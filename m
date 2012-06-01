Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004Ab2FAD5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 23:57:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35698 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758969Ab2FAD5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 23:57:34 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-8a-4fc83dabb7fc
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpudie@rpsys.net>,
        linux-leds@vger.kernel.org, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2] led: max77693: Add support for MAX77693 LED driver
Date: Fri, 01 Jun 2012 12:56:41 +0900
Message-id: <1338523001-11811-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJMWRmVeSWpSXmKPExsVy+t9jAd3Vtif8Dc4c0rW4vGsOm8XWN+sY
	HZg8Pm+SC2CM4rJJSc3JLEst0rdL4MpYsbOTpWBnWsW+WU/YGxjbQ7oYOTkkBEwkjnVsZoKw
	xSQu3FvP1sXIxSEksIhRYsrh+ewQTgeTxNxr+9hAqtgEdCT+77vJDmKLCChIbO59xgpSxCzw
	jFHizJ15zCAJYQE3iZXbroHZLAKqEotePmcFsXkFPCRm7lsBtU5BYsG9t2wTGLkXMDKsYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAj25zPpHYyrGiwOMQpwMCrx8B63POEvxJpYVlyZe4hR
	goNZSYSX4c1xfyHelMTKqtSi/Pii0pzU4kOM0hwsSuK8T5bs8BcSSE8sSc1OTS1ILYLJMnFw
	SjUwToisUPkX8+cO36kd4XtV9r2w3DvNwqsm9MryJpttcyvuhMse+nKr69DqZRvt3Dpu6kaF
	drkvmxllqGwlb/XvremB15pF8VdP8zOHnDrKdVnfMn+Rt8I6tjVd3t6LZbmcrvsplDAtOZVs
	rNAsznVu4ZMpez+zdmwTlXzn8VrBbovU0fjVyVNPK7EUZyQaajEXFScCACEEDs3jAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports max77693 LED driver. MAX77693 LED has 2 mode and 2 FLEDs.
The LED of each mode has seperate led data and handle it independently.
The 2 FLEDs can be activated by logic inputs (FLEDEN, TORCHEN) and also I2C interface.

This patch is based on mfd-2.6/for-next branch.
git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v2
- Transform the data structures which hold led's information.
- Move all macro and enum from header file to C file except platform_data strcure only.
  And replace header file to include/linux/platform_data/ .
- Modify platform data in max77693.h to contain led's platform data.

 drivers/leds/Kconfig                        |    7 +
 drivers/leds/Makefile                       |    1 +
 drivers/leds/leds-max77693.c                |  282 +++++++++++++++++++++++++++
 include/linux/mfd/max77693.h                |    4 +
 include/linux/platform_data/leds-max77693.h |   74 +++++++
 5 files changed, 368 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-max77693.c
 create mode 100644 include/linux/platform_data/leds-max77693.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index ff4b8cf..d69be3c 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -394,6 +394,13 @@ config LEDS_MAX8997
 	  This option enables support for on-chip LED drivers on
 	  MAXIM MAX8997 PMIC.
 
+config LEDS_MAX77693
+	tristate "LED support for MAX77693 PMIC"
+	depends on LEDS_CLASS && MFD_MAX77693
+	help
+	  This option enables support for on-chip LED drivers on
+	  MAXIM MAX77693 PMIC.
+
 config LEDS_OT200
 	tristate "LED support for the Bachmann OT200"
 	depends on LEDS_CLASS && HAS_IOMEM
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 890481c..ff4ff2c 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -45,6 +45,7 @@ obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
 obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
 obj-$(CONFIG_LEDS_RENESAS_TPU)		+= leds-renesas-tpu.o
 obj-$(CONFIG_LEDS_MAX8997)		+= leds-max8997.o
