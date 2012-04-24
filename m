Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab2DXByp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 21:54:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48544 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070Ab2DXByo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 21:54:44 -0400
Message-ID: <1335232478.6470.3.camel@phoenix>
Subject: [PATCH RFT 2/3] regulator: da9052: Use
 regulator_get_voltage_sel_regmap()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 24 Apr 2012 09:54:38 +0800
In-Reply-To: <1335232352.6470.1.camel@phoenix>
References: <1335232352.6470.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da9052-regulator.c |   32 ++++++++------------------------
 1 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 4f2e6f9..16815f1 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -70,7 +70,6 @@ struct da9052_regulator_info {
 	int step_uV;
 	int min_uV;
 	int max_uV;
-	unsigned char volt_shift;
 	unsigned char activate_bit;
 };
 
@@ -209,9 +208,8 @@ static int da9052_regulator_set_voltage(struct regulator_dev *rdev,
 	if (ret < 0)
 		return ret;
 
-	ret = da9052_reg_update(regulator->da9052,
-				 DA9052_BUCKCORE_REG + id,
-				 (1 << info->volt_shift) - 1, *selector);
+	ret = da9052_reg_update(regulator->da9052, rdev->desc->vsel_reg,
+				rdev->desc->vsel_mask, *selector);
 	if (ret < 0)
 		return ret;
 
@@ -232,29 +230,13 @@ static int da9052_regulator_set_voltage(struct regulator_dev *rdev,
 	return ret;
 }
 
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
-
-	return ret;
-}
-
 static struct regulator_ops da9052_dcdc_ops = {
 	.set_voltage = da9052_regulator_set_voltage,
 	.get_current_limit = da9052_dcdc_get_current_limit,
 	.set_current_limit = da9052_dcdc_set_current_limit,
 
 	.list_voltage = da9052_list_voltage,
-	.get_voltage_sel = da9052_get_regulator_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
@@ -264,7 +246,7 @@ static struct regulator_ops da9052_ldo_ops = {
 	.set_voltage = da9052_regulator_set_voltage,
 
 	.list_voltage = da9052_list_voltage,
-	.get_voltage_sel = da9052_get_regulator_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
@@ -279,13 +261,14 @@ static struct regulator_ops da9052_ldo_ops = {
 		.id = DA9052_ID_##_id,\
 		.n_voltages = (max - min) / step + 1, \
 		.owner = THIS_MODULE,\
+		.vsel_reg = DA9052_BUCKCORE_REG + DA9052_ID_##_id, \
+		.vsel_mask = (1 << (sbits)) - 1,\
 		.enable_reg = DA9052_BUCKCORE_REG + DA9052_ID_##_id, \
 		.enable_mask = 1 << (ebits),\
 	},\
 	.min_uV = (min) * 1000,\
 	.max_uV = (max) * 1000,\
 	.step_uV = (step) * 1000,\
-	.volt_shift = (sbits),\
 	.activate_bit = (abits),\
 }
 
@@ -298,13 +281,14 @@ static struct regulator_ops da9052_ldo_ops = {
 		.id = DA9052_ID_##_id,\
 		.n_voltages = (max - min) / step + 1, \
 		.owner = THIS_MODULE,\
+		.vsel_reg = DA9052_BUCKCORE_REG + DA9052_ID_##_id, \
+		.vsel_mask = (1 << (sbits)) - 1,\
 		.enable_reg = DA9052_BUCKCORE_REG + DA9052_ID_##_id, \
 		.enable_mask = 1 << (ebits),\
 	},\
 	.min_uV = (min) * 1000,\
 	.max_uV = (max) * 1000,\
 	.step_uV = (step) * 1000,\
-	.volt_shift = (sbits),\
 	.activate_bit = (abits),\
 }
 
-- 
1.7.5.4



