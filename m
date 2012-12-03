Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab2LCLQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 06:16:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:53155 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab2LCLQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 06:16:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,205,1355126400"; 
   d="scan'208";a="175377276"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 4/5] serial: 8250_dw: Move device tree code to separate function
Date: Mon,  3 Dec 2012 13:17:58 +0200
Message-Id: <1354533479-27306-5-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354533479-27306-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1354533479-27306-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial cleanup. This makes it easier to add different
methods to enumerate the device, for example ACPI 5.0
enumeration.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dw.c |   76 ++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 30 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 300bbed..c4e28df 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -87,25 +87,51 @@ static int dw8250_handle_irq(struct uart_port *p)
 	return 0;
 }
 
+static int dw8250_probe_of(struct uart_port *p)
+{
+	struct device_node	*np = p->dev->of_node;
+	u32			val;
+
+	if (!of_property_read_u32(np, "reg-io-width", &val)) {
+		switch (val) {
+		case 1:
+			break;
+		case 4:
+			p->iotype = UPIO_MEM32;
+			p->serial_in = dw8250_serial_in32;
+			p->serial_out = dw8250_serial_out32;
+			break;
+		default:
+			dev_err(p->dev, "unsupported reg-io-width (%u)\n", val);
+			return -EINVAL;
+		}
+	}
+
+	if (!of_property_read_u32(np, "reg-shift", &val))
+		p->regshift = val;
+
+	if (of_property_read_u32(np, "clock-frequency", &val)) {
+		dev_err(p->dev, "no clock-frequency property set\n");
+		return -EINVAL;
+	}
+	p->uartclk = val;
+
+	return 0;
+}
+
 static int dw8250_probe(struct platform_device *pdev)
 {
 	struct uart_8250_port uart = {};
 	struct resource *regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	struct resource *irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	struct device_node *np = pdev->dev.of_node;
-	u32 val;
 	struct dw8250_data *data;
+	int err;
 
 	if (!regs || !irq) {
 		dev_err(&pdev->dev, "no registers/irq defined\n");
 		return -EINVAL;
 	}
 
-	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-	uart.port.private_data = data;
-
 	spin_lock_init(&uart.port.lock);
 	uart.port.mapbase = regs->start;
 	uart.port.irq = irq->start;
@@ -121,30 +147,20 @@ static int dw8250_probe(struct platform_device *pdev)
 	uart.port.iotype = UPIO_MEM;
 	uart.port.serial_in = dw8250_serial_in;
 	uart.port.serial_out = dw8250_serial_out;
-	if (!of_property_read_u32(np, "reg-io-width", &val)) {
-		switch (val) {
-		case 1:
-			break;
-		case 4:
-			uart.port.iotype = UPIO_MEM32;
-			uart.port.serial_in = dw8250_serial_in32;
-			uart.port.serial_out = dw8250_serial_out32;
-			break;
-		default:
-			dev_err(&pdev->dev, "unsupported reg-io-width (%u)\n",
-				val);
-			return -EINVAL;
-		}
+
+	if (pdev->dev.of_node) {
+		err = dw8250_probe_of(&uart.port);
+		if (err)
+			return err;
+	} else {
+		return -ENODEV;
 	}
 
-	if (!of_property_read_u32(np, "reg-shift", &val))
-		uart.port.regshift = val;
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
 
-	if (of_property_read_u32(np, "clock-frequency", &val)) {
-		dev_err(&pdev->dev, "no clock-frequency property set\n");
-		return -EINVAL;
-	}
-	uart.port.uartclk = val;
+	uart.port.private_data = data;
 
 	data->line = serial8250_register_8250_port(&uart);
 	if (data->line < 0)
@@ -187,7 +203,7 @@ static int dw8250_resume(struct platform_device *pdev)
 #define dw8250_resume NULL
 #endif /* CONFIG_PM */
 
-static const struct of_device_id dw8250_match[] = {
+static const struct of_device_id dw8250_of_match[] = {
 	{ .compatible = "snps,dw-apb-uart" },
 	{ /* Sentinel */ }
 };
@@ -197,7 +213,7 @@ static struct platform_driver dw8250_platform_driver = {
 	.driver = {
 		.name		= "dw-apb-uart",
 		.owner		= THIS_MODULE,
-		.of_match_table	= dw8250_match,
+		.of_match_table	= dw8250_of_match,
 	},
 	.probe			= dw8250_probe,
 	.remove			= dw8250_remove,
-- 
1.7.10.4

