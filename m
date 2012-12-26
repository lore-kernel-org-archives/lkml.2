Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab2LZIay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 03:30:54 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:63611 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2LZIau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 03:30:50 -0500
Message-ID: <1356510644.16892.5.camel@phoenix>
Subject: [PATCH 2/2] regulator: max8997: Convert max8997_safeout_ops to
 set_voltage_sel and list_voltage_table
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Dec 2012 16:30:44 +0800
In-Reply-To: <1356510519.16892.3.camel@phoenix>
References: <1356510519.16892.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max8997.c |   76 ++++++++++---------------------------------
 1 file changed, 18 insertions(+), 58 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 57e8907..c30424a 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -54,6 +54,13 @@ struct max8997_data {
 	u8 saved_states[MAX8997_REG_MAX];
 };
 
+static const unsigned int safeoutvolt[] = {
+	4850000,
+	4900000,
+	4950000,
+	3300000,
+};
+
 static inline void max8997_set_gpio(struct max8997_data *max8997)
 {
 	int set3 = (max8997->buck125_gpioindex) & 0x1;
@@ -130,29 +137,6 @@ static const struct voltage_map_desc *reg_voltage_map[] = {
 	[MAX8997_CHARGER_TOPOFF] = &topoff_current_map_desc,
 };
 
-static int max8997_list_voltage_safeout(struct regulator_dev *rdev,
-		unsigned int selector)
-{
-	int rid = rdev_get_id(rdev);
-
-	if (rid == MAX8997_ESAFEOUT1 || rid == MAX8997_ESAFEOUT2) {
-		switch (selector) {
-		case 0:
-			return 4850000;
-		case 1:
-			return 4900000;
-		case 2:
-			return 4950000;
-		case 3:
-			return 3300000;
-		default:
-			return -EINVAL;
-		}
-	}
-
-	return -EINVAL;
-}
-
 static int max8997_list_voltage_charger_cv(struct regulator_dev *rdev,
 		unsigned int selector)
 {
@@ -722,49 +706,23 @@ out:
 	return 0;
 }
 
-static const int safeoutvolt[] = {
-	3300000,
-	4850000,
-	4900000,
-	4950000,
-};
-
 /* For SAFEOUT1 and SAFEOUT2 */
-static int max8997_set_voltage_safeout(struct regulator_dev *rdev,
-		int min_uV, int max_uV, unsigned *selector)
+static int max8997_set_voltage_safeout_sel(struct regulator_dev *rdev,
+					   unsigned selector)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
 	struct i2c_client *i2c = max8997->iodev->i2c;
 	int rid = rdev_get_id(rdev);
 	int reg, shift = 0, mask, ret;
-	int i = 0;
-	u8 val;
 
 	if (rid != MAX8997_ESAFEOUT1 && rid != MAX8997_ESAFEOUT2)
 		return -EINVAL;
 
-	for (i = 0; i < ARRAY_SIZE(safeoutvolt); i++) {
-		if (min_uV <= safeoutvolt[i] &&
-				max_uV >= safeoutvolt[i])
-			break;
-	}
-
-	if (i >= ARRAY_SIZE(safeoutvolt))
-		return -EINVAL;
-
-	if (i == 0)
-		val = 0x3;
-	else
-		val = i - 1;
-
 	ret = max8997_get_voltage_register(rdev, &reg, &shift, &mask);
 	if (ret)
 		return ret;
 
-	ret = max8997_update_reg(i2c, reg, val << shift, mask << shift);
-	*selector = val;
-
-	return ret;
+	return max8997_update_reg(i2c, reg, selector << shift, mask << shift);
 }
 
 static int max8997_reg_disable_suspend(struct regulator_dev *rdev)
@@ -824,12 +782,12 @@ static struct regulator_ops max8997_fixedvolt_ops = {
 };
 
 static struct regulator_ops max8997_safeout_ops = {
-	.list_voltage		= max8997_list_voltage_safeout,
+	.list_voltage		= regulator_list_voltage_table,
 	.is_enabled		= max8997_reg_is_enabled,
 	.enable			= max8997_reg_enable,
 	.disable		= max8997_reg_disable,
 	.get_voltage_sel	= max8997_get_voltage_sel,
-	.set_voltage		= max8997_set_voltage_safeout,
+	.set_voltage_sel	= max8997_set_voltage_safeout_sel,
 	.set_suspend_disable	= max8997_reg_disable_suspend,
 };
 
@@ -1235,13 +1193,15 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 		int id = pdata->regulators[i].id;
 
 		desc = reg_voltage_map[id];
-		if (desc)
+		if (desc) {
 			regulators[id].n_voltages =
 				(desc->max - desc->min) / desc->step + 1;
-		else if (id == MAX8997_ESAFEOUT1 || id == MAX8997_ESAFEOUT2)
-			regulators[id].n_voltages = 4;
-		else if (id == MAX8997_CHARGER_CV)
+		} else if (id == MAX8997_ESAFEOUT1 || id == MAX8997_ESAFEOUT2) {
+			regulators[id].volt_table = safeoutvolt;
+			regulators[id].n_voltages = ARRAY_SIZE(safeoutvolt);
+		} else if (id == MAX8997_CHARGER_CV) {
 			regulators[id].n_voltages = 16;
+		}
 
 		config.dev = max8997->dev;
 		config.init_data = pdata->regulators[i].initdata;
-- 
1.7.9.5



