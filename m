Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab2KUNzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:55:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:22185 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2KUNzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:55:16 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-72-50acdd43a55b
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH] regulator: max8997: skip gpio dvs setup if not used
Date: Wed, 21 Nov 2012 19:53:15 +0530
Message-id: <1353507795-3516-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJMWRmVeSWpSXmKPExsVy+t9jQV3nu2sCDN4eUbW4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mq4eGgLe0GvaMWVvQ9YGhi7BbsYOTkkBEwkLqzvYYew
	xSQu3FvP1sXIxSEkMJ1RYmbDNnYIp41J4vCi14wgVWwCBhKPFr4D6xARUJDY3PuMFcRmFkiT
	2H90OhuILSzgIrG0E6KeRUBVYkPfK7A4r4CHRPOcO1DblCQ29B5lmsDIvYCRYRWjaGpBckFx
	UnquoV5xYm5xaV66XnJ+7iZGsDefSe1gXNlgcYhRgINRiYd349rVAUKsiWXFlbmHGCU4mJVE
	eGMurgkQ4k1JrKxKLcqPLyrNSS0+xCjNwaIkztvskRIgJJCeWJKanZpakFoEk2Xi4JRqYIw7
	0Tqf58oDz9LJK5V7pEx9FeJuKb6dkao1p2r+ipB/7TPDfqcqftu6O0c/Ma3MZO6r6t6n51a7
	sDBMczi2vfF+U5KjrX7eqtlOSxa8vCZ9ZkPsydfGQUJr+xtX+zt4d8TPKN+o9j1hQ1CN0/+H
	la/lC30rzn//X9xr+j98xfTj4umfVbZe6lRiKc5INNRiLipOBABuv6zb4gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If gpio based voltage selection for buck 1/2/5 are not used, then the execution
of gpio dvs setup code during probe can be skipped completly.

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/regulator/max8997.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index cea9ec9..e81a381 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -973,6 +973,10 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 	memcpy(max8997->buck125_gpios, pdata->buck125_gpios, sizeof(int) * 3);
 	max8997->ignore_gpiodvs_side_effect = pdata->ignore_gpiodvs_side_effect;
 
+	if (!pdata->buck1_gpiodvs && !pdata->buck2_gpiodvs &&
+			!pdata->buck5_gpiodvs)
+		goto skip_gpiodvs;
+
 	for (i = 0; i < 8; i++) {
 		max8997->buck1_vol[i] = ret =
 			max8997_get_voltage_proper_val(
@@ -1019,6 +1023,19 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 				max_buck5, 0x3f);
 	}
 
+	/* Initialize all the DVS related BUCK registers */
+	for (i = 0; i < 8; i++) {
+		max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS1 + i,
+				max8997->buck1_vol[i],
+				0x3f);
+		max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS1 + i,
+				max8997->buck2_vol[i],
+				0x3f);
+		max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS1 + i,
+				max8997->buck5_vol[i],
+				0x3f);
+	}
+
 	/*
 	 * If buck 1, 2, and 5 do not care DVS GPIO settings, ignore them.
 	 * If at least one of them cares, set gpios.
@@ -1060,6 +1077,7 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 				& 0x1); /* SET3 */
 	}
 
+skip_gpiodvs:
 	/* DVS-GPIO disabled */
 	max8997_update_reg(i2c, MAX8997_REG_BUCK1CTRL, (pdata->buck1_gpiodvs) ?
 			(1 << 1) : (0 << 1), 1 << 1);
@@ -1068,19 +1086,6 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 	max8997_update_reg(i2c, MAX8997_REG_BUCK5CTRL, (pdata->buck5_gpiodvs) ?
 			(1 << 1) : (0 << 1), 1 << 1);
 
-	/* Initialize all the DVS related BUCK registers */
-	for (i = 0; i < 8; i++) {
-		max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS1 + i,
-				max8997->buck1_vol[i],
-				0x3f);
-		max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS1 + i,
-				max8997->buck2_vol[i],
-				0x3f);
-		max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS1 + i,
-				max8997->buck5_vol[i],
-				0x3f);
-	}
-
 	/* Misc Settings */
 	max8997->ramp_delay = 10; /* set 10mV/us, which is the default */
 	max8997_write_reg(i2c, MAX8997_REG_BUCKRAMP, (0xf << 4) | 0x9);
-- 
1.6.6.rc2

