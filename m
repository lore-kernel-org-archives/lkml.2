Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965958Ab2EQUEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 16:04:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56851 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab2EQUEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 16:04:31 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Roland Stigge <stigge@antcom.de>, Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/3] gpio/lpc32xx: Add device tree support
Date: Thu, 17 May 2012 14:04:19 -0600
Message-Id: <1337285060-31919-2-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337285060-31919-1-git-send-email-grant.likely@secretlab.ca>
References: <1337285060-31919-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Stigge <stigge@antcom.de>

This patch adds device tree support for gpio-lpc32xx.c.

To register the various GPIO banks as (struct) gpio_chips via the same DT
gpio-controller, we utilize the adjusted of_xlate API to manipulate the
actually used struct gpio_chip.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 .../devicetree/bindings/gpio/gpio_lpc32xx.txt      |   43 +++++++++++++++
 arch/arm/mach-lpc32xx/include/mach/gpio.h          |    9 +++-
 drivers/gpio/gpio-lpc32xx.c                        |   55 +++++++++++++++++++-
 3 files changed, 105 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio_lpc32xx.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio_lpc32xx.txt b/Documentation/devicetree/bindings/gpio/gpio_lpc32xx.txt
new file mode 100644
index 0000000..4981936
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio_lpc32xx.txt
@@ -0,0 +1,43 @@
+NXP LPC32xx SoC GPIO controller
+
+Required properties:
+- compatible: must be "nxp,lpc3220-gpio"
+- reg: Physical base address and length of the controller's registers.
+- gpio-controller: Marks the device node as a GPIO controller.
+- #gpio-cells: Should be 3:
+   1) bank:
+      0: GPIO P0
+      1: GPIO P1
+      2: GPIO P2
+      3: GPIO P3
+      4: GPI P3
+      5: GPO P3
+   2) pin number
+   3) optional parameters:
+      - bit 0 specifies polarity (0 for normal, 1 for inverted)
+- reg: Index of the GPIO group
+
+Example:
+
+	gpio: gpio@40028000 {
+		compatible = "nxp,lpc3220-gpio";
+		reg = <0x40028000 0x1000>;
+		gpio-controller;
+		#gpio-cells = <3>; /* bank, pin, flags */
+	};
+
+	leds {
+		compatible = "gpio-leds";
+
+		led0 {
+			gpios = <&gpio 5 1 1>; /* GPO_P3 1, active low */
+			linux,default-trigger = "heartbeat";
+			default-state = "off";
+		};
+
+		led1 {
+			gpios = <&gpio 5 14 1>; /* GPO_P3 14, active low */
+			linux,default-trigger = "timer";
+			default-state = "off";
+		};
+	};
diff --git a/arch/arm/mach-lpc32xx/include/mach/gpio.h b/arch/arm/mach-lpc32xx/include/mach/gpio.h
index 40a8c17..2ba6ca4 100644
--- a/arch/arm/mach-lpc32xx/include/mach/gpio.h
+++ b/arch/arm/mach-lpc32xx/include/mach/gpio.h
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
diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
index 61c2d08..d42bf6c 100644
--- a/drivers/gpio/gpio-lpc32xx.c
+++ b/drivers/gpio/gpio-lpc32xx.c
@@ -21,6 +21,9 @@
 #include <linux/io.h>
 #include <linux/errno.h>
 #include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
 
 #include <mach/hardware.h>
 #include <mach/platform.h>
@@ -454,10 +457,60 @@ static struct lpc32xx_gpio_chip lpc32xx_gpiochip[] = {
 	},
 };
 
+/* Empty now, can be removed later when mach-lpc32xx is finally switched over
+ * to DT support
+ */
 void __init lpc32xx_gpio_init(void)
 {
+}
+
+static int lpc32xx_of_xlate(struct gpio_chip **gc,
+			    const struct of_phandle_args *gpiospec, u32 *flags)
+{
+	u32 bank;
+	if (WARN_ON(gpiospec->args_count < 3))
+		return -EINVAL;
+
+	bank = gpiospec->args[0];
+	if (WARN_ON(bank > 5))
+		return -EINVAL;
+
+	*gc = &lpc32xx_gpiochip[bank].chip;
+	if (flags)
+		*flags = gpiospec->args[2];
+	return gpiospec->args[1];
+}
+
+static int __devinit lpc32xx_gpio_probe(struct platform_device *pdev)
+{
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(lpc32xx_gpiochip); i++)
+	for (i = 0; i < ARRAY_SIZE(lpc32xx_gpiochip); i++) {
+		if (pdev->dev.of_node) {
+			lpc32xx_gpiochip[i].chip.of_xlate = lpc32xx_of_xlate;
+			lpc32xx_gpiochip[i].chip.of_gpio_n_cells = 3;
+			lpc32xx_gpiochip[i].chip.of_node = pdev->dev.of_node;
+		}
 		gpiochip_add(&lpc32xx_gpiochip[i].chip);
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
-- 
1.7.9.5

