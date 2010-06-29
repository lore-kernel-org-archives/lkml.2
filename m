Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab0F2NQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 09:16:18 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:35831 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab0F2NQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 09:16:16 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [RFC][PATCH 9/11] BACKLIGHT: Initial submission of Backlight device driver for DA9052 PMIC
Date: Tue, 29 Jun 2010 14:16:13 +0100
Message-ID: <3495EC08FA53E94AAA00CC4743D5BA7E013FA7EC@pandora.diasemi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH 9/11] BACKLIGHT: Initial submission of Backlight device driver for DA9052 PMIC
Thread-Index: AcsXjT+HF2FaSrzTSPCDn8n0ChtyPA==
From: "David Dajun Chen" <Dajun.Chen@diasemi.com>
To: <rpurdie@rpsys.net>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Jun 2010 13:16:14.0555 (UTC) FILETIME=[4039D2B0:01CB178D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial submission of backlight module of the device driver for DA9052
PMIC device from Dialog Semiconductor.

Linux Kernel Version: 2.6.34

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -uprN linux-2.6.34/drivers/mfd/da9052-core.c
linux-2.6.34_test/drivers/mfd/da9052-core.c
--- linux-2.6.34/drivers/mfd/da9052-core.c	2010-06-28
19:40:28.000000000 +0500
+++ linux-2.6.34_test/drivers/mfd/da9052-core.c	2010-06-28
19:41:15.000000000 +0500
@@ -554,6 +554,9 @@ static int __init da9052_ssc_init(void)
 	if (ret)
 		return -EIO;
 
+	/* Add the DA9052 modules */
+	da9052_add_subdevice(da9052, "da9052-backlight");
+
 	/* Initialize ssc cache */
 	da9052_init_ssc_cache();
 
diff -uprN linux-2.6.34/drivers/video/backlight/da9052_bl.c
linux-2.6.34_test/drivers/video/backlight/da9052_bl.c
--- linux-2.6.34/drivers/video/backlight/da9052_bl.c	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/drivers/video/backlight/da9052_bl.c
2010-06-28 19:42:05.000000000 +0500
@@ -0,0 +1,296 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052_bl.c: Backlight driver for DA9052
+ */
+
+#include <linux/platform_device.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/backlight.h>
+
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/bl.h>
+#include <linux/mfd/da9052/da9052.h>
+
+#define DRIVER_NAME		"da9052-backlight"
+
+/* These flags define if Backlight LEDs are present */
+/* Set the following macros to 1, if LEDs are present. Otherwise set to
0 */
+#define DA9052_LED1_PRESENT	1
+#define DA9052_LED2_PRESENT	1
+#define DA9052_LED3_PRESENT	1
+
+#define DA9052_MAX_BRIGHTNESS	0xFF
+
+struct da9052_backlight_data {
+	struct device *da9052_dev;
+	int current_brightness;
+	struct da9052 *da9052;
+
+	int is_led1_present;
+	int is_led2_present;
+	int is_led3_present;
+};
+
+enum da9052_led_number {
+	LED1 = 1,
+	LED2,
+	LED3,
+};
+
+static int da9052_backlight_brightness_set(struct da9052_backlight_data
*data,
+			int brightness, enum da9052_led_number led)
+{
+	/*
+	 * Mechanism for brightness control:
+	 * For brightness control, current is used.
+	 * PWM feature is not used.
+	 * To use PWM feature, a fixed value of current should be
defined.
+	 */
+
+	int ret = 0;
+
+	unsigned int led_ramp_bit;
+	unsigned int led_current_register;
+	unsigned int led_current_sink_bit;
+	unsigned int led_boost_en_bit;
+
+	struct da9052_ssc_msg msg;
+
+	switch (led) {
+	case LED1:
+		led_ramp_bit = DA9052_LEDCONT_LED1RAMP;
+		led_current_register = DA9052_LED1CONF_REG;
+		led_current_sink_bit = DA9052_LEDCONT_LED1EN;
+		led_boost_en_bit = DA9052_BOOST_LED1INEN;
+		break;
+	case LED2:
+		led_ramp_bit = DA9052_LEDCONT_LED2RAMP;
+		led_current_register = DA9052_LED2CONF_REG;
+		led_current_sink_bit = DA9052_LEDCONT_LED2EN;
+		led_boost_en_bit = DA9052_BOOST_LED2INEN;
+		break;
+	case LED3:
+		led_ramp_bit = DA9052_LEDCONT_LED3RAMP;
+		led_current_register = DA9052_LED3CONF_REG;
+		led_current_sink_bit = DA9052_LEDCONT_LED3EN;
+		led_boost_en_bit = DA9052_BOOST_LED3INEN;
+		break;
+	default:
+		return -EIO;
+	}
+
+	/*
+	 * 3 registers to be written
+	 * 1. LED current for brightness
+	 * 2. LED enable/disable depending on the brightness
+	 * 3. BOOST enable/disable depending on the brightness
+	 */
+
+	/* Configure LED current i.e. brightness */
+	msg.addr = led_current_register;
+	msg.data = brightness;
+	/* Write to the DA9052 register */
+	da9052_lock(data->da9052);
+	ret = data->da9052->write(data->da9052, &msg);
+	if (ret) {
+		da9052_unlock(data->da9052);
+		return ret;
+	}
+	da9052_unlock(data->da9052);
+
+	/*
+	 * Check if brightness = 0
+	 * and decide if led to be disabled
+	 */
+	msg.addr = DA9052_LEDCONT_REG;
+	msg.data = 0;
+
+	/* Read LED_CONT register */
+	da9052_lock(data->da9052);
+	ret = data->da9052->read(data->da9052, &msg);
+	if (ret) {
+		da9052_unlock(data->da9052);
+		return ret;
+	}
+	da9052_unlock(data->da9052);
+
+	/* Set/Clear the LED current sink bit */
+	msg.data = brightness ? (msg.data | led_current_sink_bit) :
+			(msg.data & ~(led_current_sink_bit));
+	/* Disable current ramping */
+	msg.data = (msg.data & ~(led_ramp_bit));
+
+	/* Write to the DA9052 register */
+	da9052_lock(data->da9052);
+	ret = data->da9052->write(data->da9052, &msg);
+	if (ret) {
+		da9052_unlock(data->da9052);
+		return ret;
+	}
+	da9052_unlock(data->da9052);
+
+	/* Configure BOOST */
+	msg.addr = DA9052_BOOST_REG;
+	msg.data = 0;
+
+	/* Read LED_CONT register */
+	da9052_lock(data->da9052);
+	ret = data->da9052->read(data->da9052, &msg);
+	if (ret) {
+		da9052_unlock(data->da9052);
+		return ret;
+	}
+	da9052_unlock(data->da9052);
+
+	/* Set/Clear the LED BOOST enable bit */
+	msg.data = brightness ? (msg.data | led_boost_en_bit) :
+			(msg.data & ~(led_boost_en_bit));
+	/* Set/Clear the BOOST converter enable bit */
+	msg.data = brightness ? (msg.data | DA9052_BOOST_BOOSTEN) :
+			(msg.data & ~(DA9052_BOOST_BOOSTEN));
+
+	/* Write to the DA9052 register */
+	da9052_lock(data->da9052);
+	ret = data->da9052->write(data->da9052, &msg);
+	if (ret) {
+		da9052_unlock(data->da9052);
+		return ret;
+	}
+	da9052_unlock(data->da9052);
+
+	return 0;
+}
+
+static int da9052_backlight_set(struct backlight_device *bl, int
brightness)
+{
+	struct da9052_backlight_data *data = bl_get_data(bl);
+	int ret = 0;
+
+	/* Check for LED1 */
+	if (1 == data->is_led1_present) {
+		ret = da9052_backlight_brightness_set(data, brightness,
LED1);
+		if (ret)
+			return ret;
+	}
+	/* Check for LED2 */
+	if (1 == data->is_led1_present) {
+		ret = da9052_backlight_brightness_set(data, brightness,
LED2);
+		if (ret)
+			return ret;
+	}
+	/* Check for LED3 */
+	if (1 == data->is_led1_present) {
+		ret = da9052_backlight_brightness_set(data, brightness,
LED3);
+		if (ret)
+			return ret;
+	}
+
+	data->current_brightness = brightness;
+	return 0;
+}
+
+static int da9052_backlight_update_status(struct backlight_device *bl)
+{
+	int brightness = bl->props.brightness;
+
+	if (bl->props.power != FB_BLANK_UNBLANK)
+		brightness = 0;
+
+	if (bl->props.fb_blank != FB_BLANK_UNBLANK)
+		brightness = 0;
+
+	return da9052_backlight_set(bl, brightness);
+}
+
+static int da9052_backlight_get_brightness(struct backlight_device *bl)
+{
+	struct da9052_backlight_data *data = bl_get_data(bl);
+	return data->current_brightness;
+}
+
+static const struct backlight_ops da9052_backlight_ops = {
+	.update_status	= da9052_backlight_update_status,
+	.get_brightness	= da9052_backlight_get_brightness,
+};
+
+static int da9052_backlight_probe(struct platform_device *pdev)
+{
+	struct da9052_backlight_data *data;
+	struct backlight_device *bl;
+	struct backlight_properties props;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	data->da9052_dev = pdev->dev.parent;
+	data->current_brightness = 0;
+	data->is_led1_present = DA9052_LED1_PRESENT;
+	data->is_led2_present = DA9052_LED2_PRESENT;
+	data->is_led3_present = DA9052_LED3_PRESENT;
+
+	bl = backlight_device_register(pdev->name, data->da9052_dev,
+			data, &da9052_backlight_ops, &props);
+	if (IS_ERR(bl)) {
+		dev_err(&pdev->dev, "failed to register backlight\n");
+		kfree(data);
+		return PTR_ERR(bl);
+	}
+
+	bl->props.max_brightness = DA9052_MAX_BRIGHTNESS;
+	bl->props.brightness = 0;
+
+	platform_set_drvdata(pdev, bl);
+	backlight_update_status(bl);
+
+	/*
+	 * NOTE:
+	 * The default settings for DA9052 registers depends upon OTP
values.
+	 * E.g. The configuration of BOOST register, minimum value for
LED
+	 *      current etc. are taken from OTP
+	 */
+
+	return 0;
+}
+
+static int da9052_backlight_remove(struct platform_device *pdev)
+{
+	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct da9052_backlight_data *data = bl_get_data(bl);
+
+	backlight_device_unregister(bl);
+	kfree(data);
+	return 0;
+}
+
+static struct platform_driver da9052_backlight_driver = {
+	.driver		= {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= da9052_backlight_probe,
+	.remove		= da9052_backlight_remove,
+};
+
+static int __init da9052_backlight_init(void)
+{
+	return platform_driver_register(&da9052_backlight_driver);
+}
+module_init(da9052_backlight_init);
+
+static void __exit da9052_backlight_exit(void)
+{
+	platform_driver_unregister(&da9052_backlight_driver);
+}
+module_exit(da9052_backlight_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("Backlight driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff -uprN linux-2.6.34/drivers/video/backlight/Kconfig
linux-2.6.34_test/drivers/video/backlight/Kconfig
--- linux-2.6.34/drivers/video/backlight/Kconfig	2010-05-17
02:17:36.000000000 +0500
+++ linux-2.6.34_test/drivers/video/backlight/Kconfig	2010-06-28
19:42:23.000000000 +0500
@@ -282,3 +282,8 @@ config BACKLIGHT_88PM860X
 	help
 	  Say Y to enable the backlight driver for Marvell 88PM8606.
 
+config BACKLIGHT_DA9052
+	tristate "Backlight Driver for DA9052 using WLED"
+	depends on BACKLIGHT_CLASS_DEVICE && PMIC_DA9052
+	help
+	  Enable the DA9052 Backlight Driver
diff -uprN linux-2.6.34/drivers/video/backlight/Makefile
linux-2.6.34_test/drivers/video/backlight/Makefile
--- linux-2.6.34/drivers/video/backlight/Makefile	2010-05-17
02:17:36.000000000 +0500
+++ linux-2.6.34_test/drivers/video/backlight/Makefile	2010-06-28
19:42:14.000000000 +0500
@@ -31,4 +31,5 @@ obj-$(CONFIG_BACKLIGHT_WM831X)	+= wm831x
 obj-$(CONFIG_BACKLIGHT_ADX)    += adx_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP5520)	+= adp5520_bl.o
 obj-$(CONFIG_BACKLIGHT_88PM860X) += 88pm860x_bl.o
+obj-$(CONFIG_BACKLIGHT_DA9052)	+= da9052_bl.o
 
diff -uprN linux-2.6.34/include/linux/mfd/da9052/bl.h
linux-2.6.34_test/include/linux/mfd/da9052/bl.h
--- linux-2.6.34/include/linux/mfd/da9052/bl.h	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/include/linux/mfd/da9052/bl.h	2010-06-28
19:42:59.000000000 +0500
@@ -0,0 +1,279 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * bl.h: DA9052 Header file for backlight
+ */
+
+#ifndef _BL_H
+#define _BL_H
+
+/*
+ * enum da9052_bl_current_value - Enum for current values of LED
+ * DA9052_BL_CURRENT_50_0UA: represents 50.0 uA current value
+ */
+enum da9052_bl_current_value {
+/* Current Value for LEDMIN, LED1_CONF, LED2_CONF, LED3_CONF Registers
*/
+	DA9052_BL_CURRENT_50_0UA = 0,
+	DA9052_BL_CURRENT_51_2UA,
+	DA9052_BL_CURRENT_52_5UA,
+	DA9052_BL_CURRENT_53_7UA,
+	DA9052_BL_CURRENT_55_1UA,
+	DA9052_BL_CURRENT_56_4UA,
+	DA9052_BL_CURRENT_57_8UA,
+	DA9052_BL_CURRENT_59_3UA,
+	DA9052_BL_CURRENT_60_7UA,
+	DA9052_BL_CURRENT_62_2UA,
+	DA9052_BL_CURRENT_63_8UA,
+	DA9052_BL_CURRENT_65_3UA,
+	DA9052_BL_CURRENT_67_0UA,
+	DA9052_BL_CURRENT_68_6UA,
+	DA9052_BL_CURRENT_70_3UA,
+	DA9052_BL_CURRENT_72_0UA,
+	DA9052_BL_CURRENT_73_8UA,
+	DA9052_BL_CURRENT_75_7UA,
+	DA9052_BL_CURRENT_77_5UA,
+	DA9052_BL_CURRENT_79_4UA,
+	DA9052_BL_CURRENT_81_4UA,
+	DA9052_BL_CURRENT_83_4UA,
+	DA9052_BL_CURRENT_85_5UA,
+	DA9052_BL_CURRENT_87_6UA,
+	DA9052_BL_CURRENT_89_8UA,
+	DA9052_BL_CURRENT_92_0UA,
+	DA9052_BL_CURRENT_94_2UA,
+	DA9052_BL_CURRENT_96_6UA,
+	DA9052_BL_CURRENT_99_0UA,
+	DA9052_BL_CURRENT_101_4UA,
+	DA9052_BL_CURRENT_103_9UA,
+	DA9052_BL_CURRENT_106_5UA,
+	DA9052_BL_CURRENT_109_1UA,
+	DA9052_BL_CURRENT_111_8UA,
+	DA9052_BL_CURRENT_114_6UA,
+	DA9052_BL_CURRENT_117_4UA,
+	DA9052_BL_CURRENT_120_6UA,
+	DA9052_BL_CURRENT_123_3UA,
+	DA9052_BL_CURRENT_126_3UA,
+	DA9052_BL_CURRENT_129_4UA,
+	DA9052_BL_CURRENT_132_6UA,
+	DA9052_BL_CURRENT_135_9UA,
+	DA9052_BL_CURRENT_139_3UA,
+	DA9052_BL_CURRENT_142_7UA,
+	DA9052_BL_CURRENT_146_2UA,
+	DA9052_BL_CURRENT_149_9UA,
+	DA9052_BL_CURRENT_153_6UA,
+	DA9052_BL_CURRENT_157_4UA,
+	DA9052_BL_CURRENT_161_2UA,
+	DA9052_BL_CURRENT_165_2UA,
+	DA9052_BL_CURRENT_169_3UA,
+	DA9052_BL_CURRENT_173_5UA,
+	DA9052_BL_CURRENT_177_8UA,
+	DA9052_BL_CURRENT_182_2UA,
+	DA9052_BL_CURRENT_186_7UA,
+	DA9052_BL_CURRENT_191_3UA,
+	DA9052_BL_CURRENT_196_0UA,
+	DA9052_BL_CURRENT_200_9UA,
+	DA9052_BL_CURRENT_205_8UA,
+	DA9052_BL_CURRENT_210_9UA,
+	DA9052_BL_CURRENT_216_1UA,
+	DA9052_BL_CURRENT_221_4UA,
+	DA9052_BL_CURRENT_226_9UA,
+	DA9052_BL_CURRENT_232_5UA,
+	DA9052_BL_CURRENT_238_3UA,
+	DA9052_BL_CURRENT_244_2UA,
+	DA9052_BL_CURRENT_250_2UA,
+	DA9052_BL_CURRENT_256_4UA,
+	DA9052_BL_CURRENT_262_7UA,
+	DA9052_BL_CURRENT_269_2UA,
+	DA9052_BL_CURRENT_275_8UA,
+	DA9052_BL_CURRENT_282_7UA,
+	DA9052_BL_CURRENT_289_6UA,
+	DA9052_BL_CURRENT_296_8UA,
+	DA9052_BL_CURRENT_304_1UA,
+	DA9052_BL_CURRENT_311_6UA,
+	DA9052_BL_CURRENT_319_3UA,
+	DA9052_BL_CURRENT_327_2UA,
+	DA9052_BL_CURRENT_335_3UA,
+	DA9052_BL_CURRENT_343_6UA,
+	DA9052_BL_CURRENT_352_1UA,
+	DA9052_BL_CURRENT_360_8UA,
+	DA9052_BL_CURRENT_369_7UA,
+	DA9052_BL_CURRENT_378_8UA,
+	DA9052_BL_CURRENT_388_2UA,
+	DA9052_BL_CURRENT_397_8UA,
+	DA9052_BL_CURRENT_407_6UA,
+	DA9052_BL_CURRENT_417_7UA,
+	DA9052_BL_CURRENT_428_0UA,
+	DA9052_BL_CURRENT_438_6UA,
+	DA9052_BL_CURRENT_449_4UA,
+	DA9052_BL_CURRENT_460_5UA,
+	DA9052_BL_CURRENT_471_9UA,
+	DA9052_BL_CURRENT_483_5UA,
+	DA9052_BL_CURRENT_495_5UA,
+	DA9052_BL_CURRENT_507_7UA,
+	DA9052_BL_CURRENT_520_3UA,
+	DA9052_BL_CURRENT_533_1UA,
+	DA9052_BL_CURRENT_546_3UA,
+	DA9052_BL_CURRENT_559_8UA,
+	DA9052_BL_CURRENT_573_6UA,
+	DA9052_BL_CURRENT_587_8UA,
+	DA9052_BL_CURRENT_602_3UA,
+	DA9052_BL_CURRENT_617_2UA,
+	DA9052_BL_CURRENT_632_4UA,
+	DA9052_BL_CURRENT_648_0UA,
+	DA9052_BL_CURRENT_664_0UA,
+	DA9052_BL_CURRENT_680_4UA,
+	DA9052_BL_CURRENT_697_2UA,
+	DA9052_BL_CURRENT_714_5UA,
+	DA9052_BL_CURRENT_732_1UA,
+	DA9052_BL_CURRENT_750_2UA,
+	DA9052_BL_CURRENT_768_7UA,
+	DA9052_BL_CURRENT_787_7UA,
+	DA9052_BL_CURRENT_807_2UA,
+	DA9052_BL_CURRENT_827_1UA,
+	DA9052_BL_CURRENT_847_6UA,
+	DA9052_BL_CURRENT_868_5UA,
+	DA9052_BL_CURRENT_889_9UA,
+	DA9052_BL_CURRENT_911_9UA,
+	DA9052_BL_CURRENT_934_4UA,
+	DA9052_BL_CURRENT_957_5UA,
+	DA9052_BL_CURRENT_981_2UA,
+	DA9052_BL_CURRENT_1005_4UA,
+	DA9052_BL_CURRENT_1030_3UA,
+	DA9052_BL_CURRENT_1055_7UA,
+	DA9052_BL_CURRENT_1081_8UA,
+	DA9052_BL_CURRENT_1108_5UA,
+	DA9052_BL_CURRENT_1135_9UA,
+	DA9052_BL_CURRENT_1163_9UA,
+	DA9052_BL_CURRENT_1192_7UA,
+	DA9052_BL_CURRENT_1222_2UA,
+	DA9052_BL_CURRENT_1252_3UA,
+	DA9052_BL_CURRENT_1283_3UA,
+	DA9052_BL_CURRENT_1315_0UA,
+	DA9052_BL_CURRENT_1347_5UA,
+	DA9052_BL_CURRENT_1380_7UA,
+	DA9052_BL_CURRENT_1414_8UA,
+	DA9052_BL_CURRENT_1449_8UA,
+	DA9052_BL_CURRENT_1485_6UA,
+	DA9052_BL_CURRENT_1522_3UA,
+	DA9052_BL_CURRENT_1559_9UA,
+	DA9052_BL_CURRENT_1598_4UA,
+	DA9052_BL_CURRENT_1637_9UA,
+	DA9052_BL_CURRENT_1678_4UA,
+	DA9052_BL_CURRENT_1719_8UA,
+	DA9052_BL_CURRENT_1762_3UA,
+	DA9052_BL_CURRENT_1805_8UA,
+	DA9052_BL_CURRENT_1850_4UA,
+	DA9052_BL_CURRENT_1896_1UA,
+	DA9052_BL_CURRENT_1943_0UA,
+	DA9052_BL_CURRENT_1991_0UA,
+	DA9052_BL_CURRENT_2040_2UA,
+	DA9052_BL_CURRENT_2090_5UA,
+	DA9052_BL_CURRENT_2142_2UA,
+	DA9052_BL_CURRENT_2195_1UA,
+	DA9052_BL_CURRENT_2249_3UA,
+	DA9052_BL_CURRENT_2304_9UA,
+	DA9052_BL_CURRENT_2361_8UA,
+	DA9052_BL_CURRENT_2420_1UA,
+	DA9052_BL_CURRENT_2479_9UA,
+	DA9052_BL_CURRENT_2541_2UA,
+	DA9052_BL_CURRENT_2604_0UA,
+	DA9052_BL_CURRENT_2668_3UA,
+	DA9052_BL_CURRENT_2734_2UA,
+	DA9052_BL_CURRENT_2801_7UA,
+	DA9052_BL_CURRENT_2870_9UA,
+	DA9052_BL_CURRENT_2941_8UA,
+	DA9052_BL_CURRENT_3014_5UA,
+	DA9052_BL_CURRENT_3089_0UA,
+	DA9052_BL_CURRENT_3165_3UA,
+	DA9052_BL_CURRENT_3243_4UA,
+	DA9052_BL_CURRENT_3323_5UA,
+	DA9052_BL_CURRENT_3405_6UA,
+	DA9052_BL_CURRENT_3489_8UA,
+	DA9052_BL_CURRENT_3576_0UA,
+	DA9052_BL_CURRENT_3664_3UA,
+	DA9052_BL_CURRENT_3754_8UA,
+	DA9052_BL_CURRENT_3847_5UA,
+	DA9052_BL_CURRENT_3942_6UA,
+	DA9052_BL_CURRENT_4040_0UA,
+	DA9052_BL_CURRENT_4139_7UA,
+	DA9052_BL_CURRENT_4242_0UA,
+	DA9052_BL_CURRENT_4346_8UA,
+	DA9052_BL_CURRENT_4454_1UA,
+	DA9052_BL_CURRENT_4564_2UA,
+	DA9052_BL_CURRENT_4676_9UA,
+	DA9052_BL_CURRENT_4792_4UA,
+	DA9052_BL_CURRENT_4910_8UA,
+	DA9052_BL_CURRENT_5032_1UA,
+	DA9052_BL_CURRENT_5156_4UA,
+	DA9052_BL_CURRENT_5283_7UA,
+	DA9052_BL_CURRENT_5414_3UA,
+	DA9052_BL_CURRENT_5548_0UA,
+	DA9052_BL_CURRENT_5685_0UA,
+	DA9052_BL_CURRENT_5825_5UA,
+	DA9052_BL_CURRENT_5969_3UA,
+	DA9052_BL_CURRENT_6116_8UA,
+	DA9052_BL_CURRENT_6267_9UA,
+	DA9052_BL_CURRENT_6422_7UA,
+	DA9052_BL_CURRENT_6581_3UA,
+	DA9052_BL_CURRENT_6743_9UA,
+	DA9052_BL_CURRENT_6910_5UA,
+	DA9052_BL_CURRENT_7081_2UA,
+	DA9052_BL_CURRENT_7256_1UA,
+	DA9052_BL_CURRENT_7435_3UA,
+	DA9052_BL_CURRENT_7618_9UA,
+	DA9052_BL_CURRENT_7807_1UA,
+	DA9052_BL_CURRENT_8000_0UA,
+	DA9052_BL_CURRENT_8197_6UA,
+	DA9052_BL_CURRENT_8400_0UA,
+	DA9052_BL_CURRENT_8607_5UA,
+	DA9052_BL_CURRENT_8820_1UA,
+	DA9052_BL_CURRENT_9038_0UA,
+	DA9052_BL_CURRENT_9261_2UA,
+	DA9052_BL_CURRENT_9490_0UA,
+	DA9052_BL_CURRENT_9724_4UA,
+	DA9052_BL_CURRENT_9964_6UA,
+	DA9052_BL_CURRENT_10210_7UA,
+	DA9052_BL_CURRENT_10462_9UA,
+	DA9052_BL_CURRENT_10721_4UA,
+	DA9052_BL_CURRENT_10986_4UA,
+	DA9052_BL_CURRENT_11257_5UA,
+	DA9052_BL_CURRENT_11535_6UA,
+	DA9052_BL_CURRENT_11820_5UA,
+	DA9052_BL_CURRENT_12112_5UA,
+	DA9052_BL_CURRENT_12411_7UA,
+	DA9052_BL_CURRENT_12718_2UA,
+	DA9052_BL_CURRENT_13032_4UA,
+	DA9052_BL_CURRENT_13354_3UA,
+	DA9052_BL_CURRENT_13684_1UA,
+	DA9052_BL_CURRENT_14022_1UA,
+	DA9052_BL_CURRENT_14368_5UA,
+	DA9052_BL_CURRENT_14723_4UA,
+	DA9052_BL_CURRENT_15087_1UA,
+	DA9052_BL_CURRENT_15459_7UA,
+	DA9052_BL_CURRENT_15841_6UA,
+	DA9052_BL_CURRENT_16232_9UA,
+	DA9052_BL_CURRENT_16633_8UA,
+	DA9052_BL_CURRENT_17044_7UA,
+	DA9052_BL_CURRENT_17465_7UA,
+	DA9052_BL_CURRENT_17897_1UA,
+	DA9052_BL_CURRENT_18339_1UA,
+	DA9052_BL_CURRENT_18792_1UA,
+	DA9052_BL_CURRENT_19256_3UA,
+	DA9052_BL_CURRENT_19731_9UA,
+	DA9052_BL_CURRENT_20219_3UA,
+	DA9052_BL_CURRENT_20718_7UA,
+	DA9052_BL_CURRENT_21230_5UA,
+	DA9052_BL_CURRENT_21754_8UA,
+	DA9052_BL_CURRENT_22292_2UA,
+	DA9052_BL_CURRENT_22842_8UA,
+	DA9052_BL_CURRENT_23407_0UA,
+	DA9052_BL_CURRENT_23985_2UA,
+	DA9052_BL_CURRENT_24577_6UA,
+	DA9052_BL_CURRENT_25000_0UA,
+};
+
+#endif /* _BL_H */
Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.
