Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965150Ab2KVTSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:18:51 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56334 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396Ab2KVTSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:18:13 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Rob Landley <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH] gpio: New driver for GPO emulation using PWM generators
Date: Thu, 22 Nov 2012 14:42:03 +0100
Message-ID: <1353591723-25233-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seams to be board designs using PWM generators as enable/disable signals.
For these boards we used to have custom code as hacks to deal with such a
situations.
With the gpio-pwm driver we can emulate the GPIO functionality using PWM
generators via standard interfaces. The PWM will be configured to be off
when the GPIO is off and to full duty cycle when the GPIO is requested to be
on.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
Hi Linus,

So this is the driver I came up regarding to the issue that some boards
(BeagleBoard for example) are using the PWM generators as enable/disable signal.

On BeagleBoard the situation is like this:
TWL4030 PWMA -> TWL4030 LEDA -> nUSBHOST_PWR_EN -> external power switch -> USB
host hub power.

So I have tested this driver on BeagleBoard:
- Custom code to toggle the GPIO just to see if it switches correctly

- Real life usecase:
fixed voltage regulator with GPIO control (the gpio is the gpio-pwm provided).
ehci-omap has been modified to allow deferred probe.
the regulator is used by ehci-omap.

All works fine.

Regards,
Peter

 .../devicetree/bindings/gpio/gpio-pwm.txt          |  29 +++
 drivers/gpio/Kconfig                               |  12 +
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-pwm.c                            | 264 +++++++++++++++++++++
 include/linux/platform_data/gpio-pwm.h             |  16 ++
 5 files changed, 322 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-pwm.txt
 create mode 100644 drivers/gpio/gpio-pwm.c
 create mode 100644 include/linux/platform_data/gpio-pwm.h

diff --git a/Documentation/devicetree/bindings/gpio/gpio-pwm.txt b/Documentation/devicetree/bindings/gpio/gpio-pwm.txt
new file mode 100644
index 0000000..2569cd5
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-pwm.txt
@@ -0,0 +1,29 @@
+GPO driver using PWM generators
+
+Required properties:
+- compatible : "pwm-gpo"
+- #gpio-cells : Should be one.
+- gpio-controller : Marks the device node as a GPIO controller.
+- pwms : PWM property, please refer to:
+  Documentation/devicetree/bindings/pwm/pwm.txt
+- pwm-names : (optional) Name to be used by the PWM subsystem for the PWM device
+
+Example:
+
+twl_pwm: pwm {
+	compatible = "ti,twl4030-pwmled";
+	#pwm-cells = <2>;
+};
+
+pwm_gpo1: gpo1 {
+	compatible = "pwm-gpo";
+	#gpio-cells = <1>;
+	gpio-controller;
+	pwms = <&twl_pwm 0 7812500>;
+	pwm-names = "nUSBHOST_PWR_EN";
+};
+
+user@1 {
+	compatible = "example,testuser";
+	gpios = <&pwm_gpo1 0>;
+};
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 47150f5..d68c429 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -649,4 +649,16 @@ config GPIO_MSIC
 	  Enable support for GPIO on intel MSIC controllers found in
 	  intel MID devices
 
+comment "Miscellaneous GPIO implementations"
+
+config GPIO_PWM
+	tristate "GPO emulation using PWM generators"
+	depends on PWM
+	help
+	  When a signal from a PWM generator is used as enable/disable signal
+	  this driver will emulate a GPIO over the PWM driver.
+	  When the GPIO is requested to be on the PWM will be configured for
+	  full duty cycle, when the GPIO is requested to be off the PWM will be
+	  turned off.
+
 endif
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 9aeed67..f507901 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_GPIO_PCA953X)	+= gpio-pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= gpio-pcf857x.o
 obj-$(CONFIG_GPIO_PCH)		+= gpio-pch.o
 obj-$(CONFIG_GPIO_PL061)	+= gpio-pl061.o
+obj-$(CONFIG_GPIO_PWM)		+= gpio-pwm.o
 obj-$(CONFIG_GPIO_PXA)		+= gpio-pxa.o
 obj-$(CONFIG_GPIO_RC5T583)	+= gpio-rc5t583.o
 obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
