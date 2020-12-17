//
//  main.swift
//  FactoryMethod
//
//  Created by Роман Лабунский on 25.11.2020.
//

import Foundation

// MARK: - Фабричный метод
protocol Creator {

    // метода по умолчанию.
    func factoryMethod() -> Product
    func someOperation() -> String
}

// Это расширение реализует базовое поведение Создателя.
extension Creator {

    func someOperation() -> String {
        // Вызываем фабричный метод, чтобы получить объект-продукт.
        let product = factoryMethod()

        // Работаем с этим продуктом.
        return "Создатель: Тот же самый код создателя только что работал с " + product.operation()
    }
}

class Microsoft: Creator {
    
    public func factoryMethod() -> Product {
        return Windows()
    }
}

class Apple : Creator {

    public func factoryMethod() -> Product {
        return MacOS()
    }
}

// Протокол Продукта, должен выполнять все конкретные продукты.
protocol Product {

    func operation() -> String
}

// Конкретные Продукты предоставляют различные реализации протокола Продукта.
class Windows: Product {

    func operation() -> String {
        return "{Результат Windows}"
    }
}

class MacOS: Product {

    func operation() -> String {
        return "{Результат MacOS}"
    }
}


// Клиентский код работает с экземпляром конкретного создателя
class Client {
    static func someClientCode(creator: Creator) {
        print("Клиент: Я не знаю о классе создателя, но он все еще работает.\n"
            + creator.someOperation())
    }
}

class FactoryMethodConceptual {

    func testFactoryMethodConceptual() {
        
        print("App: Запущенный с Microsoft.")
        Client.someClientCode(creator: Microsoft())

        print("\nApp: Запущенный с Apple.")
        Client.someClientCode(creator: Apple())
    }
}

// MARK: - Абстрактная фабрика


protocol AbstractFactory {

    func createProductA() -> AbstractProductA
    func createProductB() -> AbstractProductB
}

class ConcreteFactory1: AbstractFactory {

    func createProductA() -> AbstractProductA {
        return ConcreteProductA1()
    }

    func createProductB() -> AbstractProductB {
        return ConcreteProductB1()
    }
}

// Интерфейс
protocol AbstractProductA {

    func usefulFunctionA() -> String
}

// создаются соответствующими конкретными фабриками.
class ConcreteProductA1: AbstractProductA {

    func usefulFunctionA() -> String {
        return "Результат продукта A1."
    }
}

class ConcreteProductA2: AbstractProductA {

    func usefulFunctionA() -> String {
        return "Результат продукта A2."
    }
}

protocol AbstractProductB {
    func usefulFunctionB() -> String
    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String
}

// Конкретные Продукты создаются соответствующими Конкретными Фабриками.
class ConcreteProductB1: AbstractProductB {

    func usefulFunctionB() -> String {
        return "Результат продукта B1."
    }

    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String {
        let result = collaborator.usefulFunctionA()
        return "Результат сотрудничества В1 с (\(result))"
    }
}

class ConcreteProductB2: AbstractProductB {

    func usefulFunctionB() -> String {
        return "Результат продукта B2."
    }

    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String {
        let result = collaborator.usefulFunctionA()
        return "Результат сотрудничества В2 с (\(result))"
    }
}

class Client {

    static func someClientCode(factory: AbstractFactory) {
        let productA = factory.createProductA()
        let productB = factory.createProductB()

        print(productB.usefulFunctionB())
        print(productB.anotherUsefulFunctionB(collaborator: productA))
    }
}

class AbstractFactoryConceptual {

    func testAbstractFactoryConceptual() {
        
        print("Client: Тестирование кода клиента с первым заводским типом:")
        Client.someClientCode(factory: ConcreteFactory1())
    }
}


// MARK: - Строитель

protocol Builder {

    func producePartA()
    func producePartB()
    func producePartC()
}

class ConcreteBuilder1: Builder {

    private var product = Product1()

    func reset() {
        product = Product1()
    }

    func producePartA() {
        product.add(part: "PartA1")
    }

    func producePartB() {
        product.add(part: "PartB1")
    }

    func producePartC() {
        product.add(part: "PartC1")
    }

    func retrieveProduct() -> Product1 {
        let result = self.product
        reset()
        return result
    }
}

class Director {

    private var builder: Builder?

    func update(builder: Builder) {
        self.builder = builder
    }

    func buildMinimalViableProduct() {
        builder?.producePartA()
    }

    func buildFullFeaturedProduct() {
        builder?.producePartA()
        builder?.producePartB()
        builder?.producePartC()
    }
}

class Product1 {

    private var parts = [String]()

    func add(part: String) {
        self.parts.append(part)
    }

    func listParts() -> String {
        return "Product parts: " + parts.joined(separator: ", ") + "\n"
    }
}

class Client {