+obj-$(CONFIG_LEDS_MAX77693)		+= leds-max77693.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff --git a/drivers/leds/leds-max77693.c b/drivers/leds/leds-max77693.c
new file mode 100644
index 0000000..38d4300
--- /dev/null
+++ b/drivers/leds/leds-max77693.c
@@ -0,0 +1,282 @@
+/*
+ * LED driver for Maxim MAX77693 - leds-max77673.c
+ *
+ * Copyright (C) 2012 Samsung Electronics Co.Ltd
+ * ByungChang Cha <bc.cha@samsung.com>
+ * Jonghwa Lee <jonghwa3.lee@samsung.com>
+ *
+ * This program is not provided / owned by Maxim Integrated Products.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/mfd/max77693.h>
+#include <linux/mfd/max77693-private.h>
+#include <linux/platform_data/leds-max77693.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+
+/* MAX77693_IFLASH1 */
+#define MAX77693_FLASH_IOUT1			0x3F
+
+/* MAX77693_IFLASH2 */
+#define MAX77693_FLASH_IOUT2			0x3F
+
+/* MAX77693_ITORCH */
+#define MAX77693_TORCH_IOUT1			0x0F
+#define MAX77693_TORCH_IOUT2			0xF0
+
+/* MAX77693_FLASH_EN */
+#define MAX77693_TORCH_FLED2_EN			0x03
+#define MAX77693_TORCH_FLED1_EN			0x0C
+#define MAX77693_FLASH_FLED2_EN			0x30
+#define MAX77693_FLASH_FLED1_EN			0xC0
+/* MAX77693 FLEDx_EN value */
+#define MAX77693_FLED_OFF			0x00
+#define MAX77693_FLED_FLASHEN			0x01
+#define MAX77693_FLED_TORCHEN			0x02
+#define MAX77693_FLED_I2C			0X03
+
+/* MAX77693_VOUT_CNTL */
+#define MAX77693_BOOST_FLASH_MODE		0x07
+#define MAX77693_BOOST_FLASH_FLEDNUM		0x80
+/* MAX77693_BOOST_FLASH_MODE vaule*/
+#define MAX77693_BOOST_FLASH_MODE_OFF		0x00
+#define MAX77693_BOOST_FLASH_MODE_FLED1		0x01
+#define MAX77693_BOOST_FLASH_MODE_FLED2		0x02
+#define MAX77693_BOOST_FLASH_MODE_BOTH		0x03
+#define MAX77693_BOOST_FLASH_MODE_FIXED		0x04
+/* MAX77693_BOOST_FLASH_FLEDNUM vaule*/
+#define MAX77693_BOOST_FLASH_FLEDNUM_1		0x00
+#define MAX77693_BOOST_FLASH_FLEDNUM_2		0x80
+
+/* MAX77693_VOUT_FLASH1 */
+#define MAX77693_BOOST_VOUT_FLASH		0x7F
+#define MAX77693_BOOST_VOUT_FLASH_FROM_VOLT(mV)				\
+		((mV) <= 3300 ? 0x00 :					\
+		((mV) <= 5500 ? (((mV) - 3300) / 25 + 0x0C) : 0x7F))
+
+#define MAX_FLASH_CURRENT		1000	/* 1000mA(0x1f) */
+#define MAX_TORCH_CURRENT		250	/* 250mA(0x0f) */
+#define MAX_FLASH_DRV_LEVEL		63	/* 15.625 + 15.625*63 mA */
+#define MAX_TORCH_DRV_LEVEL		15	/* 15.625 + 15.625*15 mA */
+
+#define MAX77693_LED_CTRL_BY_I2C	1
+#define MAX77693_TORCH_LED_2		3
+
+static u8 led_en_mask[MAX77693_LED_MAX] = {
+	MAX77693_FLASH_FLED1_EN,
+	MAX77693_FLASH_FLED2_EN,
+	MAX77693_TORCH_FLED1_EN,
+	MAX77693_TORCH_FLED2_EN
+};
+
+static u8 reg_led_timer[MAX77693_LED_MAX] = {
+	MAX77693_LED_REG_FLASH_TIMER,
+	MAX77693_LED_REG_FLASH_TIMER,
+	MAX77693_LED_REG_ITORCHTIMER,
+	MAX77693_LED_REG_ITORCHTIMER,
+};
+
+static u8 reg_led_current[MAX77693_LED_MAX] = {
+	MAX77693_LED_REG_IFLASH1,
+	MAX77693_LED_REG_IFLASH2,
+	MAX77693_LED_REG_ITORCH,
+	MAX77693_LED_REG_ITORCH,
+};
+
+static u8 led_current_mask[MAX77693_LED_MAX] = {
+	MAX77693_FLASH_IOUT1,
+	MAX77693_FLASH_IOUT2,
+	MAX77693_TORCH_IOUT1,
+	MAX77693_TORCH_IOUT2
+};
+
+static int max77693_led_get_en_value(struct max77693_led *led)
+{
+	if (led->cntrl_mode == MAX77693_LED_CTRL_BY_I2C)
+		return MAX77693_FLED_OFF;
+	else if (led->id < 2)
+		return MAX77693_FLED_FLASHEN;
+	else
+		return MAX77693_FLED_TORCHEN;
+}
+
+static void max77693_led_set(struct led_classdev *led_cdev,
+					 enum led_brightness value)
+{
+	struct max77693_led *led
+		= container_of(led_cdev, struct max77693_led, cdev);
+
+	led->brightness = min_t(int, value, MAX77693_FLASH_IOUT1);
+	schedule_work(&led->work);
+}
+
+static void max77693_led_work(struct work_struct *work)
+{
+	struct max77693_led *led
+			= container_of(work, struct max77693_led, work);
+	int ret;
+	int en_val;
+	int id = led->id;
+	u8 shift = id == MAX77693_TORCH_LED_2 ? 4 : 0;
+
+
+	en_val = max77693_led_get_en_value(led);
+	ret = regmap_update_bits(led->max77693->regmap,
+				MAX77693_LED_REG_FLASH_EN,
+				led_en_mask[id],
+				en_val << (ffs(led_en_mask[id]) - 1));
+	if (unlikely(ret))
+		goto error_set_bits;
+
+	ret = regmap_update_bits(led->max77693->regmap,
+				reg_led_current[id],
+				led_current_mask[id],
+				led->brightness << shift);
+	if (unlikely(ret))
+		goto error_set_bits;
+
+	return;
+
+error_set_bits:
+	dev_err(led->max77693->dev, "%s: can't set led level %d\n", __func__, ret);
+	return;
+}
+
+static int max77693_led_setup(struct max77693_led *led)
+{
+	int ret = 0;
+	int id = led->id;
+	int value;
+	u8 shift = id == MAX77693_TORCH_LED_2 ? 4 : 0;
+
+	ret |= regmap_write(led->max77693->regmap, MAX77693_LED_REG_VOUT_CNTL,
+				  MAX77693_BOOST_FLASH_FLEDNUM_2
+				| MAX77693_BOOST_FLASH_MODE_BOTH);
+	ret |= regmap_write(led->max77693->regmap, MAX77693_LED_REG_VOUT_FLASH1,
+			  MAX77693_BOOST_VOUT_FLASH_FROM_VOLT(5000));
+	ret |= regmap_write(led->max77693->regmap,
+			MAX77693_LED_REG_MAX_FLASH1, 0xEC);
+	ret |= regmap_write(led->max77693->regmap,
+			MAX77693_LED_REG_MAX_FLASH2, 0x00);
+
+	value = max77693_led_get_en_value(led);
+
+	ret |= regmap_update_bits(led->max77693->regmap,
+				 MAX77693_LED_REG_FLASH_EN,
+				 led_en_mask[id],
+				 value << (ffs(led_en_mask[id]) - 1));
+
+	/* Set TORCH_TMR_DUR or FLASH_TMR_DUR */
+	if (id < 2) {
+		ret |= regmap_write(led->max77693->regmap, reg_led_timer[id],
+				(led->timer | led->timer_mode << 7));
+	} else {
+		ret |= regmap_write(led->max77693->regmap, reg_led_timer[id],
+					0xC0);
+	}
+	/* Set current */
+	ret |= regmap_update_bits(led->max77693->regmap, reg_led_current[id],
+			led_current_mask[id],
+			led->brightness << shift);
+
+	return ret;
+}
+
+static int max77693_led_probe(struct platform_device *pdev)
+{
+	struct max77693_dev *max77693 = dev_get_drvdata(pdev->dev.parent);
+	struct max77693_platform_data *max77693_pdata
+					= dev_get_platdata(max77693->dev);
+	struct max77693_led_platform_data *led_data
+					= max77693_pdata->led_data;
+	struct max77693_led *led;
+	int ret = 0;
+	int i;
+
+	if(!led_data) {
+		dev_err(&pdev->dev, "%s : No platform data\n", __func__);
+		return -ENODEV;
+	}
+
+	platform_set_drvdata(pdev, led_data);
+
+	for (i = 0; i < led_data->num_leds; i++) {
+		led = &(led_data->leds[i]);
+
+		led->max77693 = max77693;
+		led->cdev.name = led->name;
+		led->cdev.brightness_set = max77693_led_set;
+		led->cdev.brightness = LED_OFF;
+		led->cdev.flags = LED_CORE_SUSPENDRESUME;
+		led->cdev.max_brightness = led->id < 2
+			? MAX_FLASH_DRV_LEVEL : MAX_TORCH_DRV_LEVEL;
+
+		INIT_WORK(&led->work, max77693_led_work);
+		ret = led_classdev_register(&pdev->dev, &led->cdev);
+		if (unlikely(ret)) {
+			dev_err(&pdev->dev, "unable to register LED\n");
+			ret = -EFAULT;
+			continue;
+		}
+
+		ret = max77693_led_setup(led);
+		if (unlikely(ret)) {
+			dev_err(&pdev->dev, "unable to setup LED\n");
+			led_classdev_unregister(&led->cdev);
+			ret = -EFAULT;
+		}
+	}
+	return ret;
+}
+
+static int __devexit max77693_led_remove(struct platform_device *pdev)
+{
+	struct max77693_led_platform_data *led_data = platform_get_drvdata(pdev);
+	struct max77693_led *led;
+	int i;
+
+	for (i = 0; i < led_data->num_leds; i++) {
+		led = &(led_data->leds[i]);
+		if (led == NULL)
+			continue;
+
+		led_classdev_unregister(&led->cdev);
+	}
+	return 0;
+}
+
+static struct platform_driver max77693_led_driver = {
+	.probe		= max77693_led_probe,
+	.remove		= __devexit_p(max77693_led_remove),
+	.driver		= {
+		.name	= "max77693-led",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init max77693_led_init(void)
+{
+	return platform_driver_register(&max77693_led_driver);
+}
+module_init(max77693_led_init);
+
+static void __exit max77693_led_exit(void)
+{
+	platform_driver_unregister(&max77693_led_driver);
+}
+module_exit(max77693_led_exit);
+
+MODULE_AUTHOR("ByungChang Cha <bc.cha@samsung.com>");
+MODULE_DESCRIPTION("MAX77693 LED driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
index 1d28ae9..b163e64 100644
--- a/include/linux/mfd/max77693.h
+++ b/include/linux/mfd/max77693.h
@@ -32,5 +32,9 @@
 
 struct max77693_platform_data {
 	int wakeup;
+#ifdef CONFIG_LEDS_MAX77693
+	/* led (flash/torch) data */
+	struct max77693_led_platform_data *led_data;
+#endif
 };
 #endif	/* __LINUX_MFD_MAX77693_H */
diff --git a/include/linux/platform_data/leds-max77693.h b/include/linux/platform_data/leds-max77693.h
new file mode 100644
index 0000000..24237c7
--- /dev/null
+++ b/include/linux/platform_data/leds-max77693.h
@@ -0,0 +1,74 @@
+/*
+ * leds-max77693.h - Flash-led driver for Maxim MAX77693
+ *
+ * Copyright (C) 2012 Samsung Electronics Co.Ltd
+ * ByungChang Cha <bc.cha@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __LEDS_MAX77693_H__
+#define __LEDS_MAX77693_H__
+
+#define	MAX77693_LED_MAX	4
+
+/* struct max77693_led - struture containing led's information
+ * @name: led's name
+ * @id: integer id for each led.
+ *	0: FLED1 for FLASH Mode
+ *	1: FLED2 for FLASH Mode
+ *	2: FLED1 for TORCH Mode
+ *	3: FLED2 for TORCH Mode
+ * @timer: value of timer duration (ms) <= 15
+ *		FLASH		TORCH
+ *	0:	62.5		262
+ *	1:	125		524
+ *	2:	187.5		786
+ *	3:	250		1048
+ *	4:	312.5		1572
+ *	5:	375		2096
+ *	6:	437.5		2620
+ *	7:	500		3144
+ *	8:	562.5		4193
+ *	9:	625		5242
+ *	10:	687.5		6291
+ *	11:	750		7340
+ * 	12:	812.5		9437
+ *	13:	875		11534
+ *	14:	937.5		13631
+ *	15:	1000		15728
+ * @brigthness 
+ * @timer_mode: timer mode bit
+ *	0: One shot mode
+ *	1: Max timer mode
+ * @cntrl_mode: set led's control mode 
+	0: triggered by FLASHEN/TORCHEN
+	1: triggered by I2C
+ * @cdev
+ * @max77693
+ * @work
+ */
+
+struct max77693_led
+{
+	const char			*name;
+	int				id;
+	int				timer;
+	int				brightness;
+	int				timer_mode;
+	int				cntrl_mode;
+
+	struct led_classdev		cdev;
+	struct max77693_dev		*max77693;
+	struct work_struct		work;
+};
+
+struct max77693_led_platform_data
+{
+	int num_leds;
+	struct max77693_led leds[MAX77693_LED_MAX];
+};
+
+#endif
-- 
1.7.4.1

