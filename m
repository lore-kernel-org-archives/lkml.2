Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2AQS4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:56:42 -0500
Received: from mail-yw0-f74.google.com ([209.85.213.74]:47874 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab2AQS4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:56:41 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        Simon Glass <sjg@chromium.org>
Subject: [PATCH 3/3] serial: 8250: Add a wakeup_capable module param
Date: Tue, 17 Jan 2012 10:56:03 -0800
Message-Id: <1326826563-32215-3-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1326826563-32215-1-git-send-email-sjg@chromium.org>
References: <1326826563-32215-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since serial_core now does not make serial ports wake-up capable by
default, add a parameter to support this feature in the 8250 UART.
This is the only UART where I think this feature is useful.

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 drivers/tty/serial/8250.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 54f8920..78feee4 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -65,6 +65,7 @@ static int serial_index(struct uart_port *port)
 }
 
 static unsigned int skip_txen_test; /* force skip of txen test at init time */
+static unsigned int wakeup_capable; /* device can wake up system */
 
 /*
  * Debugging.
@@ -2786,6 +2787,7 @@ serial8250_register_ports(struct uart_driver *drv, struct device *dev)
 
 		if (up->port.flags & UPF_FIXED_TYPE)
 			serial8250_init_fixed_type_port(up, up->port.type);
+		up->port.wakeup_capable = wakeup_capable;
 
 		uart_add_one_port(drv, &up->port);
 	}
@@ -3219,6 +3221,7 @@ int serial8250_register_port(struct uart_port *port)
 			uart->port.set_termios = port->set_termios;
 		if (port->pm)
 			uart->port.pm = port->pm;
+		uart->port.wakeup_capable = wakeup_capable;
 
 		if (serial8250_isa_config != NULL)
 			serial8250_isa_config(0, &uart->port,
@@ -3252,6 +3255,7 @@ void serial8250_unregister_port(int line)
 		uart->port.type = PORT_UNKNOWN;
 		uart->port.dev = &serial8250_isa_devs->dev;
 		uart->capabilities = uart_config[uart->port.type].flags;
+		uart->port.wakeup_capable = wakeup_capable;
 		uart_add_one_port(&serial8250_reg, &uart->port);
 	} else {
 		uart->port.dev = NULL;
@@ -3355,3 +3359,6 @@ module_param_array(probe_rsa, ulong, &probe_rsa_count, 0444);
 MODULE_PARM_DESC(probe_rsa, "Probe I/O ports for RSA");
 #endif
 MODULE_ALIAS_CHARDEV_MAJOR(TTY_MAJOR);
+
+module_param(wakeup_capable, uint, 0644);
+MODULE_PARM_DESC(wakeup_capable, "Allow driver to wake up the system");
-- 
1.7.7.3

