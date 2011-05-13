Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab1EMGyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 02:54:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33845 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab1EMGyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 02:54:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=uKMbw36iAQ21E7Hkh/r3+eE4vt6DgS9KxPmaCMWHVGkJEcxHBkg8Qk4tzPQ7ikPtz8
         kKLgf4MtRnE7F7lx1DkWaliIO2Kq/SdiiWq7FEXyyz29G+8CvtUeagEEr1tGXcPKtAFN
         dXk/q60Z4eyDIomEmJZKOGwr5+4fD6DAQXIqc=
Subject: [PATCH] regulator: Fix memory leak in max8998_pmic_probe failure
 path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 14:54:06 +0800
Message-ID: <1305269646.15846.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8998.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index f57e9c4..41a1495 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -732,13 +732,15 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		if (!pdata->buck1_set1) {
 			printk(KERN_ERR "MAX8998 SET1 GPIO defined as 0 !\n");
 			WARN_ON(!pdata->buck1_set1);
-			return -EIO;
+			ret = -EIO;
+			goto err_free_mem;
 		}
 		/* Check if SET2 is not equal to 0 */
 		if (!pdata->buck1_set2) {
 			printk(KERN_ERR "MAX8998 SET2 GPIO defined as 0 !\n");
 			WARN_ON(!pdata->buck1_set2);
-			return -EIO;
+			ret = -EIO;
+			goto err_free_mem;
 		}
 
 		gpio_request(pdata->buck1_set1, "MAX8998 BUCK1_SET1");
@@ -758,7 +760,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		max8998->buck1_vol[0] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE1, i);
 		if (ret)
-			return ret;
+			goto err_free_mem;
 
 		/* Set predefined value for BUCK1 register 2 */
 		i = 0;
@@ -770,7 +772,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		max8998->buck1_vol[1] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE2, i);
 		if (ret)
-			return ret;
+			goto err_free_mem;
 
 		/* Set predefined value for BUCK1 register 3 */
 		i = 0;
@@ -782,7 +784,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		max8998->buck1_vol[2] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE3, i);
 		if (ret)
-			return ret;
+			goto err_free_mem;
 
 		/* Set predefined value for BUCK1 register 4 */
 		i = 0;
@@ -794,7 +796,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		max8998->buck1_vol[3] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE4, i);
 		if (ret)
-			return ret;
+			goto err_free_mem;
 
 	}
 
@@ -803,7 +805,8 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		if (!pdata->buck2_set3) {
 			printk(KERN_ERR "MAX8998 SET3 GPIO defined as 0 !\n");
 			WARN_ON(!pdata->buck2_set3);
-			return -EIO;
+			ret = -EIO;
+			goto err_free_mem;
 		}
 		gpio_request(pdata->buck2_set3, "MAX8998 BUCK2_SET3");
 		gpio_direction_output(pdata->buck2_set3,
@@ -818,7 +821,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		max8998->buck2_vol[0] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK2_VOLTAGE1, i);
 		if (ret)
-			return ret;
+			goto err_free_mem;
 
 		/* BUCK2 register 2 */
 		i = 0;
@@ -830,7 +833,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		max8998->buck2_vol[1] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK2_VOLTAGE2, i);
 		if (ret)
-			return ret;
+			goto err_free_mem;
 	}
 
 	for (i = 0; i < pdata->num_regulators; i++) {
@@ -860,6 +863,7 @@ err:
 		if (rdev[i])
 			regulator_unregister(rdev[i]);
 
+err_free_mem:
 	kfree(max8998->rdev);
 	kfree(max8998);
 
-- 
1.7.1



