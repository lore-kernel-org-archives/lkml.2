Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab2FLCqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 22:46:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35121 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2FLCqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 22:46:48 -0400
Message-ID: <1339469203.22991.7.camel@phoenix>
Subject: [PATCH RFT] regulator: wm831x-ldo: Convert to
 regulator_set_voltage_sel_regmap and map_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 12 Jun 2012 10:46:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-ldo.c |  129 ++++++++++++----------------------------
 1 file changed, 38 insertions(+), 91 deletions(-)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index f23d020e9..04d8a41 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -78,13 +78,10 @@ static int wm831x_gp_ldo_list_voltage(struct regulator_dev *rdev,
 	return -EINVAL;
 }
 
-static int wm831x_gp_ldo_set_voltage_int(struct regulator_dev *rdev, int reg,
-					 int min_uV, int max_uV,
-					 unsigned *selector)
+static int wm831x_gp_ldo_map_voltage(struct regulator_dev *rdev,
+				     int min_uV, int max_uV)
 {
-	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
-	struct wm831x *wm831x = ldo->wm831x;
-	int vsel, ret;
+	int volt, vsel;
 
 	if (min_uV < 900000)
 		vsel = 0;
@@ -94,36 +91,25 @@ static int wm831x_gp_ldo_set_voltage_int(struct regulator_dev *rdev, int reg,
 		vsel = ((min_uV - 1700000) / 100000)
 			+ WM831X_GP_LDO_SELECTOR_LOW + 1;
 
-	ret = wm831x_gp_ldo_list_voltage(rdev, vsel);
-	if (ret < 0)
-		return ret;
-	if (ret < min_uV || ret > max_uV)
+	volt = wm831x_gp_ldo_list_voltage(rdev, vsel);
+	if (volt < min_uV || volt > max_uV)
 		return -EINVAL;
 
-	*selector = vsel;
-
-	return wm831x_set_bits(wm831x, reg, WM831X_LDO1_ON_VSEL_MASK, vsel);
-}
-
-static int wm831x_gp_ldo_set_voltage(struct regulator_dev *rdev,
-				     int min_uV, int max_uV,
-				     unsigned *selector)
-{
-	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
-	int reg = ldo->base + WM831X_LDO_ON_CONTROL;
-
-	return wm831x_gp_ldo_set_voltage_int(rdev, reg, min_uV, max_uV,
-					     selector);
+	return vsel;
 }
 
 static int wm831x_gp_ldo_set_suspend_voltage(struct regulator_dev *rdev,
 					     int uV)
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
-	int reg = ldo->base + WM831X_LDO_SLEEP_CONTROL;
-	unsigned int selector;
+	struct wm831x *wm831x = ldo->wm831x;
+	int sel, reg = ldo->base + WM831X_LDO_SLEEP_CONTROL;
 
-	return wm831x_gp_ldo_set_voltage_int(rdev, reg, uV, uV, &selector);
+	sel = wm831x_gp_ldo_map_voltage(rdev, uV, uV);
+	if (sel < 0)
+		return sel;
+
+	return wm831x_set_bits(wm831x, reg, WM831X_LDO1_ON_VSEL_MASK, sel);
 }
 
 static unsigned int wm831x_gp_ldo_get_mode(struct regulator_dev *rdev)
