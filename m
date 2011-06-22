Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab1FVKuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:50:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30591 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab1FVKt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:49:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6384"; a="99296500"
From: Anirudh Ghayal <aghayal@codeaurora.org>
To: Lars-Peter Clausen <lars@metafoo.de>, Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Anirudh Ghayal <aghayal@codeaurora.org>,
        Trilok Soni <tsoni@codeaurora.org>
Subject: [PATCH V1] led: pm8xxx: Add pm8xxx leds driver
Date: Wed, 22 Jun 2011 16:19:43 +0530
Message-Id: <1308739783-4643-1-git-send-email-aghayal@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Qualcomm PMIC8XXX keyboard
backlight, flash and low current leds.

Signed-off-by: Trilok Soni <tsoni@codeaurora.org>
Signed-off-by: Anirudh Ghayal <aghayal@codeaurora.org>
---
Changes:
    Addressed below comments from Peter.
    http://www.mail-archive.com/linux-arm-msm@vger.kernel.org/msg02051.html
    Use led_info and led_platform data

 drivers/leds/Kconfig        |   11 ++
 drivers/leds/Makefile       |    1 +
 drivers/leds/leds-pm8xxx.c  |  350 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/leds-pm8xxx.h |   37 +++++
 4 files changed, 399 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-pm8xxx.c
 create mode 100644 include/linux/leds-pm8xxx.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 713d43b..90942dc 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -269,6 +269,17 @@ config LEDS_PCA955X
 	  LED driver chips accessed via the I2C bus.  Supported
 	  devices include PCA9550, PCA9551, PCA9552, and PCA9553.
 
+config LEDS_PM8XXX
+	tristate "LED Support for Qualcomm PMIC8XXX"
+	depends on MFD_PM8XXX
+	help
+	  This option enables support for LEDs connected over PMIC8XXX
+	  (Power Management IC) chip on Qualcomm reference boards,
+	  for example SURF and FFAs.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called leds-pmic8xxx.
+
 config LEDS_WM831X_STATUS
 	tristate "LED support for status LEDs on WM831x PMICs"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index bbfd2e3..c102ae0 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
 obj-$(CONFIG_LEDS_SUNFIRE)		+= leds-sunfire.o
 obj-$(CONFIG_LEDS_PCA9532)		+= leds-pca9532.o
 obj-$(CONFIG_LEDS_GPIO_REGISTER)	+= leds-gpio-register.o
+obj-$(CONFIG_LEDS_PM8XXX)		+= leds-pm8xxx.o
 obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
 obj-$(CONFIG_LEDS_LP3944)		+= leds-lp3944.o
 obj-$(CONFIG_LEDS_LP5521)		+= leds-lp5521.o
