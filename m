Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab2KGInB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 03:43:01 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:34527 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285Ab2KGInA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 03:43:00 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, sameo@linux.intel.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] mfd: max8925: support dt for regulator
Date: Wed,  7 Nov 2012 16:41:50 +0800
Message-Id: <1352277710-16149-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 07 Nov 2012 08:41:00.0439 (UTC) FILETIME=[9D203270:01CDBCC3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

Signed-off-by: Qing Xu <qingx@marvell.com>
---
 drivers/regulator/max8925-regulator.c |   72 +++++++++++++++++++++++++++++++-
 1 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 9bb0be3..5e84921 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -17,6 +17,8 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/mfd/max8925.h>
+#include <linux/of.h>
+#include <linux/regulator/of_regulator.h>
 
 #define SD1_DVM_VMIN		850000
 #define SD1_DVM_VMAX		1000000
@@ -187,6 +189,34 @@ static struct regulator_ops max8925_regulator_ldo_ops = {
 	.enable_reg	= MAX8925_LDOCTL##_id,			\
 }
 
+#ifdef CONFIG_OF
+static struct of_regulator_match max8925_regulator_matches[] = {
+	{ .name	= "SDV1",},
+	{ .name = "SDV2",},
+	{ .name = "SDV3",},
+	{ .name = "LDO1",},
+	{ .name = "LDO2",},
+	{ .name = "LDO3",},
+	{ .name = "LDO4",},
+	{ .name = "LDO5",},
+	{ .name = "LDO6",},
+	{ .name = "LDO7",},
+	{ .name = "LDO8",},
+	{ .name = "LDO9",},
+	{ .name = "LDO10",},
+	{ .name = "LDO11",},
+	{ .name = "LDO12",},
+	{ .name = "LDO13",},
+	{ .name = "LDO14",},
+	{ .name = "LDO15",},
+	{ .name = "LDO16",},
+	{ .name = "LDO17",},
+	{ .name = "LDO18",},
+	{ .name = "LDO19",},
+	{ .name = "LDO20",},
+};
+#endif
+
 static struct max8925_regulator_info max8925_regulator_info[] = {
 	MAX8925_SDV(1, 637.5, 1425, 12.5),
 	MAX8925_SDV(2,   650, 2225,   25),
@@ -214,6 +244,36 @@ static struct max8925_regulator_info max8925_regulator_info[] = {
 	MAX8925_LDO(20, 750, 3900, 50),
 };
 
+#ifdef CONFIG_OF
+static int max8925_regulator_dt_init(struct platform_device *pdev,
+				    struct max8925_regulator_info *info,
+				    struct regulator_config *config,
+				    int ridx)
+{
+	struct device_node *nproot, *np;
+	int rcount;
+	nproot = pdev->dev.parent->of_node;
+	if (!nproot)
+		return -ENODEV;
+	np = of_find_node_by_name(nproot, "regulators");
+	if (!np) {
+		dev_err(&pdev->dev, "failed to find regulators node\n");
+		return -ENODEV;
+	}
+
+	rcount = of_regulator_match(&pdev->dev, np,
+				&max8925_regulator_matches[ridx], 1);
+	if (rcount < 0)
+		return -ENODEV;
+	config->init_data =	max8925_regulator_matches[ridx].init_data;
+	config->of_node = max8925_regulator_matches[ridx].of_node;
+
+	return 0;
+}
+#else
+#define max8925_regulator_dt_init(x, y, z)	(-1)
+#endif
+
 static int __devinit max8925_regulator_probe(struct platform_device *pdev)
 {
 	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
@@ -222,7 +282,7 @@ static int __devinit max8925_regulator_probe(struct platform_device *pdev)
 	struct max8925_regulator_info *ri;
 	struct resource *res;
 	struct regulator_dev *rdev;
-	int i;
+	int i, regulator_idx;
 
 	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
 	if (!res) {
@@ -231,9 +291,12 @@ static int __devinit max8925_regulator_probe(struct platform_device *pdev)
 	}
 	for (i = 0; i < ARRAY_SIZE(max8925_regulator_info); i++) {
 		ri = &max8925_regulator_info[i];
-		if (ri->vol_reg == res->start)
+		if (ri->vol_reg == res->start) {
+			regulator_idx = i;
 			break;
+		}
 	}
+
 	if (i == ARRAY_SIZE(max8925_regulator_info)) {
 		dev_err(&pdev->dev, "Failed to find regulator %llu\n",
 			(unsigned long long)res->start);
@@ -243,9 +306,12 @@ static int __devinit max8925_regulator_probe(struct platform_device *pdev)
 	ri->chip = chip;
 
 	config.dev = &pdev->dev;
-	config.init_data = pdata;
 	config.driver_data = ri;
 
+	if (max8925_regulator_dt_init(pdev, ri, &config, regulator_idx))
+		if (pdata)
+			config.init_data = pdata;
+
 	rdev = regulator_register(&ri->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
-- 
1.7.0.4

