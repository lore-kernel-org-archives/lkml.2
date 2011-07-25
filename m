Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab1GYVUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:20:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34672 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752455Ab1GYVUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:20:42 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/6] regulator: Set up GPIO for WM831x VSEL before enabling VSEL mode
Date: Mon, 25 Jul 2011 22:20:32 +0100
Message-Id: <1311628834-31939-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311628834-31939-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1311628834-31939-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the VSEL is not in use prior to us starting up then we need to make
sure we initialise the GPIO before we push the DVS control to being done
by the GPIO.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c |   41 +++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 2ee4823..95249f7 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -456,27 +456,6 @@ static __devinit void wm831x_buckv_dvs_init(struct wm831x_dcdc *dcdc,
 	if (!pdata || !pdata->dvs_gpio)
 		return;
 
-	switch (pdata->dvs_control_src) {
-	case 1:
-		ctrl = 2 << WM831X_DC1_DVS_SRC_SHIFT;
-		break;
-	case 2:
-		ctrl = 3 << WM831X_DC1_DVS_SRC_SHIFT;
-		break;
-	default:
-		dev_err(wm831x->dev, "Invalid DVS control source %d for %s\n",
-			pdata->dvs_control_src, dcdc->name);
-		return;
-	}
-
-	ret = wm831x_set_bits(wm831x, dcdc->base + WM831X_DCDC_DVS_CONTROL,
-			      WM831X_DC1_DVS_SRC_MASK, ctrl);
-	if (ret < 0) {
-		dev_err(wm831x->dev, "Failed to set %s DVS source: %d\n",
-			dcdc->name, ret);
-		return;
-	}
-
 	ret = gpio_request(pdata->dvs_gpio, "DCDC DVS");
 	if (ret < 0) {
 		dev_err(wm831x->dev, "Failed to get %s DVS GPIO: %d\n",
@@ -498,6 +477,26 @@ static __devinit void wm831x_buckv_dvs_init(struct wm831x_dcdc *dcdc,
 	}
 
 	dcdc->dvs_gpio = pdata->dvs_gpio;
+
+	switch (pdata->dvs_control_src) {
+	case 1:
+		ctrl = 2 << WM831X_DC1_DVS_SRC_SHIFT;
+		break;
+	case 2:
+		ctrl = 3 << WM831X_DC1_DVS_SRC_SHIFT;
+		break;
+	default:
+		dev_err(wm831x->dev, "Invalid DVS control source %d for %s\n",
+			pdata->dvs_control_src, dcdc->name);
+		return;
+	}
+
+	ret = wm831x_set_bits(wm831x, dcdc->base + WM831X_DCDC_DVS_CONTROL,
+			      WM831X_DC1_DVS_SRC_MASK, ctrl);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Failed to set %s DVS source: %d\n",
+			dcdc->name, ret);
+	}
 }
 
 static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
-- 
1.7.5.4

