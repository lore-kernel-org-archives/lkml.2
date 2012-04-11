Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab2DKGk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 02:40:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52280 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2DKGk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 02:40:26 -0400
Message-ID: <1334126418.21963.0.camel@phoenix>
Subject: [PATCH] regulator: Convert tps65xxx regulator drivers to use
 devm_kzalloc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Cyril Chemparathy <cyril@ti.com>,
        Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 11 Apr 2012 14:40:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6507x-regulator.c |    7 +------
 drivers/regulator/tps6524x-regulator.c |    3 +--
 drivers/regulator/tps65910-regulator.c |    9 +++------
 drivers/regulator/tps65912-regulator.c |    6 +-----
 4 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 16d27fc..8e432004b 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -429,7 +429,7 @@ static __devinit int tps6507x_pmic_probe(struct platform_device *pdev)
 	if (!init_data)
 		return -EINVAL;
 
-	tps = kzalloc(sizeof(*tps), GFP_KERNEL);
+	tps = devm_kzalloc(&pdev->dev, sizeof(*tps), GFP_KERNEL);
 	if (!tps)
 		return -ENOMEM;
 
@@ -479,8 +479,6 @@ static __devinit int tps6507x_pmic_probe(struct platform_device *pdev)
 fail:
 	while (--i >= 0)
 		regulator_unregister(tps->rdev[i]);
-
-	kfree(tps);
 	return error;
 }
 
@@ -492,9 +490,6 @@ static int __devexit tps6507x_pmic_remove(struct platform_device *pdev)
 
 	for (i = 0; i < TPS6507X_NUM_REGULATOR; i++)
 		regulator_unregister(tps->rdev[i]);
-
-	kfree(tps);
-
 	return 0;
 }
 
diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 6616af7..b88b3df 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -595,7 +595,6 @@ static int pmic_remove(struct spi_device *spi)
 		hw->rdev[i] = NULL;
 	}
 	spi_set_drvdata(spi, NULL);
-	kfree(hw);
 	return 0;
 }
 
@@ -614,7 +613,7 @@ static int __devinit pmic_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	hw = kzalloc(sizeof(struct tps6524x), GFP_KERNEL);
+	hw = devm_kzalloc(&spi->dev, sizeof(struct tps6524x), GFP_KERNEL);
 	if (!hw) {
 		dev_err(dev, "cannot allocate regulator private data\n");
 		return -ENOMEM;
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 08976ad..747bf57 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1109,7 +1109,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 	if (!pmic_plat_data)
 		return -EINVAL;
 
-	pmic = kzalloc(sizeof(*pmic), GFP_KERNEL);
+	pmic = devm_kzalloc(&pdev->dev, sizeof(*pmic), GFP_KERNEL);
 	if (!pmic)
 		return -ENOMEM;
 
@@ -1136,7 +1136,6 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		break;
 	default:
 		pr_err("Invalid tps chip version\n");
-		kfree(pmic);
 		return -ENODEV;
 	}
 
@@ -1144,7 +1143,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 			sizeof(struct regulator_desc), GFP_KERNEL);
 	if (!pmic->desc) {
 		err = -ENOMEM;
-		goto err_free_pmic;
+		goto err_out;
 	}
 
 	pmic->info = kcalloc(pmic->num_regulators,
@@ -1233,8 +1232,7 @@ err_free_info:
 	kfree(pmic->info);
 err_free_desc:
 	kfree(pmic->desc);
-err_free_pmic:
-	kfree(pmic);
+err_out:
 	return err;
 }
 
@@ -1249,7 +1247,6 @@ static int __devexit tps65910_remove(struct platform_device *pdev)
 	kfree(pmic->rdev);
 	kfree(pmic->info);
 	kfree(pmic->desc);
-	kfree(pmic);
 	return 0;
 }
 
diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index 8c9c613..af335dd 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -477,7 +477,7 @@ static __devinit int tps65912_probe(struct platform_device *pdev)
 
 	reg_data = pmic_plat_data->tps65912_pmic_init_data;
 
-	pmic = kzalloc(sizeof(*pmic), GFP_KERNEL);
+	pmic = devm_kzalloc(&pdev->dev, sizeof(*pmic), GFP_KERNEL);
 	if (!pmic)
 		return -ENOMEM;
 
@@ -523,8 +523,6 @@ static __devinit int tps65912_probe(struct platform_device *pdev)
 err:
 	while (--i >= 0)
 		regulator_unregister(pmic->rdev[i]);
-
-	kfree(pmic);
 	return err;
 }
 
@@ -535,8 +533,6 @@ static int __devexit tps65912_remove(struct platform_device *pdev)
 
 	for (i = 0; i < TPS65912_NUM_REGULATOR; i++)
 		regulator_unregister(tps65912_reg->rdev[i]);
-
-	kfree(tps65912_reg);
 	return 0;
 }
 
-- 
1.7.5.4



