Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab1F0Vro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 17:47:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58521 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab1F0VqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:46:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-serial@vger.kernel.org
Subject: [PATCH 7/7] serial/8250: make PIO support optional
Date: Mon, 27 Jun 2011 23:45:20 +0200
Message-Id: <1309211120-2803-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309211120-2803-1-git-send-email-arnd@arndb.de>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:eFzcHriUH1tQhTMUT05s8aKPfaxW7WlemPckuum8SxU
 YfNYZgDZOpqgvhzAa0KvlgFJHywxFT/7qkj2IdMRYYWafLdvxQ
 kgy8ClymudwTp45/ZR6diwx9/anXUQzfbuNHs2H5VKO4xfoQBY
 eDwYYnTkQsgRDHozrq67nkcmxZMeaKCDnHm5v+Zdyam8RaoXgE
 Z/6eYV7Ta/5kUKViP26YA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not currently possible to build support for the 8250 UART
on architectures that don't define PC-style I/O accessors like
inb/outb. Most embedded systems without PCI don't actually have
PC-style I/O, so they should not have to make up their own
accessors.

This makes the PIO support in the 8250 driver completely
conditional on CONFIG_HAS_IOPORT so we can remove the bogus
definitions from all the places that only need them for 8250.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/8250.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 2b06c27..a2933d6 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -318,6 +318,7 @@ static unsigned int mem32_serial_in(struct uart_port *p, int offset)
 	return readl(p->membase + offset);
 }
 
+#ifdef CONFIG_HAS_IOPORT
 static unsigned int io_serial_in(struct uart_port *p, int offset)
 {
 	offset = map_8250_in_reg(p, offset) << p->regshift;
@@ -329,16 +330,19 @@ static void io_serial_out(struct uart_port *p, int offset, int value)
 	offset = map_8250_out_reg(p, offset) << p->regshift;
 	outb(value, p->iobase + offset);
 }
+#endif
 
 static void set_io_from_upio(struct uart_port *p)
 {
 	struct uart_8250_port *up =
 		container_of(p, struct uart_8250_port, port);
 	switch (p->iotype) {
-	case UPIO_MEM:
-		p->serial_in = mem_serial_in;
-		p->serial_out = mem_serial_out;
+#ifdef CONFIG_HAS_IOPORT
+	case UPIO_PORT:
+		p->serial_in = io_serial_in;
+		p->serial_out = io_serial_out;
 		break;
+#endif
 
 	case UPIO_MEM32:
 		p->serial_in = mem32_serial_in;
@@ -346,9 +350,10 @@ static void set_io_from_upio(struct uart_port *p)
 		break;
 
 	default:
-		p->serial_in = io_serial_in;
-		p->serial_out = io_serial_out;
+		p->serial_in = mem_serial_in;
+		p->serial_out = mem_serial_out;
 		break;
+
 	}
 	/* Remember loaded iotype */
 	up->cur_iotype = p->iotype;
@@ -2250,12 +2255,13 @@ static int serial8250_request_port(struct uart_port *port)
 			}
 		}
 		break;
-
+#ifdef CONFIG_HAS_IOPORT
 	case UPIO_HUB6:
 	case UPIO_PORT:
 		if (!request_region(up->port.iobase, size, "serial"))
 			ret = -EBUSY;
 		break;
+#endif
 	}
 	return ret;
 }
@@ -2282,10 +2288,12 @@ static void serial8250_release_port(struct uart_port *port)
 		release_mem_region(up->port.mapbase, size);
 		break;
 
+#ifdef CONFIG_HAS_IOPORT
 	case UPIO_HUB6:
 	case UPIO_PORT:
 		release_region(up->port.iobase, size);
 		break;
+#endif
 	}
 }
 
-- 
1.7.5.4

