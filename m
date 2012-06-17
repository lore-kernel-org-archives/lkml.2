Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab2FQBeg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 21:34:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37353 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab2FQBef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 21:34:35 -0400
Message-ID: <1339896869.12833.3.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: max8998: Convert to set_voltage_sel and
 regulator_map_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sun, 17 Jun 2012 09:34:29 +0800
In-Reply-To: <1339896787.12833.1.camel@phoenix>
References: <1339896787.12833.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8998.c |   97 ++++++++++++-------------------------------
 1 file changed, 27 insertions(+), 70 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 105dafc..a1fa266 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -276,41 +276,18 @@ static int max8998_get_voltage_sel(struct regulator_dev *rdev)
 	return val;
 }
 
-static int max8998_set_voltage_ldo(struct regulator_dev *rdev,
-				   int min_uV, int max_uV, unsigned *selector)
+static int max8998_set_voltage_ldo_sel(struct regulator_dev *rdev,
+				       unsigned selector)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
 	struct i2c_client *i2c = max8998->iodev->i2c;
-	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
-	const struct voltage_map_desc *desc;
-	int ldo = rdev_get_id(rdev);
-	int reg, shift = 0, mask, ret, i;
-
-	if (ldo >= ARRAY_SIZE(ldo_voltage_map))
-		return -EINVAL;
-
-	desc = ldo_voltage_map[ldo];
-	if (desc == NULL)
-		return -EINVAL;
-
-	if (max_vol < desc->min || min_vol > desc->max)
-		return -EINVAL;
-
-	if (min_vol < desc->min)
-		min_vol = desc->min;
-
-	i = DIV_ROUND_UP(min_vol - desc->min, desc->step);
-
-	if (desc->min + desc->step*i > max_vol)
-		return -EINVAL;
-
-	*selector = i;
+	int reg, shift = 0, mask, ret;
 
 	ret = max8998_get_voltage_register(rdev, &reg, &shift, &mask);
 	if (ret)
 		return ret;
 
-	ret = max8998_update_reg(i2c, reg, i<<shift, mask<<shift);
+	ret = max8998_update_reg(i2c, reg, selector<<shift, mask<<shift);
 
 	return ret;
 }
@@ -326,41 +303,18 @@ static inline void buck2_gpio_set(int gpio, int v)
 	gpio_set_value(gpio, v & 0x1);
 }
 
-static int max8998_set_voltage_buck(struct regulator_dev *rdev,
-				    int min_uV, int max_uV, unsigned *selector)
+static int max8998_set_voltage_buck_sel(struct regulator_dev *rdev,
+					unsigned selector)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
 	struct max8998_platform_data *pdata =
 		dev_get_platdata(max8998->iodev->dev);
 	struct i2c_client *i2c = max8998->iodev->i2c;
-	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
-	const struct voltage_map_desc *desc;
 	int buck = rdev_get_id(rdev);
 	int reg, shift = 0, mask, ret;
-	int i, j, previous_sel;
+	int j, previous_sel;
 	static u8 buck1_last_val;
 
-	if (buck >= ARRAY_SIZE(ldo_voltage_map))
-		return -EINVAL;
-
-	desc = ldo_voltage_map[buck];
-
-	if (desc == NULL)
-		return -EINVAL;
-
-	if (max_vol < desc->min || min_vol > desc->max)
-		return -EINVAL;
-
-	if (min_vol < desc->min)
-		min_vol = desc->min;
-
-	i = DIV_ROUND_UP(min_vol - desc->min, desc->step);
-
-	if (desc->min + desc->step*i > max_vol)
-		return -EINVAL;
-
-	*selector = i;
-
 	ret = max8998_get_voltage_register(rdev, &reg, &shift, &mask);
 	if (ret)
 		return ret;
