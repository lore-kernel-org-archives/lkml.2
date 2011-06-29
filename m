Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab1F2Ncs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 09:32:48 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:6685 "EHLO
	VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab1F2Ncq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 09:32:46 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jun 2011 09:32:46 EDT
X-SpamScore: 10
X-BigFish: VPS10(zzc8kzz1202h10d2nzz8275bhz32i2a8h668h839h64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: CIP:203.197.93.240;KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.kpit.com;EFVD:NLI
Subject: [Patch 5/11] Regulator: DA9052 regulator support v2
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linaro-dev@lists.linaro.org>, <lrg@slimlogic.co.uk>,
        <linux-kernel@vger.kernel.org>, Dajun <dajun.chen@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 18:46:03 +0530
Message-ID: <1309353363.4448.10.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DA9052 PMIC has below featured regulators:-
4 DVS Buck converters 0.5V - 3.6V upto 1Amp.
10 Programmable LDO's High PSSR, 1% accuracy.

This patch support all the DA9052 regulators. The output voltages are fully
programmable via I2C or SPI interface. The platform data with regulation
constraints is passed down from the board to the regulator.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
Changes since v2
- Check for current min_uA < 700000
- Corrected current conversions from mA to uA
---
 drivers/regulator/Kconfig            |    7 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/da9052-regulator.c |  544 ++++++++++++++++++++++++++++++++++
 3 files changed, 552 insertions(+), 0 deletions(-)
 create mode 100755 drivers/regulator/da9052-regulator.c
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index fa61fe2..ae80461 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -167,6 +167,13 @@ config REGULATOR_DA903X
 	  Say y here to support the BUCKs and LDOs regulators found on
 	  Dialog Semiconductor DA9030/DA9034 PMIC.
 
+config REGULATOR_DA9052
+        tristate "Dialog DA9052 regulators"
+        depends on PMIC_DA9052
+        help
+          Say y here to support the BUCKs and LDOs regulators found on
+          Dialog Semiconductor DA9052 PMIC.
+
 config REGULATOR_PCF50633
 	tristate "PCF50633 regulator driver"
         depends on MFD_PCF50633
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 8cb6d0d..3738361 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_WM8994) += wm8994-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6586X) += tps6586x-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
+obj-$(CONFIG_REGULATOR_DA9052) += da9052-regulator.o
 obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
 obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
