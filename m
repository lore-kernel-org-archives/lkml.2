Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab2ALHig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 02:38:36 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29970 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab2ALHi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 02:38:27 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-e6-4f0e8df1b08c
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, lars@metafoo.de, patches@linaro.org
Subject: [PATCH v2 1/2] backlight: lcd: add driver for raster-type lcd's with
 gpio controlled panel reset
Date: Thu, 12 Jan 2012 13:13:30 +0530
Message-id: <1326354211-27064-2-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1326354211-27064-1-git-send-email-thomas.abraham@linaro.org>
References: <1326354211-27064-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a lcd panel driver for simple raster-type lcd's which uses a gpio
controlled panel reset. The driver controls the nRESET line of the panel
using a gpio connected from the host system. The Vcc supply to the panel
is (optionally) controlled using a voltage regulator. This driver excludes
support for lcd panels that use a serial command interface or direct
memory mapped IO interface.

Suggested-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 .../devicetree/bindings/lcd/lcd-pwrctrl.txt        |   48 ++++
 drivers/video/backlight/Kconfig                    |    7 +
 drivers/video/backlight/Makefile                   |    1 +
 drivers/video/backlight/lcd_pwrctrl.c              |  232 ++++++++++++++++++++
 include/video/lcd_pwrctrl.h                        |   34 +++
 5 files changed, 322 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/lcd/lcd-pwrctrl.txt
 create mode 100644 drivers/video/backlight/lcd_pwrctrl.c
 create mode 100644 include/video/lcd_pwrctrl.h

diff --git a/Documentation/devicetree/bindings/lcd/lcd-pwrctrl.txt b/Documentation/devicetree/bindings/lcd/lcd-pwrctrl.txt
new file mode 100644
index 0000000..171ea04
--- /dev/null
+++ b/Documentation/devicetree/bindings/lcd/lcd-pwrctrl.txt
@@ -0,0 +1,48 @@
+* Power controller for simple lcd panels
+
+Some LCD panels provide a simple control interface for the host system. The
+control mechanism would include a nRESET line connected to a gpio of the host
+system and a Vcc supply line which the host can optionally be controlled using
+a voltage regulator. Such simple panels do not support serial command
+interface (such as i2c or spi) or memory-mapped-io interface.
+
+Required properties:
+- compatible: should be 'lcd-powercontrol'
+
+- lcd-reset-gpio: The GPIO number of the host system used to control the
+  nRESET line. The format of the gpio specifier depends on the gpio controller
+  of the host system.
+
+Optional properties:
+- lcd-reset-active-high: When the nRESET line is asserted low, the lcd panel
+  is reset and stays in reset mode as long as the nRESET line is asserted low.
+  This is the default behaviour of most lcd panels. If a lcd panel requires the
+  nRESET line to be asserted high for panel reset, then this property is used.
+  Note: Some platforms might allow inverting the polarity of the gpio output
+  in the 'lcd-reset-gpio' gpio specifier. On such platforms, if the polarity
+  is used to control the output of the gpio, then this property should not be
+  used.
+
+- lcd-power-min-uV: If the output volatge of the regulator that controls Vcc
+  of the panel needs to be set, then this property should be used. This property
+  specifies the minimum voltage the regulator should supply. The value of this
+  property should in in micro-volts.
+
+- lcd-power-max-uV: If the output volatge of the regulator that controls Vcc
+  of the panel needs to be set, then this property should be used. This property
+  specifies the maximum voltage the regulator should limit to on the Vcc line.
+  The value of this property should in in micro-volts.
+
+- vcc-lcd-supply: phandle of the regulator that controls the vcc supply to
+  the lcd panel.
+
+Example:
+
+	lcd_pwrctrl {
+		compatible = "lcd-powercontrol";
+		lcd-reset-gpio = <&gpe0 4 1 0 0>;
+		lcd-reset-active-high;
+		lcd-power-min-uV = <2500000>;
+		lcd-power-max-uV = <3300000>;
+		lcd-vcc-supply = <&regulator7>;
+	};
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 278aeaa..fc1dc17 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -86,6 +86,13 @@ config LCD_PLATFORM
 	  This driver provides a platform-device registered LCD power
 	  control interface.
 
+config LCD_PWRCTRL
+	tristate "LCD panel power control"
+	help
+	  Say y here, if you have a lcd panel that allows reset and vcc to be
+	  controlled by the host system, and which does not use a serial command
+	  interface (such as i2c or spi) or memory-mapped-io interface.
+
 config LCD_TOSA
 	tristate "Sharp SL-6000 LCD Driver"
 	depends on SPI && MACH_TOSA
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index fdd1fc4..5dfcf5f 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_LCD_LMS283GF05)	   += lms283gf05.o
 obj-$(CONFIG_LCD_LTV350QV)	   += ltv350qv.o
 obj-$(CONFIG_LCD_ILI9320)	   += ili9320.o
 obj-$(CONFIG_LCD_PLATFORM)	   += platform_lcd.o
