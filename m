Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab2ENLkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:40:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11807 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab2ENLkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:40:13 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-ee-4fb0ef1bf607
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v4 2/2] MFD: MAX77693: add IRQ handler
Date: Mon, 14 May 2012 20:40:06 +0900
Message-id: <1336995606-1607-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports IRQ handling for MAX77693.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/Makefile         |    2 +-
 drivers/mfd/max77693-irq.c   |  309 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/max77693.c       |   32 +++++
 include/linux/mfd/max77693.h |    1 -
 4 files changed, 342 insertions(+), 2 deletions(-)
 create mode 100644 drivers/mfd/max77693-irq.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index ae18cf1..ddd9fa7 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -79,7 +79,7 @@ max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
 obj-$(CONFIG_MFD_MAX8997)	+= max8997.o max8997-irq.o
 obj-$(CONFIG_MFD_MAX8998)	+= max8998.o max8998-irq.o
-obj-$(CONFIG_MFD_MAX77693)	+= max77693.o
+obj-$(CONFIG_MFD_MAX77693)	+= max77693.o max77693-irq.o
 
 pcf50633-objs			:= pcf50633-core.o pcf50633-irq.o
 obj-$(CONFIG_MFD_PCF50633)	+= pcf50633.o
diff --git a/drivers/mfd/max77693-irq.c b/drivers/mfd/max77693-irq.c
new file mode 100644
index 0000000..2b40356
--- /dev/null
+++ b/drivers/mfd/max77693-irq.c
@@ -0,0 +1,309 @@
+/*
+ * max77693-irq.c - Interrupt controller support for MAX77693
+ *
+ * Copyright (C) 2012 Samsung Electronics Co.Ltd
+ * SangYoung Son <hello.son@samsung.com>
+ *
+ * This program is not provided / owned by Maxim Integrated Products.
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
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * This driver is based on max8997-irq.c
+ */
+
+#include <linux/err.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/irqdomain.h>
+#include <linux/mfd/max77693.h>
+#include <linux/mfd/max77693-private.h>
+
+static const u8 max77693_mask_reg[] = {
+	[LED_INT] = MAX77693_LED_REG_FLASH_INT_MASK,
+	[TOPSYS_INT] = MAX77693_PMIC_REG_TOPSYS_INT_MASK,
+	[CHG_INT] = MAX77693_CHG_REG_CHG_INT_MASK,
+	[MUIC_INT1] = MAX77693_MUIC_REG_INTMASK1,
+	[MUIC_INT2] = MAX77693_MUIC_REG_INTMASK2,
+	[MUIC_INT3] = MAX77693_MUIC_REG_INTMASK3,
+};
+
+static struct regmap *max77693_get_regmap(struct max77693_dev *max77693,
+				enum max77693_irq_source src)
+{
+	switch (src) {
+	case LED_INT ... CHG_INT:
+		return max77693->regmap;
+	case MUIC_INT1 ... MUIC_INT3:
+		return max77693->regmap_muic;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+}
+
+struct max77693_irq_data {
+	int mask;
+	enum max77693_irq_source group;
+};
+
+#define DECLARE_IRQ(idx, _group, _mask)		\
+	[(idx)] = { .group = (_group), .mask = (_mask) }
+static const struct max77693_irq_data max77693_irqs[] = {
+	DECLARE_IRQ(MAX77693_LED_IRQ_FLED2_OPEN,	LED_INT, 1 << 0),
+	DECLARE_IRQ(MAX77693_LED_IRQ_FLED2_SHORT,	LED_INT, 1 << 1),
+	DECLARE_IRQ(MAX77693_LED_IRQ_FLED1_OPEN,	LED_INT, 1 << 2),
+	DECLARE_IRQ(MAX77693_LED_IRQ_FLED1_SHORT,	LED_INT, 1 << 3),
+	DECLARE_IRQ(MAX77693_LED_IRQ_MAX_FLASH,		LED_INT, 1 << 4),
+
+	DECLARE_IRQ(MAX77693_TOPSYS_IRQ_T120C_INT,	TOPSYS_INT, 1 << 0),
+	DECLARE_IRQ(MAX77693_TOPSYS_IRQ_T140C_INT,	TOPSYS_INT, 1 << 1),
+	DECLARE_IRQ(MAX77693_TOPSYS_IRQ_LOWSYS_INT,	TOPSYS_INT, 1 << 3),
+
+	DECLARE_IRQ(MAX77693_CHG_IRQ_BYP_I,		CHG_INT, 1 << 0),
+	DECLARE_IRQ(MAX77693_CHG_IRQ_THM_I,		CHG_INT, 1 << 2),
+	DECLARE_IRQ(MAX77693_CHG_IRQ_BAT_I,		CHG_INT, 1 << 3),
+	DECLARE_IRQ(MAX77693_CHG_IRQ_CHG_I,		CHG_INT, 1 << 4),
+	DECLARE_IRQ(MAX77693_CHG_IRQ_CHGIN_I,		CHG_INT, 1 << 6),
+
+	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT1_ADC,		MUIC_INT1, 1 << 0),
+	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT1_ADC_LOW,	MUIC_INT1, 1 << 1),
+	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT1_ADC_ERR,	MUIC_INT1, 1 << 2),
+	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT1_ADC1K,	MUIC_INT1, 1 << 3),
+
+	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT2_CHGTYP,	MUIC_INT2, 1 << 0),
+	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT2_CHGDETREUN,	MUIC_INT2, 1 << 1),
+	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT2_DCDTMR,	MUIC_INT2, 1 << 2),
+	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT2_DXOVP,	MUIC_INT2, 1 << 3),
+	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT2_VBVOLT,	MUIC_INT2, 1 << 4),
+	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT2_VIDRM,	MUIC_INT2, 1 << 5),
+
+	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT3_EOC,		MUIC_INT3, 1 << 0),
+	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT3_CGMBC,	MUIC_INT3, 1 << 1),
+	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT3_OVP,		MUIC_INT3, 1 << 2),
+	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT3_MBCCHG_ERR,	MUIC_INT3, 1 << 3),
+	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT3_CHG_ENABLED,	MUIC_INT3, 1 << 4),
+	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT3_BAT_DET,	MUIC_INT3, 1 << 5),
+};
+
+static void max77693_irq_lock(struct irq_data *data)
+{
+	struct max77693_dev *max77693 = irq_get_chip_data(data->irq);
+
+	mutex_lock(&max77693->irqlock);
+}
+
+static void max77693_irq_sync_unlock(struct irq_data *data)
+{
+	struct max77693_dev *max77693 = irq_get_chip_data(data->irq);
+	int i;
+
+	for (i = 0; i < MAX77693_IRQ_GROUP_NR; i++) {
+		u8 mask_reg = max77693_mask_reg[i];
+		struct regmap *map = max77693_get_regmap(max77693, i);
+
+		if (mask_reg == MAX77693_REG_INVALID ||
+				IS_ERR_OR_NULL(map))
+			continue;
+		max77693->irq_masks_cache[i] = max77693->irq_masks_cur[i];
+
+		max77693_write_reg(map, max77693_mask_reg[i],
+				max77693->irq_masks_cur[i]);
+	}
+
+	mutex_unlock(&max77693->irqlock);
+}
+
+static const inline struct max77693_irq_data *
+irq_to_max77693_irq(struct max77693_dev *max77693, int irq)
+{
+	return &max77693_irqs[irq];
+}
+
+static void max77693_irq_mask(struct irq_data *data)
+{
+	struct max77693_dev *max77693 = irq_get_chip_data(data->irq);
+	const struct max77693_irq_data *irq_data =
+				irq_to_max77693_irq(max77693, data->irq);
+
+	if (irq_data->group >= MUIC_INT1 && irq_data->group <= MUIC_INT3)
+		max77693->irq_masks_cur[irq_data->group] &= ~irq_data->mask;
+	else
+		max77693->irq_masks_cur[irq_data->group] |= irq_data->mask;
+}
+
+static void max77693_irq_unmask(struct irq_data *data)
+{
+	struct max77693_dev *max77693 = irq_get_chip_data(data->irq);
+	const struct max77693_irq_data *irq_data =
+	    irq_to_max77693_irq(max77693, data->irq);
+
+	if (irq_data->group >= MUIC_INT1 && irq_data->group <= MUIC_INT3)
+		max77693->irq_masks_cur[irq_data->group] |= irq_data->mask;
+	else
+		max77693->irq_masks_cur[irq_data->group] &= ~irq_data->mask;
+}
+
+static struct irq_chip max77693_irq_chip = {
+	.name			= "max77693",
+	.irq_bus_lock		= max77693_irq_lock,
+	.irq_bus_sync_unlock	= max77693_irq_sync_unlock,
+	.irq_mask		= max77693_irq_mask,
+	.irq_unmask		= max77693_irq_unmask,
+};
+
+#define MAX77693_IRQSRC_CHG		(1 << 0)
+#define MAX77693_IRQSRC_TOP		(1 << 1)
+#define MAX77693_IRQSRC_FLASH		(1 << 2)
+#define MAX77693_IRQSRC_MUIC		(1 << 3)
+static irqreturn_t max77693_irq_thread(int irq, void *data)
+{
+	struct max77693_dev *max77693 = data;
+	u8 irq_reg[MAX77693_IRQ_GROUP_NR] = {};
+	u8 irq_src;
+	int ret;
+	int i, cur_irq;
+
+	ret = max77693_read_reg(max77693->regmap, MAX77693_PMIC_REG_INTSRC,
+				&irq_src);
+	if (ret < 0) {
+		dev_err(max77693->dev, "Failed to read interrupt source: %d\n",
+				ret);
+		return IRQ_NONE;
+	}
+
+	if (irq_src & MAX77693_IRQSRC_CHG)
+		/* CHG_INT */
+		ret = max77693_read_reg(max77693->regmap, MAX77693_CHG_REG_CHG_INT,
+				&irq_reg[CHG_INT]);
+
+	if (irq_src & MAX77693_IRQSRC_TOP)
+		/* TOPSYS_INT */
+		ret = max77693_read_reg(max77693->regmap,
+			MAX77693_PMIC_REG_TOPSYS_INT, &irq_reg[TOPSYS_INT]);
+
+	if (irq_src & MAX77693_IRQSRC_FLASH)
+		/* LED_INT */
+		ret = max77693_read_reg(max77693->regmap,
+			MAX77693_LED_REG_FLASH_INT, &irq_reg[LED_INT]);
+
+	if (irq_src & MAX77693_IRQSRC_MUIC)
+		/* MUIC INT1 ~ INT3 */
+		max77693_bulk_read(max77693->regmap, MAX77693_MUIC_REG_INT1,
+			MAX77693_NUM_IRQ_MUIC_REGS, &irq_reg[MUIC_INT1]);
+
+	/* Apply masking */
+	for (i = 0; i < MAX77693_IRQ_GROUP_NR; i++) {
+		if (i >= MUIC_INT1 && i <= MUIC_INT3)
+			irq_reg[i] &= max77693->irq_masks_cur[i];
+		else
+			irq_reg[i] &= ~max77693->irq_masks_cur[i];
+	}
+
+	/* Report */
+	for (i = 0; i < MAX77693_IRQ_NR; i++) {
+		if (irq_reg[max77693_irqs[i].group] & max77693_irqs[i].mask) {
+			cur_irq = irq_find_mapping(max77693->irq_domain, i);
+			if (cur_irq)
+				handle_nested_irq(cur_irq);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+int max77693_irq_resume(struct max77693_dev *max77693)
+{
+	if (max77693->irq)
+		max77693_irq_thread(0, max77693);
+
+	return 0;
+}
+
+static int max77693_irq_domain_map(struct irq_domain *d, unsigned int irq,
+				irq_hw_number_t hw)
+{
+	struct max77693_dev *max77693 = d->host_data;
+
+	irq_set_chip_data(irq, max77693);
+	irq_set_chip_and_handler(irq, &max77693_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(irq, 1);
+#ifdef CONFIG_ARM
+	set_irq_flags(irq, IRQF_VALID);
+#else
+	irq_set_noprobe(irq);
+#endif
+	return 0;
+}
+
+static struct irq_domain_ops max77693_irq_domain_ops = {
+	.map = max77693_irq_domain_map,
+};
+
+int max77693_irq_init(struct max77693_dev *max77693)
+{
+	struct irq_domain *domain;
+	int i;
+	int ret;
+
+	mutex_init(&max77693->irqlock);
+
+	/* Mask individual interrupt sources */
+	for (i = 0; i < MAX77693_IRQ_GROUP_NR; i++) {
+		struct regmap *map;
+		/* MUIC IRQ  0:MASK 1:NOT MASK */
+		/* Other IRQ 1:MASK 0:NOT MASK */
+		if (i >= MUIC_INT1 && i <= MUIC_INT3) {
+			max77693->irq_masks_cur[i] = 0x00;
+			max77693->irq_masks_cache[i] = 0x00;
+		} else {
+			max77693->irq_masks_cur[i] = 0xff;
+			max77693->irq_masks_cache[i] = 0xff;
+		}
+		map = max77693_get_regmap(max77693, i);
+
+		if (IS_ERR_OR_NULL(map))
+			continue;
+		if (max77693_mask_reg[i] == MAX77693_REG_INVALID)
+			continue;
+		if (i >= MUIC_INT1 && i <= MUIC_INT3)
+			max77693_write_reg(map, max77693_mask_reg[i], 0x00);
+		else
+			max77693_write_reg(map, max77693_mask_reg[i], 0xff);
+	}
+
+	domain = irq_domain_add_linear(NULL, MAX77693_IRQ_NR,
+					&max77693_irq_domain_ops, max77693);
+	if (!domain) {
+		dev_err(max77693->dev, "could not create irq domain\n");
+		return -ENODEV;
+	}
+	max77693->irq_domain = domain;
+
+	ret = request_threaded_irq(max77693->irq, NULL, max77693_irq_thread,
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   "max77693-irq", max77693);
+
+	if (ret)
+		dev_err(max77693->dev, "Failed to request IRQ %d: %d\n",
+			max77693->irq, ret);
+
+	return 0;
+}
+
+void max77693_irq_exit(struct max77693_dev *max77693)
+{
+	if (max77693->irq)
+		free_irq(max77693->irq, max77693);
+}
diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index c852515..e9e4278 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -154,6 +154,10 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	max77693->haptic = i2c_new_dummy(i2c->adapter, I2C_ADDR_HAPTIC);
 	i2c_set_clientdata(max77693->haptic, max77693);
 
+	ret = max77693_irq_init(max77693);
+	if (ret < 0)
+		goto err_mfd;
+
 	pm_runtime_set_active(max77693->dev);
 
 	ret = mfd_add_devices(max77693->dev, -1, max77693_devs,
@@ -161,6 +165,8 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err_mfd;
 
+	device_init_wakeup(max77693->dev, pdata->wakeup);
+
 	return ret;
 
 err_mfd:
@@ -189,10 +195,36 @@ static const struct i2c_device_id max77693_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, max77693_i2c_id);
 
+static int max77693_suspend(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
+
+	if (device_may_wakeup(dev))
+		irq_set_irq_wake(max77693->irq, 1);
+	return 0;
+}
+
+static int max77693_resume(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
+
+	if (device_may_wakeup(dev))
+		irq_set_irq_wake(max77693->irq, 0);
+	return max77693_irq_resume(max77693);
+}
+
+const struct dev_pm_ops max77693_pm = {
+	.suspend = max77693_suspend,
+	.resume = max77693_resume,
+};
+
 static struct i2c_driver max77693_i2c_driver = {
 	.driver = {
 		   .name = "max77693",
 		   .owner = THIS_MODULE,
+		   .pm = &max77693_pm,
 	},
 	.probe = max77693_i2c_probe,
 	.remove = max77693_i2c_remove,
diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
index 5020b86..1d28ae9 100644
--- a/include/linux/mfd/max77693.h
+++ b/include/linux/mfd/max77693.h
@@ -31,7 +31,6 @@
 #define __LINUX_MFD_MAX77693_H
 
 struct max77693_platform_data {
-	/* IRQ */
 	int wakeup;
 };
 #endif	/* __LINUX_MFD_MAX77693_H */
-- 
1.7.0.4

