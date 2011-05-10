Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab1EJUfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 16:35:07 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:33816 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab1EJUen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 16:34:43 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 May 2011 16:34:43 EDT
MIME-Version: 1.0
Date: Tue, 10 May 2011 15:25:59 -0500
Message-ID: <BANLkTimXbG5TkzV-MthUtkQ8k26AOPsqHw@mail.gmail.com>
Subject: [PATCH 4/4] tps65912: add regulator driver
From: Margarita Olaya <magi@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tps65912 consist of 4 DCDCs and 10 LDOs. The output voltages can be
configured by the SPI or I2C interface, they are meant to supply power
to the main processor and other components.

Signed-off-by: Margarita Olaya Cabrera <magi@slimlogic.co.uk>
---
 drivers/regulator/Kconfig              |    6 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/tps65912-regulator.c |  966 ++++++++++++++++++++++++++++++++
 3 files changed, 973 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/tps65912-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index b9f29e0..16af3bb 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -248,6 +248,12 @@ config REGULATOR_TPS6507X
 	  three step-down converters and two general-purpose LDO voltage regulators.
 	  It supports TI's software based Class-2 SmartReflex implementation.

+config REGULATOR_TPS65912
+	tristate "TI TPS65912 Power regulator"
+	depends on MFD_TPS65912
+	help
+	    This driver supports TPS65912 voltage regulator chip.
+
 config REGULATOR_88PM8607
 	bool "Marvell 88PM8607 Power regulators"
 	depends on MFD_88PM860X=y
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index d72a427..acb2bcc 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_REGULATOR_TPS6105X) += tps6105x-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65023) += tps65023-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6507X) += tps6507x-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6524X) += tps6524x-regulator.o
+obj-$(CONFIG_REGULATOR_TPS65912) += tps65912-regulator.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
 obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
