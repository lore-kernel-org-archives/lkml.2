Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab1CKNFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 08:05:44 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36194 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab1CKNFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 08:05:41 -0500
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 2/3] tty: serial: Fix build on architecture that does not have ioport
Date: Fri, 11 Mar 2011 21:58:11 +0900
Message-Id: <1299848292-17101-2-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299848292-17101-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
References: <1299848292-17101-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some CPU's do not have ioport. Therefore, these do not have inX/outX.

This adds CONFIG_SERIAL_8250_IOPORT. When this is enable, 8250 driver
provides ioports access. And this is not enable with the CPU without
ioports.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 drivers/tty/serial/8250.c        |   56 ++++++++++++++++---------------------
 drivers/tty/serial/8250_early.c  |    4 +++
 drivers/tty/serial/Kconfig       |   10 +++++++
 drivers/tty/serial/serial_core.c |    4 +++
 4 files changed, 42 insertions(+), 32 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 762a253..837bb39 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -387,7 +387,7 @@ static inline int map_8250_out_reg(struct uart_port *p, int offset)
 
 #endif
 
-#if CONFIG_SERIAL_8250_HUB6
+#ifdef CONFIG_SERIAL_8250_HUB6
 static unsigned int hub6_serial_in(struct uart_port *p, int offset)
 {
 	offset = map_8250_in_reg(p, offset) << p->regshift;
@@ -492,7 +492,7 @@ static void dwapb32_serial_out(struct uart_port *p, int offset, int value)
 	writel(value, p->membase + offset);
 	dwapb_check_clear_ier(p, save_offset);
 }
-
+#ifdef CONFIG_SERIAL_8250_IOPORT
 static unsigned int io_serial_in(struct uart_port *p, int offset)
 {
 	offset = map_8250_in_reg(p, offset) << p->regshift;
@@ -504,13 +504,14 @@ static void io_serial_out(struct uart_port *p, int offset, int value)
 	offset = map_8250_out_reg(p, offset) << p->regshift;
 	outb(value, p->iobase + offset);
 }
+#endif
 
 static void set_io_from_upio(struct uart_port *p)
 {
 	struct uart_8250_port *up =
 		container_of(p, struct uart_8250_port, port);
 	switch (p->iotype) {
-#if CONFIG_SERIAL_8250_HUB6
+#ifdef CONFIG_SERIAL_8250_HUB6
 	case UPIO_HUB6:
 		p->serial_in = hub6_serial_in;
 		p->serial_out = hub6_serial_out;
@@ -549,8 +550,10 @@ static void set_io_from_upio(struct uart_port *p)
 		break;
 
 	default:
+#ifdef CONFIG_SERIAL_8250_IOPORT
 		p->serial_in = io_serial_in;
 		p->serial_out = io_serial_out;
+#endif
 		break;
 	}
 	/* Remember loaded iotype */
@@ -2542,12 +2545,11 @@ static int serial8250_request_std_resource(struct uart_8250_port *up)
 			}
 		}
 		break;
-#if CONFIG_SERIAL_8250_HUB6
-	case UPIO_HUB6:
-#endif
-	case UPIO_PORT:
+	default: /* UPIO_HUB6 or UPIO_PORT */
+#if defined(CONFIG_SERIAL_8250_HUB6) || defined(CONFIG_SERIAL_8250_IOPORT)
 		if (!request_region(up->port.iobase, size, "serial"))
 			ret = -EBUSY;
+#endif
 		break;
 	}
 	return ret;
@@ -2575,50 +2577,40 @@ static void serial8250_release_std_resource(struct uart_8250_port *up)
 		release_mem_region(up->port.mapbase, size);
 		break;
 
-#if CONFIG_SERIAL_8250_HUB6
-	case UPIO_HUB6:
-#endif
-	case UPIO_PORT:
+	default: /* UPIO_HUB6 or UPIO_PORT */
+#if defined(CONFIG_SERIAL_8250_HUB6) || defined(CONFIG_SERIAL_8250_IOPORT)
 		release_region(up->port.iobase, size);