@@ -243,8 +229,9 @@ static unsigned int wm831x_gp_ldo_get_optimum_mode(struct regulator_dev *rdev,
 
 static struct regulator_ops wm831x_gp_ldo_ops = {
 	.list_voltage = wm831x_gp_ldo_list_voltage,
+	.map_voltage = wm831x_gp_ldo_map_voltage,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
-	.set_voltage = wm831x_gp_ldo_set_voltage,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.set_suspend_voltage = wm831x_gp_ldo_set_suspend_voltage,
 	.get_mode = wm831x_gp_ldo_get_mode,
 	.set_mode = wm831x_gp_ldo_set_mode,
@@ -384,13 +371,10 @@ static int wm831x_aldo_list_voltage(struct regulator_dev *rdev,
 	return -EINVAL;
 }
 
-static int wm831x_aldo_set_voltage_int(struct regulator_dev *rdev, int reg,
-				       int min_uV, int max_uV,
-				       unsigned *selector)
+static int wm831x_aldo_map_voltage(struct regulator_dev *rdev,
+				   int min_uV, int max_uV)
 {
-	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
-	struct wm831x *wm831x = ldo->wm831x;
-	int vsel, ret;
+	int volt, vsel;
 
 	if (min_uV < 1000000)
 		vsel = 0;
@@ -400,35 +384,26 @@ static int wm831x_aldo_set_voltage_int(struct regulator_dev *rdev, int reg,
 		vsel = ((min_uV - 1700000) / 100000)
 			+ WM831X_ALDO_SELECTOR_LOW + 1;
 
-	ret = wm831x_aldo_list_voltage(rdev, vsel);
-	if (ret < 0)
-		return ret;
-	if (ret < min_uV || ret > max_uV)
+	volt = wm831x_aldo_list_voltage(rdev, vsel);
+	if (volt < min_uV || volt > max_uV)
 		return -EINVAL;
 
-	*selector = vsel;
-
-	return wm831x_set_bits(wm831x, reg, WM831X_LDO7_ON_VSEL_MASK, vsel);
-}
-
-static int wm831x_aldo_set_voltage(struct regulator_dev *rdev,
-				   int min_uV, int max_uV, unsigned *selector)
-{
-	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
-	int reg = ldo->base + WM831X_LDO_ON_CONTROL;
+	return vsel;
 
-	return wm831x_aldo_set_voltage_int(rdev, reg, min_uV, max_uV,
-					   selector);
 }
 
 static int wm831x_aldo_set_suspend_voltage(struct regulator_dev *rdev,
 					     int uV)
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
-	int reg = ldo->base + WM831X_LDO_SLEEP_CONTROL;
-	unsigned int selector;
+	struct wm831x *wm831x = ldo->wm831x;
+	int sel, reg = ldo->base + WM831X_LDO_SLEEP_CONTROL;
+
+	sel = wm831x_aldo_map_voltage(rdev, uV, uV);
+	if (sel < 0)
+		return sel;
 
-	return wm831x_aldo_set_voltage_int(rdev, reg, uV, uV, &selector);
+	return wm831x_set_bits(wm831x, reg, WM831X_LDO7_ON_VSEL_MASK, sel);
 }
 
 static unsigned int wm831x_aldo_get_mode(struct regulator_dev *rdev)
@@ -506,8 +481,9 @@ static int wm831x_aldo_get_status(struct regulator_dev *rdev)
 
 static struct regulator_ops wm831x_aldo_ops = {
 	.list_voltage = wm831x_aldo_list_voltage,
+	.map_voltage = wm831x_aldo_map_voltage,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
-	.set_voltage = wm831x_aldo_set_voltage,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.set_suspend_voltage = wm831x_aldo_set_suspend_voltage,
 	.get_mode = wm831x_aldo_get_mode,
 	.set_mode = wm831x_aldo_set_mode,
@@ -628,47 +604,18 @@ static struct platform_driver wm831x_aldo_driver = {
 
 #define WM831X_ALIVE_LDO_MAX_SELECTOR 0xf
 
-static int wm831x_alive_ldo_set_voltage_int(struct regulator_dev *rdev,
-					    int reg,
-					    int min_uV, int max_uV,
-					    unsigned *selector)
-{
-	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
-	struct wm831x *wm831x = ldo->wm831x;
-	int vsel, ret;
-
-	vsel = (min_uV - 800000) / 50000;
-
-	ret = regulator_list_voltage_linear(rdev, vsel);
-	if (ret < 0)
-		return ret;
-	if (ret < min_uV || ret > max_uV)
-		return -EINVAL;
-
-	*selector = vsel;
-
-	return wm831x_set_bits(wm831x, reg, WM831X_LDO11_ON_VSEL_MASK, vsel);
-}
-
-static int wm831x_alive_ldo_set_voltage(struct regulator_dev *rdev,
-					int min_uV, int max_uV,
-					unsigned *selector)
-{
-	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
-	int reg = ldo->base + WM831X_ALIVE_LDO_ON_CONTROL;
-
-	return wm831x_alive_ldo_set_voltage_int(rdev, reg, min_uV, max_uV,
-						selector);
-}
-
 static int wm831x_alive_ldo_set_suspend_voltage(struct regulator_dev *rdev,
 					     int uV)
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
-	int reg = ldo->base + WM831X_ALIVE_LDO_SLEEP_CONTROL;
-	unsigned selector;
+	struct wm831x *wm831x = ldo->wm831x;
+	int sel, reg = ldo->base + WM831X_ALIVE_LDO_SLEEP_CONTROL;
+
+	sel = regulator_map_voltage_linear(rdev, uV, uV);
+	if (sel < 0)
+		return sel;
 
-	return wm831x_alive_ldo_set_voltage_int(rdev, reg, uV, uV, &selector);
+	return wm831x_set_bits(wm831x, reg, WM831X_LDO11_ON_VSEL_MASK, sel);
 }
 
 static int wm831x_alive_ldo_get_status(struct regulator_dev *rdev)
@@ -692,7 +639,7 @@ static struct regulator_ops wm831x_alive_ldo_ops = {
 	.list_voltage = regulator_list_voltage_linear,
 	.map_voltage = regulator_map_voltage_linear,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
-	.set_voltage = wm831x_alive_ldo_set_voltage,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.set_suspend_voltage = wm831x_alive_ldo_set_suspend_voltage,
 	.get_status = wm831x_alive_ldo_get_status,
 
-- 
1.7.9.5



