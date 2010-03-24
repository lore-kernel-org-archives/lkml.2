Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0CXRP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:15:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:33205 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab0CXRPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mrxqmDBzZJLocHTMDgYn1PhJBdiKgG2UT3xZHepENVrxW+1JTGf1LgX9fYO8SR1xY2
         zSH+llyZsIZkhuZhzbRUo06J6gfXqrcuChSkWu/BFJaW7MST0xKr2Czxdq24zHBkybMI
         JbJ2MLnKpDBFEyE6EKxicLV46tLVluBVSggPM=
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, Manuel Lauss <manuel.lauss@gmail.com>
Subject: [RFC PATCH 1/2] 8250: allow platform uarts to install PM callback.
Date: Wed, 24 Mar 2010 18:16:25 +0100
Message-Id: <1269450986-3714-2-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269450986-3714-1-git-send-email-manuel.lauss@gmail.com>
References: <1269450986-3714-1-git-send-email-manuel.lauss@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 8250 UART driver provides rudimentary UART PM support and
a callback for systems to do more sophisticated power management.
However, there is no way yet for platform_device uarts to assign
a function to this internal callback.

This patch adds a callback to plat_8250_port and a function to
register this callback with 8250 driver internals.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
---
 drivers/serial/8250.c       |   31 ++++++++++++++++++++++++++++---
 include/linux/serial_8250.h |    6 ++++++
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index c3db16b..c0c8e9b 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2995,7 +2995,7 @@ static int __devinit serial8250_probe(struct platform_device *dev)
 		port.serial_out		= p->serial_out;
 		port.dev		= &dev->dev;
 		port.irqflags		|= irqflag;
-		ret = serial8250_register_port(&port);
+		ret = serial8250_register_port_with_pm(&port, p->pm);
 		if (ret < 0) {
 			dev_err(&dev->dev, "unable to register port at index %d "
 				"(IO%lx MEM%llx IRQ%d): %d\n", i,
@@ -3107,8 +3107,10 @@ static struct uart_8250_port *serial8250_find_match_or_unused(struct uart_port *
 }
 
 /**
- *	serial8250_register_port - register a serial port
+ *	serial8250_register_port_with_pm - register a serial port and its
+ *					   power management callback.
  *	@port: serial port template
+ *	@pm:   PM callback for this port, can be NULL.
  *
  *	Configure the serial port specified by the request. If the
  *	port exists and is in use, it is hung up and unregistered
@@ -3119,7 +3121,9 @@ static struct uart_8250_port *serial8250_find_match_or_unused(struct uart_port *
  *
  *	On success the port is ready to use and the line number is returned.
  */
-int serial8250_register_port(struct uart_port *port)
+int serial8250_register_port_with_pm(struct uart_port *port,
+	void(*pm)(struct uart_port *port, unsigned int state,
+		  unsigned int old))
 {
 	struct uart_8250_port *uart;
 	int ret = -ENOSPC;
@@ -3144,6 +3148,7 @@ int serial8250_register_port(struct uart_port *port)
 		uart->port.flags        = port->flags | UPF_BOOT_AUTOCONF;
 		uart->port.mapbase      = port->mapbase;
 		uart->port.private_data = port->private_data;
+		uart->pm		= pm;
 		if (port->dev)
 			uart->port.dev = port->dev;
 
@@ -3165,6 +3170,26 @@ int serial8250_register_port(struct uart_port *port)
 
 	return ret;
 }
+EXPORT_SYMBOL(serial8250_register_port_with_pm);
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
+	return serial8250_register_port_with_pm(port, NULL);
+}
+
 EXPORT_SYMBOL(serial8250_register_port);
 
 /**
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index fb46aba..25cc3fb 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -14,6 +14,9 @@
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
 
+typedef void(*plat8250_pm_func_t)(struct uart_port *port, unsigned int state,
+				  unsigned int old_state);
+
 /*
  * This is the platform device platform_data structure
  */
@@ -32,6 +35,8 @@ struct plat_serial8250_port {
 	unsigned int	type;		/* If UPF_FIXED_TYPE */
 	unsigned int	(*serial_in)(struct uart_port *, int);
 	void		(*serial_out)(struct uart_port *, int, int);
+	void 		(*pm)(struct uart_port *port, unsigned int state,
+			      unsigned int old_state);
 };
 
 /*
@@ -62,6 +67,7 @@ enum {
 struct uart_port;
 
 int serial8250_register_port(struct uart_port *);
+int serial8250_register_port_with_pm(struct uart_port *, plat8250_pm_func_t);
 void serial8250_unregister_port(int line);
 void serial8250_suspend_port(int line);
 void serial8250_resume_port(int line);
-- 
1.7.0.2

