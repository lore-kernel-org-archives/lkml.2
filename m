Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab1GYVUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:20:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34669 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752617Ab1GYVUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:20:41 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 6/6] regulator: Improve WM831x DVS VSEL selection algorithm
Date: Mon, 25 Jul 2011 22:20:34 +0100
Message-Id: <1311628834-31939-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311628834-31939-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1311628834-31939-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than using the maximum voltage we get passed to select the DVS
voltage to use remember the highest voltage we've ever seen. This improves
how the driver works when the consumer permits higher voltages than it
will ever selects in order to support the widest possible voltage range.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c |   52 +++++++++++---------------------------
 1 files changed, 15 insertions(+), 37 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 2c5d54b..bd3531d 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -267,23 +267,6 @@ static int wm831x_buckv_select_min_voltage(struct regulator_dev *rdev,
 	return vsel;
 }
 
-static int wm831x_buckv_select_max_voltage(struct regulator_dev *rdev,
-					   int min_uV, int max_uV)
-{
-	u16 vsel;
-
-	if (max_uV < 600000 || max_uV > 1800000)
-		return -EINVAL;
-
-	vsel = ((max_uV - 600000) / 12500) + 8;
-
-	if (wm831x_buckv_list_voltage(rdev, vsel) < min_uV ||
-	    wm831x_buckv_list_voltage(rdev, vsel) < max_uV)
-		return -EINVAL;
-
-	return vsel;
-}
-
 static int wm831x_buckv_set_dvs(struct regulator_dev *rdev, int state)
 {
 	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
@@ -338,28 +321,23 @@ static int wm831x_buckv_set_voltage(struct regulator_dev *rdev,
 	if (ret < 0)
 		return ret;
 
-	/* Set the high voltage as the DVS voltage.  This is optimised
-	 * for CPUfreq usage, most processors will keep the maximum
-	 * voltage constant and lower the minimum with the frequency. */
-	vsel = wm831x_buckv_select_max_voltage(rdev, min_uV, max_uV);
-	if (vsel < 0) {
-		/* This should never happen - at worst the same vsel
-		 * should be chosen */
-		WARN_ON(vsel < 0);
-		return 0;
+	/*
+	 * If this VSEL is higher than the last one we've seen then
+	 * remember it as the DVS VSEL.  This is optimised for CPUfreq
+	 * usage where we want to get to the highest voltage very
+	 * quickly.
+	 */
+	if (vsel > dcdc->dvs_vsel) {
+		ret = wm831x_set_bits(wm831x, dvs_reg,
+				      WM831X_DC1_DVS_VSEL_MASK,
+				      dcdc->dvs_vsel);
+		if (ret == 0)
+			dcdc->dvs_vsel = vsel;
+		else
+			dev_warn(wm831x->dev,
+				 "Failed to set DCDC DVS VSEL: %d\n", ret);
 	}
 
-	/* Don't bother if it's the same VSEL we're already using */
-	if (vsel == dcdc->on_vsel)
-		return 0;
-
-	ret = wm831x_set_bits(wm831x, dvs_reg, WM831X_DC1_DVS_VSEL_MASK, vsel);
-	if (ret == 0)
-		dcdc->dvs_vsel = vsel;
-	else
-		dev_warn(wm831x->dev, "Failed to set DCDC DVS VSEL: %d\n",
-			 ret);
-
 	return 0;
 }
 
-- 
1.7.5.4

