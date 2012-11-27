Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab2K0C0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 21:26:22 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50471 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab2K0C0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 21:26:21 -0500
Message-ID: <1353983174.5422.4.camel@phoenix>
Subject: [RFC/RFT][PATCH 2/4] regulator: da9055: Use linear_min_sel and
 regulator_[map|list]_voltage_linear
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Tue, 27 Nov 2012 10:26:14 +0800
In-Reply-To: <1353983073.5422.2.camel@phoenix>
References: <1353983073.5422.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/da9055-regulator.c |   55 +++++-----------------------------
 1 file changed, 8 insertions(+), 47 deletions(-)

diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
index db59ce7..a4b9cb8 100644
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -57,7 +57,6 @@ struct da9055_volt_reg {
 	int reg_a;
 	int reg_b;
 	int sl_shift;
-	int v_offset;
 	int v_mask;
 	int v_shift;
 };
@@ -201,41 +200,6 @@ static int da9055_buck_set_current_limit(struct regulator_dev *rdev, int min_uA,
 	return -EINVAL;
 }
 
-static int da9055_list_voltage(struct regulator_dev *rdev, unsigned selector)
-{
-	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
-	struct da9055_regulator_info *info = regulator->info;
-
-	if (selector >= rdev->desc->n_voltages)
-		return -EINVAL;
-
-	if (selector < info->volt.v_offset)
-		return 0;
-
-	selector -= info->volt.v_offset;
-	return rdev->desc->min_uV + (rdev->desc->uV_step * selector);
-}
-
-static int da9055_map_voltage(struct regulator_dev *rdev, int min_uV,
-			      int max_uV)
-{
-	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
-	struct da9055_regulator_info *info = regulator->info;
-	int sel, voltage;
-
-	if (min_uV < rdev->desc->min_uV)
-		min_uV = rdev->desc->min_uV;
-
-	sel = DIV_ROUND_UP(min_uV - rdev->desc->min_uV, rdev->desc->uV_step);
-	sel += info->volt.v_offset;
-
-	voltage = da9055_list_voltage(rdev, sel);
-	if (voltage < min_uV || voltage > max_uV)
-		return -EINVAL;
-
-	return sel;
-}
-
 static int da9055_regulator_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
@@ -264,10 +228,7 @@ static int da9055_regulator_get_voltage_sel(struct regulator_dev *rdev)
 		return ret;
 
 	sel = (ret & volt.v_mask);
-	if (sel <= volt.v_offset)
-		return 0;
-	else
-		return sel;
+	return sel;
 }
 
 static int da9055_regulator_set_voltage_sel(struct regulator_dev *rdev,
@@ -328,7 +289,7 @@ static int da9055_regulator_set_suspend_voltage(struct regulator_dev *rdev,
 			return ret;
 	}
 
-	ret = da9055_map_voltage(rdev, uV, uV);
+	ret = regulator_map_voltage_linear(rdev, uV, uV);
 	if (ret < 0)
 		return ret;
 
@@ -371,8 +332,8 @@ static struct regulator_ops da9055_buck_ops = {
 
 	.get_voltage_sel = da9055_regulator_get_voltage_sel,
 	.set_voltage_sel = da9055_regulator_set_voltage_sel,
-	.list_voltage = da9055_list_voltage,
-	.map_voltage = da9055_map_voltage,
+	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
@@ -389,8 +350,8 @@ static struct regulator_ops da9055_ldo_ops = {
 
 	.get_voltage_sel = da9055_regulator_get_voltage_sel,
 	.set_voltage_sel = da9055_regulator_set_voltage_sel,
-	.list_voltage = da9055_list_voltage,
-	.map_voltage = da9055_map_voltage,
+	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
@@ -414,6 +375,7 @@ static struct regulator_ops da9055_ldo_ops = {
 		.enable_mask = 1, \
 		.min_uV = (min) * 1000,\
 		.uV_step = (step) * 1000,\
+		.linear_min_sel = (voffset),\
 		.owner = THIS_MODULE,\
 	},\
 	.conf = {\
@@ -425,7 +387,6 @@ static struct regulator_ops da9055_ldo_ops = {
 		.reg_a = DA9055_REG_VBCORE_A + DA9055_ID_##_id, \
 		.reg_b = DA9055_REG_VBCORE_B + DA9055_ID_##_id, \
 		.sl_shift = 7,\
-		.v_offset = (voffset),\
 		.v_mask = (1 << (vbits)) - 1,\
 		.v_shift = (vbits),\
 	},\
@@ -443,6 +404,7 @@ static struct regulator_ops da9055_ldo_ops = {
 		.enable_mask = 1,\
 		.min_uV = (min) * 1000,\
 		.uV_step = (step) * 1000,\
+		.linear_min_sel = (voffset),\
 		.owner = THIS_MODULE,\
 	},\
 	.conf = {\
@@ -454,7 +416,6 @@ static struct regulator_ops da9055_ldo_ops = {
 		.reg_a = DA9055_REG_VBCORE_A + DA9055_ID_##_id, \
 		.reg_b = DA9055_REG_VBCORE_B + DA9055_ID_##_id, \
 		.sl_shift = 7,\
-		.v_offset = (voffset),\
 		.v_mask = (1 << (vbits)) - 1,\
 		.v_shift = (vbits),\
 	},\
-- 
1.7.9.5



