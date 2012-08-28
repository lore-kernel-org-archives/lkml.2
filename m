Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab2H1LsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:48:22 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:36819 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab2H1LsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:48:19 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com, sameo@linux.intel.com,
        peter.ujfalusi@ti.com, s-guiriec@ti.com,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 6/6] regulator: palmas add DT support
Date: Tue, 28 Aug 2012 13:47:40 +0200
Message-Id: <1346154460-20031-7-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
References: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT support to palmas regulator. This involved a little change to
the platform data structure. Regulator information can now come from
platform data or DT.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/regulator/palmas-regulator.c |  130 +++++++++++++++++++++++++++++++---
 1 file changed, 119 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 2ba7502..48c318b 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -22,6 +22,8 @@
 #include <linux/slab.h>
 #include <linux/regmap.h>
 #include <linux/mfd/palmas.h>
+#include <linux/of_platform.h>
+#include <linux/regulator/of_regulator.h>
 
 struct regs_info {
 	char	*name;
@@ -568,10 +570,103 @@ static int palmas_ldo_init(struct palmas *palmas, int id,
 	return 0;
 }
 
+static struct of_regulator_match palmas_matches[] = {
+	{ .name = "smps12", },
+	{ .name = "smps123", },
+	{ .name = "smps3", },
+	{ .name = "smps45", },
+	{ .name = "smps457", },
+	{ .name = "smps6", },
+	{ .name = "smps7", },
+	{ .name = "smps8", },
+	{ .name = "smps9", },
+	{ .name = "smps10", },
+	{ .name = "ldo1", },
+	{ .name = "ldo2", },
+	{ .name = "ldo3", },
+	{ .name = "ldo4", },
+	{ .name = "ldo5", },
+	{ .name = "ldo6", },
+	{ .name = "ldo7", },
+	{ .name = "ldo8", },
+	{ .name = "ldo9", },
+	{ .name = "ldoln", },
+	{ .name = "ldousb", },
+};
+
+static void __devinit palmas_dt_to_pdata(struct device *dev,
+		struct device_node *node,
+		struct palmas_pmic_platform_data *pdata)
+{
+	struct device_node *regulators;
+	u32 prop;
+	int idx, ret;
+
+	regulators = of_find_node_by_name(node, "regulators");
+	if (!regulators) {
+		dev_info(dev, "regulator node not found\n");
+		return;
+	}
+
+	ret = of_regulator_match(dev, regulators, palmas_matches,
+			PALMAS_NUM_REGS);
+	if (ret < 0) {
+		dev_err(dev, "Error parsing regulator init data: %d\n", ret);
+		return;
+	}
+
+	for (idx = 0; idx < PALMAS_NUM_REGS; idx++) {
+		if (!palmas_matches[idx].init_data ||
+				!palmas_matches[idx].of_node)
+			continue;
+
+		pdata->reg_data[idx] = palmas_matches[idx].init_data;
+
+		pdata->reg_init[idx] = devm_kzalloc(dev,
+				sizeof(struct palmas_reg_init), GFP_KERNEL);
+
+		ret = of_property_read_u32(palmas_matches[idx].of_node,
+				"ti,warm_reset", &prop);
+		if (!ret)
+			pdata->reg_init[idx]->warm_reset = prop;
+
+		ret = of_property_read_u32(palmas_matches[idx].of_node,
+				"ti,roof_floor", &prop);
+		if (!ret)
+			pdata->reg_init[idx]->roof_floor = prop;
+
+		ret = of_property_read_u32(palmas_matches[idx].of_node,
+				"ti,mode_sleep", &prop);
+		if (!ret)
+			pdata->reg_init[idx]->mode_sleep = prop;
+
+		ret = of_property_read_u32(palmas_matches[idx].of_node,
+				"ti,warm_reset", &prop);
+		if (!ret)
+			pdata->reg_init[idx]->warm_reset = prop;
+
+		ret = of_property_read_u32(palmas_matches[idx].of_node,
+				"ti,tstep", &prop);
+		if (!ret)
+			pdata->reg_init[idx]->tstep = prop;
+
+		ret = of_property_read_u32(palmas_matches[idx].of_node,
+				"ti,vsel", &prop);
+		if (!ret)
+			pdata->reg_init[idx]->vsel = prop;
+	}
+
+	ret = of_property_read_u32(node, "ti,ldo6_vibrator", &prop);
+	if (!ret)
+		pdata->ldo6_vibrator = prop;
+}
+
+
 static __devinit int palmas_probe(struct platform_device *pdev)
 {
 	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
 	struct palmas_pmic_platform_data *pdata = pdev->dev.platform_data;
+	struct device_node *node = pdev->dev.of_node;
 	struct regulator_dev *rdev;
 	struct regulator_config config = { };
 	struct palmas_pmic *pmic;
@@ -579,10 +674,14 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 	int id = 0, ret;
 	unsigned int addr, reg;
 
-	if (!pdata)
-		return -EINVAL;
-	if (!pdata->reg_data)
-		return -EINVAL;
+	if (node && !pdata) {
+		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+
+		if (!pdata)
+			return -ENOMEM;
+
+		palmas_dt_to_pdata(&pdev->dev, node, pdata);
+	}
 
 	pmic = devm_kzalloc(&pdev->dev, sizeof(*pmic), GFP_KERNEL);
 	if (!pmic)
@@ -661,7 +760,7 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 		pmic->desc[id].owner = THIS_MODULE;
 
 		/* Initialise sleep/init values from platform data */
-		if (pdata && pdata->reg_init) {
+		if (pdata) {
 			reg_init = pdata->reg_init[id];
 			if (reg_init) {
 				ret = palmas_smps_init(palmas, id, reg_init);
@@ -685,11 +784,13 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 				pmic->range[id] = 1;
 		}
 
-		if (pdata && pdata->reg_data)
+		if (pdata)
 			config.init_data = pdata->reg_data[id];
 		else
 			config.init_data = NULL;
 
+		config.of_node = palmas_matches[id].of_node;
+
 		rdev = regulator_register(&pmic->desc[id], &config);
 		if (IS_ERR(rdev)) {
 			dev_err(&pdev->dev,
@@ -726,11 +827,13 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 						palmas_regs_info[id].ctrl_addr);
 		pmic->desc[id].enable_mask = PALMAS_LDO1_CTRL_MODE_ACTIVE;
 
-		if (pdata && pdata->reg_data)
+		if (pdata)
 			config.init_data = pdata->reg_data[id];
 		else
 			config.init_data = NULL;
 
+		config.of_node = palmas_matches[id].of_node;
+
 		rdev = regulator_register(&pmic->desc[id], &config);
 		if (IS_ERR(rdev)) {
 			dev_err(&pdev->dev,
@@ -744,14 +847,12 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 		pmic->rdev[id] = rdev;
 
 		/* Initialise sleep/init values from platform data */
-		if (pdata->reg_init) {
+		if (pdata) {
 			reg_init = pdata->reg_init[id];
 			if (reg_init) {
 				ret = palmas_ldo_init(palmas, id, reg_init);
-				if (ret) {
-					regulator_unregister(pmic->rdev[id]);
+				if (ret)
 					goto err_unregister_regulator;
-				}
 			}
 		}
 	}
@@ -774,9 +875,15 @@ static int __devexit palmas_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct of_device_id __devinitdata of_palmas_match_tbl[] = {
+	{ .compatible = "ti,palmas-pmic", },
+	{ /* end */ }
+};
+
 static struct platform_driver palmas_driver = {
 	.driver = {
 		.name = "palmas-pmic",
+		.of_match_table = of_palmas_match_tbl,
 		.owner = THIS_MODULE,
 	},
 	.probe = palmas_probe,
@@ -799,3 +906,4 @@ MODULE_AUTHOR("Graeme Gregory <gg@slimlogic.co.uk>");
 MODULE_DESCRIPTION("Palmas voltage regulator driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:palmas-pmic");
+MODULE_DEVICE_TABLE(of, of_palmas_match_tbl);
-- 
1.7.9.5

