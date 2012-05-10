Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761569Ab2EJT5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 15:57:55 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:37829 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761280Ab2EJT5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 15:57:52 -0400
From: Roland Stigge <stigge@antcom.de>
To: grant.likely@secretlab.ca, arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RESEND v8] gpio: Device tree support for LPC32xx
Date: Thu, 10 May 2012 21:57:18 +0200
Message-Id: <1336679838-30738-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support for gpio-lpc32xx.c.

The various GPIO groups correspond to the different irregular GPIO banks of the
LPC32xx hardware. Most importantly, there are the GPI(0-27), GPO(0-23) and
GPIO(0-5) banks. Each bank must be registered individually since they are
implemented with different functions. Registration is done via gpiochip_add()
which requires an individual gpio bank subnode in the device tree for each
call.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>

---

Applies to v3.4-rc6

Changes since last version:
* Updated patch description (above)

Thanks to Jean-Christophe PLAGNIOL-VILLARD, Grant Likely, Arnd Bergmann, Jon
Smirl, Mark Brown for reviewing!

I can also provide a git branch to pull from. On top of which one should I
provide it, if not mainline rc?
 
 Documentation/devicetree/bindings/gpio/gpio_lpc32xx.txt |   65 ++++++++++++++++
 arch/arm/mach-lpc32xx/include/mach/gpio.h               |    9 +-
 drivers/gpio/gpio-lpc32xx.c                             |   56 +++++++++++++
 3 files changed, 127 insertions(+), 3 deletions(-)

--- /dev/null
+++ linux-2.6/Documentation/devicetree/bindings/gpio/gpio_lpc32xx.txt
@@ -0,0 +1,65 @@
+NXP LPC32xx SoC GPIO controller
+
+Required properties:
+- compatible: must be "nxp,lpc3220-gpio"
+- reg: Physical base address and length of the controller's registers.
+- #address-cells: Always 1, for indexing of the subnodes (GPIO groups of the
+  SoC)
+- #size-cells: Always 0
+
+Required properties of sub-nodes which describe the GPIO groups of LPC32xx:
+- gpio-controller: Marks the device node as a GPIO controller.
+- #gpio-cells: Should be two. The first cell is the pin number and the
+  second cell is used to specify optional parameters:
+  - bit 0 specifies polarity (0 for normal, 1 for inverted)
+- reg: Index of the GPIO group
+
+Optional properties of sub-nodes which describe the GPIO groups of LPC32xx:
+- status: Set to "disabled" if you don't use the respective GPIO group
+  of the LPC32xx SoC
+
+Example:
+
+	gpio: gpio@40028000 {
+		compatible = "nxp,lpc3220-gpio";
+		reg = <0x40028000 0x1000>;
+		/* create a private address space for enumeration */
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		gpio_p0: gpio-bank@0 {
+			gpio-controller;
+			#gpio-cells = <2>;
+			reg = <0>;
+		};
+
+		gpio_p1: gpio-bank@1 {
+			gpio-controller;
+			#gpio-cells = <2>;
+			reg = <1>;
+		};
+
+		gpio_p2: gpio-bank@2 {
+			gpio-controller;
+			#gpio-cells = <2>;
+			reg = <2>;
+		};
+
+		gpio_p3: gpio-bank@3 {
+			gpio-controller;
+			#gpio-cells = <2>;
+			reg = <3>;
+		};
+
+		gpi_p3: gpio-bank@4 {
+			gpio-controller;
+			#gpio-cells = <2>;
+			reg = <4>;
+		};
+
+		gpo_p3: gpio-bank@5 {
+			gpio-controller;
+			#gpio-cells = <2>;
+			reg = <5>;
+		};
+	};
--- linux-2.6.orig/arch/arm/mach-lpc32xx/include/mach/gpio.h
+++ linux-2.6/arch/arm/mach-lpc32xx/include/mach/gpio.h
@@ -1 +1,8 @@
-/* empty */
+#ifndef __MACH_GPIO_H
+#define __MACH_GPIO_H
+
+#include "gpio-lpc32xx.h"
+
+#define ARCH_NR_GPIOS (LPC32XX_GPO_P3_GRP + LPC32XX_GPO_P3_MAX)
+
+#endif /* __MACH_GPIO_H */
--- linux-2.6.orig/drivers/gpio/gpio-lpc32xx.c
+++ linux-2.6/drivers/gpio/gpio-lpc32xx.c
@@ -21,6 +21,9 @@
 #include <linux/io.h>
 #include <linux/errno.h>
 #include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
 
 #include <mach/hardware.h>
 #include <mach/platform.h>
@@ -454,10 +457,59 @@ static struct lpc32xx_gpio_chip lpc32xx_
 	},
 };
 
+/* Empty now, can be removed later when mach-lpc32xx is finally switched over
+ * to DT support
+ */
 void __init lpc32xx_gpio_init(void)
 {
+}
+
+static void __devinit lpc32xx_gpiochip_add_dt(struct device_node *node)
+{
+	if (of_device_is_available(node)) {
+		u32 index;
+		struct gpio_chip *chip;
+
+		if (of_property_read_u32(node, "reg", &index) < 0)
+			return;
+		if (index >= ARRAY_SIZE(lpc32xx_gpiochip))
+			return;
+		chip = &lpc32xx_gpiochip[index].chip;
+		chip->of_node = of_node_get(node);
+		gpiochip_add(chip);
+	}
+}
+
+static int __devinit lpc32xx_gpio_probe(struct platform_device *pdev)
+{
+	struct device_node *node;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(lpc32xx_gpiochip); i++)
-		gpiochip_add(&lpc32xx_gpiochip[i].chip);
+	if (pdev->dev.of_node) {
+		for_each_child_of_node(pdev->dev.of_node, node)
+			lpc32xx_gpiochip_add_dt(node);
+	} else {
+		for (i = 0; i < ARRAY_SIZE(lpc32xx_gpiochip); i++)
+			gpiochip_add(&lpc32xx_gpiochip[i].chip);
+	}
+
+	return 0;
 }
+
+#ifdef CONFIG_OF
+static struct of_device_id lpc32xx_gpio_of_match[] __devinitdata = {
+	{ .compatible = "nxp,lpc3220-gpio", },
+	{ },
+};
+#endif
+
+static struct platform_driver lpc32xx_gpio_driver = {
+	.driver		= {
+		.name	= "lpc32xx-gpio",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(lpc32xx_gpio_of_match),
+	},
+	.probe		= lpc32xx_gpio_probe,
+};
+
+module_platform_driver(lpc32xx_gpio_driver);
