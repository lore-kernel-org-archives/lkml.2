Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab2KKPPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 10:15:09 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3252 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab2KKPOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 10:14:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 11 Nov 2012 07:14:44 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <broonie@opensource.wolfsonmicro.com>,
        <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 2/2] regulator: tps80031: add regulator driver for tps80031
Date: Sun, 11 Nov 2012 20:42:01 +0530
Message-ID: <1352646721-8350-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1352646721-8350-1-git-send-email-ldewangan@nvidia.com>
References: <1352646721-8350-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add regulator driver for Texas Instrument TPS80031/TPS80032 device.
TPS80031/ TPS80032 Fully Integrated Power Management with Power
Path and Battery Charger. It has 5 configurable step-down
converters, 11 general purpose LDOs, VBUS generator and digital
output to control regulators.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1: 
- Rewrite dcdc get voltage apis.
- Remove -1 and +1 in vsel.
- Correct the vbus ops for sw and hw based.

Changes from V2:
- Move header file changes to first patch so easy to apply on subsystem tree.

 drivers/regulator/Kconfig              |    9 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/tps80031-regulator.c |  789 ++++++++++++++++++++++++++++++++
 3 files changed, 799 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/tps80031-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index cbc685d..0ae658f 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -426,6 +426,15 @@ config REGULATOR_TPS65912
 	help
 	    This driver supports TPS65912 voltage regulator chip.
 
+config REGULATOR_TPS80031
+	tristate "TI TPS80031/TPS80032 power regualtor driver"
+	depends on MFD_TPS80031
+	help
+	  TPS80031/ TPS80032 Fully Integrated Power Management with Power
+	  Path and Battery Charger. It has 5 configurable step-down
+	  converters, 11 general purpose LDOs, VBUS generator and digital
+	  output to control regulators.
+
 config REGULATOR_TWL4030
 	bool "TI TWL4030/TWL5030/TWL6030/TPS659x0 PMIC"
 	depends on TWL4030_CORE
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index db274dc..6166d12 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_REGULATOR_TPS6524X) += tps6524x-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6586X) += tps6586x-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65912) += tps65912-regulator.o
+obj-$(CONFIG_REGULATOR_TPS80031) += tps80031-regulator.o
 obj-$(CONFIG_REGULATOR_TWL4030) += twl-regulator.o
 obj-$(CONFIG_REGULATOR_VEXPRESS) += vexpress.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-dcdc.o
