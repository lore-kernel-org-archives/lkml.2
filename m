Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309Ab2EIXsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:48:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56970 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761271Ab2EIXrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:47:55 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Yadwinder Singh <yadi.brar@samsung.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/6] regulator: wm831x: Convert to regulator_list_voltage_linear()
Date: Thu, 10 May 2012 00:47:31 +0100
Message-Id: <1336607255-4967-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336607255-4967-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336607255-4967-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only the alive LDOs can actually use this as all the other regulators have
two linear ranges.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-ldo.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 5bf793d..74ee686 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -630,15 +630,6 @@ static struct platform_driver wm831x_aldo_driver = {
 
 #define WM831X_ALIVE_LDO_MAX_SELECTOR 0xf
 
-static int wm831x_alive_ldo_list_voltage(struct regulator_dev *rdev,
-				      unsigned int selector)
-{
-	/* 0.8-1.55V in 50mV steps */
-	if (selector <= WM831X_ALIVE_LDO_MAX_SELECTOR)
-		return 800000 + (selector * 50000);
-	return -EINVAL;
-}
-
 static int wm831x_alive_ldo_set_voltage_int(struct regulator_dev *rdev,
 					    int reg,
 					    int min_uV, int max_uV,
@@ -650,7 +641,7 @@ static int wm831x_alive_ldo_set_voltage_int(struct regulator_dev *rdev,
 
 	vsel = (min_uV - 800000) / 50000;
 
-	ret = wm831x_alive_ldo_list_voltage(rdev, vsel);
+	ret = regulator_list_voltage_linear(rdev, vsel);
 	if (ret < 0)
 		return ret;
 	if (ret < min_uV || ret > max_uV)
@@ -700,7 +691,7 @@ static int wm831x_alive_ldo_get_status(struct regulator_dev *rdev)
 }
 
 static struct regulator_ops wm831x_alive_ldo_ops = {
-	.list_voltage = wm831x_alive_ldo_list_voltage,
+	.list_voltage = regulator_list_voltage_linear,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage = wm831x_alive_ldo_set_voltage,
 	.set_suspend_voltage = wm831x_alive_ldo_set_suspend_voltage,
@@ -765,6 +756,8 @@ static __devinit int wm831x_alive_ldo_probe(struct platform_device *pdev)
 	ldo->desc.vsel_mask = WM831X_LDO11_ON_VSEL_MASK;
 	ldo->desc.enable_reg = WM831X_LDO_ENABLE;
 	ldo->desc.enable_mask = 1 << id;
+	ldo->desc.min_uV = 800000;
+	ldo->desc.uV_step = 50000;
 
 	config.dev = pdev->dev.parent;
 	config.init_data = pdata->ldo[id];
-- 
1.7.10

