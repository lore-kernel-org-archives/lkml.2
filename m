Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab2K1R04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:26:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33057 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429Ab2K1RZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:25:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/4] regulator: arizona-ldo1: Support 1.8V mode
Date: Wed, 28 Nov 2012 17:25:34 +0000
Message-Id: <1354123534-6927-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354123534-6927-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1354123534-6927-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Arizona device support a 1.8V output mode. Enable this in the driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c           |    3 +
 drivers/regulator/arizona-ldo1.c      |  107 ++++++++++++++++++++++++++++++++-
 include/linux/mfd/arizona/registers.h |   16 +++++
 3 files changed, 125 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index fbe0304..065ffd3 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -274,6 +274,7 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000154, 0x0000 },   /* R340   - Rate Estimator 3 */ 
 	{ 0x00000155, 0x0000 },   /* R341   - Rate Estimator 4 */ 
 	{ 0x00000156, 0x0000 },   /* R342   - Rate Estimator 5 */ 
+	{ 0x00000161, 0x0000 },   /* R353   - Dynamic Frequency Scaling 1 */ 
 	{ 0x00000171, 0x0000 },   /* R369   - FLL1 Control 1 */ 
 	{ 0x00000172, 0x0008 },   /* R370   - FLL1 Control 2 */ 
 	{ 0x00000173, 0x0018 },   /* R371   - FLL1 Control 3 */ 
@@ -1064,6 +1065,7 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_RATE_ESTIMATOR_3:
 	case ARIZONA_RATE_ESTIMATOR_4:
 	case ARIZONA_RATE_ESTIMATOR_5:
+	case ARIZONA_DYNAMIC_FREQUENCY_SCALING_1:
 	case ARIZONA_FLL1_CONTROL_1:
 	case ARIZONA_FLL1_CONTROL_2:
 	case ARIZONA_FLL1_CONTROL_3:
@@ -1098,6 +1100,7 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_FLL2_GPIO_CLOCK:
 	case ARIZONA_MIC_CHARGE_PUMP_1:
 	case ARIZONA_LDO1_CONTROL_1:
+	case ARIZONA_LDO1_CONTROL_2:
 	case ARIZONA_LDO2_CONTROL_1:
 	case ARIZONA_MIC_BIAS_CTRL_1:
 	case ARIZONA_MIC_BIAS_CTRL_2:
diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index e4b7dd4..ed7beec 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -34,6 +34,108 @@ struct arizona_ldo1 {
 	struct regulator_init_data init_data;
 };
 