    static func someClientCode(director: Director) {
        let builder = ConcreteBuilder1()
        director.update(builder: builder)
        
        print("Standard basic product:")
        director.buildMinimalViableProduct()
        print(builder.retrieveProduct().listParts())

        print("Standard full featured product:")
        director.buildFullFeaturedProduct()
        print(builder.retrieveProduct().listParts())

        print("Custom product:")
        builder.producePartA()
        builder.producePartC()
        print(builder.retrieveProduct().listParts())
    }
}

/// Давайте посмотрим как всё это будет работать.
class BuilderConceptual {

    func testBuilderConceptual() {
        let director = Director()
        Client.someClientCode(creator: director as! Creator)
    }
}

// MARK: - Посетитель

// объявляет метод принятия, который в качестве аргумента может получать любой объект
protocol Component {

    func accept(_ visitor: Visitor)
}

// вызывает метод посетителя, соотвествующий классу компонента.
class ConcreteComponentA: Component {
    
    func accept(_ visitor: Visitor) {
        visitor.visitConcreteComponentA(element: self)
    }

    func exclusiveMethodOfConcreteComponentA() -> String {
        return "A"
    }
}

class ConcreteComponentB: Component {

    // visitConcreteComponentB => ConcreteComponentB
    func accept(_ visitor: Visitor) {
        visitor.visitConcreteComponentB(element: self)
    }

    func specialMethodOfConcreteComponentB() -> String {
        return "B"
    }
}

protocol Visitor {

    func visitConcreteComponentA(element: ConcreteComponentA)
    func visitConcreteComponentB(element: ConcreteComponentB)
}

class ConcreteVisitor1: Visitor {

    func visitConcreteComponentA(element: ConcreteComponentA) {
        print(element.exclusiveMethodOfConcreteComponentA() + " + ConcreteVisitor1\n")
    }

    func visitConcreteComponentB(element: ConcreteComponentB) {
        print(element.specialMethodOfConcreteComponentB() + " + ConcreteVisitor1\n")
    }
}

class ConcreteVisitor2: Visitor {

    func visitConcreteComponentA(element: ConcreteComponentA) {
        print(element.exclusiveMethodOfConcreteComponentA() + " + ConcreteVisitor2\n")
    }

    func visitConcreteComponentB(element: ConcreteComponentB) {
        print(element.specialMethodOfConcreteComponentB() + " + ConcreteVisitor2\n")
    }
}

class Client {
    
    static func clientCode(components: [Component], visitor: Visitor) {

        components.forEach({ $0.accept(visitor) })
        
    }

}

class VisitorConceptual {

    func test() {
        let components: [Component] = [ConcreteComponentA(), ConcreteComponentB()]

        print("The client code works with all visitors via the base Visitor interface:\n")
        let visitor1 = ConcreteVisitor1()
        Client.clientCode(components: components, visitor: visitor1)

        print("\nIt allows the same client code to work with different types of visitors:\n")
        let visitor2 = ConcreteVisitor2()
        Client.clientCode(components: components, visitor: visitor2)
    }
}


// MARK: - Команда

// Интерфейс
protocol Command {

    func execute()
}

// Некоторые команды способны выполнять простые операции самостоятельно.
class SimpleCommand: Command {

    private var payload: String

    init(_ payload: String) {
        self.payload = payload
    }

    func execute() {
        print("SimpleCommand: See, I can do simple things like printing (" + payload + ")")
    }
}

// команды которые делегируют более сложные операции другим
class ComplexCommand: Command {

    private var receiver: Receiver

    private var a: String
    private var b: String


    init(_ receiver: Receiver, _ a: String, _ b: String) {
        self.receiver = receiver
        self.a = a
        self.b = b
    }

    func execute() {
        print("ComplexCommand: Complex stuff should be done by a receiver object.\n")
        receiver.doSomething(a)
        receiver.doSomethingElse(b)
    }
}

// выполняет все виды операций связанных с выполнением запроса
class Receiver {

    func doSomething(_ a: String) {
        print("Receiver: Working on (" + a + ")\n")
    }

    func doSomethingElse(_ b: String) {
        print("Receiver: Also working on (" + b + ")\n")
    }
}

// Отпрвитель
class Invoker {

    private var onStart: Command?

    private var onFinish: Command?

    // Инициализация команд.
    func setOnStart(_ command: Command) {
        onStart = command
    }

    func setOnFinish(_ command: Command) {
        onFinish = command
    }

    func doSomethingImportant() {

        print("Invoker: Does anybody want something done before I begin?")

        onStart?.execute()

        print("Invoker: ...doing something really important...")
        print("Invoker: Does anybody want something done after I finish?")

        onFinish?.execute()
    }
}

class CommandConceptual {

    func test() {
        /// Клиентский код может параметризовать отправителя любыми командами.

        let invoker = Invoker()
        invoker.setOnStart(SimpleCommand("Say Hi!"))

        let receiver = Receiver()
        invoker.setOnFinish(ComplexCommand(receiver, "Send email", "Save report"))
        invoker.doSomethingImportant()
    }
}


