Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab1EXMnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:43:33 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:6078
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754925Ab1EXMnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:43:31 -0400
X-SpamScore: 4
X-BigFish: VPS4(zzc8kzz1202hzz8275bhz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:203.197.93.240;KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.kpit.com;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Richard Purdie <rpurdie@rpsys.net>, Thiago Farina <tfransosi@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Date: Tue, 24 May 2011 18:12:15 +0530
Subject: [PATCHv2 9/11] BACKLIGHT: Coding Style Corrected 
Thread-Topic: [PATCHv2 9/11] BACKLIGHT: Coding Style Corrected 
Thread-Index: AcwaEALZeYm4PAypT5yzZ2hvZRncmA==
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BE82D51@KCINPUNHJCMS01.kpit.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4OChd9S002096

Hi Richard,

Coding style corrected.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 0c9373b..a14fb21 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -237,6 +237,12 @@ config BACKLIGHT_DA903X
 	  If you have a LCD backlight connected to the WLED output of DA9030
 	  or DA9034 WLED output, say Y here to enable this driver.
 
+config BACKLIGHT_DA9052
+        tristate "Dialog DA9052 WLED"
+        depends on PMIC_DA9052
+        help
+          Enable the DA9052 Backlight Driver
+
 config BACKLIGHT_MAX8925
 	tristate "Backlight driver for MAX8925"
 	depends on MFD_MAX8925
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index b9ca849..a317e11 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_BACKLIGHT_PROGEAR) += progear_bl.o
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
 obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o
 obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x_bl.o
+obj-$(CONFIG_BACKLIGHT_DA9052)	+= da9052_bl.o
 obj-$(CONFIG_BACKLIGHT_MAX8925)	+= max8925_bl.o
 obj-$(CONFIG_BACKLIGHT_APPLE)	+= apple_bl.o
 obj-$(CONFIG_BACKLIGHT_TOSA)	+= tosa_bl.o
diff --git a/drivers/video/backlight/da9052_bl.c b/drivers/video/backlight/da9052_bl.c
new file mode 100755
index 0000000..73fe1ed
--- /dev/null
+++ b/drivers/video/backlight/da9052_bl.c
@@ -0,0 +1,218 @@
+/*
+ * Backlight Driver for Dialog DA9052 PMICs
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/backlight.h>
+#include <linux/delay.h>
+#include <linux/fb.h>
+#include <linux/platform_device.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+
+#define DA9052_MAX_BRIGHTNESS		0xFF
+
+enum {
+	DA9052_WLEDS_OFF,
+	DA9052_WLEDS_ON,
+};
+
+static unsigned char wled_bank[] = {
+	DA9052_LED1_CONF_REG,
+	DA9052_LED2_CONF_REG,
+	DA9052_LED3_CONF_REG,
+};
+
+struct da9052_bl {
+	struct da9052 *da9052;
+	uint brightness;
+	uint state;
+	uint led_reg;
+};
+
+static int da9052_adjust_wled_brightness(struct da9052_bl *wleds)
+{
+	unsigned char boost_en;
+	unsigned char i_sink;
+	int ret;
+
+	boost_en = 0x3F;
+	i_sink = 0xFF;
+	if (wleds->state == DA9052_WLEDS_OFF) {
+		boost_en = 0x00;
+		i_sink = 0x00;
+	}
+
+	ret = da9052_reg_write(wleds->da9052, DA9052_BOOST_REG, boost_en);
+	if (ret < 0) {
+		dev_err(wleds->da9052->dev,
+				"Failed to write boost reg, %d\n", ret);
+		return ret;
+	}
+
+	ret = da9052_reg_write(wleds->da9052, DA9052_LED_CONT_REG, i_sink);
+	if (ret < 0) {
+		dev_err(wleds->da9052->dev,
+				"Failed to write led cont reg, %d\n", ret);
+		return ret;
+	}
+
+	ret = da9052_reg_write(wleds->da9052, wled_bank[wleds->led_reg], 0x0);
+	if (ret < 0) {
+		dev_err(wleds->da9052->dev,
+				"Failed to write led conf reg, %d", ret);
+		return ret;
+	}
+
+	if (wleds->brightness) {
+		msleep(10);
+		ret = da9052_reg_write(wleds->da9052, wled_bank[wleds->led_reg],
+							wleds->brightness);
+		if (ret < 0) {
+			dev_err(wleds->da9052->dev,
+					"Failed to write led conf reg, %d",
+					ret);
+			return ret;
+		}
+	}
+
+	return 0;
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
+
+	return wleds->brightness;
+}
+
+static const struct backlight_ops da9052_backlight_ops = {
+	.update_status = da9052_backlight_update_status,
+	.get_brightness = da9052_backlight_get_brightness,
+};
+
+static int da9052_backlight_probe(struct platform_device *pdev)
+{
+	struct backlight_device *bl;
+	struct backlight_properties props;
+	static int led_reg_num;
+	struct da9052_bl *wleds;
+
+	wleds = kzalloc(sizeof(struct da9052_bl), GFP_KERNEL);
+	if (!wleds)
+		return -ENOMEM;
+
+	wleds->da9052 = dev_get_drvdata(pdev->dev.parent);
+	wleds->brightness = 0;
+	wleds->led_reg = led_reg_num++;
+	wleds->state = DA9052_WLEDS_OFF;
+
+	bl = backlight_device_register(pdev->name, wleds->da9052->dev,
+						wleds, &da9052_backlight_ops,
+						&props);
+	if (IS_ERR(bl)) {
+		dev_err(&pdev->dev, "Failed to register backlight\n");
+		kfree(wleds);
+		return PTR_ERR(bl);
+	}
+
+	bl->props.max_brightness = DA9052_MAX_BRIGHTNESS;
+	bl->props.brightness = 0;
+	platform_set_drvdata(pdev, bl);
+
+	return da9052_adjust_wled_brightness(wleds);
+}
+
+static int da9052_backlight_remove(struct platform_device *pdev)
+{
+	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct da9052_bl *wleds = bl_get_data(bl);
+
+	wleds->brightness = 0;
+	wleds->state = DA9052_WLEDS_OFF;
+	da9052_adjust_wled_brightness(wleds);
+	backlight_device_unregister(bl);
+
+	return 0;
+}
+
+static struct platform_driver da9052_wled1_driver = {
+	.driver		= {
+		.name		= "da9052-WLED1",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= da9052_backlight_probe,
+	.remove	= da9052_backlight_remove,
+};
+
+static struct platform_driver da9052_wled2_driver = {
+	.driver		= {
+		.name		= "da9052-WLED2",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= da9052_backlight_probe,
+	.remove	= da9052_backlight_remove,
+};
+
+static struct platform_driver da9052_wled3_driver = {
+	.driver		= {
+		.name		= "da9052-WLED3",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= da9052_backlight_probe,
+	.remove	= da9052_backlight_remove,
+};
+
+static int __init da9052_backlight_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&da9052_wled1_driver);
+	if (ret)
+		return ret;
+
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
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("Backlight driver for DA9052 PMIC");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9052-backlight");




Regards,
Ashish


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
