Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1JCIiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 04:38:46 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:38209 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab1JCIii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 04:38:38 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [RFC PATCH] tty/serial: atmel_serial: add device tree support
Date: Mon,  3 Oct 2011 11:51:42 +0200
Message-Id: <1317635502-9430-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi,

Here is a first attempt to add device tree support to atmel_serial driver.
RS485 data are not handled for the moment. My feeling is that they should be
added as a generic DT biding set.


 .../devicetree/bindings/tty/serial/atmel-usart.txt |   27 +++++++++
 drivers/tty/serial/atmel_serial.c                  |   56 +++++++++++++++++---
 2 files changed, 75 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/tty/serial/atmel-usart.txt

diff --git a/Documentation/devicetree/bindings/tty/serial/atmel-usart.txt b/Documentation/devicetree/bindings/tty/serial/atmel-usart.txt
new file mode 100644
index 0000000..a49d9a1
--- /dev/null
+++ b/Documentation/devicetree/bindings/tty/serial/atmel-usart.txt
@@ -0,0 +1,27 @@
+* Atmel Universal Synchronous Asynchronous Receiver/Transmitter (USART)
+
+Required properties:
+- compatible: Should be "atmel,<chip>-usart"
+  The compatible <chip> indicated will be the first SoC to support an
+  additional mode or an USART new feature.
+- reg: Should contain registers location and length
+- interrupts: Should contain interrupt
+
+Optional properties:
+- atmel,use-dma-rx: use of PDC or DMA for receiving data
+- atmel,use-dma-tx: use of PDC or DMA for transmitting data
+
+<chip> compatible description:
+- at91rm9200:  legacy USART support
+- at91sam9260: generic USART implementation for SAM9 SoCs
+
+Example:
+
+	usart0: serial@fff8c000 {
+		compatible = "atmel,at91sam9260-usart";
+		reg = <0xfff8c000 0x4000>;
+		interrupts = <7>;
+		atmel,use-dma-rx;
+		atmel,use-dma-tx;
+	};
+
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 453cdb5..65f56c3 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -33,6 +33,8 @@
 #include <linux/sysrq.h>
 #include <linux/tty_flip.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/atmel_pdc.h>
 #include <linux/atmel_serial.h>
@@ -162,6 +164,16 @@ static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
 static struct console atmel_console;
 #endif
 
+#if defined(CONFIG_OF)
+static const struct of_device_id atmel_serial_dt_ids[] = {
+	{ .compatible = "atmel,at91rm9200-usart" },
+	{ .compatible = "atmel,at91sam9260-usart" },
+	{ /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, atmel_serial_dt_ids);
+#endif
+
 static inline struct atmel_uart_port *
 to_atmel_uart_port(struct uart_port *uart)
 {
@@ -1413,14 +1425,31 @@ static struct uart_ops atmel_pops = {
 static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
 				      struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
 	struct uart_port *port = &atmel_port->uart;
 	struct atmel_uart_data *pdata = pdev->dev.platform_data;
+	int ret;
+
+	if (np) {
+		ret = of_alias_get_id(np, "serial");
+		if (ret >= 0)
+			port->line = ret;
+		if (of_get_property(np, "atmel,use-dma-rx", NULL))
+			atmel_port->use_dma_rx	= 1;
+		if (of_get_property(np, "atmel,use-dma-tx", NULL))
+			atmel_port->use_dma_tx	= 1;
+	} else {
+		port->line = pdata->num;
+
+		atmel_port->use_dma_rx	= pdata->use_dma_rx;
+		atmel_port->use_dma_tx	= pdata->use_dma_tx;
+		atmel_port->rs485	= pdata->rs485;
+	}
 
 	port->iotype		= UPIO_MEM;
 	port->flags		= UPF_BOOT_AUTOCONF;
 	port->ops		= &atmel_pops;
 	port->fifosize		= 1;
-	port->line		= pdata->num;
 	port->dev		= &pdev->dev;
 	port->mapbase	= pdev->resource[0].start;
 	port->irq	= pdev->resource[1].start;
@@ -1430,7 +1459,7 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
 
 	memset(&atmel_port->rx_ring, 0, sizeof(atmel_port->rx_ring));
 
-	if (pdata->regs) {
+	if (pdata && pdata->regs) {
 		/* Already mapped by setup code */
 		port->membase = pdata->regs;
 	} else {
@@ -1447,10 +1476,6 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
 		/* only enable clock when USART is in use */
 	}
 
-	atmel_port->use_dma_rx	= pdata->use_dma_rx;
-	atmel_port->use_dma_tx	= pdata->use_dma_tx;
-	atmel_port->rs485	= pdata->rs485;
-
 	/* Use TXEMPTY for interrupt when rs485 else TXRDY or ENDTX|TXBUFE */
 	if (atmel_port->rs485.flags & SER_RS485_ENABLED)
 		atmel_port->tx_done_mask = ATMEL_US_TXEMPTY;
@@ -1710,13 +1735,27 @@ static int atmel_serial_resume(struct platform_device *pdev)
 static int __devinit atmel_serial_probe(struct platform_device *pdev)
 {
 	struct atmel_uart_port *port;
+	struct device_node *np = pdev->dev.of_node;
 	struct atmel_uart_data *pdata = pdev->dev.platform_data;
 	void *data;
 	int ret;
 
 	BUILD_BUG_ON(ATMEL_SERIAL_RINGSIZE & (ATMEL_SERIAL_RINGSIZE - 1));
 
-	port = &atmel_ports[pdata->num];
+	if (np) {
+		ret = of_alias_get_id(np, "serial");
+		if (ret < 0)
+			goto err;
+	} else {
+		if (pdata) {
+			ret = pdata->num;
+		} else {
+			ret = -ENODEV;
+			goto err;
+		}
+	}
+
+	port = &atmel_ports[ret];
 	port->backup_imr = 0;
 
 	atmel_init_port(port, pdev);
@@ -1763,7 +1802,7 @@ err_alloc_ring:
 		clk_put(port->clk);
 		port->clk = NULL;
 	}
-
+err:
 	return ret;
 }
 
@@ -1796,6 +1835,7 @@ static struct platform_driver atmel_serial_driver = {
 	.driver		= {
 		.name	= "atmel_usart",
 		.owner	= THIS_MODULE,
+		.of_match_table	= of_match_ptr(atmel_serial_dt_ids),
 	},
 };
 
-- 
1.7.3

