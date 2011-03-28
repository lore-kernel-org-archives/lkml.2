Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1C1L5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 07:57:16 -0400
Received: from mx1.zhaw.ch ([160.85.104.50]:59712 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab1C1L5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 07:57:13 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, nios2-dev@sopc.et.ntust.edu.tw,
        linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>
Subject: [PATCH] serial: altera_uart: Scan for a free port if platform device id is -1
Date: Mon, 28 Mar 2011 13:57:11 +0200
Message-Id: <1301313431-10063-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.0.4
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.3.28.114519
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __FRAUD_BODY_WEBMAIL 0, __FRAUD_WEBMAIL 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices extracted from device tree all seem to have pdev->id set to -1.
Up until now we mapped all devices with id -1 to the first device.  This
behaviour could lead to problems when using more than one Altera UART in
a system.

This patch changes the behaviour of the driver to scan for the next free
id in case the id is -1.

Because we cannot refer back to the assigned id in altera_uart_remove,
the port instance needs to be stored in device drvdata.

Reported-by: David Smoot <davidsmoot@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/tty/serial/altera_uart.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
index 6a1ebd9..3a9cffa 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -517,11 +517,14 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
 	int i = pdev->id;
 	int ret;
 
-	/* -1 emphasizes that the platform must have one port, no .N suffix */
-	if (i == -1)
-		i = 0;
+	/* if id is -1 scan for a free id and use that one */
+	if (i == -1) {
+		for (i = 0; i < CONFIG_SERIAL_ALTERA_UART_MAXPORTS; i++)
+			if (altera_uart_ports[i].port.mapbase == 0)
+				break;
+	}
 
-	if (i >= CONFIG_SERIAL_ALTERA_UART_MAXPORTS)
+	if (i < 0 || i >= CONFIG_SERIAL_ALTERA_UART_MAXPORTS)
 		return -EINVAL;
 
 	port = &altera_uart_ports[i].port;
@@ -564,6 +567,8 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
 	port->ops = &altera_uart_ops;
 	port->flags = UPF_BOOT_AUTOCONF;
 
+	dev_set_drvdata(&pdev->dev, port);
+
 	uart_add_one_port(&altera_uart_driver, port);
 
 	return 0;
@@ -571,14 +576,13 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
 
 static int __devexit altera_uart_remove(struct platform_device *pdev)
 {
-	struct uart_port *port;
-	int i = pdev->id;
+	struct uart_port *port = dev_get_drvdata(&pdev->dev);
 
-	if (i == -1)
-		i = 0;
-
-	port = &altera_uart_ports[i].port;
-	uart_remove_one_port(&altera_uart_driver, port);
+	if (port) {
+		uart_remove_one_port(&altera_uart_driver, port);
+		dev_set_drvdata(&pdev->dev, NULL);
+		port->mapbase = 0;
+	}
 
 	return 0;
 }
-- 
1.7.0.4

