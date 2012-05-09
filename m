Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330Ab2EIXsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:48:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56986 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761278Ab2EIXr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:47:57 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Yadwinder Singh <yadi.brar@samsung.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 6/6] regulator: wm8400: Modernise driver
Date: Thu, 10 May 2012 00:47:34 +0100
Message-Id: <1336607255-4967-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336607255-4967-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336607255-4967-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the driver to use all the regmap based helpers, saving a nice chunk
of code (especially for the DCDCs).

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8400-regulator.c |  169 +++++++++-------------------------
 1 file changed, 44 insertions(+), 125 deletions(-)

diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index 4408b78..69a2b7c 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -19,31 +19,6 @@
 #include <linux/regulator/driver.h>
 #include <linux/mfd/wm8400-private.h>
 
-static int wm8400_ldo_is_enabled(struct regulator_dev *dev)
-{
-	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
-	u16 val;
-
-	val = wm8400_reg_read(wm8400, WM8400_LDO1_CONTROL + rdev_get_id(dev));
-	return (val & WM8400_LDO1_ENA) != 0;
-}
-
-static int wm8400_ldo_enable(struct regulator_dev *dev)
-{
-	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
-
-	return wm8400_set_bits(wm8400, WM8400_LDO1_CONTROL + rdev_get_id(dev),
-			       WM8400_LDO1_ENA, WM8400_LDO1_ENA);
-}
-
-static int wm8400_ldo_disable(struct regulator_dev *dev)
-{
-	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
-
-	return wm8400_set_bits(wm8400, WM8400_LDO1_CONTROL + rdev_get_id(dev),
-			       WM8400_LDO1_ENA, 0);
-}
-
 static int wm8400_ldo_list_voltage(struct regulator_dev *dev,
 				   unsigned selector)
 {
@@ -56,21 +31,9 @@ static int wm8400_ldo_list_voltage(struct regulator_dev *dev,
 		return 1600000 + ((selector - 14) * 100000);
 }
 
-static int wm8400_ldo_get_voltage_sel(struct regulator_dev *dev)
+static int wm8400_ldo_map_voltage(struct regulator_dev *dev,
+				  int min_uV, int max_uV)
 {
-	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
-	u16 val;
-
-	val = wm8400_reg_read(wm8400, WM8400_LDO1_CONTROL + rdev_get_id(dev));
-	val &= WM8400_LDO1_VSEL_MASK;
-
-	return val;
-}
-
-static int wm8400_ldo_set_voltage(struct regulator_dev *dev,
-				  int min_uV, int max_uV, unsigned *selector)
-{
-	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
 	u16 val;
 
 	if (min_uV < 900000 || min_uV > 3300000)
@@ -94,92 +57,19 @@ static int wm8400_ldo_set_voltage(struct regulator_dev *dev,
 		val += 0xf;
 	}
 
-	*selector = val;
-
-	return wm8400_set_bits(wm8400, WM8400_LDO1_CONTROL + rdev_get_id(dev),
-			       WM8400_LDO1_VSEL_MASK, val);
+	return val;
 }
 
 static struct regulator_ops wm8400_ldo_ops = {
-	.is_enabled = wm8400_ldo_is_enabled,
-	.enable = wm8400_ldo_enable,
-	.disable = wm8400_ldo_disable,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
 	.list_voltage = wm8400_ldo_list_voltage,
-	.get_voltage_sel = wm8400_ldo_get_voltage_sel,
-	.set_voltage = wm8400_ldo_set_voltage,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.map_voltage = wm8400_ldo_map_voltage,
 };
 
-static int wm8400_dcdc_is_enabled(struct regulator_dev *dev)
-{
-	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
-	int offset = (rdev_get_id(dev) - WM8400_DCDC1) * 2;
-	u16 val;
-
-	val = wm8400_reg_read(wm8400, WM8400_DCDC1_CONTROL_1 + offset);
-	return (val & WM8400_DC1_ENA) != 0;
-}
-
-static int wm8400_dcdc_enable(struct regulator_dev *dev)
-{
-	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
-	int offset = (rdev_get_id(dev) - WM8400_DCDC1) * 2;
-
-	return wm8400_set_bits(wm8400, WM8400_DCDC1_CONTROL_1 + offset,
-			       WM8400_DC1_ENA, WM8400_DC1_ENA);
-}
-
-static int wm8400_dcdc_disable(struct regulator_dev *dev)
-{
-	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
-	int offset = (rdev_get_id(dev) - WM8400_DCDC1) * 2;
-
-	return wm8400_set_bits(wm8400, WM8400_DCDC1_CONTROL_1 + offset,
-			       WM8400_DC1_ENA, 0);
-}
-
-static int wm8400_dcdc_list_voltage(struct regulator_dev *dev,
-				    unsigned selector)
-{
-	if (selector > WM8400_DC1_VSEL_MASK)
-		return -EINVAL;
-
-	return 850000 + (selector * 25000);
-}
-
-static int wm8400_dcdc_get_voltage_sel(struct regulator_dev *dev)
-{
-	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
-	u16 val;
-	int offset = (rdev_get_id(dev) - WM8400_DCDC1) * 2;
-
-	val = wm8400_reg_read(wm8400, WM8400_DCDC1_CONTROL_1 + offset);
-	val &= WM8400_DC1_VSEL_MASK;
-
-	return val;
-}
-
-static int wm8400_dcdc_set_voltage(struct regulator_dev *dev,
-				   int min_uV, int max_uV, unsigned *selector)
-{
-	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
-	u16 val;
-	int offset = (rdev_get_id(dev) - WM8400_DCDC1) * 2;
-
-	if (min_uV < 850000)
-		return -EINVAL;
-
-	val = DIV_ROUND_UP(min_uV - 850000, 25000);
-
-	if (850000 + (25000 * val) > max_uV)
-		return -EINVAL;
-	BUG_ON(850000 + (25000 * val) < min_uV);
-
-	*selector = val;
-
-	return wm8400_set_bits(wm8400, WM8400_DCDC1_CONTROL_1 + offset,
-			       WM8400_DC1_VSEL_MASK, val);
-}
-
 static unsigned int wm8400_dcdc_get_mode(struct regulator_dev *dev)
 {
 	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
@@ -258,12 +148,12 @@ static unsigned int wm8400_dcdc_get_optimum_mode(struct regulator_dev *dev,
 }
 
 static struct regulator_ops wm8400_dcdc_ops = {
-	.is_enabled = wm8400_dcdc_is_enabled,
-	.enable = wm8400_dcdc_enable,
-	.disable = wm8400_dcdc_disable,
-	.list_voltage = wm8400_dcdc_list_voltage,
-	.get_voltage_sel = wm8400_dcdc_get_voltage_sel,
-	.set_voltage = wm8400_dcdc_set_voltage,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.list_voltage = regulator_list_voltage_linear,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_mode = wm8400_dcdc_get_mode,
 	.set_mode = wm8400_dcdc_set_mode,
 	.get_optimum_mode = wm8400_dcdc_get_optimum_mode,
@@ -274,7 +164,11 @@ static struct regulator_desc regulators[] = {
 		.name = "LDO1",
 		.id = WM8400_LDO1,
 		.ops = &wm8400_ldo_ops,
+		.enable_reg = WM8400_LDO1_CONTROL,
+		.enable_mask = WM8400_LDO1_ENA,
 		.n_voltages = WM8400_LDO1_VSEL_MASK + 1,
+		.vsel_reg = WM8400_LDO1_CONTROL,
+		.vsel_mask = WM8400_LDO1_VSEL_MASK,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -282,15 +176,23 @@ static struct regulator_desc regulators[] = {
 		.name = "LDO2",
 		.id = WM8400_LDO2,
 		.ops = &wm8400_ldo_ops,
+		.enable_reg = WM8400_LDO2_CONTROL,
+		.enable_mask = WM8400_LDO2_ENA,
 		.n_voltages = WM8400_LDO2_VSEL_MASK + 1,
 		.type = REGULATOR_VOLTAGE,
+		.vsel_reg = WM8400_LDO2_CONTROL,
+		.vsel_mask = WM8400_LDO2_VSEL_MASK,
 		.owner = THIS_MODULE,
 	},
 	{
 		.name = "LDO3",
 		.id = WM8400_LDO3,
 		.ops = &wm8400_ldo_ops,
+		.enable_reg = WM8400_LDO3_CONTROL,
+		.enable_mask = WM8400_LDO3_ENA,
 		.n_voltages = WM8400_LDO3_VSEL_MASK + 1,
+		.vsel_reg = WM8400_LDO3_CONTROL,
+		.vsel_mask = WM8400_LDO3_VSEL_MASK,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -298,7 +200,11 @@ static struct regulator_desc regulators[] = {
 		.name = "LDO4",
 		.id = WM8400_LDO4,
 		.ops = &wm8400_ldo_ops,
+		.enable_reg = WM8400_LDO4_CONTROL,
+		.enable_mask = WM8400_LDO4_ENA,
 		.n_voltages = WM8400_LDO4_VSEL_MASK + 1,
+		.vsel_reg = WM8400_LDO4_CONTROL,
+		.vsel_mask = WM8400_LDO4_VSEL_MASK,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -306,7 +212,13 @@ static struct regulator_desc regulators[] = {
 		.name = "DCDC1",
 		.id = WM8400_DCDC1,
 		.ops = &wm8400_dcdc_ops,
+		.enable_reg = WM8400_DCDC1_CONTROL_1,
+		.enable_mask = WM8400_DC1_ENA_MASK,
 		.n_voltages = WM8400_DC1_VSEL_MASK + 1,
+		.vsel_reg = WM8400_DCDC1_CONTROL_1,
+		.vsel_mask = WM8400_DC1_VSEL_MASK,
+		.min_uV = 850000,
+		.uV_step = 25000,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -314,7 +226,13 @@ static struct regulator_desc regulators[] = {
 		.name = "DCDC2",
 		.id = WM8400_DCDC2,
 		.ops = &wm8400_dcdc_ops,
+		.enable_reg = WM8400_DCDC2_CONTROL_1,
+		.enable_mask = WM8400_DC1_ENA_MASK,
 		.n_voltages = WM8400_DC2_VSEL_MASK + 1,
+		.vsel_reg = WM8400_DCDC2_CONTROL_1,
+		.vsel_mask = WM8400_DC2_VSEL_MASK,
+		.min_uV = 850000,
+		.uV_step = 25000,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -329,6 +247,7 @@ static int __devinit wm8400_regulator_probe(struct platform_device *pdev)
 	config.dev = &pdev->dev;
 	config.init_data = pdev->dev.platform_data;
 	config.driver_data = wm8400;
+	config.regmap = wm8400->regmap;
 
 	rdev = regulator_register(&regulators[pdev->id], &config);
 	if (IS_ERR(rdev))
-- 
1.7.10

