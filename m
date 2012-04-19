Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab2DSBoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 21:44:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32794 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab2DSBoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 21:44:19 -0400
Message-ID: <1334799853.2707.3.camel@phoenix>
Subject: [PATCH 1/2] regulator: max8997: Convert ot use devm_kzalloc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 19 Apr 2012 09:44:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also simplify the error handling to start unwind from the place
regulator_register fails.

No need to check rdev[i] is NULL or not before calling regulator_unregister.
regulator_unregister is safe if rdev is NULL,

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8997.c |   40 +++++++++++++++-------------------------
 1 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 99d7cb3..20286ad 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -962,16 +962,15 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	max8997 = kzalloc(sizeof(struct max8997_data), GFP_KERNEL);
+	max8997 = devm_kzalloc(&pdev->dev, sizeof(struct max8997_data),
+			       GFP_KERNEL);
 	if (!max8997)
 		return -ENOMEM;
 
 	size = sizeof(struct regulator_dev *) * pdata->num_regulators;
-	max8997->rdev = kzalloc(size, GFP_KERNEL);
-	if (!max8997->rdev) {
-		kfree(max8997);
+	max8997->rdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	if (!max8997->rdev)
 		return -ENOMEM;
-	}
 
 	rdev = max8997->rdev;
 	max8997->dev = &pdev->dev;
@@ -995,7 +994,7 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 					pdata->buck1_voltage[i] / 1000 +
 					buck1245_voltage_map_desc.step);
 		if (ret < 0)
-			goto err_alloc;
+			goto err_out;
 
 		max8997->buck2_vol[i] = ret =
 			max8997_get_voltage_proper_val(
@@ -1004,7 +1003,7 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 					pdata->buck2_voltage[i] / 1000 +
 					buck1245_voltage_map_desc.step);
 		if (ret < 0)
-			goto err_alloc;
+			goto err_out;
 
 		max8997->buck5_vol[i] = ret =
 			max8997_get_voltage_proper_val(
@@ -1013,7 +1012,7 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 					pdata->buck5_voltage[i] / 1000 +
 					buck1245_voltage_map_desc.step);
 		if (ret < 0)
-			goto err_alloc;
+			goto err_out;
 
 		if (max_buck1 < max8997->buck1_vol[i])
 			max_buck1 = max8997->buck1_vol[i];
@@ -1046,7 +1045,7 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 				!gpio_is_valid(pdata->buck125_gpios[2])) {
 			dev_err(&pdev->dev, "GPIO NOT VALID\n");
 			ret = -EINVAL;
-			goto err_alloc;
+			goto err_out;
 		}
 
 		ret = gpio_request(pdata->buck125_gpios[0],
@@ -1055,7 +1054,7 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 			dev_warn(&pdev->dev, "Duplicated gpio request"
 					" on SET1\n");
 		else if (ret)
-			goto err_alloc;
+			goto err_out;
 		else
 			gpio1set = true;
 
@@ -1067,7 +1066,7 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 		else if (ret) {
 			if (gpio1set)
 				gpio_free(pdata->buck125_gpios[0]);
-			goto err_alloc;
+			goto err_out;
 		} else
 			gpio2set = true;
 
@@ -1081,7 +1080,7 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 				gpio_free(pdata->buck125_gpios[0]);
 			if (gpio2set)
 				gpio_free(pdata->buck125_gpios[1]);
-			goto err_alloc;
+			goto err_out;
 		}
 
 		gpio_direction_output(pdata->buck125_gpios[0],
@@ -1150,13 +1149,9 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 
 	return 0;
 err:
-	for (i = 0; i < max8997->num_regulators; i++)
-		if (rdev[i])
-			regulator_unregister(rdev[i]);
-err_alloc:
-	kfree(max8997->rdev);
-	kfree(max8997);
-
+	while (--i >= 0)
+		regulator_unregister(rdev[i]);
+err_out:
 	return ret;
 }
 
@@ -1167,12 +1162,7 @@ static int __devexit max8997_pmic_remove(struct platform_device *pdev)
 	int i;
 
 	for (i = 0; i < max8997->num_regulators; i++)
-		if (rdev[i])
-			regulator_unregister(rdev[i]);
-
-	kfree(max8997->rdev);
-	kfree(max8997);
-
+		regulator_unregister(rdev[i]);
 	return 0;
 }
 
-- 
1.7.5.4



