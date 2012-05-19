Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481Ab2ESOjh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 10:39:37 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16526 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760420Ab2ESOja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 10:39:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 19 May 2012 07:39:26 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 4/5] regulator: tps65910: use devm_* for memory allocation
Date: Sat, 19 May 2012 20:04:09 +0530
Message-ID: <1337438050-3707-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com>
References: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use the devm_* apis for memory allocation.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65910-regulator.c |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 72942c2..5a8ad4e 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1191,25 +1191,25 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	pmic->desc = kcalloc(pmic->num_regulators,
+	pmic->desc = devm_kzalloc(&pdev->dev, pmic->num_regulators *
 			sizeof(struct regulator_desc), GFP_KERNEL);
 	if (!pmic->desc) {
-		err = -ENOMEM;
-		goto err_out;
+		dev_err(&pdev->dev, "Memory alloc fails for desc\n");
+		return -ENOMEM;
 	}
 
-	pmic->info = kcalloc(pmic->num_regulators,
+	pmic->info = devm_kzalloc(&pdev->dev, pmic->num_regulators *
 			sizeof(struct tps_info *), GFP_KERNEL);
 	if (!pmic->info) {
-		err = -ENOMEM;
-		goto err_free_desc;
+		dev_err(&pdev->dev, "Memory alloc fails for info\n");
+		return -ENOMEM;
 	}
 
-	pmic->rdev = kcalloc(pmic->num_regulators,
+	pmic->rdev = devm_kzalloc(&pdev->dev, pmic->num_regulators *
 			sizeof(struct regulator_dev *), GFP_KERNEL);
 	if (!pmic->rdev) {
-		err = -ENOMEM;
-		goto err_free_info;
+		dev_err(&pdev->dev, "Memory alloc fails for rdev\n");
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < pmic->num_regulators && i < TPS65910_NUM_REGS;
@@ -1286,12 +1286,6 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 err_unregister_regulator:
 	while (--i >= 0)
 		regulator_unregister(pmic->rdev[i]);
-	kfree(pmic->rdev);
-err_free_info:
-	kfree(pmic->info);
-err_free_desc:
-	kfree(pmic->desc);
-err_out:
 	return err;
 }
 
@@ -1303,9 +1297,6 @@ static int __devexit tps65910_remove(struct platform_device *pdev)
 	for (i = 0; i < pmic->num_regulators; i++)
 		regulator_unregister(pmic->rdev[i]);
 
-	kfree(pmic->rdev);
-	kfree(pmic->info);
-	kfree(pmic->desc);
 	return 0;
 }
 
-- 
1.7.1.1

