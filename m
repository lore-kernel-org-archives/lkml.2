Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab2DSBro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 21:47:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60570 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab2DSBrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 21:47:43 -0400
Message-ID: <1334800057.2707.6.camel@phoenix>
Subject: [PATCH 2/2] regulator: max8998: Convert ot use devm_kzalloc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 19 Apr 2012 09:47:37 +0800
In-Reply-To: <1334799853.2707.3.camel@phoenix>
References: <1334799853.2707.3.camel@phoenix>
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
 drivers/regulator/max8998.c |   45 ++++++++++++++++--------------------------
 1 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 4ca22f9..04c8961 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -719,16 +719,15 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	max8998 = kzalloc(sizeof(struct max8998_data), GFP_KERNEL);
+	max8998 = devm_kzalloc(&pdev->dev, sizeof(struct max8998_data),
+			       GFP_KERNEL);
 	if (!max8998)
 		return -ENOMEM;
 
 	size = sizeof(struct regulator_dev *) * pdata->num_regulators;
-	max8998->rdev = kzalloc(size, GFP_KERNEL);
-	if (!max8998->rdev) {
-		kfree(max8998);
+	max8998->rdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	if (!max8998->rdev)
 		return -ENOMEM;
-	}
 
 	rdev = max8998->rdev;
 	max8998->dev = &pdev->dev;
@@ -752,14 +751,14 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 			printk(KERN_ERR "MAX8998 SET1 GPIO defined as 0 !\n");
 			WARN_ON(!pdata->buck1_set1);
 			ret = -EIO;
-			goto err_free_mem;
+			goto err_out;
 		}
 		/* Check if SET2 is not equal to 0 */
 		if (!pdata->buck1_set2) {
 			printk(KERN_ERR "MAX8998 SET2 GPIO defined as 0 !\n");
 			WARN_ON(!pdata->buck1_set2);
 			ret = -EIO;
-			goto err_free_mem;
+			goto err_out;
 		}
 
 		gpio_request(pdata->buck1_set1, "MAX8998 BUCK1_SET1");
@@ -779,7 +778,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		max8998->buck1_vol[0] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE1, i);
 		if (ret)
-			goto err_free_mem;
+			goto err_out;
 
 		/* Set predefined value for BUCK1 register 2 */
 		i = 0;
@@ -791,7 +790,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		max8998->buck1_vol[1] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE2, i);
 		if (ret)
-			goto err_free_mem;
+			goto err_out;
 
 		/* Set predefined value for BUCK1 register 3 */
 		i = 0;
@@ -803,7 +802,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		max8998->buck1_vol[2] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE3, i);
 		if (ret)
-			goto err_free_mem;
+			goto err_out;
 
 		/* Set predefined value for BUCK1 register 4 */
 		i = 0;
@@ -815,7 +814,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		max8998->buck1_vol[3] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE4, i);
 		if (ret)
-			goto err_free_mem;
+			goto err_out;
 
 	}
 
@@ -825,7 +824,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 			printk(KERN_ERR "MAX8998 SET3 GPIO defined as 0 !\n");
 			WARN_ON(!pdata->buck2_set3);
 			ret = -EIO;
-			goto err_free_mem;
+			goto err_out;
 		}
 		gpio_request(pdata->buck2_set3, "MAX8998 BUCK2_SET3");
 		gpio_direction_output(pdata->buck2_set3,
@@ -840,7 +839,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		max8998->buck2_vol[0] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK2_VOLTAGE1, i);
 		if (ret)
-			goto err_free_mem;
+			goto err_out;
 
 		/* BUCK2 register 2 */
 		i = 0;
@@ -851,7 +850,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		max8998->buck2_vol[1] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK2_VOLTAGE2, i);
 		if (ret)
-			goto err_free_mem;
+			goto err_out;
 	}
 
 	for (i = 0; i < pdata->num_regulators; i++) {
@@ -881,14 +880,9 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 
 	return 0;
 err:
-	for (i = 0; i < max8998->num_regulators; i++)
-		if (rdev[i])
-			regulator_unregister(rdev[i]);
-
-err_free_mem:
-	kfree(max8998->rdev);
-	kfree(max8998);
-
+	while (--i >= 0)
+		regulator_unregister(rdev[i]);
+err_out:
 	return ret;
 }
 
@@ -899,12 +893,7 @@ static int __devexit max8998_pmic_remove(struct platform_device *pdev)
 	int i;
 
 	for (i = 0; i < max8998->num_regulators; i++)
-		if (rdev[i])
-			regulator_unregister(rdev[i]);
-
-	kfree(max8998->rdev);
-	kfree(max8998);
-
+		regulator_unregister(rdev[i]);
 	return 0;
 }
 
-- 
1.7.5.4



