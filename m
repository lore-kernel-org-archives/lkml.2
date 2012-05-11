Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761922Ab2EKGwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:52:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44446 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761725Ab2EKGu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:50:59 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-1c-4facb6d2f018
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Oritz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>
Subject: [PATCH v2 1/3] mfd: MAX77686: Add Maxim 77686 mfd driver
Date: Fri, 11 May 2012 15:50:43 +0900
Message-id: <1336719045-9765-2-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1336719045-9765-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1336719045-9765-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is device driver for MAX77686 chip.
MAX77686 is PMIC and includes regulator and rtc on it.
This driver is core of MAX77686 chip, so provides common support for accessing
on-chip devices. It uses irq_domain to manage irq and regmap to read/write data
to its register with i2c bus.

v2
- Change I/O interface register to using regmap.
- Support IRQ domain, and remove irq_base from all referenced.
- Add module_param() macro to debug_mask parameter. It can be set various
  masking value for specific purpose while debugging.
- Remove IRQ_TEST block and some unnecessary points.

Signed-off-by: Chiwoong Byun <woong.byun@samsung.com>
Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/Kconfig                  |    2 +-
 drivers/mfd/Makefile                 |    2 +-
 drivers/mfd/max77686-irq.c           |  109 +++++++++-----------
 drivers/mfd/max77686.c               |  193 +--------------------------------
 include/linux/mfd/max77686-private.h |   54 ++++------
 include/linux/mfd/max77686.h         |   23 +----
 6 files changed, 79 insertions(+), 304 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 998356f..df1ef8f 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -443,7 +443,7 @@ config MFD_MAX8998
 
 config MFD_MAX77686
 	bool "Maxim Semiconductor MAX77686 PMIC Support"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C && GENERIC_HARDIRQS
 	select MFD_CORE
 	help
 	  Say yes here to support for Maxim Semiconductor MAX77686.
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index d6e57ea..a793ebd 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -79,8 +79,8 @@ max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
 obj-$(CONFIG_MFD_MAX8997)	+= max8997.o max8997-irq.o
 obj-$(CONFIG_MFD_MAX8998)	+= max8998.o max8998-irq.o
-obj-$(CONFIG_MFD_MAX77693)	+= max77693.o max77693-irq.o
 obj-$(CONFIG_MFD_MAX77686)	+= max77686.o max77686-irq.o
+obj-$(CONFIG_MFD_MAX77693)	+= max77693.o max77693-irq.o
 
 pcf50633-objs			:= pcf50633-core.o pcf50633-irq.o
 obj-$(CONFIG_MFD_PCF50633)	+= pcf50633.o
diff --git a/drivers/mfd/max77686-irq.c b/drivers/mfd/max77686-irq.c
index 255ad69..ebe24dd 100644
--- a/drivers/mfd/max77686-irq.c
+++ b/drivers/mfd/max77686-irq.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2012 Samsung Electronics Co.Ltd
  * Chiwoong Byun <woong.byun@samsung.com>
+ * Jonghwa Lee <jonghwa3.lee@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -27,17 +28,18 @@
 #include <linux/gpio.h>
 #include <linux/mfd/max77686.h>
 #include <linux/mfd/max77686-private.h>
+#include <linux/irqdomain.h>
 #include <linux/regmap.h>
 
-
 enum {
 	MAX77686_DEBUG_IRQ_INFO = 1 << 0,
 	MAX77686_DEBUG_IRQ_MASK = 1 << 1,
 	MAX77686_DEBUG_IRQ_INT = 1 << 2,
 };
 
