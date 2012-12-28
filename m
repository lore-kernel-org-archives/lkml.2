Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab2L1Q6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 11:58:34 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:58138 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2L1Q6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 11:58:32 -0500
Message-ID: <1356713901.15120.2.camel@phoenix>
Subject: [PATCH RFT] regulator: s5m8767: Convert to
 regulator_[get|set]_voltage_sel_regmap
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Sat, 29 Dec 2012 00:58:21 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/s5m8767.c |   50 +++++++++++--------------------------------
 1 file changed, 12 insertions(+), 38 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 33b65c9..eeadf58 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -255,10 +255,8 @@ static int s5m8767_reg_disable(struct regulator_dev *rdev)
 	return sec_reg_update(s5m8767->iodev, reg, ~mask, mask);
 }
 
-static int s5m8767_get_voltage_register(struct regulator_dev *rdev, int *_reg)
+static int s5m8767_get_vsel_reg(int reg_id, struct s5m8767_info *s5m8767)
 {
-	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
-	int reg_id = rdev_get_id(rdev);
 	int reg;
 
 	switch (reg_id) {
@@ -296,31 +294,7 @@ static int s5m8767_get_voltage_register(struct regulator_dev *rdev, int *_reg)
 		return -EINVAL;
 	}
 
-	*_reg = reg;
-
-	return 0;
-}
-
-static int s5m8767_get_voltage_sel(struct regulator_dev *rdev)
-{
-	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
-	int reg, mask, ret;
-	int reg_id = rdev_get_id(rdev);
-	unsigned int val;
-
-	ret = s5m8767_get_voltage_register(rdev, &reg);
-	if (ret)
-		return ret;
-
-	mask = (reg_id < S5M8767_BUCK1) ? 0x3f : 0xff;
-
-	ret = sec_reg_read(s5m8767->iodev, reg, &val);
-	if (ret)
-		return ret;
-
-	val &= mask;
-
-	return val;
+	return reg;
 }
 
 static int s5m8767_convert_voltage_to_sel(
@@ -373,15 +347,13 @@ static int s5m8767_set_voltage_sel(struct regulator_dev *rdev,
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 	int reg_id = rdev_get_id(rdev);
-	int reg, mask, ret = 0, old_index, index = 0;
+	int old_index, index = 0;
 	u8 *buck234_vol = NULL;
 
 	switch (reg_id) {
 	case S5M8767_LDO1 ... S5M8767_LDO28:
-		mask = 0x3f;
 		break;
 	case S5M8767_BUCK1 ... S5M8767_BUCK6:
-		mask = 0xff;
 		if (reg_id == S5M8767_BUCK2 && s5m8767->buck2_gpiodvs)
 			buck234_vol = &s5m8767->buck2_vol[0];
 		else if (reg_id == S5M8767_BUCK3 && s5m8767->buck3_gpiodvs)
@@ -392,7 +364,6 @@ static int s5m8767_set_voltage_sel(struct regulator_dev *rdev,
 	case S5M8767_BUCK7 ... S5M8767_BUCK8:
 		return -EINVAL;
 	case S5M8767_BUCK9:
-		mask = 0xff;
 		break;
 	default:
 		return -EINVAL;
@@ -412,11 +383,7 @@ static int s5m8767_set_voltage_sel(struct regulator_dev *rdev,
 		else
 			return s5m8767_set_low(s5m8767);
 	} else {
-		ret = s5m8767_get_voltage_register(rdev, &reg);
-		if (ret)
-			return ret;
-
-		return sec_reg_update(s5m8767->iodev, reg, selector, mask);
+		return regulator_set_voltage_sel_regmap(rdev, selector);
 	}
 }
 
@@ -441,7 +408,7 @@ static struct regulator_ops s5m8767_ops = {
 	.is_enabled		= s5m8767_reg_is_enabled,
 	.enable			= s5m8767_reg_enable,
 	.disable		= s5m8767_reg_disable,
-	.get_voltage_sel	= s5m8767_get_voltage_sel,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= s5m8767_set_voltage_sel,
 	.set_voltage_time_sel	= s5m8767_set_voltage_time_sel,
 };
@@ -760,11 +727,18 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 				(desc->max - desc->min) / desc->step + 1;
 			regulators[id].min_uV = desc->min;
 			regulators[id].uV_step = desc->step;
+			regulators[id].vsel_reg =
+				s5m8767_get_vsel_reg(id, s5m8767);
+			if (id < S5M8767_BUCK1)
+				regulators[id].vsel_mask = 0x3f;
+			else
+				regulators[id].vsel_mask = 0xff;
 		}
 
 		config.dev = s5m8767->dev;
 		config.init_data = pdata->regulators[i].initdata;
 		config.driver_data = s5m8767;
+		config.regmap = iodev->regmap;
 
 		rdev[i] = regulator_register(&regulators[id], &config);
 		if (IS_ERR(rdev[i])) {
-- 
1.7.9.5



