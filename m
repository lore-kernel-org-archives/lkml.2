Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1BIJ6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:58:17 -0500
Received: from mx1.zhaw.ch ([160.85.104.50]:64780 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab1BIJ6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:58:15 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Cc: nios2-dev@sopc.et.ntust.edu.tw, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] tty: serial: altera_uart: Add devicetree support
Date: Wed,  9 Feb 2011 10:58:13 +0100
Message-Id: <c7a7085602687d2f1b6ac505c030f19bafda04e3.1297245277.git.tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1297245277.git.tklauser@distanz.ch>
References: <cover.1297245277.git.tklauser@distanz.ch>
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.2.9.94515
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODY_SIZE_3000_3999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent switch of the (currently still out-of-tree) Nios2 Linux
port to devicetree we want to be able to retreive the resources and
properties from dts.

The old method to retreive resources and properties from platform data
is still supported.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 .../devicetree/bindings/serial/altera_uart.txt     |    7 +++
 drivers/tty/serial/altera_uart.c                   |   47 ++++++++++++++++++--
 2 files changed, 50 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/serial/altera_uart.txt

diff --git a/Documentation/devicetree/bindings/serial/altera_uart.txt b/Documentation/devicetree/bindings/serial/altera_uart.txt
new file mode 100644
index 0000000..2ab151c
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/altera_uart.txt
@@ -0,0 +1,7 @@
+Altera UART
+
+Required properties:
+- compatible : should be "ALTR,uart-1.0"
+ 
+Optional properties:
+- clock-frequency : frequency of the clock input to the UART
diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
index 3a57352..5b46ca7 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -24,6 +24,7 @@
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
 #include <linux/io.h>
 #include <linux/altera_uart.h>
 
@@ -507,6 +508,34 @@ static struct uart_driver altera_uart_driver = {
 	.cons		= ALTERA_UART_CONSOLE,
 };
 
+#ifdef CONFIG_OF
+static int altera_uart_get_uartclk(struct platform_device *pdev,
+				   struct uart_port *port)
+{
+	const __be32 *clk = of_get_property(pdev->dev.of_node, "clock-frequency", NULL);
+
+	if (!clk)
+		return -ENODEV;
+
+	port->uartclk = be32_to_cpup(clk);
+
+	return 0;
+}
+#else
+static int altera_uart_get_uartclk(struct platform_device *pdev,
+				   struct uart_port *port)
+{
+	struct altera_uart_platform_uart *platp = pdev->dev.platform_data;
+
+	if (!platp)
+		return -ENODEV;
+
+	port->uartclk = platp->uartclk;
+
+	return 0;
+}
+#endif /* CONFIG_OF */
+
 static int __devinit altera_uart_probe(struct platform_device *pdev)
 {
 	struct altera_uart_platform_uart *platp = pdev->dev.platform_data;
@@ -514,6 +543,7 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
 	struct resource *res_mem;
 	struct resource *res_irq;
 	int i = pdev->id;
+	int ret;
 
 	/* -1 emphasizes that the platform must have one port, no .N suffix */
 	if (i == -1)
@@ -538,6 +568,10 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
 	else if (platp->irq)
 		port->irq = platp->irq;
 
+	ret = altera_uart_get_uartclk(pdev, port);
+	if (ret)
+		return ret;
+
 	port->membase = ioremap(port->mapbase, ALTERA_UART_SIZE);
 	if (!port->membase)
 		return -ENOMEM;
@@ -550,7 +584,6 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
 	port->line = i;
 	port->type = PORT_ALTERA_UART;
 	port->iotype = SERIAL_IO_MEM;
-	port->uartclk = platp->uartclk;
 	port->ops = &altera_uart_ops;
 	port->flags = UPF_BOOT_AUTOCONF;
 
@@ -573,13 +606,19 @@ static int __devexit altera_uart_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct of_device_id altera_uart_match[] = {
+	{ .compatible = "altr,uart-1.0", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, altera_uart_match);
+
 static struct platform_driver altera_uart_platform_driver = {
 	.probe	= altera_uart_probe,
 	.remove	= __devexit_p(altera_uart_remove),
 	.driver	= {
-		.name	= DRV_NAME,
-		.owner	= THIS_MODULE,
-		.pm	= NULL,
+		.name		= DRV_NAME,
+		.owner		= THIS_MODULE,
+		.of_match_table	= altera_uart_match,
 	},
 };
 
-- 
1.7.0.4

