Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab1CKNFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 08:05:39 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49946 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab1CKNFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 08:05:38 -0500
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 1/3] tty: serial: Use hub6_serial_X when CONFIG_SERIAL_8250_HUB6 is defined
Date: Fri, 11 Mar 2011 21:58:10 +0900
Message-Id: <1299848292-17101-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hub6_serial_X comes to be always usable.
This revises it to be usable when CONFIG_SERIAL_8250_HUB6 is defined.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 drivers/tty/serial/8250.c        |   13 ++++++++++++-
 drivers/tty/serial/serial_core.c |    4 ++++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 3975df6..762a253 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -387,6 +387,7 @@ static inline int map_8250_out_reg(struct uart_port *p, int offset)
 
 #endif
 
+#if CONFIG_SERIAL_8250_HUB6
 static unsigned int hub6_serial_in(struct uart_port *p, int offset)
 {
 	offset = map_8250_in_reg(p, offset) << p->regshift;
@@ -400,6 +401,7 @@ static void hub6_serial_out(struct uart_port *p, int offset, int value)
 	outb(p->hub6 - 1 + offset, p->iobase);
 	outb(value, p->iobase + 1);
 }
+#endif
 
 static unsigned int mem_serial_in(struct uart_port *p, int offset)
 {
@@ -508,10 +510,12 @@ static void set_io_from_upio(struct uart_port *p)
 	struct uart_8250_port *up =
 		container_of(p, struct uart_8250_port, port);
 	switch (p->iotype) {
+#if CONFIG_SERIAL_8250_HUB6
 	case UPIO_HUB6:
 		p->serial_in = hub6_serial_in;
 		p->serial_out = hub6_serial_out;
 		break;
+#endif
 
 	case UPIO_MEM:
 		p->serial_in = mem_serial_in;
@@ -2538,8 +2542,9 @@ static int serial8250_request_std_resource(struct uart_8250_port *up)
 			}
 		}
 		break;
-
+#if CONFIG_SERIAL_8250_HUB6
 	case UPIO_HUB6:
+#endif
 	case UPIO_PORT:
 		if (!request_region(up->port.iobase, size, "serial"))
 			ret = -EBUSY;
@@ -2570,7 +2575,9 @@ static void serial8250_release_std_resource(struct uart_8250_port *up)
 		release_mem_region(up->port.mapbase, size);
 		break;
 
+#if CONFIG_SERIAL_8250_HUB6
 	case UPIO_HUB6:
+#endif
 	case UPIO_PORT:
 		release_region(up->port.iobase, size);
 		break;
@@ -2584,7 +2591,9 @@ static int serial8250_request_rsa_resource(struct uart_8250_port *up)
 	int ret = -EINVAL;
 
 	switch (up->port.iotype) {
+#if CONFIG_SERIAL_8250_HUB6
 	case UPIO_HUB6:
+#endif
 	case UPIO_PORT:
 		start += up->port.iobase;
 		if (request_region(start, size, "serial-rsa"))
@@ -2603,7 +2612,9 @@ static void serial8250_release_rsa_resource(struct uart_8250_port *up)
 	unsigned int size = 8 << up->port.regshift;
 
 	switch (up->port.iotype) {
+#if CONFIG_SERIAL_8250_HUB6
 	case UPIO_HUB6:
+#endif
 	case UPIO_PORT:
 		release_region(up->port.iobase + offset, size);
 		break;
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 460a72d..c533524 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2129,10 +2129,12 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 	case UPIO_PORT:
 		snprintf(address, sizeof(address), "I/O 0x%lx", port->iobase);
 		break;
+#if CONFIG_SERIAL_8250_HUB6
 	case UPIO_HUB6:
 		snprintf(address, sizeof(address),
 			 "I/O 0x%lx offset 0x%x", port->iobase, port->hub6);
 		break;
+#endif
 	case UPIO_MEM:
 	case UPIO_MEM32:
 	case UPIO_AU:
@@ -2551,9 +2553,11 @@ int uart_match_port(struct uart_port *port1, struct uart_port *port2)
 	switch (port1->iotype) {
 	case UPIO_PORT:
 		return (port1->iobase == port2->iobase);
+#if CONFIG_SERIAL_8250_HUB6
 	case UPIO_HUB6:
 		return (port1->iobase == port2->iobase) &&
 		       (port1->hub6   == port2->hub6);
+#endif
 	case UPIO_MEM:
 	case UPIO_MEM32:
 	case UPIO_AU:
-- 
1.7.2.3

