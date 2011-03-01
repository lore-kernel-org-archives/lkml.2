Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab1CAQuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:50:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54419 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751773Ab1CAQuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:50:24 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Convert WM831x regulators to genirq
Date: Tue,  1 Mar 2011 16:50:43 +0000
Message-Id: <1298998243-12177-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c  |   26 +++++++++++---------------
 drivers/regulator/wm831x-isink.c |    8 +++-----
 drivers/regulator/wm831x-ldo.c   |   17 +++++++----------
 3 files changed, 21 insertions(+), 30 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 06df898..857d741 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -565,9 +565,8 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq_byname(pdev, "UV");
-	ret = wm831x_request_irq(wm831x, irq, wm831x_dcdc_uv_irq,
-				 IRQF_TRIGGER_RISING, dcdc->name,
-				 dcdc);
+	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq,
+				   IRQF_TRIGGER_RISING, dcdc->name, dcdc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
@@ -575,9 +574,8 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq_byname(pdev, "HC");
-	ret = wm831x_request_irq(wm831x, irq, wm831x_dcdc_oc_irq,
-				 IRQF_TRIGGER_RISING, dcdc->name,
-				 dcdc);
+	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_oc_irq,
+				   IRQF_TRIGGER_RISING, dcdc->name, dcdc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request HC IRQ %d: %d\n",
 			irq, ret);
@@ -589,7 +587,7 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 	return 0;
 
 err_uv:
-	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), dcdc);
+	free_irq(platform_get_irq_byname(pdev, "UV"), dcdc);
 err_regulator:
 	regulator_unregister(dcdc->regulator);
 err:
@@ -756,9 +754,8 @@ static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq_byname(pdev, "UV");
-	ret = wm831x_request_irq(wm831x, irq, wm831x_dcdc_uv_irq,
-				 IRQF_TRIGGER_RISING, dcdc->name,
-				 dcdc);
+	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq,
+				   IRQF_TRIGGER_RISING,	dcdc->name, dcdc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
@@ -885,9 +882,9 @@ static __devinit int wm831x_boostp_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq_byname(pdev, "UV");
-	ret = wm831x_request_irq(wm831x, irq, wm831x_dcdc_uv_irq,
-				 IRQF_TRIGGER_RISING, dcdc->name,
-				 dcdc);
+	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq,
+				   IRQF_TRIGGER_RISING, dcdc->name,
+				   dcdc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
@@ -908,11 +905,10 @@ err:
 static __devexit int wm831x_boostp_remove(struct platform_device *pdev)
 {
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
-	struct wm831x *wm831x = dcdc->wm831x;
 
 	platform_set_drvdata(pdev, NULL);
 
-	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), dcdc);
+	free_irq(platform_get_irq_byname(pdev, "UV"), dcdc);
 	regulator_unregister(dcdc->regulator);
 	kfree(dcdc);
 
diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index 6c446cd..01f27c7 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -198,9 +198,8 @@ static __devinit int wm831x_isink_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	ret = wm831x_request_irq(wm831x, irq, wm831x_isink_irq,
-				 IRQF_TRIGGER_RISING, isink->name,
-				 isink);
+	ret = request_threaded_irq(irq, NULL, wm831x_isink_irq,
+				   IRQF_TRIGGER_RISING, isink->name, isink);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request ISINK IRQ %d: %d\n",
 			irq, ret);
@@ -221,11 +220,10 @@ err:
 static __devexit int wm831x_isink_remove(struct platform_device *pdev)
 {
 	struct wm831x_isink *isink = platform_get_drvdata(pdev);
-	struct wm831x *wm831x = isink->wm831x;
 
 	platform_set_drvdata(pdev, NULL);
 
-	wm831x_free_irq(wm831x, platform_get_irq(pdev, 0), isink);
+	free_irq(platform_get_irq(pdev, 0), isink);
 
 	regulator_unregister(isink->regulator);
 	kfree(isink);
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index c94fc5b..2220cf8 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -354,9 +354,9 @@ static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq_byname(pdev, "UV");
-	ret = wm831x_request_irq(wm831x, irq, wm831x_ldo_uv_irq,
-				 IRQF_TRIGGER_RISING, ldo->name,
-				 ldo);
+	ret = request_threaded_irq(irq, NULL, wm831x_ldo_uv_irq,
+				   IRQF_TRIGGER_RISING, ldo->name,
+				   ldo);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
@@ -377,11 +377,10 @@ err:
 static __devexit int wm831x_gp_ldo_remove(struct platform_device *pdev)
 {
 	struct wm831x_ldo *ldo = platform_get_drvdata(pdev);
-	struct wm831x *wm831x = ldo->wm831x;
 
 	platform_set_drvdata(pdev, NULL);
 
-	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), ldo);
+	free_irq(platform_get_irq_byname(pdev, "UV"), ldo);
 	regulator_unregister(ldo->regulator);
 	kfree(ldo);
 
@@ -619,9 +618,8 @@ static __devinit int wm831x_aldo_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq_byname(pdev, "UV");
-	ret = wm831x_request_irq(wm831x, irq, wm831x_ldo_uv_irq,
-				 IRQF_TRIGGER_RISING, ldo->name,
-				 ldo);
+	ret = request_threaded_irq(irq, NULL, wm831x_ldo_uv_irq,
+				   IRQF_TRIGGER_RISING, ldo->name, ldo);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
@@ -642,9 +640,8 @@ err:
 static __devexit int wm831x_aldo_remove(struct platform_device *pdev)
 {
 	struct wm831x_ldo *ldo = platform_get_drvdata(pdev);
-	struct wm831x *wm831x = ldo->wm831x;
 
-	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), ldo);
+	free_irq(platform_get_irq_byname(pdev, "UV"), ldo);
 	regulator_unregister(ldo->regulator);
 	kfree(ldo);
 
-- 
1.7.2.3

