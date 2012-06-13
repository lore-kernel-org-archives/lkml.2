Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2FMM3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:29:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47268 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab2FMM3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:29:23 -0400
Message-ID: <1339590557.9672.3.camel@phoenix>
Subject: [PATCH v2 3/3] regulator: wm831x-dcdc: Convert wm831x_buckv_ops to
 set_voltage_sel and map_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 13 Jun 2012 20:29:17 +0800
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
 drivers/regulator/wm831x-dcdc.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 91b5b0a..7413885 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -215,8 +215,8 @@ static int wm831x_buckv_list_voltage(struct regulator_dev *rdev,
 	return -EINVAL;
 }
 
-static int wm831x_buckv_select_min_voltage(struct regulator_dev *rdev,
-					   int min_uV, int max_uV)
+static int wm831x_buckv_map_voltage(struct regulator_dev *rdev,
+				   int min_uV, int max_uV)
 {
 	u16 vsel;
 
@@ -251,20 +251,14 @@ static int wm831x_buckv_set_dvs(struct regulator_dev *rdev, int state)
 	return 0;
 }
 
-static int wm831x_buckv_set_voltage(struct regulator_dev *rdev,
-				    int min_uV, int max_uV, unsigned *selector)
+static int wm831x_buckv_set_voltage_sel(struct regulator_dev *rdev,
+					unsigned vsel)
 {
 	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
 	struct wm831x *wm831x = dcdc->wm831x;
 	int on_reg = dcdc->base + WM831X_DCDC_ON_CONFIG;
 	int dvs_reg = dcdc->base + WM831X_DCDC_DVS_CONTROL;
-	int vsel, ret;
-
-	vsel = wm831x_buckv_select_min_voltage(rdev, min_uV, max_uV);
-	if (vsel < 0)
-		return vsel;
-
-	*selector = vsel;
+	int ret;
 
 	/* If this value is already set then do a GPIO update if we can */
 	if (dcdc->dvs_gpio && dcdc->on_vsel == vsel)
@@ -315,7 +309,7 @@ static int wm831x_buckv_set_suspend_voltage(struct regulator_dev *rdev,
 	u16 reg = dcdc->base + WM831X_DCDC_SLEEP_CONTROL;
 	int vsel;
 
-	vsel = wm831x_buckv_select_min_voltage(rdev, uV, uV);
+	vsel = wm831x_buckv_map_voltage(rdev, uV, uV);
 	if (vsel < 0)
 		return vsel;
 
@@ -373,9 +367,10 @@ static int wm831x_buckv_get_current_limit(struct regulator_dev *rdev)
 }
 
 static struct regulator_ops wm831x_buckv_ops = {
-	.set_voltage = wm831x_buckv_set_voltage,
+	.set_voltage_sel = wm831x_buckv_set_voltage_sel,
 	.get_voltage_sel = wm831x_buckv_get_voltage_sel,
 	.list_voltage = wm831x_buckv_list_voltage,
+	.map_voltage = wm831x_buckv_map_voltage,
 	.set_suspend_voltage = wm831x_buckv_set_suspend_voltage,
 	.set_current_limit = wm831x_buckv_set_current_limit,
 	.get_current_limit = wm831x_buckv_get_current_limit,
-- 
1.7.9.5



