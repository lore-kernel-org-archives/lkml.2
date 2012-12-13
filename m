Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab2LMIrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 03:47:22 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51672 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab2LMIrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 03:47:20 -0500
Message-ID: <1355388433.31434.7.camel@phoenix>
Subject: [RFC/RFT][PATCH 3/4] regulator: da9052: Use activate_[reg|bit] with
 regmap based voltage_sel operations
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Thu, 13 Dec 2012 16:47:13 +0800
In-Reply-To: <1355388248.31434.3.camel@phoenix>
References: <1355388248.31434.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/da9052-regulator.c |   41 +++++-----------------------------
 1 file changed, 6 insertions(+), 35 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index d096309..47455ad 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -70,7 +70,6 @@ struct da9052_regulator_info {
 	int step_uV;
 	int min_uV;
 	int max_uV;
-	unsigned char activate_bit;
 };
 
 struct da9052_regulator {
@@ -210,36 +209,6 @@ static int da9052_map_voltage(struct regulator_dev *rdev,
 	return sel;
 }
 
-static int da9052_regulator_set_voltage_sel(struct regulator_dev *rdev,
-					    unsigned int selector)
-{
-	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
-	struct da9052_regulator_info *info = regulator->info;
-	int id = rdev_get_id(rdev);
-	int ret;
-
-	ret = da9052_reg_update(regulator->da9052, rdev->desc->vsel_reg,
-				rdev->desc->vsel_mask, selector);
-	if (ret < 0)
-		return ret;
-
-	/* Some LDOs and DCDCs are DVC controlled which requires enabling of
-	 * the activate bit to implment the changes on the output.
-	 */
-	switch (id) {
-	case DA9052_ID_BUCK1:
-	case DA9052_ID_BUCK2:
-	case DA9052_ID_BUCK3:
-	case DA9052_ID_LDO2:
-	case DA9052_ID_LDO3:
-		ret = da9052_reg_update(regulator->da9052, DA9052_SUPPLY_REG,
-					info->activate_bit, info->activate_bit);
-		break;
-	}
-
-	return ret;
-}
-
 static struct regulator_ops da9052_dcdc_ops = {
 	.get_current_limit = da9052_dcdc_get_current_limit,
 	.set_current_limit = da9052_dcdc_set_current_limit,
@@ -247,7 +216,7 @@ static struct regulator_ops da9052_dcdc_ops = {
 	.list_voltage = da9052_list_voltage,
 	.map_voltage = da9052_map_voltage,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
-	.set_voltage_sel = da9052_regulator_set_voltage_sel,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
@@ -257,7 +226,7 @@ static struct regulator_ops da9052_ldo_ops = {
 	.list_voltage = da9052_list_voltage,
 	.map_voltage = da9052_map_voltage,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
-	.set_voltage_sel = da9052_regulator_set_voltage_sel,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
@@ -274,13 +243,14 @@ static struct regulator_ops da9052_ldo_ops = {
 		.owner = THIS_MODULE,\
 		.vsel_reg = DA9052_BUCKCORE_REG + DA9052_ID_##_id, \
 		.vsel_mask = (1 << (sbits)) - 1,\
+		.activate_reg = DA9052_SUPPLY_REG, \
+		.activate_bit = (abits), \
 		.enable_reg = DA9052_BUCKCORE_REG + DA9052_ID_##_id, \
 		.enable_mask = 1 << (ebits),\
 	},\
 	.min_uV = (min) * 1000,\
 	.max_uV = (max) * 1000,\
 	.step_uV = (step) * 1000,\
-	.activate_bit = (abits),\
 }
 
 #define DA9052_DCDC(_id, step, min, max, sbits, ebits, abits) \
@@ -294,13 +264,14 @@ static struct regulator_ops da9052_ldo_ops = {
 		.owner = THIS_MODULE,\
 		.vsel_reg = DA9052_BUCKCORE_REG + DA9052_ID_##_id, \
 		.vsel_mask = (1 << (sbits)) - 1,\
+		.activate_reg = DA9052_SUPPLY_REG, \
+		.activate_bit = (abits), \
 		.enable_reg = DA9052_BUCKCORE_REG + DA9052_ID_##_id, \
 		.enable_mask = 1 << (ebits),\
 	},\
 	.min_uV = (min) * 1000,\
 	.max_uV = (max) * 1000,\
 	.step_uV = (step) * 1000,\
-	.activate_bit = (abits),\
 }
 
 static struct da9052_regulator_info da9052_regulator_info[] = {
-- 
1.7.9.5