+#endif
 		break;
 	}
 }
 
 static int serial8250_request_rsa_resource(struct uart_8250_port *up)
 {
+	int ret = -EINVAL;
+
+#if defined(CONFIG_SERIAL_8250_HUB6) || defined(CONFIG_SERIAL_8250_IOPORT)
 	unsigned long start = UART_RSA_BASE << up->port.regshift;
 	unsigned int size = 8 << up->port.regshift;
-	int ret = -EINVAL;
 
-	switch (up->port.iotype) {
-#if CONFIG_SERIAL_8250_HUB6
-	case UPIO_HUB6:
+	/* up->port.iotype are UPIO_HUB6 or UPIO_PORT */
+	start += up->port.iobase;
+	if (request_region(start, size, "serial-rsa"))
+		ret = 0;
+	else
+		ret = -EBUSY;
 #endif
-	case UPIO_PORT:
-		start += up->port.iobase;
-		if (request_region(start, size, "serial-rsa"))
-			ret = 0;
-		else
-			ret = -EBUSY;
-		break;
-	}
-
 	return ret;
 }
 
 static void serial8250_release_rsa_resource(struct uart_8250_port *up)
 {
+#if defined(CONFIG_SERIAL_8250_HUB6) || defined(CONFIG_SERIAL_8250_IOPORT)
 	unsigned long offset = UART_RSA_BASE << up->port.regshift;
 	unsigned int size = 8 << up->port.regshift;
-
-	switch (up->port.iotype) {
-#if CONFIG_SERIAL_8250_HUB6
-	case UPIO_HUB6:
+	/* up->port.iotype are UPIO_HUB6 or UPIO_PORT */
+	release_region(up->port.iobase + offset, size);
 #endif
-	case UPIO_PORT:
-		release_region(up->port.iobase + offset, size);
-		break;
-	}
 }
 
 static void serial8250_release_port(struct uart_port *port)
diff --git a/drivers/tty/serial/8250_early.c b/drivers/tty/serial/8250_early.c
index eaafb98..6eae7a3 100644
--- a/drivers/tty/serial/8250_early.c
+++ b/drivers/tty/serial/8250_early.c
@@ -55,8 +55,10 @@ static unsigned int __init serial_in(struct uart_port *port, int offset)
 		return readb(port->membase + offset);
 	case UPIO_MEM32:
 		return readl(port->membase + (offset << 2));
+#if CONFIG_SERIAL_8250_IOPORT
 	case UPIO_PORT:
 		return inb(port->iobase + offset);
+#endif
 	default:
 		return 0;
 	}
@@ -71,9 +73,11 @@ static void __init serial_out(struct uart_port *port, int offset, int value)
 	case UPIO_MEM32:
 		writel(value, port->membase + (offset << 2));
 		break;
+#if CONFIG_SERIAL_8250_IOPORT
 	case UPIO_PORT:
 		outb(value, port->iobase + offset);
 		break;
+#endif
 	}
 }
 
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 2b83346..6fd5825 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -116,6 +116,16 @@ config SERIAL_8250_CS
 
 	  If unsure, say N.
 
+config CONFIG_SERIAL_8250_IOPORT
+	bool "8250/16550 serial IOports access support"
+	depends on SERIAL_8250 && NO_IOPORT != y
+	default SERIAL_8250
+	help
+	  Say Y here to enable support for serial ioport access.
+	  If there is not ioport, cannot be enable this.
+
+	  If unsure, say N.
+
 config SERIAL_8250_NR_UARTS
 	int "Maximum number of 8250/16550 serial ports"
 	depends on SERIAL_8250
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index c533524..ad5b215 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2126,9 +2126,11 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 	char address[64];
 
 	switch (port->iotype) {
+#if CONFIG_SERIAL_8250_IOPORT
 	case UPIO_PORT:
 		snprintf(address, sizeof(address), "I/O 0x%lx", port->iobase);
 		break;
+#endif
 #if CONFIG_SERIAL_8250_HUB6
 	case UPIO_HUB6:
 		snprintf(address, sizeof(address),
@@ -2551,8 +2553,10 @@ int uart_match_port(struct uart_port *port1, struct uart_port *port2)
 		return 0;
 
 	switch (port1->iotype) {
+#if CONFIG_SERIAL_8250_IOPORT
 	case UPIO_PORT:
 		return (port1->iobase == port2->iobase);
+#endif
 #if CONFIG_SERIAL_8250_HUB6
 	case UPIO_HUB6:
 		return (port1->iobase == port2->iobase) &&
-- 
1.7.2.3

