Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab2DMWra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 18:47:30 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:31516 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753562Ab2DMWr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 18:47:29 -0400
From: Roland Stigge <stigge@antcom.de>
To: grant.likely@secretlab.ca, arm@kernel.org, linux-kernel@vger.kernel.org,
        x-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v4] gpio: Device tree support for LPC32xx
Date: Sat, 14 Apr 2012 00:47:00 +0200
Message-Id: <1334357220-21238-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support for gpio-lpc32xx.c

Signed-off-by: Roland Stigge <stigge@antcom.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>

---

 Applies to v3.4-rc2

 Changes since last version:
 * Typo fix in documentation
 
 Please note: I kept the handling of the different GPIO banks of LPC32xx via
 multiple GPIO subnodes in the devicetree, therefore using a gpiochip_add() for
 each of those. gpiochip_add() can only be used for applying to a homogeneous
 bank. Since the GPIO banks in LPC32xx are different regarding GPO/GPI/GPIO and
 different callbacks, we need to handle this via different subnodes. (See also
 the definitions in drivers/gpio/gpio-lpc32xx.c)

 Documentation/devicetree/bindings/gpio/gpio_lpc32xx.txt |   65 ++++++++++++++++
 arch/arm/mach-lpc32xx/include/mach/gpio.h               |    9 +-
 drivers/gpio/gpio-lpc32xx.c                             |   52 ++++++++++++
 3 files changed, 123 insertions(+), 3 deletions(-)

--- /dev/null
+++ linux-2.6/Documentation/devicetree/bindings/gpio/gpio_lpc32xx.txt
@@ -0,0 +1,65 @@
+NXP LPC32xx SoC GPIO controller
+
+Required properties:
+- compatible: "nxp,lpc32xx-gpio"
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
+		compatible = "nxp,lpc32xx-gpio";
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
@@ -454,10 +457,55 @@ static struct lpc32xx_gpio_chip lpc32xx_
 	},
 };
 
+/* Empty now, can be removed later when mach-lpc32xx is finally switched over
+ * to DT support
+ */
 void __init lpc32xx_gpio_init(void)
 {
+}
+
+static int __devinit lpc32xx_gpio_probe(struct platform_device *pdev)
+{
+	struct device_node *node;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(lpc32xx_gpiochip); i++)
-		gpiochip_add(&lpc32xx_gpiochip[i].chip);
+	if (pdev->dev.of_node) {
+		for_each_child_of_node(pdev->dev.of_node, node) {
+			if (of_device_is_available(node)) {
+				u32 index;
+				struct gpio_chip *chip;
+				if (of_property_read_u32(node,
+							 "reg", &index) <  0)
+					continue;
+				if (index >= ARRAY_SIZE(lpc32xx_gpiochip))
+					continue;
+				chip = &lpc32xx_gpiochip[index].chip;
+				chip->of_node = of_node_get(node);
+				gpiochip_add(chip);
+			}
+		}
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
+	{ .compatible = "nxp,lpc32xx-gpio", },
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
