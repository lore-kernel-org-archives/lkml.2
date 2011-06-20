Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab1FTIaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 04:30:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42417 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1FTIaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 04:30:22 -0400
X-AuditID: cbfee61a-b7ce2ae000001a8f-56-4dff051aa746
Date: Mon, 20 Jun 2011 17:30:17 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] regulator: max8997: remove dependency on platform_data pointer
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1308558617-20581-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 20 Jun 2011 08:29:45.0340 (UTC)
 FILETIME=[35B6C3C0:01CC2F24]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform_data (pdata) may be pointing to __initdata section, which
may be free'd from the memory. The dependency on pdata in non-init
functions is removed in this patch to allow platform to declare
__initdata for platform data.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/max8997.c |   44 ++++++++++++++++++++++--------------------
 1 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 10d5a1d..469b657 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -39,25 +39,28 @@ struct max8997_data {
 	struct regulator_dev **rdev;
 	int ramp_delay; /* in mV/us */
 
+	bool buck1_gpiodvs;
+	bool buck2_gpiodvs;
+	bool buck5_gpiodvs;
 	u8 buck1_vol[8];
 	u8 buck2_vol[8];
 	u8 buck5_vol[8];
+	int buck125_gpios[3];
 	int buck125_gpioindex;
+	bool ignore_gpiodvs_side_effect;
 
 	u8 saved_states[MAX8997_REG_MAX];
 };
 
 static inline void max8997_set_gpio(struct max8997_data *max8997)
 {
-	struct max8997_platform_data *pdata =
-		dev_get_platdata(max8997->iodev->dev);
 	int set3 = (max8997->buck125_gpioindex) & 0x1;
 	int set2 = ((max8997->buck125_gpioindex) >> 1) & 0x1;
 	int set1 = ((max8997->buck125_gpioindex) >> 2) & 0x1;
 
-	gpio_set_value(pdata->buck125_gpios[0], set1);
-	gpio_set_value(pdata->buck125_gpios[1], set2);
-	gpio_set_value(pdata->buck125_gpios[2], set3);
+	gpio_set_value(max8997->buck125_gpios[0], set1);
+	gpio_set_value(max8997->buck125_gpios[1], set2);
+	gpio_set_value(max8997->buck125_gpios[2], set3);
 }
 
 struct voltage_map_desc {
@@ -380,8 +383,6 @@ static int max8997_get_voltage_register(struct regulator_dev *rdev,
 static int max8997_get_voltage(struct regulator_dev *rdev)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct max8997_platform_data *pdata =
-		dev_get_platdata(max8997->iodev->dev);
 	struct i2c_client *i2c = max8997->iodev->i2c;
 	int reg, shift, mask, ret;
 	int rid = max8997_get_rid(rdev);
@@ -391,9 +392,9 @@ static int max8997_get_voltage(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	if ((rid == MAX8997_BUCK1 && pdata->buck1_gpiodvs) ||
-			(rid == MAX8997_BUCK2 && pdata->buck2_gpiodvs) ||
-			(rid == MAX8997_BUCK5 && pdata->buck5_gpiodvs))
+	if ((rid == MAX8997_BUCK1 && max8997->buck1_gpiodvs) ||
+			(rid == MAX8997_BUCK2 && max8997->buck2_gpiodvs) ||
+			(rid == MAX8997_BUCK5 && max8997->buck5_gpiodvs))
 		reg += max8997->buck125_gpioindex;
 
 	ret = max8997_read_reg(i2c, reg, &val);
@@ -561,8 +562,6 @@ static int max8997_assess_side_effect(struct regulator_dev *rdev,
 		u8 new_val, int *best)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct max8997_platform_data *pdata =
-		dev_get_platdata(max8997->iodev->dev);
 	int rid = max8997_get_rid(rdev);
 	u8 *buckx_val[3];
 	bool buckx_gpiodvs[3];
@@ -589,9 +588,9 @@ static int max8997_assess_side_effect(struct regulator_dev *rdev,
 	buckx_val[0] = max8997->buck1_vol;
 	buckx_val[1] = max8997->buck2_vol;
 	buckx_val[2] = max8997->buck5_vol;
-	buckx_gpiodvs[0] = pdata->buck1_gpiodvs;
-	buckx_gpiodvs[1] = pdata->buck2_gpiodvs;
-	buckx_gpiodvs[2] = pdata->buck5_gpiodvs;
+	buckx_gpiodvs[0] = max8997->buck1_gpiodvs;
+	buckx_gpiodvs[1] = max8997->buck2_gpiodvs;
+	buckx_gpiodvs[2] = max8997->buck5_gpiodvs;
 
 	for (i = 0; i < 8; i++) {
 		int others;
@@ -640,8 +639,6 @@ static int max8997_set_voltage_buck(struct regulator_dev *rdev,
 		int min_uV, int max_uV, unsigned *selector)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct max8997_platform_data *pdata =
-		dev_get_platdata(max8997->iodev->dev);
 	int rid = max8997_get_rid(rdev);
 	const struct voltage_map_desc *desc;
 	int new_val, new_idx, damage, tmp_val, tmp_idx, tmp_dmg;
@@ -653,15 +650,15 @@ static int max8997_set_voltage_buck(struct regulator_dev *rdev,
 
 	switch (rid) {
 	case MAX8997_BUCK1:
-		if (pdata->buck1_gpiodvs)
+		if (max8997->buck1_gpiodvs)
 			gpio_dvs_mode = true;
 		break;
 	case MAX8997_BUCK2:
-		if (pdata->buck2_gpiodvs)
+		if (max8997->buck2_gpiodvs)
 			gpio_dvs_mode = true;
 		break;
 	case MAX8997_BUCK5:
-		if (pdata->buck5_gpiodvs)
+		if (max8997->buck5_gpiodvs)
 			gpio_dvs_mode = true;
 		break;
 	}
@@ -695,7 +692,7 @@ static int max8997_set_voltage_buck(struct regulator_dev *rdev,
 	new_idx = tmp_idx;
 	new_val = tmp_val;
 
-	if (pdata->ignore_gpiodvs_side_effect == false)
+	if (max8997->ignore_gpiodvs_side_effect == false)
 		return -EINVAL;
 
 	dev_warn(&rdev->dev, "MAX8997 GPIO-DVS Side Effect Warning: GPIO SET:"
@@ -993,6 +990,11 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 	i2c = max8997->iodev->i2c;
 
 	max8997->buck125_gpioindex = pdata->buck125_default_idx;
+	max8997->buck1_gpiodvs = pdata->buck1_gpiodvs;
+	max8997->buck2_gpiodvs = pdata->buck2_gpiodvs;
+	max8997->buck5_gpiodvs = pdata->buck5_gpiodvs;
+	memcpy(max8997->buck125_gpios, pdata->buck125_gpios, sizeof(int) * 3);
+	max8997->ignore_gpiodvs_side_effect = pdata->ignore_gpiodvs_side_effect;
 
 	for (i = 0; i < 8; i++) {
 		max8997->buck1_vol[i] = ret =
-- 
1.7.4.1

