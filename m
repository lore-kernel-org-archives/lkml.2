Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab2DQDek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 23:34:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50409 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab2DQDeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 23:34:37 -0400
Message-ID: <1334633672.22293.3.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: da9052: Use generic regmap
 enable/disable operations
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 17 Apr 2012 11:34:32 +0800
In-Reply-To: <1334633577.22293.1.camel@phoenix>
References: <1334633577.22293.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da9052-regulator.c |   56 +++++++---------------------------
 1 files changed, 11 insertions(+), 45 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index eaa91cc5..4f2e6f9 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -71,7 +71,6 @@ struct da9052_regulator_info {
 	int min_uV;
 	int max_uV;
 	unsigned char volt_shift;
-	unsigned char en_bit;
 	unsigned char activate_bit;
 };
 
@@ -90,42 +89,6 @@ static int verify_range(struct da9052_regulator_info *info,
 	return 0;
 }
 
-static int da9052_regulator_enable(struct regulator_dev *rdev)
-{
-	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
-	struct da9052_regulator_info *info = regulator->info;
-	int offset = rdev_get_id(rdev);
-
-	return da9052_reg_update(regulator->da9052,
-				 DA9052_BUCKCORE_REG + offset,
-				 1 << info->en_bit, 1 << info->en_bit);
-}
-
-static int da9052_regulator_disable(struct regulator_dev *rdev)
-{
-	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
-	struct da9052_regulator_info *info = regulator->info;
-	int offset = rdev_get_id(rdev);
-
-	return da9052_reg_update(regulator->da9052,
-				 DA9052_BUCKCORE_REG + offset,
-				 1 << info->en_bit, 0);
-}
-
-static int da9052_regulator_is_enabled(struct regulator_dev *rdev)
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
-	return ret & (1 << info->en_bit);
-}
-
 static int da9052_dcdc_get_current_limit(struct regulator_dev *rdev)
 {
 	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
@@ -292,9 +255,9 @@ static struct regulator_ops da9052_dcdc_ops = {
 
 	.list_voltage = da9052_list_voltage,
 	.get_voltage_sel = da9052_get_regulator_voltage_sel,
-	.is_enabled = da9052_regulator_is_enabled,
-	.enable = da9052_regulator_enable,
-	.disable = da9052_regulator_disable,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
 };
 
 static struct regulator_ops da9052_ldo_ops = {
@@ -302,9 +265,9 @@ static struct regulator_ops da9052_ldo_ops = {
 
 	.list_voltage = da9052_list_voltage,
 	.get_voltage_sel = da9052_get_regulator_voltage_sel,
-	.is_enabled = da9052_regulator_is_enabled,
-	.enable = da9052_regulator_enable,
-	.disable = da9052_regulator_disable,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
 };
 
 #define DA9052_LDO(_id, step, min, max, sbits, ebits, abits) \
@@ -316,12 +279,13 @@ static struct regulator_ops da9052_ldo_ops = {
 		.id = DA9052_ID_##_id,\
 		.n_voltages = (max - min) / step + 1, \
 		.owner = THIS_MODULE,\
+		.enable_reg = DA9052_BUCKCORE_REG + DA9052_ID_##_id, \
+		.enable_mask = 1 << (ebits),\
 	},\
 	.min_uV = (min) * 1000,\
 	.max_uV = (max) * 1000,\
 	.step_uV = (step) * 1000,\
 	.volt_shift = (sbits),\
-	.en_bit = (ebits),\
 	.activate_bit = (abits),\
 }
 
@@ -334,12 +298,13 @@ static struct regulator_ops da9052_ldo_ops = {
 		.id = DA9052_ID_##_id,\
 		.n_voltages = (max - min) / step + 1, \
 		.owner = THIS_MODULE,\
+		.enable_reg = DA9052_BUCKCORE_REG + DA9052_ID_##_id, \
+		.enable_mask = 1 << (ebits),\
 	},\
 	.min_uV = (min) * 1000,\
 	.max_uV = (max) * 1000,\
 	.step_uV = (step) * 1000,\
 	.volt_shift = (sbits),\
-	.en_bit = (ebits),\
 	.activate_bit = (abits),\
 }
 
@@ -430,6 +395,7 @@ static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 
 	config.dev = &pdev->dev;
 	config.driver_data = regulator;
+	config.regmap = da9052->regmap;
 	if (pdata && pdata->regulators) {
 		config.init_data = pdata->regulators[pdev->id];
 	} else {
-- 
1.7.5.4



