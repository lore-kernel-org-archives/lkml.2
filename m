Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab2ENCHF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:07:05 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:59189 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab2ENCGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:06:17 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        b-cousson@ti.com, linux-omap@vger.kernel.org,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 3/4] REGULATOR: regulator driver for Palmas series chips
Date: Mon, 14 May 2012 10:58:31 +0900
Message-Id: <1336960712-2812-4-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336960712-2812-1-git-send-email-gg@slimlogic.co.uk>
References: <1336960712-2812-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas has both Switched Mode (SMPS) and Linear (LDO) regulators in it.
This regulator driver allows software control of these regulators.

The regulators available on Palmas series chips vary depending on the muxing.
This is handled automatically in the driver by reading the mux info from OTP.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/mfd/palmas.c                 |    8 +
 drivers/regulator/palmas-regulator.c |  908 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/palmas.h           |  207 ++++++++
 3 files changed, 1123 insertions(+)
 create mode 100644 drivers/regulator/palmas-regulator.c

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 640ce4c..5dff45b 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -23,7 +23,15 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/palmas.h>
 
+enum palmas_ids {
+	PALMAS_PMIC_ID,
+};
+
 static const struct mfd_cell palmas_children[] = {
+	{
+		.name = "palmas-pmic",
+		.id = PALMAS_PMIC_ID,
+	},
 };
 
 static const struct regmap_config palmas_regmap_config[PALMAS_NUM_CLIENTS] = {
diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
new file mode 100644
index 0000000..1ed958f
--- /dev/null
+++ b/drivers/regulator/palmas-regulator.c
@@ -0,0 +1,908 @@
+/*
+ * Driver for Regulator part of Palmas PMIC Chips
+ *
+ * Copyright 2011-2012 Texas Instruments Inc.
+ *
+ * Author: Graeme Gregory <gg@slimlogic.co.uk>
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
+#include <linux/slab.h>
+#include <linux/regmap.h>
+#include <linux/mfd/palmas.h>
+
+struct regs_info {
+	char	*name;
+	u8	vsel_addr;
+	u8	ctrl_addr;
+	u8	tstep_addr;
+};
+
+static struct regs_info palmas_regs_info[] = {
+	{
+		.name		= "SMPS12",
+		.vsel_addr	= PALMAS_SMPS12_VOLTAGE,
+		.ctrl_addr	= PALMAS_SMPS12_CTRL,
+		.tstep_addr	= PALMAS_SMPS12_TSTEP,
+	},
+	{
+		.name		= "SMPS123",
+		.vsel_addr	= PALMAS_SMPS12_VOLTAGE,
+		.ctrl_addr	= PALMAS_SMPS12_CTRL,
+		.tstep_addr	= PALMAS_SMPS12_TSTEP,
+	},
+	{
+		.name		= "SMPS3",
+		.vsel_addr	= PALMAS_SMPS3_VOLTAGE,
+		.ctrl_addr	= PALMAS_SMPS3_CTRL,
+	},
+	{
+		.name		= "SMPS45",
+		.vsel_addr	= PALMAS_SMPS45_VOLTAGE,
+		.ctrl_addr	= PALMAS_SMPS45_CTRL,
+		.tstep_addr	= PALMAS_SMPS45_TSTEP,
+	},
+	{
+		.name		= "SMPS457",
+		.vsel_addr	= PALMAS_SMPS45_VOLTAGE,
+		.ctrl_addr	= PALMAS_SMPS45_CTRL,
+		.tstep_addr	= PALMAS_SMPS45_TSTEP,
+	},
+	{
+		.name		= "SMPS6",
+		.vsel_addr	= PALMAS_SMPS6_VOLTAGE,
+		.ctrl_addr	= PALMAS_SMPS6_CTRL,
+		.tstep_addr	= PALMAS_SMPS6_TSTEP,
+	},
+	{
+		.name		= "SMPS7",
+		.vsel_addr	= PALMAS_SMPS7_VOLTAGE,
+		.ctrl_addr	= PALMAS_SMPS7_CTRL,
+	},
+	{
+		.name		= "SMPS8",
+		.vsel_addr	= PALMAS_SMPS8_VOLTAGE,
+		.ctrl_addr	= PALMAS_SMPS8_CTRL,
+		.tstep_addr	= PALMAS_SMPS8_TSTEP,
+	},
+	{
+		.name		= "SMPS9",
+		.vsel_addr	= PALMAS_SMPS9_VOLTAGE,
+		.ctrl_addr	= PALMAS_SMPS9_CTRL,
+	},
+	{
+		.name		= "SMPS10",
+	},
+	{
+		.name		= "LDO1",
+		.vsel_addr	= PALMAS_LDO1_VOLTAGE,
+		.ctrl_addr	= PALMAS_LDO1_CTRL,
+	},
+	{
+		.name		= "LDO2",
+		.vsel_addr	= PALMAS_LDO2_VOLTAGE,
+		.ctrl_addr	= PALMAS_LDO2_CTRL,
+	},
+	{
+		.name		= "LDO3",
+		.vsel_addr	= PALMAS_LDO3_VOLTAGE,
+		.ctrl_addr	= PALMAS_LDO3_CTRL,
+	},
+	{
+		.name		= "LDO4",
+		.vsel_addr	= PALMAS_LDO4_VOLTAGE,
+		.ctrl_addr	= PALMAS_LDO4_CTRL,
+	},
+	{
+		.name		= "LDO5",
+		.vsel_addr	= PALMAS_LDO5_VOLTAGE,
+		.ctrl_addr	= PALMAS_LDO5_CTRL,
+	},
+	{
+		.name		= "LDO6",
+		.vsel_addr	= PALMAS_LDO6_VOLTAGE,
+		.ctrl_addr	= PALMAS_LDO6_CTRL,
+	},
+	{
+		.name		= "LDO7",
+		.vsel_addr	= PALMAS_LDO7_VOLTAGE,
+		.ctrl_addr	= PALMAS_LDO7_CTRL,
+	},
+	{
+		.name		= "LDO8",
+		.vsel_addr	= PALMAS_LDO8_VOLTAGE,
+		.ctrl_addr	= PALMAS_LDO8_CTRL,
+	},
+	{
+		.name		= "LDO9",
+		.vsel_addr	= PALMAS_LDO9_VOLTAGE,
+		.ctrl_addr	= PALMAS_LDO9_CTRL,
+	},
+	{
+		.name		= "LDOLN",
+		.vsel_addr	= PALMAS_LDOLN_VOLTAGE,
+		.ctrl_addr	= PALMAS_LDOLN_CTRL,
+	},
+	{
+		.name		= "LDOUSB",
+		.vsel_addr	= PALMAS_LDOUSB_VOLTAGE,
+		.ctrl_addr	= PALMAS_LDOUSB_CTRL,
+	},
+};
+
+#define SMPS_CTRL_MODE_OFF		0x00
+#define SMPS_CTRL_MODE_ON		0x01
+#define SMPS_CTRL_MODE_ECO		0x02
+#define SMPS_CTRL_MODE_PWM		0x03
+
+/* These values are derived from the data sheet. And are the number of steps
+ * where there is a voltage change, the ranges at beginning and end of register
+ * max/min values where there are no change are ommitted.
+ *
+ * So they are basically (maxV-minV)/stepV
+ */
+#define PALMAS_SMPS_NUM_VOLTAGES	116
+#define PALMAS_SMPS10_NUM_VOLTAGES	2
+#define PALMAS_LDO_NUM_VOLTAGES		50
+
+#define SMPS10_VSEL			(1<<3)
+#define SMPS10_BOOST_EN			(1<<2)
+#define SMPS10_BYPASS_EN		(1<<1)
+#define SMPS10_SWITCH_EN		(1<<0)
+
+static int palmas_smps_read(struct palmas *palmas, unsigned int reg,
+		unsigned int *dest)
+{
+	int slave;
+	unsigned int addr;
+
+	slave = PALMAS_BASE_TO_SLAVE(PALMAS_SMPS_BASE);
+	addr = PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE, reg);
+
+	return regmap_read(palmas->regmap[slave], addr, dest);
+}
+
+static int palmas_smps_write(struct palmas *palmas, unsigned int reg,
+		unsigned int value)
+{
+	int slave;
+	unsigned int addr;
+
+	slave = PALMAS_BASE_TO_SLAVE(PALMAS_SMPS_BASE);
+	addr = PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE, reg);
+
+	return regmap_write(palmas->regmap[slave], addr, value);
+}
+
+static int palmas_ldo_read(struct palmas *palmas, unsigned int reg,
+		unsigned int *dest)
+{
+	int slave;
+	unsigned int addr;
+
+	slave = PALMAS_BASE_TO_SLAVE(PALMAS_LDO_BASE);
+	addr = PALMAS_BASE_TO_REG(PALMAS_LDO_BASE, reg);
+
+	return regmap_read(palmas->regmap[slave], addr, dest);
+}
+
+static int palmas_ldo_write(struct palmas *palmas, unsigned int reg,
+		unsigned int value)
+{
+	int slave;
+	unsigned int addr;
+
+	slave = PALMAS_BASE_TO_SLAVE(PALMAS_LDO_BASE);
+	addr = PALMAS_BASE_TO_REG(PALMAS_LDO_BASE, reg);
+
+	return regmap_write(palmas->regmap[slave], addr, value);
+}
+
+static int palmas_is_enabled_smps(struct regulator_dev *dev)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	unsigned int reg;
+
+	palmas_smps_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
+
+	reg &= SMPS12_CTRL_STATUS_MASK;
+	reg >>= SMPS12_CTRL_STATUS_SHIFT;
+
+	return !!(reg);
+}
+
+static int palmas_enable_smps(struct regulator_dev *dev)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	unsigned int reg;
+
+	palmas_smps_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
+
+	reg &= ~SMPS12_CTRL_MODE_ACTIVE_MASK;
+	reg |= SMPS_CTRL_MODE_ON;
+
+	palmas_smps_write(pmic->palmas, palmas_regs_info[id].ctrl_addr, reg);
+
+	return 0;
+}
+
+static int palmas_disable_smps(struct regulator_dev *dev)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	unsigned int reg;
+
+	palmas_smps_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
+
+	reg &= ~SMPS12_CTRL_MODE_ACTIVE_MASK;
+
+	palmas_smps_write(pmic->palmas, palmas_regs_info[id].ctrl_addr, reg);
+
+	return 0;
+}
+
+
+static int palmas_set_mode_smps(struct regulator_dev *dev, unsigned int mode)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	unsigned int reg;
+
+	palmas_smps_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
+	reg &= ~SMPS12_CTRL_STATUS_MASK;
+	reg >>= SMPS12_CTRL_STATUS_SHIFT;
+
+	switch (mode) {
+	case REGULATOR_MODE_NORMAL:
+		reg |= SMPS_CTRL_MODE_ON;
+		break;
+	case REGULATOR_MODE_IDLE:
+		reg |= SMPS_CTRL_MODE_ECO;
+		break;
+	case REGULATOR_MODE_FAST:
+		reg |= SMPS_CTRL_MODE_PWM;
+		break;
+	default:
+		return -EINVAL;
+	}
+	palmas_smps_write(pmic->palmas, palmas_regs_info[id].ctrl_addr, reg);
+
+	return 0;
+}
+
+static unsigned int palmas_get_mode_smps(struct regulator_dev *dev)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	unsigned int reg;
+
+	palmas_smps_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
+	reg &= SMPS12_CTRL_STATUS_MASK;
+	reg >>= SMPS12_CTRL_STATUS_SHIFT;
+
+	switch (reg) {
+	case SMPS_CTRL_MODE_ON:
+		return REGULATOR_MODE_NORMAL;
+	case SMPS_CTRL_MODE_ECO:
+		return REGULATOR_MODE_IDLE;
+	case SMPS_CTRL_MODE_PWM:
+		return REGULATOR_MODE_FAST;
+	}
+
+	return 0;
+}
+
+static int palmas_list_voltage_smps(struct regulator_dev *dev,
+					unsigned selector)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	int mult = 1;
+
+	if (!selector)
+		return 0;
+
+	/* Read the multiplier set in VSEL register to return
+	 * the correct voltage.
+	 */
+	if (pmic->range[id])
+		mult = 2;
+
+	/* Voltage is (0.49V + (selector * 0.01V)) * RANGE
+	 * as defined in data sheet. RANGE is either x1 or x2
+	 */
+	return  (490000 + (selector * 10000)) * mult;
+}
+
+static int palmas_get_voltage_smps(struct regulator_dev *dev)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	int selector;
+	unsigned int reg;
+	unsigned int addr;
+
+	addr = palmas_regs_info[id].vsel_addr;
+
+	palmas_smps_read(pmic->palmas, addr, &reg);
+
+	selector = reg & SMPS12_VOLTAGE_VSEL_MASK;
+
+	/* Adjust selector to match list_voltage ranges */
+	if ((selector > 0) && (selector < 6))
+		selector = 6;
+	if (!selector)
+		selector = 5;
+	if (selector > 121)
+		selector = 121;
+	selector -= 5;
+
+	return palmas_list_voltage_smps(dev, selector);
+}
+
+static int palmas_set_voltage_smps_sel(struct regulator_dev *dev,
+		unsigned selector)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	unsigned int reg = 0;
+	unsigned int addr;
+
+	addr = palmas_regs_info[id].vsel_addr;
+
+	/* Make sure we don't change the value of RANGE */
+	if (pmic->range[id])
+		reg |= SMPS12_VOLTAGE_RANGE;
+
+	/* Adjust the linux selector into range used in VSEL register */
+	if (selector)
+		reg |= selector + 5;
+
+	palmas_smps_write(pmic->palmas, addr, reg);
+
+	return 0;
+}
+
+static struct regulator_ops palmas_ops_smps = {
+	.is_enabled		= palmas_is_enabled_smps,
+	.enable			= palmas_enable_smps,
+	.disable		= palmas_disable_smps,
+	.set_mode		= palmas_set_mode_smps,
+	.get_mode		= palmas_get_mode_smps,
+	.get_voltage		= palmas_get_voltage_smps,
+	.set_voltage_sel	= palmas_set_voltage_smps_sel,
+	.list_voltage		= palmas_list_voltage_smps,
+};
+
+static int palmas_is_enabled_smps10(struct regulator_dev *dev)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	unsigned int reg;
+
+	palmas_smps_read(pmic->palmas, PALMAS_SMPS10_STATUS, &reg);
+
+	reg &= SMPS10_BOOST_EN;
+
+	return !!(reg);
+}
+
+static int palmas_enable_smps10(struct regulator_dev *dev)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	unsigned int reg;
+
+	palmas_smps_read(pmic->palmas, PALMAS_SMPS10_CTRL, &reg);
+
+	reg &= ~SMPS10_BOOST_EN;
+	reg |= SMPS10_BOOST_EN;
+
+	palmas_smps_write(pmic->palmas, PALMAS_SMPS10_CTRL, reg);
+
+	return 0;
+}
+
+static int palmas_disable_smps10(struct regulator_dev *dev)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	unsigned int reg;
+
+	palmas_smps_read(pmic->palmas, PALMAS_SMPS10_CTRL, &reg);
+
+	reg &= ~SMPS10_BOOST_EN;
+
+	palmas_smps_write(pmic->palmas, PALMAS_SMPS10_CTRL, reg);
+
+	return 0;
+}
+
+static int palmas_list_voltage_smps10(struct regulator_dev *dev,
+					unsigned selector)
+{
+	if (selector)
+		return 5000000;
+
+	return 3750000;
+}
+
+static int palmas_get_voltage_smps10(struct regulator_dev *dev)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int selector;
+	unsigned int reg;
+
+	palmas_smps_read(pmic->palmas, PALMAS_SMPS10_CTRL, &reg);
+
+	selector = (reg & SMPS10_VSEL) >> 3;
+
+	return palmas_list_voltage_smps10(dev, selector);
+}
+
+static int palmas_set_voltage_smps10_sel(struct regulator_dev *dev,
+		unsigned selector)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	unsigned int reg = 0;
+
+	palmas_smps_read(pmic->palmas, PALMAS_SMPS10_CTRL, &reg);
+
+	if (selector)
+		reg |= SMPS10_VSEL;
+	else
+		reg &= ~SMPS10_VSEL;
+
+	palmas_smps_write(pmic->palmas, PALMAS_SMPS10_CTRL, reg);
+
+	return 0;
+}
+
+static struct regulator_ops palmas_ops_smps10 = {
+	.is_enabled		= palmas_is_enabled_smps10,
+	.enable			= palmas_enable_smps10,
+	.disable		= palmas_disable_smps10,
+	.get_voltage		= palmas_get_voltage_smps10,
+	.set_voltage_sel	= palmas_set_voltage_smps10_sel,
+	.list_voltage		= palmas_list_voltage_smps10,
+};
+
+static int palmas_is_enabled_ldo(struct regulator_dev *dev)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	unsigned int reg;
+
+	palmas_ldo_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
+
+	reg &= LDO1_CTRL_STATUS;
+
+	return !!(reg);
+}
+
+static int palmas_enable_ldo(struct regulator_dev *dev)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	unsigned int reg;
+
+	palmas_ldo_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
+
+	reg |= LDO1_CTRL_MODE_ACTIVE;
+
+	palmas_ldo_write(pmic->palmas, palmas_regs_info[id].ctrl_addr, reg);
+
+	return 0;
+}
+
+static int palmas_disable_ldo(struct regulator_dev *dev)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	unsigned int reg;
+
+	palmas_ldo_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
+
+	reg &= ~LDO1_CTRL_MODE_ACTIVE;
+
+	palmas_ldo_write(pmic->palmas, palmas_regs_info[id].ctrl_addr, reg);
+
+	return 0;
+}
+
+static int palmas_list_voltage_ldo(struct regulator_dev *dev,
+					unsigned selector)
+{
+	if (!selector)
+		return 0;
+
+	/* voltage is 0.85V + (selector * 0.05v) */
+	return  850000 + (selector * 50000);
+}
+
+static int palmas_get_voltage_ldo(struct regulator_dev *dev)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	int selector;
+	unsigned int reg;
+	unsigned int addr;
+
+	addr = palmas_regs_info[id].vsel_addr;
+
+	palmas_ldo_read(pmic->palmas, addr, &reg);
+
+	selector = reg & LDO1_VOLTAGE_VSEL_MASK;
+
+	/* Adjust selector to match list_voltage ranges */
+	if (selector > 49)
+		selector = 49;
+
+	return palmas_list_voltage_ldo(dev, selector);
+}
+
+static int palmas_set_voltage_ldo_sel(struct regulator_dev *dev,
+		unsigned selector)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	unsigned int reg = 0;
+	unsigned int addr;
+
+	addr = palmas_regs_info[id].vsel_addr;
+
+	reg = selector;
+
+	palmas_ldo_write(pmic->palmas, addr, reg);
+
+	return 0;
+}
+
+/*
+ * setup the hardware based sleep configuration of the SMPS/LDO regulators
+ * from the platform data. This is different to the software based control
+ * supported by the regulator framework as it is controlled by toggling
+ * pins on the PMIC such as PREQ, SYSEN, ...
+ */
+static int palmas_smps_init(struct palmas *palmas, int id,
+		struct palmas_reg_init *reg_init)
+{
+	unsigned int reg;
+	unsigned int addr;
+	int ret;
+
+	addr = palmas_regs_info[id].ctrl_addr;
+
+	ret = palmas_smps_read(palmas, addr, &reg);
+	if (ret)
+		return ret;
+
+	if (id != PALMAS_REG_SMPS10) {
+		if (reg_init->warm_reset)
+			reg |= SMPS12_CTRL_WR_S;
+
+		if (reg_init->roof_floor)
+			reg |= SMPS12_CTRL_ROOF_FLOOR_EN;
+
+		if (reg_init->mode_sleep) {
+			reg &= ~SMPS12_CTRL_MODE_SLEEP_MASK;
+			reg |= reg_init->mode_sleep <<
+					SMPS12_CTRL_MODE_SLEEP_SHIFT;
+		}
+	} else {
+		if (reg_init->mode_sleep) {
+			reg &= ~SMPS10_CTRL_MODE_SLEEP_MASK;
+			reg |= reg_init->mode_sleep <<
+					SMPS10_CTRL_MODE_SLEEP_SHIFT;
+		}
+
+	}
+	ret = palmas_smps_write(palmas, addr, reg);
+	if (ret)
+		return ret;
+
+	if (palmas_regs_info[id].tstep_addr && reg_init->tstep) {
+		addr = palmas_regs_info[id].tstep_addr;
+
+		reg = reg_init->tstep & SMPS12_TSTEP_TSTEP_MASK;
+
+		ret = palmas_smps_write(palmas, addr, reg);
+		if (ret)
+			return ret;
+	}
+
+	if (palmas_regs_info[id].vsel_addr && reg_init->vsel) {
+		addr = palmas_regs_info[id].vsel_addr;
+
+		reg = reg_init->vsel;
+
+		ret = palmas_smps_write(palmas, addr, reg);
+		if (ret)
+			return ret;
+	}
+
+
+	return 0;
+}
+
+static int palmas_ldo_init(struct palmas *palmas, int id,
+		struct palmas_reg_init *reg_init)
+{
+	unsigned int reg;
+	unsigned int addr;
+	int ret;
+
+	addr = palmas_regs_info[id].ctrl_addr;
+
+	ret = palmas_smps_read(palmas, addr, &reg);
+	if (ret)
+		return ret;
+
+	if (reg_init->warm_reset)
+		reg |= LDO1_CTRL_WR_S;
+
+	if (reg_init->mode_sleep)
+		reg |= LDO1_CTRL_MODE_SLEEP;
+
+	ret = palmas_smps_write(palmas, addr, reg);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static struct regulator_ops palmas_ops_ldo = {
+	.is_enabled		= palmas_is_enabled_ldo,
+	.enable			= palmas_enable_ldo,
+	.disable		= palmas_disable_ldo,
+	.get_voltage		= palmas_get_voltage_ldo,
+	.set_voltage_sel	= palmas_set_voltage_ldo_sel,
+	.list_voltage		= palmas_list_voltage_ldo,
+};
+
+static __devinit int palmas_probe(struct platform_device *pdev)
+{
+	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
+	struct palmas_pmic_platform_data *pdata = pdev->dev.platform_data;
+	struct regulator_init_data *reg_data;
+	struct regulator_dev *rdev;
+	struct regulator_config config = { };
+	struct palmas_pmic *pmic;
+	struct palmas_reg_init *reg_init;
+	int id = 0, ret;
+	unsigned int addr, reg;
+
+	if (!pdata)
+		return -EINVAL;
+	if (!pdata->reg_data)
+		return -EINVAL;
+
+	pmic = kzalloc(sizeof(*pmic), GFP_KERNEL);
+	if (!pmic)
+		return -ENOMEM;
+
+	pmic->dev = &pdev->dev;
+	pmic->palmas = palmas;
+	palmas->pmic = pmic;
+	platform_set_drvdata(pdev, pmic);
+
+	pmic->desc = kcalloc(PALMAS_NUM_REGS,
+			sizeof(struct regulator_desc), GFP_KERNEL);
+	if (!pmic->desc) {
+		ret = -ENOMEM;
+		goto err_free_pmic;
+	}
+
+	pmic->rdev = kcalloc(PALMAS_NUM_REGS,
+			sizeof(struct regulator_dev *), GFP_KERNEL);
+	if (!pmic->rdev) {
+		ret = -ENOMEM;
+		goto err_free_desc;
+	}
+
+	ret = palmas_smps_read(palmas, PALMAS_SMPS_CTRL, &reg);
+	if (ret)
+		goto err_unregister_regulator;
+
+	if (reg & SMPS_CTRL_SMPS12_SMPS123_EN)
+		pmic->smps123 = 1;
+
+	if (reg & SMPS_CTRL_SMPS45_SMPS457_EN)
+		pmic->smps457 = 1;
+
+	for (id = 0; id < PALMAS_REG_LDO1; id++) {
+
+		/*
+		 * Miss out regulators which are not available due
+		 * to slaving configurations.
+		 */
+		switch (id) {
+		case PALMAS_REG_SMPS12:
+		case PALMAS_REG_SMPS3:
+			if (pmic->smps123)
+				continue;
+			break;
+		case PALMAS_REG_SMPS123:
+			if (!pmic->smps123)
+				continue;
+			break;
+		case PALMAS_REG_SMPS45:
+		case PALMAS_REG_SMPS7:
+			if (pmic->smps457)
+				continue;
+			break;
+		case PALMAS_REG_SMPS457:
+			if (!pmic->smps457)
+				continue;
+		}
+
+		reg_data = pdata->reg_data[id];
+		if (!reg_data)
+			continue;
+
+		/* Register the regulators */
+		pmic->desc[id].name = palmas_regs_info[id].name;
+		pmic->desc[id].id = id;
+
+		if (id != PALMAS_REG_SMPS10) {
+			pmic->desc[id].ops = &palmas_ops_smps;
+			pmic->desc[id].n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
+		} else {
+			pmic->desc[id].n_voltages = PALMAS_SMPS10_NUM_VOLTAGES;
+			pmic->desc[id].ops = &palmas_ops_smps10;
+		}
+
+		pmic->desc[id].type = REGULATOR_VOLTAGE;
+		pmic->desc[id].owner = THIS_MODULE;
+
+		/* Initialise sleep/init values from platform data */
+		if (pdata->reg_init) {
+			reg_init = pdata->reg_init[id];
+			if (reg_init) {
+				ret = palmas_smps_init(palmas, id, reg_init);
+				if (ret)
+					goto err_unregister_regulator;
+			}
+		}
+
+		/*
+		 * read and store the RANGE bit for later use
+		 * This must be done before regulator is probed otherwise
+		 * we error in probe with unsuportable ranges.
+		 */
+		if (id != PALMAS_REG_SMPS10) {
+			addr = palmas_regs_info[id].vsel_addr;
+
+			ret = palmas_smps_read(pmic->palmas, addr, &reg);
+			if (ret)
+				goto err_unregister_regulator;
+			if (reg & SMPS12_VOLTAGE_RANGE)
+				pmic->range[id] = 1;
+		}
+
+		config.dev = &pdev->dev;
+		config.init_data = reg_data;
+		config.driver_data = pmic;
+
+		rdev = regulator_register(&pmic->desc[id], &config);
+		if (IS_ERR(rdev)) {
+			dev_err(&pdev->dev,
+				"failed to register %s regulator\n",
+				pdev->name);
+			ret = PTR_ERR(rdev);
+			goto err_unregister_regulator;
+		}
+
+		/* Save regulator for cleanup */
+		pmic->rdev[id] = rdev;
+	}
+
+	/* Start this loop from the id left from previous loop */
+	for (; id < PALMAS_NUM_REGS; id++) {
+
+		/* Miss out regulators which are not available due
+		 * to alternate functions.
+		 */
+
+		reg_data = pdata->reg_data[id];
+
+		/* Register the regulators */
+		pmic->desc[id].name = palmas_regs_info[id].name;
+		pmic->desc[id].id = id;
+		pmic->desc[id].n_voltages = PALMAS_LDO_NUM_VOLTAGES;
+
+		pmic->desc[id].ops = &palmas_ops_ldo;
+
+		pmic->desc[id].type = REGULATOR_VOLTAGE;
+		pmic->desc[id].owner = THIS_MODULE;
+
+		config.dev = &pdev->dev;
+		config.init_data = reg_data;
+		config.driver_data = pmic;
+
+		rdev = regulator_register(&pmic->desc[id], &config);
+		if (IS_ERR(rdev)) {
+			dev_err(&pdev->dev,
+				"failed to register %s regulator\n",
+				pdev->name);
+			ret = PTR_ERR(rdev);
+			goto err_unregister_regulator;
+		}
+
+		/* Save regulator for cleanup */
+		pmic->rdev[id] = rdev;
+
+		/* Initialise sleep/init values from platform data */
+		if (pdata->reg_init) {
+			reg_init = pdata->reg_init[id];
+			if (reg_init) {
+				ret = palmas_ldo_init(palmas, id, reg_init);
+				if (ret)
+					goto err_unregister_regulator;
+			}
+		}
+	}
+
+	return 0;
+
+err_unregister_regulator:
+	while (--id >= 0)
+		regulator_unregister(pmic->rdev[id]);
+	kfree(pmic->rdev);
+err_free_desc:
+	kfree(pmic->desc);
+err_free_pmic:
+	kfree(pmic);
+	return ret;
+}
+
+static int __devexit palmas_remove(struct platform_device *pdev)
+{
+	struct palmas_pmic *pmic = platform_get_drvdata(pdev);
+	int id;
+
+	for (id = 0; id < PALMAS_NUM_REGS; id++)
+		regulator_unregister(pmic->rdev[id]);
+
+	kfree(pmic->rdev);
+	kfree(pmic->desc);
+	kfree(pmic);
+	return 0;
+}
+
+static struct platform_driver palmas_driver = {
+	.driver = {
+		.name = "palmas-pmic",
+		.owner = THIS_MODULE,
+	},
+	.probe = palmas_probe,
+	.remove = __devexit_p(palmas_remove),
+};
+
+static int __init palmas_init(void)
+{
+	return platform_driver_register(&palmas_driver);
+}
+subsys_initcall(palmas_init);
+
+static void __exit palmas_exit(void)
+{
+	platform_driver_unregister(&palmas_driver);
+}
+module_exit(palmas_exit);
+
+MODULE_AUTHOR("Graeme Gregory <gg@slimlogic.co.uk>");
+MODULE_DESCRIPTION("Palmas voltage regulator driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:palmas-pmic");
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 45130a0..43603f2 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -24,6 +24,8 @@
 
 #define PALMAS_NUM_CLIENTS		3
 
+struct palmas_pmic;
+
 struct palmas {
 	struct device *dev;
 
@@ -38,12 +40,91 @@ struct palmas {
 	u32 irq_mask;
 	struct mutex irq_lock;
 
+	/* Child Devices */
+	struct palmas_pmic *pmic;
+
 	/* GPIO MUXing */
 	u8 gpio_muxed;
 	u8 led_muxed;
 	u8 pwm_muxed;
 };
 
+struct palmas_reg_init {
+	/* warm_rest controls the voltage levels after a warm reset
+	 *
+	 * 0: reload default values from OTP on warm reset
+	 * 1: maintain voltage from VSEL on warm reset
+	 */
+	int warm_reset;
+
+	/* roof_floor controls whether the regulator uses the i2c style
+	 * of DVS or uses the method where a GPIO or other control method is
+	 * attached to the NSLEEP/ENABLE1/ENABLE2 pins
+	 *
+	 * For SMPS
+	 *
+	 * 0: i2c selection of voltage
+	 * 1: pin selection of voltage.
+	 *
+	 * For LDO unused
+	 */
+	int roof_floor;
+
+	/* sleep_mode is the mode loaded to MODE_SLEEP bits as defined in
+	 * the data sheet.
+	 *
+	 * For SMPS
+	 *
+	 * 0: Off
+	 * 1: AUTO
+	 * 2: ECO
+	 * 3: Forced PWM
+	 *
+	 * For LDO
+	 *
+	 * 0: Off
+	 * 1: On
+	 */
+	int mode_sleep;
+
+	/* tstep is the timestep loaded to the TSTEP register
+	 *
+	 * For SMPS
+	 *
+	 * 0: Jump (no slope control)
+	 * 1: 10mV/us
+	 * 2: 5mV/us
+	 * 3: 2.5mV/us
+	 *
+	 * For LDO unused
+	 */
+	int tstep;
+
+	/* voltage_sel is the bitfield loaded onto the SMPSX_VOLTAGE
+	 * register. Set this is the default voltage set in OTP needs
+	 * to be overridden.
+	 */
+	u8 vsel;
+
+};
+
+struct palmas_pmic_platform_data {
+	/* An array of pointers to regulator init data indexed by regulator
+	 * ID
+	 */
+	struct regulator_init_data **reg_data;
+
+	/* An array of pointers to structures containing sleep mode and DVS
+	 * configuration for regulators indexed by ID
+	 */
+	struct palmas_reg_init **reg_init;
+
+	/* use LDO6 for vibrator control */
+	int ldo6_vibrator;
+
+
+};
+
 struct palmas_platform_data {
 	int gpio_base;
 
@@ -56,6 +137,8 @@ struct palmas_platform_data {
 	 */
 	int mux_from_pdata;
 	u8 pad1, pad2;
+
+	struct palmas_pmic_platform_data *pmic_pdata;
 };
 
 /* Define the palmas IRQ numbers */
@@ -103,6 +186,130 @@ enum palmas_irqs {
 int palmas_irq_init(struct palmas *palmas);
 int palmas_irq_exit(struct palmas *palmas);
 
+enum palmas_regulators {
+	/* SMPS regulators */
+	PALMAS_REG_SMPS12,
+	PALMAS_REG_SMPS123,
+	PALMAS_REG_SMPS3,
+	PALMAS_REG_SMPS45,
+	PALMAS_REG_SMPS457,
+	PALMAS_REG_SMPS6,
+	PALMAS_REG_SMPS7,
+	PALMAS_REG_SMPS8,
+	PALMAS_REG_SMPS9,
+	PALMAS_REG_SMPS10,
+	/* LDO regulators */
+	PALMAS_REG_LDO1,
+	PALMAS_REG_LDO2,
+	PALMAS_REG_LDO3,
+	PALMAS_REG_LDO4,
+	PALMAS_REG_LDO5,
+	PALMAS_REG_LDO6,
+	PALMAS_REG_LDO7,
+	PALMAS_REG_LDO8,
+	PALMAS_REG_LDO9,
+	PALMAS_REG_LDOLN,
+	PALMAS_REG_LDOUSB,
+	/* Total number of regulators */
+	PALMAS_NUM_REGS,
+};
+
+/* REGULATOR Exported Functions */
+extern int palmas_set_bypass_smps10(struct palmas *palmas, int bypass);
+extern int palmas_set_switch_smps10(struct palmas *palmas, int sw);
+extern int palmas_set_ldo8_tracking(struct palmas *palmas, int tracking);
+extern int palmas_set_ldo9_bypass(struct palmas *palmas, int bypass);
+
+struct palmas_pmic {
+	struct palmas *palmas;
+	struct device *dev;
+	struct regulator_desc *desc;
+	struct regulator_dev **rdev;
+	struct mutex mutex;
+
+	int smps123;
+	int smps457;
+
+	int range[PALMAS_REG_SMPS10];
+};
+
+struct palmas_resource {
+	struct palmas *palmas;
+	struct device *dev;
+};
+
+/* RESOURCE Exported Functions */
+extern int palmas_enable_regen1(struct palmas_resource *resource);
+extern int palmas_disable_regen1(struct palmas_resource *resource);
+extern int palmas_is_enabled_regen1(struct palmas_resource *resource);
+extern int palmas_enable_regen2(struct palmas_resource *resource);
+extern int palmas_disable_regen2(struct palmas_resource *resource);
+extern int palmas_is_enabled_regen2(struct palmas_resource *resource);
+extern int palmas_enable_sysen1(struct palmas_resource *resource);
+extern int palmas_disable_sysen1(struct palmas_resource *resource);
+extern int palmas_is_enabled_sysen1(struct palmas_resource *resource);
+extern int palmas_enable_sysen2(struct palmas_resource *resource);
+extern int palmas_disable_sysen2(struct palmas_resource *resource);
+extern int palmas_is_enabled_sysen2(struct palmas_resource *resource);
+
+struct palmas_usb {
+	struct palmas *palmas;
+	struct device *dev;
+
+	/* for vbus reporting with irqs disabled */
+	spinlock_t lock;
+
+	struct regulator *vbus_reg;
+
+	/* used to set vbus, in atomic path */
+	struct work_struct set_vbus_work;
+
+	int irq1;
+	int irq2;
+	int irq3;
+	int irq4;
+
+	int vbus_enable;
+
+	u8 linkstat;
+};
+
+#define comparator_to_palmas(x) container_of((x), struct palmas_usb, comparator)
+
+enum usb_irq_events {
+	/* Wakeup events from INT3 */
+	PALMAS_USB_ID_WAKEPUP,
+	PALMAS_USB_VBUS_WAKEUP,
+
+	/* ID_OTG_EVENTS */
+	PALMAS_USB_ID_GND,
+	N_PALMAS_USB_ID_GND,
+	PALMAS_USB_ID_C,
+	N_PALMAS_USB_ID_C,
+	PALMAS_USB_ID_B,
+	N_PALMAS_USB_ID_B,
+	PALMAS_USB_ID_A,
+	N_PALMAS_USB_ID_A,
+	PALMAS_USB_ID_FLOAT,
+	N_PALMAS_USB_ID_FLOAT,
+
+	/* VBUS_OTG_EVENTS */
+	PALMAS_USB_VB_SESS_END,
+	N_PALMAS_USB_VB_SESS_END,
+	PALMAS_USB_VB_SESS_VLD,
+	N_PALMAS_USB_VB_SESS_VLD,
+	PALMAS_USB_VA_SESS_VLD,
+	N_PALMAS_USB_VA_SESS_VLD,
+	PALMAS_USB_VA_VBUS_VLD,
+	N_PALMAS_USB_VA_VBUS_VLD,
+	PALMAS_USB_VADP_SNS,
+	N_PALMAS_USB_VADP_SNS,
+	PALMAS_USB_VADP_PRB,
+	N_PALMAS_USB_VADP_PRB,
+	PALMAS_USB_VOTG_SESS_VLD,
+	N_PALMAS_USB_VOTG_SESS_VLD,
+};
+
 /* defines so we can store the mux settings */
 #define PALMAS_GPIO_0_MUXED					(1 << 0)
 #define PALMAS_GPIO_1_MUXED					(1 << 1)
-- 
1.7.9.5

