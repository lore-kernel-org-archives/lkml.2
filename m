Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1GFQqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:46:30 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:21144
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150Ab1GFQq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:46:29 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jul 2011 12:46:29 EDT
X-SpamScore: -6
X-BigFish: VS-6(zzea8Nzz1202hzz8275dhz2dh87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <patches@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 3/3] gpio/mxc: add device tree probe support
Date: Thu, 7 Jul 2011 00:37:43 +0800
Message-ID: <1309970263-13239-4-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309970263-13239-1-git-send-email-shawn.guo@linaro.org>
References: <1309970263-13239-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds device tree probe support for gpio-mxc driver.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---
 .../devicetree/bindings/gpio/fsl-imx-gpio.txt      |   22 +++++++++++++
 drivers/gpio/gpio-mxc.c                            |   34 ++++++++++++++++---
 2 files changed, 50 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/fsl-imx-gpio.txt

diff --git a/Documentation/devicetree/bindings/gpio/fsl-imx-gpio.txt b/Documentation/devicetree/bindings/gpio/fsl-imx-gpio.txt
new file mode 100644
index 0000000..4363ae4
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/fsl-imx-gpio.txt
@@ -0,0 +1,22 @@
+* Freescale i.MX/MXC GPIO controller
+
+Required properties:
+- compatible : Should be "fsl,<soc>-gpio"
+- reg : Address and length of the register set for the device
+- interrupts : Should be the port interrupt shared by all 32 pins, if
+  one number.  If two numbers, the first one is the interrupt shared
+  by low 16 pins and the second one is for high 16 pins.
+- gpio-controller : Marks the device node as a gpio controller.
+- #gpio-cells : Should be two.  The first cell is the pin number and
+  the second cell is used to specify optional parameters (currently
+  unused).
+
+Example:
+
+gpio0: gpio@73f84000 {
+	compatible = "fsl,imx51-gpio", "fsl,imx31-gpio";
+	reg = <0x73f84000 0x4000>;
+	interrupts = <50 51>;
+	gpio-controller;
+	#gpio-cells = <2>;
+};
diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 310a46d..b7ff0a5 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -27,6 +27,8 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/basic_mmio_gpio.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <asm-generic/bug.h>
 
 enum mxc_gpio_hwtype {
@@ -120,6 +122,13 @@ static struct platform_device_id mxc_gpio_devtype[] = {
 	}
 };
 
+static const struct of_device_id mxc_gpio_dt_ids[] = {
+	{ .compatible = "fsl,imx1-gpio", .data = &mxc_gpio_devtype[IMX1_GPIO], },
+	{ .compatible = "fsl,imx21-gpio", .data = &mxc_gpio_devtype[IMX21_GPIO], },
+	{ .compatible = "fsl,imx31-gpio", .data = &mxc_gpio_devtype[IMX31_GPIO], },
+	{ /* sentinel */ }
+};
+
 /*
  * MX2 has one interrupt *for all* gpio ports. The list is used
  * to save the references to all ports, so that mx2_gpio_irq_handler
@@ -302,7 +311,13 @@ static void __init mxc_gpio_init_gc(struct mxc_gpio_port *port)
 
 static void __devinit mxc_gpio_get_hw(struct platform_device *pdev)
 {
-	enum mxc_gpio_hwtype hwtype = pdev->id_entry->driver_data;
+	const struct of_device_id *of_id =
+			of_match_device(mxc_gpio_dt_ids, &pdev->dev);
+	enum mxc_gpio_hwtype hwtype;
+
+	if (of_id)
+		pdev->id_entry = of_id->data;
+	hwtype = pdev->id_entry->driver_data;
 
 	if (mxc_gpio_hwtype) {
 		/*
@@ -324,6 +339,7 @@ static void __devinit mxc_gpio_get_hw(struct platform_device *pdev)
 
 static int __devinit mxc_gpio_probe(struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
 	struct mxc_gpio_port *port;
 	struct resource *iores;
 	int err;
@@ -334,8 +350,6 @@ static int __devinit mxc_gpio_probe(struct platform_device *pdev)
 	if (!port)
 		return -ENOMEM;
 
-	port->virtual_irq_start = MXC_GPIO_IRQ_START + pdev->id * 32;
-
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!iores) {
 		err = -ENODEV;
@@ -365,9 +379,6 @@ static int __devinit mxc_gpio_probe(struct platform_device *pdev)
 	writel(0, port->base + GPIO_IMR);
 	writel(~0, port->base + GPIO_ISR);
 
-	/* gpio-mxc can be a generic irq chip */
-	mxc_gpio_init_gc(port);
-
 	if (mxc_gpio_hwtype == IMX21_GPIO) {
 		/* setup one handler for all GPIO interrupts */
 		if (pdev->id == 0)
@@ -398,6 +409,16 @@ static int __devinit mxc_gpio_probe(struct platform_device *pdev)
 	if (err)
 		goto out_bgpio_remove;
 
+	/*
+	 * In dt case, we use gpio number range dynamically
+	 * allocated by gpio core.
+	 */
+	port->virtual_irq_start = MXC_GPIO_IRQ_START + (np ? port->bgc.gc.base :
+							     pdev->id * 32);
+
+	/* gpio-mxc can be a generic irq chip */
+	mxc_gpio_init_gc(port);
+
 	list_add_tail(&port->node, &mxc_gpio_ports);
 
 	return 0;
@@ -418,6 +439,7 @@ static struct platform_driver mxc_gpio_driver = {
 	.driver		= {
 		.name	= "gpio-mxc",
 		.owner	= THIS_MODULE,
+		.of_match_table = mxc_gpio_dt_ids,
 	},
 	.probe		= mxc_gpio_probe,
 	.id_table	= mxc_gpio_devtype,
-- 
1.7.4.1