-static int debug_mask = MAX77686_DEBUG_IRQ_INFO | MAX77686_DEBUG_IRQ_MASK |
-						MAX77686_DEBUG_IRQ_INT;
+static int debug_mask = 0;
+module_param(debug_mask, int, 0);
+MODULE_PARM_DESC(debug_mask, "Set debug_mask : 0x0=off 0x1=IRQ_INFO  0x2=IRQ_MASK 0x4=IRQ_INI)");
 
 static const u8 max77686_mask_reg[] = {
 	[PMIC_INT1] = MAX77686_REG_INT1MSK,
@@ -73,15 +75,15 @@ static const struct max77686_irq_data max77686_irqs[] = {
 	DECLARE_IRQ(MAX77686_PMICIRQ_ACOKBF,	PMIC_INT1, 1 << 4),
 	DECLARE_IRQ(MAX77686_PMICIRQ_ACOKBR,	PMIC_INT1, 1 << 5),
 	DECLARE_IRQ(MAX77686_PMICIRQ_ONKEY1S,	PMIC_INT1, 1 << 6),
-	DECLARE_IRQ(MAX77686_PMICIRQ_MRSTB,	PMIC_INT1, 1 << 7),
-	DECLARE_IRQ(MAX77686_PMICIRQ_140C,	PMIC_INT2, 1 << 0),
-	DECLARE_IRQ(MAX77686_PMICIRQ_120C,	PMIC_INT2, 1 << 1),
-	DECLARE_IRQ(MAX77686_RTCIRQ_RTC60S,	RTC_INT, 1 << 0),
-	DECLARE_IRQ(MAX77686_RTCIRQ_RTCA1,	RTC_INT, 1 << 1),
-	DECLARE_IRQ(MAX77686_RTCIRQ_RTCA2,	RTC_INT, 1 << 2),
-	DECLARE_IRQ(MAX77686_RTCIRQ_SMPL,	RTC_INT, 1 << 3),
-	DECLARE_IRQ(MAX77686_RTCIRQ_RTC1S,	RTC_INT, 1 << 4),
-	DECLARE_IRQ(MAX77686_RTCIRQ_WTSR,	RTC_INT, 1 << 5),
+	DECLARE_IRQ(MAX77686_PMICIRQ_MRSTB,		PMIC_INT1, 1 << 7),
+	DECLARE_IRQ(MAX77686_PMICIRQ_140C,		PMIC_INT2, 1 << 0),
+	DECLARE_IRQ(MAX77686_PMICIRQ_120C,		PMIC_INT2, 1 << 1),
+	DECLARE_IRQ(MAX77686_RTCIRQ_RTC60S,		RTC_INT, 1 << 0),
+	DECLARE_IRQ(MAX77686_RTCIRQ_RTCA1,		RTC_INT, 1 << 1),
+	DECLARE_IRQ(MAX77686_RTCIRQ_RTCA2,		RTC_INT, 1 << 2),
+	DECLARE_IRQ(MAX77686_RTCIRQ_SMPL,		RTC_INT, 1 << 3),
+	DECLARE_IRQ(MAX77686_RTCIRQ_RTC1S,		RTC_INT, 1 << 4),
+	DECLARE_IRQ(MAX77686_RTCIRQ_WTSR,		RTC_INT, 1 << 5),
 };
 
 static void max77686_irq_lock(struct irq_data *data)
@@ -89,7 +91,7 @@ static void max77686_irq_lock(struct irq_data *data)
 	struct max77686_dev *max77686 = irq_get_chip_data(data->irq);
 
 	if (debug_mask & MAX77686_DEBUG_IRQ_MASK)
-		pr_debug("%s\n", __func__);
+		pr_info("%s\n", __func__);
 
 	mutex_lock(&max77686->irqlock);
 }
@@ -120,8 +122,7 @@ static void max77686_irq_sync_unlock(struct irq_data *data)
 	mutex_unlock(&max77686->irqlock);
 }
 
