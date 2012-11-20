Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab2KTHg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:36:58 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43831 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab2KTHg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:36:57 -0500
Message-ID: <1353397006.10137.2.camel@phoenix>
Subject: [PATCH RFT] regulator: da9055: Properly handle voltage range that
 doesn't start with 0 offset
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Tue, 20 Nov 2012 15:36:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements map_voltage and list_voltage callbacks to properly handle
the case voltage range that doesn't start with 0 offset.

Now we adjust the selector in map_voltage() before calling set_voltage_sel().
And return 0 in list_voltage() for invalid selectors.

With above change, we can remove da9055_regulator_set_voltage_bits function.

One tricky part is that we need adding voffset to n_voltages.
Although for the cases "selector < voffset" are invalid, we need add voffset to
n_voltage so regulator_list_voltage() won't fail while checking the boundary for
selector before calling list_voltage callback.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Ashish,
  I don't have this hardware to test this patch.
  Can you help to review and test this patch?
Thank you,
Axel

 drivers/regulator/da9055-regulator.c |   80 +++++++++++++++++++++-------------
 1 file changed, 50 insertions(+), 30 deletions(-)

diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
index 79c5665..a486b19 100644
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -204,6 +204,41 @@ static int da9055_buck_set_current_limit(struct regulator_dev *rdev, int min_uA,
 				info->mode.mask, val << info->mode.shift);
 }
 
+static int da9055_list_voltage(struct regulator_dev *rdev, unsigned selector)
+{
+	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9055_regulator_info *info = regulator->info;
+
+	if (selector >= rdev->desc->n_voltages)
+		return -EINVAL;
+
+	if (selector < info->volt.v_offset)
+		return 0;
+
+	selector -= info->volt.v_offset;
+	return rdev->desc->min_uV + (rdev->desc->uV_step * selector);
+}
+
+static int da9055_map_voltage(struct regulator_dev *rdev, int min_uV,
+			      int max_uV)
+{
+	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9055_regulator_info *info = regulator->info;
+	int sel, voltage;
+
+	if (min_uV < rdev->desc->min_uV)
+		min_uV = rdev->desc->min_uV;
+
+	sel = DIV_ROUND_UP(min_uV - rdev->desc->min_uV, rdev->desc->uV_step);
+	sel += info->volt.v_offset;
+
+	voltage = da9055_list_voltage(rdev, sel);
+	if (voltage < min_uV || voltage > max_uV)
+		return -EINVAL;
+
+	return sel;
+}
+
 static int da9055_regulator_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
@@ -238,22 +273,6 @@ static int da9055_regulator_get_voltage_sel(struct regulator_dev *rdev)
 		return sel;
 }
 
-static int da9055_regulator_set_voltage_bits(struct regulator_dev *rdev,
-					     unsigned int reg,
-					     unsigned int selector)
-{
-	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
-	struct da9055_regulator_info *info = regulator->info;
-
-	/* Takes care of voltage range that does not start with 0 offset. */
-	selector += info->volt.v_offset;
-
-	/* Set the voltage */
-	return da9055_reg_update(regulator->da9055, reg, info->volt.v_mask,
-				 selector);
-
-}
-
 static int da9055_regulator_set_voltage_sel(struct regulator_dev *rdev,
 					    unsigned int selector)
 {
@@ -273,8 +292,8 @@ static int da9055_regulator_set_voltage_sel(struct regulator_dev *rdev,
 			return ret;
 
 		/* Set the voltage */
-		return da9055_regulator_set_voltage_bits(rdev, info->volt.reg_a,
-							 selector);
+		return da9055_reg_update(regulator->da9055, info->volt.reg_a,
+					 info->volt.v_mask, selector);
 	}
 
 	/*
@@ -290,11 +309,11 @@ static int da9055_regulator_set_voltage_sel(struct regulator_dev *rdev,
 
 	/* Set the voltage */
 	if (ret == DA9055_REGUALTOR_SET_A)
-		return da9055_regulator_set_voltage_bits(rdev, info->volt.reg_a,
-							 selector);
+		return da9055_reg_update(regulator->da9055, info->volt.reg_a,
+					 info->volt.v_mask, selector);
 	else
-		return da9055_regulator_set_voltage_bits(rdev, info->volt.reg_b,
-						 selector);
+		return da9055_reg_update(regulator->da9055, info->volt.reg_b,
+					 info->volt.v_mask, selector);
 }
 
 static int da9055_regulator_set_suspend_voltage(struct regulator_dev *rdev,
@@ -312,11 +331,12 @@ static int da9055_regulator_set_suspend_voltage(struct regulator_dev *rdev,
 			return ret;
 	}
 
-	ret = regulator_map_voltage_linear(rdev, uV, uV);
+	ret = da9055_map_voltage(rdev, uV, uV);
 	if (ret < 0)
 		return ret;
 
-	return da9055_regulator_set_voltage_bits(rdev, info->volt.reg_b, ret);
+	return da9055_reg_update(regulator->da9055, info->volt.reg_b,
+				 info->volt.v_mask, ret);
 }
 
 static int da9055_suspend_enable(struct regulator_dev *rdev)
@@ -354,8 +374,8 @@ static struct regulator_ops da9055_buck_ops = {
 
 	.get_voltage_sel = da9055_regulator_get_voltage_sel,
 	.set_voltage_sel = da9055_regulator_set_voltage_sel,
-	.list_voltage = regulator_list_voltage_linear,
-	.map_voltage = regulator_map_voltage_linear,
+	.list_voltage = da9055_list_voltage,
+	.map_voltage = da9055_map_voltage,
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
@@ -372,8 +392,8 @@ static struct regulator_ops da9055_ldo_ops = {
 
 	.get_voltage_sel = da9055_regulator_get_voltage_sel,
 	.set_voltage_sel = da9055_regulator_set_voltage_sel,
-	.list_voltage = regulator_list_voltage_linear,
-	.map_voltage = regulator_map_voltage_linear,
+	.list_voltage = da9055_list_voltage,
+	.map_voltage = da9055_map_voltage,
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
@@ -392,7 +412,7 @@ static struct regulator_ops da9055_ldo_ops = {
 		.ops = &da9055_ldo_ops,\
 		.type = REGULATOR_VOLTAGE,\
 		.id = DA9055_ID_##_id,\
-		.n_voltages = (max - min) / step + 1, \
+		.n_voltages = (max - min) / step + 1 + (voffset), \
 		.enable_reg = DA9055_REG_BCORE_CONT + DA9055_ID_##_id, \
 		.enable_mask = 1, \
 		.min_uV = (min) * 1000,\
@@ -421,7 +441,7 @@ static struct regulator_ops da9055_ldo_ops = {
 		.ops = &da9055_buck_ops,\
 		.type = REGULATOR_VOLTAGE,\
 		.id = DA9055_ID_##_id,\
-		.n_voltages = (max - min) / step + 1, \
+		.n_voltages = (max - min) / step + 1 + (voffset), \
 		.enable_reg = DA9055_REG_BCORE_CONT + DA9055_ID_##_id, \
 		.enable_mask = 1,\
 		.min_uV = (min) * 1000,\
-- 
1.7.9.5



