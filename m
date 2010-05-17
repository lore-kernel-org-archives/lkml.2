Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0EQQxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:53:45 -0400
Received: from smtp3.epfl.ch ([128.178.224.226]:55860 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753514Ab0EQQxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:53:42 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 May 2010 12:53:41 EDT
From: =?utf-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>
To: s.hauer@pengutronix.de
Cc: u.kleine-koenig@pengutronix.de, maramaopercheseimorto@gmail.com,
       sameo@linux.intel.com, valentin.longchamp@epfl.ch,
       rpurdie@linux.intel.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       =?utf-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>
Subject: [PATCH 1/2] mc13783: add LED support
Date: Mon, 17 May 2010 18:40:22 +0200
Message-Id: <1274114423-30020-2-git-send-email-philippe.retornaz@epfl.ch>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1274114423-30020-1-git-send-email-philippe.retornaz@epfl.ch>
References: <1274114423-30020-1-git-send-email-philippe.retornaz@epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds basic led support for Freescale MC13783 PMIC.

Signed-off-by: Philippe Rétornaz <philippe.retornaz@epfl.ch>
---
 drivers/leds/Kconfig        |    7 +
 drivers/leds/Makefile       |    1 +
 drivers/leds/leds-mc13783.c |  375 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/mc13783-core.c  |    4 +
 include/linux/mfd/mc13783.h |   68 ++++++++
 5 files changed, 455 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-mc13783.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 505eb64..706386c 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -285,6 +285,13 @@ config LEDS_DELL_NETBOOKS
 	  This adds support for the Latitude 2100 and similar
 	  notebooks that have an external LED.
 
+config LEDS_MC13783
+	tristate "LED Support for MC13783 PMIC"
+	depends on MFD_MC13783
+	help
+	  This option enable support for on-chip LED drivers found
+	  on Freescale Semiconductor MC13783 PMIC.
+
 config LEDS_TRIGGERS
 	bool "LED Trigger support"
 	help
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 0cd8b99..d084e3b 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_LEDS_INTEL_SS4200)		+= leds-ss4200.o
 obj-$(CONFIG_LEDS_LT3593)		+= leds-lt3593.o
 obj-$(CONFIG_LEDS_ADP5520)		+= leds-adp5520.o
 obj-$(CONFIG_LEDS_DELL_NETBOOKS)	+= dell-led.o
