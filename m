Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab0LURip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:38:45 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34926 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab0LURio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:38:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=vmVt+10VUh4puK9luwrasSrQ3ltexoKRsHFa+z6l6kH1t4Ht1K3e0+rvU860fvx9Uh
         MirtcB1E1SPW5QVf0VdUiAZPJg3QP19EYuDCLM5ZVeAjoCOCXiboUeZj0lRq2DdMYrhZ
         O5FJq2+QRMC770urRqBBg8n/JO+PTARB8iaSM=
MIME-Version: 1.0
Date: Tue, 21 Dec 2010 18:38:43 +0100
Message-ID: <AANLkTikC4J-91LXec2HLBXoLyiXk4nmLonpwA-CkhabB@mail.gmail.com>
Subject: [PATCHv2 9/11] BACKLIGHT: Backlight module of DA9052 device driver
From: dd diasemi <dd.diasemi@gmail.com>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BACKLIGHT module for DA9052 PMIC device from Dialog Semiconductor.

Changes made since last submission:
. added registration for three different backlight devices

Linux Kernel Version: 2.6.34

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -Naur linux-2.6.34-orig2/drivers/video/backlight/da9052_bl.c
linux-2.6.34/drivers/video/backlight/da9052_bl.c
--- linux-2.6.34-orig2/drivers/video/backlight/da9052_bl.c	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34/drivers/video/backlight/da9052_bl.c	2010-10-12
14:39:22.000000000 +0500
@@ -0,0 +1,410 @@
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
+#include <linux/backlight.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/bl.h>
+
+
+#define DRIVER_NAME		"da9052-backlight"
+#define DRIVER_NAME1		"WLED-1"
+#define DRIVER_NAME2		"WLED-2"
+#define DRIVER_NAME3		"WLED-3"
+
+/* These flags define if Backlight LEDs are present */
+/* Set the following macros to 1, if LEDs are present. Otherwise set to 0 */
+#define DA9052_LED1_PRESENT	1
+#define DA9052_LED2_PRESENT	1
+#define DA9052_LED3_PRESENT	1
+
+#define DA9052_MAX_BRIGHTNESS	0xA0
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
+static int da9052_backlight_brightness_set(struct da9052_backlight_data *data,
+			int brightness, enum da9052_led_number led)
+{
+	int ret = 0;
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
+	break;
+	case LED2:
+		led_ramp_bit = DA9052_LEDCONT_LED2RAMP;
+		led_current_register = DA9052_LED2CONF_REG;
+		led_current_sink_bit = DA9052_LEDCONT_LED2EN;
+		led_boost_en_bit = DA9052_BOOST_LED2INEN;
+	break;
+	case LED3:
+		led_ramp_bit = DA9052_LEDCONT_LED3RAMP;
+		led_current_register = DA9052_LED3CONF_REG;
+		led_current_sink_bit = DA9052_LEDCONT_LED3EN;
+		led_boost_en_bit = DA9052_BOOST_LED3INEN;
+	break;
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
+	msg.addr = led_current_register;
+	msg.data = brightness;
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
+	da9052_lock(data->da9052);
+	ret = data->da9052->read(data->da9052, &msg);
+	if (ret) {
+		da9052_unlock(data->da9052);
+		return ret;
+	}
+	da9052_unlock(data->da9052);
+
+	msg.data = brightness ? (msg.data | led_current_sink_bit) :
+			(msg.data & ~(led_current_sink_bit));
+	msg.data = (msg.data & ~(led_ramp_bit));
+
+	da9052_lock(data->da9052);
+	ret = data->da9052->write(data->da9052, &msg);
+	if (ret) {
+		da9052_unlock(data->da9052);
+		return ret;
+	}
+	da9052_unlock(data->da9052);
+
+	msg.addr = DA9052_BOOST_REG;
+	msg.data = 0;
+
+	da9052_lock(data->da9052);
+	ret = data->da9052->read(data->da9052, &msg);
+	if (ret) {
+		da9052_unlock(data->da9052);
+		return ret;
+	}
+	da9052_unlock(data->da9052);
+
+	msg.data = brightness ? (msg.data | led_boost_en_bit) :
+			(msg.data & ~(led_boost_en_bit));
+
+	if (0 == (data->is_led1_present | data->is_led2_present |
+			data->is_led3_present)) {
+		msg.data = msg.data & ~(DA9052_BOOST_BOOSTEN);
+	} else
+			msg.data = (msg.data | DA9052_BOOST_BOOSTEN);
+
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
+static int da9052_backlight_set(struct backlight_device *bl, int brightness)
+{
+	struct da9052_backlight_data *data = bl_get_data(bl);
+	int ret = 0;
+
+	if (1 == data->is_led1_present) {
+		ret = da9052_backlight_brightness_set(data, brightness, LED1);
+		if (ret)
+			return ret;
+	}
+
+	if (1 == data->is_led2_present) {
+		ret = da9052_backlight_brightness_set(data, brightness, LED2);
+		if (ret)
+			return ret;
+	}
+
+	if (1 == data->is_led3_present) {
+		ret = da9052_backlight_brightness_set(data, brightness, LED3);
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
+	return da9052_backlight_set(bl, brightness);
+}
+
+static int da9052_backlight_get_brightness(struct backlight_device *bl)
+{
+	struct da9052_backlight_data *data = bl_get_data(bl);
+	return data->current_brightness;
+}
+
+struct backlight_ops da9052_backlight_ops = {
+	.update_status	= da9052_backlight_update_status,
+	.get_brightness	= da9052_backlight_get_brightness,
+};
+
+static int da9052_backlight_probe1(struct platform_device *pdev)
+{
+	struct da9052_backlight_data *data;
+	struct backlight_device *bl;
+	struct backlight_properties props;
+	struct da9052 *da9052 = dev_get_drvdata(pdev->dev.parent);
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+	data->da9052_dev = pdev->dev.parent;
+	data->da9052 = da9052;
+	data->current_brightness = 0;
+
+	data->is_led1_present = DA9052_LED1_PRESENT;
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
+	platform_set_drvdata(pdev, bl);
+
+	backlight_update_status(bl);
+
+	/*
+	 * NOTE:
+	 * The default settings for DA9052 registers depends upon OTP values.
+	 * E.g. The configuration of BOOST register, minimum value for LED
+	 * current etc. are taken from OTP
+	 */
+	return 0;
+}
+static int da9052_backlight_probe2(struct platform_device *pdev)
+{
+	struct da9052_backlight_data *data;
+	struct backlight_device *bl;
+	struct backlight_properties props;
+	struct da9052 *da9052 = dev_get_drvdata(pdev->dev.parent);
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+	data->da9052_dev = pdev->dev.parent;
+	data->da9052	= da9052;
+	data->current_brightness = 0;
+
+	data->is_led2_present = DA9052_LED2_PRESENT;
+	bl = backlight_device_register(pdev->name, data->da9052_dev,
+			data, &da9052_backlight_ops, &props);
+
+	if (IS_ERR(bl)) {
+		dev_err(&pdev->dev, "failed to register backlight\n");
+		kfree(data);
+		return PTR_ERR(bl);
+	}
+
+	bl->props.max_brightness = DA9052_MAX_BRIGHTNESS;
+	bl->props.brightness = 0;
+	platform_set_drvdata(pdev, bl);
+
+	backlight_update_status(bl);
+
+	/*
+	 * NOTE:
+	 * The default settings for DA9052 registers depends upon OTP values.
+	 * E.g. The configuration of BOOST register, minimum value for LED
+	 * current etc. are taken from OTP
+	 */
+
+	return 0;
+}
+static int da9052_backlight_probe3(struct platform_device *pdev)
+{
+	struct da9052_backlight_data *data;
+	struct backlight_device *bl;
+	struct backlight_properties props;
+	struct da9052 *da9052 = dev_get_drvdata(pdev->dev.parent);
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+	data->da9052_dev = pdev->dev.parent;
+	data->da9052	= da9052;
+	data->current_brightness = 0;
+
+	data->is_led3_present = DA9052_LED3_PRESENT;
+	bl = backlight_device_register(pdev->name, data->da9052_dev,
+			data, &da9052_backlight_ops, &props);
+
+	if (IS_ERR(bl)) {
+		dev_err(&pdev->dev, "failed to register backlight\n");
+		kfree(data);
+		return PTR_ERR(bl);
+	}
+
+	bl->props.max_brightness = DA9052_MAX_BRIGHTNESS;
+	bl->props.brightness = 0;
+	platform_set_drvdata(pdev, bl);
+
+	backlight_update_status(bl);
+
+	/*
+	 * NOTE:
+	 * The default settings for DA9052 registers depends upon OTP values.
+	 * E.g. The configuration of BOOST register, minimum value for LED
+	 * current etc. are taken from OTP
+	 */
+
+	return 0;
+}
+
+static int da9052_backlight_remove1(struct platform_device *pdev)
+{
+	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct da9052_backlight_data *data = bl_get_data(bl);
+
+	backlight_device_unregister(bl);
+	kfree(data);
+	return 0;
+}
+
+static int da9052_backlight_remove2(struct platform_device *pdev)
+{
+	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct da9052_backlight_data *data = bl_get_data(bl);
+
+	backlight_device_unregister(bl);
+	kfree(data);
+	return 0;
+}
+static int da9052_backlight_remove3(struct platform_device *pdev)
+{
+	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct da9052_backlight_data *data = bl_get_data(bl);
+
+	backlight_device_unregister(bl);
+	kfree(data);
+	return 0;
+}
+
+static struct platform_driver da9052_backlight_driver1 = {
+	.driver		= {
+		.name	= DRIVER_NAME1,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= da9052_backlight_probe1,
+	.remove		= da9052_backlight_remove1,
+};
+static struct platform_driver da9052_backlight_driver2 = {
+	.driver		= {
+		.name	= DRIVER_NAME2,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= da9052_backlight_probe2,
+	.remove		= da9052_backlight_remove2,
+};
+static struct platform_driver da9052_backlight_driver3 = {
+	.driver		= {
+		.name	= DRIVER_NAME3,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= da9052_backlight_probe3,
+	.remove		= da9052_backlight_remove3,
+};
+
+static int __init da9052_backlight_init(void)
+{
+	s32 ret;
+	ret = platform_driver_register(&da9052_backlight_driver1);
+	if (ret)
+		return ret;
+	ret = platform_driver_register(&da9052_backlight_driver2);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_register(&da9052_backlight_driver3);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+module_init(da9052_backlight_init);
+
+static void __exit da9052_backlight_exit(void)
+{
+	platform_driver_unregister(&da9052_backlight_driver1);
+	platform_driver_unregister(&da9052_backlight_driver2);
+	platform_driver_unregister(&da9052_backlight_driver3);
+}
+module_exit(da9052_backlight_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("Backlight driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
+
diff -Naur linux-2.6.34-orig2/drivers/video/backlight/Kconfig
linux-2.6.34/drivers/video/backlight/Kconfig
--- linux-2.6.34-orig2/drivers/video/backlight/Kconfig	2010-10-12
18:22:19.000000000 +0500
+++ linux-2.6.34/drivers/video/backlight/Kconfig	2010-10-12
15:48:41.000000000 +0500
@@ -219,6 +219,14 @@
 	  If you have a LCD backlight connected to the WLED output of DA9030
 	  or DA9034 WLED output, say Y here to enable this driver.

+config BACKLIGHT_DA9052
+	tristate "Dialog DA9052 WLED"
+	depends on PMIC_DA9052
+	select BACKLIGHT_CLASS_DEVICE
+	help
+	  Enable the DA9052 Backlight Driver
+
+
 config BACKLIGHT_MAX8925
 	tristate "Backlight driver for MAX8925"
 	depends on BACKLIGHT_CLASS_DEVICE && MFD_MAX8925
diff -Naur linux-2.6.34-orig2/drivers/video/backlight/Makefile
linux-2.6.34/drivers/video/backlight/Makefile
--- linux-2.6.34-orig2/drivers/video/backlight/Makefile	2010-10-12
18:22:10.000000000 +0500
+++ linux-2.6.34/drivers/video/backlight/Makefile	2010-10-12
15:49:18.000000000 +0500
@@ -23,6 +23,7 @@
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
 obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o
 obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x_bl.o
+obj-$(CONFIG_BACKLIGHT_DA9052)	+= da9052_bl.o
 obj-$(CONFIG_BACKLIGHT_MAX8925)	+= max8925_bl.o
 obj-$(CONFIG_BACKLIGHT_MBP_NVIDIA) += mbp_nvidia_bl.o
 obj-$(CONFIG_BACKLIGHT_TOSA)	+= tosa_bl.o
diff -Naur linux-2.6.34-orig2/include/linux/mfd/da9052/bl.h
linux-2.6.34/include/linux/mfd/da9052/bl.h
--- linux-2.6.34-orig2/include/linux/mfd/da9052/bl.h	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34/include/linux/mfd/da9052/bl.h	2010-10-12
09:55:03.000000000 +0500
@@ -0,0 +1,289 @@
+/*
+ * da9052 Backlight module declarations.
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
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
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __LINUX_MFD_DA9052_BL_H
+#define __LINUX_MFD_DA9052_BL_H
+
+/*
+ * enum da9052_bl_current_value - Enum for current values of LED
+ * DA9052_BL_CURRENT_50_0UA: represents 50.0 uA current value
+ */
+enum da9052_bl_current_value {
+/* Current Value for LEDMIN, LED1_CONF, LED2_CONF, LED3_CONF Registers */
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
+#endif /* __LINUX_MFD_DA9052_BL_H */
