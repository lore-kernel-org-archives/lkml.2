Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab1CPCCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:02:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34162 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1CPCCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:02:14 -0400
Date: Wed, 16 Mar 2011 10:39:10 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v6 1/2] MAX8997/8966 MFD: Add IRQ control feature
In-reply-to: <1300239551-21285-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>, Joe Perches <joe@perches.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Message-id: <1300239551-21285-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <1300239551-21285-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 16 Mar 2011 01:39:11.0945 (UTC)
 FILETIME=[F368FB90:01CBE37A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables IRQ handling for MAX8997/8966 chips.

Please note that Fuel-Gauge-related IRQs are not implemented in this
initial release. The fuel gauge module in MAX8997 is identical to
MAX17042, which is already in Linux kernel. In order to use the
already-existing MAX17042 driver for fuel gauge module in MAX8997, the
main interrupt handler of MAX8997 should relay related interrupts to
MAX17042 driver. However, in order to do this, we need to modify
MAX17042 driver as well because MAX17042 driver does not have any
interrupt handlers for now. We are not going to implement this in this
initial release as it is not crucial in basic operations of MAX8997.

The IRQ handling of MAX8997/8966 MFD relays IRQ handlers to
PMIC, MUIC, GPIO, and FLASH. Note that PMIC-IRQ handles RTC and Charger
related inetrrupts as well.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/Makefile                |    2 +-
 drivers/mfd/max8997-irq.c           |  377 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8997-private.h |   21 ++
 include/linux/mfd/max8997.h         |    7 +-
 4 files changed, 404 insertions(+), 3 deletions(-)
 create mode 100644 drivers/mfd/max8997-irq.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index f6662e3..4cff10c 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -60,7 +60,7 @@ obj-$(CONFIG_UCB1400_CORE)	+= ucb1400_core.o
 obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
 max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
-obj-$(CONFIG_MFD_MAX8997)	+= max8997.o
+obj-$(CONFIG_MFD_MAX8997)	+= max8997.o max8997-irq.o
 obj-$(CONFIG_MFD_MAX8998)	+= max8998.o max8998-irq.o
 
 pcf50633-objs			:= pcf50633-core.o pcf50633-irq.o
diff --git a/drivers/mfd/max8997-irq.c b/drivers/mfd/max8997-irq.c
new file mode 100644
index 0000000..c52f29f
--- /dev/null
+++ b/drivers/mfd/max8997-irq.c
@@ -0,0 +1,377 @@
+/*
+ * max8997-irq.c - Interrupt controller support for MAX8997
+ *
+ * Copyright (C) 2011 Samsung Electronics Co.Ltd
+ * MyungJoo Ham <myungjoo.ham@samsung.com>
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
+ * This driver is based on max8998-irq.c
+ */
+
+#include <linux/err.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/max8997.h>
+#include <linux/mfd/max8997-private.h>
+
+static const u8 max8997_mask_reg[] = {
+	[PMIC_INT1] = MAX8997_REG_INT1MSK,
+	[PMIC_INT2] = MAX8997_REG_INT2MSK,
+	[PMIC_INT3] = MAX8997_REG_INT3MSK,
+	[PMIC_INT4] = MAX8997_REG_INT4MSK,
+	[FUEL_GAUGE] = MAX8997_REG_INVALID,
+	[MUIC_INT1] = MAX8997_MUIC_REG_INTMASK1,
+	[MUIC_INT2] = MAX8997_MUIC_REG_INTMASK2,
+	[MUIC_INT3] = MAX8997_MUIC_REG_INTMASK3,
+	[GPIO_LOW] = MAX8997_REG_INVALID,
+	[GPIO_HI] = MAX8997_REG_INVALID,
+	[FLASH_STATUS] = MAX8997_REG_INVALID,
+};
+
+static struct i2c_client *get_i2c(struct max8997_dev *max8997,
+				enum max8997_irq_source src)
+{
+	switch (src) {
+	case PMIC_INT1 ... PMIC_INT4:
+		return max8997->i2c;
+	case FUEL_GAUGE:
+		return NULL;
+	case MUIC_INT1 ... MUIC_INT3:
+		return max8997->muic;
+	case GPIO_LOW ... GPIO_HI:
+		return max8997->i2c;
+	case FLASH_STATUS:
+		return max8997->i2c;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
+	return ERR_PTR(-EINVAL);
+}
+
+struct max8997_irq_data {
+	int mask;
+	enum max8997_irq_source group;
+};
+
+#define DECLARE_IRQ(idx, _group, _mask)		\
+	[(idx)] = { .group = (_group), .mask = (_mask) }
+static const struct max8997_irq_data max8997_irqs[] = {
+	DECLARE_IRQ(MAX8997_PMICIRQ_PWRONR,	PMIC_INT1, 1 << 0),
+	DECLARE_IRQ(MAX8997_PMICIRQ_PWRONF,	PMIC_INT1, 1 << 1),
+	DECLARE_IRQ(MAX8997_PMICIRQ_PWRON1SEC,	PMIC_INT1, 1 << 3),
+	DECLARE_IRQ(MAX8997_PMICIRQ_JIGONR,	PMIC_INT1, 1 << 4),
+	DECLARE_IRQ(MAX8997_PMICIRQ_JIGONF,	PMIC_INT1, 1 << 5),
+	DECLARE_IRQ(MAX8997_PMICIRQ_LOWBAT2,	PMIC_INT1, 1 << 6),
+	DECLARE_IRQ(MAX8997_PMICIRQ_LOWBAT1,	PMIC_INT1, 1 << 7),
+
+	DECLARE_IRQ(MAX8997_PMICIRQ_JIGR,	PMIC_INT2, 1 << 0),
+	DECLARE_IRQ(MAX8997_PMICIRQ_JIGF,	PMIC_INT2, 1 << 1),
+	DECLARE_IRQ(MAX8997_PMICIRQ_MR,		PMIC_INT2, 1 << 2),
+	DECLARE_IRQ(MAX8997_PMICIRQ_DVS1OK,	PMIC_INT2, 1 << 3),
+	DECLARE_IRQ(MAX8997_PMICIRQ_DVS2OK,	PMIC_INT2, 1 << 4),
+	DECLARE_IRQ(MAX8997_PMICIRQ_DVS3OK,	PMIC_INT2, 1 << 5),
+	DECLARE_IRQ(MAX8997_PMICIRQ_DVS4OK,	PMIC_INT2, 1 << 6),
+
+	DECLARE_IRQ(MAX8997_PMICIRQ_CHGINS,	PMIC_INT3, 1 << 0),
+	DECLARE_IRQ(MAX8997_PMICIRQ_CHGRM,	PMIC_INT3, 1 << 1),
+	DECLARE_IRQ(MAX8997_PMICIRQ_DCINOVP,	PMIC_INT3, 1 << 2),
+	DECLARE_IRQ(MAX8997_PMICIRQ_TOPOFFR,	PMIC_INT3, 1 << 3),
+	DECLARE_IRQ(MAX8997_PMICIRQ_CHGRSTF,	PMIC_INT3, 1 << 5),
+	DECLARE_IRQ(MAX8997_PMICIRQ_MBCHGTMEXPD,	PMIC_INT3, 1 << 7),
+
+	DECLARE_IRQ(MAX8997_PMICIRQ_RTC60S,	PMIC_INT4, 1 << 0),
+	DECLARE_IRQ(MAX8997_PMICIRQ_RTCA1,	PMIC_INT4, 1 << 1),
+	DECLARE_IRQ(MAX8997_PMICIRQ_RTCA2,	PMIC_INT4, 1 << 2),
+	DECLARE_IRQ(MAX8997_PMICIRQ_SMPL_INT,	PMIC_INT4, 1 << 3),
+	DECLARE_IRQ(MAX8997_PMICIRQ_RTC1S,	PMIC_INT4, 1 << 4),
+	DECLARE_IRQ(MAX8997_PMICIRQ_WTSR,	PMIC_INT4, 1 << 5),
+
+	DECLARE_IRQ(MAX8997_MUICIRQ_ADCError,	MUIC_INT1, 1 << 2),
+	DECLARE_IRQ(MAX8997_MUICIRQ_ADCLow,	MUIC_INT1, 1 << 1),
+	DECLARE_IRQ(MAX8997_MUICIRQ_ADC,	MUIC_INT1, 1 << 0),
+
+	DECLARE_IRQ(MAX8997_MUICIRQ_VBVolt,	MUIC_INT2, 1 << 4),
+	DECLARE_IRQ(MAX8997_MUICIRQ_DBChg,	MUIC_INT2, 1 << 3),
+	DECLARE_IRQ(MAX8997_MUICIRQ_DCDTmr,	MUIC_INT2, 1 << 2),
+	DECLARE_IRQ(MAX8997_MUICIRQ_ChgDetRun,	MUIC_INT2, 1 << 1),
+	DECLARE_IRQ(MAX8997_MUICIRQ_ChgTyp,	MUIC_INT2, 1 << 0),
+
+	DECLARE_IRQ(MAX8997_MUICIRQ_OVP,	MUIC_INT3, 1 << 2),
+};
+
+static const inline struct max8997_irq_data *
+irq_to_max8997_irq(struct max8997_dev *max8997, int irq)
+{
+	return &max8997_irqs[irq - max8997->irq_base];
+}
+
+static void max8997_irq_lock(unsigned int irq)
+{
+	struct max8997_dev *max8997 = get_irq_chip_data(irq);
+
+	mutex_lock(&max8997->irqlock);
+}
+
+static void max8997_irq_sync_unlock(unsigned int irq)
+{
+	struct max8997_dev *max8997 = get_irq_chip_data(irq);
+	int i;
+
+	for (i = 0; i < MAX8997_IRQ_GROUP_NR; i++) {
+		u8 mask_reg = max8997_mask_reg[i];
+		struct i2c_client *i2c = get_i2c(max8997, i);
+
+		if (mask_reg == MAX8997_REG_INVALID ||
+				IS_ERR_OR_NULL(i2c))
+			continue;
+		max8997->irq_masks_cache[i] = max8997->irq_masks_cur[i];
+
+		max8997_write_reg(i2c, max8997_mask_reg[i],
+				max8997->irq_masks_cur[i]);
+	}
+
+	mutex_unlock(&max8997->irqlock);
+}
+
+static void max8997_irq_mask(unsigned int irq)
+{
+	struct max8997_dev *max8997 = get_irq_chip_data(irq);
+	const struct max8997_irq_data *irq_data = irq_to_max8997_irq(max8997,
+									irq);
+
+	max8997->irq_masks_cur[irq_data->group] |= irq_data->mask;
+}
+
+static void max8997_irq_unmask(unsigned int irq)
+{
+	struct max8997_dev *max8997 = get_irq_chip_data(irq);
+	const struct max8997_irq_data *irq_data = irq_to_max8997_irq(max8997,
+									irq);
+
+	max8997->irq_masks_cur[irq_data->group] &= ~irq_data->mask;
+}
+
+static struct irq_chip max8997_irq_chip = {
+	.name			= "max8997",
+	.bus_lock		= max8997_irq_lock,
+	.bus_sync_unlock	= max8997_irq_sync_unlock,
+	.mask			= max8997_irq_mask,
+	.unmask			= max8997_irq_unmask,
+};
+
+#define MAX8997_IRQSRC_PMIC		(1 << 1)
+#define MAX8997_IRQSRC_FUELGAUGE	(1 << 2)
+#define MAX8997_IRQSRC_MUIC		(1 << 3)
+#define MAX8997_IRQSRC_GPIO		(1 << 4)
+#define MAX8997_IRQSRC_FLASH		(1 << 5)
+static irqreturn_t max8997_irq_thread(int irq, void *data)
+{
+	struct max8997_dev *max8997 = data;
+	u8 irq_reg[MAX8997_IRQ_GROUP_NR] = {};
+	u8 irq_src;
+	int ret;
+	int i;
+
+	ret = max8997_read_reg(max8997->i2c, MAX8997_REG_INTSRC, &irq_src);
+	if (ret < 0) {
+		dev_err(max8997->dev, "Failed to read interrupt source: %d\n",
+				ret);
+		return IRQ_NONE;
+	}
+
+	if (irq_src & MAX8997_IRQSRC_PMIC) {
+		/* PMIC INT1 ~ INT4 */
+		max8997_bulk_read(max8997->i2c, MAX8997_REG_INT1, 4,
+				&irq_reg[PMIC_INT1]);
+	}
+	if (irq_src & MAX8997_IRQSRC_FUELGAUGE) {
+		/*
+		 * TODO: FUEL GAUGE
+		 *
+		 * This is to be supported by Max17042 driver. When
+		 * an interrupt incurs here, it should be relayed to a
+		 * Max17042 device that is connected (probably by
+		 * platform-data). However, we do not have interrupt
+		 * handling in Max17042 driver currently. The Max17042 IRQ
+		 * driver should be ready to be used as a stand-alone device and
+		 * a Max8997-dependent device. Because it is not ready in
+		 * Max17042-side and it is not too critical in operating
+		 * Max8997, we do not implement this in initial releases.
+		 */
+		irq_reg[FUEL_GAUGE] = 0;
+	}
+	if (irq_src & MAX8997_IRQSRC_MUIC) {
+		/* MUIC INT1 ~ INT3 */
+		max8997_bulk_read(max8997->muic, MAX8997_MUIC_REG_INT1, 3,
+				&irq_reg[MUIC_INT1]);
+	}
+	if (irq_src & MAX8997_IRQSRC_GPIO) {
+		/* GPIO Interrupt */
+		u8 gpio_info[MAX8997_NUM_GPIO];
+
+		irq_reg[GPIO_LOW] = 0;
+		irq_reg[GPIO_HI] = 0;
+
+		max8997_bulk_read(max8997->i2c, MAX8997_REG_GPIOCNTL1,
+				MAX8997_NUM_GPIO, gpio_info);
+		for (i = 0; i < MAX8997_NUM_GPIO; i++) {
+			bool interrupt = false;
+
+			switch (gpio_info[i] & MAX8997_GPIO_INT_MASK) {
+			case MAX8997_GPIO_INT_BOTH:
+				if (max8997->gpio_status[i] != gpio_info[i])
+					interrupt = true;
+				break;
+			case MAX8997_GPIO_INT_RISE:
+				if ((max8997->gpio_status[i] != gpio_info[i]) &&
+				    (gpio_info[i] & MAX8997_GPIO_DATA_MASK))
+					interrupt = true;
+				break;
+			case MAX8997_GPIO_INT_FALL:
+				if ((max8997->gpio_status[i] != gpio_info[i]) &&
+				    !(gpio_info[i] & MAX8997_GPIO_DATA_MASK))
+					interrupt = true;
+				break;
+			default:
+				break;
+			}
+
+			if (interrupt) {
+				if (i < 8)
+					irq_reg[GPIO_LOW] |= (1 << i);
+				else
+					irq_reg[GPIO_HI] |= (1 << (i - 8));
+			}
+
+		}
+	}
+	if (irq_src & MAX8997_IRQSRC_FLASH) {
+		/* Flash Status Interrupt */
+		ret = max8997_read_reg(max8997->i2c, MAX8997_REG_FLASHSTATUS,
+				&irq_reg[FLASH_STATUS]);
+	}
+
+	/* Apply masking */
+	for (i = 0; i < MAX8997_IRQ_GROUP_NR; i++)
+		irq_reg[i] &= ~max8997->irq_masks_cur[i];
+
+	/* Report */
+	for (i = 0; i < MAX8997_IRQ_NR; i++) {
+		if (irq_reg[max8997_irqs[i].group] & max8997_irqs[i].mask)
+			handle_nested_irq(max8997->irq_base + i);
+	}
+
+	return IRQ_HANDLED;
+}
+
+int max8997_irq_resume(struct max8997_dev *max8997)
+{
+	if (max8997->irq && max8997->irq_base)
+		max8997_irq_thread(max8997->irq_base, max8997);
+	return 0;
+}
+
+int max8997_irq_init(struct max8997_dev *max8997)
+{
+	int i;
+	int cur_irq;
+	int ret;
+	u8 val;
+
+	if (!max8997->irq) {
+		dev_warn(max8997->dev, "No interrupt specified.\n");
+		max8997->irq_base = 0;
+		return 0;
+	}
+
+	if (!max8997->irq_base) {
+		dev_err(max8997->dev, "No interrupt base specified.\n");
+		return 0;
+	}
+
+	mutex_init(&max8997->irqlock);
+
+	/* Mask individual interrupt sources */
+	for (i = 0; i < MAX8997_IRQ_GROUP_NR; i++) {
+		struct i2c_client *i2c;
+
+		max8997->irq_masks_cur[i] = 0xff;
+		max8997->irq_masks_cache[i] = 0xff;
+		i2c = get_i2c(max8997, i);
+
+		if (IS_ERR_OR_NULL(i2c))
+			continue;
+		if (max8997_mask_reg[i] == MAX8997_REG_INVALID)
+			continue;
+
+		max8997_write_reg(i2c, max8997_mask_reg[i], 0xff);
+	}
+
+	for (i = 0; i < MAX8997_NUM_GPIO; i++) {
+		max8997->gpio_status[i] = (max8997_read_reg(max8997->i2c,
+						MAX8997_REG_GPIOCNTL1 + i,
+						&val)
+					& MAX8997_GPIO_DATA_MASK) ?
+					true : false;
+	}
+
+	/* Register with genirq */
+	for (i = 0; i < MAX8997_IRQ_NR; i++) {
+		cur_irq = i + max8997->irq_base;
+		set_irq_chip_data(cur_irq, max8997);
+		set_irq_chip_and_handler(cur_irq, &max8997_irq_chip,
+				handle_edge_irq);
+		set_irq_nested_thread(cur_irq, 1);
+#ifdef CONFIG_ARM
+		set_irq_flags(cur_irq, IRQF_VALID);
+#else
+		set_irq_noprobe(cur_irq);
+#endif
+	}
+
+	ret = request_threaded_irq(max8997->irq, NULL, max8997_irq_thread,
+			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+			"max8997-irq", max8997);
+
+	if (ret) {
+		dev_err(max8997->dev, "Failed to request IRQ %d: %d\n",
+				max8997->irq, ret);
+		return ret;
+	}
+
+	if (!max8997->ono)
+		return 0;
+
+	ret = request_threaded_irq(max8997->ono, NULL, max8997_irq_thread,
+			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING |
+			IRQF_ONESHOT, "max8997-ono", max8997);
+
+	if (ret)
+		dev_err(max8997->dev, "Failed to request ono-IRQ %d: %d\n",
+				max8997->ono, ret);
+
+	return 0;
+}
+
+void max8997_irq_exit(struct max8997_dev *max8997)
+{
+	if (max8997->ono)
+		free_irq(max8997->ono, max8997);
+
+	if (max8997->irq)
+		free_irq(max8997->irq, max8997);
+}
diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
index 93a9477..69d1010 100644
--- a/include/linux/mfd/max8997-private.h
+++ b/include/linux/mfd/max8997-private.h
@@ -24,6 +24,8 @@
 
 #include <linux/i2c.h>
 
+#define MAX8997_REG_INVALID	(0xff)
+
 enum max8997_pmic_reg {
 	MAX8997_REG_PMIC_ID0	= 0x00,
 	MAX8997_REG_PMIC_ID1	= 0x01,
@@ -313,6 +315,7 @@ enum max8997_irq {
 #define MAX8997_REG_BUCK2DVS(x)	(MAX8997_REG_BUCK2DVS1 + (x) - 1)
 #define MAX8997_REG_BUCK5DVS(x)	(MAX8997_REG_BUCK5DVS1 + (x) - 1)
 
+#define MAX8997_NUM_GPIO	12
 struct max8997_dev {
 	struct device *dev;
 	struct i2c_client *i2c; /* 0xcc / PMIC, Battery Control, and FLASH */
@@ -324,11 +327,19 @@ struct max8997_dev {
 	int type;
 	struct platform_device *battery; /* battery control (not fuel gauge) */
 
+	int irq;
+	int ono;
+	int irq_base;
 	bool wakeup;
+	struct mutex irqlock;
+	int irq_masks_cur[MAX8997_IRQ_GROUP_NR];
+	int irq_masks_cache[MAX8997_IRQ_GROUP_NR];
 
 	/* For hibernation */
 	u8 reg_dump[MAX8997_REG_PMIC_END + MAX8997_MUIC_REG_END +
 		MAX8997_HAPTIC_REG_END];
+
+	bool gpio_status[MAX8997_NUM_GPIO];
 };
 
 enum max8997_types {
@@ -336,6 +347,10 @@ enum max8997_types {
 	TYPE_MAX8966,
 };
 
+extern int max8997_irq_init(struct max8997_dev *max8997);
+extern void max8997_irq_exit(struct max8997_dev *max8997);
+extern int max8997_irq_resume(struct max8997_dev *max8997);
+
 extern int max8997_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest);
 extern int max8997_bulk_read(struct i2c_client *i2c, u8 reg, int count,
 				u8 *buf);
@@ -344,4 +359,10 @@ extern int max8997_bulk_write(struct i2c_client *i2c, u8 reg, int count,
 				u8 *buf);
 extern int max8997_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask);
 
+#define MAX8997_GPIO_INT_BOTH	(0x3 << 4)
+#define MAX8997_GPIO_INT_RISE	(0x2 << 4)
+#define MAX8997_GPIO_INT_FALL	(0x1 << 4)
+
+#define MAX8997_GPIO_INT_MASK	(0x3 << 4)
+#define MAX8997_GPIO_DATA_MASK	(0x1 << 2)
 #endif /*  __LINUX_MFD_MAX8997_PRIV_H */
diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
index cb671b3..60931d0 100644
--- a/include/linux/mfd/max8997.h
+++ b/include/linux/mfd/max8997.h
@@ -78,8 +78,11 @@ struct max8997_regulator_data {
 };
 
 struct max8997_platform_data {
-	bool wakeup;
-	/* IRQ: Not implemented */
+	/* IRQ */
+	int irq_base;
+	int ono;
+	int wakeup;
+
 	/* ---- PMIC ---- */
 	struct max8997_regulator_data *regulators;
 	int num_regulators;
-- 
1.7.1

