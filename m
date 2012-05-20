Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab2ETQY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 12:24:29 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1267 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab2ETQY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 12:24:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 20 May 2012 09:23:08 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 3/3] regulator: tps65910: use of_node of matched regulator being register
Date: Sun, 20 May 2012 21:48:50 +0530
Message-ID: <1337530730-16605-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1337530730-16605-1-git-send-email-ldewangan@nvidia.com>
References: <1337530730-16605-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After getting matched regulators by using of_regulator_match(),
initialize the config.of_node of regulator being register with
of_regulator_match.of_node of that regulator.
This is require for supporting regulator consumers in dt.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
This is discussed in details on patch
	regulator: core: use correct device for device supply lookup
with other issue of input_supply and decided to have the implementation
similar to the mc13892-regulator.c.
In this patch making the implementation very similar to
mc13892-regulator.c. config.of_node for regulator being
register is initialize with of_regulator_match.of_node
which get initialized by calling of_regulator_match.

 drivers/regulator/tps65910-regulator.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 0190f29..4e01a42 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1071,7 +1071,8 @@ static struct of_regulator_match tps65911_matches[] = {
 };
 
 static struct tps65910_board *tps65910_parse_dt_reg_data(
-				struct platform_device *pdev)
+		struct platform_device *pdev,
+		struct of_regulator_match **tps65910_reg_matches)
 {
 	struct tps65910_board *pmic_plat_data;
 	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
@@ -1116,6 +1117,8 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 		return NULL;
 	}
 
+	*tps65910_reg_matches = matches;
+
 	for (idx = 0; idx < count; idx++) {
 		if (!matches[idx].init_data || !matches[idx].of_node)
 			continue;
@@ -1133,8 +1136,10 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 }
 #else
 static inline struct tps65910_board *tps65910_parse_dt_reg_data(
-				struct platform_device *pdev)
+			struct platform_device *pdev,
+			struct of_regulator_match **tps65910_reg_matches)
 {
+	*tps65910_reg_matches = NULL;
 	return 0;
 }
 #endif
@@ -1148,11 +1153,13 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 	struct regulator_dev *rdev;
 	struct tps65910_reg *pmic;
 	struct tps65910_board *pmic_plat_data;
+	struct of_regulator_match *tps65910_reg_matches = NULL;
 	int i, err;
 
 	pmic_plat_data = dev_get_platdata(tps65910->dev);
 	if (!pmic_plat_data && tps65910->dev->of_node)
-		pmic_plat_data = tps65910_parse_dt_reg_data(pdev);
+		pmic_plat_data = tps65910_parse_dt_reg_data(pdev,
+						&tps65910_reg_matches);
 
 	if (!pmic_plat_data) {
 		dev_err(&pdev->dev, "Platform data not found\n");
@@ -1265,10 +1272,8 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		config.driver_data = pmic;
 		config.regmap = tps65910->regmap;
 
-#ifdef CONFIG_OF
-		config.of_node = of_find_node_by_name(tps65910->dev->of_node,
-							info->name);
-#endif
+		if (tps65910_reg_matches)
+			config.of_node = tps65910_reg_matches[i].of_node;
 
 		rdev = regulator_register(&pmic->desc[i], &config);
 		if (IS_ERR(rdev)) {
-- 
1.7.1.1

