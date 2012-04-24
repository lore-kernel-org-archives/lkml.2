Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521Ab2DXXhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:37:36 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16926 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118Ab2DXXgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:36:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Apr 2012 16:36:14 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 6/8 v2] regulator: tps65910 regulator: add device tree support
Date: Tue, 24 Apr 2012 16:36:08 -0700
Message-ID: <1335310570-12455-7-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335310570-12455-1-git-send-email-rklein@nvidia.com>
References: <1335310570-12455-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree based initialization support for TI tps65910 regulators.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 v2: split off regulator specific dt initialization
     made use of new function to match regulator nodes to names to fill in
       init_data

 drivers/regulator/tps65910-regulator.c |  106 ++++++++++++++++++++++++++++++++
 1 files changed, 106 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 855bbec..519be51 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/gpio.h>
 #include <linux/mfd/tps65910.h>
+#include <linux/regulator/of_regulator.h>
 
 #define TPS65910_SUPPLY_STATE_ENABLED	0x1
 #define EXT_SLEEP_CONTROL (TPS65910_SLEEP_CONTROL_EXT_INPUT_EN1 |	\
@@ -1090,6 +1091,104 @@ static int tps65910_set_ext_sleep_config(struct tps65910_reg *pmic,
 	return ret;
 }
 
+#ifdef CONFIG_OF
+
+static const char * const tps65910_reg_names[] = {
+	"VRTC",
+	"VIO",
+	"VDD1",
+	"VDD2",
+	"VDD3",
+	"VDIG1",
+	"VDIG2",
+	"VPLL",
+	"VDAC",
+	"VAUX1",
+	"VAUX2",
+	"VAUX33",
+	"VMMC",
+};
+
+static const char * const tps65911_reg_names[] = {
+	"VRTC",
+	"VIO",
+	"VDD1",
+	"VDD2",
+	"VDDCTRL",
+	"LDO1",
+	"LDO2",
+	"LDO3",
+	"LDO4",
+	"LDO5",
+	"LDO6",
+	"LDO7",
+	"LDO8",
+};
+
+static struct tps65910_board *tps65910_parse_dt_reg_data(
+				struct platform_device *pdev)
+{
+	struct tps65910_board *pmic_plat_data;
+	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
+	struct device_node *np = pdev->dev.parent->of_node;
+	struct device_node *regulators, *child;
+	unsigned int prop;
+	struct regulator_init_data **all_data;
+	int idx = 0, ret;
+
+	pmic_plat_data = devm_kzalloc(&pdev->dev, sizeof(*pmic_plat_data),
+					GFP_KERNEL);
+
+	if (!pmic_plat_data) {
+		dev_err(&pdev->dev, "Failure to alloc pdata for regulators.\n");
+		return NULL;
+	}
+
+	all_data = pmic_plat_data->tps65910_pmic_init_data;
+
+	regulators = of_find_node_by_name(np, "regulators");
+
+	switch (tps65910_chip_id(tps65910)) {
+	case TPS65910:
+		ret = of_find_regulator_init_data_from_device(pdev->dev.parent,
+			regulators, tps65910_reg_names, all_data,
+			ARRAY_SIZE(tps65910_reg_names));
+		break;
+	case TPS65911:
+		ret = of_find_regulator_init_data_from_device(pdev->dev.parent,
+			regulators, tps65911_reg_names, all_data,
+			ARRAY_SIZE(tps65911_reg_names));
+		break;
+	default:
+		pr_err("Invalid tps chip version\n");
+		return NULL;
+	}
+
+	if (ret) {
+		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n",
+			ret);
+		return NULL;
+	}
+
+	idx = 0;
+	for_each_child_of_node(regulators, child) {
+		ret = of_property_read_u32(child,
+				"ti,regulator-ext-sleep-control", &prop);
+		if (!ret)
+			pmic_plat_data->regulator_ext_sleep_control[idx] = prop;
+		idx++;
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
@@ -1102,6 +1201,9 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 	int i, err;
 
 	pmic_plat_data = dev_get_platdata(tps65910->dev);
+	if (!pmic_plat_data && tps65910->dev->of_node)
+		pmic_plat_data = tps65910_parse_dt_reg_data(pdev);
+
 	if (!pmic_plat_data)
 		return -EINVAL;
 
@@ -1205,6 +1307,10 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		config.dev = tps65910->dev;
 		config.init_data = reg_data;
 		config.driver_data = pmic;
+#ifdef CONFIG_OF
+		config.of_node = of_find_node_by_name(tps65910->dev->of_node,
+							info->name);
+#endif
 
 		rdev = regulator_register(&pmic->desc[i], &config);
 		if (IS_ERR(rdev)) {
-- 
1.7.0.4