@@ -369,19 +323,19 @@ static int max8998_set_voltage_buck(struct regulator_dev *rdev,
 
 	/* Check if voltage needs to be changed */
 	/* if previous_voltage equal new voltage, return */
-	if (previous_sel == i) {
+	if (previous_sel == selector) {
 		dev_dbg(max8998->dev, "No voltage change, old:%d, new:%d\n",
 			regulator_list_voltage_linear(rdev, previous_sel),
-			regulator_list_voltage_linear(rdev, i));
+			regulator_list_voltage_linear(rdev, selector));
 		return ret;
 	}
 
 	switch (buck) {
 	case MAX8998_BUCK1:
 		dev_dbg(max8998->dev,
-			"BUCK1, i:%d, buck1_vol1:%d, buck1_vol2:%d\n"
+			"BUCK1, selector:%d, buck1_vol1:%d, buck1_vol2:%d\n"
 			"buck1_vol3:%d, buck1_vol4:%d\n",
-			i, max8998->buck1_vol[0], max8998->buck1_vol[1],
+			selector, max8998->buck1_vol[0], max8998->buck1_vol[1],
 			max8998->buck1_vol[2], max8998->buck1_vol[3]);
 
 		if (gpio_is_valid(pdata->buck1_set1) &&
@@ -390,7 +344,7 @@ static int max8998_set_voltage_buck(struct regulator_dev *rdev,
 			/* check if requested voltage */
 			/* value is already defined */
 			for (j = 0; j < ARRAY_SIZE(max8998->buck1_vol); j++) {
-				if (max8998->buck1_vol[j] == i) {
+				if (max8998->buck1_vol[j] == selector) {
 					max8998->buck1_idx = j;
 					buck1_gpio_set(pdata->buck1_set1,
 						       pdata->buck1_set2, j);
@@ -405,11 +359,11 @@ static int max8998_set_voltage_buck(struct regulator_dev *rdev,
 			max8998->buck1_idx = (buck1_last_val % 2) + 2;
 			dev_dbg(max8998->dev, "max8998->buck1_idx:%d\n",
 				max8998->buck1_idx);
-			max8998->buck1_vol[max8998->buck1_idx] = i;
+			max8998->buck1_vol[max8998->buck1_idx] = selector;
 			ret = max8998_get_voltage_register(rdev, &reg,
 							   &shift,
 							   &mask);
-			ret = max8998_write_reg(i2c, reg, i);
+			ret = max8998_write_reg(i2c, reg, selector);
 			buck1_gpio_set(pdata->buck1_set1,
 				       pdata->buck1_set2, max8998->buck1_idx);
 			buck1_last_val++;
@@ -419,20 +373,20 @@ buck1_exit:
 				gpio_get_value(pdata->buck1_set2));
 			break;
 		} else {
-			ret = max8998_write_reg(i2c, reg, i);
+			ret = max8998_write_reg(i2c, reg, selector);
 		}
 		break;
 
 	case MAX8998_BUCK2:
 		dev_dbg(max8998->dev,
-			"BUCK2, i:%d buck2_vol1:%d, buck2_vol2:%d\n"
-			, i, max8998->buck2_vol[0], max8998->buck2_vol[1]);
+			"BUCK2, selector:%d buck2_vol1:%d, buck2_vol2:%d\n",
+			selector, max8998->buck2_vol[0], max8998->buck2_vol[1]);
 		if (gpio_is_valid(pdata->buck2_set3)) {
 
 			/* check if requested voltage */
 			/* value is already defined */
 			for (j = 0; j < ARRAY_SIZE(max8998->buck2_vol); j++) {
-				if (max8998->buck2_vol[j] == i) {
+				if (max8998->buck2_vol[j] == selector) {
 					max8998->buck2_idx = j;
 					buck2_gpio_set(pdata->buck2_set3, j);
 					goto buck2_exit;
@@ -444,20 +398,21 @@ buck1_exit:
 
 			max8998_get_voltage_register(rdev,
 					&reg, &shift, &mask);
-			ret = max8998_write_reg(i2c, reg, i);
-			max8998->buck2_vol[max8998->buck2_idx] = i;
+			ret = max8998_write_reg(i2c, reg, selector);
+			max8998->buck2_vol[max8998->buck2_idx] = selector;
 			buck2_gpio_set(pdata->buck2_set3, max8998->buck2_idx);
 buck2_exit:
 			dev_dbg(max8998->dev, "%s: SET3:%d\n", i2c->name,
 				gpio_get_value(pdata->buck2_set3));
 		} else {
-			ret = max8998_write_reg(i2c, reg, i);
+			ret = max8998_write_reg(i2c, reg, selector);
 		}
 		break;
 
 	case MAX8998_BUCK3:
 	case MAX8998_BUCK4:
-		ret = max8998_update_reg(i2c, reg, i<<shift, mask<<shift);
+		ret = max8998_update_reg(i2c, reg, selector<<shift,
+					 mask<<shift);
 		break;
 	}
 
@@ -499,22 +454,24 @@ static int max8998_set_voltage_buck_time_sel(struct regulator_dev *rdev,
 
 static struct regulator_ops max8998_ldo_ops = {
 	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
 	.is_enabled		= max8998_ldo_is_enabled,
 	.enable			= max8998_ldo_enable,
 	.disable		= max8998_ldo_disable,
 	.get_voltage_sel	= max8998_get_voltage_sel,
-	.set_voltage		= max8998_set_voltage_ldo,
+	.set_voltage_sel	= max8998_set_voltage_ldo_sel,
 	.set_suspend_enable	= max8998_ldo_enable,
 	.set_suspend_disable	= max8998_ldo_disable,
 };
 
 static struct regulator_ops max8998_buck_ops = {
 	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
 	.is_enabled		= max8998_ldo_is_enabled,
 	.enable			= max8998_ldo_enable,
 	.disable		= max8998_ldo_disable,
 	.get_voltage_sel	= max8998_get_voltage_sel,
-	.set_voltage		= max8998_set_voltage_buck,
+	.set_voltage_sel	= max8998_set_voltage_buck_sel,
 	.set_voltage_time_sel	= max8998_set_voltage_buck_time_sel,
 	.set_suspend_enable	= max8998_ldo_enable,
 	.set_suspend_disable	= max8998_ldo_disable,
-- 
1.7.9.5