diff --git a/drivers/gpio/gpio-pwm.c b/drivers/gpio/gpio-pwm.c
new file mode 100644
index 0000000..de38d8b
--- /dev/null
+++ b/drivers/gpio/gpio-pwm.c
@@ -0,0 +1,264 @@
+/*
+ * Simple driver to allow PWMs to be used as GPO (General Purpose Output)
+ *
+ * The PWM will be turned off completely or configured for full on based on the
+ * gpio state request.
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/gpio.h>
+#include <linux/pwm.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/platform_data/gpio-pwm.h>
+
+struct gpo_pwm_data {
+	const char *name;
+	struct pwm_device *pwm;
+	unsigned int pwm_period_ns;
+	bool enabled;
+};
+
+struct gpo_pwm_priv {
+	struct gpio_chip gpio_chip;
+	int num_gpos;
+	struct gpo_pwm_data gpos[];
+};
+
+static inline struct gpo_pwm_priv *to_pwm_gpo(struct gpio_chip *chip)
+{
+	return container_of(chip, struct gpo_pwm_priv, gpio_chip);
+}
+
+static int gpo_pwm_request(struct gpio_chip *chip, unsigned offset)
+{
+	struct gpo_pwm_priv *priv = to_pwm_gpo(chip);
+	struct gpo_pwm_data *gpo = &priv->gpos[offset];
+	int ret;
+
+	if (gpo->pwm) {
+		dev_err(chip->dev, "GPIO%d has been already requested\n",
+			chip->base + offset);
+		return -EBUSY;
+	}
+	gpo->pwm = pwm_get(chip->dev, gpo->name);
+	ret = IS_ERR(gpo->pwm);
+	if (ret) {
+		gpo->pwm = NULL;
+		return ret;
+	}
+
+	/* If period_ns is not set yet, try to get it via pwm framework */
+	if (!gpo->pwm_period_ns)
+		gpo->pwm_period_ns = pwm_get_period(gpo->pwm);
+
+	return ret;
+}
+
+static void gpo_pwm_free(struct gpio_chip *chip, unsigned offset)
+{
+	struct gpo_pwm_priv *priv = to_pwm_gpo(chip);
+
+	if (priv->gpos[offset].pwm) {
+		pwm_put(priv->gpos[offset].pwm);
+		priv->gpos[offset].pwm = NULL;
+	}
+}
+
+static void gpo_pwm_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct gpo_pwm_priv *priv = to_pwm_gpo(chip);
+	struct gpo_pwm_data *gpo = &priv->gpos[offset];
+
+	if (!gpo->pwm) {
+		dev_err(chip->dev, "GPIO%d has not been requested\n",
+			chip->base + offset);
+		return;
+	}
+
+	if (unlikely(!gpo->pwm_period_ns)) {
+		dev_err(chip->dev, "pwm period_ns is not set for GPIO%d\n",
+			chip->base + offset);
+		return;
+	}
+
+	if (value) {
+		/* Set PWM to full on */
+		pwm_config(gpo->pwm, gpo->pwm_period_ns, gpo->pwm_period_ns);
+		pwm_enable(gpo->pwm);
+		gpo->enabled = 1;
+	} else {
+		/* Disable PWM */
+		pwm_config(gpo->pwm, 0, gpo->pwm_period_ns);
+		pwm_disable(gpo->pwm);
+		gpo->enabled = 0;
+	}
+}
+
+static int gpo_pwm_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct gpo_pwm_priv *priv = to_pwm_gpo(chip);
+
+	return priv->gpos[offset].enabled;
+}
+
+static int gpo_pwm_direction_out(struct gpio_chip *chip, unsigned offset,
+				    int value)
+{
+	/* This only drives GPOs, and can't change direction */
+	gpo_pwm_set(chip, offset, value);
+	return 0;
+}
+
+static struct gpio_chip template_chip = {
+	.label			= "pwm-gpo",
+	.owner			= THIS_MODULE,
+	.request		= gpo_pwm_request,
+	.free			= gpo_pwm_free,
+	.get			= gpo_pwm_get,
+	.direction_output	= gpo_pwm_direction_out,
+	.set			= gpo_pwm_set,
+	.can_sleep		= 1,
+};
+
+static inline int sizeof_gpo_pwm_priv(int num_gpos)
+{
+	return sizeof(struct gpo_pwm_priv) +
+		      (sizeof(struct gpo_pwm_data) * num_gpos);
+}
+
+static struct gpo_pwm_priv *gpo_pwm_create_of(struct platform_device *pdev)
+{
+	struct gpo_pwm_priv *priv;
+
+	/* With DT boot we support one GPO per gpo-pwm device */
+	priv = devm_kzalloc(&pdev->dev, sizeof_gpo_pwm_priv(1),
+			    GFP_KERNEL);
+	if (!priv)
+		return NULL;
+
+	priv->gpio_chip = template_chip;
+	priv->gpio_chip.base = -1;
+#ifdef CONFIG_OF_GPIO
+	priv->gpio_chip.of_node = pdev->dev.of_node;
+#endif
+
+	return priv;
+}
+
+static int __devinit gpo_pwm_probe(struct platform_device *pdev)
+{
+	struct gpio_pwm_pdata *pdata = pdev->dev.platform_data;
+	struct gpo_pwm_priv *priv;
+	int i, ret = 0;
+
+	if (pdata && pdata->num_gpos) {
+		priv = devm_kzalloc(&pdev->dev,
+				    sizeof_gpo_pwm_priv(pdata->num_gpos),
+				    GFP_KERNEL);
+		if (!priv)
+			return -ENOMEM;
+
+		for (i = 0; i < pdata->num_gpos; i++) {
+			struct gpio_pwm *cur_gpo = &pdata->gpos[i];
+			struct gpo_pwm_data *gpo = &priv->gpos[i];
+
+			gpo->name = cur_gpo->name;
+			gpo->pwm_period_ns = cur_gpo->pwm_period_ns;
+		}
+
+		priv->num_gpos = pdata->num_gpos;
+		priv->gpio_chip = template_chip;
+		priv->gpio_chip.base = pdata->gpio_base ? pdata->gpio_base : -1;
+	} else if (pdev->dev.of_node) {
+		priv = gpo_pwm_create_of(pdev);
+		if (!priv)
+			return -ENODEV;
+	} else {
+		dev_err(&pdev->dev, "missing pdata\n");
+		return -ENODEV;
+	}
+
+	priv->gpio_chip.ngpio = priv->num_gpos;
+	priv->gpio_chip.dev = &pdev->dev;
+
+	/*
+	 * Try to get the PWMs at probe time to see if the drivers are loaded.
+	 * This way we can take advantage of deferred probe to make sure that
+	 * the needed PWM drivers are in place.
+	 */
+	for (i = 0; i < priv->num_gpos; i++) {
+		struct gpo_pwm_data *gpo = &priv->gpos[i];
+
+		gpo->pwm = devm_pwm_get(&pdev->dev, gpo->name);
+		if (IS_ERR(gpo->pwm)) {
+			dev_err(&pdev->dev, "unable to request PWM\n");
+			return PTR_ERR(gpo->pwm);
+		}
+		pwm_put(gpo->pwm);
+		gpo->pwm = NULL;
+	}
+
+	ret = gpiochip_add(&priv->gpio_chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "could not register gpiochip, %d\n", ret);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, priv);
+
+	if (pdata && pdata->setup)
+		ret = pdata->setup(&pdev->dev, priv->gpio_chip.base,
+				   priv->num_gpos);
+
+	return ret;
+}
+
+static int __devexit gpo_pwm_remove(struct platform_device *pdev)
+{
+	struct gpo_pwm_priv *priv = platform_get_drvdata(pdev);
+
+	return gpiochip_remove(&priv->gpio_chip);
+}
+
+static const struct of_device_id of_gpo_pwm_match[] = {
+	{ .compatible = "pwm-gpo", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, of_gpo_pwm_match);
+
+static struct platform_driver gpo_pwm_driver = {
+	.driver = {
+		.name	= "pwm-gpo",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(of_gpo_pwm_match),
+	},
+	.probe		= gpo_pwm_probe,
+	.remove		= gpo_pwm_remove,
+};
+
+module_platform_driver(gpo_pwm_driver);
+
+MODULE_AUTHOR("Peter Ujfalusi <peter.ujfalusi@ti.com>");
+MODULE_DESCRIPTION("Driver for PWM generators used as GPO");
+MODULE_ALIAS("platform:pwm-gpo");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/platform_data/gpio-pwm.h b/include/linux/platform_data/gpio-pwm.h
new file mode 100644
index 0000000..824301b
--- /dev/null
+++ b/include/linux/platform_data/gpio-pwm.h
@@ -0,0 +1,16 @@
+#ifndef __GPIO_PWM_H__
+#define __GPIO_PWM_H__
+
+struct gpio_pwm {
+	char *name; /* to be used as unique string when requesting the PWM */
+	unsigned int pwm_period_ns;
+};
+
+struct gpio_pwm_pdata {
+	int gpio_base;
+	int num_gpos;
+	struct gpio_pwm	*gpos;
+	int (*setup)(struct device *dev, unsigned gpio, unsigned ngpio);
+};
+
+#endif /* __GPIO_PWM_H__ */
-- 
1.8.0