diff --git a/drivers/regulator/tps80031-regulator.c b/drivers/regulator/tps80031-regulator.c
new file mode 100644
index 0000000..0484478
--- /dev/null
+++ b/drivers/regulator/tps80031-regulator.c
@@ -0,0 +1,789 @@
+/*
+ * tps80031-regulator.c -- TI TPS80031 regulator driver.
+ *
+ * Regulator driver for TITPS80031/TPS80032 Fully Integrated Power
+ * Management with Power Path and Battery Charger.
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
+ *
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307, USA
+ */
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mfd/tps80031.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/slab.h>
+
+/* Flags for DCDC Voltage reading */
+#define DCDC_OFFSET_EN		BIT(0)
+#define DCDC_EXTENDED_EN	BIT(1)
+#define TRACK_MODE_ENABLE	BIT(2)
+
+#define SMPS_MULTOFFSET_VIO	BIT(1)
+#define SMPS_MULTOFFSET_SMPS1	BIT(3)
+#define SMPS_MULTOFFSET_SMPS2	BIT(4)
+#define SMPS_MULTOFFSET_SMPS3	BIT(6)
+#define SMPS_MULTOFFSET_SMPS4	BIT(0)
+
+#define SMPS_CMD_MASK		0xC0
+#define SMPS_VSEL_MASK		0x3F
+#define LDO_VSEL_MASK		0x1F
+#define LDO_TRACK_VSEL_MASK	0x3F
+
+#define MISC2_LDOUSB_IN_VSYS	BIT(4)
+#define MISC2_LDOUSB_IN_PMID	BIT(3)
+#define MISC2_LDOUSB_IN_MASK	0x18
+
+#define MISC2_LDO3_SEL_VIB_VAL	BIT(0)
+#define MISC2_LDO3_SEL_VIB_MASK	0x1
+
+#define BOOST_HW_PWR_EN		BIT(5)
+#define BOOST_HW_PWR_EN_MASK	BIT(5)
+
+#define OPA_MODE_EN		BIT(6)
+#define OPA_MODE_EN_MASK	BIT(6)
+
+#define USB_VBUS_CTRL_SET	0x04
+#define USB_VBUS_CTRL_CLR	0x05
+#define VBUS_DISCHRG		0x20
+
+struct tps80031_regulator_info {
+	/* Regulator register address.*/
+	u8		trans_reg;
+	u8		state_reg;
+	u8		force_reg;
+	u8		volt_reg;
+	u8		volt_id;
+
+	/*Power request bits */
+	int		preq_bit;
+
+	/* used by regulator core */
+	struct regulator_desc	desc;
+
+};
+
+struct tps80031_regulator {
+	struct device			*dev;
+	struct regulator_dev		*rdev;
+	struct tps80031_regulator_info	*rinfo;
+
+	u8				device_flags;
+	unsigned int			config_flags;
+	unsigned int			ext_ctrl_flag;
+};
+
+static inline struct device *to_tps80031_dev(struct regulator_dev *rdev)
+{
+	return rdev_get_dev(rdev)->parent->parent;
+}
+
+static int tps80031_reg_is_enabled(struct regulator_dev *rdev)
+{
+	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
+	struct device *parent = to_tps80031_dev(rdev);
+	u8 reg_val;
+	int ret;
+
+	if (ri->ext_ctrl_flag & EXT_PWR_REQ)
+		return true;
+
+	ret = tps80031_read(parent, SLAVE_ID1, ri->rinfo->state_reg, &reg_val);
+	if (ret < 0) {
+		dev_err(&rdev->dev, "Reg 0x%02x read failed, err = %d\n",
+			ri->rinfo->state_reg, ret);
+		return ret;
+	}
+	return ((reg_val & STATE_MASK) == STATE_ON);
+}
+
+static int tps80031_reg_enable(struct regulator_dev *rdev)
+{
+	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
+	struct device *parent = to_tps80031_dev(rdev);
+	int ret;
+
+	if (ri->ext_ctrl_flag & EXT_PWR_REQ)
+		return 0;
+
+	ret = tps80031_update(parent, SLAVE_ID1, ri->rinfo->state_reg,
+			STATE_ON, STATE_MASK);
+	if (ret < 0) {
+		dev_err(&rdev->dev, "Reg 0x%02x update failed, err = %d\n",
+			ri->rinfo->state_reg, ret);
+		return ret;
+	}
+	return ret;
+}
+
+static int tps80031_reg_disable(struct regulator_dev *rdev)
+{
+	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
+	struct device *parent = to_tps80031_dev(rdev);
+	int ret;
+
+	if (ri->ext_ctrl_flag & EXT_PWR_REQ)
+		return 0;
+
+	ret = tps80031_update(parent, SLAVE_ID1, ri->rinfo->state_reg,
+			STATE_OFF, STATE_MASK);
+	if (ret < 0)
+		dev_err(&rdev->dev, "Reg 0x%02x update failed, err = %d\n",
+			ri->rinfo->state_reg, ret);
+	return ret;
+}
+
+/* DCDC voltages for the selector of 58 to 63 */
+static int tps80031_dcdc_voltages[4][5] = {
+	{ 1350, 1500, 1800, 1900, 2100},
+	{ 1350, 1500, 1800, 1900, 2100},
+	{ 2084, 2315, 2778, 2932, 3241},
+	{ 4167, 2315, 2778, 2932, 3241},
+};
+
+static int tps80031_dcdc_list_voltage(struct regulator_dev *rdev, unsigned sel)
+{
+	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
+	int volt_index = ri->device_flags & 0x3;
+
+	if (sel == 0)
+		return 0;
+	else if (sel < 58)
+		return regulator_list_voltage_linear(rdev, sel - 1);
+	else
+		return tps80031_dcdc_voltages[volt_index][sel - 58] * 1000;
+}
+
+static int tps80031_dcdc_set_voltage_sel(struct regulator_dev *rdev,
+		unsigned vsel)
+{
+	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
+	struct device *parent = to_tps80031_dev(rdev);
+	int ret;
+	u8 reg_val;
+
+	if (ri->rinfo->force_reg) {
+		ret = tps80031_read(parent, ri->rinfo->volt_id,
+						ri->rinfo->force_reg, &reg_val);
+		if (ret < 0) {
+			dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
+				ri->rinfo->force_reg, ret);
+			return ret;
+		}
+		if (!(reg_val & SMPS_CMD_MASK)) {
+			ret = tps80031_update(parent, ri->rinfo->volt_id,
+				ri->rinfo->force_reg, vsel, SMPS_VSEL_MASK);
+			if (ret < 0)
+				dev_err(ri->dev,
+					"reg 0x%02x update failed, e = %d\n",
+					ri->rinfo->force_reg, ret);
+			return ret;
+		}
+	}
+	ret = tps80031_update(parent, ri->rinfo->volt_id,
+			ri->rinfo->volt_reg, vsel, SMPS_VSEL_MASK);
+	if (ret < 0)
+		dev_err(ri->dev, "reg 0x%02x update failed, e = %d\n",
+			ri->rinfo->volt_reg, ret);
+	return ret;
+}
+
+static int tps80031_dcdc_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
+	struct device *parent = to_tps80031_dev(rdev);
+	uint8_t vsel = 0;
+	int ret;
+
+	if (ri->rinfo->force_reg) {
+		ret = tps80031_read(parent, ri->rinfo->volt_id,
+						ri->rinfo->force_reg, &vsel);
+		if (ret < 0) {
+			dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
+					ri->rinfo->force_reg, ret);
+			return ret;
+		}
+
+		if (!(vsel & SMPS_CMD_MASK))
+			return vsel & SMPS_VSEL_MASK;
+	}
+	ret = tps80031_read(parent, ri->rinfo->volt_id,
+				ri->rinfo->volt_reg, &vsel);
+	if (ret < 0) {
+		dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
+			ri->rinfo->volt_reg, ret);
+		return ret;
+	}
+	return vsel & SMPS_VSEL_MASK;
+}
+
+static int tps80031_ldo_set_voltage_sel(struct regulator_dev *rdev,
+		unsigned sel)
+{
+	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
+	struct device *parent = to_tps80031_dev(rdev);
+	int ret;
+
+	/* Check for valid setting for TPS80031 or TPS80032-ES1.0 */
+	if ((ri->rinfo->desc.id == TPS80031_REGULATOR_LDO2) &&
+			(ri->device_flags & TRACK_MODE_ENABLE)) {
+		unsigned nvsel = (sel) & 0x1F;
+		if (((tps80031_get_chip_info(parent) == TPS80031) ||
+			((tps80031_get_chip_info(parent) == TPS80032) &&
+			(tps80031_get_pmu_version(parent) == 0x0))) &&
+			((nvsel == 0x0) || (nvsel >= 0x19 && nvsel <= 0x1F))) {
+				dev_err(ri->dev,
+					"Invalid sel %d in track mode LDO2\n",
+					nvsel);
+				return -EINVAL;
+		}
+	}
+
+	ret = tps80031_write(parent, ri->rinfo->volt_id,
+			ri->rinfo->volt_reg, sel);
+	if (ret < 0)
+		dev_err(ri->dev, "Error in writing reg 0x%02x, e = %d\n",
+			ri->rinfo->volt_reg, ret);
+	return ret;
+}
+
+static int tps80031_ldo_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
+	struct device *parent = to_tps80031_dev(rdev);
+	uint8_t vsel;
+	int ret;
+
+	ret = tps80031_read(parent, ri->rinfo->volt_id,
+				ri->rinfo->volt_reg, &vsel);
+	if (ret < 0) {
+		dev_err(ri->dev, "Error in writing the Voltage register\n");
+		return ret;
+	}
+	return vsel & rdev->desc->vsel_mask;
+}
+
+static int tps80031_ldo_list_voltage(struct regulator_dev *rdev, unsigned sel)
+{
+	if (sel == 0)
+		return 0;
+	else
+		return regulator_list_voltage_linear(rdev, sel - 1);
+}
+
+static int tps80031_vbus_is_enabled(struct regulator_dev *rdev)
+{
+	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
+	struct device *parent = to_tps80031_dev(rdev);
+	int ret = -EIO;
+	uint8_t ctrl1 = 0;
+	uint8_t ctrl3 = 0;
+
+	ret = tps80031_read(parent, SLAVE_ID2,
+			TPS80031_CHARGERUSB_CTRL1, &ctrl1);
+	if (ret < 0) {
+		dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
+			TPS80031_CHARGERUSB_CTRL1, ret);
+		return ret;
+	}
+	ret = tps80031_read(parent, SLAVE_ID2,
+				TPS80031_CHARGERUSB_CTRL3, &ctrl3);
+	if (ret < 0) {
+		dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
+			TPS80031_CHARGERUSB_CTRL1, ret);
+		return ret;
+	}
+	if ((ctrl1 & OPA_MODE_EN) && (ctrl3 & BOOST_HW_PWR_EN))
+		return 1;
+	return ret;
+}
+
+static int tps80031_vbus_enable(struct regulator_dev *rdev)
+{
+	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
+	struct device *parent = to_tps80031_dev(rdev);
+	int ret;
+
+	ret = tps80031_set_bits(parent, SLAVE_ID2,
+				TPS80031_CHARGERUSB_CTRL1, OPA_MODE_EN);
+	if (ret < 0) {
+		dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
+					TPS80031_CHARGERUSB_CTRL1, ret);
+		return ret;
+	}
+
+	ret = tps80031_set_bits(parent, SLAVE_ID2,
+				TPS80031_CHARGERUSB_CTRL3, BOOST_HW_PWR_EN);
+	if (ret < 0) {
+		dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
+			TPS80031_CHARGERUSB_CTRL3, ret);
+		return ret;
+	}
+	return ret;
+}
+
+static int tps80031_vbus_disable(struct regulator_dev *rdev)
+{
+	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
+	struct device *parent = to_tps80031_dev(rdev);
+	int ret = 0;
+
+	if (ri->config_flags & VBUS_DISCHRG_EN_PDN) {
+		ret = tps80031_write(parent, SLAVE_ID2,
+			USB_VBUS_CTRL_SET, VBUS_DISCHRG);
+		if (ret < 0) {
+			dev_err(ri->dev, "reg 0x%02x write failed, e = %d\n",
+				USB_VBUS_CTRL_SET, ret);
+			return ret;
+		}
+	}
+
+	ret = tps80031_clr_bits(parent, SLAVE_ID2,
+			TPS80031_CHARGERUSB_CTRL1,  OPA_MODE_EN);
+	if (ret < 0) {
+		dev_err(ri->dev, "reg 0x%02x clearbit failed, e = %d\n",
+				TPS80031_CHARGERUSB_CTRL1, ret);
+		return ret;
+	}
+
+	ret = tps80031_clr_bits(parent, SLAVE_ID2,
+				TPS80031_CHARGERUSB_CTRL3, BOOST_HW_PWR_EN);
+	if (ret < 0) {
+		dev_err(ri->dev, "reg 0x%02x clearbit failed, e = %d\n",
+				TPS80031_CHARGERUSB_CTRL3, ret);
+		return ret;
+	}
+
+	mdelay(DIV_ROUND_UP(ri->rinfo->desc.enable_time, 1000));
+	if (ri->config_flags & VBUS_DISCHRG_EN_PDN) {
+		ret = tps80031_write(parent, SLAVE_ID2,
+			USB_VBUS_CTRL_CLR, VBUS_DISCHRG);
+		if (ret < 0) {
+			dev_err(ri->dev, "reg 0x%02x write failed, e = %d\n",
+					USB_VBUS_CTRL_CLR, ret);
+			return ret;
+		}
+	}
+	return ret;
+}
+
+static struct regulator_ops tps80031_dcdc_ops = {
+	.list_voltage		= tps80031_dcdc_list_voltage,
+	.set_voltage_sel	= tps80031_dcdc_set_voltage_sel,
+	.get_voltage_sel	= tps80031_dcdc_get_voltage_sel,
+	.enable		= tps80031_reg_enable,
+	.disable	= tps80031_reg_disable,
+	.is_enabled	= tps80031_reg_is_enabled,
+};
+
+static struct regulator_ops tps80031_ldo_ops = {
+	.list_voltage		= tps80031_ldo_list_voltage,
+	.set_voltage_sel	= tps80031_ldo_set_voltage_sel,
+	.get_voltage_sel	= tps80031_ldo_get_voltage_sel,
+	.enable			= tps80031_reg_enable,
+	.disable		= tps80031_reg_disable,
+	.is_enabled		= tps80031_reg_is_enabled,
+};
+
+static struct regulator_ops tps80031_vbus_sw_ops = {
+	.enable		= tps80031_vbus_enable,
+	.disable	= tps80031_vbus_disable,
+	.is_enabled	= tps80031_vbus_is_enabled,
+};
+
+static struct regulator_ops tps80031_vbus_hw_ops = {
+};
+
+static struct regulator_ops tps80031_ext_reg_ops = {
+	.enable		= tps80031_reg_enable,
+	.disable	= tps80031_reg_disable,
+	.is_enabled	= tps80031_reg_is_enabled,
+};
+
+/* Non-exiting default definition for some register */
+#define TPS80031_SMPS3_CFG_FORCE	0
+#define TPS80031_SMPS4_CFG_FORCE	0
+
+#define TPS80031_VBUS_CFG_TRANS		0
+#define TPS80031_VBUS_CFG_STATE		0
+
+#define TPS80031_REG_SMPS(_id, _volt_id, _pbit)	\
+{								\
+	.trans_reg = TPS80031_##_id##_CFG_TRANS,		\
+	.state_reg = TPS80031_##_id##_CFG_STATE,		\
+	.force_reg = TPS80031_##_id##_CFG_FORCE,		\
+	.volt_reg = TPS80031_##_id##_CFG_VOLTAGE,		\
+	.volt_id = SLAVE_##_volt_id,				\
+	.preq_bit = _pbit,					\
+	.desc = {						\
+		.name = "tps80031_"#_id,			\
+		.id = TPS80031_REGULATOR_##_id,			\
+		.n_voltages = 63,				\
+		.ops = &tps80031_dcdc_ops,			\
+		.type = REGULATOR_VOLTAGE,			\
+		.owner = THIS_MODULE,				\
+		.enable_time = 500,				\
+	},							\
+}
+
+#define TPS80031_REG_LDO(_id, _preq_bit)			\
+{								\
+	.trans_reg = TPS80031_##_id##_CFG_TRANS,		\
+	.state_reg = TPS80031_##_id##_CFG_STATE,		\
+	.volt_reg = TPS80031_##_id##_CFG_VOLTAGE,		\
+	.volt_id = SLAVE_ID1,					\
+	.preq_bit = _preq_bit,					\
+	.desc = {						\
+		.owner = THIS_MODULE,				\
+		.name = "tps80031_"#_id,			\
+		.id = TPS80031_REGULATOR_##_id,			\
+		.ops = &tps80031_ldo_ops,			\
+		.type = REGULATOR_VOLTAGE,			\
+		.min_uV = 1000000,				\
+		.uV_step = 100000,				\
+		.n_voltages = 25,				\
+		.vsel_mask = LDO_VSEL_MASK,			\
+		.enable_time = 500,				\
+	},							\
+}
+
+#define TPS80031_REG_FIXED(_id, max_mV, _ops, _delay, _pbit)	\
+{								\
+	.trans_reg = TPS80031_##_id##_CFG_TRANS,		\
+	.state_reg = TPS80031_##_id##_CFG_STATE,		\
+	.volt_id = SLAVE_ID1,					\
+	.preq_bit = _pbit,					\
+	.desc = {						\
+		.name = "tps80031_"#_id,			\
+		.id = TPS80031_REGULATOR_##_id,			\
+		.n_voltages = 2,				\
+		.ops = &_ops,					\
+		.type = REGULATOR_VOLTAGE,			\
+		.owner = THIS_MODULE,				\
+		.enable_time = _delay,				\
+	},							\
+}
+
+static struct tps80031_regulator_info tps80031_rinfo[TPS80031_REGULATOR_MAX] = {
+	TPS80031_REG_SMPS(VIO,   ID0, 4),
+	TPS80031_REG_SMPS(SMPS1, ID0, 0),
+	TPS80031_REG_SMPS(SMPS2, ID0, 1),
+	TPS80031_REG_SMPS(SMPS3, ID1, 2),
+	TPS80031_REG_SMPS(SMPS4, ID1, 3),
+	TPS80031_REG_LDO(VANA,   -1),
+	TPS80031_REG_LDO(LDO1,   8),
+	TPS80031_REG_LDO(LDO2,   9),
+	TPS80031_REG_LDO(LDO3,   10),
+	TPS80031_REG_LDO(LDO4,   11),
+	TPS80031_REG_LDO(LDO5,   12),
+	TPS80031_REG_LDO(LDO6,   13),
+	TPS80031_REG_LDO(LDO7,   14),
+	TPS80031_REG_LDO(LDOLN,  15),
+	TPS80031_REG_LDO(LDOUSB, 5),
+	TPS80031_REG_FIXED(VBUS,   5000, tps80031_vbus_hw_ops, 100000, -1),
+	TPS80031_REG_FIXED(REGEN1, 3300, tps80031_ext_reg_ops, 0, 16),
+	TPS80031_REG_FIXED(REGEN2, 3300, tps80031_ext_reg_ops, 0, 17),
+	TPS80031_REG_FIXED(SYSEN,  3300, tps80031_ext_reg_ops, 0, 18),
+};
+
+static int tps80031_power_req_config(struct device *parent,
+		struct tps80031_regulator *ri,
+		struct tps80031_regulator_platform_data *tps80031_pdata)
+{
+	int ret = 0;
+
+	if (ri->rinfo->preq_bit < 0)
+		goto skip_pwr_req_config;
+
+	ret = tps80031_ext_power_req_config(parent, ri->ext_ctrl_flag,
+			ri->rinfo->preq_bit, ri->rinfo->state_reg,
+			ri->rinfo->trans_reg);
+	if (ret < 0) {
+		dev_err(ri->dev, "ext powerreq config failed, err = %d\n", ret);
+		return ret;
+	}
+
+skip_pwr_req_config:
+	if (tps80031_pdata->ext_ctrl_flag & PWR_ON_ON_SLEEP) {
+		ret = tps80031_update(parent, SLAVE_ID1, ri->rinfo->trans_reg,
+				TRANS_SLEEP_ON, TRANS_SLEEP_MASK);
+		if (ret < 0) {
+			dev_err(ri->dev, "Reg 0x%02x update failed, e %d\n",
+					ri->rinfo->trans_reg, ret);
+			return ret;
+		}
+	}
+	return ret;
+}
+
+static int tps80031_regulator_config(struct device *parent,
+		struct tps80031_regulator *ri,
+		struct tps80031_regulator_platform_data *tps80031_pdata)
+{
+	int ret = 0;
+
+	switch (ri->rinfo->desc.id) {
+	case TPS80031_REGULATOR_LDOUSB:
+		if (ri->config_flags &
+			(USBLDO_INPUT_VSYS | USBLDO_INPUT_PMID)) {
+			unsigned val = 0;
+			if (ri->config_flags & USBLDO_INPUT_VSYS)
+				val = MISC2_LDOUSB_IN_VSYS;
+			else
+				val = MISC2_LDOUSB_IN_PMID;
+
+			ret = tps80031_update(parent, SLAVE_ID1,
+				TPS80031_MISC2, val, MISC2_LDOUSB_IN_MASK);
+			if (ret < 0) {
+				dev_err(ri->dev,
+					"LDOUSB config failed, e= %d\n", ret);
+				return ret;
+			}
+		}
+		break;
+
+	case TPS80031_REGULATOR_LDO3:
+		if (ri->config_flags & LDO3_OUTPUT_VIB) {
+			ret = tps80031_update(parent, SLAVE_ID1,
+				TPS80031_MISC2, MISC2_LDO3_SEL_VIB_VAL,
+				MISC2_LDO3_SEL_VIB_MASK);
+			if (ret < 0) {
+				dev_err(ri->dev,
+					"LDO3 config failed, e = %d\n", ret);
+				return ret;
+			}
+		}
+		break;
+
+	case TPS80031_REGULATOR_VBUS:
+		/* Provide SW control Ops if VBUS is SW control */
+		if (!(ri->config_flags & VBUS_SW_ONLY))
+			ri->rinfo->desc.ops = &tps80031_vbus_sw_ops;
+		break;
+	default:
+		break;
+	}
+
+	/* Configure Active state to ON, SLEEP to OFF and OFF_state to OFF */
+	ret = tps80031_update(parent, SLAVE_ID1, ri->rinfo->trans_reg,
+		TRANS_ACTIVE_ON | TRANS_SLEEP_OFF | TRANS_OFF_OFF,
+		TRANS_ACTIVE_MASK | TRANS_SLEEP_MASK | TRANS_OFF_MASK);
+	if (ret < 0) {
+		dev_err(ri->dev, "trans reg update failed, e %d\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+static int check_smps_mode_mult(struct device *parent,
+	struct tps80031_regulator *ri)
+{
+	int mult_offset;
+	int ret;
+	u8 smps_offset;
+	u8 smps_mult;
+
+	ret = tps80031_read(parent, SLAVE_ID1,
+			TPS80031_SMPS_OFFSET, &smps_offset);
+	if (ret < 0) {
+		dev_err(parent, "Error in reading smps offset register\n");
+		return ret;
+	}
+
+	ret = tps80031_read(parent, SLAVE_ID1,
+			TPS80031_SMPS_MULT, &smps_mult);
+	if (ret < 0) {
+		dev_err(parent, "Error in reading smps mult register\n");
+		return ret;
+	}
+
+	switch (ri->rinfo->desc.id) {
+	case TPS80031_REGULATOR_VIO:
+		mult_offset = SMPS_MULTOFFSET_VIO;
+		break;
+	case TPS80031_REGULATOR_SMPS1:
+		mult_offset = SMPS_MULTOFFSET_SMPS1;
+		break;
+	case TPS80031_REGULATOR_SMPS2:
+		mult_offset = SMPS_MULTOFFSET_SMPS2;
+		break;
+	case TPS80031_REGULATOR_SMPS3:
+		mult_offset = SMPS_MULTOFFSET_SMPS3;
+		break;
+	case TPS80031_REGULATOR_SMPS4:
+		mult_offset = SMPS_MULTOFFSET_SMPS4;
+		break;
+	case TPS80031_REGULATOR_LDO2:
+		ri->device_flags = smps_mult & BIT(5) ? TRACK_MODE_ENABLE : 0;
+		/* TRACK mode the ldo2 varies from 600mV to 1300mV */
+		if (ri->device_flags & TRACK_MODE_ENABLE) {
+			ri->rinfo->desc.min_uV = 600000;
+			ri->rinfo->desc.uV_step = 12500;
+			ri->rinfo->desc.n_voltages = 57;
+			ri->rinfo->desc.vsel_mask = LDO_TRACK_VSEL_MASK;
+		}
+		return 0;
+	default:
+		return 0;
+	}
+
+	ri->device_flags = (smps_offset & mult_offset) ? DCDC_OFFSET_EN : 0;
+	ri->device_flags |= (smps_mult & mult_offset) ? DCDC_EXTENDED_EN : 0;
+	switch (ri->device_flags) {
+	case 0:
+		ri->rinfo->desc.min_uV = 607700;
+		ri->rinfo->desc.uV_step = 12660;
+		break;
+	case DCDC_OFFSET_EN:
+		ri->rinfo->desc.min_uV = 700000;
+		ri->rinfo->desc.uV_step = 12500;
+		break;
+	case DCDC_EXTENDED_EN:
+		ri->rinfo->desc.min_uV = 1852000;
+		ri->rinfo->desc.uV_step = 38600;
+		break;
+	case DCDC_OFFSET_EN | DCDC_EXTENDED_EN:
+		ri->rinfo->desc.min_uV = 2161000;
+		ri->rinfo->desc.uV_step = 38600;
+		break;
+	}
+	return 0;
+}
+
+static int __devinit tps80031_regulator_probe(struct platform_device *pdev)
+{
+	struct tps80031_platform_data *pdata;
+	struct tps80031_regulator_platform_data *tps_pdata;
+	struct tps80031_regulator_info *rinfo;
+	struct tps80031_regulator *ri;
+	struct tps80031_regulator *pmic;
+	struct regulator_dev *rdev;
+	struct regulator_config config = { };
+	int ret;
+	int num;
+
+	pdata = dev_get_platdata(pdev->dev.parent);
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform data\n");
+		return -EINVAL;
+	}
+
+	pmic = devm_kzalloc(&pdev->dev,
+			TPS80031_REGULATOR_MAX * sizeof(*pmic), GFP_KERNEL);
+	if (!pmic) {
+		dev_err(&pdev->dev, "mem alloc for pmic failed\n");
+		return -ENOMEM;
+	}
+
+	for (num = 0; num < TPS80031_REGULATOR_MAX; ++num) {
+		tps_pdata = pdata->regulator_pdata[num];
+		rinfo = &tps80031_rinfo[num];
+		ri = &pmic[num];
+		ri->rinfo = rinfo;
+		ri->dev = &pdev->dev;
+
+		check_smps_mode_mult(pdev->dev.parent, ri);
+		config.dev = &pdev->dev;
+		config.init_data = NULL;
+		config.driver_data = ri;
+		if (tps_pdata) {
+			config.init_data = tps_pdata->reg_init_data;
+			ri->config_flags = tps_pdata->config_flags;
+			ri->ext_ctrl_flag = tps_pdata->ext_ctrl_flag;
+			ret = tps80031_regulator_config(pdev->dev.parent,
+					ri, tps_pdata);
+			if (ret < 0) {
+				dev_err(&pdev->dev,
+					"regulator config failed, e %d\n", ret);
+				goto fail;
+			}
+
+			ret = tps80031_power_req_config(pdev->dev.parent,
+					ri, tps_pdata);
+			if (ret < 0) {
+				dev_err(&pdev->dev,
+					"pwr_req config failed, err %d\n", ret);
+				goto fail;
+			}
+		}
+		rdev = regulator_register(&ri->rinfo->desc, &config);
+		if (IS_ERR_OR_NULL(rdev)) {
+			dev_err(&pdev->dev,
+				"register regulator failed %s\n",
+					ri->rinfo->desc.name);
+			ret = PTR_ERR(rdev);
+			goto fail;
+		}
+		ri->rdev = rdev;
+	}
+
+	platform_set_drvdata(pdev, pmic);
+	return 0;
+fail:
+	while (--num >= 0) {
+		ri = &pmic[num];
+		regulator_unregister(ri->rdev);
+	}
+	return ret;
+}
+
+static int __devexit tps80031_regulator_remove(struct platform_device *pdev)
+{
+	struct tps80031_regulator *pmic = platform_get_drvdata(pdev);
+	struct tps80031_regulator *ri = NULL;
+	int num;
+
+	for (num = 0; num < TPS80031_REGULATOR_MAX; ++num) {
+		ri = &pmic[num];
+		regulator_unregister(ri->rdev);
+	}
+	return 0;
+}
+
+static struct platform_driver tps80031_regulator_driver = {
+	.driver	= {
+		.name	= "tps80031-pmic",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= tps80031_regulator_probe,
+	.remove		= __devexit_p(tps80031_regulator_remove),
+};
+
+static int __init tps80031_regulator_init(void)
+{
+	return platform_driver_register(&tps80031_regulator_driver);
+}
+subsys_initcall(tps80031_regulator_init);
+
+static void __exit tps80031_regulator_exit(void)
+{
+	platform_driver_unregister(&tps80031_regulator_driver);
+}
+module_exit(tps80031_regulator_exit);
+
+MODULE_ALIAS("platform:tps80031-regulator");
+MODULE_DESCRIPTION("Regulator Driver for TI TPS80031 PMIC");
+MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.7.1.1

