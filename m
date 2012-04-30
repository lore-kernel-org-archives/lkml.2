Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab2D3Wvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 18:51:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48737 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756932Ab2D3WvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 18:51:21 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: wm8350: Convert to core regmap-based enable operations
Date: Mon, 30 Apr 2012 23:51:17 +0100
Message-Id: <1335826277-3094-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335826277-3094-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1335826277-3094-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8350-regulator.c |  121 ++++++++--------------------------
 1 file changed, 29 insertions(+), 92 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 5ccab37..12ecaec 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -905,63 +905,6 @@ int wm8350_dcdc25_set_mode(struct wm8350 *wm8350, int dcdc, u16 mode,
 }
 EXPORT_SYMBOL_GPL(wm8350_dcdc25_set_mode);
 
-static int wm8350_dcdc_enable(struct regulator_dev *rdev)
-{
-	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
-	int dcdc = rdev_get_id(rdev);
-	u16 shift;
-
-	if (dcdc < WM8350_DCDC_1 || dcdc > WM8350_DCDC_6)
-		return -EINVAL;
-
-	shift = dcdc - WM8350_DCDC_1;
-	wm8350_set_bits(wm8350, WM8350_DCDC_LDO_REQUESTED, 1 << shift);
-	return 0;
-}
-
-static int wm8350_dcdc_disable(struct regulator_dev *rdev)
-{
-	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
-	int dcdc = rdev_get_id(rdev);
-	u16 shift;
-
-	if (dcdc < WM8350_DCDC_1 || dcdc > WM8350_DCDC_6)
-		return -EINVAL;
-
-	shift = dcdc - WM8350_DCDC_1;
-	wm8350_clear_bits(wm8350, WM8350_DCDC_LDO_REQUESTED, 1 << shift);
-
-	return 0;
-}
-
-static int wm8350_ldo_enable(struct regulator_dev *rdev)
-{
-	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
-	int ldo = rdev_get_id(rdev);
-	u16 shift;
-
-	if (ldo < WM8350_LDO_1 || ldo > WM8350_LDO_4)
-		return -EINVAL;
-
-	shift = (ldo - WM8350_LDO_1) + 8;
-	wm8350_set_bits(wm8350, WM8350_DCDC_LDO_REQUESTED, 1 << shift);
-	return 0;
-}
-
-static int wm8350_ldo_disable(struct regulator_dev *rdev)
-{
-	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
-	int ldo = rdev_get_id(rdev);
-	u16 shift;
-
-	if (ldo < WM8350_LDO_1 || ldo > WM8350_LDO_4)
-		return -EINVAL;
-
-	shift = (ldo - WM8350_LDO_1) + 8;
-	wm8350_clear_bits(wm8350, WM8350_DCDC_LDO_REQUESTED, 1 << shift);
-	return 0;
-}
-
 static int force_continuous_enable(struct wm8350 *wm8350, int dcdc, int enable)
 {
 	int reg = 0, ret;
@@ -1143,42 +1086,16 @@ static unsigned int wm8350_dcdc_get_optimum_mode(struct regulator_dev *rdev,
 	return mode;
 }
 
-static int wm8350_dcdc_is_enabled(struct regulator_dev *rdev)
-{
-	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
-	int dcdc = rdev_get_id(rdev), shift;
-
-	if (dcdc < WM8350_DCDC_1 || dcdc > WM8350_DCDC_6)
-		return -EINVAL;
-
-	shift = dcdc - WM8350_DCDC_1;
-	return wm8350_reg_read(wm8350, WM8350_DCDC_LDO_REQUESTED)
-	    & (1 << shift);
-}
-
-static int wm8350_ldo_is_enabled(struct regulator_dev *rdev)
-{
-	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
-	int ldo = rdev_get_id(rdev), shift;
-
-	if (ldo < WM8350_LDO_1 || ldo > WM8350_LDO_4)
-		return -EINVAL;
-
-	shift = (ldo - WM8350_LDO_1) + 8;
-	return wm8350_reg_read(wm8350, WM8350_DCDC_LDO_REQUESTED)
-	    & (1 << shift);
-}
-
 static struct regulator_ops wm8350_dcdc_ops = {
 	.set_voltage = wm8350_dcdc_set_voltage,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.list_voltage = wm8350_dcdc_list_voltage,
-	.enable = wm8350_dcdc_enable,
-	.disable = wm8350_dcdc_disable,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
 	.get_mode = wm8350_dcdc_get_mode,
 	.set_mode = wm8350_dcdc_set_mode,
 	.get_optimum_mode = wm8350_dcdc_get_optimum_mode,
-	.is_enabled = wm8350_dcdc_is_enabled,
 	.set_suspend_voltage = wm8350_dcdc_set_suspend_voltage,
 	.set_suspend_enable = wm8350_dcdc_set_suspend_enable,
 	.set_suspend_disable = wm8350_dcdc_set_suspend_disable,
@@ -1186,9 +1103,9 @@ static struct regulator_ops wm8350_dcdc_ops = {
 };
 
 static struct regulator_ops wm8350_dcdc2_5_ops = {
-	.enable = wm8350_dcdc_enable,
-	.disable = wm8350_dcdc_disable,
-	.is_enabled = wm8350_dcdc_is_enabled,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
 	.set_suspend_enable = wm8350_dcdc25_set_suspend_enable,
 	.set_suspend_disable = wm8350_dcdc25_set_suspend_disable,
 };
@@ -1197,9 +1114,9 @@ static struct regulator_ops wm8350_ldo_ops = {
 	.set_voltage = wm8350_ldo_set_voltage,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.list_voltage = wm8350_ldo_list_voltage,
-	.enable = wm8350_ldo_enable,
-	.disable = wm8350_ldo_disable,
-	.is_enabled = wm8350_ldo_is_enabled,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
 	.get_mode = wm8350_ldo_get_mode,
 	.set_suspend_voltage = wm8350_ldo_set_suspend_voltage,
 	.set_suspend_enable = wm8350_ldo_set_suspend_enable,
@@ -1225,6 +1142,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
 		.vsel_reg = WM8350_DCDC1_CONTROL,
 		.vsel_mask = WM8350_DC1_VSEL_MASK,
+		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
+		.enable_mask = WM8350_DC1_ENA,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1233,6 +1152,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.ops = &wm8350_dcdc2_5_ops,
 		.irq = WM8350_IRQ_UV_DC2,
 		.type = REGULATOR_VOLTAGE,
+		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
+		.enable_mask = WM8350_DC2_ENA,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1244,6 +1165,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
 		.vsel_reg = WM8350_DCDC3_CONTROL,
 		.vsel_mask = WM8350_DC3_VSEL_MASK,
+		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
+		.enable_mask = WM8350_DC3_ENA,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1255,6 +1178,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
 		.vsel_reg = WM8350_DCDC4_CONTROL,
 		.vsel_mask = WM8350_DC4_VSEL_MASK,
+		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
+		.enable_mask = WM8350_DC4_ENA,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1263,6 +1188,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.ops = &wm8350_dcdc2_5_ops,
 		.irq = WM8350_IRQ_UV_DC5,
 		.type = REGULATOR_VOLTAGE,
+		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
+		.enable_mask = WM8350_DC5_ENA,
 		.owner = THIS_MODULE,
 	 },
 	{
@@ -1274,6 +1201,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
 		.vsel_reg = WM8350_DCDC6_CONTROL,
 		.vsel_mask = WM8350_DC6_VSEL_MASK,
+		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
+		.enable_mask = WM8350_DC6_ENA,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1285,6 +1214,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.n_voltages = WM8350_LDO1_VSEL_MASK + 1,
 		.vsel_reg = WM8350_LDO1_CONTROL,
 		.vsel_mask = WM8350_LDO1_VSEL_MASK,
+		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
+		.enable_mask = WM8350_LDO1_ENA,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1296,6 +1227,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.n_voltages = WM8350_LDO2_VSEL_MASK + 1,
 		.vsel_reg = WM8350_LDO2_CONTROL,
 		.vsel_mask = WM8350_LDO2_VSEL_MASK,
+		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
+		.enable_mask = WM8350_LDO2_ENA,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1307,6 +1240,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.n_voltages = WM8350_LDO3_VSEL_MASK + 1,
 		.vsel_reg = WM8350_LDO3_CONTROL,
 		.vsel_mask = WM8350_LDO3_VSEL_MASK,
+		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
+		.enable_mask = WM8350_LDO3_ENA,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1318,6 +1253,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.n_voltages = WM8350_LDO4_VSEL_MASK + 1,
 		.vsel_reg = WM8350_LDO4_CONTROL,
 		.vsel_mask = WM8350_LDO4_VSEL_MASK,
+		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
+		.enable_mask = WM8350_LDO4_ENA,
 		.owner = THIS_MODULE,
 	},
 	{
-- 
1.7.10

