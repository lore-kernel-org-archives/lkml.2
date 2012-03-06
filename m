Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031054Ab2CFXqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 18:46:23 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44657 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab2CFXqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 18:46:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.236.153.6 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1331077575.20711.4.camel@phoenix>
Subject: [PATCH RFC/RFT 2/2] regulator: Refactor to use one
 da9052_ldo_ops/da9052_dcdc_ops for all LDOs/DCDCs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Wed, 07 Mar 2012 07:46:15 +0800
In-Reply-To: <1331077370.20711.2.camel@phoenix>
References: <1331077370.20711.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, da9052_ldo_ops and da9052_ldo5_6_ops are very
similar, only the set_voltage is slightly different.
da9052_buckperi_ops and da9052_dcdc_ops are also similar.

This patch adds da9052_regulator_set_voltage for the set_voltage callback
used by all LDOs and DCDCs. Rework da9052_get_regulator_voltage_sel and
da9052_set_dcdc_voltage to make it possible to be shared by all DCDCs.
Rework da9052_list_voltage to make it to be shared by all DCDCs and LDOs.

Then we can remove da9052_ldo5_6_ops and da9052_buckperi_ops.
We can also remove DA9052_LDO5_6 and DA9052_BUCKPERI macros which is not used
now.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da9052-regulator.c |  230 +++++++---------------------------
 1 files changed, 44 insertions(+), 186 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index ddcba36..7eb7293 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -189,36 +189,23 @@ static int da9052_dcdc_set_current_limit(struct regulator_dev *rdev, int min_uA,
 					 reg_val << 6);
 }
 
