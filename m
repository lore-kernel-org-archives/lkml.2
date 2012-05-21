Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab2EUJwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:52:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14482 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670Ab2EUJwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:52:09 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-59-4fba1042dc7b
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Oritz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Gridwodd <lrg@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>
Subject: [PATCH v4 1/3] mfd: MAX77686: Add Maxim 77686 mfd driver
Date: Mon, 21 May 2012 18:51:45 +0900
Message-id: <1337593907-6615-2-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1337593907-6615-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1337593907-6615-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t9jQV0ngV3+BjOWSltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MY2fmshWcucVYcXXTFdYGxoebGbsYOTkkBEwk2na2s0HYYhIX
	7q0Hs4UEpjNKvPpbAGGvZJKY1VMFYrMJ6Ej833eTHcQWEVCQ2Nz7jLWLkYuDWeAzk8T2k/NY
	uhg5OIQFHCWWfBYDqWERUJWYePMeC4jNK+Au8fdDHzvELgWJBffegu3iFPCQWNK7jxlil7vE
	ruvHmCYw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEezzZ9I7GFc1WBxiFOBgVOLh
	XfBmp78Qa2JZcWXuIUYJDmYlEd67D4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZ8s2eEvJJCe
	WJKanZpakFoEk2Xi4JRqYJT8mPOgvGXvj/1dkfn1HSYWyYsXPLa5VPjvc6Tz1D05yillns++
	7clUcG4oW1jh8GXCwrIP74TDOpdGfWw7zlQz9/H9G9wLz55ncLETiY92fG70/UQXT9kWtZuO
	K1+JTJld+W/utRc/xf84nlsRa/7o14GXu/aYWV8KFenfzsTX6sSle1Rsm6sSS3FGoqEWc1Fx
	IgBr7zer9QEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is device driver for MAX77686 chip.
MAX77686 is PMIC and includes regulator and rtc on it.
This driver is core of MAX77686 chip, so provides common support for accessing
on-chip devices. It uses irq_domain to manage irq and regmap to read/write data
to its register with i2c bus.

Changes in patchset v3
- Remove APIs accessing to register ( e.g. max77686_read_reg() )
  to use regmap's API directly over all related drivers.

Changes in patchset v2
- Change I/O interface register to using regmap.
- Support IRQ domain, and remove irq_base from all referenced.
- Add module_param() macro to debug_mask parameter. It can be set various
  masking value for specific purpose while debugging.
- Remove IRQ_TEST block and some unnecessary points.

Signed-off-by: Chiwoong Byun <woong.byun@samsung.com>
Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig                  |   11 ++
 drivers/mfd/Makefile                 |    1 +
 drivers/mfd/max77686-irq.c           |  309 ++++++++++++++++++++++++++++++++++
 drivers/mfd/max77686.c               |  156 +++++++++++++++++
 include/linux/mfd/max77686-private.h |  247 +++++++++++++++++++++++++++
 include/linux/mfd/max77686.h         |  117 +++++++++++++
 6 files changed, 841 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/max77686-irq.c
 create mode 100644 drivers/mfd/max77686.c
 create mode 100644 include/linux/mfd/max77686-private.h
 create mode 100644 include/linux/mfd/max77686.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index a8619eb..3ad34b6 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -441,6 +441,17 @@ config MFD_MAX8998
 	  additional drivers must be enabled in order to use the functionality
 	  of the device.
 
+config MFD_MAX77686
+	bool "Maxim Semiconductor MAX77686 PMIC Support"
+	depends on I2C && GENERIC_HARDIRQS
+	select MFD_CORE
+	help
+	  Say yes here to support for Maxim Semiconductor MAX77686.
+	  This is a Power Management IC with RTC on chip.
+	  This driver provides common support for accessing the device;
+	  additional drivers must be enabled in order to use the functionality
+	  of the device.
+
 config MFD_S5M_CORE
 	bool "SAMSUNG S5M Series Support"
 	depends on I2C=y && GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index ddd9fa7..a793ebd 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -79,6 +79,7 @@ max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
 obj-$(CONFIG_MFD_MAX8997)	+= max8997.o max8997-irq.o
 obj-$(CONFIG_MFD_MAX8998)	+= max8998.o max8998-irq.o
+obj-$(CONFIG_MFD_MAX77686)	+= max77686.o max77686-irq.o
 obj-$(CONFIG_MFD_MAX77693)	+= max77693.o max77693-irq.o
 
 pcf50633-objs			:= pcf50633-core.o pcf50633-irq.o
