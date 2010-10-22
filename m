Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab0JVSYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:24:49 -0400
Received: from kroah.org ([198.145.64.141]:37731 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758832Ab0JVSYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:24:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Dirk Brandewie <dirk.brandewie@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 47/49] serial: abstraction for 8250 legacy ports
Date: Fri, 22 Oct 2010 11:21:26 -0700
Message-Id: <1287771688-14805-47-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Not every platform that has generic legacy 8250 ports manages to have them
clocked the right way or without errata. Provide a generic interface to
allow platforms to override the default behaviour in a manner that dumps
the complexity in *their* code not the 8250 driver.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c       |   17 +++++++++++++++++
 include/linux/serial_8250.h |    4 ++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 6994afb..37f19a6 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2672,6 +2672,16 @@ static struct uart_ops serial8250_pops = {
 
 static struct uart_8250_port serial8250_ports[UART_NR];
 
+static void (*serial8250_isa_config)(int port, struct uart_port *up,
+	unsigned short *capabilities);
+
+void serial8250_set_isa_configurator(
+	void (*v)(int port, struct uart_port *up, unsigned short *capabilities))
+{
+	serial8250_isa_config = v;
+}
+EXPORT_SYMBOL(serial8250_set_isa_configurator);
+
 static void __init serial8250_isa_init_ports(void)
 {
 	struct uart_8250_port *up;
@@ -2717,6 +2727,9 @@ static void __init serial8250_isa_init_ports(void)
 		up->port.regshift = old_serial_port[i].iomem_reg_shift;
 		set_io_from_upio(&up->port);
 		up->port.irqflags |= irqflag;
+		if (serial8250_isa_config != NULL)
+			serial8250_isa_config(i, &up->port, &up->capabilities);
+
 	}
 }
 
@@ -3178,6 +3191,10 @@ int serial8250_register_port(struct uart_port *port)
 		if (port->pm)
 			uart->port.pm = port->pm;
 
+		if (serial8250_isa_config != NULL)
+			serial8250_isa_config(0, &uart->port,
+					&uart->capabilities);
+
 		ret = uart_add_one_port(&serial8250_reg, &uart->port);
 		if (ret == 0)
 			ret = uart->port.line;
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index bf9c2bd..97f5b45 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -81,4 +81,8 @@ extern void serial8250_do_set_termios(struct uart_port *port,
 extern void serial8250_do_pm(struct uart_port *port, unsigned int state,
 			     unsigned int oldstate);
 
+extern void serial8250_set_isa_configurator(void (*v)
+					(int port, struct uart_port *up,
+						unsigned short *capabilities));
+
 #endif
-- 
1.7.2

