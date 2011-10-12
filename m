Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab1JLQIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:08:09 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:12674 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab1JLQIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:08:07 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, robherring2@gmail.com,
        claudio@evidence.eu.com, jesper.nilsson@axis.com,
        alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 4/5] tty/serial: atmel_serial: auto-enumerate ports
Date: Wed, 12 Oct 2011 18:06:59 +0200
Message-Id: <ecef50a9b874d08bb46c0a12d1e4ad01e641d3d5.1318433947.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318435620-7481-1-git-send-email-nicolas.ferre@atmel.com>
References: <1318435620-7481-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <37a19e194d02144aecd24f284f5e43979643a3c3.1318433947.git.nicolas.ferre@atmel.com>
References: <37a19e194d02144aecd24f284f5e43979643a3c3.1318433947.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no platform data provided to enumerate ports, use a bit field
to choose port number and check if port is already initialized.
Use this mechanism for both console and plain serial ports.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/tty/serial/atmel_serial.c |   44 ++++++++++++++++++++++++++++++------
 1 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index bb72354..1074329 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -157,6 +157,7 @@ struct atmel_uart_port {
 };
 
 static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
+static unsigned long atmel_ports_in_use;
 
 #ifdef SUPPORT_SYSRQ
 static struct console atmel_console;
@@ -1423,7 +1424,6 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
 	port->flags		= UPF_BOOT_AUTOCONF;
 	port->ops		= &atmel_pops;
 	port->fifosize		= 1;
-	port->line		= pdata->num;
 	port->dev		= &pdev->dev;
 	port->mapbase	= pdev->resource[0].start;
 	port->irq	= pdev->resource[1].start;
@@ -1613,10 +1613,15 @@ static struct console atmel_console = {
 static int __init atmel_console_init(void)
 {
 	if (atmel_default_console_device) {
-		add_preferred_console(ATMEL_DEVICENAME,
-				      atmel_default_console_device->id, NULL);
-		atmel_init_port(&atmel_ports[atmel_default_console_device->id],
-				atmel_default_console_device);
+		int id = atmel_default_console_device->id;
+		struct atmel_uart_port *port = &atmel_ports[id];
+
+		set_bit(id, &atmel_ports_in_use);
+		port->backup_imr = 0;
+		port->uart.line = id;
+
+		add_preferred_console(ATMEL_DEVICENAME, id, NULL);
+		atmel_init_port(port, atmel_default_console_device);
 		register_console(&atmel_console);
 	}
 
@@ -1715,12 +1720,33 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 	struct atmel_uart_port *port;
 	struct atmel_uart_data *pdata = pdev->dev.platform_data;
 	void *data;
-	int ret;
+	int ret = -ENODEV;
 
 	BUILD_BUG_ON(ATMEL_SERIAL_RINGSIZE & (ATMEL_SERIAL_RINGSIZE - 1));
 
-	port = &atmel_ports[pdata->num];
+	if (pdata)
+		ret = pdata->num;
+
+	if (ret < 0)
+		/* port id not found in platform data:
+		 * auto-enumerate it */
+		ret = find_first_zero_bit(&atmel_ports_in_use,
+				sizeof(atmel_ports_in_use));
+
+	if (ret > ATMEL_MAX_UART) {
+		ret = -ENODEV;
+		goto err;
+	}
+
+	if (test_and_set_bit(ret, &atmel_ports_in_use)) {
+		/* port already in use */
+		ret = -EBUSY;
+		goto err;
+	}
+
+	port = &atmel_ports[ret];
 	port->backup_imr = 0;
+	port->uart.line = ret;
 
 	atmel_init_port(port, pdev);
 
@@ -1766,7 +1792,7 @@ err_alloc_ring:
 		clk_put(port->clk);
 		port->clk = NULL;
 	}
-
+err:
 	return ret;
 }
 
@@ -1786,6 +1812,8 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
 
 	/* "port" is allocated statically, so we shouldn't free it */
 
+	clear_bit(port->line, &atmel_ports_in_use);
+
 	clk_put(atmel_port->clk);
 
 	return ret;
-- 
1.7.5.4

