Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2EBMqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:46:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51182 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2EBMqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:46:32 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-serial@vger.kernel.org
Cc: horms@verge.net.au, arnd@arndb.de, linux-sh@vger.kernel.org,
        gregkh@linuxfoundation.org, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl,
        paul.gortmaker@windriver.com, lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>, dan.j.williams@intel.com,
        alan@linux.intel.com
Date: Wed, 02 May 2012 21:47:18 +0900
Message-Id: <20120502124718.30480.3406.sendpatchset@w520>
In-Reply-To: <20120502124642.30480.41373.sendpatchset@w520>
References: <20120502124642.30480.41373.sendpatchset@w520>
Subject: [PATCH 04/06] serial8250: Clean up default map and dl code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Get rid of unused functions and macros now when
Alchemy and RM9K are converted over to callbacks.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/tty/serial/8250/8250.c |   38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

--- 0007/drivers/tty/serial/8250/8250.c
+++ work/drivers/tty/serial/8250/8250.c	2012-05-01 22:52:30.000000000 +0900
@@ -285,28 +285,18 @@ static const struct serial8250_config ua
 };
 
 /* Uart divisor latch read */
-static int default_dl_read(struct uart_8250_port *up)
+static int default_serial_dl_read(struct uart_8250_port *up)
 {
 	return serial_in(up, UART_DLL) | serial_in(up, UART_DLM) << 8;
 }
 
 /* Uart divisor latch write */
-static void default_dl_write(struct uart_8250_port *up, int value)
+static void default_serial_dl_write(struct uart_8250_port *up, int value)
 {
 	serial_out(up, UART_DLL, value & 0xff);
 	serial_out(up, UART_DLM, value >> 8 & 0xff);
 }
 
-static int _serial_dl_read(struct uart_8250_port *up)
-{
-	return default_dl_read(up);
-}
-
-static void _serial_dl_write(struct uart_8250_port *up, int value)
-{
-	default_dl_write(up, value);
-}
-
 #ifdef CONFIG_MIPS_ALCHEMY
 
 /* Au1x00 UART hardware has a weird register layout */
@@ -403,57 +393,53 @@ static void rm9k_serial_dl_write(struct
 
 #endif
 
-/* sane hardware needs no mapping */
-#define map_8250_in_reg(up, offset) (offset)
-#define map_8250_out_reg(up, offset) (offset)
-
 static unsigned int hub6_serial_in(struct uart_port *p, int offset)
 {
-	offset = map_8250_in_reg(p, offset) << p->regshift;
+	offset = offset << p->regshift;
 	outb(p->hub6 - 1 + offset, p->iobase);
 	return inb(p->iobase + 1);
 }
 
 static void hub6_serial_out(struct uart_port *p, int offset, int value)
 {
-	offset = map_8250_out_reg(p, offset) << p->regshift;
+	offset = offset << p->regshift;
 	outb(p->hub6 - 1 + offset, p->iobase);
 	outb(value, p->iobase + 1);
 }
 
 static unsigned int mem_serial_in(struct uart_port *p, int offset)
 {
-	offset = map_8250_in_reg(p, offset) << p->regshift;
+	offset = offset << p->regshift;
 	return readb(p->membase + offset);
 }
 
 static void mem_serial_out(struct uart_port *p, int offset, int value)
 {
-	offset = map_8250_out_reg(p, offset) << p->regshift;
+	offset = offset << p->regshift;
 	writeb(value, p->membase + offset);
 }
 
 static void mem32_serial_out(struct uart_port *p, int offset, int value)
 {
-	offset = map_8250_out_reg(p, offset) << p->regshift;
+	offset = offset << p->regshift;
 	writel(value, p->membase + offset);
 }
 
 static unsigned int mem32_serial_in(struct uart_port *p, int offset)
 {
-	offset = map_8250_in_reg(p, offset) << p->regshift;
+	offset = offset << p->regshift;
 	return readl(p->membase + offset);
 }
 
 static unsigned int io_serial_in(struct uart_port *p, int offset)
 {
-	offset = map_8250_in_reg(p, offset) << p->regshift;
+	offset = offset << p->regshift;
 	return inb(p->iobase + offset);
 }
 
 static void io_serial_out(struct uart_port *p, int offset, int value)
 {
-	offset = map_8250_out_reg(p, offset) << p->regshift;
+	offset = offset << p->regshift;
 	outb(value, p->iobase + offset);
 }
 
@@ -464,8 +450,8 @@ static void set_io_from_upio(struct uart
 	struct uart_8250_port *up =
 		container_of(p, struct uart_8250_port, port);
 
-	up->dl_read = _serial_dl_read;
-	up->dl_write = _serial_dl_write;
+	up->dl_read = default_serial_dl_read;
+	up->dl_write = default_serial_dl_write;
 
 	switch (p->iotype) {
 	case UPIO_HUB6:
