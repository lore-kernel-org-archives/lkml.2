Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935324Ab0HFC2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 22:28:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64678 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935273Ab0HFC2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 22:28:24 -0400
Date: Fri, 06 Aug 2010 11:28:07 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH v3 2/3] mfd: MAX8998: Add interrupts support
In-reply-to: <1281061688-856-1-git-send-email-jy0922.shim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, akpm@linux-foundation.org, a.zummo@towertech.it,
        p_gortmaker@yahoo.com, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com
Message-id: <1281061688-856-2-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.7.0.4
Content-transfer-encoding: 7BIT
References: <1281061688-856-1-git-send-email-jy0922.shim@samsung.com>
X-OriginalArrivalTime: 06 Aug 2010 02:28:21.0240 (UTC)
 FILETIME=[099F2F80:01CB350F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use genirq and provide seperated file for interrupts support.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/Kconfig                 |    2 +-
 drivers/mfd/Makefile                |    2 +-
 drivers/mfd/max8998-irq.c           |  255 +++++++++++++++++++++++++++++++++++
 drivers/mfd/max8998.c               |   25 ++++-
 include/linux/mfd/max8998-private.h |   72 ++++++++++-
 include/linux/mfd/max8998.h         |   11 +-
 6 files changed, 358 insertions(+), 9 deletions(-)
 create mode 100644 drivers/mfd/max8998-irq.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ad61a9e..ee2d1a7 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -254,7 +254,7 @@ config MFD_MAX8925
 
 config MFD_MAX8998
 	bool "Maxim Semiconductor MAX8998 PMIC Support"
-	depends on I2C=y
+	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	help
 	  Say yes here to support for Maxim Semiconductor MAX8998. This is
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index a362ccf..565e021 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -56,7 +56,7 @@ obj-$(CONFIG_UCB1400_CORE)	+= ucb1400_core.o
 obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
 max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
-obj-$(CONFIG_MFD_MAX8998)	+= max8998.o
+obj-$(CONFIG_MFD_MAX8998)	+= max8998.o max8998-irq.o
 
 pcf50633-objs			:= pcf50633-core.o pcf50633-irq.o
 obj-$(CONFIG_MFD_PCF50633)	+= pcf50633.o
diff --git a/drivers/mfd/max8998-irq.c b/drivers/mfd/max8998-irq.c
new file mode 100644
index 0000000..346fd29
--- /dev/null
+++ b/drivers/mfd/max8998-irq.c
@@ -0,0 +1,255 @@
+/*
+ * Interrupt controller support for MAX8998
+ *
+ * Copyright (C) 2010 Samsung Electronics Co.Ltd
+ * Author: Joonyoung Shim <jy0922.shim@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/mfd/max8998-private.h>
+
+struct max8998_irq_data {
+	int reg;
+	int mask;
+};
+
+static struct max8998_irq_data max8998_irqs[] = {
+	[MAX8998_IRQ_DCINF] = {
+		.reg = 1,
+		.mask = MAX8998_IRQ_DCINF_MASK,
+	},
+	[MAX8998_IRQ_DCINR] = {
+		.reg = 1,
+		.mask = MAX8998_IRQ_DCINR_MASK,
+	},
+	[MAX8998_IRQ_JIGF] = {
+		.reg = 1,
+		.mask = MAX8998_IRQ_JIGF_MASK,
+	},
+	[MAX8998_IRQ_JIGR] = {
+		.reg = 1,
+		.mask = MAX8998_IRQ_JIGR_MASK,
+	},
+	[MAX8998_IRQ_PWRONF] = {
+		.reg = 1,
+		.mask = MAX8998_IRQ_PWRONF_MASK,
+	},
+	[MAX8998_IRQ_PWRONR] = {
+		.reg = 1,
+		.mask = MAX8998_IRQ_PWRONR_MASK,
+	},
+	[MAX8998_IRQ_WTSREVNT] = {
+		.reg = 2,
+		.mask = MAX8998_IRQ_WTSREVNT_MASK,
+	},
+	[MAX8998_IRQ_SMPLEVNT] = {
+		.reg = 2,
+		.mask = MAX8998_IRQ_SMPLEVNT_MASK,
+	},
+	[MAX8998_IRQ_ALARM1] = {
+		.reg = 2,
+		.mask = MAX8998_IRQ_ALARM1_MASK,
+	},
+	[MAX8998_IRQ_ALARM0] = {
+		.reg = 2,
+		.mask = MAX8998_IRQ_ALARM0_MASK,
+	},
+	[MAX8998_IRQ_ONKEY1S] = {
+		.reg = 3,
+		.mask = MAX8998_IRQ_ONKEY1S_MASK,
+	},
+	[MAX8998_IRQ_TOPOFFR] = {
+		.reg = 3,
+		.mask = MAX8998_IRQ_TOPOFFR_MASK,
+	},
+	[MAX8998_IRQ_DCINOVPR] = {
+		.reg = 3,
+		.mask = MAX8998_IRQ_DCINOVPR_MASK,
+	},
+	[MAX8998_IRQ_CHGRSTF] = {
+		.reg = 3,
+		.mask = MAX8998_IRQ_CHGRSTF_MASK,
+	},
+	[MAX8998_IRQ_DONER] = {
+		.reg = 3,
+		.mask = MAX8998_IRQ_DONER_MASK,
+	},
+	[MAX8998_IRQ_CHGFAULT] = {
+		.reg = 3,
+		.mask = MAX8998_IRQ_CHGFAULT_MASK,
+	},
+	[MAX8998_IRQ_LOBAT1] = {
+		.reg = 4,
+		.mask = MAX8998_IRQ_LOBAT1_MASK,
+	},
+	[MAX8998_IRQ_LOBAT2] = {
+		.reg = 4,
+		.mask = MAX8998_IRQ_LOBAT2_MASK,
+	},
+};
+
+static inline struct max8998_irq_data *
+irq_to_max8998_irq(struct max8998_dev *max8998, int irq)
+{
+	return &max8998_irqs[irq - max8998->irq_base];
+}
+
+static void max8998_irq_lock(unsigned int irq)
+{
+	struct max8998_dev *max8998 = get_irq_chip_data(irq);
+
+	mutex_lock(&max8998->irqlock);
+}
+
+static void max8998_irq_sync_unlock(unsigned int irq)
+{
+	struct max8998_dev *max8998 = get_irq_chip_data(irq);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(max8998->irq_masks_cur); i++) {
+		/*
+		 * If there's been a change in the mask write it back
+		 * to the hardware.
+		 */
+		if (max8998->irq_masks_cur[i] != max8998->irq_masks_cache[i]) {
+			max8998->irq_masks_cache[i] = max8998->irq_masks_cur[i];
+			max8998_write_reg(max8998->i2c, MAX8998_REG_IRQM1 + i,
+					max8998->irq_masks_cur[i]);
+		}
+	}
+
+	mutex_unlock(&max8998->irqlock);
+}
+
+static void max8998_irq_unmask(unsigned int irq)
+{
+	struct max8998_dev *max8998 = get_irq_chip_data(irq);
+	struct max8998_irq_data *irq_data = irq_to_max8998_irq(max8998, irq);
+
+	max8998->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
+}
+
+static void max8998_irq_mask(unsigned int irq)
+{
+	struct max8998_dev *max8998 = get_irq_chip_data(irq);
+	struct max8998_irq_data *irq_data = irq_to_max8998_irq(max8998, irq);
+
+	max8998->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
+}
+
+static struct irq_chip max8998_irq_chip = {
+	.name = "max8998",
+	.bus_lock = max8998_irq_lock,
+	.bus_sync_unlock = max8998_irq_sync_unlock,
+	.mask = max8998_irq_mask,
+	.unmask = max8998_irq_unmask,
+};
+
+static irqreturn_t max8998_irq_thread(int irq, void *data)
+{
+	struct max8998_dev *max8998 = data;
+	u8 irq_reg[MAX8998_NUM_IRQ_REGS];
+	int ret;
+	int i;
+
+	ret = max8998_bulk_read(max8998->i2c, MAX8998_REG_IRQ1,
+			MAX8998_NUM_IRQ_REGS, irq_reg);
+	if (ret < 0) {
+		dev_err(max8998->dev, "Failed to read interrupt register: %d\n",
+				ret);
+		return IRQ_NONE;
+	}
+
+	/* Apply masking */
+	for (i = 0; i < MAX8998_NUM_IRQ_REGS; i++)
+		irq_reg[i] &= ~max8998->irq_masks_cur[i];
+
+	/* Report */
+	for (i = 0; i < MAX8998_IRQ_NR; i++) {
+		if (irq_reg[max8998_irqs[i].reg - 1] & max8998_irqs[i].mask)
+			handle_nested_irq(max8998->irq_base + i);
+	}
+
+	return IRQ_HANDLED;
+}
+
+int max8998_irq_init(struct max8998_dev *max8998)
+{
+	int i;
+	int cur_irq;
+	int ret;
+
+	if (!max8998->irq) {
+		dev_warn(max8998->dev,
+			 "No interrupt specified, no interrupts\n");
+		max8998->irq_base = 0;
+		return 0;
+	}
+
+	if (!max8998->irq_base) {
+		dev_err(max8998->dev,
+			"No interrupt base specified, no interrupts\n");
+		return 0;
+	}
+
+	mutex_init(&max8998->irqlock);
+
+	/* Mask the individual interrupt sources */
+	for (i = 0; i < MAX8998_NUM_IRQ_REGS; i++) {
+		max8998->irq_masks_cur[i] = 0xff;
+		max8998->irq_masks_cache[i] = 0xff;
+		max8998_write_reg(max8998->i2c, MAX8998_REG_IRQM1 + i, 0xff);
+	}
+
+	max8998_write_reg(max8998->i2c, MAX8998_REG_STATUSM1, 0xff);
+	max8998_write_reg(max8998->i2c, MAX8998_REG_STATUSM2, 0xff);
+
+	/* register with genirq */
+	for (i = 0; i < MAX8998_IRQ_NR; i++) {
+		cur_irq = i + max8998->irq_base;
+		set_irq_chip_data(cur_irq, max8998);
+		set_irq_chip_and_handler(cur_irq, &max8998_irq_chip,
+					 handle_edge_irq);
+		set_irq_nested_thread(cur_irq, 1);
+#ifdef CONFIG_ARM
+		set_irq_flags(cur_irq, IRQF_VALID);
+#else
+		set_irq_noprobe(cur_irq);
+#endif
+	}
+
+	ret = request_threaded_irq(max8998->irq, NULL, max8998_irq_thread,
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   "max8998-irq", max8998);
+	if (ret) {
+		dev_err(max8998->dev, "Failed to request IRQ %d: %d\n",
+			max8998->irq, ret);
+		return ret;
+	}
+
+	if (!max8998->ono)
+		return 0;
+
+	ret = request_threaded_irq(max8998->ono, NULL, max8998_irq_thread,
+				   IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING |
+				   IRQF_ONESHOT, "max8998-ono", max8998);
+	if (ret)
+		dev_err(max8998->dev, "Failed to request IRQ %d: %d\n",
+			max8998->ono, ret);
+
+	return 0;
+}
+
+void max8998_irq_exit(struct max8998_dev *max8998)
+{
+	if (max8998->irq)
+		free_irq(max8998->irq, max8998);
+}
diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index 183964e..7e4489f 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -1,5 +1,5 @@
 /*
- * max8698.c - mfd core driver for the Maxim 8998
+ * max8998.c - mfd core driver for the Maxim 8998
  *
  *  Copyright (C) 2009-2010 Samsung Electronics
  *  Kyungmin Park <kyungmin.park@samsung.com>
@@ -53,6 +53,21 @@ int max8998_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
 }
 EXPORT_SYMBOL(max8998_read_reg);
 
+int max8998_bulk_read(struct i2c_client *i2c, u8 reg, int count, u8 *buf)
+{
+	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
+	int ret;
+
+	mutex_lock(&max8998->iolock);
+	ret = i2c_smbus_read_i2c_block_data(i2c, reg, count, buf);
+	mutex_unlock(&max8998->iolock);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL(max8998_bulk_read);
+
 int max8998_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
 {
 	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
@@ -87,6 +102,7 @@ EXPORT_SYMBOL(max8998_update_reg);
 static int max8998_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
+	struct max8998_platform_data *pdata = i2c->dev.platform_data;
 	struct max8998_dev *max8998;
 	int ret = 0;
 
@@ -99,8 +115,15 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 	i2c_set_clientdata(i2c, max8998);
 	max8998->dev = &i2c->dev;
 	max8998->i2c = i2c;
+	max8998->irq = i2c->irq;
+	if (pdata) {
+		max8998->ono = pdata->ono;
+		max8998->irq_base = pdata->irq_base;
+	}
 	mutex_init(&max8998->iolock);
 
+	max8998_irq_init(max8998);
+
 	ret = mfd_add_devices(max8998->dev, -1,
 			      max8998_devs, ARRAY_SIZE(max8998_devs),
 			      NULL, 0);
diff --git a/include/linux/mfd/max8998-private.h b/include/linux/mfd/max8998-private.h
index f0a20cd..3bd2371 100644
--- a/include/linux/mfd/max8998-private.h
+++ b/include/linux/mfd/max8998-private.h
@@ -1,5 +1,5 @@
 /*
- * max8698.h - Voltage regulator driver for the Maxim 8998
+ * max8998.h - Voltage regulator driver for the Maxim 8998
  *
  *  Copyright (C) 2009-2010 Samsung Electrnoics
  *  Kyungmin Park <kyungmin.park@samsung.com>
@@ -23,6 +23,8 @@
 #ifndef __LINUX_MFD_MAX8998_PRIV_H
 #define __LINUX_MFD_MAX8998_PRIV_H
 
+#define MAX8998_NUM_IRQ_REGS	4
+
 /* MAX 8998 registers */
 enum {
 	MAX8998_REG_IRQ1,
@@ -72,20 +74,86 @@ enum {
 	MAX8998_REG_LBCNFG2,
 };
 
+/* IRQ definitions */
+enum {
+	MAX8998_IRQ_DCINF,
+	MAX8998_IRQ_DCINR,
+	MAX8998_IRQ_JIGF,
+	MAX8998_IRQ_JIGR,
+	MAX8998_IRQ_PWRONF,
+	MAX8998_IRQ_PWRONR,
+
+	MAX8998_IRQ_WTSREVNT,
+	MAX8998_IRQ_SMPLEVNT,
+	MAX8998_IRQ_ALARM1,
+	MAX8998_IRQ_ALARM0,
+
+	MAX8998_IRQ_ONKEY1S,
+	MAX8998_IRQ_TOPOFFR,
+	MAX8998_IRQ_DCINOVPR,
+	MAX8998_IRQ_CHGRSTF,
+	MAX8998_IRQ_DONER,
+	MAX8998_IRQ_CHGFAULT,
+
+	MAX8998_IRQ_LOBAT1,
+	MAX8998_IRQ_LOBAT2,
+
+	MAX8998_IRQ_NR,
+};
+
+#define MAX8998_IRQ_DCINF_MASK		(1 << 2)
+#define MAX8998_IRQ_DCINR_MASK		(1 << 3)
+#define MAX8998_IRQ_JIGF_MASK		(1 << 4)
+#define MAX8998_IRQ_JIGR_MASK		(1 << 5)
+#define MAX8998_IRQ_PWRONF_MASK		(1 << 6)
+#define MAX8998_IRQ_PWRONR_MASK		(1 << 7)
+
+#define MAX8998_IRQ_WTSREVNT_MASK	(1 << 0)
+#define MAX8998_IRQ_SMPLEVNT_MASK	(1 << 1)
+#define MAX8998_IRQ_ALARM1_MASK		(1 << 2)
+#define MAX8998_IRQ_ALARM0_MASK		(1 << 3)
+
+#define MAX8998_IRQ_ONKEY1S_MASK	(1 << 0)
+#define MAX8998_IRQ_TOPOFFR_MASK	(1 << 2)
+#define MAX8998_IRQ_DCINOVPR_MASK	(1 << 3)
+#define MAX8998_IRQ_CHGRSTF_MASK	(1 << 4)
+#define MAX8998_IRQ_DONER_MASK		(1 << 5)
+#define MAX8998_IRQ_CHGFAULT_MASK	(1 << 7)
+
+#define MAX8998_IRQ_LOBAT1_MASK		(1 << 0)
+#define MAX8998_IRQ_LOBAT2_MASK		(1 << 1)
+
 /**
  * struct max8998_dev - max8998 master device for sub-drivers
  * @dev: master device of the chip (can be used to access platform data)
  * @i2c: i2c client private data
  * @iolock: mutex for serializing io access
+ * @irqlock: mutex for buslock
+ * @irq_base: base IRQ number for max8998, required for IRQs
+ * @irq: generic IRQ number for max8998
+ * @ono: power onoff IRQ number for max8998
+ * @irq_masks_cur: currently active value
+ * @irq_masks_cache: cached hardware value
  */
-
 struct max8998_dev {
 	struct device *dev;
 	struct i2c_client *i2c;
 	struct mutex iolock;
+	struct mutex irqlock;
+
+	int irq_base;
+	int irq;
+	int ono;
+	u8 irq_masks_cur[MAX8998_NUM_IRQ_REGS];
+	u8 irq_masks_cache[MAX8998_NUM_IRQ_REGS];
 };
 
+int max8998_irq_init(struct max8998_dev *max8998);
+void max8998_irq_exit(struct max8998_dev *max8998);
+
 extern int max8998_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest);