+obj-$(CONFIG_LCD_PWRCTRL)	   += lcd_pwrctrl.o
 obj-$(CONFIG_LCD_VGG2432A4)	   += vgg2432a4.o
 obj-$(CONFIG_LCD_TDO24M)	   += tdo24m.o
 obj-$(CONFIG_LCD_TOSA)		   += tosa_lcd.o
diff --git a/drivers/video/backlight/lcd_pwrctrl.c b/drivers/video/backlight/lcd_pwrctrl.c
new file mode 100644
index 0000000..a02455f
--- /dev/null
+++ b/drivers/video/backlight/lcd_pwrctrl.c
@@ -0,0 +1,232 @@
+/*
+ * Simple lcd panel power control driver.
+ *
+ * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2011-2012 Linaro Ltd.
+ *
+ * This driver is for controlling power for raster type lcd panels that requires
+ * its nRESET interface line to be connected and controlled by a GPIO of the
+ * host system and the Vcc line controlled by a voltage regulator.  This
+ * excludes support for lcd panels that use a serial command interface or direct
+ * memory mapped IO interface.
+ *
+ * The nRESET interface line of the panel should be connected to a gpio of the
+ * host system. The Vcc pin is controlled using a external volatage regulator.
+ * Panel backlight is not controlled by this driver.
+ *
+ * This driver is derived from platform-lcd.c which was written by
+ * Ben Dooks <ben@simtec.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+*/
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/fb.h>
+#include <linux/lcd.h>
+#include <linux/gpio.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/regulator/consumer.h>
+#include <video/lcd_pwrctrl.h>
+
+struct lcd_pwrctrl {
+	struct device		*dev;
+	struct lcd_device	*lcd;
+	struct lcd_pwrctrl_data	*pdata;
+	struct regulator	*regulator;
+	unsigned int		power;
+	bool			suspended;
+	bool			pwr_en;
+};
+
+static int lcd_pwrctrl_get_power(struct lcd_device *lcd)
+{
+	struct lcd_pwrctrl *lp = lcd_get_data(lcd);
+	return lp->power;
+}
+
+static int lcd_pwrctrl_set_power(struct lcd_device *lcd, int power)
+{
+	struct lcd_pwrctrl *lp = lcd_get_data(lcd);
+	struct lcd_pwrctrl_data *pd = lp->pdata;
+	bool lcd_enable;
+	int lcd_reset;
+
+	lcd_enable = (power == FB_BLANK_POWERDOWN || lp->suspended) ? 0 : 1;
+	lcd_reset = (pd->invert) ? !lcd_enable : lcd_enable;
+
+	if (lp->pwr_en == lcd_enable)
+		return 0;
+
+	if (!IS_ERR_OR_NULL(lp->regulator)) {
+		if (lcd_enable) {
+			/* set regulator voltage if specified */
+			if (pd->min_uV || pd->max_uV)
+				if (regulator_set_voltage(lp->regulator,
+						pd->min_uV, pd->max_uV))
+					dev_info(lp->dev,
+						"voltage set failed\n");
+			if (regulator_enable(lp->regulator))
+				dev_info(lp->dev, "regulator enable failed\n");
+		} else {
+			regulator_disable(lp->regulator);
+		}
+	}
+
+	gpio_direction_output(lp->pdata->gpio, lcd_reset);
+	lp->power = power;
+	lp->pwr_en = lcd_enable;
+	return 0;
+}
+
+static int lcd_pwrctrl_check_fb(struct lcd_device *lcd, struct fb_info *info)
+{
+	struct lcd_pwrctrl *lp = lcd_get_data(lcd);
+	return lp->dev->parent == info->device;
+}
+
+static struct lcd_ops lcd_pwrctrl_ops = {
+	.get_power	= lcd_pwrctrl_get_power,
+	.set_power	= lcd_pwrctrl_set_power,
+	.check_fb	= lcd_pwrctrl_check_fb,
+};
+
+#ifdef CONFIG_OF
+static void __devinit lcd_pwrctrl_parse_dt(struct device *dev,
+					struct lcd_pwrctrl_data *pdata)
+{
+	struct device_node *np = dev->of_node;
+
+	pdata->gpio = of_get_named_gpio(np, "lcd-reset-gpio", 0);
+	if (of_get_property(np, "lcd-reset-active-high", NULL))
+		pdata->invert = true;
+	of_property_read_u32(np, "lcd-power-min-uV", &pdata->min_uV);
+	of_property_read_u32(np, "lcd-power-max-uV", &pdata->max_uV);
+}
+#endif
+
+static int __devinit lcd_pwrctrl_probe(struct platform_device *pdev)
+{
+	struct lcd_pwrctrl *lp;
+	struct lcd_pwrctrl_data *pdata = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	int err;
+
+#ifdef CONFIG_OF
+	if (dev->of_node) {
+		pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+		if (!pdata) {
+			dev_err(dev, "memory allocation for pdata failed\n");
+			return -ENOMEM;
+		}
+		lcd_pwrctrl_parse_dt(dev, pdata);
+	}
+#endif
+
+	if (!pdata) {
+		dev_err(dev, "platform data not available\n");
+		return -EINVAL;
+	}
+
+	lp = devm_kzalloc(dev, sizeof(struct lcd_pwrctrl), GFP_KERNEL);
+	if (!lp) {
+		dev_err(dev, "memory allocation failed for private data\n");
+		return -ENOMEM;
+	}
+
+	err = gpio_request(pdata->gpio, "LCD-nRESET");
+	if (err) {
+		dev_err(dev, "gpio [%d] request failed\n", pdata->gpio);
+		return err;
+	}
+
+	/*
+	 * If power to lcd and/or lcd interface is controlled using a regulator,
+	 * get the handle to the regulator for later use during power switching.
+	 */
+	lp->regulator = regulator_get(dev, "vcc-lcd");
+	if (IS_ERR(lp->regulator))
+		dev_info(dev, "could not find regulator\n");
+
+	lp->dev = dev;
+	lp->pdata = pdata;
+	lp->lcd = lcd_device_register(dev_name(dev), dev, lp, &lcd_pwrctrl_ops);
+	if (IS_ERR(lp->lcd)) {
+		dev_err(dev, "cannot register lcd device\n");
+		regulator_put(lp->regulator);
+		gpio_free(pdata->gpio);
+		return PTR_ERR(lp->lcd);
+	}
+
+	platform_set_drvdata(pdev, lp);
+	lcd_pwrctrl_set_power(lp->lcd, FB_BLANK_NORMAL);
+	return 0;
+}
+
+static int __devexit lcd_pwrctrl_remove(struct platform_device *pdev)
+{
+	struct lcd_pwrctrl *lp = platform_get_drvdata(pdev);
+	lcd_device_unregister(lp->lcd);
+	gpio_free(lp->pdata->gpio);
+	if (!IS_ERR(lp->regulator))
+		regulator_put(lp->regulator);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int lcd_pwrctrl_suspend(struct device *dev)
+{
+	struct lcd_pwrctrl *lp = dev_get_drvdata(dev);
+
+	lp->suspended = true;
+	lcd_pwrctrl_set_power(lp->lcd, FB_BLANK_POWERDOWN);
+	return 0;
+}
+
+static int lcd_pwrctrl_resume(struct device *dev)
+{
+	struct lcd_pwrctrl *lp = dev_get_drvdata(dev);
+
+	lp->suspended = false;
+	lcd_pwrctrl_set_power(lp->lcd, FB_BLANK_UNBLANK);
+	return 0;
+}
+
+static const struct dev_pm_ops lcd_pwrctrl_dev_pm_ops = {
+	.suspend	= lcd_pwrctrl_suspend,
+	.resume		= lcd_pwrctrl_resume,
+};
+
+#define LCD_PWRCTRL_DEV_PM_OPS	(&lcd_pwrctrl_dev_pm_ops)
+#else
+#define LCD_PWRCTRL_DEV_PM_OPS	NULL
+#endif /* CONFIG_PM */
+
+#ifdef CONFIG_OF
+static const struct of_device_id lcd_pwrctrl_match[] = {
+	{ .compatible = "lcd-powercontrol", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, lcd_pwrctrl_match);
+#endif
+
+static struct platform_driver lcd_pwrctrl_driver = {
+	.driver		= {
+		.name	= "lcd-pwrctrl",
+		.owner	= THIS_MODULE,
+		.pm	= LCD_PWRCTRL_DEV_PM_OPS,
+		.of_match_table	= of_match_ptr(lcd_pwrctrl_match),
+	},
+	.probe		= lcd_pwrctrl_probe,
+	.remove		= lcd_pwrctrl_remove,
+};
+
+module_platform_driver(lcd_pwrctrl_driver);
+
+MODULE_AUTHOR("Thomas Abraham <thomas.ab@samsung.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:lcd-pwrctrl");
diff --git a/include/video/lcd_pwrctrl.h b/include/video/lcd_pwrctrl.h
new file mode 100644
index 0000000..2c07725
--- /dev/null
+++ b/include/video/lcd_pwrctrl.h
@@ -0,0 +1,34 @@
+/*
+ * Simple lcd panel power control driver.
+ *
+ * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2011-2012 Linaro Ltd.
+ *
+ * This driver is derived from platform-lcd.h which was written by
+ * Ben Dooks <ben@simtec.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+*/
+
+/**
+ * struct lcd_pwrctrl_data - platform data for lcd_pwrctrl driver.
+ * @gpio: GPIO number of the host system that connects to nRESET line.
+ * @invert: True, if output of gpio connected to nRESET should be inverted.
+ * @min_uV: Minimum required voltage output from the regulator. The voltage
+ *   should be specified in micro-volts. If the regulator does not support
+ *   setting of voltage or if required voltage is pre-configured, then the
+ *   value should be 0.
+ * @max_uV: Maximum acceptable voltage output from the regulator. The voltage
+ *   should be specified in micro-volts. If the regulator does not support
+ *   setting of voltage or if required voltage is pre-configured, then the
+ *   value should be 0.
+ */
+struct lcd_pwrctrl_data {
+	int		gpio;
+	bool		invert;
+	int		min_uV;
+	int		max_uV;
+};
-- 
1.6.6.rc2

