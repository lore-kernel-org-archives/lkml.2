Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2DOLva (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 07:51:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44644 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753371Ab2DOLtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 07:49:43 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/8] regulator: wm831x-ldo: Use regulator_get_voltage_sel_regmap()
Date: Sun, 15 Apr 2012 12:49:21 +0100
Message-Id: <1334490565-19808-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-ldo.c |   63 +++++++--------------------------------
 1 files changed, 12 insertions(+), 51 deletions(-)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 344beb8..ef017ea 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -161,22 +161,6 @@ static int wm831x_gp_ldo_set_suspend_voltage(struct regulator_dev *rdev,
 	return wm831x_gp_ldo_set_voltage_int(rdev, reg, uV, uV, &selector);
 }
 
-static int wm831x_gp_ldo_get_voltage_sel(struct regulator_dev *rdev)
-{
-	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
-	struct wm831x *wm831x = ldo->wm831x;
-	int reg = ldo->base + WM831X_LDO_ON_CONTROL;
-	int ret;
-
-	ret = wm831x_reg_read(wm831x, reg);
-	if (ret < 0)
-		return ret;
-
-	ret &= WM831X_LDO1_ON_VSEL_MASK;
-
-	return ret;
-}
-
 static unsigned int wm831x_gp_ldo_get_mode(struct regulator_dev *rdev)
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
@@ -294,7 +278,7 @@ static unsigned int wm831x_gp_ldo_get_optimum_mode(struct regulator_dev *rdev,
 
 static struct regulator_ops wm831x_gp_ldo_ops = {
 	.list_voltage = wm831x_gp_ldo_list_voltage,
-	.get_voltage_sel = wm831x_gp_ldo_get_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage = wm831x_gp_ldo_set_voltage,
 	.set_suspend_voltage = wm831x_gp_ldo_set_suspend_voltage,
 	.get_mode = wm831x_gp_ldo_get_mode,
@@ -356,10 +340,13 @@ static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
 	ldo->desc.n_voltages = WM831X_GP_LDO_MAX_SELECTOR + 1;
 	ldo->desc.ops = &wm831x_gp_ldo_ops;
 	ldo->desc.owner = THIS_MODULE;
+	ldo->desc.vsel_reg = ldo->base + WM831X_LDO_ON_CONTROL;
+	ldo->desc.vsel_mask = WM831X_LDO1_ON_VSEL_MASK;
 
 	config.dev = pdev->dev.parent;
 	config.init_data = pdata->ldo[id];
 	config.driver_data = ldo;
+	config.regmap = wm831x->regmap;
 
 	ldo->regulator = regulator_register(&ldo->desc, &config);
 	if (IS_ERR(ldo->regulator)) {
@@ -478,22 +465,6 @@ static int wm831x_aldo_set_suspend_voltage(struct regulator_dev *rdev,
 	return wm831x_aldo_set_voltage_int(rdev, reg, uV, uV, &selector);
 }
 
-static int wm831x_aldo_get_voltage_sel(struct regulator_dev *rdev)
-{
-	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
-	struct wm831x *wm831x = ldo->wm831x;
-	int reg = ldo->base + WM831X_LDO_ON_CONTROL;
-	int ret;
-
-	ret = wm831x_reg_read(wm831x, reg);
-	if (ret < 0)
-		return ret;
-
-	ret &= WM831X_LDO7_ON_VSEL_MASK;
-
-	return ret;
-}
-
 static unsigned int wm831x_aldo_get_mode(struct regulator_dev *rdev)
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
@@ -569,7 +540,7 @@ static int wm831x_aldo_get_status(struct regulator_dev *rdev)
 
 static struct regulator_ops wm831x_aldo_ops = {
 	.list_voltage = wm831x_aldo_list_voltage,
-	.get_voltage_sel = wm831x_aldo_get_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage = wm831x_aldo_set_voltage,
 	.set_suspend_voltage = wm831x_aldo_set_suspend_voltage,
 	.get_mode = wm831x_aldo_get_mode,
@@ -630,10 +601,13 @@ static __devinit int wm831x_aldo_probe(struct platform_device *pdev)
 	ldo->desc.n_voltages = WM831X_ALDO_MAX_SELECTOR + 1;
 	ldo->desc.ops = &wm831x_aldo_ops;
 	ldo->desc.owner = THIS_MODULE;
+	ldo->desc.vsel_reg = ldo->base + WM831X_LDO_ON_CONTROL;
+	ldo->desc.vsel_mask = WM831X_LDO7_ON_VSEL_MASK;
 
 	config.dev = pdev->dev.parent;
 	config.init_data = pdata->ldo[id];
 	config.driver_data = ldo;
+	config.regmap = wm831x->regmap;
 
 	ldo->regulator = regulator_register(&ldo->desc, &config);
 	if (IS_ERR(ldo->regulator)) {
@@ -739,22 +713,6 @@ static int wm831x_alive_ldo_set_suspend_voltage(struct regulator_dev *rdev,
 	return wm831x_alive_ldo_set_voltage_int(rdev, reg, uV, uV, &selector);
 }
 
-static int wm831x_alive_ldo_get_voltage_sel(struct regulator_dev *rdev)
-{
-	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
-	struct wm831x *wm831x = ldo->wm831x;
-	int reg = ldo->base + WM831X_ALIVE_LDO_ON_CONTROL;
-	int ret;
-
-	ret = wm831x_reg_read(wm831x, reg);
-	if (ret < 0)
-		return ret;
-
-	ret &= WM831X_LDO11_ON_VSEL_MASK;
-
-	return ret;
-}
-
 static int wm831x_alive_ldo_get_status(struct regulator_dev *rdev)
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
@@ -774,7 +732,7 @@ static int wm831x_alive_ldo_get_status(struct regulator_dev *rdev)
 
 static struct regulator_ops wm831x_alive_ldo_ops = {
 	.list_voltage = wm831x_alive_ldo_list_voltage,
-	.get_voltage_sel = wm831x_alive_ldo_get_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage = wm831x_alive_ldo_set_voltage,
 	.set_suspend_voltage = wm831x_alive_ldo_set_suspend_voltage,
 	.get_status = wm831x_alive_ldo_get_status,
@@ -834,10 +792,13 @@ static __devinit int wm831x_alive_ldo_probe(struct platform_device *pdev)
 	ldo->desc.n_voltages = WM831X_ALIVE_LDO_MAX_SELECTOR + 1;
 	ldo->desc.ops = &wm831x_alive_ldo_ops;
 	ldo->desc.owner = THIS_MODULE;
+	ldo->desc.vsel_reg = ldo->base + WM831X_ALIVE_LDO_ON_CONTROL;
+	ldo->desc.vsel_mask = WM831X_LDO11_ON_VSEL_MASK;
 
 	config.dev = pdev->dev.parent;
 	config.init_data = pdata->ldo[id];
 	config.driver_data = ldo;
+	config.regmap = wm831x->regmap;
 
 	ldo->regulator = regulator_register(&ldo->desc, &config);
 	if (IS_ERR(ldo->regulator)) {
-- 
1.7.9.1

