Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761946Ab2ERIR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:17:56 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:31018 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758969Ab2ERIRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:17:50 -0400
From: Roland Stigge <stigge@antcom.de>
To: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 2/2] gpio: Device tree support for LPC32xx
Date: Fri, 18 May 2012 10:17:41 +0200
Message-Id: <1337329065-5567-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1337285060-31919-1-git-send-email-grant.likely@secretlab.ca>
References: <1337285060-31919-1-git-send-email-grant.likely@secretlab.ca>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support for gpio-lpc32xx.c.

To register the various GPIO banks as (struct) gpio_chips via the same DT
gpio-controller, we utilize the adjusted of_xlate API to manipulate the
actually used struct gpio_chip.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

---

Thanks to Jean-Christophe PLAGNIOL-VILLARD, Grant Likely, Arnd Bergmann, Jon
Smirl, Mark Brown for reviewing!

You can also pull from:
  git://git.antcom.de/linux-2.6.git dt/gpio
  http://git.antcom.de/linux-2.6.git dt/gpio
  http://git.antcom.de/?p=linux-2.6.git;a=shortlog;h=refs/heads/dt/gpio

 Documentation/devicetree/bindings/gpio/gpio_lpc32xx.txt |   43 +++++++++++++
 arch/arm/mach-lpc32xx/include/mach/gpio.h               |    9 ++
 drivers/gpio/gpio-lpc32xx.c                             |   52 +++++++++++++++-
 3 files changed, 102 insertions(+), 2 deletions(-)

--- /dev/null
+++ linux-2.6/Documentation/devicetree/bindings/gpio/gpio_lpc32xx.txt
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
@@ -454,10 +457,57 @@ static struct lpc32xx_gpio_chip lpc32xx_
 	},
 };
 
+/* Empty now, can be removed later when mach-lpc32xx is finally switched over
+ * to DT support
+ */
 void __init lpc32xx_gpio_init(void)
 {
+}
+
+static int lpc32xx_of_xlate(struct gpio_chip *gc,
+			    const struct of_phandle_args *gpiospec, u32 *flags)
+{
+	/* Is this the correct bank? */
+	u32 bank = gpiospec->args[0];
+	if ((bank > ARRAY_SIZE(lpc32xx_gpiochip) ||
+	    (gc != &lpc32xx_gpiochip[bank].chip)))
+		return -EINVAL;
+
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