-static const inline struct max77686_irq_data *
-irq_to_max77686_irq(struct max77686_dev *max77686, int irq)
+static const inline struct max77686_irq_data *to_max77686_irq(int irq)
 {
 	struct irq_data *data = irq_get_irq_data(irq);
 	return &max77686_irqs[data->hwirq];
@@ -130,8 +131,7 @@ irq_to_max77686_irq(struct max77686_dev *max77686, int irq)
 static void max77686_irq_mask(struct irq_data *data)
 {
 	struct max77686_dev *max77686 = irq_get_chip_data(data->irq);
-	const struct max77686_irq_data *irq_data = irq_to_max77686_irq(max77686,
-							data->irq);
+	const struct max77686_irq_data *irq_data = to_max77686_irq(data->irq);
 
 	max77686->irq_masks_cur[irq_data->group] |= irq_data->mask;
 
@@ -144,8 +144,7 @@ static void max77686_irq_mask(struct irq_data *data)
 static void max77686_irq_unmask(struct irq_data *data)
 {
 	struct max77686_dev *max77686 = irq_get_chip_data(data->irq);
-	const struct max77686_irq_data *irq_data = irq_to_max77686_irq(max77686,
-							data->irq);
+	const struct max77686_irq_data *irq_data = to_max77686_irq(data->irq);
 
 	max77686->irq_masks_cur[irq_data->group] &= ~irq_data->mask;
 
@@ -182,27 +181,25 @@ static irqreturn_t max77686_irq_thread(int irq, void *data)
 	if (debug_mask & MAX77686_DEBUG_IRQ_INT)
 		pr_info("%s: irq_src=0x%x\n", __func__, irq_src);
 
-	/* MAX77686_IRQSRC_RTC may be set even if there are pending at INT1/2 */
-	ret = max77686_read_reg(max77686->regmap,
-					 MAX77686_REG_INT1, &irq_reg[0]);
-	ret = max77686_read_reg(max77686->regmap,
-					 MAX77686_REG_INT2, &irq_reg[1]);
-	if (ret < 0) {
-		dev_err(max77686->dev, "Failed to read pmic interrupt: %d\n",
-				ret);
-		return IRQ_NONE;
-	}
+	if (irq_src == MAX77686_IRQSRC_PMIC) {
+		ret = max77686_bulk_read(max77686->rtc_regmap,
+					 MAX77686_REG_INT1, 2, irq_reg);
+		if (ret < 0) {
+			dev_err(max77686->dev, "Failed to read interrupt source: %d\n",
+					ret);
+			return IRQ_NONE;
+		}
 
-	if (debug_mask & MAX77686_DEBUG_IRQ_INT)
-		pr_info("%s: int1=0x%x, int2=0x%x\n",
-			__func__, irq_reg[PMIC_INT1], irq_reg[PMIC_INT2]);
+		if (debug_mask & MAX77686_DEBUG_IRQ_INT)
+			pr_info("%s: int1=0x%x, int2=0x%x\n", __func__,
+				 irq_reg[PMIC_INT1], irq_reg[PMIC_INT2]);
+	}
 
 	if (irq_src & MAX77686_IRQSRC_RTC) {
 		ret = max77686_read_reg(max77686->rtc_regmap,
-					 MAX77686_RTC_INT, &irq_reg[RTC_INT]);
-
+					MAX77686_RTC_INT, &irq_reg[RTC_INT]);
 		if (ret < 0) {
-			dev_err(max77686->dev, "Failed to read rtc interrupt: %d\n",
+			dev_err(max77686->dev, "Failed to read interrupt source: %d\n",
 					ret);
 			return IRQ_NONE;
 		}
@@ -213,26 +210,17 @@ static irqreturn_t max77686_irq_thread(int irq, void *data)
 
 	}
 
-	/* Report */
 	for (i = 0; i < MAX77686_IRQ_NR; i++) {
 		if (irq_reg[max77686_irqs[i].group] & max77686_irqs[i].mask) {
 			cur_irq = irq_find_mapping(max77686->irq_domain, i);
 			if (cur_irq)
 				handle_nested_irq(cur_irq);
-
 		}
 	}
 
 	return IRQ_HANDLED;
 }
 
-int max77686_irq_resume(struct max77686_dev *max77686)
-{
-	if (max77686->irq && max77686->irq_domain)
-		max77686_irq_thread(0, max77686);
-	return 0;
-}
-
 static int max77686_irq_domain_map(struct irq_domain *d, unsigned int irq,
 					irq_hw_number_t hw)
 {
@@ -259,6 +247,7 @@ int max77686_irq_init(struct max77686_dev *max77686)
 	int i;
 	int ret;
 	int val;
+	struct regmap *map;
 
 	if (debug_mask & MAX77686_DEBUG_IRQ_INFO)
 		pr_info("%s+\n", __func__);
@@ -267,30 +256,29 @@ int max77686_irq_init(struct max77686_dev *max77686)
 		dev_warn(max77686->dev, "No interrupt gpio specified.\n");
 		return 0;
 	}
-
 	mutex_init(&max77686->irqlock);
 
 	max77686->irq = gpio_to_irq(max77686->irq_gpio);
-	ret = gpio_request(max77686->irq_gpio, "pmic_irq");
-	if (ret < 0 && ret != -EBUSY) {
-		dev_err(max77686->dev,
-			"Failed to request gpio %d with ret: %d\n",
-			max77686->irq_gpio, ret);
-		return IRQ_NONE;
-	}
-	if (ret == -EBUSY)
-		dev_warn(max77686->dev, "gpio pmic_irq is already requested\n");
 
-	gpio_direction_input(max77686->irq_gpio);
-	val = gpio_get_value(max77686->irq_gpio);
-	gpio_free(max77686->irq_gpio);
+	if (debug_mask & MAX77686_DEBUG_IRQ_INT) {
+		ret = gpio_request(max77686->irq_gpio, "pmic_irq");
+		if (ret < 0) {
+			dev_err(max77686->dev,
+				"Failed to request gpio %d with ret: %d\n",
+				max77686->irq_gpio, ret);
+			return IRQ_NONE;
+		}
 
-	if (debug_mask & MAX77686_DEBUG_IRQ_INT)
+
+		gpio_direction_input(max77686->irq_gpio);
+		val = gpio_get_value(max77686->irq_gpio);
+		gpio_free(max77686->irq_gpio);
 		pr_info("%s: gpio_irq=%x\n", __func__, val);
+	}
+
 
 	/* Mask individual interrupt sources */
 	for (i = 0; i < MAX77686_IRQ_GROUP_NR; i++) {
-		struct regmap *map;
 
 		max77686->irq_masks_cur[i] = 0xff;
 		max77686->irq_masks_cache[i] = 0xff;
@@ -303,9 +291,8 @@ int max77686_irq_init(struct max77686_dev *max77686)
 
 		max77686_write_reg(map, max77686_mask_reg[i], 0xff);
 	}
-
 	domain = irq_domain_add_linear(NULL, MAX77686_IRQ_NR,
-					&max77686_irq_domain_ops, &max77686);
+					&max77686_irq_domain_ops, max77686);
 	if (!domain) {
 		dev_err(max77686->dev, "could not create irq domain\n");
 		return -ENODEV;
diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index d8f44b2..a87e508 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2012 Samsung Electronics
  * Chiwoong Byun <woong.byun@smasung.com>
+ * Jonghwa Lee <jonghwa3.lee@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -21,16 +22,15 @@
  * This driver is based on max8997.c
  */
 
+#include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
-#include <linux/regmap.h>
 #include <linux/pm_runtime.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/max77686.h>
 #include <linux/mfd/max77686-private.h>
-#include <linux/interrupt.h>
 #include <linux/err.h>
 
 #define I2C_ADDR_RTC	(0x0C >> 1)
@@ -97,7 +97,6 @@ int max77686_update_reg(struct regmap *map, u8 reg, u8 val, u8 mask)
 }
 EXPORT_SYMBOL_GPL(max77686_update_reg);
 
-
 static struct regmap_config max77686_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
@@ -128,6 +127,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	max77686->dev = &i2c->dev;
 	max77686->i2c = i2c;
 	max77686->type = id->driver_data;
+
 	if (!pdata) {
 		ret = -EIO;
 		goto err;
@@ -135,7 +135,6 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 
 	max77686->wakeup = pdata->wakeup;
 	max77686->irq_gpio = pdata->irq_gpio;
-	max77686->wtsr_smpl = pdata->wtsr_smpl;
 
 	mutex_init(&max77686->iolock);
 
@@ -150,6 +149,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 
 	max77686->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
 	i2c_set_clientdata(max77686->rtc, max77686);
+
 	max77686_irq_init(max77686);
 
 	ret = mfd_add_devices(max77686->dev, -1, max77686_devs,
@@ -158,8 +158,6 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err_mfd;
 
-	device_init_wakeup(max77686->dev, pdata->wakeup);
-
 	return ret;
 
 err_mfd:
@@ -187,189 +185,10 @@ static const struct i2c_device_id max77686_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, max77686_i2c_id);
 
-#ifdef CONFIG_PM
-static int max77686_suspend(struct device *dev)
-{
-	struct max77686_dev *max77686 = dev_get_drvdata(dev);
-
-	disable_irq(max77686->irq);
-
-	if (device_may_wakeup(dev))
-		enable_irq_wake(max77686->irq);
-
-	return 0;
-}
-
-static int max77686_resume(struct device *dev)
-{
-	struct max77686_dev *max77686 = dev_get_drvdata(dev);
-
-	if (device_may_wakeup(dev))
-		disable_irq_wake(max77686->irq);
-
-	enable_irq(max77686->irq);
-
-	return max77686_irq_resume(max77686);
-}
-#else
-#define max77686_suspend	NULL
-#define max77686_resume		NULL
-#endif /* CONFIG_PM */
-
-#ifdef CONFIG_HIBERNATION
-
-u8 max77686_dumpaddr_pmic[] = {
-	MAX77686_REG_INT1MSK,
-	MAX77686_REG_INT2MSK,
-	MAX77686_REG_ONOFF_DELAY,
-	MAX77686_REG_MRSTB	,
-	/* Reserved: 0x0B-0x0F */
-	MAX77686_REG_BUCK1CTRL,
-	MAX77686_REG_BUCK1OUT,
-	MAX77686_REG_BUCK2CTRL1,
-	MAX77686_REG_BUCK234FREQ,
-	MAX77686_REG_BUCK2DVS1,
-	MAX77686_REG_BUCK2DVS2,
-	MAX77686_REG_BUCK2DVS3,
-	MAX77686_REG_BUCK2DVS4,
-	MAX77686_REG_BUCK2DVS5,
-	MAX77686_REG_BUCK2DVS6,
-	MAX77686_REG_BUCK2DVS7,
-	MAX77686_REG_BUCK2DVS8,
-	MAX77686_REG_BUCK3CTRL1,
-	/* Reserved: 0x1D */
-	MAX77686_REG_BUCK3DVS1,
-	MAX77686_REG_BUCK3DVS2,
-	MAX77686_REG_BUCK3DVS3,
-	MAX77686_REG_BUCK3DVS4,
-	MAX77686_REG_BUCK3DVS5,
-	MAX77686_REG_BUCK3DVS6,
-	MAX77686_REG_BUCK3DVS7,
-	MAX77686_REG_BUCK3DVS8,
-	MAX77686_REG_BUCK4CTRL1,
-	/* Reserved: 0x27 */
-	MAX77686_REG_BUCK4DVS1,
-	MAX77686_REG_BUCK4DVS2,
-	MAX77686_REG_BUCK4DVS3,
-	MAX77686_REG_BUCK4DVS4,
-	MAX77686_REG_BUCK4DVS5,
-	MAX77686_REG_BUCK4DVS6,
-	MAX77686_REG_BUCK4DVS7,
-	MAX77686_REG_BUCK4DVS8,
-	MAX77686_REG_BUCK5CTRL,
-	MAX77686_REG_BUCK5OUT,
-	MAX77686_REG_BUCK6CTRL,
-	MAX77686_REG_BUCK6OUT,
-	MAX77686_REG_BUCK7CTRL,
-	MAX77686_REG_BUCK7OUT,
-	MAX77686_REG_BUCK8CTRL,
-	MAX77686_REG_BUCK8OUT,
-	MAX77686_REG_BUCK9CTRL,
-	MAX77686_REG_BUCK9OUT,
-	/* Reserved: 0x3A-0x3F */
-	MAX77686_REG_LDO1CTRL1	,
-	MAX77686_REG_LDO2CTRL1	,
-	MAX77686_REG_LDO3CTRL1	,
-	MAX77686_REG_LDO4CTRL1	,
-	MAX77686_REG_LDO5CTRL1	,
-	MAX77686_REG_LDO6CTRL1,
-	MAX77686_REG_LDO7CTRL1	,
-	MAX77686_REG_LDO8CTRL1	,
-	MAX77686_REG_LDO9CTRL1	,
-	MAX77686_REG_LDO10CTRL1,
-	MAX77686_REG_LDO11CTRL1,
-	MAX77686_REG_LDO12CTRL1,
-	MAX77686_REG_LDO13CTRL1,
-	MAX77686_REG_LDO14CTRL1,
-	MAX77686_REG_LDO15CTRL1,
-	MAX77686_REG_LDO16CTRL1,
-	MAX77686_REG_LDO17CTRL1,
-	MAX77686_REG_LDO18CTRL1,
-	MAX77686_REG_LDO19CTRL1,
-	MAX77686_REG_LDO20CTRL1,
-	MAX77686_REG_LDO21CTRL1,
-	MAX77686_REG_LDO22CTRL1,
-	MAX77686_REG_LDO23CTRL1,
-	MAX77686_REG_LDO24CTRL1,
-	MAX77686_REG_LDO25CTRL1,
-	MAX77686_REG_LDO26CTRL1,
-	/* Reserved: 0x5A-0x5F */
-	MAX77686_REG_LDO1CTRL2	,
-	MAX77686_REG_LDO2CTRL2	,
-	MAX77686_REG_LDO3CTRL2	,
-	MAX77686_REG_LDO4CTRL2	,
-	MAX77686_REG_LDO5CTRL2	,
-	MAX77686_REG_LDO6CTRL2,
-	MAX77686_REG_LDO7CTRL2	,
-	MAX77686_REG_LDO8CTRL2	,
-	MAX77686_REG_LDO9CTRL2	,
-	MAX77686_REG_LDO10CTRL2,
-	MAX77686_REG_LDO11CTRL2,
-	MAX77686_REG_LDO12CTRL2,
-	MAX77686_REG_LDO13CTRL2,
-	MAX77686_REG_LDO14CTRL2,
-	MAX77686_REG_LDO15CTRL2,
-	MAX77686_REG_LDO16CTRL2,
-	MAX77686_REG_LDO17CTRL2,
-	MAX77686_REG_LDO18CTRL2,
-	MAX77686_REG_LDO19CTRL2,
-	MAX77686_REG_LDO20CTRL2,
-	MAX77686_REG_LDO21CTRL2,
-	MAX77686_REG_LDO22CTRL2,
-	MAX77686_REG_LDO23CTRL2,
-	MAX77686_REG_LDO24CTRL2,
-	MAX77686_REG_LDO25CTRL2,
-	MAX77686_REG_LDO26CTRL2,
-	MAX77686_REG_BBAT_CHG,
-	MAX77686_REG_32KHZ,
-};
-
-static int max77686_freeze(struct device *dev)
-{
-	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
-	struct max77686_dev *max77686 = i2c_get_clientdata(i2c);
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(max77686_dumpaddr_pmic); i++)
-		max77686_read_reg(i2c, max77686_dumpaddr_pmic[i],
-				&max77686->reg_dump[i]);
-
-	disable_irq(max77686->irq);
-
-	return 0;
-}
-
-static int max77686_restore(struct device *dev)
-{
-	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
-	struct max77686_dev *max77686 = i2c_get_clientdata(i2c);
-	int i;
-
-	enable_irq(max77686->irq);
-
-	for (i = 0; i < ARRAY_SIZE(max77686_dumpaddr_pmic); i++)
-		max77686_write_reg(i2c, max77686_dumpaddr_pmic[i],
-				max77686->reg_dump[i]);
-
-	return 0;
-}
-#endif
-
-const struct dev_pm_ops max77686_pm = {
-	.suspend = max77686_suspend,
-	.resume = max77686_resume,
-#ifdef CONFIG_HIBERNATION
-	.freeze =  max77686_freeze,
-	.thaw = max77686_restore,
-	.restore = max77686_restore,
-#endif
-};
-
 static struct i2c_driver max77686_i2c_driver = {
 	.driver = {
-		.name = "max77686",
-		.owner = THIS_MODULE,
-		.pm = &max77686_pm,
+		   .name = "max77686",
+		   .owner = THIS_MODULE,
 	},
 	.probe = max77686_i2c_probe,
 	.remove = max77686_i2c_remove,
diff --git a/include/linux/mfd/max77686-private.h b/include/linux/mfd/max77686-private.h
index ab369e9..2f62d2a 100644
--- a/include/linux/mfd/max77686-private.h
+++ b/include/linux/mfd/max77686-private.h
@@ -4,8 +4,6 @@
  *  Copyright (C) 2012 Samsung Electrnoics
  *  Chiwoong Byun <woong.byun@samsung.com>
  *
- * This program is not provided / owned by Maxim Integrated Products.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -25,8 +23,8 @@
 #define __LINUX_MFD_MAX77686_PRIV_H
 
 #include <linux/i2c.h>
-#include <linux/export.h>
-#include <linux/irqdomain.h>
+#include <linux/regmap.h>
+#include <linux/module.h>
 
 #define MAX77686_REG_INVALID		(0xff)
 
@@ -147,35 +145,35 @@ enum max77686_pmic_reg {
 	/* Reserved: 0x7A-0x7D */
 
 	MAX77686_REG_BBAT_CHG		= 0x7E,
-	MAX77686_REG_32KHZ			= 0x7F,
+	MAX77686_REG_32KHZ		= 0x7F,
 
 	MAX77686_REG_PMIC_END		= 0x80,
 };
 
 enum max77686_rtc_reg {
-	MAX77686_RTC_INT			= 0x00,
-	MAX77686_RTC_INTM			= 0x01,
+	MAX77686_RTC_INT		= 0x00,
+	MAX77686_RTC_INTM		= 0x01,
 	MAX77686_RTC_CONTROLM		= 0x02,
 	MAX77686_RTC_CONTROL		= 0x03,
 	MAX77686_RTC_UPDATE0		= 0x04,
 	/* Reserved: 0x5 */
 	MAX77686_WTSR_SMPL_CNTL		= 0x06,
-	MAX77686_RTC_SEC			= 0x07,
-	MAX77686_RTC_MIN			= 0x08,
-	MAX77686_RTC_HOUR			= 0x09,
+	MAX77686_RTC_SEC		= 0x07,
+	MAX77686_RTC_MIN		= 0x08,
+	MAX77686_RTC_HOUR		= 0x09,
 	MAX77686_RTC_WEEKDAY		= 0x0A,
-	MAX77686_RTC_MONTH			= 0x0B,
-	MAX77686_RTC_YEAR			= 0x0C,
-	MAX77686_RTC_DATE			= 0x0D,
-	MAX77686_ALARM1_SEC			= 0x0E,
-	MAX77686_ALARM1_MIN			= 0x0F,
+	MAX77686_RTC_MONTH		= 0x0B,
+	MAX77686_RTC_YEAR		= 0x0C,
+	MAX77686_RTC_DATE		= 0x0D,
+	MAX77686_ALARM1_SEC		= 0x0E,
+	MAX77686_ALARM1_MIN		= 0x0F,
 	MAX77686_ALARM1_HOUR		= 0x10,
 	MAX77686_ALARM1_WEEKDAY		= 0x11,
 	MAX77686_ALARM1_MONTH		= 0x12,
 	MAX77686_ALARM1_YEAR		= 0x13,
 	MAX77686_ALARM1_DATE		= 0x14,
-	MAX77686_ALARM2_SEC			= 0x15,
-	MAX77686_ALARM2_MIN			= 0x16,
+	MAX77686_ALARM2_SEC		= 0x15,
+	MAX77686_ALARM2_MIN		= 0x16,
 	MAX77686_ALARM2_HOUR		= 0x17,
 	MAX77686_ALARM2_WEEKDAY		= 0x18,
 	MAX77686_ALARM2_MONTH		= 0x19,
@@ -186,11 +184,6 @@ enum max77686_rtc_reg {
 #define MAX77686_IRQSRC_PMIC	(0)
 #define MAX77686_IRQSRC_RTC		(1 << 0)
 
-#define MAX77686_REG_RAMP_RATE_100MV	(0x3<<6)
-#define MAX77686_REG_RAMP_RATE_55MV		(0x2<<6)
-#define MAX77686_REG_RAMP_RATE_27MV		(0x1<<6)
-#define MAX77686_REG_RAMP_RATE_13MV		(0x0<<6)
-
 enum max77686_irq_source {
 	PMIC_INT1 = 0,
 	PMIC_INT2,
@@ -224,26 +217,23 @@ enum max77686_irq {
 
 struct max77686_dev {
 	struct device *dev;
-	struct regmap *regmap;
-	struct regmap *rtc_regmap;
 	struct i2c_client *i2c; /* 0xcc / PMIC, Battery Control, and FLASH */
 	struct i2c_client *rtc; /* slave addr 0x0c */
 	struct mutex iolock;
 
 	int type;
 
+	struct regmap *regmap;		/* regmap for mfd */
+	struct regmap *rtc_regmap;	/* regmap for rtc */
+
+	struct irq_domain *irq_domain;
+
 	int irq;
 	int irq_gpio;
-	struct irq_domain *irq_domain;
 	bool wakeup;
 	struct mutex irqlock;
 	int irq_masks_cur[MAX77686_IRQ_GROUP_NR];
 	int irq_masks_cache[MAX77686_IRQ_GROUP_NR];
-	int wtsr_smpl;
-
-#ifdef CONFIG_HIBERNATION
-	u8 reg_dump[MAX77686_REG_PMIC_END];
-#endif
 };
 
 enum max77686_types {
@@ -260,6 +250,6 @@ extern int max77686_bulk_read(struct regmap *map, u8 reg, int count,
 extern int max77686_write_reg(struct regmap *map, u8 reg, u8 value);
 extern int max77686_bulk_write(struct regmap *map, u8 reg, int count,
 				u8 *buf);
-extern int max77686_update_reg(struct regmap *map, u8 reg, u8 val, u8 mask);
-
+extern int max77686_update_reg(struct regmap *map, u8 reg, u8 val, u8 mask)
+;
 #endif /*  __LINUX_MFD_MAX77686_PRIV_H */
diff --git a/include/linux/mfd/max77686.h b/include/linux/mfd/max77686.h
index a151fc6..fcf3126 100644
--- a/include/linux/mfd/max77686.h
+++ b/include/linux/mfd/max77686.h
@@ -4,8 +4,6 @@
  *  Copyright (C) 2012 Samsung Electrnoics
  *  Chiwoong Byun <woong.byun@samsung.com>
  *
- * This program is not provided / owned by Maxim Integrated Products.
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -32,9 +30,6 @@
 
 #include <linux/regulator/consumer.h>
 
-#define MAX77686_SMPL_ENABLE			(0x1)
-#define MAX77686_WTSR_ENABLE			(0x2)
-
 /* MAX77686 regulator IDs */
 enum max77686_regulators {
 	MAX77686_LDO1 = 0,
@@ -90,23 +85,11 @@ enum max77686_opmode {
 	MAX77686_OPMODE_STANDBY,
 };
 
-enum max77686_ramp_rate {
-	MAX77686_RAMP_RATE_100MV,
-	MAX77686_RAMP_RATE_13MV,
-	MAX77686_RAMP_RATE_27MV,
-	MAX77686_RAMP_RATE_55MV,
-};
-
 struct max77686_opmode_data {
 	int id;
 	int mode;
 };
 
-struct max77686_buck234_gpio_data {
-	int gpio;
-	int data;
-};
-
 struct max77686_platform_data {
 	/* IRQ */
 	int irq_gpio;
@@ -116,19 +99,15 @@ struct max77686_platform_data {
 	/* ---- PMIC ---- */
 	struct max77686_regulator_data *regulators;
 	int num_regulators;
-	int has_full_constraints;
 
 	struct max77686_opmode_data *opmode_data;
-	int ramp_rate;
-	int wtsr_smpl;
 
 	/*
 	 * GPIO-DVS feature is not enabled with the current version of
 	 * MAX77686 driver. Buck2/3/4_voltages[0] is used as the default
 	 * voltage at probe. DVS/SELB gpios are set as OUTPUT-LOW.
 	 */
-	struct max77686_buck234_gpio_data buck234_gpio_dvs[3];
-					/* GPIO of [0]DVS1, [1]DVS2, [2]DVS3 */
+	int buck234_gpio_dvs[3]; /* GPIO of [0]DVS1, [1]DVS2, [2]DVS3 */
 	int buck234_gpio_selb[3]; /* [0]SELB2, [1]SELB3, [2]SELB4 */
 	unsigned int buck2_voltage[8]; /* buckx_voltage in uV */
 	unsigned int buck3_voltage[8];
-- 
1.7.4.1

