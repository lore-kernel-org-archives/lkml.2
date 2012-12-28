Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab2L1JJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 04:09:16 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60879 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2L1JJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 04:09:14 -0500
Message-ID: <1356685743.27172.2.camel@phoenix>
Subject: [PATCH 1/3] regulator: max8997: Use uV in voltage_map_desc
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Dec 2012 17:09:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code does integer division (min_vol = min_uV / 1000) before pass
min_vol to max8997_get_voltage_proper_val().
So it is possible min_vol is truncated to a smaller value.

For example, if the request min_uV is 800900 for ldo.
min_vol = 800900 / 1000 = 800 (mV)
Then max8997_get_voltage_proper_val returns 800 mV for this case which is lower
than the requested voltage.

Use uV rather than mV in voltage_map_desc to prevent truncation by integer
division.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max8997.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index c30424a..1a1ae99 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -78,26 +78,26 @@ struct voltage_map_desc {
 	int step;
 };
 
-/* Voltage maps in mV */
+/* Voltage maps in uV */
 static const struct voltage_map_desc ldo_voltage_map_desc = {
-	.min = 800,	.max = 3950,	.step = 50,
+	.min = 800000,	.max = 3950000,	.step = 50000,
 }; /* LDO1 ~ 18, 21 all */
 
 static const struct voltage_map_desc buck1245_voltage_map_desc = {
-	.min = 650,	.max = 2225,	.step = 25,
+	.min = 650000,	.max = 2225000,	.step = 25000,
 }; /* Buck1, 2, 4, 5 */
 
 static const struct voltage_map_desc buck37_voltage_map_desc = {
-	.min = 750,	.max = 3900,	.step = 50,
+	.min = 750000,	.max = 3900000,	.step = 50000,
 }; /* Buck3, 7 */
 
-/* current map in mA */
+/* current map in uA */
 static const struct voltage_map_desc charger_current_map_desc = {
-	.min = 200,	.max = 950,	.step = 50,
+	.min = 200000,	.max = 950000,	.step = 50000,
 };
 
 static const struct voltage_map_desc topoff_current_map_desc = {
-	.min = 50,	.max = 200,	.step = 10,
+	.min = 50000,	.max = 200000,	.step = 10000,
 };
 
 static const struct voltage_map_desc *reg_voltage_map[] = {
@@ -178,7 +178,7 @@ static int max8997_list_voltage(struct regulator_dev *rdev,
 	if (val > desc->max)
 		return -EINVAL;
 
-	return val * 1000;
+	return val;
 }
 
 static int max8997_get_enable_register(struct regulator_dev *rdev,
@@ -469,7 +469,6 @@ static int max8997_set_voltage_ldobuck(struct regulator_dev *rdev,
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
 	struct i2c_client *i2c = max8997->iodev->i2c;
-	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
 	const struct voltage_map_desc *desc;
 	int rid = rdev_get_id(rdev);
 	int i, reg, shift, mask, ret;
@@ -493,7 +492,7 @@ static int max8997_set_voltage_ldobuck(struct regulator_dev *rdev,
 
 	desc = reg_voltage_map[rid];
 
-	i = max8997_get_voltage_proper_val(desc, min_vol, max_vol);
+	i = max8997_get_voltage_proper_val(desc, min_uV, max_uV);
 	if (i < 0)
 		return i;
 
@@ -541,7 +540,7 @@ static int max8997_set_voltage_buck_time_sel(struct regulator_dev *rdev,
 	case MAX8997_BUCK4:
 	case MAX8997_BUCK5:
 		return DIV_ROUND_UP(desc->step * (new_selector - old_selector),
-				    max8997->ramp_delay);
+				    max8997->ramp_delay * 1000);
 	}
 
 	return 0;
@@ -640,7 +639,6 @@ static int max8997_set_voltage_buck(struct regulator_dev *rdev,
 	const struct voltage_map_desc *desc;
 	int new_val, new_idx, damage, tmp_val, tmp_idx, tmp_dmg;
 	bool gpio_dvs_mode = false;
-	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
 
 	if (rid < MAX8997_BUCK1 || rid > MAX8997_BUCK7)
 		return -EINVAL;
@@ -665,7 +663,7 @@ static int max8997_set_voltage_buck(struct regulator_dev *rdev,
 						selector);
 
 	desc = reg_voltage_map[rid];
-	new_val = max8997_get_voltage_proper_val(desc, min_vol, max_vol);
+	new_val = max8997_get_voltage_proper_val(desc, min_uV, max_uV);
 	if (new_val < 0)
 		return new_val;
 
@@ -1080,8 +1078,8 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 		max8997->buck1_vol[i] = ret =
 			max8997_get_voltage_proper_val(
 					&buck1245_voltage_map_desc,
-					pdata->buck1_voltage[i] / 1000,
-					pdata->buck1_voltage[i] / 1000 +
+					pdata->buck1_voltage[i],
+					pdata->buck1_voltage[i] +
 					buck1245_voltage_map_desc.step);
 		if (ret < 0)
 			goto err_out;
@@ -1089,8 +1087,8 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 		max8997->buck2_vol[i] = ret =
 			max8997_get_voltage_proper_val(
 					&buck1245_voltage_map_desc,
-					pdata->buck2_voltage[i] / 1000,
-					pdata->buck2_voltage[i] / 1000 +
+					pdata->buck2_voltage[i],
+					pdata->buck2_voltage[i] +
 					buck1245_voltage_map_desc.step);
 		if (ret < 0)
 			goto err_out;
@@ -1098,8 +1096,8 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 		max8997->buck5_vol[i] = ret =
 			max8997_get_voltage_proper_val(
 					&buck1245_voltage_map_desc,
-					pdata->buck5_voltage[i] / 1000,
-					pdata->buck5_voltage[i] / 1000 +
+					pdata->buck5_voltage[i],
+					pdata->buck5_voltage[i] +
 					buck1245_voltage_map_desc.step);
 		if (ret < 0)
 			goto err_out;
-- 
1.7.9.5



