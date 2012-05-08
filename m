Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab2EHPn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:43:56 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11199 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab2EHPnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:43:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 08 May 2012 08:43:43 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 4/6 v3] regulator: tps65910 regulator: add device tree support
Date: Tue, 8 May 2012 11:42:41 -0700
Message-ID: <1336502563-31789-5-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336502563-31789-1-git-send-email-rklein@nvidia.com>
References: <1336502563-31789-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree based initialization support for TI tps65910 regulators.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 v3: Modified to use new api of_regulator_match to fetch all regulator
     init data from device node.

 v2: split off regulator specific dt initialization

 drivers/regulator/tps65910-regulator.c |  108 ++++++++++++++++++++++++++++++++
 1 files changed, 108 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 09fb5cd..67791e1 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/gpio.h>
 #include <linux/mfd/tps65910.h>
+#include <linux/regulator/of_regulator.h>
 
 #define TPS65910_SUPPLY_STATE_ENABLED	0x1
 #define EXT_SLEEP_CONTROL (TPS65910_SLEEP_CONTROL_EXT_INPUT_EN1 |	\
@@ -1047,6 +1048,105 @@ static int tps65910_set_ext_sleep_config(struct tps65910_reg *pmic,
 	return ret;
 }
 
+#ifdef CONFIG_OF
+
+static struct of_regulator_match tps65910_matches[] = {
+	{ .name = "VRTC",	.driver_data = (void *) &tps65910_regs[0] },
+	{ .name = "VIO",	.driver_data = (void *) &tps65910_regs[1] },
+	{ .name = "VDD1",	.driver_data = (void *) &tps65910_regs[2] },
+	{ .name = "VDD2",	.driver_data = (void *) &tps65910_regs[3] },
+	{ .name = "VDD3",	.driver_data = (void *) &tps65910_regs[4] },
+	{ .name = "VDIG1",	.driver_data = (void *) &tps65910_regs[5] },
+	{ .name = "VDIG2",	.driver_data = (void *) &tps65910_regs[6] },
+	{ .name = "VPLL",	.driver_data = (void *) &tps65910_regs[7] },
+	{ .name = "VDAC",	.driver_data = (void *) &tps65910_regs[8] },
+	{ .name = "VAUX1",	.driver_data = (void *) &tps65910_regs[9] },
+	{ .name = "VAUX2",	.driver_data = (void *) &tps65910_regs[10] },
+	{ .name = "VAUX33",	.driver_data = (void *) &tps65910_regs[11] },
+	{ .name = "VMMC",	.driver_data = (void *) &tps65910_regs[12] },
+};
+
+static struct of_regulator_match tps65911_matches[] = {
+	{ .name = "VRTC",	.driver_data = (void *) &tps65911_regs[0] },
+	{ .name = "VIO",	.driver_data = (void *) &tps65911_regs[1] },
+	{ .name = "VDD1",	.driver_data = (void *) &tps65911_regs[2] },
+	{ .name = "VDD2",	.driver_data = (void *) &tps65911_regs[3] },
+	{ .name = "VDDCTRL",	.driver_data = (void *) &tps65911_regs[4] },
+	{ .name = "LDO1",	.driver_data = (void *) &tps65911_regs[5] },
+	{ .name = "LDO2",	.driver_data = (void *) &tps65911_regs[6] },
+	{ .name = "LDO3",	.driver_data = (void *) &tps65911_regs[7] },
+	{ .name = "LDO4",	.driver_data = (void *) &tps65911_regs[8] },
+	{ .name = "LDO5",	.driver_data = (void *) &tps65911_regs[9] },
+	{ .name = "LDO6",	.driver_data = (void *) &tps65911_regs[10] },
+	{ .name = "LDO7",	.driver_data = (void *) &tps65911_regs[11] },
+	{ .name = "LDO8",	.driver_data = (void *) &tps65911_regs[12] },
+};
+
+static struct tps65910_board *tps65910_parse_dt_reg_data(
+				struct platform_device *pdev)
+{
+	struct tps65910_board *pmic_plat_data;
+	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
+	struct device_node *np = pdev->dev.parent->of_node;
+	struct device_node *regulators;
+	struct of_regulator_match *matches;
+	unsigned int prop;
+	int idx = 0, ret, count;
+
+	pmic_plat_data = devm_kzalloc(&pdev->dev, sizeof(*pmic_plat_data),
+					GFP_KERNEL);
+
+	if (!pmic_plat_data) {
+		dev_err(&pdev->dev, "Failure to alloc pdata for regulators.\n");
+		return NULL;
+	}
+
+	regulators = of_find_node_by_name(np, "regulators");
+
+	switch (tps65910_chip_id(tps65910)) {
+	case TPS65910:
+		count = ARRAY_SIZE(tps65910_matches);
+		matches = tps65910_matches;
+		break;
+	case TPS65911:
+		count = ARRAY_SIZE(tps65911_matches);
+		matches = tps65911_matches;
+		break;
+	default:
+		pr_err("Invalid tps chip version\n");
+		return NULL;
+	}
+
+	ret = of_regulator_match(pdev->dev.parent, regulators, matches, count);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n",
+			ret);
+		return NULL;
+	}
+
+	for (idx = 0; idx < count; idx++) {
+		if (!matches[idx].init_data || !matches[idx].of_node)
+			continue;
+
+		pmic_plat_data->tps65910_pmic_init_data[idx] =
+							matches[idx].init_data;
+
+		ret = of_property_read_u32(matches[idx].of_node,
+				"ti,regulator-ext-sleep-control", &prop);
+		if (!ret)
+			pmic_plat_data->regulator_ext_sleep_control[idx] = prop;
+	}
+
+	return pmic_plat_data;
+}
+#else
+static inline struct tps65910_board *tps65910_parse_dt_reg_data(
+				struct platform_device *pdev)
+{
+	return 0;
+}
+#endif
+
 static __devinit int tps65910_probe(struct platform_device *pdev)
 {
 	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
@@ -1059,6 +1159,9 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 	int i, err;
 
 	pmic_plat_data = dev_get_platdata(tps65910->dev);
+	if (!pmic_plat_data && tps65910->dev->of_node)
+		pmic_plat_data = tps65910_parse_dt_reg_data(pdev);
+
 	if (!pmic_plat_data)
 		return -EINVAL;
 
@@ -1166,6 +1269,11 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		config.driver_data = pmic;
 		config.regmap = tps65910->regmap;
 
+#ifdef CONFIG_OF
+		config.of_node = of_find_node_by_name(tps65910->dev->of_node,
+							info->name);
+#endif
+
 		rdev = regulator_register(&pmic->desc[i], &config);
 		if (IS_ERR(rdev)) {
 			dev_err(tps65910->dev,
-- 
1.7.0.4

