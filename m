Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1DTB1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 21:27:41 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:40264 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab1DTB1j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 21:27:39 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv3 4/4] TPS65910: Add tps65910 regulator driver
Date: Tue, 19 Apr 2011 20:27:35 -0500
Message-Id: <BAB49D4A-084E-4290-AF99-118A172F0ED6@slimlogic.co.uk>
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com, sameo@linux.intel.com,
        Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <gg@slimlogic.co.uk>

The regulator module consists of 3 DCDCs and 8 LDOs. The output
voltages are configurable and are meant to supply power to the
main processor and other components

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
---
 drivers/regulator/Kconfig              |    6 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/tps65910-regulator.c |  736 ++++++++++++++++++++++++++++++++
 include/linux/mfd/tps65910.h           |   14 +
 4 files changed, 757 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/tps65910-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index b9f29e0..fa61fe2 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -290,5 +290,11 @@ config REGULATOR_TPS6524X
 	  serial interface currently supported on the sequencer serial
 	  port controller.
 
+config REGULATOR_TPS65910
+	tristate "TI TPS65910 Power Regulator"
+	depends on MFD_TPS65910
+	help
+	  This driver supports TPS65910 voltage regulator chips.
+
 endif
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index d72a427..8cb6d0d 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -41,5 +41,6 @@ obj-$(CONFIG_REGULATOR_TPS6524X) += tps6524x-regulator.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
 obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
+obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
new file mode 100644
index 0000000..cb34372
--- /dev/null
+++ b/drivers/regulator/tps65910-regulator.c
@@ -0,0 +1,736 @@
+/*
+ * tps65910.c  --  TI tps65910
+ *
+ * Copyright 2010 Texas Instruments Inc.
+ *
+ * Author: Graeme Gregory <gg@slimlogic.co.uk>
+ * Author: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
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
+#include <linux/mfd/tps65910.h>
+
+#define TPS65910_REG_VRTC		0
+#define TPS65910_REG_VIO		1
+#define TPS65910_REG_VDD1		2
+#define TPS65910_REG_VDD2		3
+#define TPS65910_REG_VDD3		4
+#define TPS65910_REG_VDIG1		5
+#define TPS65910_REG_VDIG2		6
+#define TPS65910_REG_VPLL		7
+#define TPS65910_REG_VDAC		8
+#define TPS65910_REG_VAUX1		9
+#define TPS65910_REG_VAUX2		10
+#define TPS65910_REG_VAUX33		11
+#define TPS65910_REG_VMMC		12
+
+#define TPS65910_NUM_REGULATOR		13
+
+#define TPS65910_SUPPLY_STATE_ENABLED	0x1
+
+/* supported VIO voltages in milivolts */
+static const u16 VIO_VSEL_table[] = {
+	1500, 1800, 2500, 3300,
+};
+
+/* supported VIO voltages in milivolts */
+static const u16 VDD3_VSEL_table[] = {
+	5000,
+};
+
+/* supported VDIG1 voltages in milivolts */
+static const u16 VDIG1_VSEL_table[] = {
+	1200, 1500, 1800, 2700,
+};
+
+/* supported VDIG2 voltages in milivolts */
+static const u16 VDIG2_VSEL_table[] = {
+	1000, 1100, 1200, 1800,
+};
+
+/* supported VPLL voltages in milivolts */
+static const u16 VPLL_VSEL_table[] = {
+	1000, 1100, 1800, 2500,
+};
+
+/* supported VDAC voltages in milivolts */
+static const u16 VDAC_VSEL_table[] = {
+	1800, 2600, 2800, 2850,
+};
+
+/* supported VAUX1 voltages in milivolts */
+static const u16 VAUX1_VSEL_table[] = {
+	1800, 2500, 2800, 2850,
+};
+
+/* supported VAUX2 voltages in milivolts */
+static const u16 VAUX2_VSEL_table[] = {
+	1800, 2800, 2900, 3300,
+};
+
+/* supported VAUX33 voltages in milivolts */
+static const u16 VAUX33_VSEL_table[] = {
+	1800, 2000, 2800, 3300,
+};
+
+/* supported VMMC voltages in milivolts */
+static const u16 VMMC_VSEL_table[] = {
+	1800, 2800, 3000, 3300,
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
+static struct tps_info tps65910_regs[] = {
+	{
+		.name = "VRTC",
+	},
+	{
+		.name = "VIO",
+		.min_uV = 1500000,
+		.max_uV = 3300000,
+		.table_len = ARRAY_SIZE(VIO_VSEL_table),
+		.table = VIO_VSEL_table,
+	},
+	{
+		.name = "VDD1",
+		.min_uV = 600000,
+		.max_uV = 4500000,
+	},
+	{
+		.name = "VDD2",
+		.min_uV = 600000,
+		.max_uV = 4500000,
+	},
+	{
+		.name = "VDD3",
+		.min_uV = 5000000,
+		.max_uV = 5000000,
+		.table_len = ARRAY_SIZE(VDD3_VSEL_table),
+		.table = VDD3_VSEL_table,
+	},
+	{
+		.name = "VDIG1",
+		.min_uV = 1200000,
+		.max_uV = 2700000,
+		.table_len = ARRAY_SIZE(VDIG1_VSEL_table),
+		.table = VDIG1_VSEL_table,
+	},
+	{
+		.name = "VDIG2",
+		.min_uV = 1000000,
+		.max_uV = 1800000,
+		.table_len = ARRAY_SIZE(VDIG2_VSEL_table),
+		.table = VDIG2_VSEL_table,
+	},
+	{
+		.name = "VPLL",
+		.min_uV = 1000000,
+		.max_uV = 2500000,
+		.table_len = ARRAY_SIZE(VPLL_VSEL_table),
+		.table = VPLL_VSEL_table,
+	},
+	{
+		.name = "VDAC",
+		.min_uV = 1800000,
+		.max_uV = 2850000,
+		.table_len = ARRAY_SIZE(VDAC_VSEL_table),
+		.table = VDAC_VSEL_table,
+	},
+	{
+		.name = "VAUX1",
+		.min_uV = 1800000,
+		.max_uV = 2850000,
+		.table_len = ARRAY_SIZE(VAUX1_VSEL_table),
+		.table = VAUX1_VSEL_table,
+	},
+	{
+		.name = "VAUX2",
+		.min_uV = 1800000,
+		.max_uV = 3300000,
+		.table_len = ARRAY_SIZE(VAUX2_VSEL_table),
+		.table = VAUX2_VSEL_table,
+	},
+	{
+		.name = "VAUX33",
+		.min_uV = 1800000,
+		.max_uV = 3300000,
+		.table_len = ARRAY_SIZE(VAUX33_VSEL_table),
+		.table = VAUX33_VSEL_table,
+	},
+	{
+		.name = "VMMC",
+		.min_uV = 1800000,
+		.max_uV = 3300000,
+		.table_len = ARRAY_SIZE(VMMC_VSEL_table),
+		.table = VMMC_VSEL_table,
+	},
+};
+
+struct tps65910_reg {
+	struct regulator_desc desc[TPS65910_NUM_REGULATOR];
+	struct tps65910 *mfd;
+	struct regulator_dev *rdev[TPS65910_NUM_REGULATOR];
+	struct tps_info *info[TPS65910_NUM_REGULATOR];
+	struct mutex mutex;
+	int mode;
+};
+
+static inline int tps65910_read(struct tps65910_reg *pmic, u8 reg)
+{
+	u8 val;
+	int err;
+
+	err = pmic->mfd->read(pmic->mfd, reg, 1, &val);
+	if (err)
+		return err;
+
+	return val;
+}
+
+static inline int tps65910_write(struct tps65910_reg *pmic, u8 reg, u8 val)
+{
+	return pmic->mfd->write(pmic->mfd, reg, 1, &val);
+}
+
+static int tps65910_set_bits(struct tps65910_reg *pmic, u8 reg, u8 mask)
+{
+	int err, data;
+
+	mutex_lock(&pmic->mutex);
+
+	data = tps65910_read(pmic, reg);
+	if (data < 0) {
+		dev_err(pmic->mfd->dev, "Read from reg 0x%x failed\n", reg);
+		err = data;
+		goto out;
+	}
+
+	data |= mask;
+	err = tps65910_write(pmic, reg, data);
+	if (err)
+		dev_err(pmic->mfd->dev, "Write for reg 0x%x failed\n", reg);
+
+out:
+	mutex_unlock(&pmic->mutex);
+	return err;
+}
+
+static int tps65910_clear_bits(struct tps65910_reg *pmic, u8 reg, u8 mask)
+{
+	int err, data;
+
+	mutex_lock(&pmic->mutex);
+
+	data = tps65910_read(pmic, reg);
+	if (data < 0) {
+		dev_err(pmic->mfd->dev, "Read from reg 0x%x failed\n", reg);
+		err = data;
+		goto out;
+	}
+
+	data &= ~mask;
+	err = tps65910_write(pmic, reg, data);
+	if (err)
+		dev_err(pmic->mfd->dev, "Write for reg 0x%x failed\n", reg);
+
+out:
+	mutex_unlock(&pmic->mutex);
+	return err;
+}
+
+static int tps65910_reg_read(struct tps65910_reg *pmic, u8 reg)
+{
+	int data;
+
+	mutex_lock(&pmic->mutex);
+
+	data = tps65910_read(pmic, reg);
+	if (data < 0)
+		dev_err(pmic->mfd->dev, "Read from reg 0x%x failed\n", reg);
+
+	mutex_unlock(&pmic->mutex);
+	return data;
+}
+
+static int tps65910_reg_write(struct tps65910_reg *pmic, u8 reg, u8 val)
+{
+	int err;
+
+	mutex_lock(&pmic->mutex);
+
+	err = tps65910_write(pmic, reg, val);
+	if (err < 0)
+		dev_err(pmic->mfd->dev, "Write for reg 0x%x failed\n", reg);
+
+	mutex_unlock(&pmic->mutex);
+	return err;
+}
+
+static int tps65910_get_ctrl_register(int id)
+{
+	switch (id) {
+	case TPS65910_REG_VRTC:
+		return TPS65910_VRTC;
+	case TPS65910_REG_VIO:
+		return TPS65910_VIO;
+	case TPS65910_REG_VDD1:
+		return TPS65910_VDD1;
+	case TPS65910_REG_VDD2:
+		return TPS65910_VDD2;
+	case TPS65910_REG_VDD3:
+		return TPS65910_VDD3;
+	case TPS65910_REG_VDIG1:
+		return TPS65910_VDIG1;
+	case TPS65910_REG_VDIG2:
+		return TPS65910_VDIG2;
+	case TPS65910_REG_VPLL:
+		return TPS65910_VPLL;
+	case TPS65910_REG_VDAC:
+		return TPS65910_VDAC;
+	case TPS65910_REG_VAUX1:
+		return TPS65910_VAUX1;
+	case TPS65910_REG_VAUX2:
+		return TPS65910_VAUX2;
+	case TPS65910_REG_VAUX33:
+		return TPS65910_VAUX33;
+	case TPS65910_REG_VMMC:
+		return TPS65910_VMMC;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int tps65910_is_enabled(struct regulator_dev *dev)
+{
+	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
+	int reg, value, id = rdev_get_id(dev);
+
+	reg = tps65910_get_ctrl_register(id);
+	if (reg < 0)
+		return reg;
+
+	value = tps65910_reg_read(pmic, reg);
+	if (value < 0)
+		return value;
+
+	return value & TPS65910_SUPPLY_STATE_ENABLED;
+}
+
+static int tps65910_enable(struct regulator_dev *dev)
+{
+	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
+	int reg, id = rdev_get_id(dev);
+
+	reg = tps65910_get_ctrl_register(id);
+	if (reg < 0)
+		return reg;
+
+	return tps65910_set_bits(pmic, reg, TPS65910_SUPPLY_STATE_ENABLED);
+}
+
+static int tps65910_disable(struct regulator_dev *dev)
+{
+	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
+	int reg, id = rdev_get_id(dev);
+
+	reg = tps65910_get_ctrl_register(id);
+	if (reg < 0)
+		return reg;
+
+	return tps65910_clear_bits(pmic, reg, TPS65910_SUPPLY_STATE_ENABLED);
+}
+
+
+static int tps65910_set_mode(struct regulator_dev *dev, unsigned int mode)
+{
+	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
+	int reg, value, id = rdev_get_id(dev);
+	reg = tps65910_get_ctrl_register(id);
+	if (reg < 0)
+		return reg;
+
+	switch (mode) {
+	case REGULATOR_MODE_NORMAL:
+		value = LDO_ST_ON_BIT & ~LDO_ST_MODE_BIT;
+		return tps65910_set_bits(pmic, reg, value);
+	case REGULATOR_MODE_IDLE:
+		value = LDO_ST_ON_BIT | LDO_ST_MODE_BIT;
+		tps65910_set_bits(pmic, reg, value);
+	case REGULATOR_MODE_STANDBY:
+		tps65910_clear_bits(pmic, reg, LDO_ST_ON_BIT);
+	}
+
+	return -EINVAL;
+}
+
+static unsigned int tps65910_get_mode(struct regulator_dev *dev)
+{
+	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
+	int reg, value, id = rdev_get_id(dev);
+
+	reg = tps65910_get_ctrl_register(id);
+	if (reg < 0)
+		return reg;
+
+	value = tps65910_reg_read(pmic, reg);
+	if (value < 0)
+		return value;
+
+	if (value & LDO_ST_ON_BIT)
+		return REGULATOR_MODE_STANDBY;
+	else if (value & LDO_ST_MODE_BIT)
+		return REGULATOR_MODE_IDLE;
+	else
+		return REGULATOR_MODE_NORMAL;
+}
+
+static int tps65910_get_voltage_dcdc(struct regulator_dev *dev)
+{
+	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev), voltage = 0;
+	int opvsel = 0, srvsel = 0, mult = 0, sr = 0;
+
+	switch (id) {
+	case TPS65910_REG_VDD1:
+		opvsel = tps65910_reg_read(pmic, TPS65910_VDD1_OP);
+		mult = tps65910_reg_read(pmic, TPS65910_VDD1);
+		mult = (mult & VDD1_VGAIN_SEL_MASK) >> VDD1_VGAIN_SEL_SHIFT;
+		srvsel = tps65910_reg_read(pmic, TPS65910_VDD1_SR);
+		sr = opvsel & VDD1_OP_CMD_MASK;
+		opvsel &= VDD1_OP_SEL_MASK;
+		srvsel &= VDD1_SR_SEL_MASK;
+		break;
+	case TPS65910_REG_VDD2:
+		opvsel = tps65910_reg_read(pmic, TPS65910_VDD2_OP);
+		mult = tps65910_reg_read(pmic, TPS65910_VDD2);
+		mult = (mult & VDD2_VGAIN_SEL_MASK) >> VDD2_VGAIN_SEL_SHIFT;
+		srvsel = tps65910_reg_read(pmic, TPS65910_VDD2_SR);
+		sr = opvsel & VDD2_OP_CMD_MASK;
+		opvsel &= VDD2_OP_SEL_MASK;
+		srvsel &= VDD2_SR_SEL_MASK;
+		break;
+	}
+
+	/* multiplier 0 == 1 but 2,3 normal */
+	if (!mult)
+		mult=1;
+
+	if (sr) {
+		/* Valid range is 3-75 so normalise */
+		if (srvsel < 3) srvsel = 3;
+		if (srvsel > 75) srvsel = 75;
+		srvsel -= 3;
+
+		//voltage = pmic->info[id]->table[srvsel] * 100;
+		voltage = (srvsel * 125 + 6000) * 100;
+	} else {
+
+		/* Valid range is 3-75 so normalise */
+		if (opvsel < 3) opvsel = 3;
+		if (opvsel > 75) opvsel = 75;
+		opvsel -= 3;
+
+		//voltage = pmic->info[id]->table[opvsel] * 100;
+		voltage = (opvsel * 125 + 6000) * 100;
+	}
+
+	voltage *= mult;
+
+	return voltage;
+}
+
+static int tps65910_get_voltage(struct regulator_dev *dev)
+{
+	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
+	int reg, value, id = rdev_get_id(dev), voltage = 0;
+
+	reg = tps65910_get_ctrl_register(id);
+	if (reg < 0)
+		return reg;
+
+	value = tps65910_reg_read(pmic, reg);
+	if (value < 0)
+		return value;
+
+	switch (id) {
+	case TPS65910_REG_VIO:
+	case TPS65910_REG_VDIG1:
+	case TPS65910_REG_VDIG2:
+	case TPS65910_REG_VPLL:
+	case TPS65910_REG_VDAC:
+	case TPS65910_REG_VAUX1:
+	case TPS65910_REG_VAUX2:
+	case TPS65910_REG_VAUX33:
+	case TPS65910_REG_VMMC:
+		value &= LDO_SEL_MASK;
+		value >>= LDO_SEL_SHIFT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	voltage = pmic->info[id]->table[value] * 1000;
+
+	return voltage;
+}
+
+static int tps65910_get_voltage_vdd3(struct regulator_dev *dev)
+{
+	return 5 * 1000 * 1000;
+}
+
+static int tps65910_set_voltage_dcdc(struct regulator_dev *dev,
+				unsigned selector)
+{
+	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
+	int reg, id = rdev_get_id(dev), vsel;
+	int dcdc_mult;
+
+	/* Split vsel into appropriate registers */
+	dcdc_mult = (selector / VDD1_2_NUM_VOLTS) + 1;
+	if (dcdc_mult == 1) dcdc_mult--;
+
+	vsel = (selector % VDD1_2_NUM_VOLTS) + 3;
+
+	if (id == TPS65910_REG_VDD1) {
+		reg = tps65910_reg_read(pmic, TPS65910_VDD1);
+		reg &= ~VDD1_VGAIN_SEL_MASK;
+		reg |= (dcdc_mult << VDD1_VGAIN_SEL_SHIFT);
+		tps65910_reg_write(pmic, TPS65910_VDD1, reg);
+		tps65910_reg_write(pmic, TPS65910_VDD1_OP, vsel);
+	} else {
+		reg = tps65910_reg_read(pmic, TPS65910_VDD2);
+		reg &= ~VDD2_VGAIN_SEL_MASK;
+		reg |= dcdc_mult << VDD2_VGAIN_SEL_SHIFT;
+		tps65910_reg_write(pmic, TPS65910_VDD2, reg);
+		tps65910_reg_write(pmic, TPS65910_VDD2_OP, vsel);
+	}
+
+	return 0;
+}
+
+static int tps65910_set_voltage(struct regulator_dev *dev, unsigned selector)
+{
+	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
+	int reg, value, id = rdev_get_id(dev);
+
+	reg = tps65910_get_ctrl_register(id);
+	if (reg < 0)
+		return reg;
+
+	value = tps65910_reg_read(pmic, reg);
+	if (value < 0)
+		return value;
+
+	switch (id) {
+	case TPS65910_REG_VIO:
+	case TPS65910_REG_VDIG1:
+	case TPS65910_REG_VDIG2:
+	case TPS65910_REG_VPLL:
+	case TPS65910_REG_VDAC:
+	case TPS65910_REG_VAUX1:
+	case TPS65910_REG_VAUX2:
+	case TPS65910_REG_VAUX33:
+	case TPS65910_REG_VMMC:
+		value &= ~(LDO_SEL_MASK);
+		value |= (selector << LDO_SEL_SHIFT);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return tps65910_reg_write(pmic, reg, value);
+}
+
+static int tps65910_list_voltage_dcdc(struct regulator_dev *dev,
+					unsigned selector)
+{
+	int mult, volt;
+
+	mult = (selector / VDD1_2_NUM_VOLTS) + 1;
+
+	volt = VDD1_2_MIN_VOLT + ((selector % VDD1_2_NUM_VOLTS) * VDD1_2_OFFSET);
+
+	return  volt * 100 * mult;
+}
+
+static int tps65910_list_voltage(struct regulator_dev *dev,
+					unsigned selector)
+{
+	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev), voltage;
+
+	if (id < TPS65910_REG_VIO || id > TPS65910_REG_VMMC)
+		return -EINVAL;
+
+	if (selector >= pmic->info[id]->table_len)
+		return -EINVAL;
+	else
+		voltage = pmic->info[id]->table[selector] * 1000;
+
+	return voltage;
+}
+
+/* Regulator ops (except VRTC) */
+static struct regulator_ops tps65910_ops_dcdc = {
+	.is_enabled		= tps65910_is_enabled,
+	.enable			= tps65910_enable,
+	.disable		= tps65910_disable,
+	.set_mode		= tps65910_set_mode,
+	.get_mode		= tps65910_get_mode,
+	.get_voltage		= tps65910_get_voltage_dcdc,
+	.set_voltage_sel	= tps65910_set_voltage_dcdc,
+	.list_voltage		= tps65910_list_voltage_dcdc,
+};
+
+static struct regulator_ops tps65910_ops_vdd3 = {
+	.is_enabled		= tps65910_is_enabled,
+	.enable			= tps65910_enable,
+	.disable		= tps65910_disable,
+	.set_mode		= tps65910_set_mode,
+	.get_mode		= tps65910_get_mode,
+	.get_voltage		= tps65910_get_voltage_vdd3,
+	.list_voltage		= tps65910_list_voltage,
+};
+
+static struct regulator_ops tps65910_ops = {
+	.is_enabled		= tps65910_is_enabled,
+	.enable			= tps65910_enable,
+	.disable		= tps65910_disable,
+	.set_mode		= tps65910_set_mode,
+	.get_mode		= tps65910_get_mode,
+	.get_voltage		= tps65910_get_voltage,
+	.set_voltage_sel	= tps65910_set_voltage,
+	.list_voltage		= tps65910_list_voltage,
+};
+
+static __devinit int tps65910_probe(struct platform_device *pdev)
+{
+	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
+	struct tps_info *info = tps65910_regs;
+	struct regulator_init_data *reg_data;
+	struct regulator_dev *rdev;
+	struct tps65910_reg *pmic;
+	struct tps65910_board *pmic_plat_data;
+	static int desc_id;
+	int i, err;
+	u8 reg;
+
+	pmic_plat_data = dev_get_platdata(tps65910->dev);
+	if (!pmic_plat_data)
+		return -EINVAL;
+
+	reg_data = pmic_plat_data->tps65910_pmic_init_data;
+
+	pmic = kzalloc(sizeof(*pmic), GFP_KERNEL);
+	if (!pmic)
+		return -ENOMEM;
+
+	mutex_init(&pmic->mutex);
+	pmic->mfd = tps65910;
+	platform_set_drvdata(pdev, pmic);
+
+	/* Give control of all register to control port */
+	reg = tps65910_reg_read(pmic, TPS65910_DEVCTRL);
+	reg |= DEVCTRL_SR_CTL_I2C_SEL_MASK;
+	tps65910_reg_write(pmic, TPS65910_DEVCTRL, reg);
+
+	for (i = 0; i < TPS65910_NUM_REGULATOR; i++, info++, reg_data++) {
+		/* Register the regulators */
+		pmic->info[i] = info;
+
+		pmic->desc[i].name = info->name;
+		pmic->desc[i].id = desc_id++;
+		pmic->desc[i].n_voltages = info->table_len;
+
+		if ((i == TPS65910_REG_VDD1) || (i == TPS65910_REG_VDD2))
+			pmic->desc[i].ops = &tps65910_ops_dcdc;
+		else if (i == TPS65910_REG_VDD3)
+			pmic->desc[i].ops = &tps65910_ops_vdd3;
+		else
+			pmic->desc[i].ops = &tps65910_ops;
+
+		pmic->desc[i].type = REGULATOR_VOLTAGE;
+		pmic->desc[i].owner = THIS_MODULE;
+
+		rdev = regulator_register(&pmic->desc[i],
+				tps65910->dev, reg_data, pmic);
+		if (IS_ERR(rdev)) {
+			dev_err(tps65910->dev,
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
+static int __devexit tps65910_remove(struct platform_device *pdev)
+{
+	struct tps65910_reg *tps65910_reg = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < TPS65910_NUM_REGULATOR; i++)
+		regulator_unregister(tps65910_reg->rdev[i]);
+
+	kfree(tps65910_reg);
+	return 0;
+}
+
+static struct platform_driver tps65910_driver = {
+	.driver = {
+		.name = "tps65910-pmic",
+		.owner = THIS_MODULE,
+	},
+	.probe = tps65910_probe,
+	.remove = __devexit_p(tps65910_remove),
+};
+
+static int __init tps65910_init(void)
+{
+	return platform_driver_register(&tps65910_driver);
+}
+subsys_initcall(tps65910_init);
+
+static void __exit tps65910_cleanup(void)
+{
+	platform_driver_unregister(&tps65910_driver);
+}
+module_exit(tps65910_cleanup);
+
+MODULE_AUTHOR("Graeme Gregory <gg@slimlogic.co.uk>");
+MODULE_DESCRIPTION("TPS6507x voltage regulator driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:tps65910-pmic");
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index afc1896..fcff625 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -215,12 +215,26 @@
 #define VDD2_SR_SEL_SHIFT				0
 
 
+/*Registers VDD1, VDD2 voltage values definitions */
+#define VDD1_2_NUM_VOLTS				73
+#define VDD1_2_MIN_VOLT					60000
+#define VDD1_2_OFFSET					125
+
+
 /*Register VDD3  (0x80) register.RegisterDescription */
 #define VDD3_CKINEN_MASK				0x04
 #define VDD3_CKINEN_SHIFT				2
 #define VDD3_ST_MASK					0x03
 #define VDD3_ST_SHIFT					0
 
+/*Registers VDIG (0x80) to VDAC register.RegisterDescription */
+#define LDO_SEL_MASK					0x0C
+#define LDO_SEL_SHIFT					2
+#define LDO_ST_MASK					0x03
+#define LDO_ST_SHIFT					0
+#define LDO_ST_ON_BIT					0x01
+#define LDO_ST_MODE_BIT					0x02	
+
 
 /*Register VDIG1  (0x80) register.RegisterDescription */
 #define VDIG1_SEL_MASK					0x0C
-- 
1.7.1