+extern int max8998_bulk_read(struct i2c_client *i2c, u8 reg, int count,
+		u8 *buf);
 extern int max8998_write_reg(struct i2c_client *i2c, u8 reg, u8 value);
 extern int max8998_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask);
 
diff --git a/include/linux/mfd/max8998.h b/include/linux/mfd/max8998.h
index 1d3601a..d47ed4c 100644
--- a/include/linux/mfd/max8998.h
+++ b/include/linux/mfd/max8998.h
@@ -1,5 +1,5 @@
 /*
- * max8698.h - Voltage regulator driver for the Maxim 8998
+ * max8998.h - Voltage regulator driver for the Maxim 8998
  *
  *  Copyright (C) 2009-2010 Samsung Electrnoics
  *  Kyungmin Park <kyungmin.park@samsung.com>
@@ -66,13 +66,16 @@ struct max8998_regulator_data {
 
 /**
  * struct max8998_board - packages regulator init data
- * @num_regulators: number of regultors used
  * @regulators: array of defined regulators
+ * @num_regulators: number of regultors used
+ * @irq_base: base IRQ number for max8998, required for IRQs
+ * @ono: power onoff IRQ number for max8998
  */
-
 struct max8998_platform_data {
-	int				num_regulators;
 	struct max8998_regulator_data	*regulators;
+	int				num_regulators;
+	int				irq_base;
+	int				ono;
 };
 
 #endif /*  __LINUX_MFD_MAX8998_H */
-- 
1.7.0.4