diff --git a/drivers/regulator/tps65912-regulator.c
b/drivers/regulator/tps65912-regulator.c
new file mode 100644
index 0000000..525586a
--- /dev/null
+++ b/drivers/regulator/tps65912-regulator.c
@@ -0,0 +1,966 @@
+/*
+ * tps65912.c  --  TI tps65912
+ *
+ * Copyright 2011 Texas Instruments Inc.
+ *
+ * Author: Margarita Olaya Cabrera <magi@slimlogic.co.uk>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/mfd/tps65912.h>
+
+/* DCDC's */
+#define TPS65912_REG_DCDC1	0
+#define TPS65912_REG_DCDC2	1
+#define TPS65912_REG_DCDC3	2
+#define TPS65912_REG_DCDC4	3
+
+/* LDOs */
+#define TPS65912_REG_LDO1	4
+#define TPS65912_REG_LDO2	5
+#define TPS65912_REG_LDO3	6
+#define TPS65912_REG_LDO4	7
+#define TPS65912_REG_LDO5	8
+#define TPS65912_REG_LDO6	9
+#define TPS65912_REG_LDO7	10
+#define TPS65912_REG_LDO8	11
+#define TPS65912_REG_LDO9	12
+#define TPS65912_REG_LDO10	13
+
+#define TPS65912_MAX_REG_ID	TPS65912_REG_LDO_10
+
+/* Number of step-down converters available */
+#define TPS65912_NUM_DCDC	4
+
+/* Number of LDO voltage regulators  available */
+#define TPS65912_NUM_LDO	10
+
+/* Number of total regulators available */
+#define TPS65912_NUM_REGULATOR		(TPS65912_NUM_DCDC + TPS65912_NUM_LDO)
+
+#define TPS65912_REG_ENABLED	0x80
+#define TPS65912_REG_DISABLED	0x7F
+#define OP_SELREG_MASK		0x40
+#define OP_SELREG_SHIFT		6
+
+/* Supported voltage values for regulators */
+static const u16 VDCDCx_VSEL0_table[] = {
+	5000, 5125, 5250, 5375, 5500,
+	5625, 5750, 5875, 6000, 6125,
+	6250, 6375, 6500, 6625, 6750,
+	6875, 7000, 7125, 7250, 7375,
+	7500, 7625, 7750, 7875, 8000,
+	8125, 8250, 8375, 8500, 8625,
+	8750, 8875, 9000, 9125, 9250,
+	9375, 9500, 9625, 9750, 9875,
+	10000, 10125, 10250, 10375, 10500,
+	10625, 10750, 10875, 11000, 11125,
+	11250, 11375, 11500, 11625, 11750,
+	11875, 12000, 12125, 12250, 12375,
+	12500, 12625, 12750, 12875,
+};
+
+static const u16 VDCDCx_VSEL1_table[] = {
+	7000, 7125, 7250, 7375, 7500,
+	7625, 7750, 7875, 8000, 8125,
+	8250, 8375, 8500, 8625, 8750,
+	8875, 9000, 9125, 9250, 9375,
+	9500, 9625, 9750, 9875, 10000,
+	10125, 10250, 10375, 10500, 10625,
+	10750, 10875, 11000, 11125, 11250,
+	11375, 11500, 11625, 11750, 11875,
+	12000, 12125, 12250, 12375, 12500,
+	12625, 12750, 12875, 13000, 13125,
+	13250, 13375, 13500, 13625, 13750,
+	13875, 14000, 14125, 14250, 14375,
+	14500, 14625, 14750, 14875,
+};
+
+static const u16 VDCDCx_VSEL2_table[] = {
+	5000, 5250, 5500, 5750,
+	6000, 6250, 6500, 6750,
+	7000, 7250, 7500, 7750,
+	8000, 8250, 8500, 8750,
+	9000, 9250, 9500, 9750,
+	10000, 10250, 10500, 10750,
+	11000, 11250, 11500, 11750,
+	12000, 12250, 12500, 12750,
+	13000, 13250, 13500, 13750,
+	14000, 14250, 14500, 14750,
+	15000, 15250, 15500, 15750,
+	16000, 16250, 16500, 16750,
+	17000, 17250, 17500, 17750,
+	18000, 18250, 18500, 18750,
+	19000, 19250, 19500, 19750,
+	20000, 20250, 20500, 20750,
+};
+
+static const u16 VDCDCx_VSEL3_table[] = {
+	5000, 5500, 6000, 6500,
+	7000, 7500, 8000, 8500,
+	9000, 9500, 10000, 10500,
+	11000, 11500, 12000, 12500,
+	13000, 13500, 14000, 14500,
+	15000, 15500, 16000, 16500,
+	17000, 17500, 18000, 18500,
+	19000, 19500, 20000, 20500,
+	21000, 21500, 22000, 22500,
+	23000, 23500, 24000, 24500,
+	25000, 25500, 26000, 26500,
+	27000, 27500, 28000, 28500,
+	29000, 29500, 30000, 30500,
+	31000, 31500, 32000, 32500,
+	33000, 33500, 34000, 34500,
+	35000, 35500, 36000, 38000,
+};
+
+static const u16 LDO_VSEL_table[] = {
+	8000, 8250, 8500, 8750,
+	9000, 9250, 9500, 9750,
+	10000, 10250, 10500, 10750,
+	11000, 11250, 11500, 11750,
+	12000, 12250, 12500, 12750,
+	13000, 13250, 13500, 13750,
+	14000, 14250, 14500, 14750,
+	15000, 15250, 15500, 15750,
+	16000, 16500, 17000, 17500,
+	18000, 18500, 19000, 19500,
+	20000, 20500, 21000, 21500,
+	22000, 22500, 23000, 23500,
+	24000, 24500, 25000, 25500,
+	26000, 26500, 27000, 27500,
+	28000, 28500, 29000, 29500,
+	30000, 31000, 32000, 33000,
+};
+
+static unsigned int num_voltages[] = {
+	ARRAY_SIZE(VDCDCx_VSEL0_table),
+	ARRAY_SIZE(VDCDCx_VSEL1_table),
+	ARRAY_SIZE(VDCDCx_VSEL2_table),
+	ARRAY_SIZE(VDCDCx_VSEL3_table),
+	ARRAY_SIZE(LDO_VSEL_table),
+	ARRAY_SIZE(LDO_VSEL_table),
+	ARRAY_SIZE(LDO_VSEL_table),
+	ARRAY_SIZE(LDO_VSEL_table),
+	ARRAY_SIZE(LDO_VSEL_table),
+	ARRAY_SIZE(LDO_VSEL_table),
+	ARRAY_SIZE(LDO_VSEL_table),
+	ARRAY_SIZE(LDO_VSEL_table),
+	ARRAY_SIZE(LDO_VSEL_table),
+	ARRAY_SIZE(LDO_VSEL_table)
+};
+
+struct tps_info {
+	const char *name;
+	unsigned min_uV;
+	unsigned max_uV;
+	u8 table_len;
+	const u16 *table;
+};
+
+static struct tps_info tps65912_regs[] = {
+	{
+		.name = "DCDC1",
+	},
+	{
+		.name = "DCDC2",
+	},
+	{
+		.name = "DCDC3",
+	},
+	{
+		.name = "DCDC4",
+	},
+	{
+		.name = "LDO1",
+	},
+	{
+		.name = "LDO2",
+	},
+	{
+		.name = "LDO3",
+	},
+	{
+		.name = "LDO4",
+	},
+	{
+		.name = "LDO5",
+	},
+	{
+		.name = "LDO6",
+	},
+	{
+		.name = "LDO7",
+	},
+	{
+		.name = "LDO8",
+	},
+	{
+		.name = "LDO9",
+	},
+	{
+		.name = "LDO10",
+	},
+};
+
+struct tps65912_reg {
+	struct regulator_desc desc[TPS65912_NUM_REGULATOR];
+	struct tps65912 *mfd;
+	struct regulator_dev *rdev[TPS65912_NUM_REGULATOR];
+	struct tps_info *info[TPS65912_NUM_REGULATOR];
+	/* for read/write access */
+	struct mutex io_lock;
+	int mode;
+	int (*get_ctrl_reg)(int);
+	int dcdc1_range;
+	int dcdc2_range;
+	int dcdc3_range;
+	int dcdc4_range;
+};
+
+static inline int tps65912_read(struct tps65912_reg *pmic, u8 reg)
+{
+	u8 val;
+	int err;
+
+	err = pmic->mfd->read(pmic->mfd, reg, 1, &val);
+	if (err < 0)
+		return err;
+
+	return val;
+}
+
+static inline int tps65912_write(struct tps65912_reg *pmic, u8 reg, u8 val)
+{
+	return pmic->mfd->write(pmic->mfd, reg, 1, &val);
+}
+
+static int tps65912_reg_read(struct tps65912_reg *pmic, u8 reg)
+{
+	int data;
+
+	mutex_lock(&pmic->io_lock);
+
+	data = tps65912_read(pmic, reg);
+	if (data < 0)
+		dev_err(pmic->mfd->dev, "Read from reg 0x%x failed\n", reg);
+
+	mutex_unlock(&pmic->io_lock);
+	return data;
+}
+
+static int tps65912_reg_write(struct tps65912_reg *pmic, u8 reg, u8 val)
+{
+	int err;
+
+	mutex_lock(&pmic->io_lock);
+
+	err = tps65912_write(pmic, reg, val);
+	if (err < 0)
+		dev_err(pmic->mfd->dev, "Write for reg 0x%x failed\n", reg);
+
+	mutex_unlock(&pmic->io_lock);
+	return err;
+}
+
+static void tps65912_init_vtable(struct tps65912_reg *pmic, int id, int range)
+{
+	switch (range) {
+	case 0:
+		pmic->info[id]->table = VDCDCx_VSEL0_table;
+		pmic->info[id]->table_len = ARRAY_SIZE(VDCDCx_VSEL0_table);
+		pmic->info[id]->min_uV = 500000;
+		pmic->info[id]->max_uV = 1287500;
+		break;
+	case 1:
+		pmic->info[id]->table = VDCDCx_VSEL1_table;
+		pmic->info[id]->table_len = ARRAY_SIZE(VDCDCx_VSEL1_table);
+		pmic->info[id]->min_uV = 700000;
+		pmic->info[id]->max_uV = 1487500;
+		break;
+	case 2:
+		pmic->info[id]->table = VDCDCx_VSEL2_table;
+		pmic->info[id]->table_len = ARRAY_SIZE(VDCDCx_VSEL2_table);
+		pmic->info[id]->min_uV = 500000;
+		pmic->info[id]->max_uV = 2075000;
+		break;
+	case 3:
+		pmic->info[id]->table = VDCDCx_VSEL3_table;
+		pmic->info[id]->table_len = ARRAY_SIZE(VDCDCx_VSEL3_table);
+		pmic->info[id]->min_uV = 500000;
+		pmic->info[id]->max_uV = 3800000;
+		break;
+	default:
+		break;
+	}
+}
+
+static int tps65912_get_range(struct tps65912_reg *pmic, int id)
+{
+	if (id > TPS65912_REG_DCDC4)
+		return 0;
+
+	switch (id) {
+	case TPS65912_REG_DCDC1:
+		pmic->dcdc1_range = tps65912_reg_read(pmic,
+							TPS65912_DCDC1_LIMIT);
+		if (pmic->dcdc1_range < 0)
+			return pmic->dcdc1_range;
+		pmic->dcdc1_range = (pmic->dcdc1_range &
+			DCDC_LIMIT_RANGE_MASK) >> DCDC_LIMIT_RANGE_SHIFT;
+		return pmic->dcdc1_range;
+	case TPS65912_REG_DCDC2:
+		pmic->dcdc2_range = tps65912_reg_read(pmic,
+							TPS65912_DCDC2_LIMIT);
+		if (pmic->dcdc2_range < 0)
+			return pmic->dcdc2_range;
+		pmic->dcdc2_range = (pmic->dcdc2_range &
+			DCDC_LIMIT_RANGE_MASK) >> DCDC_LIMIT_RANGE_SHIFT;
+		return pmic->dcdc2_range;
+	case TPS65912_REG_DCDC3:
+		pmic->dcdc3_range = tps65912_reg_read(pmic,
+							TPS65912_DCDC3_LIMIT);
+		if (pmic->dcdc3_range < 0)
+			return pmic->dcdc3_range;
+		pmic->dcdc3_range = (pmic->dcdc3_range &
+			DCDC_LIMIT_RANGE_MASK) >> DCDC_LIMIT_RANGE_SHIFT;
+		return pmic->dcdc3_range;
+	case TPS65912_REG_DCDC4:
+		pmic->dcdc4_range = tps65912_reg_read(pmic,
+							TPS65912_DCDC4_LIMIT);
+		if (pmic->dcdc4_range < 0)
+			return pmic->dcdc4_range;
+		pmic->dcdc4_range = (pmic->dcdc4_range &
+			DCDC_LIMIT_RANGE_MASK) >> DCDC_LIMIT_RANGE_SHIFT;
+		return pmic->dcdc4_range;
+	default:
+		return 0;
+	}
+}
+
+static unsigned long tps65912_vsel_to_uv_range0(u8 vsel)
+{
+	unsigned long uv;
+
+	uv = ((vsel * 12500) + 500000);
+	return uv;
+}
+
+static unsigned long tps65912_vsel_to_uv_range1(u8 vsel)
+{
+	unsigned long uv;
+
+	 uv = ((vsel * 12500) + 700000);
+	return uv;
+}
+
+static unsigned long tps65912_vsel_to_uv_range2(u8 vsel)
+{
+	unsigned long uv;
+
+	uv = ((vsel * 25000) + 500000);
+	return uv;
+}
+
+static unsigned long tps65912_vsel_to_uv_range3(u8 vsel)
+{
+	unsigned long uv;
+
+	if (vsel == 0x3f)
+		uv = 3800000;
+	else
+		uv = ((vsel * 5000) + 500000);
+
+	return uv;
+}
+
+static int tps65912_get_ctrl_register(int id)
+{
+	switch (id) {
+	case TPS65912_REG_DCDC1:
+		return TPS65912_DCDC1_AVS;
+	case TPS65912_REG_DCDC2:
+		return TPS65912_DCDC2_AVS;
+	case TPS65912_REG_DCDC3:
+		return TPS65912_DCDC3_AVS;
+	case TPS65912_REG_DCDC4:
+		return TPS65912_DCDC4_AVS;
+	case TPS65912_REG_LDO1:
+		return TPS65912_LDO1_AVS;
+	case TPS65912_REG_LDO2:
+		return TPS65912_LDO2_AVS;
+	case TPS65912_REG_LDO3:
+		return TPS65912_LDO3_AVS;
+	case TPS65912_REG_LDO4:
+		return TPS65912_LDO4_AVS;
+	case TPS65912_REG_LDO5:
+		return TPS65912_LDO5;
+	case TPS65912_REG_LDO6:
+		return TPS65912_LDO6;
+	case TPS65912_REG_LDO7:
+		return TPS65912_LDO7;
+	case TPS65912_REG_LDO8:
+		return TPS65912_LDO8;
+	case TPS65912_REG_LDO9:
+		return TPS65912_LDO9;
+	case TPS65912_REG_LDO10:
+		return TPS65912_LDO10;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int tps65912_get_dcdc_sel_register(struct tps65912_reg *pmic, int id)
+{
+	int opvsel = 0, sr = 0;
+	u8 reg = 0;
+
+	if (id < TPS65912_REG_DCDC1 || id > TPS65912_REG_DCDC4)
+		return -EINVAL;
+
+	switch (id) {
+	case TPS65912_REG_DCDC1:
+		opvsel = tps65912_reg_read(pmic, TPS65912_DCDC1_OP);
+		sr = ((opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT);
+		if (sr)
+			reg = TPS65912_DCDC1_AVS;
+		else
+			reg = TPS65912_DCDC1_OP;
+		break;
+	case TPS65912_REG_DCDC2:
+		opvsel = tps65912_reg_read(pmic, TPS65912_DCDC2_OP);
+		sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
+		if (sr)
+			reg = TPS65912_DCDC2_AVS;
+		else
+			reg = TPS65912_DCDC2_OP;
+		break;
+	case TPS65912_REG_DCDC3:
+		opvsel = tps65912_reg_read(pmic, TPS65912_DCDC3_OP);
+		sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
+		if (sr)
+			reg = TPS65912_DCDC3_AVS;
+		else
+			reg = TPS65912_DCDC3_OP;
+		break;
+	case TPS65912_REG_DCDC4:
+		opvsel = tps65912_reg_read(pmic, TPS65912_DCDC4_OP);
+		sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
+		if (sr)
+			reg = TPS65912_DCDC4_AVS;
+		else
+			reg = TPS65912_DCDC4_OP;
+		break;
+	}
+	return reg;
+}
+
+static int tps65912_get_ldo_sel_register(struct tps65912_reg *pmic, int id)
+{
+	int opvsel = 0, sr = 0;
+	u8 reg = 0;
+
+	if (id < TPS65912_REG_LDO1 || id > TPS65912_REG_LDO10)
+		return -EINVAL;
+
+	switch (id) {
+	case TPS65912_REG_LDO1:
+		opvsel = tps65912_reg_read(pmic, TPS65912_LDO1_OP);
+		sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
+		if (sr)
+			reg = TPS65912_LDO1_AVS;
+		else
+			reg = TPS65912_LDO1_OP;
+		break;
+	case TPS65912_REG_LDO2:
+		opvsel = tps65912_reg_read(pmic, TPS65912_LDO2_OP);
+		sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
+		if (sr)
+			reg = TPS65912_LDO2_AVS;
+		else
+			reg = TPS65912_LDO2_OP;
+		break;
+	case TPS65912_REG_LDO3:
+		opvsel = tps65912_reg_read(pmic, TPS65912_LDO3_OP);
+		sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
+		if (sr)
+			reg = TPS65912_LDO3_AVS;
+		else
+			reg = TPS65912_LDO3_OP;
+		break;
+	case TPS65912_REG_LDO4:
+		opvsel = tps65912_reg_read(pmic, TPS65912_LDO4_OP);
+		sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
+		if (sr)
+			reg = TPS65912_LDO4_AVS;
+		else
+			reg = TPS65912_LDO4_OP;
+		break;
+	case TPS65912_REG_LDO5:
+		reg = TPS65912_LDO5;
+		break;
+	case TPS65912_REG_LDO6:
+		reg = TPS65912_LDO6;
+		break;
+	case TPS65912_REG_LDO7:
+		reg = TPS65912_LDO7;
+		break;
+	case TPS65912_REG_LDO8:
+		reg = TPS65912_LDO8;
+		break;
+	case TPS65912_REG_LDO9:
+		reg = TPS65912_LDO9;
+		break;
+	case TPS65912_REG_LDO10:
+		reg = TPS65912_LDO10;
+		break;
+	}
+
+	return reg;
+}
+
+static int tps65912_reg_is_enabled(struct regulator_dev *dev)
+{
+	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
+	int reg, value, id = rdev_get_id(dev);
+
+	if (id < TPS65912_REG_DCDC1 || id > TPS65912_REG_LDO10)
+		return -EINVAL;
+
+	reg = pmic->get_ctrl_reg(id);
+	if (reg < 0)
+		return reg;
+
+	value = tps65912_reg_read(pmic, reg);
+	if (value < 0)
+		return value;
+
+	return value & TPS65912_REG_ENABLED;
+}
+
+static int tps65912_reg_enable(struct regulator_dev *dev)
+{
+	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
+	struct tps65912 *mfd = pmic->mfd;
+	int id = rdev_get_id(dev);
+	u8 reg;
+
+	if (id < TPS65912_REG_DCDC1 || id > TPS65912_REG_LDO10)
+		return -EINVAL;
+
+	reg = pmic->get_ctrl_reg(id);
+	if (reg < 0)
+		return reg;
+
+	return tps65912_set_bits(mfd, reg, TPS65912_REG_ENABLED);
+}
+
+static int tps65912_reg_disable(struct regulator_dev *dev)
+{
+	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
+	struct tps65912 *mfd = pmic->mfd;
+	int id = rdev_get_id(dev), reg;
+
+	reg = pmic->get_ctrl_reg(id);
+	if (reg < 0)
+		return reg;
+
+	return tps65912_clear_bits(mfd, reg, TPS65912_REG_DISABLED);
+}
+
+static int tps65912_set_mode(struct regulator_dev *dev, unsigned int mode)
+{
+	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
+	int pwm_mode, eco, reg1, reg2, reg1_val, reg2_val;
+	int id = rdev_get_id(dev);
+
+	switch (id) {
+	case TPS65912_REG_DCDC1:
+		reg1 = TPS65912_DCDC1_CTRL;
+		reg2 = TPS65912_DCDC1_AVS;
+		break;
+	case TPS65912_REG_DCDC2:
+		reg1 = TPS65912_DCDC2_CTRL;
+		reg2 = TPS65912_DCDC2_AVS;
+		break;
+	case TPS65912_REG_DCDC3:
+		reg1 = TPS65912_DCDC3_CTRL;
+		reg2 = TPS65912_DCDC3_AVS;
+		break;
+	case TPS65912_REG_DCDC4:
+		reg1 = TPS65912_DCDC4_CTRL;
+		reg2 = TPS65912_DCDC4_AVS;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	reg1_val = tps65912_reg_read(pmic, reg1);
+	reg2_val = tps65912_reg_read(pmic, reg2);
+
+	pwm_mode = reg1_val & DCDCCTRL_DCDC_MODE_MASK;
+	eco = reg2_val & DCDC_AVS_ECO_MASK;
+
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		/* Verify if mode alredy set */
+		if (pwm_mode && !eco)
+			break;
+		reg1_val |= DCDCCTRL_DCDC_MODE_MASK;
+		tps65912_reg_write(pmic, reg1, reg1_val);
+		reg2_val &= ~DCDC_AVS_ECO_MASK;
+		tps65912_reg_write(pmic, reg2, reg2_val);
+		break;
+	case REGULATOR_MODE_NORMAL:
+	case REGULATOR_MODE_IDLE:
+		if (!pwm_mode && !eco)
+			break;
+		reg1_val &= ~DCDCCTRL_DCDC_MODE_MASK;
+		tps65912_reg_write(pmic, reg1, reg1_val);
+		reg2_val &= ~DCDC_AVS_ECO_MASK;
+		tps65912_reg_write(pmic, reg2, reg2_val);
+		break;
+	case REGULATOR_MODE_STANDBY:
+		if (!pwm_mode && eco)
+			break;
+		reg1_val &= ~DCDCCTRL_DCDC_MODE_MASK;
+		tps65912_reg_write(pmic, reg1, reg1_val);
+		reg2_val |= DCDC_AVS_ECO_MASK;
+		tps65912_reg_write(pmic, reg2, reg2_val);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static unsigned int tps65912_get_mode(struct regulator_dev *dev)
+{
+	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
+	int pwm_mode, eco, mode = 0, id = rdev_get_id(dev);
+
+	switch (id) {
+	case TPS65912_REG_DCDC1:
+		pwm_mode = tps65912_reg_read(pmic, TPS65912_DCDC1_CTRL);
+		eco = tps65912_reg_read(pmic, TPS65912_DCDC1_AVS);
+		break;
+	case TPS65912_REG_DCDC2:
+		pwm_mode = tps65912_reg_read(pmic, TPS65912_DCDC2_CTRL);
+		eco = tps65912_reg_read(pmic, TPS65912_DCDC2_AVS);
+		break;
+	case TPS65912_REG_DCDC3:
+		pwm_mode = tps65912_reg_read(pmic, TPS65912_DCDC3_CTRL);
+		eco = tps65912_reg_read(pmic, TPS65912_DCDC3_AVS);
+		break;
+	case TPS65912_REG_DCDC4:
+		pwm_mode = tps65912_reg_read(pmic, TPS65912_DCDC4_CTRL);
+		eco = tps65912_reg_read(pmic, TPS65912_DCDC4_AVS);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	pwm_mode &= DCDCCTRL_DCDC_MODE_MASK;
+	eco &= DCDC_AVS_ECO_MASK;
+
+	if (pwm_mode && !eco)
+		mode = REGULATOR_MODE_FAST;
+	else if (!pwm_mode && !eco)
+		mode = REGULATOR_MODE_NORMAL;
+	else if (!pwm_mode && eco)
+		mode = REGULATOR_MODE_STANDBY;
+
+	return mode;
+}
+
+static int tps65912_get_voltage_dcdc(struct regulator_dev *dev)
+{
+	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev), voltage = 0, range;
+	int opvsel = 0, avsel = 0, sr, vsel;
+
+	switch (id) {
+	case TPS65912_REG_DCDC1:
+		opvsel = tps65912_reg_read(pmic, TPS65912_DCDC1_OP);
+		avsel = tps65912_reg_read(pmic, TPS65912_DCDC1_AVS);
+		range = pmic->dcdc1_range;
+		break;
+	case TPS65912_REG_DCDC2:
+		opvsel = tps65912_reg_read(pmic, TPS65912_DCDC2_OP);
+		avsel = tps65912_reg_read(pmic, TPS65912_DCDC2_AVS);
+		range = pmic->dcdc2_range;
+		break;
+	case TPS65912_REG_DCDC3:
+		opvsel = tps65912_reg_read(pmic, TPS65912_DCDC3_OP);
+		avsel = tps65912_reg_read(pmic, TPS65912_DCDC3_AVS);
+		range = pmic->dcdc3_range;
+		break;
+	case TPS65912_REG_DCDC4:
+		opvsel = tps65912_reg_read(pmic, TPS65912_DCDC4_OP);
+		avsel = tps65912_reg_read(pmic, TPS65912_DCDC4_AVS);
+		range = pmic->dcdc4_range;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
+	if (sr)
+		vsel = avsel;
+	else
+		vsel = opvsel;
+	vsel &= 0x3F;
+
+	switch (range) {
+	case 0:
+		/* 0.5 - 1.2875V in 12.5mV steps */
+		voltage = tps65912_vsel_to_uv_range0(vsel);
+		break;
+	case 1:
+		/* 0.7 - 1.4875V in 12.5mV steps */
+		voltage = tps65912_vsel_to_uv_range1(vsel);
+		break;
+	case 2:
+		/* 0.5 - 2.075V in 25mV steps */
+		voltage = tps65912_vsel_to_uv_range2(vsel);
+		break;
+	case 3:
+		/* 0.5 - 3.8V in 50mV steps */
+		voltage = tps65912_vsel_to_uv_range3(vsel);
+		break;
+	}
+	return voltage;
+}
+
+static int tps65912_set_voltage_dcdc(struct regulator_dev *dev,
+						unsigned selector)
+{
+	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	int value;
+	const u16 *table;
+	u8 table_len, reg;
+
+	table = pmic->info[id]->table;
+	table_len = pmic->info[id]->table_len;
+
+	reg = tps65912_get_dcdc_sel_register(pmic, id);
+	value = tps65912_reg_read(pmic, reg);
+	value &= 0xC0;
+	return tps65912_reg_write(pmic, reg, selector | value);
+}
+
+static int tps65912_get_voltage_ldo(struct regulator_dev *dev)
+{
+	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev), voltage = 0;
+	int vsel = 0;
+	u8 reg;
+
+	reg = tps65912_get_ldo_sel_register(pmic, id);
+	vsel = tps65912_reg_read(pmic, reg);
+	vsel &= 0x3F;
+
+	/* 0.5 - 1.2875V in 12.5mV steps */
+	voltage = LDO_VSEL_table[vsel];
+
+	return voltage * 100;
+}
+
+static int tps65912_set_voltage_ldo(struct regulator_dev *dev,
+						unsigned selector)
+{
+	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev), reg, value;
+
+	reg = tps65912_get_ldo_sel_register(pmic, id);
+	value = tps65912_reg_read(pmic, reg);
+	value &= 0xC0;
+	return tps65912_reg_write(pmic, reg, selector | value);
+}
+
+static int tps65912_list_voltage_dcdc(struct regulator_dev *dev,
+					unsigned selector)
+{
+	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	const u16 *table;
+	u8 table_len;
+
+	table = pmic->info[id]->table;
+	table_len = pmic->info[id]->table_len;
+	if (selector >= table_len)
+		return -EINVAL;
+	else
+		return table[selector] * 100;
+}
+
+static int tps65912_list_voltage_ldo(struct regulator_dev *dev,
+					unsigned selector)
+{
+	int ldo = rdev_get_id(dev);
+	const u16 *table;
+	u8 table_len;
+
+	if (ldo < TPS65912_REG_LDO1 || ldo > TPS65912_REG_LDO10)
+		return -EINVAL;
+
+	table = LDO_VSEL_table;
+	table_len = ARRAY_SIZE(LDO_VSEL_table);
+
+	if (selector >= table_len)
+		return -EINVAL;
+	else
+		return table[selector] * 100;
+}
+
+/* Operations permitted on DCDCx */
+static struct regulator_ops tps65912_ops_dcdc = {
+	.is_enabled = tps65912_reg_is_enabled,
+	.enable = tps65912_reg_enable,
+	.disable = tps65912_reg_disable,
+	.set_mode = tps65912_set_mode,
+	.get_mode = tps65912_get_mode,
+	.get_voltage = tps65912_get_voltage_dcdc,
+	.set_voltage_sel = tps65912_set_voltage_dcdc,
+	.list_voltage = tps65912_list_voltage_dcdc,
+};
+
+/* Operations permitted on LDOx */
+static struct regulator_ops tps65912_ops_ldo = {
+	.is_enabled = tps65912_reg_is_enabled,
+	.enable = tps65912_reg_enable,
+	.disable = tps65912_reg_disable,
+	.get_voltage = tps65912_get_voltage_ldo,
+	.set_voltage_sel = tps65912_set_voltage_ldo,
+	.list_voltage = tps65912_list_voltage_ldo,
+};
+
+static __devinit int tps65912_probe(struct platform_device *pdev)
+{
+	struct tps65912 *tps65912 = dev_get_drvdata(pdev->dev.parent);
+	struct tps_info *info;
+	struct regulator_init_data *reg_data;
+	struct regulator_dev *rdev;
+	struct tps65912_reg *pmic;
+	struct tps65912_board *pmic_plat_data;
+	static int desc_id;
+	int i, err;
+
+	pmic_plat_data = dev_get_platdata(tps65912->dev);
+	if (!pmic_plat_data)
+		return -EINVAL;
+
+	reg_data = pmic_plat_data->tps65912_pmic_init_data;
+
+	pmic = kzalloc(sizeof(*pmic), GFP_KERNEL);
+	if (!pmic)
+		return -ENOMEM;
+
+	mutex_init(&pmic->io_lock);
+	pmic->mfd = tps65912;
+	platform_set_drvdata(pdev, pmic);
+
+	pmic->get_ctrl_reg = &tps65912_get_ctrl_register;
+	info = tps65912_regs;
+
+	for (i = 0; i < TPS65912_NUM_REGULATOR; i++, info++, reg_data++) {
+		int range = 0;
+		/* Register the regulators */
+		pmic->info[i] = info;
+
+		pmic->desc[i].name = info->name;
+		pmic->desc[i].id = desc_id++;
+		pmic->desc[i].n_voltages = num_voltages[i];
+		pmic->desc[i].ops = (i > TPS65912_REG_DCDC4 ?
+		&tps65912_ops_ldo : &tps65912_ops_dcdc);
+		pmic->desc[i].type = REGULATOR_VOLTAGE;
+		pmic->desc[i].owner = THIS_MODULE;
+		range = tps65912_get_range(pmic, i);
+		tps65912_init_vtable(pmic, i, range);
+		rdev = regulator_register(&pmic->desc[i],
+					tps65912->dev, reg_data, pmic);
+		if (IS_ERR(rdev)) {
+			dev_err(tps65912->dev,
+				"failed to register %s regulator\n",
+				pdev->name);
+			err = PTR_ERR(rdev);
+			goto err;
+		}
+
+		/* Save regulator for cleanup */
+		pmic->rdev[i] = rdev;
+	}
+	return 0;
+
+err:
+	while (--i >= 0)
+		regulator_unregister(pmic->rdev[i]);
+
+	kfree(pmic);
+	return err;
+}
+
+static int __devexit tps65912_remove(struct platform_device *pdev)
+{
+	struct tps65912_reg *tps65912_reg = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < TPS65912_NUM_REGULATOR; i++)
+		regulator_unregister(tps65912_reg->rdev[i]);
+
+	kfree(tps65912_reg);
+	return 0;
+}
+
+static struct platform_driver tps65912_driver = {
+	.driver = {
+		.name = "tps65912-pmic",
+		.owner = THIS_MODULE,
+	},
+	.probe = tps65912_probe,
+	.remove = __devexit_p(tps65912_remove),
+};
+
+/**
+ * tps65912_init
+ *
+ * Module init function
+ */
+static int __init tps65912_init(void)
+{
+	return platform_driver_register(&tps65912_driver);
+}
+subsys_initcall(tps65912_init);
+
+/**
+ * tps65912_cleanup
+ *
+ * Module exit function
+ */
+static void __exit tps65912_cleanup(void)
+{
+	platform_driver_unregister(&tps65912_driver);
+}
+module_exit(tps65912_cleanup);
+
+MODULE_AUTHOR("Margarita Olaya Cabrera <magi@slimlogic.co.uk>");
+MODULE_DESCRIPTION("TPS65912 voltage regulator driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:tps65912-pmic");
-- 
1.7.0.4
