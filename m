Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab1CKGC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 01:02:27 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50787 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab1CKGCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 01:02:24 -0500
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 1/2] tty: serial: Fix build on architecture that does not have ioport
Date: Fri, 11 Mar 2011 14:54:56 +0900
Message-Id: <1299822897-7047-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some CPU's do not have ioport. Therefore, these do not have inX/outX.
Because they define CONFIG_NO_IOPORT, These CPU's use this and do not
use inX/outX.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 drivers/tty/serial/8250.c        |   18 ++++++++++++++++--
 drivers/tty/serial/8250_early.c  |    4 ++++
 drivers/tty/serial/serial_core.c |    4 ++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 3975df6..5c1f353 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -387,6 +387,7 @@ static inline int map_8250_out_reg(struct uart_port *p, int offset)
 
 #endif
 
+#ifndef CONFIG_NO_IOPORT
 static unsigned int hub6_serial_in(struct uart_port *p, int offset)
 {
 	offset = map_8250_in_reg(p, offset) << p->regshift;
@@ -400,6 +401,7 @@ static void hub6_serial_out(struct uart_port *p, int offset, int value)
 	outb(p->hub6 - 1 + offset, p->iobase);
 	outb(value, p->iobase + 1);
 }
+#endif /* CONFIG_NO_IOPORT */
 
 static unsigned int mem_serial_in(struct uart_port *p, int offset)
 {
@@ -491,6 +493,7 @@ static void dwapb32_serial_out(struct uart_port *p, int offset, int value)
 	dwapb_check_clear_ier(p, save_offset);
 }
 
+#ifndef CONFIG_NO_IOPORT
 static unsigned int io_serial_in(struct uart_port *p, int offset)
 {
 	offset = map_8250_in_reg(p, offset) << p->regshift;
@@ -502,17 +505,19 @@ static void io_serial_out(struct uart_port *p, int offset, int value)
 	offset = map_8250_out_reg(p, offset) << p->regshift;
 	outb(value, p->iobase + offset);
 }
+#endif
 
 static void set_io_from_upio(struct uart_port *p)
 {
 	struct uart_8250_port *up =
 		container_of(p, struct uart_8250_port, port);
 	switch (p->iotype) {
+#ifndef CONFIG_NO_IOPORT
 	case UPIO_HUB6:
 		p->serial_in = hub6_serial_in;
 		p->serial_out = hub6_serial_out;
 		break;
-
+#endif
 	case UPIO_MEM:
 		p->serial_in = mem_serial_in;
 		p->serial_out = mem_serial_out;
@@ -545,8 +550,10 @@ static void set_io_from_upio(struct uart_port *p)
 		break;
 
 	default:
+#ifndef CONFIG_NO_IOPORT
 		p->serial_in = io_serial_in;
 		p->serial_out = io_serial_out;
+#endif
 		break;
 	}
 	/* Remember loaded iotype */
@@ -2539,11 +2546,13 @@ static int serial8250_request_std_resource(struct uart_8250_port *up)
 		}
 		break;
 
+#ifndef CONFIG_NO_IOPORT
 	case UPIO_HUB6:
 	case UPIO_PORT:
 		if (!request_region(up->port.iobase, size, "serial"))
 			ret = -EBUSY;
 		break;
+#endif
 	}
 	return ret;
 }
@@ -2570,10 +2579,12 @@ static void serial8250_release_std_resource(struct uart_8250_port *up)
 		release_mem_region(up->port.mapbase, size);
 		break;
 
+#ifndef CONFIG_NO_IOPORT
 	case UPIO_HUB6:
 	case UPIO_PORT:
 		release_region(up->port.iobase, size);
 		break;
+#endif
 	}
 }
 
@@ -2584,6 +2595,7 @@ static int serial8250_request_rsa_resource(struct uart_8250_port *up)
 	int ret = -EINVAL;
 
 	switch (up->port.iotype) {
+#ifndef CONFIG_NO_IOPORT
 	case UPIO_HUB6:
 	case UPIO_PORT:
 		start += up->port.iobase;
@@ -2593,7 +2605,7 @@ static int serial8250_request_rsa_resource(struct uart_8250_port *up)
 			ret = -EBUSY;
 		break;
 	}
-
+#endif
 	return ret;
 }
 
@@ -2603,11 +2615,13 @@ static void serial8250_release_rsa_resource(struct uart_8250_port *up)
 	unsigned int size = 8 << up->port.regshift;
 
 	switch (up->port.iotype) {
+#ifndef CONFIG_NO_IOPORT
 	case UPIO_HUB6:
 	case UPIO_PORT:
 		release_region(up->port.iobase + offset, size);
 		break;
 	}
+#endif
 }
 
 static void serial8250_release_port(struct uart_port *port)
diff --git a/drivers/tty/serial/8250_early.c b/drivers/tty/serial/8250_early.c
index eaafb98..5169f9e 100644
--- a/drivers/tty/serial/8250_early.c
+++ b/drivers/tty/serial/8250_early.c
@@ -55,8 +55,10 @@ static unsigned int __init serial_in(struct uart_port *port, int offset)
 		return readb(port->membase + offset);
 	case UPIO_MEM32:
 		return readl(port->membase + (offset << 2));
+#if defined(CONFIG_NO_IOPORT)
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
+#if defined(CONFIG_NO_IOPORT)
 	case UPIO_PORT:
 		outb(value, port->iobase + offset);
 		break;
+#endif
 	}
 }
 
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 460a72d..eb7ceba 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2126,6 +2126,7 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 	char address[64];
 
 	switch (port->iotype) {
+#ifndef CONFIG_NO_IOPORT
 	case UPIO_PORT:
 		snprintf(address, sizeof(address), "I/O 0x%lx", port->iobase);
 		break;
@@ -2133,6 +2134,7 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 		snprintf(address, sizeof(address),
 			 "I/O 0x%lx offset 0x%x", port->iobase, port->hub6);
 		break;
+#endif
 	case UPIO_MEM:
 	case UPIO_MEM32:
 	case UPIO_AU:
@@ -2549,11 +2551,13 @@ int uart_match_port(struct uart_port *port1, struct uart_port *port2)
 		return 0;
 
 	switch (port1->iotype) {
+#ifndef CONFIG_NO_IOPORT
 	case UPIO_PORT:
 		return (port1->iobase == port2->iobase);
 	case UPIO_HUB6:
 		return (port1->iobase == port2->iobase) &&
 		       (port1->hub6   == port2->hub6);
+#endif
 	case UPIO_MEM:
 	case UPIO_MEM32:
 	case UPIO_AU:
-- 
1.7.2.3

