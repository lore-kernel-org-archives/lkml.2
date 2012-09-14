Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab2INNRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:17:40 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:51585
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957Ab2INNRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:17:35 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 4
X-BigFish: VPS4(zz1102Ic8kd6f1izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh1315hbe9i1155h)
Subject: [Patch v1 2/7] DA9055 Regulator driver
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        David Dajun Chen <dchen@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Sep 2012 18:56:56 +0530
Message-ID: <1347629216.18587.11.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the Regulator patch for the DA9055 PMIC and has got dependency
on the DA9055 MFD core.

This patch support all of the DA9055 regulators. The output voltages are
fully programmable through I2C interface only. The platform data with
regulation constraints is passed down from the board to the regulator.

This patch is functionaly tested on SMDK6410 board. DA9055 Evaluation
board was connected to the SMDK6410 board.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/regulator/Kconfig            |   10 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/da9055-regulator.c |  727 ++++++++++++++++++++++++++++++++++
 3 files changed, 738 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/da9055-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 129c827..0bd6db1 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -109,6 +109,16 @@ config REGULATOR_DA9052
 	  This driver supports the voltage regulators of DA9052-BC and
 	  DA9053-AA/Bx PMIC.
 
+config REGULATOR_DA9055
+	tristate "Dialog Semiconductor DA9055 regulators"
+	depends on MFD_DA9055
+	help
+	  Say y here to support the BUCKs and LDOs regulators found on
+	  Dialog Semiconductor DA9055 PMIC.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called da9055-regulator.
+
 config REGULATOR_ANATOP
 	tristate "Freescale i.MX on-chip ANATOP LDO regulators"
 	depends on MFD_ANATOP
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 3a0dbc5..950b38b 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_REGULATOR_ANATOP) += anatop-regulator.o
 obj-$(CONFIG_REGULATOR_ARIZONA) += arizona-micsupp.o arizona-ldo1.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_DA9052)	+= da9052-regulator.o
+obj-$(CONFIG_REGULATOR_DA9055)	+= da9055-regulator.o
 obj-$(CONFIG_REGULATOR_DBX500_PRCMU) += dbx500-prcmu.o
 obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
 obj-$(CONFIG_REGULATOR_GPIO) += gpio-regulator.o
diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
new file mode 100644
index 0000000..630b664
--- /dev/null
+++ b/drivers/regulator/da9055-regulator.c
@@ -0,0 +1,727 @@
+/*
+* Regulator driver for DA9055 PMIC
+*
+* Copyright(c) 2012 Dialog Semiconductor Ltd.
+*
+* Author: David Dajun Chen <dchen@diasemi.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License as published by
+* the Free Software Foundation; either version 2 of the License, or
+* (at your option) any later version.
+*
+*/
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+
+#include <linux/mfd/da9055/core.h>
+#include <linux/mfd/da9055/reg.h>
+#include <linux/mfd/da9055/pdata.h>
+
+#define DA9055_MIN_UA		0
+#define DA9055_MAX_UA		3
+
+#define DA9055_LDO_MODE_SYNC	0
+#define DA9055_LDO_MODE_SLEEP	1
+
+#define DA9055_BUCK_MODE_SLEEP	1
+#define DA9055_BUCK_MODE_SYNC	2
+#define DA9055_BUCK_MODE_AUTO	3
+
+/* DA9055 REGULATOR IDs */
+#define DA9055_ID_BUCK1		0
+#define DA9055_ID_BUCK2		1
+#define DA9055_ID_LDO1		2
+#define DA9055_ID_LDO2		3
+#define DA9055_ID_LDO3		4
+#define DA9055_ID_LDO4		5
+#define DA9055_ID_LDO5		6
+#define DA9055_ID_LDO6		7
+
+/* DA9055 GPIO OFFSET */
+#define DA9055_GPIO_1_OFFSET	0x01
+#define DA9055_GPIO_2_OFFSET	0x02
+
+/* DA9055 BUCK current limit */
+static const int da9055_current_limits[] = { 500000, 600000, 700000, 800000 };
+
+struct da9055_conf_reg {
+	int reg;
+	int sel_mask;
+	int en_mask;
+};
+
+struct da9055_volt_reg {
+	int reg_a;
+	int reg_b;
+	int sl_shift;
+	int v_offset;
+	int v_mask;
+	int v_shift;
+};
+
+struct da9055_mode_reg {
+	int reg;
+	int mask;
+	int shift;
+};
+
+struct da9055_regulator_info {
+	struct regulator_desc reg_desc;
+	int step_uV;
+	int min_uV;
+	int max_uV;
+	struct da9055_conf_reg conf;
+	struct da9055_volt_reg volt;
+	struct da9055_mode_reg mode;
+};
+
+struct da9055_regulator {
+	struct da9055 *da9055;
+	struct da9055_regulator_info *info;
+	struct regulator_dev *rdev;
+	int gpio_1;
+	int gpio_2;
+	enum gpio_select gpio_rsel;
+	enum gpio_select gpio_ren;
+};
+
+static int verify_range(struct da9055_regulator_info *info,
+			 int min_uV, int max_uV)
+{
+	if (min_uV > info->max_uV || max_uV < info->min_uV)
+		return -EINVAL;
+
+	return 0;
+}
+
+static unsigned int da9055_buck_get_mode(struct regulator_dev *rdev)
+{
+	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9055_regulator_info *info = regulator->info;
+	int ret, mode = 0;
+
+	ret = da9055_reg_read(regulator->da9055, info->mode.reg);
+	if (ret < 0)
+		return ret;
+
+	switch ((ret & info->mode.mask) >> info->mode.shift) {
+	case DA9055_BUCK_MODE_SYNC:
+		mode = REGULATOR_MODE_FAST;
+		break;
+	case DA9055_BUCK_MODE_AUTO:
+		mode = REGULATOR_MODE_NORMAL;
+		break;
+	case DA9055_BUCK_MODE_SLEEP:
+		mode = REGULATOR_MODE_STANDBY;
+		break;
+	}
+
+	return mode;
+}
+
+static int da9055_buck_set_mode(struct regulator_dev *rdev,
+					unsigned int mode)
+{
+	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9055_regulator_info *info = regulator->info;
+	int val = 0;
+
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		val = DA9055_BUCK_MODE_SYNC << info->mode.shift;
+		break;
+	case REGULATOR_MODE_NORMAL:
+		val = DA9055_BUCK_MODE_AUTO << info->mode.shift;
+		break;
+	case REGULATOR_MODE_IDLE:
+	case REGULATOR_MODE_STANDBY:
+		val = DA9055_BUCK_MODE_SLEEP << info->mode.shift;
+		break;
+	}
+
+	return da9055_reg_update(regulator->da9055, info->mode.reg,
+				 info->mode.mask, val);
+}
+
+static unsigned int da9055_ldo_get_mode(struct regulator_dev *rdev)
+{
+	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9055_regulator_info *info = regulator->info;
+	int ret;
+
+	ret = da9055_reg_read(regulator->da9055, info->volt.reg_b);
+	if (ret < 0)
+		return ret;
+
+	if (ret >> info->volt.sl_shift)
+		return REGULATOR_MODE_STANDBY;
+	else
+		return REGULATOR_MODE_NORMAL;
+}
+
+static int da9055_ldo_set_mode(struct regulator_dev *rdev, unsigned int mode)
+{
+	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9055_regulator_info *info = regulator->info;
+	struct da9055_volt_reg volt = info->volt;
+	int val = 0;
+
+	switch (mode) {
+	case REGULATOR_MODE_NORMAL:
+	case REGULATOR_MODE_FAST:
+		val = DA9055_LDO_MODE_SYNC;
+		break;
+	case REGULATOR_MODE_IDLE:
+	case REGULATOR_MODE_STANDBY:
+		val = DA9055_LDO_MODE_SLEEP;
+	}
+
+	return da9055_reg_update(regulator->da9055, volt.reg_b,
+				 1 << volt.sl_shift,
+				 val << volt.sl_shift);
+}
+
+static int da9055_buck_get_current_limit(struct regulator_dev *rdev)
+{
+	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9055_regulator_info *info = regulator->info;
+	int ret;
+
+	ret = da9055_reg_read(regulator->da9055, DA9055_REG_BUCK_LIM);
+	if (ret < 0)
+		return ret;
+
+	ret &= info->mode.mask;
+	return da9055_current_limits[ret >> info->mode.shift];
+}
+
+static int da9055_buck_set_current_limit(struct regulator_dev *rdev, int min_uA,
+					 int max_uA)
+{
+	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9055_regulator_info *info = regulator->info;
+	int i, val = 0;
+
+	if (min_uA > da9055_current_limits[DA9055_MAX_UA] ||
+	    max_uA < da9055_current_limits[DA9055_MIN_UA])
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(da9055_current_limits); i++) {
+		if (min_uA <= da9055_current_limits[i]) {
+			val = i;
+			break;
+		}
+	}
+
+	return da9055_reg_update(regulator->da9055, DA9055_REG_BUCK_LIM,
+				info->mode.mask, val << info->mode.shift);
+}
+
+static int da9055_list_voltage(struct regulator_dev *rdev,
+				unsigned int selector)
+{
+	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9055_regulator_info *info = regulator->info;
+	int volt_uV;
+
+	volt_uV = (selector * info->step_uV) + info->min_uV;
+
+	if (volt_uV > info->max_uV)
+		return -EINVAL;
+
+	return volt_uV;
+}
+
+static int da9055_map_voltage(struct regulator_dev *rdev,
+			      int min_uV, int max_uV)
+{
+	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9055_regulator_info *info = regulator->info;
+	int ret, sel;
+
+	ret = verify_range(info, min_uV, max_uV);
+	if (ret < 0)
+		return ret;
+
+	if (min_uV < info->min_uV)
+		min_uV = info->min_uV;
+
+	sel = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
+
+	ret = da9055_list_voltage(rdev, sel);
+	if (ret < 0)
+		return ret;
+
+	return sel;
+}
+
+static int da9055_regulator_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9055_regulator_info *info = regulator->info;
+	struct da9055_volt_reg volt = info->volt;
+	int ret, sel;
+
+	/*
+	 * There are two voltage register set A & B for voltage ramping but
+	 * either one of then can be active therefore we first determine
+	 * the active register set.
+	 */
+	ret = da9055_reg_read(regulator->da9055, info->conf.reg);
+	if (ret < 0)
+		return ret;
+
+	ret &= info->conf.sel_mask;
+
+	/* Get the voltage for the activer register set A/B */
+	if (ret == DA9055_REGUALTOR_SET_A)
+		ret = da9055_reg_read(regulator->da9055, volt.reg_a);
+	else
+		ret = da9055_reg_read(regulator->da9055, volt.reg_b);
+
+	if (ret < 0)
+		return ret;
+
+	sel = ((ret & volt.v_mask) - volt.v_offset);
+
+	return sel;
+}
+
+static int da9055_regulator_set_voltage_bits(struct regulator_dev *rdev,
+					     unsigned int reg,
+					     unsigned int selector)
+{
+	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9055_regulator_info *info = regulator->info;
+
+	/* Take care of voltage range that does not start with 0 offset. */
+	selector += info->volt.v_offset;
+
+	/* Set the voltage */
+	return da9055_reg_update(regulator->da9055, reg, info->volt.v_mask,
+				 selector);
+
+}
+
+static int da9055_regulator_set_voltage_sel(struct regulator_dev *rdev,
+					    unsigned int selector)
+{
+	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9055_regulator_info *info = regulator->info;
+	int ret;
+
+	/*
+	 * When regulator set A/B is not selected through GPIO then we use the
+	 * default register set A for voltage ramping.
+	 */
+	if (regulator->gpio_rsel == NO_GPIO) {
+		/* Select register set A */
+		ret = da9055_reg_update(regulator->da9055, info->conf.reg,
+					info->conf.sel_mask, DA9055_SEL_REG_A);
+		if (ret < 0)
+			return ret;
+
+		/* Set the voltage */
+		return da9055_regulator_set_voltage_bits(rdev, info->volt.reg_a,
+							 selector);
+	}
+
+	/*
+	 * In this case regulator voltage set A/B is GPIO controlled.
+	 * Therefore we first determine the GPIO selected register
+	 * set A/B and then set the desired voltage.
+	 */
+	ret = da9055_reg_read(regulator->da9055, info->conf.reg);
+	if (ret < 0)
+		return ret;
+
+	ret &= info->conf.sel_mask;
+
+	/* Set the voltage */
+	if (ret == DA9055_REGUALTOR_SET_A)
+		return da9055_regulator_set_voltage_bits(rdev, info->volt.reg_a,
+							 selector);
+
+	return da9055_regulator_set_voltage_bits(rdev, info->volt.reg_b,
+						 selector);
+}
+
+static int da9055_regulator_set_suspend_voltage(struct regulator_dev *rdev,
+						int uV)
+{
+	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9055_regulator_info *info = regulator->info;
+	int ret;
+
+	/* Select register set B for suspend voltage ramping. */
+	ret = da9055_reg_update(regulator->da9055, info->conf.reg,
+				info->conf.sel_mask, DA9055_SEL_REG_B);
+	if (ret < 0)
+		return ret;
+
+	ret = da9055_map_voltage(rdev, uV, uV);
+	if (ret < 0)
+		return ret;
+
+	return da9055_regulator_set_voltage_bits(rdev, info->volt.reg_b, ret);
+}
+
+static int da9055_suspend_enable(struct regulator_dev *rdev)
+{
+	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9055_regulator_info *info = regulator->info;
+
+	/* Select register set B for voltage ramping. */
+	return da9055_reg_update(regulator->da9055, info->conf.reg,
+				info->conf.sel_mask, DA9055_SEL_REG_B);
+}
+
+static int da9055_suspend_disable(struct regulator_dev *rdev)
+{
+	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9055_regulator_info *info = regulator->info;
+
+	/* Diselect register set B. */
+	return da9055_reg_update(regulator->da9055, info->conf.reg,
+				info->conf.sel_mask, DA9055_SEL_REG_A);
+}
+
+static struct regulator_ops da9055_buck_ops = {
+	.get_mode = da9055_buck_get_mode,
+	.set_mode = da9055_buck_set_mode,
+
+	.get_current_limit = da9055_buck_get_current_limit,
+	.set_current_limit = da9055_buck_set_current_limit,
+
+	.list_voltage = da9055_list_voltage,
+	.map_voltage = da9055_map_voltage,
+	.get_voltage_sel = da9055_regulator_get_voltage_sel,
+	.set_voltage_sel = da9055_regulator_set_voltage_sel,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+
+	.set_suspend_voltage = da9055_regulator_set_suspend_voltage,
+	.set_suspend_enable = da9055_suspend_enable,
+	.set_suspend_disable = da9055_suspend_disable,
+	.set_suspend_mode = da9055_buck_set_mode,
+};
+
+static struct regulator_ops da9055_ldo_ops = {
+	.get_mode = da9055_ldo_get_mode,
+	.set_mode = da9055_ldo_set_mode,
+
+	.list_voltage = da9055_list_voltage,
+	.map_voltage = da9055_map_voltage,
+	.get_voltage_sel = da9055_regulator_get_voltage_sel,
+	.set_voltage_sel = da9055_regulator_set_voltage_sel,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+
+	.set_suspend_voltage = da9055_regulator_set_suspend_voltage,
+	.set_suspend_enable = da9055_suspend_enable,
+	.set_suspend_disable = da9055_suspend_disable,
+	.set_suspend_mode = da9055_ldo_set_mode,
+
+};
+
+#define DA9055_LDO(_id, step, min, max, vbits, voffset) \
+{\
+	.reg_desc = {\
+		.name = #_id,\
+		.ops = &da9055_ldo_ops,\
+		.type = REGULATOR_VOLTAGE,\
+		.id = DA9055_ID_##_id,\
+		.n_voltages = (max - min) / step + 1, \
+		.enable_reg = DA9055_REG_BCORE_CONT + DA9055_ID_##_id, \
+		.enable_mask = 1, \
+		.owner = THIS_MODULE,\
+	},\
+	.conf = {\
+		.reg = DA9055_REG_BCORE_CONT + DA9055_ID_##_id, \
+		.sel_mask = (1 << 4),\
+		.en_mask = 1,\
+	},\
+	.volt = {\
+		.reg_a = DA9055_REG_VBCORE_A + DA9055_ID_##_id, \
+		.reg_b = DA9055_REG_VBCORE_B + DA9055_ID_##_id, \
+		.sl_shift = 7,\
+		.v_offset = (voffset),\
+		.v_mask = (1 << (vbits)) - 1,\
+		.v_shift = (vbits),\
+	},\
+	.min_uV = (min) * 1000,\
+	.max_uV = (max) * 1000,\
+	.step_uV = (step) * 1000,\
+}
+
+#define DA9055_BUCK(_id, step, min, max, vbits, voffset, mbits, sbits) \
+{\
+	.reg_desc = {\
+		.name = #_id,\
+		.ops = &da9055_buck_ops,\
+		.type = REGULATOR_VOLTAGE,\
+		.id = DA9055_ID_##_id,\
+		.n_voltages = (max - min) / step + 1, \
+		.enable_reg = DA9055_REG_BCORE_CONT + DA9055_ID_##_id, \
+		.enable_mask = 1,\
+		.owner = THIS_MODULE,\
+	},\
+	.conf = {\
+		.reg = DA9055_REG_BCORE_CONT + DA9055_ID_##_id, \
+		.sel_mask = (1 << 4),\
+		.en_mask = 1,\
+	},\
+	.volt = {\
+		.reg_a = DA9055_REG_VBCORE_A + DA9055_ID_##_id, \
+		.reg_b = DA9055_REG_VBCORE_B + DA9055_ID_##_id, \
+		.sl_shift = 7,\
+		.v_offset = (voffset),\
+		.v_mask = (1 << (vbits)) - 1,\
+		.v_shift = (vbits),\
+	},\
+	.mode = {\
+		.reg = DA9055_REG_BCORE_MODE,\
+		.mask = (mbits),\
+		.shift = (sbits),\
+	},\
+	.min_uV = (min) * 1000,\
+	.max_uV = (max) * 1000,\
+	.step_uV = (step) * 1000,\
+}
+
+static struct da9055_regulator_info da9055_regulator_info[] = {
+	DA9055_BUCK(BUCK1, 25, 725, 2075, 6, 9, 0xc, 2),
+	DA9055_BUCK(BUCK2, 25, 925, 2500, 6, 0, 3, 0),
+	DA9055_LDO(LDO1, 50, 900, 3300, 6, 2),
+	DA9055_LDO(LDO2, 50, 900, 3300, 6, 3),
+	DA9055_LDO(LDO3, 50, 900, 3300, 6, 2),
+	DA9055_LDO(LDO4, 50, 900, 3300, 6, 2),
+	DA9055_LDO(LDO5, 50, 900, 2750, 6, 2),
+	DA9055_LDO(LDO6, 20, 900, 3300, 7, 0),
+};
+
+/*
+ * This function configures regulator to be controlled through GPIO 1/2.
+ * GPIO can control regulator in two ways. 1) selects the regulator register
+ * set A/B for voltage ramping. 2) changes the regulator state.
+ */
+static __devinit int da9055_gpio_init(struct da9055_regulator *regulator,
+				      struct da9055_pdata *pdata, int id)
+{
+	struct da9055_regulator_info *info = regulator->info;
+	int ret = 0;
+
+	if (pdata->gpio_rsel)
+		regulator->gpio_rsel = pdata->gpio_rsel[id];
+	if (pdata->gpio_ren)
+		regulator->gpio_ren = pdata->gpio_ren[id];
+
+	if (regulator->gpio_rsel == GPIO_1 || regulator->gpio_ren == GPIO_1)
+		regulator->gpio_1 = pdata->gpio_base + DA9055_GPIO_1_OFFSET;
+
+	if (regulator->gpio_rsel == GPIO_2 || regulator->gpio_ren == GPIO_2)
+		regulator->gpio_2 = pdata->gpio_base + DA9055_GPIO_2_OFFSET;
+
+	/* Set the GPIO pin 1 direction for controlling the regulator. */
+	if (regulator->gpio_1) {
+		ret = gpio_request(regulator->gpio_1, "DA9055 GPIO_1");
+		if (ret < 0)
+			goto err_gpio;
+
+		ret = gpio_direction_input(regulator->gpio_1);
+		if (ret < 0) {
+			gpio_free(regulator->gpio_1);
+			goto err_gpio;
+		}
+
+		gpio_free(regulator->gpio_1);
+	}
+
+	/* Set the GPIO pin 2 direction for controlling the regulator. */
+	if (regulator->gpio_2) {
+		ret = gpio_request(regulator->gpio_2, "DA9055 GPIO_2");
+		if (ret < 0)
+			goto err_gpio;
+
+		ret = gpio_direction_input(regulator->gpio_2);
+		if (ret < 0) {
+			gpio_free(regulator->gpio_2);
+			goto err_gpio;
+		}
+
+		gpio_free(regulator->gpio_2);
+	}
+
+	/*
+	 * Set the regulator register bit for GPIO to select
+	 * the register set.
+	 */
+	if (regulator->gpio_rsel)
+		ret = da9055_reg_update(regulator->da9055, info->conf.reg,
+					DA9055_V_GPI_MASK,
+					regulator->gpio_rsel
+					<< DA9055_V_GPI_SHIFT);
+
+	/*
+	 * Set the regulator register bits for GPIO to change
+	 * the regulator state.
+	 */
+	if (regulator->gpio_ren)
+		ret = da9055_reg_update(regulator->da9055, info->conf.reg,
+					DA9055_E_GPI_MASK,
+					regulator->gpio_ren
+					<< DA9055_E_GPI_SHIFT);
+
+err_gpio:
+	return ret;
+}
+
+static irqreturn_t da9055_ldo5_6_oc_irq(int irq, void *data)
+{
+	struct da9055_regulator *regulator = data;
+
+	regulator_notifier_call_chain(regulator->rdev,
+				      REGULATOR_EVENT_OVER_CURRENT,
+				      NULL);
+
+	return IRQ_HANDLED;
+}
+
+static inline struct da9055_regulator_info *find_regulator_info(int id)
+{
+	struct da9055_regulator_info *info;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(da9055_regulator_info); i++) {
+		info = &da9055_regulator_info[i];
+		if (info->reg_desc.id == id)
+			return info;
+		}
+
+	return NULL;
+}
+
+static int __devinit da9055_regulator_probe(struct platform_device *pdev)
+{
+	struct regulator_config config = { };
+	struct da9055_regulator *regulator;
+	struct da9055 *da9055 = dev_get_drvdata(pdev->dev.parent);
+	struct da9055_pdata *pdata = da9055->dev->platform_data;
+	int ret, irq;
+
+	if (pdata == NULL || pdata->regulators[pdev->id] == NULL)
+		return -ENODEV;
+
+	regulator = devm_kzalloc(&pdev->dev, sizeof(struct da9055_regulator),
+				 GFP_KERNEL);
+	if (!regulator)
+		return -ENOMEM;
+
+	regulator->info = find_regulator_info(pdev->id);
+	if (regulator->info == NULL) {
+		dev_err(&pdev->dev, "invalid regulator ID specified\n");
+		return -EINVAL;
+	}
+
+	regulator->da9055 = da9055;
+	config.dev = &pdev->dev;
+	config.driver_data = regulator;
+	config.regmap = da9055->regmap;
+
+	if (pdata && pdata->regulators)
+		config.init_data = pdata->regulators[pdev->id];
+
+	ret = da9055_gpio_init(regulator, pdata, pdev->id);
+	if (ret < 0)
+		return ret;
+
+	regulator->rdev = regulator_register(&regulator->info->reg_desc,
+					     &config);
+	if (IS_ERR(regulator->rdev)) {
+		dev_err(&pdev->dev, "Failed to register regulator %s\n",
+			regulator->info->reg_desc.name);
+		ret = PTR_ERR(regulator->rdev);
+		goto err_gpio;
+	}
+
+	/* Only LDO 5/6 has got the over current interrupt */
+	if (pdev->id == DA9055_ID_LDO5 || pdev->id ==  DA9055_ID_LDO6) {
+		irq = platform_get_irq_byname(pdev, "REGULATOR");
+		ret = request_threaded_irq(irq, NULL, da9055_ldo5_6_oc_irq,
+					   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					   pdev->name, regulator);
+		if (ret != 0) {
+			if (ret != -EBUSY) {
+				dev_err(&pdev->dev,
+				"Failed to request Regulator IRQ %d: %d\n",
+				irq, ret);
+				goto err_regulator;
+			}
+		}
+	}
+
+	platform_set_drvdata(pdev, regulator);
+
+	return 0;
+
+err_regulator:
+	regulator_unregister(regulator->rdev);
+err_gpio:
+	gpio_free(regulator->gpio_1);
+	gpio_free(regulator->gpio_2);
+	return ret;
+}
+
+static int __devexit da9055_regulator_remove(struct platform_device *pdev)
+{
+	struct da9055_regulator *regulator = platform_get_drvdata(pdev);
+
+	if (regulator->gpio_1)
+		gpio_free(regulator->gpio_1);
+	if (regulator->gpio_2)
+		gpio_free(regulator->gpio_2);
+
+	if (pdev->id == DA9055_ID_LDO5 || pdev->id == DA9055_ID_LDO6) {
+		int irq = platform_get_irq_byname(pdev, "REGULATOR");
+		free_irq(irq, regulator);
+	}
+
+	regulator_unregister(regulator->rdev);
+
+	return 0;
+}
+
+static struct platform_driver da9055_regulator_driver = {
+	.probe = da9055_regulator_probe,
+	.remove = __devexit_p(da9055_regulator_remove),
+	.driver = {
+		.name = "da9055-regulator",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init da9055_regulator_init(void)
+{
+	return platform_driver_register(&da9055_regulator_driver);
+}
+subsys_initcall(da9055_regulator_init);
+
+static void __exit da9055_regulator_exit(void)
+{
+	platform_driver_unregister(&da9055_regulator_driver);
+}
+module_exit(da9055_regulator_exit);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("Power Regulator driver for Dialog DA9055 PMIC");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9055-regulator");
-- 
1.7.0.4


