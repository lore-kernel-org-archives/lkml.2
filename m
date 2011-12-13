Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab1LMIOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 03:14:22 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20993 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab1LMIOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 03:14:20 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-98-4ee709587429
From: Donggeun Kim <dg77.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rpurdie@rpsys.net,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com
Subject: [PATCH RESEND 2/2] leds: add suuport for MAX8997-LED driver
Date: Tue, 13 Dec 2011 17:13:53 +0900
Message-id: <1323764033-3979-3-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1323764033-3979-1-git-send-email-dg77.kim@samsung.com>
References: <1323764033-3979-1-git-send-email-dg77.kim@samsung.com>
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables LED controller in MAX8997 PMIC.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/leds/Kconfig        |    7 +
 drivers/leds/Makefile       |    1 +
 drivers/leds/leds-max8997.c |  372 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 380 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-max8997.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index ff203a4..c0e30e8 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -387,6 +387,13 @@ config LEDS_RENESAS_TPU
 	  pin function. The latter to support brightness control.
 	  Brightness control is supported but hardware blinking is not.
 
+config LEDS_MAX8997
+	tristate "LED support for MAX8997 PMIC"
+	depends on LEDS_CLASS && MFD_MAX8997
+	help
+	  This option enables support for on-chip LED drivers on
+	  MAXIM MAX8997 PMIC.
+
 config LEDS_TRIGGERS
 	bool "LED Trigger support"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index e4f6bf5..17f1e98 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_LEDS_NS2)			+= leds-ns2.o
 obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
 obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
 obj-$(CONFIG_LEDS_RENESAS_TPU)		+= leds-renesas-tpu.o