-static int da9052_list_buckperi_voltage(struct regulator_dev *rdev,
-					 unsigned int selector)
-{
-	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
-	struct da9052_regulator_info *info = regulator->info;
-	int volt_uV;
-
-	if ((regulator->da9052->chip_id == DA9052) &&
-	    (selector >= DA9052_BUCK_PERI_REG_MAP_UPTO_3uV)) {
-		volt_uV = ((DA9052_BUCK_PERI_REG_MAP_UPTO_3uV * info->step_uV)
-			    + info->min_uV);
-		volt_uV += (selector - DA9052_BUCK_PERI_REG_MAP_UPTO_3uV)
-			    * (DA9052_BUCK_PERI_3uV_STEP);
-	} else
-			volt_uV = (selector * info->step_uV) + info->min_uV;
-
-	if (volt_uV > info->max_uV)
-		return -EINVAL;
-
-	return volt_uV;
-}
-
 static int da9052_list_voltage(struct regulator_dev *rdev,
 				unsigned int selector)
 {
 	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
 	struct da9052_regulator_info *info = regulator->info;
+	int id = rdev_get_id(rdev);
 	int volt_uV;
 
-	volt_uV = info->min_uV + info->step_uV * selector;
+	if ((id == DA9052_ID_BUCK4) && (regulator->da9052->chip_id == DA9052)
+		&& (selector >= DA9052_BUCK_PERI_REG_MAP_UPTO_3uV)) {
+		volt_uV = ((DA9052_BUCK_PERI_REG_MAP_UPTO_3uV * info->step_uV)
+			  + info->min_uV);
+		volt_uV += (selector - DA9052_BUCK_PERI_REG_MAP_UPTO_3uV)
+				    * (DA9052_BUCK_PERI_3uV_STEP);
+	} else {
+		volt_uV = (selector * info->step_uV) + info->min_uV;
+	}
 
 	if (volt_uV > info->max_uV)
 		return -EINVAL;
@@ -226,13 +213,13 @@ static int da9052_list_voltage(struct regulator_dev *rdev,
 	return volt_uV;
 }
 
-static int da9052_regulator_set_voltage_int(struct regulator_dev *rdev,
+static int da9052_regulator_set_voltage(struct regulator_dev *rdev,
 					     int min_uV, int max_uV,
 					     unsigned int *selector)
 {
 	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
 	struct da9052_regulator_info *info = regulator->info;
-	int offset = rdev_get_id(rdev);
+	int id = rdev_get_id(rdev);
 	int ret;
 
 	ret = verify_range(info, min_uV, max_uV);
@@ -242,113 +229,43 @@ static int da9052_regulator_set_voltage_int(struct regulator_dev *rdev,
 	if (min_uV < info->min_uV)
 		min_uV = info->min_uV;
 
-	*selector = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
+	if ((id == DA9052_ID_BUCK4) && (regulator->da9052->chip_id == DA9052)
+		&& (min_uV >= DA9052_CONST_3uV)) {
+			*selector = DA9052_BUCK_PERI_REG_MAP_UPTO_3uV +
+				    DIV_ROUND_UP(min_uV - DA9052_CONST_3uV,
+						 DA9052_BUCK_PERI_3uV_STEP);
+	} else {
+		*selector = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
+	}
 
 	ret = da9052_list_voltage(rdev, *selector);
 	if (ret < 0)
 		return ret;
 
-	return da9052_reg_update(regulator->da9052,
-				 DA9052_BUCKCORE_REG + offset,
+	ret = da9052_reg_update(regulator->da9052,
+				 DA9052_BUCKCORE_REG + id,
 				 (1 << info->volt_shift) - 1, *selector);
-}
-
-static int da9052_set_ldo_voltage(struct regulator_dev *rdev,
-				   int min_uV, int max_uV,
-				   unsigned int *selector)
-{
-	return da9052_regulator_set_voltage_int(rdev, min_uV, max_uV, selector);
-}
-
-static int da9052_set_ldo5_6_voltage(struct regulator_dev *rdev,
-				      int min_uV, int max_uV,
-				      unsigned int *selector)
-{
-	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
-	struct da9052_regulator_info *info = regulator->info;
-	int ret;
-
-	ret = da9052_regulator_set_voltage_int(rdev, min_uV, max_uV, selector);
 	if (ret < 0)
 		return ret;
 
-	/* Some LDOs are DVC controlled which requires enabling of
-	 * the LDO activate bit to implment the changes on the
-	 * LDO output.
-	*/
-	return da9052_reg_update(regulator->da9052, DA9052_SUPPLY_REG,
-				 info->activate_bit, info->activate_bit);
-}
-
-static int da9052_set_dcdc_voltage(struct regulator_dev *rdev,
-				    int min_uV, int max_uV,
-				    unsigned int *selector)
-{
-	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
-	struct da9052_regulator_info *info = regulator->info;
-	int ret;
-
-	ret = da9052_regulator_set_voltage_int(rdev, min_uV, max_uV, selector);
-	if (ret < 0)
-		return ret;
-
-	/* Some DCDCs are DVC controlled which requires enabling of
-	 * the DCDC activate bit to implment the changes on the
-	 * DCDC output.
-	*/
-	return da9052_reg_update(regulator->da9052, DA9052_SUPPLY_REG,
-				 info->activate_bit, info->activate_bit);
-}
-
-static int da9052_get_regulator_voltage_sel(struct regulator_dev *rdev)
-{
-	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
-	struct da9052_regulator_info *info = regulator->info;
-	int offset = rdev_get_id(rdev);
-	int ret;
-
-	ret = da9052_reg_read(regulator->da9052, DA9052_BUCKCORE_REG + offset);
-	if (ret < 0)
-		return ret;
-
-	ret &= ((1 << info->volt_shift) - 1);
+	/* Some LDOs and DCDCs are DVC controlled which requires enabling of
+	 * the activate bit to implment the changes on the output.
+	 */
+	switch (id) {
+	case DA9052_ID_BUCK1:
+	case DA9052_ID_BUCK2:
+	case DA9052_ID_BUCK3:
+	case DA9052_ID_LDO2:
+	case DA9052_ID_LDO3:
+		ret = da9052_reg_update(regulator->da9052, DA9052_SUPPLY_REG,
+					info->activate_bit, info->activate_bit);
+		break;
+	}
 
 	return ret;
 }
 
-static int da9052_set_buckperi_voltage(struct regulator_dev *rdev, int min_uV,
-					int max_uV, unsigned int *selector)
-{
-	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
-	struct da9052_regulator_info *info = regulator->info;
-	int offset = rdev_get_id(rdev);
-	int ret;
-
-	ret = verify_range(info, min_uV, max_uV);
-	if (ret < 0)
-		return ret;
-
-	if (min_uV < info->min_uV)
-		min_uV = info->min_uV;
-
-	if ((regulator->da9052->chip_id == DA9052) &&
-	    (min_uV >= DA9052_CONST_3uV))
-		*selector = DA9052_BUCK_PERI_REG_MAP_UPTO_3uV +
-			    DIV_ROUND_UP(min_uV - DA9052_CONST_3uV,
-					 DA9052_BUCK_PERI_3uV_STEP);
-	else
-		*selector = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
-
-	ret = da9052_list_buckperi_voltage(rdev, *selector);
-	if (ret < 0)
-		return ret;
-
-	return da9052_reg_update(regulator->da9052,
-				 DA9052_BUCKCORE_REG + offset,
-				 (1 << info->volt_shift) - 1, *selector);
-}
-
-static int da9052_get_buckperi_voltage_sel(struct regulator_dev *rdev)
+static int da9052_get_regulator_voltage_sel(struct regulator_dev *rdev)
 {
 	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
 	struct da9052_regulator_info *info = regulator->info;
@@ -364,21 +281,8 @@ static int da9052_get_buckperi_voltage_sel(struct regulator_dev *rdev)
 	return ret;
 }
 
-static struct regulator_ops da9052_buckperi_ops = {
-	.list_voltage = da9052_list_buckperi_voltage,
-	.get_voltage_sel = da9052_get_buckperi_voltage_sel,
-	.set_voltage = da9052_set_buckperi_voltage,
-
-	.get_current_limit = da9052_dcdc_get_current_limit,
-	.set_current_limit = da9052_dcdc_set_current_limit,
-
-	.is_enabled = da9052_regulator_is_enabled,
-	.enable = da9052_regulator_enable,
-	.disable = da9052_regulator_disable,
-};
-
 static struct regulator_ops da9052_dcdc_ops = {
-	.set_voltage = da9052_set_dcdc_voltage,
+	.set_voltage = da9052_regulator_set_voltage,
 	.get_current_limit = da9052_dcdc_get_current_limit,
 	.set_current_limit = da9052_dcdc_set_current_limit,
 
@@ -389,18 +293,8 @@ static struct regulator_ops da9052_dcdc_ops = {
 	.disable = da9052_regulator_disable,
 };
 
-static struct regulator_ops da9052_ldo5_6_ops = {
-	.set_voltage = da9052_set_ldo5_6_voltage,
-
-	.list_voltage = da9052_list_voltage,
-	.get_voltage_sel = da9052_get_regulator_voltage_sel,
-	.is_enabled = da9052_regulator_is_enabled,
-	.enable = da9052_regulator_enable,
-	.disable = da9052_regulator_disable,
-};
-
 static struct regulator_ops da9052_ldo_ops = {
-	.set_voltage = da9052_set_ldo_voltage,
+	.set_voltage = da9052_regulator_set_voltage,
 
 	.list_voltage = da9052_list_voltage,
 	.get_voltage_sel = da9052_get_regulator_voltage_sel,
@@ -409,24 +303,6 @@ static struct regulator_ops da9052_ldo_ops = {
 	.disable = da9052_regulator_disable,
 };
 
-#define DA9052_LDO5_6(_id, step, min, max, sbits, ebits, abits) \
-{\
-	.reg_desc = {\
-		.name = #_id,\
-		.ops = &da9052_ldo5_6_ops,\
-		.type = REGULATOR_VOLTAGE,\
-		.id = DA9052_ID_##_id,\
-		.n_voltages = (max - min) / step + 1, \
-		.owner = THIS_MODULE,\
-	},\
-	.min_uV = (min) * 1000,\
-	.max_uV = (max) * 1000,\
-	.step_uV = (step) * 1000,\
-	.volt_shift = (sbits),\
-	.en_bit = (ebits),\
-	.activate_bit = (abits),\
-}
-
 #define DA9052_LDO(_id, step, min, max, sbits, ebits, abits) \
 {\
 	.reg_desc = {\
@@ -463,32 +339,14 @@ static struct regulator_ops da9052_ldo_ops = {
 	.activate_bit = (abits),\
 }
 
-#define DA9052_BUCKPERI(_id, step, min, max, sbits, ebits, abits) \
-{\
-	.reg_desc = {\
-		.name = #_id,\
-		.ops = &da9052_buckperi_ops,\
-		.type = REGULATOR_VOLTAGE,\
-		.id = DA9052_ID_##_id,\
-		.n_voltages = (max - min) / step + 1, \
-		.owner = THIS_MODULE,\
-	},\
-	.min_uV = (min) * 1000,\
-	.max_uV = (max) * 1000,\
-	.step_uV = (step) * 1000,\
-	.volt_shift = (sbits),\
-	.en_bit = (ebits),\
-	.activate_bit = (abits),\
-}
-
 static struct da9052_regulator_info da9052_regulator_info[] = {
 	DA9052_DCDC(BUCK1, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBCOREGO),
 	DA9052_DCDC(BUCK2, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBPROGO),
 	DA9052_DCDC(BUCK3, 25, 925, 2500, 6, 6, DA9052_SUPPLY_VBMEMGO),
-	DA9052_BUCKPERI(BUCK4, 50, 1800, 3600, 5, 6, 0),
+	DA9052_DCDC(BUCK4, 50, 1800, 3600, 5, 6, 0),
 	DA9052_LDO(LDO1, 50, 600, 1800, 5, 6, 0),
-	DA9052_LDO5_6(LDO2, 25, 600, 1800, 6, 6, DA9052_SUPPLY_VLDO2GO),
-	DA9052_LDO5_6(LDO3, 25, 1725, 3300, 6, 6, DA9052_SUPPLY_VLDO3GO),
+	DA9052_LDO(LDO2, 25, 600, 1800, 6, 6, DA9052_SUPPLY_VLDO2GO),
+	DA9052_LDO(LDO3, 25, 1725, 3300, 6, 6, DA9052_SUPPLY_VLDO3GO),
 	DA9052_LDO(LDO4, 25, 1725, 3300, 6, 6, 0),
 	DA9052_LDO(LDO5, 50, 1200, 3600, 6, 6, 0),
 	DA9052_LDO(LDO6, 50, 1200, 3600, 6, 6, 0),
@@ -502,10 +360,10 @@ static struct da9052_regulator_info da9053_regulator_info[] = {
 	DA9052_DCDC(BUCK1, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBCOREGO),
 	DA9052_DCDC(BUCK2, 25, 500, 2075, 6, 6, DA9052_SUPPLY_VBPROGO),
 	DA9052_DCDC(BUCK3, 25, 925, 2500, 6, 6, DA9052_SUPPLY_VBMEMGO),
-	DA9052_BUCKPERI(BUCK4, 25, 925, 2500, 6, 6, 0),
+	DA9052_DCDC(BUCK4, 25, 925, 2500, 6, 6, 0),
 	DA9052_LDO(LDO1, 50, 600, 1800, 5, 6, 0),
-	DA9052_LDO5_6(LDO2, 25, 600, 1800, 6, 6, DA9052_SUPPLY_VLDO2GO),
-	DA9052_LDO5_6(LDO3, 25, 1725, 3300, 6, 6, DA9052_SUPPLY_VLDO3GO),
+	DA9052_LDO(LDO2, 25, 600, 1800, 6, 6, DA9052_SUPPLY_VLDO2GO),
+	DA9052_LDO(LDO3, 25, 1725, 3300, 6, 6, DA9052_SUPPLY_VLDO3GO),
 	DA9052_LDO(LDO4, 25, 1725, 3300, 6, 6, 0),
 	DA9052_LDO(LDO5, 50, 1200, 3600, 6, 6, 0),
 	DA9052_LDO(LDO6, 50, 1200, 3600, 6, 6, 0),
-- 
1.7.5.4



