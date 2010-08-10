Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab0HJWBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:01:08 -0400
Received: from kroah.org ([198.145.64.141]:45032 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933470Ab0HJWAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:00:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Samium Gromoff <_deepfire@feelingofgreen.ru>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 56/68] serial: MMIO32 support for 8250_early.c
Date: Tue, 10 Aug 2010 14:59:18 -0700
Message-Id: <1281477570-18944-56-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samium Gromoff <_deepfire@feelingofgreen.ru>

Provide MMIO32 support in 8250_early (aka earlycon)

[randy.dunlap@oracle.com: fix printk format warnings]
[akpm@linux-foundation.org: fix printk args some more]
Signed-off-by: Samium Gromoff <_deepfire@feelingofgreen.ru>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/kernel-parameters.txt |    3 ++
 drivers/serial/8250_early.c         |   57 +++++++++++++++++++++++++---------
 2 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 44f6b19..d529b13 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -681,8 +681,11 @@ and is between 256 and 4096 characters. It is defined in the file
 	earlycon=	[KNL] Output early console device and options.
 		uart[8250],io,<addr>[,options]
 		uart[8250],mmio,<addr>[,options]
+		uart[8250],mmio32,<addr>[,options]
 			Start an early, polled-mode console on the 8250/16550
 			UART at the specified I/O port or MMIO address.
+			MMIO inter-register address stride is either 8bit (mmio)
+                        or 32bit (mmio32).
 			The options are the same as for ttyS, above.
 
 	earlyprintk=	[X86,SH,BLACKFIN]
diff --git a/drivers/serial/8250_early.c b/drivers/serial/8250_early.c
index f279745..b745792 100644
--- a/drivers/serial/8250_early.c
+++ b/drivers/serial/8250_early.c
@@ -19,9 +19,11 @@
  * The user can specify the device directly, e.g.,
  *	earlycon=uart8250,io,0x3f8,9600n8
  *	earlycon=uart8250,mmio,0xff5e0000,115200n8
+ *	earlycon=uart8250,mmio32,0xff5e0000,115200n8
  * or
  *	console=uart8250,io,0x3f8,9600n8
  *	console=uart8250,mmio,0xff5e0000,115200n8
+ *	console=uart8250,mmio32,0xff5e0000,115200n8
  */
 
 #include <linux/tty.h>
@@ -48,18 +50,31 @@ static struct early_serial8250_device early_device;
 
 static unsigned int __init serial_in(struct uart_port *port, int offset)
 {
-	if (port->iotype == UPIO_MEM)
+	switch (port->iotype) {
+	case UPIO_MEM:
 		return readb(port->membase + offset);
-	else
+	case UPIO_MEM32:
+		return readl(port->membase + (offset << 2));
+	case UPIO_PORT:
 		return inb(port->iobase + offset);
+	default:
+		return 0;
+	}
 }
 
 static void __init serial_out(struct uart_port *port, int offset, int value)
 {
-	if (port->iotype == UPIO_MEM)
+	switch (port->iotype) {
+	case UPIO_MEM:
 		writeb(value, port->membase + offset);
-	else
+		break;
+	case UPIO_MEM32:
+		writel(value, port->membase + (offset << 2));
+		break;
+	case UPIO_PORT:
 		outb(value, port->iobase + offset);
+		break;
+	}
 }
 
 #define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
@@ -137,15 +152,21 @@ static int __init parse_options(struct early_serial8250_device *device,
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
+		port->mapbase = simple_strtoul(options + (mmio ? 5 : 7),
+					       &options, 0);
+		if (mmio32)
+			port->regshift = 2;
 #ifdef CONFIG_FIX_EARLYCON_MEM
 		set_fixmap_nocache(FIX_EARLYCON_MEM_BASE,
 					port->mapbase & PAGE_MASK);
@@ -157,11 +178,10 @@ static int __init parse_options(struct early_serial8250_device *device,
 		if (!port->membase) {
 			printk(KERN_ERR "%s: Couldn't ioremap 0x%llx\n",
 				__func__,
-			       (unsigned long long)port->mapbase);
+			       (unsigned long long) port->mapbase);
 			return -ENOMEM;
 		}
 #endif
-		mmio = 1;
 	} else if (!strncmp(options, "io,", 3)) {
 		port->iotype = UPIO_PORT;
 		port->iobase = simple_strtoul(options + 3, &options, 0);
@@ -181,11 +201,18 @@ static int __init parse_options(struct early_serial8250_device *device,
 			device->baud);
 	}
 
-	printk(KERN_INFO "Early serial console at %s 0x%llx (options '%s')\n",
-		mmio ? "MMIO" : "I/O port",
-		mmio ? (unsigned long long) port->mapbase
-		     : (unsigned long long) port->iobase,
-		device->options);
+	if (mmio || mmio32)
+		printk(KERN_INFO
+		       "Early serial console at MMIO%s 0x%llu (options '%s')\n",
+			mmio32 ? "32" : "",
+			(unsigned long long)port->mapbase,
+			device->options);
+	else
+		printk(KERN_INFO
+		      "Early serial console at I/O port 0x%lu (options '%s')\n",
+			port->iobase,
+			device->options);
+
 	return 0;
 }
 
-- 
1.7.2