new file mode 100755
index 0000000..e7126d7
--- /dev/null
+++ b/drivers/regulator/da9052-regulator.c
@@ -0,0 +1,544 @@
+/*
+* da9052-regulator.c: Regulator driver for DA9052
+*
+* Copyright(c) 2011 Dialog Semiconductor Ltd.
+*
+*Author: David Dajun Chen <dchen@diasemi.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License as published by
+* the Free Software Foundation; either version 2 of the License, or
+* (at your option) any later version.
+*
+*/
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/pdata.h>
+
+/* Buck step size */
+#define DA9052_BUCK_PERI_3uV_STEP		100000
+#define DA9052_BUCK_PERI_REG_MAP_UPTO_3uV	24
+#define DA9052_CONST_3uV			3000000
+
+/* Buck current limits */
+#define DA9052_BUCK_CURRENT_LIMIT_700mA         0
+#define DA9052_BUCK_CURRENT_LIMIT_800mA         1
+#define DA9052_BUCK_CURRENT_LIMIT_1000mA        2
+#define DA9052_BUCK_CURRENT_LIMIT_1200mA        3
+
+/* Bit masks */
+#define DA9052_BUCK_ILIM_MASK_EVEN	0x3F
+#define DA9052_BUCK_ILIM_MASK_ODD	0xF3
+
+struct da9052_regulator_info {
+	struct regulator_desc reg_desc;
+	int step_uV;
+	int min_uV;
+	int max_uV;
+	unsigned char volt_shift;
+	unsigned char en_bit;
+	unsigned char activate_bit;
+};
+
+struct da9052_regulator {
+	struct da9052 *da9052;
+	struct da9052_regulator_info *info;
+	struct regulator_dev *rdev;
+};
+
+static int verify_range(struct da9052_regulator_info *info,
+			 int min_uV, int max_uV)
+{
+	if (min_uV < info->min_uV || min_uV > info->max_uV)
+		return -EINVAL;
+	if (max_uV < info->min_uV || max_uV > info->max_uV)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int da9052_regulator_enable(struct regulator_dev *rdev)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9052_regulator_info *info = regulator->info;
+	int offset = rdev_get_id(rdev);
+
+	return da9052_reg_update(regulator->da9052,
+				 DA9052_BUCKCORE_REG + offset,
+				 1 << info->en_bit, 1);
+}
+
+static int da9052_regulator_disable(struct regulator_dev *rdev)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9052_regulator_info *info = regulator->info;
+	int offset = rdev_get_id(rdev);
+
+	return da9052_reg_update(regulator->da9052,
+				 DA9052_BUCKCORE_REG + offset,
+				 1 << info->en_bit, 0);
+}
+
+static int da9052_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9052_regulator_info *info = regulator->info;
+	int offset = rdev_get_id(rdev);
+	int ret;
+
+	ret = da9052_reg_read(regulator->da9052, DA9052_BUCKCORE_REG + offset);
+	if (ret < 0)
+		return ret;
+
+	return ret & (1 << info->en_bit);
+}
+
+static int da9052_dcdc_get_current_limit(struct regulator_dev *rdev)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	int offset = rdev_get_id(rdev);
+	int ret;
+
+	ret = da9052_reg_read(regulator->da9052, DA9052_BUCKA_REG + offset/2);
+	if (ret < 0)
+		return ret;
+
+	/* Determine the even or odd position of the buck current limit
+	 * register field */
+	if (offset % 2 == 0)
+		ret = (ret & DA9052_BUCK_ILIM_MASK_EVEN) >> 2;
+	else
+		ret = (ret & DA9052_BUCK_ILIM_MASK_ODD) >> 6;
+
+	return ret;
+}
+
+static int da9052_dcdc_set_current_limit(struct regulator_dev *rdev, int min_uA,
+					  int max_uA)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	int offset = rdev_get_id(rdev);
+	int reg_val;
+
+	if (min_uA < 700000 || min_uA > 1200000)
+		return -EINVAL;
+	if (max_uA < 700000 || max_uA > 1200000)
+		return -EINVAL;
+
+	if (min_uA == 700000)
+		reg_val = DA9052_BUCK_CURRENT_LIMIT_700mA;
+	else if (min_uA <= 800000)
+		reg_val = DA9052_BUCK_CURRENT_LIMIT_800mA;
+	else if (min_uA <= 1000000)
+		reg_val = DA9052_BUCK_CURRENT_LIMIT_1000mA;
+	else if (min_uA <= 1200000)
+		reg_val = DA9052_BUCK_CURRENT_LIMIT_1200mA;
+
+	/* Determine the even or odd position of the buck current limit
+	 * register field */
+	if (offset % 2 == 0)
+		return da9052_reg_update(regulator->da9052,
+					 DA9052_BUCKA_REG + offset/2,
+					 DA9052_BUCK_ILIM_MASK_EVEN,
+					 reg_val << 2);
+	else
+		return da9052_reg_update(regulator->da9052,
+					 DA9052_BUCKA_REG + offset/2,
+					 DA9052_BUCK_ILIM_MASK_ODD,
+					 reg_val << 6);
+}
+
+static int da9052_list_buckperi_voltage(struct regulator_dev *rdev,
+					 unsigned int selector)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9052_regulator_info *info = regulator->info;
+	int volt_uV;
+
+	if (selector >= DA9052_BUCK_PERI_REG_MAP_UPTO_3uV) {
+		volt_uV = ((DA9052_BUCK_PERI_REG_MAP_UPTO_3uV * info->step_uV) +
+			    info->min_uV);
+		volt_uV += (selector - DA9052_BUCK_PERI_REG_MAP_UPTO_3uV)
+			    * (DA9052_BUCK_PERI_3uV_STEP);
+	} else
+		volt_uV = (selector * info->step_uV) + info->min_uV;
+
+	if (volt_uV > info->max_uV)
+		return -EINVAL;
+
+	return volt_uV;
+}
+
+static int da9052_list_voltage(struct regulator_dev *rdev,
+			        unsigned int selector)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9052_regulator_info *info = regulator->info;
+	int volt_uV;
+
+	volt_uV = info->min_uV + info->step_uV * selector;
+
+	if (volt_uV > info->max_uV)
+		return -EINVAL;
+
+	return volt_uV;
+}
+
+static int da9052_regulator_set_voltage_int(struct regulator_dev *rdev,
+					     int min_uV, int max_uV,
+					     unsigned int *selector)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9052_regulator_info *info = regulator->info;
+	int offset = rdev_get_id(rdev);
+	int ret;
+
+	ret = verify_range(info, min_uV, max_uV);
+	if (ret < 0)
+		return ret;
+
+	*selector = (min_uV - info->min_uV) / info->step_uV;
+
+	ret = da9052_list_voltage(rdev, *selector);
+	if (ret < 0)
+		return ret;
+
+	return da9052_reg_update(regulator->da9052,
+				 DA9052_BUCKCORE_REG + offset,
+				 (1 << info->volt_shift) - 1, *selector);
+}
+
+static int da9052_set_ldo_voltage(struct regulator_dev *rdev,
+				   int min_uV, int max_uV,
+				   unsigned int *selector)
+{
+	return da9052_regulator_set_voltage_int(rdev, min_uV, max_uV, selector);
+}
+
+static int da9052_set_ldo5_6_voltage(struct regulator_dev *rdev,
+				      int min_uV, int max_uV,
+				      unsigned int *selector)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9052_regulator_info *info = regulator->info;
+	int ret;
+
+	ret = da9052_regulator_set_voltage_int(rdev, min_uV, max_uV, selector);
+	if (ret < 0)
+		return ret;
+
+	/* Some LD0s are DVC controlled which requires enabling of
+	 * the LDO activate bit to implment the changes on the
+	 * LDO output. */
+	return da9052_reg_update(regulator->da9052, DA9052_SUPPLY_REG, 0,
+				 info->activate_bit);
+}
+
+static int da9052_set_dcdc_voltage(struct regulator_dev *rdev,
+				    int min_uV, int max_uV,
+				    unsigned int *selector)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9052_regulator_info *info = regulator->info;
+	int ret;
+
+	ret = da9052_regulator_set_voltage_int(rdev, min_uV, max_uV, selector);
+	if (ret < 0)
+		return ret;
+
+	/* Some DCDCs are DVC controlled which requires enabling of
+	 * the DCDC activate bit to implment the changes on the
+	 * DCDC output. */
+	return da9052_reg_update(regulator->da9052, DA9052_SUPPLY_REG, 0,
+				 info->activate_bit);
+}
+
+static int da9052_get_regulator_voltage_sel(struct regulator_dev *rdev)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9052_regulator_info *info = regulator->info;
+	int offset = rdev_get_id(rdev);
+	int ret;
+
+	ret = da9052_reg_read(regulator->da9052, DA9052_BUCKCORE_REG + offset);
+	if (ret < 0)
+		return ret;
+
+	ret &= ((1 << info->volt_shift) - 1);
+
+	return ret;
+}
+
+static int da9052_set_buckperi_voltage(struct regulator_dev *rdev, int min_uV,
+				        int max_uV, unsigned int *selector)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9052_regulator_info *info = regulator->info;
+	int offset = rdev_get_id(rdev);
+	int ret;
+
+	ret = verify_range(info, min_uV, max_uV);
+	if (ret < 0)
+		return ret;
+
+	if (min_uV >= DA9052_CONST_3uV)
+		*selector = DA9052_CONST_3uV + ((min_uV - DA9052_CONST_3uV) /
+			    (DA9052_BUCK_PERI_3uV_STEP));
+	else
+		*selector = (min_uV - info->min_uV) / info->step_uV;
+
+	ret = da9052_list_buckperi_voltage(rdev, *selector);
+	if (ret < 0)
+		return ret;
+
+	return da9052_reg_update(regulator->da9052,
+				 DA9052_BUCKCORE_REG + offset,
+				 (1 << info->volt_shift) - 1, *selector);
+}
+
+static int da9052_get_buckperi_voltage_sel(struct regulator_dev *rdev)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9052_regulator_info *info = regulator->info;
+	int offset = rdev_get_id(rdev);
+	int ret;
+
+	ret = da9052_reg_read(regulator->da9052, DA9052_BUCKCORE_REG + offset);
+	if (ret < 0)
+		return ret;
+
+	ret &= ((1 << info->volt_shift) - 1);
+
+	return ret;
+}
+
+static struct regulator_ops da9052_buckperi_ops = {
+	.list_voltage = da9052_list_buckperi_voltage,
+	.get_voltage_sel = da9052_get_buckperi_voltage_sel,
+	.set_voltage = da9052_set_buckperi_voltage,
+
+	.get_current_limit = da9052_dcdc_get_current_limit,
+	.set_current_limit = da9052_dcdc_set_current_limit,
+
+	.is_enabled = da9052_regulator_is_enabled,
+	.enable = da9052_regulator_enable,
+	.disable = da9052_regulator_disable,
+};
+
+static struct regulator_ops da9052_dcdc_ops = {
+	.set_voltage = da9052_set_dcdc_voltage,
+	.get_current_limit = da9052_dcdc_get_current_limit,
+	.set_current_limit = da9052_dcdc_set_current_limit,
+
+	.list_voltage = da9052_list_voltage,
+	.get_voltage_sel = da9052_get_regulator_voltage_sel,
+	.is_enabled = da9052_regulator_is_enabled,
+	.enable = da9052_regulator_enable,
+	.disable = da9052_regulator_disable,
+};
+
+static struct regulator_ops da9052_ldo5_6_ops = {
+	.set_voltage = da9052_set_ldo5_6_voltage,
+
+	.list_voltage = da9052_list_voltage,
+	.get_voltage_sel = da9052_get_regulator_voltage_sel,
+	.is_enabled = da9052_regulator_is_enabled,
+	.enable = da9052_regulator_enable,
+	.disable = da9052_regulator_disable,
+};
+
+static struct regulator_ops da9052_ldo_ops = {
+	.set_voltage = da9052_set_ldo_voltage,
+
+	.list_voltage = da9052_list_voltage,
+	.get_voltage_sel = da9052_get_regulator_voltage_sel,
+	.is_enabled = da9052_regulator_is_enabled,
+	.enable = da9052_regulator_enable,
+	.disable = da9052_regulator_disable,
+};
+
+#define DA9052_LDO5_6(_id, step, min, max, sbits, ebits, abits) \
+{\
+	.reg_desc = {\
+		.name = "LDO" #_id,\
+		.ops = &da9052_ldo5_6_ops,\
+		.type = REGULATOR_VOLTAGE,\
+		.id = _id,\
+		.owner = THIS_MODULE,\
+	},\
+	.min_uV = (min) * 1000,\
+	.max_uV = (max) * 1000,\
+	.step_uV = (step) * 1000,\
+	.volt_shift = (sbits),\
+	.en_bit = (ebits),\
+	.activate_bit = (abits),\
+}
+
+#define DA9052_LDO(_id, step, min, max, sbits, ebits, abits) \
+{\
+	.reg_desc = {\
+		.name = "LDO" #_id,\
+		.ops = &da9052_ldo_ops,\
+		.type = REGULATOR_VOLTAGE,\
+		.id = _id,\
+		.owner = THIS_MODULE,\
+	},\
+	.min_uV = (min) * 1000,\
+	.max_uV = (max) * 1000,\
+	.step_uV = (step) * 1000,\
+	.volt_shift = (sbits),\
+	.en_bit = (ebits),\
+	.activate_bit = (abits),\
+}
+
+#define DA9052_DCDC(_id, step, min, max, sbits, ebits, abits) \
+{\
+	.reg_desc = {\
+		.name = "BUCK" #_id,\
+		.ops = &da9052_dcdc_ops,\
+		.type = REGULATOR_VOLTAGE,\
+		.id = _id,\
+		.owner = THIS_MODULE,\
+	},\
+	.min_uV = (min) * 1000,\
+	.max_uV = (max) * 1000,\
+	.step_uV = (step) * 1000,\
+	.volt_shift = (sbits),\
+	.en_bit = (ebits),\
+	.activate_bit = (abits),\
+}
+
+#define DA9052_BUCKPERI(_id, step, min, max, sbits, ebits, abits) \
+{\
+	.reg_desc = {\
+		.name = "BUCK" #_id,\
+		.ops = &da9052_buckperi_ops,\
+		.type = REGULATOR_VOLTAGE,\
+		.id = _id,\
+		.owner = THIS_MODULE,\
+	},\
+	.min_uV = (min) * 1000,\
+	.max_uV = (max) * 1000,\
+	.step_uV = (step) * 1000,\
+	.volt_shift = (sbits),\
+	.en_bit = (ebits),\
+	.activate_bit = (abits),\
+}
+
+struct da9052_regulator_info da9052_regulator_info[] = {
+	/* Buck1 - 4*/
+	DA9052_DCDC(0, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBCOREGO),
+	DA9052_DCDC(1, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBPROGO),
+	DA9052_DCDC(2, 25, 925, 2500, 6, 6, DA9052_SUPPLY_VBMEMGO),
+	DA9052_BUCKPERI(3, 50, 1800, 3600, 5, 6, 0),
+	/* LD01 - LDO10*/
+	DA9052_LDO(4, 50, 600, 1800, 5, 6, 0),
+	DA9052_LDO5_6(5, 25, 600, 1800, 6, 6, DA9052_SUPPLY_VLDO2GO),
+	DA9052_LDO5_6(6, 25, 1725, 3300, 6, 6, DA9052_SUPPLY_VLDO3GO),
+	DA9052_LDO(7, 25, 1725, 3300, 6, 6, 0),
+	DA9052_LDO(8, 50, 1200, 3600, 6, 6, 0),
+	DA9052_LDO(9, 50, 1200, 3600, 6, 6, 0),
+	DA9052_LDO(10, 50, 1200, 3600, 6, 6, 0),
+	DA9052_LDO(11, 50, 1200, 3600, 6, 6, 0),
+	DA9052_LDO(12, 50, 1250, 3650, 6, 6, 0),
+	DA9052_LDO(13, 50, 1200, 3600, 6, 6, 0),
+};
+
+static inline struct da9052_regulator_info *find_regulator_info(int id)
+{
+	struct da9052_regulator_info *info;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(da9052_regulator_info); i++) {
+		info = &da9052_regulator_info[i];
+		if (info->reg_desc.id == id)
+			return info;
+	}
+
+	return NULL;
+}
+
+static int __devinit da9052_regulator_probe(struct platform_device *pdev)
+{
+	struct da9052_regulator *regulator;
+	struct da9052 *da9052;
+	struct da9052_pdata *pdata;
+	int ret;
+
+	regulator = kzalloc(sizeof(struct da9052_regulator), GFP_KERNEL);
+	if (!regulator)
+		return -ENOMEM;
+
+	da9052 = dev_get_drvdata(pdev->dev.parent);
+	pdata = da9052->dev->platform_data;
+
+	regulator->info = find_regulator_info(pdev->id);
+	if (regulator->info == NULL) {
+		dev_err(&pdev->dev, "invalid regulator ID specified\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	regulator->rdev = regulator_register(&regulator->info->reg_desc,
+					     &pdev->dev,
+					     pdata->regulators[pdev->id],
+					     regulator);
+	if (IS_ERR(regulator->rdev)) {
+		dev_err(&pdev->dev, "failed to register regulator %s\n",
+			regulator->info->reg_desc.name);
+		ret = PTR_ERR(regulator->rdev);
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, regulator);
+
+	return 0;
+err:
+	kfree(regulator);
+	return ret;
+}
+
+static int __devexit da9052_regulator_remove(struct platform_device *pdev)
+{
+	struct da9052_regulator *regulator = platform_get_drvdata(pdev);
+
+	regulator_unregister(regulator->rdev);
+	kfree(regulator);
+
+	return 0;
+}
+
+static struct platform_driver da9052_regulator_driver = {
+	.probe = da9052_regulator_probe,
+	.remove = __devexit_p(da9052_regulator_remove),
+	.driver = {
+		.name = "da9052-regulator",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init da9052_regulator_init(void)
+{
+	return platform_driver_register(&da9052_regulator_driver);
+}
+subsys_initcall(da9052_regulator_init);
+
+static void __exit da9052_regulator_exit(void)
+{
+	platform_driver_unregister(&da9052_regulator_driver);
+}
+module_exit(da9052_regulator_exit);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("Power Regulator driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9052-regulator");


