Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab0FWULr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 16:11:47 -0400
Received: from 69-100-st.zelcom.ru ([80.92.100.69]:40863 "HELO
	feelingofgreen.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1750966Ab0FWULq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 16:11:46 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jun 2010 16:11:45 EDT
From: Samium Gromoff <_deepfire@feelingofgreen.ru>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] serial: MMIO32 support for 8250_early.c
Date: Wed, 23 Jun 2010 23:10:20 +0400
Message-ID: <87r5jxva3n.fsf@auriga.deep>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should be fairly uncontroversial, but YMMV.

Available from master branch at git://git.feelingofgreen.ru/linux

commit 67e21ada6739e0730fb28f855abf4202a1bb3f8c
Author: Samium Gromoff <deepfire@elvees.com>
Date:   Thu Jun 24 00:36:16 2010 +0400

    Provide MMIO32 support in 8250_early (aka earlycon)

diff --git a/drivers/serial/8250_early.c b/drivers/serial/8250_early.c
index f279745..afb6dce 100644
--- a/drivers/serial/8250_early.c
+++ b/drivers/serial/8250_early.c
@@ -48,18 +48,31 @@ static struct early_serial8250_device early_device;
 
 static unsigned int __init serial_in(struct uart_port *port, int offset)
 {
-	if (port->iotype == UPIO_MEM)
-		return readb(port->membase + offset);
-	else
-		return inb(port->iobase + offset);
+	switch (port->iotype) {
+		case UPIO_MEM:
+			return readb(port->membase + offset);
+		case UPIO_MEM32:
+			return readw(port->membase + (offset << 2));
+		case UPIO_PORT:
+			return inb(port->iobase + offset);
+		default:
+			return 0;
+	}
 }
 
 static void __init serial_out(struct uart_port *port, int offset, int value)
 {
-	if (port->iotype == UPIO_MEM)
-		writeb(value, port->membase + offset);
-	else
-		outb(value, port->iobase + offset);
+	switch (port->iotype) {
+		case UPIO_MEM:
+			writeb(value, port->membase + offset);
+			break;
+		case UPIO_MEM32:
+			writew(value, port->membase + (offset << 2));
+			break;
+		case UPIO_PORT:
+			outb(value, port->iobase + offset);
+			break;
+	}
 }
 
 #define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
@@ -137,15 +150,20 @@ static int __init parse_options(struct early_serial8250_device *device,
 								char *options)
 {
 	struct uart_port *port = &device->port;
-	int mmio, length;
+	int mmio, mmio32, length;
 
 	if (!options)
 		return -ENODEV;
 
 	port->uartclk = BASE_BAUD * 16;
-	if (!strncmp(options, "mmio,", 5)) {
-		port->iotype = UPIO_MEM;
-		port->mapbase = simple_strtoul(options + 5, &options, 0);
+
+	mmio = !strncmp(options, "mmio,", 5);
+	mmio32 = !strncmp(options, "mmio32,", 7);
+	if (mmio || mmio32) {
+		port->iotype = (mmio ? UPIO_MEM : UPIO_MEM32);
+		port->mapbase = simple_strtoul(options + (mmio ? 5 : 7), &options, 0);
+		if (mmio32)
+			port->regshift = 2;
 #ifdef CONFIG_FIX_EARLYCON_MEM
 		set_fixmap_nocache(FIX_EARLYCON_MEM_BASE,
 					port->mapbase & PAGE_MASK);
@@ -161,7 +179,6 @@ static int __init parse_options(struct early_serial8250_device *device,
 			return -ENOMEM;
 		}
 #endif
-		mmio = 1;
 	} else if (!strncmp(options, "io,", 3)) {
 		port->iotype = UPIO_PORT;
 		port->iobase = simple_strtoul(options + 3, &options, 0);
@@ -182,9 +199,9 @@ static int __init parse_options(struct early_serial8250_device *device,
 	}
 
 	printk(KERN_INFO "Early serial console at %s 0x%llx (options '%s')\n",
-		mmio ? "MMIO" : "I/O port",
-		mmio ? (unsigned long long) port->mapbase
-		     : (unsigned long long) port->iobase,
+		mmio ? "MMIO" : mmio32 ? "MMIO32" : "I/O port",
+		(mmio | mmio32) ? (unsigned long long) port->mapbase
+		                : (unsigned long long) port->iobase,
 		device->options);
 	return 0;
 }


-- 
regards,
  Samium Gromoff
--
"Actually I made up the term 'object-oriented', and I can tell you I
did not have C++ in mind." - Alan Kay (OOPSLA 1997 Keynote)