diff --git a/drivers/mfd/max77686-irq.c b/drivers/mfd/max77686-irq.c
new file mode 100644
index 0000000..fc10122
--- /dev/null
+++ b/drivers/mfd/max77686-irq.c
@@ -0,0 +1,309 @@
+/*
+ * max77686-irq.c - Interrupt controller support for MAX77686
+ *
+ * Copyright (C) 2012 Samsung Electronics Co.Ltd
+ * Chiwoong Byun <woong.byun@samsung.com>
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
+#include <linux/gpio.h>
+#include <linux/mfd/max77686.h>
+#include <linux/mfd/max77686-private.h>
+#include <linux/irqdomain.h>
+#include <linux/regmap.h>
+
+enum {
+	MAX77686_DEBUG_IRQ_INFO = 1 << 0,
+	MAX77686_DEBUG_IRQ_MASK = 1 << 1,
+	MAX77686_DEBUG_IRQ_INT = 1 << 2,
+};
+
+static int debug_mask = 0;
+module_param(debug_mask, int, 0);
+MODULE_PARM_DESC(debug_mask, "Set debug_mask : 0x0=off 0x1=IRQ_INFO  0x2=IRQ_MASK 0x4=IRQ_INI)");
+
+static const u8 max77686_mask_reg[] = {
+	[PMIC_INT1] = MAX77686_REG_INT1MSK,
+	[PMIC_INT2] = MAX77686_REG_INT2MSK,
+	[RTC_INT] = MAX77686_RTC_INTM,
+};
+
+static struct regmap *max77686_get_regmap(struct max77686_dev *max77686,
+				enum max77686_irq_source src)
+{
+	switch (src) {
+	case PMIC_INT1 ... PMIC_INT2:
+		return max77686->regmap;
+	case RTC_INT:
+		return max77686->rtc_regmap;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+}
+
+struct max77686_irq_data {
+	int mask;
+	enum max77686_irq_source group;
+};
+
+#define DECLARE_IRQ(idx, _group, _mask)		\
+	[(idx)] = { .group = (_group), .mask = (_mask) }
+static const struct max77686_irq_data max77686_irqs[] = {
+	DECLARE_IRQ(MAX77686_PMICIRQ_PWRONF,	PMIC_INT1, 1 << 0),
+	DECLARE_IRQ(MAX77686_PMICIRQ_PWRONR,	PMIC_INT1, 1 << 1),
+	DECLARE_IRQ(MAX77686_PMICIRQ_JIGONBF,	PMIC_INT1, 1 << 2),
+	DECLARE_IRQ(MAX77686_PMICIRQ_JIGONBR,	PMIC_INT1, 1 << 3),
+	DECLARE_IRQ(MAX77686_PMICIRQ_ACOKBF,	PMIC_INT1, 1 << 4),
+	DECLARE_IRQ(MAX77686_PMICIRQ_ACOKBR,	PMIC_INT1, 1 << 5),
+	DECLARE_IRQ(MAX77686_PMICIRQ_ONKEY1S,	PMIC_INT1, 1 << 6),
+	DECLARE_IRQ(MAX77686_PMICIRQ_MRSTB,		PMIC_INT1, 1 << 7),
+	DECLARE_IRQ(MAX77686_PMICIRQ_140C,		PMIC_INT2, 1 << 0),
+	DECLARE_IRQ(MAX77686_PMICIRQ_120C,		PMIC_INT2, 1 << 1),
+	DECLARE_IRQ(MAX77686_RTCIRQ_RTC60S,		RTC_INT, 1 << 0),
+	DECLARE_IRQ(MAX77686_RTCIRQ_RTCA1,		RTC_INT, 1 << 1),
+	DECLARE_IRQ(MAX77686_RTCIRQ_RTCA2,		RTC_INT, 1 << 2),
+	DECLARE_IRQ(MAX77686_RTCIRQ_SMPL,		RTC_INT, 1 << 3),
+	DECLARE_IRQ(MAX77686_RTCIRQ_RTC1S,		RTC_INT, 1 << 4),
+	DECLARE_IRQ(MAX77686_RTCIRQ_WTSR,		RTC_INT, 1 << 5),
+};
+
+static void max77686_irq_lock(struct irq_data *data)
+{
+	struct max77686_dev *max77686 = irq_get_chip_data(data->irq);
+
+	if (debug_mask & MAX77686_DEBUG_IRQ_MASK)
+		pr_info("%s\n", __func__);
+
+	mutex_lock(&max77686->irqlock);
+}
+
+static void max77686_irq_sync_unlock(struct irq_data *data)
+{
+	struct max77686_dev *max77686 = irq_get_chip_data(data->irq);
+	int i;
+
+	for (i = 0; i < MAX77686_IRQ_GROUP_NR; i++) {
+		u8 mask_reg = max77686_mask_reg[i];
+		struct regmap *map = max77686_get_regmap(max77686, i);
+
+		if (debug_mask & MAX77686_DEBUG_IRQ_MASK)
+			pr_debug("%s: mask_reg[%d]=0x%x, cur=0x%x\n",
+			__func__, i, mask_reg, max77686->irq_masks_cur[i]);
+
+		if (mask_reg == MAX77686_REG_INVALID ||
+				IS_ERR_OR_NULL(map))
+			continue;
+
+		max77686->irq_masks_cache[i] = max77686->irq_masks_cur[i];
+
+		regmap_write(map, max77686_mask_reg[i],
+				max77686->irq_masks_cur[i]);
+	}
+
+	mutex_unlock(&max77686->irqlock);
+}
+
+static const inline struct max77686_irq_data *to_max77686_irq(int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	return &max77686_irqs[data->hwirq];
+}
+
+static void max77686_irq_mask(struct irq_data *data)
+{
+	struct max77686_dev *max77686 = irq_get_chip_data(data->irq);
+	const struct max77686_irq_data *irq_data = to_max77686_irq(data->irq);
+
+	max77686->irq_masks_cur[irq_data->group] |= irq_data->mask;
+
+	if (debug_mask & MAX77686_DEBUG_IRQ_MASK)
+		pr_info("%s: group=%d, cur=0x%x\n",
+			__func__, irq_data->group,
+			max77686->irq_masks_cur[irq_data->group]);
+}
+
+static void max77686_irq_unmask(struct irq_data *data)
+{
+	struct max77686_dev *max77686 = irq_get_chip_data(data->irq);
+	const struct max77686_irq_data *irq_data = to_max77686_irq(data->irq);
+
+	max77686->irq_masks_cur[irq_data->group] &= ~irq_data->mask;
+
+	if (debug_mask & MAX77686_DEBUG_IRQ_MASK)
+		pr_info("%s: group=%d, cur=0x%x\n",
+			__func__, irq_data->group,
+			max77686->irq_masks_cur[irq_data->group]);
+}
+
+static struct irq_chip max77686_irq_chip = {
+	.name			= "max77686",
+	.irq_bus_lock		= max77686_irq_lock,
+	.irq_bus_sync_unlock	= max77686_irq_sync_unlock,
+	.irq_mask		= max77686_irq_mask,
+	.irq_unmask		= max77686_irq_unmask,
+};
+
+static irqreturn_t max77686_irq_thread(int irq, void *data)
+{
+	struct max77686_dev *max77686 = data;
+	unsigned int irq_reg[MAX77686_IRQ_GROUP_NR] = {};
+	unsigned int irq_src;
+	int ret;
+	int i, cur_irq;
+
+	ret = regmap_read(max77686->regmap,  MAX77686_REG_INTSRC, &irq_src);
+	if (ret < 0) {
+		dev_err(max77686->dev, "Failed to read interrupt source: %d\n",
+				ret);
+		return IRQ_NONE;
+	}
+
+	if (debug_mask & MAX77686_DEBUG_IRQ_INT)
+		pr_info("%s: irq_src=0x%x\n", __func__, irq_src);
+
+	if (irq_src == MAX77686_IRQSRC_PMIC) {
+		ret = regmap_bulk_read(max77686->rtc_regmap,
+					 MAX77686_REG_INT1, irq_reg, 2);
+		if (ret < 0) {
+			dev_err(max77686->dev, "Failed to read interrupt source: %d\n",
+					ret);
+			return IRQ_NONE;
+		}
+
+		if (debug_mask & MAX77686_DEBUG_IRQ_INT)
+			pr_info("%s: int1=0x%x, int2=0x%x\n", __func__,
+				 irq_reg[PMIC_INT1], irq_reg[PMIC_INT2]);
+	}
+
+	if (irq_src & MAX77686_IRQSRC_RTC) {
+		ret = regmap_read(max77686->rtc_regmap,
+					MAX77686_RTC_INT, &irq_reg[RTC_INT]);
+		if (ret < 0) {
+			dev_err(max77686->dev, "Failed to read interrupt source: %d\n",
+					ret);
+			return IRQ_NONE;
+		}
+
+		if (debug_mask & MAX77686_DEBUG_IRQ_INT)
+			pr_info("%s: rtc int=0x%x\n", __func__,
+							 irq_reg[RTC_INT]);
+
+	}
+
+	for (i = 0; i < MAX77686_IRQ_NR; i++) {
+		if (irq_reg[max77686_irqs[i].group] & max77686_irqs[i].mask) {
+			cur_irq = irq_find_mapping(max77686->irq_domain, i);
+			if (cur_irq)
+				handle_nested_irq(cur_irq);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int max77686_irq_domain_map(struct irq_domain *d, unsigned int irq,
+					irq_hw_number_t hw)
+{
+	struct max77686_dev *max77686 = d->host_data;
+
+	irq_set_chip_data(irq, max77686);
+	irq_set_chip_and_handler(irq, &max77686_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(irq, 1);
+#ifdef CONFIG_ARM
+	set_irq_flags(irq, IRQF_VALID);
+#else
+	irq_set_noprobe(irq);
+#endif
+	return 0;
+}
+
+static struct irq_domain_ops max77686_irq_domain_ops = {
+	.map = max77686_irq_domain_map,
+};
+
+int max77686_irq_init(struct max77686_dev *max77686)
+{
+	struct irq_domain *domain;
+	int i;
+	int ret;
+	int val;
+	struct regmap *map;
+
+	mutex_init(&max77686->irqlock);
+
+	max77686->irq = gpio_to_irq(max77686->irq_gpio);
+
+	if (debug_mask & MAX77686_DEBUG_IRQ_INT) {
+		ret = gpio_request(max77686->irq_gpio, "pmic_irq");
+		if (ret < 0) {
+			dev_err(max77686->dev,
+				"Failed to request gpio %d with ret: %d\n",
+				max77686->irq_gpio, ret);
+			return IRQ_NONE;
+		}
+
+		gpio_direction_input(max77686->irq_gpio);
+		val = gpio_get_value(max77686->irq_gpio);
+		gpio_free(max77686->irq_gpio);
+		pr_info("%s: gpio_irq=%x\n", __func__, val);
+	}
+
+	/* Mask individual interrupt sources */
+	for (i = 0; i < MAX77686_IRQ_GROUP_NR; i++) {
+		max77686->irq_masks_cur[i] = 0xff;
+		max77686->irq_masks_cache[i] = 0xff;
+		map = max77686_get_regmap(max77686, i);
+
+		if (IS_ERR_OR_NULL(map))
+			continue;
+		if (max77686_mask_reg[i] == MAX77686_REG_INVALID)
+			continue;
+
+		regmap_write(map, max77686_mask_reg[i], 0xff);
+	}
+	domain = irq_domain_add_linear(NULL, MAX77686_IRQ_NR,
+					&max77686_irq_domain_ops, max77686);
+	if (!domain) {
+		dev_err(max77686->dev, "could not create irq domain\n");
+		return -ENODEV;
+	}
+	max77686->irq_domain = domain;
+
+	ret = request_threaded_irq(max77686->irq, NULL, max77686_irq_thread,
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   "max77686-irq", max77686);
+
+	if (ret)
+		dev_err(max77686->dev, "Failed to request IRQ %d: %d\n",
+			max77686->irq, ret);
+
+
+	if (debug_mask & MAX77686_DEBUG_IRQ_INFO)
+		pr_info("%s-\n", __func__);
+
+	return 0;
+}
+
+void max77686_irq_exit(struct max77686_dev *max77686)
+{
+	if (max77686->irq)
+		free_irq(max77686->irq, max77686);
+}
diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
new file mode 100644
index 0000000..11e5601
--- /dev/null
+++ b/drivers/mfd/max77686.c
@@ -0,0 +1,156 @@
+/*
+ * max77686.c - mfd core driver for the Maxim 77686
+ *
+ * Copyright (C) 2012 Samsung Electronics
+ * Chiwoong Byun <woong.byun@smasung.com>
+ * Jonghwa Lee <jonghwa3.lee@samsung.com>
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
+ * This driver is based on max8997.c
+ */
+
+#include <linux/export.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/pm_runtime.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/max77686.h>
+#include <linux/mfd/max77686-private.h>
+#include <linux/err.h>
+
+#define I2C_ADDR_RTC	(0x0C >> 1)
+
+static struct mfd_cell max77686_devs[] = {
+	{ .name = "max77686-pmic", },
+	{ .name = "max77686-rtc", },
+};
+
+static struct regmap_config max77686_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int max77686_i2c_probe(struct i2c_client *i2c,
+			      const struct i2c_device_id *id)
+{
+	struct max77686_dev *max77686;
+	struct max77686_platform_data *pdata = i2c->dev.platform_data;
+	unsigned int data;
+	int ret = 0;
+
+	max77686 = kzalloc(sizeof(struct max77686_dev), GFP_KERNEL);
+	if (max77686 == NULL)
+		return -ENOMEM;
+
+	max77686->regmap = regmap_init_i2c(i2c, &max77686_regmap_config);
+	if (IS_ERR(max77686->regmap)) {
+		ret = PTR_ERR(max77686->regmap);
+		dev_err(max77686->dev, "Failed to allocate register map: %d\n",
+				ret);
+		kfree(max77686);
+		return ret;
+	}
+
+	i2c_set_clientdata(i2c, max77686);
+	max77686->dev = &i2c->dev;
+	max77686->i2c = i2c;
+	max77686->type = id->driver_data;
+
+	if (!pdata) {
+		ret = -EIO;
+		goto err;
+	}
+
+	max77686->wakeup = pdata->wakeup;
+	max77686->irq_gpio = pdata->irq_gpio;
+
+	mutex_init(&max77686->iolock);
+
+	if (regmap_read(max77686->regmap,
+			 MAX77686_REG_DEVICE_ID, &data) < 0) {
+		dev_err(max77686->dev,
+			"device not found on this channel (this is not an error)\n");
+		ret = -ENODEV;
+		goto err;
+	} else
+		dev_info(max77686->dev, "device found\n");
+
+	max77686->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
+	i2c_set_clientdata(max77686->rtc, max77686);
+
+	max77686_irq_init(max77686);
+
+	ret = mfd_add_devices(max77686->dev, -1, max77686_devs,
+			      ARRAY_SIZE(max77686_devs), NULL, 0);
+
+	if (ret < 0)
+		goto err_mfd;
+
+	return ret;
+
+err_mfd:
+	mfd_remove_devices(max77686->dev);
+	i2c_unregister_device(max77686->rtc);
+err:
+	kfree(max77686);
+	return ret;
+}
+
+static int max77686_i2c_remove(struct i2c_client *i2c)
+{
+	struct max77686_dev *max77686 = i2c_get_clientdata(i2c);
+
+	mfd_remove_devices(max77686->dev);
+	i2c_unregister_device(max77686->rtc);
+	kfree(max77686);
+
+	return 0;
+}
+
+static const struct i2c_device_id max77686_i2c_id[] = {
+	{ "max77686", TYPE_MAX77686 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, max77686_i2c_id);
+
+static struct i2c_driver max77686_i2c_driver = {
+	.driver = {
+		   .name = "max77686",
+		   .owner = THIS_MODULE,
+	},
+	.probe = max77686_i2c_probe,
+	.remove = max77686_i2c_remove,
+	.id_table = max77686_i2c_id,
+};
+
+static int __init max77686_i2c_init(void)
+{
+	return i2c_add_driver(&max77686_i2c_driver);
+}
+/* init early so consumer devices can complete system boot */
+subsys_initcall(max77686_i2c_init);
+
+static void __exit max77686_i2c_exit(void)
+{
+	i2c_del_driver(&max77686_i2c_driver);
+}
+module_exit(max77686_i2c_exit);
+
+MODULE_DESCRIPTION("MAXIM 77686 multi-function core driver");
+MODULE_AUTHOR("Chiwoong Byun <woong.byun@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max77686-private.h b/include/linux/mfd/max77686-private.h
new file mode 100644
index 0000000..962f65e
--- /dev/null
+++ b/include/linux/mfd/max77686-private.h
@@ -0,0 +1,247 @@
+/*
+ * max77686.h - Voltage regulator driver for the Maxim 77686
+ *
+ *  Copyright (C) 2012 Samsung Electrnoics
+ *  Chiwoong Byun <woong.byun@samsung.com>
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
+ */
+
+#ifndef __LINUX_MFD_MAX77686_PRIV_H
+#define __LINUX_MFD_MAX77686_PRIV_H
+
+#include <linux/i2c.h>
+#include <linux/regmap.h>
+#include <linux/module.h>
+
+#define MAX77686_REG_INVALID		(0xff)
+
+enum max77686_pmic_reg {
+	MAX77686_REG_DEVICE_ID		= 0x00,
+	MAX77686_REG_INTSRC		= 0x01,
+	MAX77686_REG_INT1		= 0x02,
+	MAX77686_REG_INT2		= 0x03,
+
+	MAX77686_REG_INT1MSK		= 0x04,
+	MAX77686_REG_INT2MSK		= 0x05,
+
+	MAX77686_REG_STATUS1		= 0x06,
+	MAX77686_REG_STATUS2		= 0x07,
+
+	MAX77686_REG_PWRON		= 0x08,
+	MAX77686_REG_ONOFF_DELAY	= 0x09,
+	MAX77686_REG_MRSTB		= 0x0A,
+	/* Reserved: 0x0B-0x0F */
+
+	MAX77686_REG_BUCK1CTRL		= 0x10,
+	MAX77686_REG_BUCK1OUT		= 0x11,
+	MAX77686_REG_BUCK2CTRL1		= 0x12,
+	MAX77686_REG_BUCK234FREQ	= 0x13,
+	MAX77686_REG_BUCK2DVS1		= 0x14,
+	MAX77686_REG_BUCK2DVS2		= 0x15,
+	MAX77686_REG_BUCK2DVS3		= 0x16,
+	MAX77686_REG_BUCK2DVS4		= 0x17,
+	MAX77686_REG_BUCK2DVS5		= 0x18,
+	MAX77686_REG_BUCK2DVS6		= 0x19,
+	MAX77686_REG_BUCK2DVS7		= 0x1A,
+	MAX77686_REG_BUCK2DVS8		= 0x1B,
+	MAX77686_REG_BUCK3CTRL1		= 0x1C,
+	/* Reserved: 0x1D */
+	MAX77686_REG_BUCK3DVS1		= 0x1E,
+	MAX77686_REG_BUCK3DVS2		= 0x1F,
+	MAX77686_REG_BUCK3DVS3		= 0x20,
+	MAX77686_REG_BUCK3DVS4		= 0x21,
+	MAX77686_REG_BUCK3DVS5		= 0x22,
+	MAX77686_REG_BUCK3DVS6		= 0x23,
+	MAX77686_REG_BUCK3DVS7		= 0x24,
+	MAX77686_REG_BUCK3DVS8		= 0x25,
+	MAX77686_REG_BUCK4CTRL1		= 0x26,
+	/* Reserved: 0x27 */
+	MAX77686_REG_BUCK4DVS1		= 0x28,
+	MAX77686_REG_BUCK4DVS2		= 0x29,
+	MAX77686_REG_BUCK4DVS3		= 0x2A,
+	MAX77686_REG_BUCK4DVS4		= 0x2B,
+	MAX77686_REG_BUCK4DVS5		= 0x2C,
+	MAX77686_REG_BUCK4DVS6		= 0x2D,
+	MAX77686_REG_BUCK4DVS7		= 0x2E,
+	MAX77686_REG_BUCK4DVS8		= 0x2F,
+	MAX77686_REG_BUCK5CTRL		= 0x30,
+	MAX77686_REG_BUCK5OUT		= 0x31,
+	MAX77686_REG_BUCK6CTRL		= 0x32,
+	MAX77686_REG_BUCK6OUT		= 0x33,
+	MAX77686_REG_BUCK7CTRL		= 0x34,
+	MAX77686_REG_BUCK7OUT		= 0x35,
+	MAX77686_REG_BUCK8CTRL		= 0x36,
+	MAX77686_REG_BUCK8OUT		= 0x37,
+	MAX77686_REG_BUCK9CTRL		= 0x38,
+	MAX77686_REG_BUCK9OUT		= 0x39,
+	/* Reserved: 0x3A-0x3F */
+
+	MAX77686_REG_LDO1CTRL1		= 0x40,
+	MAX77686_REG_LDO2CTRL1		= 0x41,
+	MAX77686_REG_LDO3CTRL1		= 0x42,
+	MAX77686_REG_LDO4CTRL1		= 0x43,
+	MAX77686_REG_LDO5CTRL1		= 0x44,
+	MAX77686_REG_LDO6CTRL1		= 0x45,
+	MAX77686_REG_LDO7CTRL1		= 0x46,
+	MAX77686_REG_LDO8CTRL1		= 0x47,
+	MAX77686_REG_LDO9CTRL1		= 0x48,
+	MAX77686_REG_LDO10CTRL1		= 0x49,
+	MAX77686_REG_LDO11CTRL1		= 0x4A,
+	MAX77686_REG_LDO12CTRL1		= 0x4B,
+	MAX77686_REG_LDO13CTRL1		= 0x4C,
+	MAX77686_REG_LDO14CTRL1		= 0x4D,
+	MAX77686_REG_LDO15CTRL1		= 0x4E,
+	MAX77686_REG_LDO16CTRL1		= 0x4F,
+	MAX77686_REG_LDO17CTRL1		= 0x50,
+	MAX77686_REG_LDO18CTRL1		= 0x51,
+	MAX77686_REG_LDO19CTRL1		= 0x52,
+	MAX77686_REG_LDO20CTRL1		= 0x53,
+	MAX77686_REG_LDO21CTRL1		= 0x54,
+	MAX77686_REG_LDO22CTRL1		= 0x55,
+	MAX77686_REG_LDO23CTRL1		= 0x56,
+	MAX77686_REG_LDO24CTRL1		= 0x57,
+	MAX77686_REG_LDO25CTRL1		= 0x58,
+	MAX77686_REG_LDO26CTRL1		= 0x59,
+	/* Reserved: 0x5A-0x5F */
+	MAX77686_REG_LDO1CTRL2		= 0x60,
+	MAX77686_REG_LDO2CTRL2		= 0x61,
+	MAX77686_REG_LDO3CTRL2		= 0x62,
+	MAX77686_REG_LDO4CTRL2		= 0x63,
+	MAX77686_REG_LDO5CTRL2		= 0x64,
+	MAX77686_REG_LDO6CTRL2		= 0x65,
+	MAX77686_REG_LDO7CTRL2		= 0x66,
+	MAX77686_REG_LDO8CTRL2		= 0x67,
+	MAX77686_REG_LDO9CTRL2		= 0x68,
+	MAX77686_REG_LDO10CTRL2		= 0x69,
+	MAX77686_REG_LDO11CTRL2		= 0x6A,
+	MAX77686_REG_LDO12CTRL2		= 0x6B,
+	MAX77686_REG_LDO13CTRL2		= 0x6C,
+	MAX77686_REG_LDO14CTRL2		= 0x6D,
+	MAX77686_REG_LDO15CTRL2		= 0x6E,
+	MAX77686_REG_LDO16CTRL2		= 0x6F,
+	MAX77686_REG_LDO17CTRL2		= 0x70,
+	MAX77686_REG_LDO18CTRL2		= 0x71,
+	MAX77686_REG_LDO19CTRL2		= 0x72,
+	MAX77686_REG_LDO20CTRL2		= 0x73,
+	MAX77686_REG_LDO21CTRL2		= 0x74,
+	MAX77686_REG_LDO22CTRL2		= 0x75,
+	MAX77686_REG_LDO23CTRL2		= 0x76,
+	MAX77686_REG_LDO24CTRL2		= 0x77,
+	MAX77686_REG_LDO25CTRL2		= 0x78,
+	MAX77686_REG_LDO26CTRL2		= 0x79,
+	/* Reserved: 0x7A-0x7D */
+
+	MAX77686_REG_BBAT_CHG		= 0x7E,
+	MAX77686_REG_32KHZ			= 0x7F,
+
+	MAX77686_REG_PMIC_END		= 0x80,
+};
+
+enum max77686_rtc_reg {
+	MAX77686_RTC_INT			= 0x00,
+	MAX77686_RTC_INTM			= 0x01,
+	MAX77686_RTC_CONTROLM		= 0x02,
+	MAX77686_RTC_CONTROL		= 0x03,
+	MAX77686_RTC_UPDATE0		= 0x04,
+	/* Reserved: 0x5 */
+	MAX77686_WTSR_SMPL_CNTL		= 0x06,
+	MAX77686_RTC_SEC			= 0x07,
+	MAX77686_RTC_MIN			= 0x08,
+	MAX77686_RTC_HOUR			= 0x09,
+	MAX77686_RTC_WEEKDAY		= 0x0A,
+	MAX77686_RTC_MONTH			= 0x0B,
+	MAX77686_RTC_YEAR			= 0x0C,
+	MAX77686_RTC_DATE			= 0x0D,
+	MAX77686_ALARM1_SEC			= 0x0E,
+	MAX77686_ALARM1_MIN			= 0x0F,
+	MAX77686_ALARM1_HOUR		= 0x10,
+	MAX77686_ALARM1_WEEKDAY		= 0x11,
+	MAX77686_ALARM1_MONTH		= 0x12,
+	MAX77686_ALARM1_YEAR		= 0x13,
+	MAX77686_ALARM1_DATE		= 0x14,
+	MAX77686_ALARM2_SEC			= 0x15,
+	MAX77686_ALARM2_MIN			= 0x16,
+	MAX77686_ALARM2_HOUR		= 0x17,
+	MAX77686_ALARM2_WEEKDAY		= 0x18,
+	MAX77686_ALARM2_MONTH		= 0x19,
+	MAX77686_ALARM2_YEAR		= 0x1A,
+	MAX77686_ALARM2_DATE		= 0x1B,
+};
+
+#define MAX77686_IRQSRC_PMIC	(0)
+#define MAX77686_IRQSRC_RTC		(1 << 0)
+
+enum max77686_irq_source {
+	PMIC_INT1 = 0,
+	PMIC_INT2,
+	RTC_INT,
+
+	MAX77686_IRQ_GROUP_NR,
+};
+
+enum max77686_irq {
+	MAX77686_PMICIRQ_PWRONF,
+	MAX77686_PMICIRQ_PWRONR,
+	MAX77686_PMICIRQ_JIGONBF,
+	MAX77686_PMICIRQ_JIGONBR,
+	MAX77686_PMICIRQ_ACOKBF,
+	MAX77686_PMICIRQ_ACOKBR,
+	MAX77686_PMICIRQ_ONKEY1S,
+	MAX77686_PMICIRQ_MRSTB,
+
+	MAX77686_PMICIRQ_140C,
+	MAX77686_PMICIRQ_120C,
+
+	MAX77686_RTCIRQ_RTC60S,
+	MAX77686_RTCIRQ_RTCA1,
+	MAX77686_RTCIRQ_RTCA2,
+	MAX77686_RTCIRQ_SMPL,
+	MAX77686_RTCIRQ_RTC1S,
+	MAX77686_RTCIRQ_WTSR,
+
+	MAX77686_IRQ_NR,
+};
+
+struct max77686_dev {
+	struct device *dev;
+	struct i2c_client *i2c; /* 0xcc / PMIC, Battery Control, and FLASH */
+	struct i2c_client *rtc; /* slave addr 0x0c */
+	struct mutex iolock;
+
+	int type;
+
+	struct regmap *regmap;		/* regmap for mfd */
+	struct regmap *rtc_regmap;	/* regmap for rtc */
+
+	struct irq_domain *irq_domain;
+
+	int irq;
+	int irq_gpio;
+	bool wakeup;
+	struct mutex irqlock;
+	int irq_masks_cur[MAX77686_IRQ_GROUP_NR];
+	int irq_masks_cache[MAX77686_IRQ_GROUP_NR];
+};
+
+enum max77686_types {
+	TYPE_MAX77686,
+};
+
+extern int max77686_irq_init(struct max77686_dev *max77686);
+extern void max77686_irq_exit(struct max77686_dev *max77686);
+extern int max77686_irq_resume(struct max77686_dev *max77686);
+
+#endif /*  __LINUX_MFD_MAX77686_PRIV_H */
diff --git a/include/linux/mfd/max77686.h b/include/linux/mfd/max77686.h
new file mode 100644
index 0000000..fcf3126
--- /dev/null
+++ b/include/linux/mfd/max77686.h
@@ -0,0 +1,117 @@
+/*
+ * max77686.h - Driver for the Maxim 77686
+ *
+ *  Copyright (C) 2012 Samsung Electrnoics
+ *  Chiwoong Byun <woong.byun@samsung.com>
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
+ * This driver is based on max8997.h
+ *
+ * MAX77686 has PMIC, RTC devices.
+ * The devices share the same I2C bus and included in
+ * this mfd driver.
+ */
+
+#ifndef __LINUX_MFD_MAX77686_H
+#define __LINUX_MFD_MAX77686_H
+
+#include <linux/regulator/consumer.h>
+
+/* MAX77686 regulator IDs */
+enum max77686_regulators {
+	MAX77686_LDO1 = 0,
+	MAX77686_LDO2,
+	MAX77686_LDO3,
+	MAX77686_LDO4,
+	MAX77686_LDO5,
+	MAX77686_LDO6,
+	MAX77686_LDO7,
+	MAX77686_LDO8,
+	MAX77686_LDO9,
+	MAX77686_LDO10,
+	MAX77686_LDO11,
+	MAX77686_LDO12,
+	MAX77686_LDO13,
+	MAX77686_LDO14,
+	MAX77686_LDO15,
+	MAX77686_LDO16,
+	MAX77686_LDO17,
+	MAX77686_LDO18,
+	MAX77686_LDO19,
+	MAX77686_LDO20,
+	MAX77686_LDO21,
+	MAX77686_LDO22,
+	MAX77686_LDO23,
+	MAX77686_LDO24,
+	MAX77686_LDO25,
+	MAX77686_LDO26,
+	MAX77686_BUCK1,
+	MAX77686_BUCK2,
+	MAX77686_BUCK3,
+	MAX77686_BUCK4,
+	MAX77686_BUCK5,
+	MAX77686_BUCK6,
+	MAX77686_BUCK7,
+	MAX77686_BUCK8,
+	MAX77686_BUCK9,
+	MAX77686_EN32KHZ_AP,
+	MAX77686_EN32KHZ_CP,
+	MAX77686_P32KH,
+
+	MAX77686_REG_MAX,
+};
+
+struct max77686_regulator_data {
+	int id;
+	struct regulator_init_data *initdata;
+};
+
+enum max77686_opmode {
+	MAX77686_OPMODE_NORMAL,
+	MAX77686_OPMODE_LP,
+	MAX77686_OPMODE_STANDBY,
+};
+
+struct max77686_opmode_data {
+	int id;
+	int mode;
+};
+
+struct max77686_platform_data {
+	/* IRQ */
+	int irq_gpio;
+	int ono;
+	int wakeup;
+
+	/* ---- PMIC ---- */
+	struct max77686_regulator_data *regulators;
+	int num_regulators;
+
+	struct max77686_opmode_data *opmode_data;
+
+	/*
+	 * GPIO-DVS feature is not enabled with the current version of
+	 * MAX77686 driver. Buck2/3/4_voltages[0] is used as the default
+	 * voltage at probe. DVS/SELB gpios are set as OUTPUT-LOW.
+	 */
+	int buck234_gpio_dvs[3]; /* GPIO of [0]DVS1, [1]DVS2, [2]DVS3 */
+	int buck234_gpio_selb[3]; /* [0]SELB2, [1]SELB3, [2]SELB4 */
+	unsigned int buck2_voltage[8]; /* buckx_voltage in uV */
+	unsigned int buck3_voltage[8];
+	unsigned int buck4_voltage[8];
+};
+
+#endif /* __LINUX_MFD_MAX77686_H */
-- 
1.7.4.1

