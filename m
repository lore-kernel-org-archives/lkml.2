Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2DOLuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 07:50:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44653 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845Ab2DOLto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 07:49:44 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 8/8] regulator: wm831x-ldo: Use generic regmap enable/disable operations
Date: Sun, 15 Apr 2012 12:49:25 +0100
Message-Id: <1334490565-19808-8-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-ldo.c |   59 ++++++++++-----------------------------
 1 files changed, 15 insertions(+), 44 deletions(-)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index ef017ea..5bf793d 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -47,41 +47,6 @@ struct wm831x_ldo {
  * Shared
  */
 
-static int wm831x_ldo_is_enabled(struct regulator_dev *rdev)
-{
-	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
-	struct wm831x *wm831x = ldo->wm831x;
-	int mask = 1 << rdev_get_id(rdev);
-	int reg;
-
-	reg = wm831x_reg_read(wm831x, WM831X_LDO_ENABLE);
-	if (reg < 0)
-		return reg;
-
-	if (reg & mask)
-		return 1;
-	else
-		return 0;
-}
-
-static int wm831x_ldo_enable(struct regulator_dev *rdev)
-{
-	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
-	struct wm831x *wm831x = ldo->wm831x;
-	int mask = 1 << rdev_get_id(rdev);
-
-	return wm831x_set_bits(wm831x, WM831X_LDO_ENABLE, mask, mask);
-}
-
-static int wm831x_ldo_disable(struct regulator_dev *rdev)
-{
-	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
-	struct wm831x *wm831x = ldo->wm831x;
-	int mask = 1 << rdev_get_id(rdev);
-
-	return wm831x_set_bits(wm831x, WM831X_LDO_ENABLE, mask, 0);
-}
-
 static irqreturn_t wm831x_ldo_uv_irq(int irq, void *data)
 {
 	struct wm831x_ldo *ldo = data;
@@ -286,9 +251,9 @@ static struct regulator_ops wm831x_gp_ldo_ops = {
 	.get_status = wm831x_gp_ldo_get_status,
 	.get_optimum_mode = wm831x_gp_ldo_get_optimum_mode,
 
-	.is_enabled = wm831x_ldo_is_enabled,
-	.enable = wm831x_ldo_enable,
-	.disable = wm831x_ldo_disable,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
 };
 
 static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
@@ -342,6 +307,8 @@ static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
 	ldo->desc.owner = THIS_MODULE;
 	ldo->desc.vsel_reg = ldo->base + WM831X_LDO_ON_CONTROL;
 	ldo->desc.vsel_mask = WM831X_LDO1_ON_VSEL_MASK;
+	ldo->desc.enable_reg = WM831X_LDO_ENABLE;
+	ldo->desc.enable_mask = 1 << id;
 
 	config.dev = pdev->dev.parent;
 	config.init_data = pdata->ldo[id];
@@ -547,9 +514,9 @@ static struct regulator_ops wm831x_aldo_ops = {
 	.set_mode = wm831x_aldo_set_mode,
 	.get_status = wm831x_aldo_get_status,
 
-	.is_enabled = wm831x_ldo_is_enabled,
-	.enable = wm831x_ldo_enable,
-	.disable = wm831x_ldo_disable,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
 };
 
 static __devinit int wm831x_aldo_probe(struct platform_device *pdev)
@@ -603,6 +570,8 @@ static __devinit int wm831x_aldo_probe(struct platform_device *pdev)
 	ldo->desc.owner = THIS_MODULE;
 	ldo->desc.vsel_reg = ldo->base + WM831X_LDO_ON_CONTROL;
 	ldo->desc.vsel_mask = WM831X_LDO7_ON_VSEL_MASK;
+	ldo->desc.enable_reg = WM831X_LDO_ENABLE;
+	ldo->desc.enable_mask = 1 << id;
 
 	config.dev = pdev->dev.parent;
 	config.init_data = pdata->ldo[id];
@@ -737,9 +706,9 @@ static struct regulator_ops wm831x_alive_ldo_ops = {
 	.set_suspend_voltage = wm831x_alive_ldo_set_suspend_voltage,
 	.get_status = wm831x_alive_ldo_get_status,
 
-	.is_enabled = wm831x_ldo_is_enabled,
-	.enable = wm831x_ldo_enable,
-	.disable = wm831x_ldo_disable,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
 };
 
 static __devinit int wm831x_alive_ldo_probe(struct platform_device *pdev)
@@ -794,6 +763,8 @@ static __devinit int wm831x_alive_ldo_probe(struct platform_device *pdev)
 	ldo->desc.owner = THIS_MODULE;
 	ldo->desc.vsel_reg = ldo->base + WM831X_ALIVE_LDO_ON_CONTROL;
 	ldo->desc.vsel_mask = WM831X_LDO11_ON_VSEL_MASK;
+	ldo->desc.enable_reg = WM831X_LDO_ENABLE;
+	ldo->desc.enable_mask = 1 << id;
 
 	config.dev = pdev->dev.parent;
 	config.init_data = pdata->ldo[id];
-- 
1.7.9.1

