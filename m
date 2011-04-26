Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1DZK01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:26:27 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:40579 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab1DZK00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:26:26 -0400
X-SpamScore: 1
X-BigFish: VPS1(zz936eKc8kzz1202hzz8275bh84d07hz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.kpit.com;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Date: Tue, 26 Apr 2011 15:56:01 +0530
Subject: [PATCHv1 -next] LEDS: LED module of DA9052 PMIC driver
Thread-Topic: [PATCHv1 -next] LEDS: LED module of DA9052 PMIC driver
Thread-Index: AcwD/Fb0wleH2cPPS1KdTVc7Bf4Tvw==
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B89B0E8@KCINPUNHJCMS01.kpit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3QAQhOt016991

Hi,

LED Driver for Dialog Semiconductor DA9052 PMICs.

Changes made since last submission:
. used 'flags' field of led_platform_data to pass the led index

Signed-off-by: Dajun Chen <dchen@diasemi.com>
---

diff -Naur linux-next-20110421.orig/drivers/leds/Kconfig linux-next-20110421/drivers/leds/Kconfig
--- linux-next-20110421.orig/drivers/leds/Kconfig	2011-04-26 09:32:34.000000000 +0500
+++ linux-next-20110421/drivers/leds/Kconfig	2011-04-26 10:02:16.000000000 +0500
@@ -284,6 +284,14 @@
 	  This option enables support for on-chip LED drivers found
 	  on Dialog Semiconductor DA9030/DA9034 PMICs.

+config LEDS_DA9052
+	tristate "Dialog DA9052 LEDS"
+	depends on LEDS_CLASS
+	depends on PMIC_DA9052
+	help
+	  This option enables support for on-chip LED drivers found
+	  on Dialog Semiconductor DA9052 PMICs
+
 config LEDS_DAC124S085
 	tristate "LED Support for DAC124S085 SPI DAC"
 	depends on LEDS_CLASS
diff -Naur linux-next-20110421.orig/drivers/leds/leds-da9052.c linux-next-20110421/drivers/leds/leds-da9052.c
--- linux-next-20110421.orig/drivers/leds/leds-da9052.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-next-20110421/drivers/leds/leds-da9052.c	2011-04-26 09:57:59.000000000 +0500
@@ -0,0 +1,214 @@
+/*
+ * LED Driver for Dialog DA9052
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * Author: Dajun Chen <dchen@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <linux/workqueue.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/pdata.h>
+#include <linux/mfd/da9052/gpio.h>
+
+struct da9052_led {
+	struct led_classdev cdev;
+	struct work_struct work;
+	struct da9052 *da9052;
+	u8 led_index;
+	u8 id;
+	int brightness;
+};
+
+u8 led_reg[] = {
+		DA9052_LED_CONT_4_REG,
+		DA9052_LED_CONT_5_REG,
+};
+
+static int da9052_set_led_brightness(struct da9052_led *led)
+{
+	int error;
+
+	error = da9052_reg_write(led->da9052, led_reg[led->led_index],
+				led->brightness | DA9052_LED_CONT_DIM);
+	if (error < 0)
+		dev_err(led->da9052->dev, "Failed to set led brightness, %d\n", error);
+	return error;
+}
+
+static void da9052_led_work(struct work_struct *work)
+{
+	struct da9052_led *led = container_of(work,
+				 struct da9052_led, work);
+
+	da9052_set_led_brightness(led);
+}
+
+static void da9052_led_set(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct da9052_led *led;
+
+	led = container_of(led_cdev, struct da9052_led, cdev);
+	led->brightness = value;
+	schedule_work(&led->work);
+}
+
+
+static int da9052_configure_leds_gpio(struct da9052_led *led)
+{
+	int error;
+	u8 register_value = DA9052_OUTPUT_OPENDRAIN |
+			DA9052_SUPPLY_VDD_IO1 << 2 | 1 << 3;
+
+	error = da9052_reg_update(led->da9052, DA9052_GPIO_14_15_REG,
+				DA9052_GPIO_MASK_LOWER_NIBBLE,
+				register_value);
+
+	if (error < 0) {
+		dev_err(led->da9052->dev, "Failed to write GPIO 14-15 reg, %d\n", error);
+		return error;
+	}
+
+	error = da9052_reg_update(led->da9052, DA9052_GPIO_14_15_REG,
+				DA9052_GPIO_MASK_UPPER_NIBBLE,
+				register_value << DA9052_GPIO_NIBBLE_SHIFT
+				);
+	if (error < 0)
+		dev_err(led->da9052->dev, "Failed to write GPIO 14-15 reg, %d\n", error);
+
+	return error;
+}
+
+static int __devinit da9052_led_probe(struct platform_device *pdev)
+{
+	struct da9052_pdata *pdata;
+	struct da9052 *da9052;
+	struct led_platform_data *pled;
+	struct da9052_led *led;
+	int error, i;
+
+	da9052 = dev_get_drvdata(pdev->dev.parent);
+	pdata = da9052->dev->platform_data;
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "No platform data\n");
+		error = -ENODEV;
+		goto err_mem;
+	}
+
+	pled = pdata->pled;
+
+	if (pled == NULL) {
+		dev_err(&pdev->dev, "Failed no platform data for LED\n");
+		return -ENOMEM;
+	}
+
+	led = kzalloc(sizeof(struct da9052_led) * pled->num_leds, GFP_KERNEL);
+	if (led == NULL) {
+		dev_err(&pdev->dev, "Failed to alloc memory\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < pled->num_leds; i++) {
+		led[i].cdev.name = pled->leds[i].name;
+		led[i].cdev.brightness_set = da9052_led_set;
+		led[i].cdev.brightness = LED_OFF;
+		led[i].brightness = 0;
+		led[i].led_index = pled->leds[i].flags;
+		led[i].da9052 = dev_get_drvdata(pdev->dev.parent);
+		INIT_WORK(&led[i].work, da9052_led_work);
+
+		error = led_classdev_register(pdev->dev.parent, &led[i].cdev);
+		if (error) {
+			dev_err(&pdev->dev, "Failed to register led %d\n", led[i].led_index);
+			goto err_register;
+		}
+
+		error = da9052_set_led_brightness(&led[i]);
+		if (error) {
+			dev_err(&pdev->dev, "Unable to init led %d\n", led[i].led_index);
+			continue;
+		}
+	}
+	error = da9052_configure_leds_gpio(led);
+	if (error) {
+		dev_err(&pdev->dev, "Failed to configure GPIO Led,%d\n", error);
+		goto err_register;
+	}
+
+	platform_set_drvdata(pdev, led);
+
+	return 0;
+
+err_register:
+	for (i = i - 1; i >= 0; i--) {
+		led_classdev_unregister(&led[i].cdev);
+		cancel_work_sync(&led[i].work);
+	}
+err_mem:
+	kfree(led);
+	return error;
+}
+
+static int __devexit da9052_led_remove(struct platform_device *pdev)
+{
+	struct da9052_led *led = platform_get_drvdata(pdev);
+	struct da9052_pdata *pdata;
+	struct da9052 *da9052;
+	struct led_platform_data *pled;
+	int i;
+
+	da9052 = dev_get_drvdata(pdev->dev.parent);
+	pdata = da9052->dev->platform_data;
+	pled = pdata->pled;
+
+	for (i = 0; i < pled->num_leds; i++) {
+		led[i].brightness = 0;
+		da9052_set_led_brightness(&led[i]);
+		led_classdev_unregister(&led[i].cdev);
+		cancel_work_sync(&led[i].work);
+	}
+
+	kfree(led);
+
+	return 0;
+}
+
+static struct platform_driver da9052_led_driver = {
+	.driver = {
+		.name	= "da9052-leds",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= da9052_led_probe,
+	.remove		= __devexit_p(da9052_led_remove),
+};
+
+static int __init da9052_led_init(void)
+{
+	return platform_driver_register(&da9052_led_driver);
+}
+module_init(da9052_led_init);
+
+static void __exit da9052_led_exit(void)
+{
+	platform_driver_unregister(&da9052_led_driver);
+}
+module_exit(da9052_led_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>	");
+MODULE_DESCRIPTION("LED driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
diff -Naur linux-next-20110421.orig/drivers/leds/Makefile linux-next-20110421/drivers/leds/Makefile
--- linux-next-20110421.orig/drivers/leds/Makefile	2011-04-26 09:32:34.000000000 +0500
+++ linux-next-20110421/drivers/leds/Makefile	2011-04-26 10:01:02.000000000 +0500
@@ -31,6 +31,7 @@
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
 obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
+obj-$(CONFIG_LEDS_DA9052)		+= leds-da9052.o
 obj-$(CONFIG_LEDS_WM831X_STATUS)	+= leds-wm831x-status.o
 obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
 obj-$(CONFIG_LEDS_PWM)			+= leds-pwm.o

Regards,
Ashish


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
