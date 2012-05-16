Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967401Ab2EPFMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:12:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62398 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967377Ab2EPFMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:12:43 -0400
Message-ID: <1337145155.10294.1.camel@phoenix>
Subject: [PATCH RFT] regulator: da9052: Convert to set_voltage_sel and
 map_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Wed, 16 May 2012 13:12:35 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da9052-regulator.c |   37 ++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index d2de7fc..88976d8 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -179,14 +179,13 @@ static int da9052_list_voltage(struct regulator_dev *rdev,
 	return volt_uV;
 }
 
-static int da9052_regulator_set_voltage(struct regulator_dev *rdev,
-					     int min_uV, int max_uV,
-					     unsigned int *selector)
+static int da9052_map_voltage(struct regulator_dev *rdev,
+			      int min_uV, int max_uV)
 {
 	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
 	struct da9052_regulator_info *info = regulator->info;
 	int id = rdev_get_id(rdev);
-	int ret;
+	int ret, sel;
 
 	ret = verify_range(info, min_uV, max_uV);
 	if (ret < 0)
@@ -197,19 +196,30 @@ static int da9052_regulator_set_voltage(struct regulator_dev *rdev,
 
 	if ((id == DA9052_ID_BUCK4) && (regulator->da9052->chip_id == DA9052)
 		&& (min_uV >= DA9052_CONST_3uV)) {
-			*selector = DA9052_BUCK_PERI_REG_MAP_UPTO_3uV +
-				    DIV_ROUND_UP(min_uV - DA9052_CONST_3uV,
-						 DA9052_BUCK_PERI_3uV_STEP);
+			sel = DA9052_BUCK_PERI_REG_MAP_UPTO_3uV +
+			      DIV_ROUND_UP(min_uV - DA9052_CONST_3uV,
+					   DA9052_BUCK_PERI_3uV_STEP);
 	} else {
-		*selector = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
+		sel = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
 	}
 
-	ret = da9052_list_voltage(rdev, *selector);
+	ret = da9052_list_voltage(rdev, sel);
 	if (ret < 0)
 		return ret;
 
+	return sel;
+}
+
+static int da9052_regulator_set_voltage_sel(struct regulator_dev *rdev,
+					    unsigned int selector)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	struct da9052_regulator_info *info = regulator->info;
+	int id = rdev_get_id(rdev);
+	int ret;
+
 	ret = da9052_reg_update(regulator->da9052, rdev->desc->vsel_reg,
-				rdev->desc->vsel_mask, *selector);
+				rdev->desc->vsel_mask, selector);
 	if (ret < 0)
 		return ret;
 
@@ -231,22 +241,23 @@ static int da9052_regulator_set_voltage(struct regulator_dev *rdev,
 }
 
 static struct regulator_ops da9052_dcdc_ops = {
-	.set_voltage = da9052_regulator_set_voltage,
 	.get_current_limit = da9052_dcdc_get_current_limit,
 	.set_current_limit = da9052_dcdc_set_current_limit,
 
 	.list_voltage = da9052_list_voltage,
+	.map_voltage = da9052_map_voltage,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = da9052_regulator_set_voltage_sel,
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
 };
 
 static struct regulator_ops da9052_ldo_ops = {
-	.set_voltage = da9052_regulator_set_voltage,
-
 	.list_voltage = da9052_list_voltage,
+	.map_voltage = da9052_map_voltage,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = da9052_regulator_set_voltage_sel,
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
-- 
1.7.5.4



