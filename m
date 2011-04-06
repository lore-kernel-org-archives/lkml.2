Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab1DFM3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:29:25 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:19015
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755664Ab1DFM3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:29:24 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Apr 2011 08:29:23 EDT
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cK936eKc8kzz1202hzz8275bh84d07hz32i2a8h668h839h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.kpit.com;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Richard Purdie <rpurdie@rpsys.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>
Date: Wed, 6 Apr 2011 17:44:02 +0530
Subject: [PATCHv1 9/11] BACKLIGHT: Backlight module for DA9052 PMIC driver
Thread-Topic: [PATCHv1 9/11] BACKLIGHT: Backlight module for DA9052 PMIC
 driver
Thread-Index: Acv0VB4TTT0UPBGcTNGX/W2Zawlhgw==
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B451E62@KCINPUNHJCMS01.kpit.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p36CTZo2000702

Hi Richard,

Backlight Driver for Dialog Semiconductor DA9052 PMICs.

Changes made since last submission:
. read and write operation moved to MFD

Some additional information of this patch:
. 3 banks of WLEDs on the DA9052 development board was thoroughly tested using a pattern generation script. 

Linux Kernel Version: 2.6.37

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -Naur orig_linux-2.6.37/drivers/video/backlight/da9052_bl.c linux-2.6.37/drivers/video/backlight/da9052_bl.c
--- orig_linux-2.6.37/drivers/video/backlight/da9052_bl.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/drivers/video/backlight/da9052_bl.c	2011-03-31 20:27:51.000000000 +0500
@@ -0,0 +1,215 @@
+/*
+ * da9052_bl.c  --  Backlight Driver for Dialog DA9052 PMICs
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * Author: Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/platform_device.h>
+#include <linux/fb.h>
+#include <linux/backlight.h>
+#include <linux/delay.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+
+#define DA9052_MAX_BRIGHTNESS		0xFF
+
+enum {
+	DA9052_WLEDS_OFF,
+	DA9052_WLEDS_ON,
+	};
+
+u8 wled_bank[] = {
+			DA9052_LED1_CONF_REG,
+			DA9052_LED2_CONF_REG,
+			DA9052_LED3_CONF_REG,
+		};
+
+struct da9052_bl {
+	struct da9052 *da9052;
+	uint brightness;
+	uint state;
+	uint led_reg;
+	};
+
+static int da9052_adjust_wled_brightness(struct da9052_bl *wleds)
+{
+	u8 boost_en, i_sink;
+	int ret = 0;
+
+	boost_en = 0x3F;
+	i_sink	 = 0xFF;
+	if (wleds->state == DA9052_WLEDS_OFF) {
+		boost_en = 0x00;
+		i_sink	 = 0x00;
+	}
+
+	ret = da9052_reg_write(wleds->da9052, DA9052_BOOST_REG, boost_en);
+	if (ret < 0) {
+		dev_err(wleds->da9052->dev,
+			"Failed to write boost reg, %d\n", ret);
+		return ret;
+	}
+
+	ret = da9052_reg_write(wleds->da9052, DA9052_LED_CONT_REG, i_sink);
+	if (ret < 0) {
+		dev_err(wleds->da9052->dev,
+			"Failed to write led cont reg, %d\n", ret);
+		return ret;
+	}
+
+	ret = da9052_reg_write(wleds->da9052, wled_bank[wleds->led_reg],
+							0x0);
+	if (ret < 0) {
+		dev_err(wleds->da9052->dev,
+			"Failed to write led conf reg, %d", ret);
+		return ret;
+	}
+
+	if (wleds->brightness) {
+		msleep(10);
+		ret = da9052_reg_write(wleds->da9052,
+		wled_bank[wleds->led_reg], wleds->brightness);
+		if (ret < 0)
+			dev_err(wleds->da9052->dev,
+				"Failed to write led conf reg, %d", ret);
+	}
+
+	return ret;
+
+}
+
+static int da9052_backlight_update_status(struct backlight_device *bl)
+{
+	int brightness = bl->props.brightness;
+	struct da9052_bl *wleds = bl_get_data(bl);
+
+	wleds->brightness = brightness;
+	wleds->state = DA9052_WLEDS_ON;
+
+	return da9052_adjust_wled_brightness(wleds);
+}
+
+static int da9052_backlight_get_brightness(struct backlight_device *bl)
+{
+	struct da9052_bl *wleds = bl_get_data(bl);
+	return wleds->brightness;
+}
+
+struct backlight_ops da9052_backlight_ops = {
+	.update_status	= da9052_backlight_update_status,
+	.get_brightness	= da9052_backlight_get_brightness,
+};
+
+static int da9052_backlight_probe(struct platform_device *pdev)
+{
+	struct backlight_device *bl;
+	struct backlight_properties props;
+	int ret = 0;
+	static int led_reg_num;
+	struct da9052_bl *wleds;
+
+
+	wleds = kzalloc(sizeof(struct da9052_bl), GFP_KERNEL);
+
+	if (!wleds)
+		return -ENOMEM;
+
+	wleds->da9052	= dev_get_drvdata(pdev->dev.parent);
+	wleds->brightness = 0;
+	wleds->led_reg = led_reg_num++;
+	wleds->state = DA9052_WLEDS_OFF;
+
+	bl = backlight_device_register(pdev->name, wleds->da9052->dev,
+			wleds, &da9052_backlight_ops, &props);
+
+	if (IS_ERR(bl)) {
+		dev_err(&pdev->dev, "Failed to register backlight\n");
+		return PTR_ERR(bl);
+	}
+
+	bl->props.max_brightness = DA9052_MAX_BRIGHTNESS;
+	bl->props.brightness = 0;
+	platform_set_drvdata(pdev, bl);
+
+	ret = da9052_adjust_wled_brightness(wleds);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int da9052_backlight_remove(struct platform_device *pdev)
+{
+	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct da9052_bl *wleds = bl_get_data(bl);
+
+	wleds->brightness = 0;
+	wleds->state = DA9052_WLEDS_OFF;
+
+	da9052_adjust_wled_brightness(wleds);
+	backlight_device_unregister(bl);
+
+	return 0;
+}
+
+static struct platform_driver da9052_wled1_driver = {
+	.driver.name	= "da9052-WLED1",
+	.driver.owner	= THIS_MODULE,
+	.probe		= da9052_backlight_probe,
+	.remove		= da9052_backlight_remove,
+};
+
+static struct platform_driver da9052_wled2_driver = {
+	.driver.name	= "da9052-WLED2",
+	.driver.owner	= THIS_MODULE,
+	.probe		= da9052_backlight_probe,
+	.remove		= da9052_backlight_remove,
+};
+static struct platform_driver da9052_wled3_driver = {
+	.driver.name	= "da9052-WLED3",
+	.driver.owner	= THIS_MODULE,
+	.probe		= da9052_backlight_probe,
+	.remove		= da9052_backlight_remove,
+};
+
+static int __init da9052_backlight_init(void)
+{
+	s32 ret;
+	ret = platform_driver_register(&da9052_wled1_driver);
+	if (ret)
+		return ret;
+	ret = platform_driver_register(&da9052_wled2_driver);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_register(&da9052_wled3_driver);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+module_init(da9052_backlight_init);
+
+static void __exit da9052_backlight_exit(void)
+{
+	platform_driver_unregister(&da9052_wled1_driver);
+	platform_driver_unregister(&da9052_wled2_driver);
+	platform_driver_unregister(&da9052_wled3_driver);
+}
+module_exit(da9052_backlight_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("Backlight driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:da9052-backlight");
+
+
diff -Naur orig_linux-2.6.37/drivers/video/backlight/Kconfig linux-2.6.37/drivers/video/backlight/Kconfig
--- orig_linux-2.6.37/drivers/video/backlight/Kconfig	2011-01-05 05:50:19.000000000 +0500
+++ linux-2.6.37/drivers/video/backlight/Kconfig	2011-03-31 20:27:42.000000000 +0500
@@ -229,6 +229,12 @@
 	  If you have a LCD backlight connected to the WLED output of DA9030
 	  or DA9034 WLED output, say Y here to enable this driver.

+config BACKLIGHT_DA9052
+	tristate "Dialog DA9052 WLED"
+	depends on PMIC_DA9052
+	help
+	  Enable the DA9052 Backlight Driver
+
 config BACKLIGHT_MAX8925
 	tristate "Backlight driver for MAX8925"
 	depends on MFD_MAX8925
diff -Naur orig_linux-2.6.37/drivers/video/backlight/Makefile linux-2.6.37/drivers/video/backlight/Makefile
--- orig_linux-2.6.37/drivers/video/backlight/Makefile	2011-01-05 05:50:19.000000000 +0500
+++ linux-2.6.37/drivers/video/backlight/Makefile	2011-03-31 20:27:37.000000000 +0500
@@ -25,6 +25,7 @@
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
 obj-$(CONFIG_BACKLIGHT_PWM)		+= pwm_bl.o
 obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x_bl.o
+obj-$(CONFIG_BACKLIGHT_DA9052)	+= da9052_bl.o
 obj-$(CONFIG_BACKLIGHT_MAX8925)	+= max8925_bl.o
 obj-$(CONFIG_BACKLIGHT_MBP_NVIDIA) += mbp_nvidia_bl.o
 obj-$(CONFIG_BACKLIGHT_TOSA)		+= tosa_bl.o

Regards,
Ashish


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
