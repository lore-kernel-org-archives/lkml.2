Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab2EBMqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:46:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51182 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2EBMql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:46:41 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-serial@vger.kernel.org
Cc: arnd@arndb.de, swarren@wwwdotorg.org, lethal@linux-sh.org,
        gregkh@linuxfoundation.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl,
        paul.gortmaker@windriver.com, horms@verge.net.au, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>, dan.j.williams@intel.com,
        alan@linux.intel.com
Date: Wed, 02 May 2012 21:47:27 +0900
Message-Id: <20120502124727.30480.66237.sendpatchset@w520>
In-Reply-To: <20120502124642.30480.41373.sendpatchset@w520>
References: <20120502124642.30480.41373.sendpatchset@w520>
Subject: [PATCH 05/06] serial8250: Introduce serial8250_register_8250_port()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Introduce yet another 8250 registration function.
This time it is serial8250_register_8250_port() and it
allows us to register 8250 hardware instances using struct 
uart_8250_port. The new function makes it possible to
register 8250 hardware that makes use of 8250 specific
callbacks such as ->dl_read() and ->dl_write().

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/tty/serial/8250/8250.c |   89 ++++++++++++++++++++++++++--------------
 include/linux/serial_8250.h    |    1 

--- 0005/drivers/tty/serial/8250/8250.c
+++ work/drivers/tty/serial/8250/8250.c	2012-05-02 20:51:44.000000000 +0900
@@ -3111,7 +3111,7 @@ static struct uart_8250_port *serial8250
 }
 
 /**
- *	serial8250_register_port - register a serial port
+ *	serial8250_register_8250_port - register a serial port
  *	@port: serial port template
  *
  *	Configure the serial port specified by the request. If the
@@ -3123,52 +3123,56 @@ static struct uart_8250_port *serial8250
  *
  *	On success the port is ready to use and the line number is returned.
  */
-int serial8250_register_port(struct uart_port *port)
+int serial8250_register_8250_port(struct uart_8250_port *up)
 {
 	struct uart_8250_port *uart;
 	int ret = -ENOSPC;
 
-	if (port->uartclk == 0)
+	if (up->port.uartclk == 0)
 		return -EINVAL;
 
 	mutex_lock(&serial_mutex);
 
-	uart = serial8250_find_match_or_unused(port);
+	uart = serial8250_find_match_or_unused(&up->port);
 	if (uart) {
 		uart_remove_one_port(&serial8250_reg, &uart->port);
 
-		uart->port.iobase       = port->iobase;
-		uart->port.membase      = port->membase;
-		uart->port.irq          = port->irq;
-		uart->port.irqflags     = port->irqflags;
-		uart->port.uartclk      = port->uartclk;
-		uart->port.fifosize     = port->fifosize;
-		uart->port.regshift     = port->regshift;
-		uart->port.iotype       = port->iotype;
-		uart->port.flags        = port->flags | UPF_BOOT_AUTOCONF;
-		uart->port.mapbase      = port->mapbase;
-		uart->port.private_data = port->private_data;
-		if (port->dev)
-			uart->port.dev = port->dev;
+		uart->port.iobase       = up->port.iobase;
+		uart->port.membase      = up->port.membase;
+		uart->port.irq          = up->port.irq;
+		uart->port.irqflags     = up->port.irqflags;
+		uart->port.uartclk      = up->port.uartclk;
+		uart->port.fifosize     = up->port.fifosize;
+		uart->port.regshift     = up->port.regshift;
+		uart->port.iotype       = up->port.iotype;
+		uart->port.flags        = up->port.flags | UPF_BOOT_AUTOCONF;
+		uart->port.mapbase      = up->port.mapbase;
+		uart->port.private_data = up->port.private_data;
+		if (up->port.dev)
+			uart->port.dev = up->port.dev;
 
-		if (port->flags & UPF_FIXED_TYPE)
-			serial8250_init_fixed_type_port(uart, port->type);
+		if (up->port.flags & UPF_FIXED_TYPE)
+			serial8250_init_fixed_type_port(uart, up->port.type);
 
 		set_io_from_upio(&uart->port);
 		/* Possibly override default I/O functions.  */
-		if (port->serial_in)
-			uart->port.serial_in = port->serial_in;
-		if (port->serial_out)
-			uart->port.serial_out = port->serial_out;
-		if (port->handle_irq)
-			uart->port.handle_irq = port->handle_irq;
+		if (up->port.serial_in)
+			uart->port.serial_in = up->port.serial_in;
+		if (up->port.serial_out)
+			uart->port.serial_out = up->port.serial_out;
+		if (up->port.handle_irq)
+			uart->port.handle_irq = up->port.handle_irq;
 		/*  Possibly override set_termios call */
-		if (port->set_termios)
-			uart->port.set_termios = port->set_termios;
-		if (port->pm)
-			uart->port.pm = port->pm;
-		if (port->handle_break)
-			uart->port.handle_break = port->handle_break;
+		if (up->port.set_termios)
+			uart->port.set_termios = up->port.set_termios;
+		if (up->port.pm)
+			uart->port.pm = up->port.pm;
+		if (up->port.handle_break)
+			uart->port.handle_break = up->port.handle_break;
+		if (up->dl_read)
+			uart->dl_read = up->dl_read;
+		if (up->dl_write)
+			uart->dl_write = up->dl_write;
 
 		if (serial8250_isa_config != NULL)
 			serial8250_isa_config(0, &uart->port,
@@ -3182,6 +3186,29 @@ int serial8250_register_port(struct uart
 
 	return ret;
 }
+EXPORT_SYMBOL(serial8250_register_8250_port);
+
+/**
+ *	serial8250_register_port - register a serial port
+ *	@port: serial port template
+ *
+ *	Configure the serial port specified by the request. If the
+ *	port exists and is in use, it is hung up and unregistered
+ *	first.
+ *
+ *	The port is then probed and if necessary the IRQ is autodetected
+ *	If this fails an error is returned.
+ *
+ *	On success the port is ready to use and the line number is returned.
+ */
+int serial8250_register_port(struct uart_port *port)
+{
+	struct uart_8250_port up;
+
+	memset(&up, 0, sizeof(up));
+	memcpy(&up.port, port, sizeof(*port));
+	return serial8250_register_8250_port(&up);
+}
 EXPORT_SYMBOL(serial8250_register_port);
 
 /**
--- 0001/include/linux/serial_8250.h
+++ work/include/linux/serial_8250.h	2012-05-02 20:47:21.000000000 +0900
@@ -69,6 +69,7 @@ enum {
 struct uart_port;
 struct uart_8250_port;
 
+int serial8250_register_8250_port(struct uart_8250_port *);
 int serial8250_register_port(struct uart_port *);
 void serial8250_unregister_port(int line);
 void serial8250_suspend_port(int line);