diff --git a/drivers/leds/leds-pm8xxx.c b/drivers/leds/leds-pm8xxx.c
new file mode 100644
index 0000000..e8e758f
--- /dev/null
+++ b/drivers/leds/leds-pm8xxx.c
@@ -0,0 +1,350 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <linux/workqueue.h>
+
+#include <linux/mfd/pm8xxx/core.h>
+#include <linux/leds-pm8xxx.h>
+
+#define SSBI_REG_ADDR_DRV_KEYPAD	0x48
+#define PM8XXX_DRV_KEYPAD_BL_MASK	0xf0
+#define PM8XXX_DRV_KEYPAD_BL_SHIFT	0x04
+
+#define SSBI_REG_ADDR_FLASH_DRV0        0x49
+#define PM8XXX_DRV_FLASH_MASK           0xf0
+#define PM8XXX_DRV_FLASH_SHIFT          0x04
+
+#define SSBI_REG_ADDR_FLASH_DRV1        0xFB
+
+#define SSBI_REG_ADDR_LED_CTRL_BASE	0x131
+#define SSBI_REG_ADDR_LED_CTRL(n)	(SSBI_REG_ADDR_LED_CTRL_BASE + (n))
+#define PM8XXX_DRV_LED_CTRL_MASK	0xf8
+#define PM8XXX_DRV_LED_CTRL_SHIFT	0x03
+
+#define MAX_FLASH_LED_CURRENT	300
+#define MAX_LC_LED_CURRENT	40
+#define MAX_KP_BL_LED_CURRENT	300
+
+#define MAX_KEYPAD_BL_LEVEL	(1 << 4)
+#define MAX_LED_DRV_LEVEL	20 /* 2 * 20 mA */
+
+#define PM8XXX_LED_OFFSET(id) ((id) - PM8XXX_ID_LED_0)
+
+#define MAX_KB_LED_BRIGHTNESS		15
+#define MAX_LC_LED_BRIGHTNESS		20
+#define MAX_FLASH_LED_BRIGHTNESS	15
+
+#define PM8XXX_MAX_LEDS		7
+
+/**
+ * struct pm8xxx_led_data - internal led data structure
+ * @led_classdev - led class device
+ * @id - led index
+ * @led_brightness - led brightness levels
+ * @work - workqueue for led
+ * @lock - to protect the transactions
+ * @reg - cached value of led register
+ */
+struct pm8xxx_led_data {
+	struct led_classdev	cdev;
+	int			id;
+	u8			reg;
+	enum led_brightness	brightness;
+	struct device		*dev;
+	struct work_struct	work;
+	struct mutex		lock;
+};
+
+static void led_kp_set(struct pm8xxx_led_data *led, enum led_brightness value)
+{
+	int rc;
+	u8 level;
+
+	level = (value << PM8XXX_DRV_KEYPAD_BL_SHIFT) &
+				 PM8XXX_DRV_KEYPAD_BL_MASK;
+
+	led->reg &= ~PM8XXX_DRV_KEYPAD_BL_MASK;
+	led->reg |= level;
+
+	rc = pm8xxx_writeb(led->dev->parent, SSBI_REG_ADDR_DRV_KEYPAD,
+								led->reg);
+	if (rc < 0)
+		dev_err(led->cdev.dev, "can't set keypad backlight level\n");
+}
+
+static void led_lc_set(struct pm8xxx_led_data *led, enum led_brightness value)
+{
+	int rc, offset;
+	u8 level;
+
+	level = (value << PM8XXX_DRV_LED_CTRL_SHIFT) &
+				PM8XXX_DRV_LED_CTRL_MASK;
+
+	offset = PM8XXX_LED_OFFSET(led->id);
+
+	led->reg &= ~PM8XXX_DRV_LED_CTRL_MASK;
+	led->reg |= level;
+
+	rc = pm8xxx_writeb(led->dev->parent, SSBI_REG_ADDR_LED_CTRL(offset),
+								led->reg);
+	if (rc)
+		dev_err(led->cdev.dev, "can't set (%d) led value\n",
+				led->id);
+}
+
+static void
+led_flash_set(struct pm8xxx_led_data *led, enum led_brightness value)
+{
+	int rc;
+	u8 level;
+	u16 reg_addr;
+
+	level = (value << PM8XXX_DRV_FLASH_SHIFT) &
+				 PM8XXX_DRV_FLASH_MASK;
+
+	led->reg &= ~PM8XXX_DRV_FLASH_MASK;
+	led->reg |= level;
+
+	if (led->id == PM8XXX_ID_FLASH_LED_0)
+		reg_addr = SSBI_REG_ADDR_FLASH_DRV0;
+	else
+		reg_addr = SSBI_REG_ADDR_FLASH_DRV1;
+
+	rc = pm8xxx_writeb(led->dev->parent, reg_addr, led->reg);
+	if (rc < 0)
+		dev_err(led->cdev.dev, "can't set flash led%d level\n",
+			 led->id);
+}
+
+static void pm8xxx_led_work(struct work_struct *work)
+{
+	struct pm8xxx_led_data *led = container_of(work,
+					 struct pm8xxx_led_data, work);
+
+	mutex_lock(&led->lock);
+
+	switch (led->id) {
+	case PM8XXX_ID_LED_KB_LIGHT:
+		led_kp_set(led, led->brightness);
+	break;
+	case PM8XXX_ID_LED_0:
+	case PM8XXX_ID_LED_1:
+	case PM8XXX_ID_LED_2:
+		led_lc_set(led, led->brightness);
+	break;
+	case PM8XXX_ID_FLASH_LED_0:
+	case PM8XXX_ID_FLASH_LED_1:
+		led_flash_set(led, led->brightness);
+	break;
+	}
+
+	mutex_unlock(&led->lock);
+}
+
+static void pm8xxx_led_set(struct led_classdev *led_cdev,
+	enum led_brightness value)
+{
+	struct pm8xxx_led_data *led;
+
+	led = container_of(led_cdev, struct pm8xxx_led_data, cdev);
+
+	led->brightness = value;
+	schedule_work(&led->work);
+}
+
+static enum led_brightness pm8xxx_led_get(struct led_classdev *led_cdev)
+{
+	struct pm8xxx_led_data *led;
+
+	led = container_of(led_cdev, struct pm8xxx_led_data, cdev);
+
+	return led->brightness;
+}
+
+static int __devinit get_max_brightness(enum pm8xxx_leds id)
+{
+	switch (id) {
+	case PM8XXX_ID_LED_KB_LIGHT:
+		return MAX_KB_LED_BRIGHTNESS;
+	case PM8XXX_ID_LED_0:
+	case PM8XXX_ID_LED_1:
+	case PM8XXX_ID_LED_2:
+		return MAX_LC_LED_BRIGHTNESS;
+	case PM8XXX_ID_FLASH_LED_0:
+	case PM8XXX_ID_FLASH_LED_1:
+		return MAX_FLASH_LED_CURRENT;
+	default:
+		return 0;
+	}
+}
+
+static int __devinit get_init_value(struct pm8xxx_led_data *led, u8 *val)
+{
+	int rc, offset;
+	u16 addr;
+
+	switch (led->id) {
+	case PM8XXX_ID_LED_KB_LIGHT:
+		addr = SSBI_REG_ADDR_DRV_KEYPAD;
+		break;
+	case PM8XXX_ID_LED_0:
+	case PM8XXX_ID_LED_1:
+	case PM8XXX_ID_LED_2:
+		offset = PM8XXX_LED_OFFSET(led->id);
+		addr = SSBI_REG_ADDR_LED_CTRL(offset);
+		break;
+	case PM8XXX_ID_FLASH_LED_0:
+		addr = SSBI_REG_ADDR_FLASH_DRV0;
+		break;
+	case PM8XXX_ID_FLASH_LED_1:
+		addr = SSBI_REG_ADDR_FLASH_DRV1;
+		break;
+	}
+
+	rc = pm8xxx_readb(led->dev->parent, addr, val);
+	if (rc)
+		dev_err(led->cdev.dev, "can't get led(%d) level\n", led->id);
+
+	return rc;
+}
+
+static int __devinit pm8xxx_led_probe(struct platform_device *pdev)
+{
+	const struct led_platform_data *pdata = pdev->dev.platform_data;
+	struct pm8xxx_led_data *led_dat;
+	struct led_info *curr_led;
+	int rc, i;
+	struct pm8xxx_led_data *led;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "platform data not supplied\n");
+		return -EINVAL;
+	}
+
+	if (pdata->num_leds > PM8XXX_MAX_LEDS) {
+		dev_err(&pdev->dev, "can't handle more than %d LEDs\n",
+				 PM8XXX_MAX_LEDS);
+		return -EFAULT;
+	}
+
+	led = kcalloc(PM8XXX_MAX_LEDS, sizeof(*led), GFP_KERNEL);
+	if (led == NULL) {
+		dev_err(&pdev->dev, "failed to alloc memory\n");
+		return -ENOMEM;
+	}
+
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		curr_led	= &pdata->leds[i];
+		led_dat		= &led[curr_led->flags];
+		/* the flags variable is used for led-id */
+		led_dat->id     = curr_led->flags;
+
+		if (!((led_dat->id >= PM8XXX_ID_LED_KB_LIGHT) &&
+				(led_dat->id <= PM8XXX_ID_FLASH_LED_1))) {
+			dev_err(&pdev->dev, "invalid LED ID (%d) specified\n",
+						 led_dat->id);
+			rc = -EINVAL;
+			goto fail_id_check;
+		}
+
+		led_dat->cdev.name		= curr_led->name;
+		led_dat->cdev.default_trigger   = curr_led->default_trigger;
+		led_dat->cdev.brightness_set    = pm8xxx_led_set;
+		led_dat->cdev.brightness_get    = pm8xxx_led_get;
+		led_dat->cdev.brightness	= LED_OFF;
+		led_dat->cdev.flags		= LED_CORE_SUSPENDRESUME;
+
+		led_dat->cdev.max_brightness = get_max_brightness(led_dat->id);
+		led_dat->dev = &pdev->dev;
+
+		rc =  get_init_value(led_dat, &led_dat->reg);
+		if (rc < 0)
+			goto fail_id_check;
+
+		mutex_init(&led_dat->lock);
+		INIT_WORK(&led_dat->work, pm8xxx_led_work);
+
+		rc = led_classdev_register(&pdev->dev, &led_dat->cdev);
+		if (rc) {
+			dev_err(&pdev->dev, "unable to register led %d\n",
+						 led_dat->id);
+			goto fail_id_check;
+		}
+	}
+
+	platform_set_drvdata(pdev, led);
+
+	return 0;
+
+fail_id_check:
+	if (i > 0) {
+		for (i = i - 1; i >= 0; i--) {
+			int index = pdata->leds[i].flags;
+			mutex_destroy(&led[index].lock);
+			led_classdev_unregister(&led[index].cdev);
+		}
+	}
+	kfree(led);
+	return rc;
+}
+
+static int __devexit pm8xxx_led_remove(struct platform_device *pdev)
+{
+	int i;
+	const struct led_platform_data *pdata =
+				pdev->dev.platform_data;
+	struct pm8xxx_led_data *led = platform_get_drvdata(pdev);
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		int index = pdata->leds[i].flags;
+		cancel_work_sync(&led[index].work);
+		mutex_destroy(&led[index].lock);
+		led_classdev_unregister(&led[index].cdev);
+	}
+
+	kfree(led);
+
+	return 0;
+}
+
+static struct platform_driver pm8xxx_led_driver = {
+	.probe		= pm8xxx_led_probe,
+	.remove		= __devexit_p(pm8xxx_led_remove),
+	.driver		= {
+		.name	= PM8XXX_LEDS_DEV_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init pm8xxx_led_init(void)
+{
+	return platform_driver_register(&pm8xxx_led_driver);
+}
+module_init(pm8xxx_led_init);
+
+static void __exit pm8xxx_led_exit(void)
+{
+	platform_driver_unregister(&pm8xxx_led_driver);
+}
+module_exit(pm8xxx_led_exit);
+
+MODULE_DESCRIPTION("PM8XXX LEDs driver");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION("1.0");
+MODULE_ALIAS("platform:pm8xxx-led");
+MODULE_AUTHOR("Trilok Soni <tsoni@codeaurora.org>");
diff --git a/include/linux/leds-pm8xxx.h b/include/linux/leds-pm8xxx.h
new file mode 100644
index 0000000..3a03100
--- /dev/null
+++ b/include/linux/leds-pm8xxx.h
@@ -0,0 +1,37 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __LEDS_PM8XXX_H__
+#define __LEDS_PM8XXX_H__
+
+
+#define PM8XXX_LEDS_DEV_NAME	"pm8xxx-led"
+
+/**
+ * enum pm8xxx_leds - PMIC8XXX supported led ids
+ * @PM8XXX_ID_LED_KB_LIGHT - keyboard backlight led
+ * @PM8XXX_ID_LED_0 - First low current led
+ * @PM8XXX_ID_LED_1 - Second low current led
+ * @PM8XXX_ID_LED_2 - Third low current led
+ * @PM8XXX_ID_FLASH_LED_0 - First flash led
+ * @PM8XXX_ID_FLASH_LED_0 - Second flash led
+ */
+enum pm8xxx_leds {
+	PM8XXX_ID_LED_KB_LIGHT = 1,
+	PM8XXX_ID_LED_0,
+	PM8XXX_ID_LED_1,
+	PM8XXX_ID_LED_2,
+	PM8XXX_ID_FLASH_LED_0,
+	PM8XXX_ID_FLASH_LED_1,
+};
+
+#endif /* __LEDS_PM8XXX_H__ */
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

