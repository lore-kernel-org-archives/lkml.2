Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530Ab2ESOkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 10:40:25 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13019 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760350Ab2ESOjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 10:39:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sat, 19 May 2012 07:39:22 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/5] regulator: tps65910: set of_node for regulator register config
Date: Sat, 19 May 2012 20:04:07 +0530
Message-ID: <1337438050-3707-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com>
References: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set of_node parameter for regulator registration configuration
parameter. This node contains the regulator related device node
information for regulator which need to be register.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65910-regulator.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index bd616a0..dd0e2cb 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1071,7 +1071,7 @@ static struct of_regulator_match tps65911_matches[] = {
 };
 
 static struct tps65910_board *tps65910_parse_dt_reg_data(
-				struct platform_device *pdev)
+	struct platform_device *pdev, struct device_node **regulators_node)
 {
 	struct tps65910_board *pmic_plat_data;
 	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
@@ -1090,6 +1090,12 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 	}
 
 	regulators = of_find_node_by_name(np, "regulators");
+	if (!regulators) {
+		dev_err(&pdev->dev, "regulator node not found\n");
+		return NULL;
+	}
+
+	*regulators_node = regulators;
 
 	switch (tps65910_chip_id(tps65910)) {
 	case TPS65910:
@@ -1129,8 +1135,9 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 }
 #else
 static inline struct tps65910_board *tps65910_parse_dt_reg_data(
-				struct platform_device *pdev)
+	struct platform_device *pdev, struct device_node **regulators_node)
 {
+	*regulators_node = NULL;
 	return 0;
 }
 #endif
@@ -1145,10 +1152,11 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 	struct tps65910_reg *pmic;
 	struct tps65910_board *pmic_plat_data;
 	int i, err;
+	struct device_node *reg_node = NULL;
 
 	pmic_plat_data = dev_get_platdata(tps65910->dev);
 	if (!pmic_plat_data && tps65910->dev->of_node)
-		pmic_plat_data = tps65910_parse_dt_reg_data(pdev);
+		pmic_plat_data = tps65910_parse_dt_reg_data(pdev, &reg_node);
 
 	if (!pmic_plat_data)
 		return -EINVAL;
@@ -1257,10 +1265,9 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		config.driver_data = pmic;
 		config.regmap = tps65910->regmap;
 
-#ifdef CONFIG_OF
-		config.of_node = of_find_node_by_name(tps65910->dev->of_node,
+		if (reg_node)
+			config.of_node = of_find_node_by_name(reg_node,
 							info->name);
-#endif
 
 		rdev = regulator_register(&pmic->desc[i], &config);
 		if (IS_ERR(rdev)) {
-- 
1.7.1.1

