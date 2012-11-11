Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2KKMu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:50:58 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45333 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab2KKMuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:50:55 -0500
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC] serial: bcm63xx_uart: allow probing through Device Tree
Date: Sun, 11 Nov 2012 13:50:46 +0100
Message-Id: <1352638249-29298-13-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for probing the serial ports through Device Tree.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 .../bindings/tty/serial/bcm63xx-uart.txt           |   17 +++++++++
 drivers/tty/serial/bcm63xx_uart.c                  |   35 ++++++++++++++------
 2 files changed, 42 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/tty/serial/bcm63xx-uart.txt

diff --git a/Documentation/devicetree/bindings/tty/serial/bcm63xx-uart.txt b/Documentation/devicetree/bindings/tty/serial/bcm63xx-uart.txt
new file mode 100644
index 0000000..7623604
--- /dev/null
+++ b/Documentation/devicetree/bindings/tty/serial/bcm63xx-uart.txt
@@ -0,0 +1,17 @@
+* Broadcom BCM63XX UART
+
+Required properties:
+- compatible: "brcm,bcm63xx-uart"
+  Compatible with all BCM63XX SoCs.
+
+- reg: address and length of the register block.
+
+- interrupts: the uart's interrupt number.
+
+Example:
+
+	uart0: serial@100 {
+		compatible = "brcm,bcm63xx";
+		reg = <0x100 0x18>;
+		interrupts = <2>;
+	};
diff --git a/drivers/tty/serial/bcm63xx_uart.c b/drivers/tty/serial/bcm63xx_uart.c
index 0187aff..4521a52 100644
--- a/drivers/tty/serial/bcm63xx_uart.c
+++ b/drivers/tty/serial/bcm63xx_uart.c
@@ -802,23 +802,32 @@ static struct uart_driver bcm_uart_driver = {
  */
 static int __devinit bcm_uart_probe(struct platform_device *pdev)
 {
-	struct resource *res_mem, *res_irq;
+	struct resource *res_mem;
 	struct uart_port *port;
 	struct clk *clk;
-	int ret;
+	int ret, irq;
 
-	if (pdev->id < 0 || pdev->id >= BCM63XX_NR_UARTS)
-		return -EINVAL;
+	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res_mem)
+		return -ENODEV;
+
+	if (pdev->id < 0)  {
+		void __iomem *membase;
+
+		membase = ioremap(res_mem->start, resource_size(res_mem));
+		if (membase == (void *)bcm63xx_regset_address(RSET_UART0))
+			pdev->id = 0;
+		else
+			pdev->id = 1;
+		iounmap(membase);
+	}
 
 	if (ports[pdev->id].membase)
 		return -EBUSY;
 
-	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res_mem)
-		return -ENODEV;
 
-	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res_irq)
+	irq = platform_get_irq(pdev, 0);
+	if (!irq)
 		return -ENODEV;
 
 	clk = clk_get(&pdev->dev, "periph");
@@ -829,7 +838,7 @@ static int __devinit bcm_uart_probe(struct platform_device *pdev)
 	memset(port, 0, sizeof(*port));
 	port->iotype = UPIO_MEM;
 	port->mapbase = res_mem->start;
-	port->irq = res_irq->start;
+	port->irq = irq;
 	port->ops = &bcm_uart_ops;
 	port->flags = UPF_BOOT_AUTOCONF;
 	port->dev = &pdev->dev;
@@ -862,12 +871,18 @@ static int __devexit bcm_uart_remove(struct platform_device *pdev)
 /*
  * platform driver stuff
  */
+static const struct of_device_id bcm_uart_match[] = {
+	{ .compatible = "brcm,bcm63xx-uart" },
+	{ },
+};
+
 static struct platform_driver bcm_uart_platform_driver = {
 	.probe	= bcm_uart_probe,
 	.remove	= __devexit_p(bcm_uart_remove),
 	.driver	= {
 		.owner = THIS_MODULE,
 		.name  = "bcm63xx_uart",
+		.of_match_table = bcm_uart_match,
 	},
 };
 
-- 
1.7.2.5