+obj-$(CONFIG_LEDS_MAX8997)		+= leds-max8997.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff --git a/drivers/leds/leds-max8997.c b/drivers/leds/leds-max8997.c
new file mode 100644
index 0000000..f4c0e37
--- /dev/null
+++ b/drivers/leds/leds-max8997.c
@@ -0,0 +1,372 @@
+/*
+ * leds-max8997.c - LED class driver for MAX8997 LEDs.
+ *
+ * Copyright (C) 2011 Samsung Electronics
+ * Donggeun Kim <dg77.kim@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include <linux/leds.h>
+#include <linux/mfd/max8997.h>
+#include <linux/mfd/max8997-private.h>
+#include <linux/platform_device.h>
+
+#define MAX8997_LED_FLASH_SHIFT			3
+#define MAX8997_LED_FLASH_CUR_MASK		0xf8
+#define MAX8997_LED_MOVIE_SHIFT			4
+#define MAX8997_LED_MOVIE_CUR_MASK		0xf0
+
+#define MAX8997_LED_FLASH_MAX_BRIGHTNESS	0x1f
+#define MAX8997_LED_MOVIE_MAX_BRIGHTNESS	0xf
+#define MAX8997_LED_NONE_MAX_BRIGHTNESS		0
+
+#define MAX8997_LED0_FLASH_MASK			0x1
+#define MAX8997_LED0_FLASH_PIN_MASK		0x5
+#define MAX8997_LED0_MOVIE_MASK			0x8
+#define MAX8997_LED0_MOVIE_PIN_MASK		0x28
+
+#define MAX8997_LED1_FLASH_MASK			0x2
+#define MAX8997_LED1_FLASH_PIN_MASK		0x6
+#define MAX8997_LED1_MOVIE_MASK			0x10
+#define MAX8997_LED1_MOVIE_PIN_MASK		0x30
+
+#define MAX8997_LED_BOOST_ENABLE_MASK		(1 << 6)
+
+struct max8997_led {
+	struct max8997_dev *iodev;
+	struct led_classdev cdev;
+	bool enabled;
+	int id;
+	enum max8997_led_mode led_mode;
+	struct mutex mutex;
+};
+
+static void max8997_led_clear_mode(struct max8997_led *led,
+			enum max8997_led_mode mode)
+{
+	struct i2c_client *client = led->iodev->i2c;
+	u8 val = 0, mask = 0;
+	int ret;
+
+	switch (mode) {
+	case MAX8997_FLASH_MODE:
+		mask = led->id ?
+		      MAX8997_LED1_FLASH_MASK : MAX8997_LED0_FLASH_MASK;
+		break;
+	case MAX8997_MOVIE_MODE:
+		mask = led->id ?
+		      MAX8997_LED1_MOVIE_MASK : MAX8997_LED0_MOVIE_MASK;
+		break;
+	case MAX8997_FLASH_PIN_CONTROL_MODE:
+		mask = led->id ?
+		      MAX8997_LED1_FLASH_PIN_MASK : MAX8997_LED0_FLASH_PIN_MASK;
+		break;
+	case MAX8997_MOVIE_PIN_CONTROL_MODE:
+		mask = led->id ?
+		      MAX8997_LED1_MOVIE_PIN_MASK : MAX8997_LED0_MOVIE_PIN_MASK;
+		break;
+	default:
+		break;
+	}
+
+	if (mask) {
+		ret = max8997_update_reg(client,
+				MAX8997_REG_LEN_CNTL, val, mask);
+		if (ret)
+			dev_err(led->iodev->dev,
+				"failed to update register(%d)\n", ret);
+	}
+}
+
+static void max8997_led_set_mode(struct max8997_led *led,
+			enum max8997_led_mode mode)
+{
+	int ret;
+	struct i2c_client *client = led->iodev->i2c;
+	u8 mask = 0;
+
+	/* First, clear the previous mode */
+	max8997_led_clear_mode(led, led->led_mode);
+
+	switch (mode) {
+	case MAX8997_FLASH_MODE:
+		mask = led->id ?
+		      MAX8997_LED1_FLASH_MASK : MAX8997_LED0_FLASH_MASK;
+		led->cdev.max_brightness = MAX8997_LED_FLASH_MAX_BRIGHTNESS;
+		break;
+	case MAX8997_MOVIE_MODE:
+		mask = led->id ?
+		      MAX8997_LED1_MOVIE_MASK : MAX8997_LED0_MOVIE_MASK;
+		led->cdev.max_brightness = MAX8997_LED_MOVIE_MAX_BRIGHTNESS;
+		break;
+	case MAX8997_FLASH_PIN_CONTROL_MODE:
+		mask = led->id ?
+		      MAX8997_LED1_FLASH_PIN_MASK : MAX8997_LED0_FLASH_PIN_MASK;
+		led->cdev.max_brightness = MAX8997_LED_FLASH_MAX_BRIGHTNESS;
+		break;
+	case MAX8997_MOVIE_PIN_CONTROL_MODE:
+		mask = led->id ?
+		      MAX8997_LED1_MOVIE_PIN_MASK : MAX8997_LED0_MOVIE_PIN_MASK;
+		led->cdev.max_brightness = MAX8997_LED_MOVIE_MAX_BRIGHTNESS;
+		break;
+	default:
+		led->cdev.max_brightness = MAX8997_LED_NONE_MAX_BRIGHTNESS;
+		break;
+	}
+
+	if (mask) {
+		ret = max8997_update_reg(client,
+				MAX8997_REG_LEN_CNTL, mask, mask);
+		if (ret)
+			dev_err(led->iodev->dev,
+				"failed to update register(%d)\n", ret);
+	}
+
+	led->led_mode = mode;
+}
+
+static void max8997_led_enable(struct max8997_led *led, bool enable)
+{
+	int ret;
+	struct i2c_client *client = led->iodev->i2c;
+	u8 val = 0, mask = MAX8997_LED_BOOST_ENABLE_MASK;
+
+	if (led->enabled == enable)
+		return;
+
+	val = enable ? MAX8997_LED_BOOST_ENABLE_MASK : 0;
+
+	ret = max8997_update_reg(client, MAX8997_REG_BOOST_CNTL, val, mask);
+	if (ret)
+		dev_err(led->iodev->dev,
+			"failed to update register(%d)\n", ret);
+
+	led->enabled = enable;
+}
+
+static void max8997_led_set_current(struct max8997_led *led,
+				enum led_brightness value)
+{
+	int ret;
+	struct i2c_client *client = led->iodev->i2c;
+	u8 val = 0, mask = 0, reg = 0;
+
+	switch (led->led_mode) {
+	case MAX8997_FLASH_MODE:
+	case MAX8997_FLASH_PIN_CONTROL_MODE:
+		val = value << MAX8997_LED_FLASH_SHIFT;
+		mask = MAX8997_LED_FLASH_CUR_MASK;
+		reg = led->id ? MAX8997_REG_FLASH2_CUR : MAX8997_REG_FLASH1_CUR;
+		break;
+	case MAX8997_MOVIE_MODE:
+	case MAX8997_MOVIE_PIN_CONTROL_MODE:
+		val = value << MAX8997_LED_MOVIE_SHIFT;
+		mask = MAX8997_LED_MOVIE_CUR_MASK;
+		reg = MAX8997_REG_MOVIE_CUR;
+		break;
+	default:
+		break;
+	}
+
+	if (mask) {
+		ret = max8997_update_reg(client, reg, val, mask);
+		if (ret)
+			dev_err(led->iodev->dev,
+				"failed to update register(%d)\n", ret);
+	}
+}
+
+static void max8997_led_brightness_set(struct led_classdev *led_cdev,
+				enum led_brightness value)
+{
+	struct max8997_led *led =
+			container_of(led_cdev, struct max8997_led, cdev);
+
+	if (value) {
+		max8997_led_set_current(led, value);
+		max8997_led_enable(led, true);
+	} else {
+		max8997_led_set_current(led, value);
+		max8997_led_enable(led, false);
+	}
+}
+
+static ssize_t max8997_led_show_mode(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct max8997_led *led =
+			container_of(led_cdev, struct max8997_led, cdev);
+	ssize_t ret = 0;
+
+	mutex_lock(&led->mutex);
+
+	switch (led->led_mode) {
+	case MAX8997_FLASH_MODE:
+		ret += sprintf(buf, "FLASH\n");
+		break;
+	case MAX8997_MOVIE_MODE:
+		ret += sprintf(buf, "MOVIE\n");
+		break;
+	case MAX8997_FLASH_PIN_CONTROL_MODE:
+		ret += sprintf(buf, "FLASH_PIN_CONTROL\n");
+		break;
+	case MAX8997_MOVIE_PIN_CONTROL_MODE:
+		ret += sprintf(buf, "MOVIE_PIN_CONTROL\n");
+		break;
+	default:
+		ret += sprintf(buf, "NONE\n");
+		break;
+	}
+
+	mutex_unlock(&led->mutex);
+
+	return ret;
+}
+
+static ssize_t max8997_led_store_mode(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct max8997_led *led =
+			container_of(led_cdev, struct max8997_led, cdev);
+	enum max8997_led_mode mode;
+
+	mutex_lock(&led->mutex);
+
+	if (!strncmp(buf, "FLASH_PIN_CONTROL", 17))
+		mode = MAX8997_FLASH_PIN_CONTROL_MODE;
+	else if (!strncmp(buf, "MOVIE_PIN_CONTROL", 17))
+		mode = MAX8997_MOVIE_PIN_CONTROL_MODE;
+	else if (!strncmp(buf, "FLASH", 5))
+		mode = MAX8997_FLASH_MODE;
+	else if (!strncmp(buf, "MOVIE", 5))
+		mode = MAX8997_MOVIE_MODE;
+	else
+		mode = MAX8997_NONE;
+
+	max8997_led_set_mode(led, mode);
+
+	mutex_unlock(&led->mutex);
+
+	return size;
+}
+
+static DEVICE_ATTR(mode, 0644, max8997_led_show_mode, max8997_led_store_mode);
+
+static int __devinit max8997_led_probe(struct platform_device *pdev)
+{
+	struct max8997_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct max8997_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct max8997_led *led;
+	char name[20];
+	int ret = 0;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "no platform data\n");
+		return -ENODEV;
+	}
+
+	led = kzalloc(sizeof(*led), GFP_KERNEL);
+	if (led == NULL) {
+		ret = -ENOMEM;
+		goto err_mem;
+	}
+
+	led->id = pdev->id;
+	snprintf(name, sizeof(name), "max8997-led%d", pdev->id);
+
+	led->cdev.name = name;
+	led->cdev.brightness_set = max8997_led_brightness_set;
+	led->cdev.flags |= LED_CORE_SUSPENDRESUME;
+	led->cdev.brightness = 0;
+	led->iodev = iodev;
+
+	/* initialize mode and brightness according to platform_data */
+	if (pdata->led_pdata) {
+		u8 mode = 0, brightness = 0;
+
+		mode = pdata->led_pdata->mode[led->id];
+		brightness = pdata->led_pdata->brightness[led->id];
+
+		max8997_led_set_mode(led, pdata->led_pdata->mode[led->id]);
+
+		if (brightness > led->cdev.max_brightness)
+			brightness = led->cdev.max_brightness;
+		max8997_led_set_current(led, brightness);
+		led->cdev.brightness = brightness;
+	} else {
+		max8997_led_set_mode(led, MAX8997_NONE);
+		max8997_led_set_current(led, 0);
+	}
+
+	mutex_init(&led->mutex);
+
+	platform_set_drvdata(pdev, led);
+
+	ret = led_classdev_register(&pdev->dev, &led->cdev);
+	if (ret < 0)
+		goto err_led;
+
+	ret = device_create_file(led->cdev.dev, &dev_attr_mode);
+	if (ret != 0) {
+		dev_err(&pdev->dev,
+			"failed to create file: %d\n", ret);
+		goto err_file;
+	}
+
+	return 0;
+
+err_file:
+	led_classdev_unregister(&led->cdev);
+err_led:
+	kfree(led);
+err_mem:
+	return ret;
+}
+
+static int __devexit max8997_led_remove(struct platform_device *pdev)
+{
+	struct max8997_led *led = platform_get_drvdata(pdev);
+
+	device_remove_file(led->cdev.dev, &dev_attr_mode);
+	led_classdev_unregister(&led->cdev);
+	kfree(led);
+
+	return 0;
+}
+
+static struct platform_driver max8997_led_driver = {
+	.driver = {
+		.name  = "max8997-led",
+		.owner = THIS_MODULE,
+	},
+	.probe  = max8997_led_probe,
+	.remove = __devexit_p(max8997_led_remove),
+};
+
+static int __init max8997_led_init(void)
+{
+	return platform_driver_register(&max8997_led_driver);
+}
+module_init(max8997_led_init);
+
+static void __exit max8997_led_exit(void)
+{
+	platform_driver_unregister(&max8997_led_driver);
+}
+module_exit(max8997_led_exit);
+
+MODULE_AUTHOR("Donggeun Kim <dg77.kim@samsung.com>");
+MODULE_DESCRIPTION("MAX8997 LED driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:max8997-led");
-- 
1.7.4.1

