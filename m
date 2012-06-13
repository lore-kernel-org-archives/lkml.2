Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2FMM2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:28:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39422 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab2FMM2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:28:05 -0400
Message-ID: <1339590478.9672.2.camel@phoenix>
Subject: [PATCH RESEND 2/3] regulator: wm831x-dcdc: Convert wm831x_buckp_ops
 to regulator_set_voltage_sel_regmap
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 13 Jun 2012 20:27:58 +0800
In-Reply-To: <1339590434.9672.1.camel@phoenix>
References: <1339590434.9672.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-dcdc.c |   44 ++++++++-------------------------------
 1 file changed, 9 insertions(+), 35 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index fbcff56..91b5b0a 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -599,51 +599,25 @@ static struct platform_driver wm831x_buckv_driver = {
  * BUCKP specifics
  */
 
-static int wm831x_buckp_set_voltage_int(struct regulator_dev *rdev, int reg,
-					int min_uV, int max_uV, int *selector)
+static int wm831x_buckp_set_suspend_voltage(struct regulator_dev *rdev, int uV)
 {
 	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
 	struct wm831x *wm831x = dcdc->wm831x;
-	u16 vsel;
-
-	if (min_uV <= 34000000)
-		vsel = (min_uV - 850000) / 25000;
-	else
-		return -EINVAL;
-
-	if (regulator_list_voltage_linear(rdev, vsel) > max_uV)
-		return -EINVAL;
-
-	*selector = vsel;
-
-	return wm831x_set_bits(wm831x, reg, WM831X_DC3_ON_VSEL_MASK, vsel);
-}
-
-static int wm831x_buckp_set_voltage(struct regulator_dev *rdev,
-				    int min_uV, int max_uV,
-				    unsigned *selector)
-{
-	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
-	u16 reg = dcdc->base + WM831X_DCDC_ON_CONFIG;
-
-	return wm831x_buckp_set_voltage_int(rdev, reg, min_uV, max_uV,
-					    selector);
-}
-
-static int wm831x_buckp_set_suspend_voltage(struct regulator_dev *rdev,
-					    int uV)
-{
-	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
 	u16 reg = dcdc->base + WM831X_DCDC_SLEEP_CONTROL;
-	unsigned selector;
+	int sel;
+
+	sel = regulator_map_voltage_linear(rdev, uV, uV);
+	if (sel < 0)
+		return sel;
 
-	return wm831x_buckp_set_voltage_int(rdev, reg, uV, uV, &selector);
+	return wm831x_set_bits(wm831x, reg, WM831X_DC3_ON_VSEL_MASK, sel);
 }
 
 static struct regulator_ops wm831x_buckp_ops = {
-	.set_voltage = wm831x_buckp_set_voltage,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
 	.set_suspend_voltage = wm831x_buckp_set_suspend_voltage,
 
 	.is_enabled = regulator_is_enabled_regmap,
-- 
1.7.9.5