+static int arizona_ldo1_hc_list_voltage(struct regulator_dev *rdev,
+					unsigned int selector)
+{
+	if (selector >= rdev->desc->n_voltages)
+		return -EINVAL;
+
+	if (selector == rdev->desc->n_voltages - 1)
+		return 1800000;
+	else
+		return rdev->desc->min_uV + (rdev->desc->uV_step * selector);
+}
+
+static int arizona_ldo1_hc_map_voltage(struct regulator_dev *rdev,
+				       int min_uV, int max_uV)
+{
+	int sel;
+
+	sel = DIV_ROUND_UP(min_uV - rdev->desc->min_uV, rdev->desc->uV_step);
+	if (sel >= rdev->desc->n_voltages)
+		sel = rdev->desc->n_voltages - 1;
+
+	return sel;
+}
+
+static int arizona_ldo1_hc_set_voltage_sel(struct regulator_dev *rdev,
+					   unsigned sel)
+{
+	struct arizona_ldo1 *ldo = rdev_get_drvdata(rdev);
+	struct regmap *regmap = ldo->arizona->regmap;
+	unsigned int val;
+	int ret;
+
+	if (sel == rdev->desc->n_voltages - 1)
+		val = ARIZONA_LDO1_HI_PWR;
+	else
+		val = 0;
+
+	ret = regmap_update_bits(regmap, ARIZONA_LDO1_CONTROL_2,
+				 ARIZONA_LDO1_HI_PWR, val);
+	if (ret != 0)
+		return ret;
+
+	ret = regmap_update_bits(regmap, ARIZONA_DYNAMIC_FREQUENCY_SCALING_1,
+				 ARIZONA_SUBSYS_MAX_FREQ, val);
+	if (ret != 0)
+		return ret;
+
+	if (val)
+		return 0;
+
+	val = sel << ARIZONA_LDO1_VSEL_SHIFT;
+
+	return regmap_update_bits(regmap, ARIZONA_LDO1_CONTROL_1,
+				  ARIZONA_LDO1_VSEL_MASK, val);
+}
+
+static int arizona_ldo1_hc_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct arizona_ldo1 *ldo = rdev_get_drvdata(rdev);
+	struct regmap *regmap = ldo->arizona->regmap;
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(regmap, ARIZONA_LDO1_CONTROL_2, &val);
+	if (ret != 0)
+		return ret;
+
+	if (val & ARIZONA_LDO1_HI_PWR)
+		return rdev->desc->n_voltages - 1;
+
+	ret = regmap_read(regmap, ARIZONA_LDO1_CONTROL_1, &val);
+	if (ret != 0)
+		return ret;
+
+	return (val & ARIZONA_LDO1_VSEL_MASK) >> ARIZONA_LDO1_VSEL_SHIFT;
+}
+
+static struct regulator_ops arizona_ldo1_hc_ops = {
+	.list_voltage = arizona_ldo1_hc_list_voltage,
+	.map_voltage = arizona_ldo1_hc_map_voltage,
+	.get_voltage_sel = arizona_ldo1_hc_get_voltage_sel,
+	.set_voltage_sel = arizona_ldo1_hc_set_voltage_sel,
+	.get_bypass = regulator_get_bypass_regmap,
+	.set_bypass = regulator_set_bypass_regmap,
+};
+
+static const struct regulator_desc arizona_ldo1_hc = {
+	.name = "LDO1",
+	.supply_name = "LDOVDD",
+	.type = REGULATOR_VOLTAGE,
+	.ops = &arizona_ldo1_hc_ops,
+
+	.bypass_reg = ARIZONA_LDO1_CONTROL_1,
+	.bypass_mask = ARIZONA_LDO1_BYPASS,
+	.min_uV = 900000,
+	.uV_step = 50000,
+	.n_voltages = 8,
+	.enable_time = 500,
+
+	.owner = THIS_MODULE,
+};
+
 static struct regulator_ops arizona_ldo1_ops = {
 	.list_voltage = regulator_list_voltage_linear,
 	.map_voltage = regulator_map_voltage_linear,
@@ -81,6 +183,7 @@ static const struct regulator_init_data arizona_ldo1_default = {
 static int arizona_ldo1_probe(struct platform_device *pdev)
 {
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
+	const struct regulator_desc *desc;
 	struct regulator_config config = { };
 	struct arizona_ldo1 *ldo1;
 	int ret;
@@ -100,9 +203,11 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	 */
 	switch (arizona->type) {
 	case WM5102:
+		desc = &arizona_ldo1_hc;
 		ldo1->init_data = arizona_ldo1_dvfs;
 		break;
 	default:
+		desc = &arizona_ldo1;
 		ldo1->init_data = arizona_ldo1_default;
 		break;
 	}
@@ -121,7 +226,7 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	else
 		config.init_data = &ldo1->init_data;
 
-	ldo1->regulator = regulator_register(&arizona_ldo1, &config);
+	ldo1->regulator = regulator_register(desc, &config);
 	if (IS_ERR(ldo1->regulator)) {
 		ret = PTR_ERR(ldo1->regulator);
 		dev_err(arizona->dev, "Failed to register LDO1 supply: %d\n",
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index 7671a28..ba26e99 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -76,6 +76,7 @@
 #define ARIZONA_RATE_ESTIMATOR_3                 0x154
 #define ARIZONA_RATE_ESTIMATOR_4                 0x155
 #define ARIZONA_RATE_ESTIMATOR_5                 0x156
+#define ARIZONA_DYNAMIC_FREQUENCY_SCALING_1      0x161
 #define ARIZONA_FLL1_CONTROL_1                   0x171
 #define ARIZONA_FLL1_CONTROL_2                   0x172
 #define ARIZONA_FLL1_CONTROL_3                   0x173
@@ -110,6 +111,7 @@
 #define ARIZONA_FLL2_GPIO_CLOCK                  0x1AA
 #define ARIZONA_MIC_CHARGE_PUMP_1                0x200
 #define ARIZONA_LDO1_CONTROL_1                   0x210
+#define ARIZONA_LDO1_CONTROL_2                   0x212
 #define ARIZONA_LDO2_CONTROL_1                   0x213
 #define ARIZONA_MIC_BIAS_CTRL_1                  0x218
 #define ARIZONA_MIC_BIAS_CTRL_2                  0x219
@@ -1574,6 +1576,13 @@
 #define ARIZONA_SAMPLE_RATE_DETECT_D_WIDTH            5  /* SAMPLE_RATE_DETECT_D - [4:0] */
 
 /*
+ * R353 (0x161) - Dynamic Frequency Scaling 1
+ */
+#define ARIZONA_SUBSYS_MAX_FREQ                  0x0001  /* SUBSYS_MAX_FREQ */
+#define ARIZONA_SUBSYS_MAX_FREQ_SHIFT                 0  /* SUBSYS_MAX_FREQ */
+#define ARIZONA_SUBSYS_MAX_FREQ_WIDTH                 1  /* SUBSYS_MAX_FREQ */
+
+/*
  * R369 (0x171) - FLL1 Control 1
  */
 #define ARIZONA_FLL1_FREERUN                     0x0002  /* FLL1_FREERUN */
@@ -1889,6 +1898,13 @@
 #define ARIZONA_LDO1_ENA_WIDTH                        1  /* LDO1_ENA */
 
 /*
+ * R530 (0x212) - LDO1 Control 2
+ */
+#define ARIZONA_LDO1_HI_PWR                      0x0001  /* LDO1_HI_PWR */
+#define ARIZONA_LDO1_HI_PWR_SHIFT                     0  /* LDO1_HI_PWR */
+#define ARIZONA_LDO1_HI_PWR_WIDTH                     1  /* LDO1_HI_PWR */
+
+/*
  * R531 (0x213) - LDO2 Control 1
  */
 #define ARIZONA_LDO2_VSEL_MASK                   0x07E0  /* LDO2_VSEL - [10:5] */
-- 
1.7.10.4