+obj-$(CONFIG_LEDS_MC13783)		+= leds-mc13783.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff --git a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
new file mode 100644
index 0000000..c0427fd
--- /dev/null
+++ b/drivers/leds/leds-mc13783.c
@@ -0,0 +1,375 @@
+/*
+ * LEDs driver for Freescale MC13783
+ *
+ * Copyright (C) 2010 Philippe Rétornaz
+ *
+ * Based on leds-da903x:
+ * Copyright (C) 2008 Compulab, Ltd.
+ *      Mike Rapoport <mike@compulab.co.il>
+ *
+ * Copyright (C) 2006-2008 Marvell International Ltd.
+ *      Eric Miao <eric.miao@marvell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <linux/workqueue.h>
+#include <linux/mfd/mc13783.h>
+#include <linux/mfd/mc13783-private.h>
+#include <linux/slab.h>
+
+struct mc13783_led {
+	struct led_classdev	cdev;
+	struct work_struct	work;
+	struct mc13783		*master;
+	enum led_brightness	new_brightness;
+	int			id;
+};
+
+#define BL_P_MASK 0xf
+#define MD_P_SHIFT 9
+#define AD_P_SHIFT 13
+#define KP_P_SHIFT 17
+#define TC_P_BASE_SHIFT 6
+#define TC_P_MASK 0x1f
+static void mc13783_led_work(struct work_struct *work)
+{
+	struct mc13783_led *led = container_of(work, struct mc13783_led, work);
+	int off;
+	int shift;
+	int bank;
+	int o;
+
+	mc13783_lock(led->master);
+	switch (led->id) {
+	case MC13783_LED_MD:
+		mc13783_reg_rmw(led->master, MC13783_REG_LED_CONTROL_2,
+			BL_P_MASK << MD_P_SHIFT,
+			(led->new_brightness >> 4) << MD_P_SHIFT);
+		break;
+	case MC13783_LED_AD:
+		mc13783_reg_rmw(led->master, MC13783_REG_LED_CONTROL_2,
+			BL_P_MASK << AD_P_SHIFT,
+			(led->new_brightness >> 4) << AD_P_SHIFT);
+		break;
+	case MC13783_LED_KP:
+		mc13783_reg_rmw(led->master, MC13783_REG_LED_CONTROL_2,
+			BL_P_MASK << KP_P_SHIFT,
+			(led->new_brightness >> 4) << KP_P_SHIFT);
+		break;
+	case MC13783_LED_R1:
+	case MC13783_LED_G1:
+	case MC13783_LED_B1:
+	case MC13783_LED_R2:
+	case MC13783_LED_G2:
+	case MC13783_LED_B2:
+	case MC13783_LED_R3:
+	case MC13783_LED_G3:
+	case MC13783_LED_B3:
+		o = led->id - MC13783_LED_R1;
+		bank = o/3;
+		off = MC13783_REG_LED_CONTROL_3 + o/3;
+		shift = (o - bank * 3) * 5 + TC_P_BASE_SHIFT;
+		mc13783_reg_rmw(led->master, off, TC_P_MASK << shift,
+				(led->new_brightness >> 3) << shift);
+
+		break;
+	}
+	mc13783_unlock(led->master);
+}
+
+static void mc13783_led_set(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct mc13783_led *led;
+
+	led = container_of(led_cdev, struct mc13783_led, cdev);
+	led->new_brightness = value;
+	schedule_work(&led->work);
+}
+
+#define BL_C_MASK 0x7
+#define MD_C_SHIFT 0
+#define AD_C_SHIFT 3
+#define KP_C_SHIFT 6
+#define TC_C_MASK 0x3
+static int __devinit mc13783_led_setup(struct mc13783_led *led, int max_current)
+{
+	int off;
+	int shift;
+	int ret;
+	int bank;
+	mc13783_lock(led->master);
+
+	switch (led->id) {
+	case MC13783_LED_MD:
+		ret = mc13783_reg_rmw(led->master, MC13783_REG_LED_CONTROL_2,
+				BL_C_MASK << MD_C_SHIFT,
+				(max_current & BL_C_MASK) << MD_C_SHIFT);
+		break;
+	case MC13783_LED_AD:
+		ret = mc13783_reg_rmw(led->master, MC13783_REG_LED_CONTROL_2,
+				BL_C_MASK << AD_C_SHIFT,
+				(max_current & BL_C_MASK) << AD_C_SHIFT);
+		break;
+	case MC13783_LED_KP:
+		ret = mc13783_reg_rmw(led->master, MC13783_REG_LED_CONTROL_2,
+				BL_C_MASK << KP_C_SHIFT,
+				(max_current & BL_C_MASK) << KP_C_SHIFT);
+		break;
+	case MC13783_LED_R1:
+	case MC13783_LED_G1:
+	case MC13783_LED_B1:
+	case MC13783_LED_R2:
+	case MC13783_LED_G2:
+	case MC13783_LED_B2:
+	case MC13783_LED_R3:
+	case MC13783_LED_G3:
+	case MC13783_LED_B3:
+		bank = (led->id - MC13783_LED_R1)/3;
+		off = MC13783_REG_LED_CONTROL_3 + bank;
+		shift = ((led->id - MC13783_LED_R1) - bank * 3) * 2;
+
+		ret = mc13783_reg_rmw(led->master, off, TC_C_MASK << shift,
+					(max_current & TC_C_MASK) << shift);
+		break;
+	}
+
+	mc13783_unlock(led->master);
+	return ret;
+}
+
+#define TC1HALF_BIT 18
+#define SLEWLIM_BIT 23
+#define TRIODE_TC_BIT 23
+#define TRIODE_MD_BIT 7
+#define TRIODE_AD_BIT 8
+#define TRIODE_KP_BIT 9
+#define BOOST_BIT 10
+#define PERIOD_MASK 0x3
+#define PERIOD_SHIFT 21
+#define ABMODE_MASK 0x7
+#define ABMODE_SHIFT 11
+#define ABREF_MASK 0x3
+#define ABREF_SHIFT 14
+static int __devinit mc13783_leds_prepare(struct platform_device *pdev)
+{
+	struct mc13783_leds_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	struct mc13783 *dev = dev_get_drvdata(pdev->dev.parent);
+	int ret = 0;
+	int reg = 0;
+
+	mc13783_lock(dev);
+
+	if (pdata->flags & MC13783_LED_TC1HALF)
+		reg |= 1 << TC1HALF_BIT;
+
+	if (pdata->flags & MC13783_LED_SLEWLIMTC)
+		reg |= 1 << SLEWLIM_BIT;
+
+	ret = mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_1, reg);
+	if (ret)
+		goto out;
+
+	reg = (pdata->bl_period & PERIOD_MASK) << PERIOD_SHIFT;
+
+	if (pdata->flags & MC13783_LED_SLEWLIMBL)
+		reg |= 1 << SLEWLIM_BIT;
+
+	ret = mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_2, reg);
+	if (ret)
+		goto out;
+
+
+	reg = (pdata->tc1_period & PERIOD_MASK) << PERIOD_SHIFT;
+	if (pdata->flags & MC13783_LED_TRIODE_TC1)
+		reg |= 1 << TRIODE_TC_BIT;
+
+	ret = mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_3, reg);
+	if (ret)
+		goto out;
+
+	reg = (pdata->tc2_period & PERIOD_MASK) << PERIOD_SHIFT;
+	if (pdata->flags & MC13783_LED_TRIODE_TC2)
+		reg |= 1 << TRIODE_TC_BIT;
+
+	ret = mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_4, reg);
+	if (ret)
+		goto out;
+
+	reg = (pdata->tc3_period & PERIOD_MASK) << PERIOD_SHIFT;
+	if (pdata->flags & MC13783_LED_TRIODE_TC3)
+		reg |= 1 << TRIODE_TC_BIT;
+
+	ret = mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_5, reg);
+	if (ret)
+		goto out;
+
+	reg = 1;
+	if (pdata->flags & MC13783_LED_TRIODE_MD)
+		reg |= 1 << TRIODE_MD_BIT;
+	if (pdata->flags & MC13783_LED_TRIODE_AD)
+		reg |= 1 << TRIODE_AD_BIT;
+	if (pdata->flags & MC13783_LED_TRIODE_KP)
+		reg |= 1 << TRIODE_KP_BIT;
+	if (pdata->flags & MC13783_LED_BOOST_EN)
+		reg |= 1 << BOOST_BIT;
+
+	reg |= (pdata->abmode & ABMODE_MASK) << ABMODE_SHIFT;
+	reg |= (pdata->abref & ABREF_MASK) << ABREF_SHIFT;
+
+	ret = mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_0, reg);
+
+out:
+	mc13783_unlock(dev);
+	return ret;
+}
+
+static int __devinit mc13783_led_probe(struct platform_device *pdev)
+{
+	struct mc13783_leds_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	struct mc13783_led_platform_data *led_cur;
+	struct mc13783_led *led, *led_dat;
+	int ret, i;
+	int init_led = 0;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "missing platform data\n");
+		return -ENODEV;
+	}
+
+	if (pdata->num_leds < 1 || pdata->num_leds > MC13783_LED_MAX) {
+		dev_err(&pdev->dev, "Invalid led count %d\n", pdata->num_leds);
+		return -EINVAL;
+	}
+
+	led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
+	if (led == NULL) {
+		dev_err(&pdev->dev, "failed to alloc memory\n");
+		return -ENOMEM;
+	}
+
+	ret = mc13783_leds_prepare(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to init led driver\n");
+		goto err_free;
+	}
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		led_dat = &led[i];
+		led_cur = &pdata->led[i];
+
+		if (led_cur->id > MC13783_LED_MAX || led_cur->id < 0) {
+			dev_err(&pdev->dev, "invalid id %d\n", led_cur->id);
+			ret = -EINVAL;
+			goto err_register;
+		}
+
+		if (init_led & (1 << led_cur->id)) {
+			dev_err(&pdev->dev, "led %d already initialized\n",
+					led_cur->id);
+			ret = -EINVAL;
+			goto err_register;
+		}
+
+		init_led |= 1 << led_cur->id;
+		led_dat->cdev.name = led_cur->name;
+		led_dat->cdev.default_trigger = led_cur->default_trigger;
+		led_dat->cdev.brightness_set = mc13783_led_set;
+		led_dat->cdev.brightness = LED_OFF;
+		led_dat->id = led_cur->id;
+		led_dat->master = dev_get_drvdata(pdev->dev.parent);
+
+		INIT_WORK(&led_dat->work, mc13783_led_work);
+
+		ret = led_classdev_register(pdev->dev.parent, &led_dat->cdev);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to register led %d\n",
+					led_dat->id);
+			goto err_register;
+		}
+
+		ret = mc13783_led_setup(led_dat, led_cur->max_current);
+		if (ret) {
+			dev_err(&pdev->dev, "unable to init led %d\n",
+					led_dat->id);
+			i++;
+			goto err_register;
+		}
+	}
+
+	platform_set_drvdata(pdev, led);
+	return 0;
+
+err_register:
+	if (i > 0) {
+		for (i = i - 1; i >= 0; i--) {
+			led_classdev_unregister(&led[i].cdev);
+			cancel_work_sync(&led[i].work);
+		}
+	}
+
+err_free:
+	kfree(led);
+	return ret;
+}
+
+static int __devexit mc13783_led_remove(struct platform_device *pdev)
+{
+	struct mc13783_leds_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	struct mc13783_led *led = platform_get_drvdata(pdev);
+	struct mc13783 *dev = dev_get_drvdata(pdev->dev.parent);
+	int i;
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		led_classdev_unregister(&led[i].cdev);
+		cancel_work_sync(&led[i].work);
+	}
+
+	mc13783_lock(dev);
+
+	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_0, 0);
+	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_1, 0);
+	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_2, 0);
+	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_3, 0);
+	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_4, 0);
+	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_5, 0);
+
+	mc13783_unlock(dev);
+
+	kfree(led);
+	return 0;
+}
+
+static struct platform_driver mc13783_led_driver = {
+	.driver	= {
+		.name	= "mc13783-led",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= mc13783_led_probe,
+	.remove		= __devexit_p(mc13783_led_remove),
+};
+
+static int __init mc13783_led_init(void)
+{
+	return platform_driver_register(&mc13783_led_driver);
+}
+module_init(mc13783_led_init);
+
+static void __exit mc13783_led_exit(void)
+{
+	platform_driver_unregister(&mc13783_led_driver);
+}
+module_exit(mc13783_led_exit);
+
+MODULE_DESCRIPTION("LEDs driver for Freescale MC13783 PMIC");
+MODULE_AUTHOR("Philipe Rétornaz <philippe.retorna@epfl.ch>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:mc13783-led");
diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
index 1f68eca..fecf38a 100644
--- a/drivers/mfd/mc13783-core.c
+++ b/drivers/mfd/mc13783-core.c
@@ -679,6 +679,10 @@ err_revision:
 	if (pdata->flags & MC13783_USE_TOUCHSCREEN)
 		mc13783_add_subdevice(mc13783, "mc13783-ts");
 
+	if (pdata->flags & MC13783_USE_LED)
+		mc13783_add_subdevice_pdata(mc13783, "mc13783-led",
+					pdata->leds, sizeof(*pdata->leds));
+
 	return 0;
 }
 
diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
index 8895d9d..95aa8b6 100644
--- a/include/linux/mfd/mc13783.h
+++ b/include/linux/mfd/mc13783.h
@@ -64,6 +64,72 @@ static inline int mc13783_ackirq(struct mc13783 *mc13783, int irq)
 					MC13783_ADC0_TSMOD1 | \
 					MC13783_ADC0_TSMOD2)
 
+struct mc13783_led_platform_data {
+#define MC13783_LED_MD		0
+#define MC13783_LED_AD		1
+#define MC13783_LED_KP		2
+#define MC13783_LED_R1		3
+#define MC13783_LED_G1		4
+#define MC13783_LED_B1		5
+#define MC13783_LED_R2		6
+#define MC13783_LED_G2		7
+#define MC13783_LED_B2		8
+#define MC13783_LED_R3		9
+#define MC13783_LED_G3		10
+#define MC13783_LED_B3		11
+#define MC13783_LED_MAX MC13783_LED_B3
+	int id;
+	const char *name;
+	const char *default_trigger;
+
+/* Three or two bits current selection depending on the led */
+	char max_current;
+};
+
+struct mc13783_leds_platform_data {
+	int num_leds;
+	struct mc13783_led_platform_data *led;
+
+#define MC13783_LED_TRIODE_MD	(1 << 0)
+#define MC13783_LED_TRIODE_AD	(1 << 1)
+#define MC13783_LED_TRIODE_KP	(1 << 2)
+#define MC13783_LED_BOOST_EN	(1 << 3)
+#define MC13783_LED_TC1HALF	(1 << 4)
+#define MC13783_LED_SLEWLIMTC	(1 << 5)
+#define MC13783_LED_SLEWLIMBL	(1 << 6)
+#define MC13783_LED_TRIODE_TC1	(1 << 7)
+#define MC13783_LED_TRIODE_TC2	(1 << 8)
+#define MC13783_LED_TRIODE_TC3	(1 << 9)
+	int flags;
+
+#define MC13783_LED_AB_DISABLED		0
+#define MC13783_LED_AB_MD1		1
+#define MC13783_LED_AB_MD12		2
+#define MC13783_LED_AB_MD123		3
+#define MC13783_LED_AB_MD1234		4
+#define MC13783_LED_AB_MD1234_AD1	5
+#define MC13783_LED_AB_MD1234_AD12	6
+#define MC13783_LED_AB_MD1_AD		7
+	char abmode;
+
+#define MC13783_LED_ABREF_200MV	0
+#define MC13783_LED_ABREF_400MV	1
+#define MC13783_LED_ABREF_600MV	2
+#define MC13783_LED_ABREF_800MV	3
+	char abref;
+
+#define MC13783_LED_PERIOD_10MS		0
+#define MC13783_LED_PERIOD_100MS	1
+#define MC13783_LED_PERIOD_500MS	2
+#define MC13783_LED_PERIOD_2S		3
+	char bl_period;
+	char tc1_period;
+	char tc2_period;
+	char tc3_period;
+};
+
+
+
 /* to be cleaned up */
 struct regulator_init_data;
 
@@ -80,12 +146,14 @@ struct mc13783_regulator_platform_data {
 struct mc13783_platform_data {
 	int num_regulators;
 	struct mc13783_regulator_init_data *regulators;
+	struct mc13783_leds_platform_data *leds;
 
 #define MC13783_USE_TOUCHSCREEN (1 << 0)
 #define MC13783_USE_CODEC	(1 << 1)
 #define MC13783_USE_ADC		(1 << 2)
 #define MC13783_USE_RTC		(1 << 3)
 #define MC13783_USE_REGULATOR	(1 << 4)
+#define MC13783_USE_LED		(1 << 5)
 	unsigned int flags;
 };
 
-- 
1.6.3.3

