// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'dart:convert';

import 'package:api_integation_four/product_model.dart';
import 'package:api_integation_four/single_product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> products = [];
  Future<List<ProductModel>> getProduct() async {
    var response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (var i in data) {
        products.add(ProductModel.fromJson(i));
        print(products.length);
      }
      return products;
    } else {
      return products;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ProductModel> product = [];
    String productName;
    String productImage;
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Product list'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 190,
              child: FutureBuilder(
                future: getProduct(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ProductModel>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Container(
                              // color: Colors.lightBlue,
                              width: 150,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      height: 100,
                                      child: Image.network(
                                        '${snapshot.data![index].image}',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      height: 15,
                                      child: Text(
                                          '${snapshot.data![index].title}'),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'TK ${snapshot.data![index].price}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        ConstrainedBox(
                                          constraints:
                                              BoxConstraints(maxHeight: 25),
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            child: Text('Buy'),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
