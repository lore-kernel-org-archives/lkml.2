Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2FLCYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 22:24:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59367 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab2FLCYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 22:24:15 -0400
Message-ID: <1339467849.22991.5.camel@phoenix>
Subject: [PATCH RFT 4/4] regulator: wm831x-dcdc: Convert to
 devm_request_threaded_irq
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 12 Jun 2012 10:24:09 +0800
In-Reply-To: <1339467650.22991.1.camel@phoenix>
References: <1339467650.22991.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-dcdc.c |   35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index eea53e1..5ec10d7 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -532,8 +532,9 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 	}
 
 	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
-	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq,
-				   IRQF_TRIGGER_RISING, dcdc->name, dcdc);
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					wm831x_dcdc_uv_irq, IRQF_TRIGGER_RISING,
+					dcdc->name, dcdc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
@@ -541,8 +542,9 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 	}
 
 	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "HC"));
-	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_oc_irq,
-				   IRQF_TRIGGER_RISING, dcdc->name, dcdc);
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					wm831x_dcdc_oc_irq, IRQF_TRIGGER_RISING,
+					dcdc->name, dcdc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request HC IRQ %d: %d\n",
 			irq, ret);
@@ -554,8 +556,6 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 	return 0;
 
 err_uv:
-	free_irq(wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV")),
-		 dcdc);
 err_regulator:
 	regulator_unregister(dcdc->regulator);
 err:
@@ -567,14 +567,8 @@ err:
 static __devexit int wm831x_buckv_remove(struct platform_device *pdev)
 {
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
-	struct wm831x *wm831x = dcdc->wm831x;
 
 	platform_set_drvdata(pdev, NULL);
-
-	free_irq(wm831x_irq(wm831x, platform_get_irq_byname(pdev, "HC")),
-			    dcdc);
-	free_irq(wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV")),
-			    dcdc);
 	regulator_unregister(dcdc->regulator);
 	if (dcdc->dvs_gpio)
 		gpio_free(dcdc->dvs_gpio);
@@ -694,8 +688,9 @@ static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
 	}
 
 	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
-	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq,
-				   IRQF_TRIGGER_RISING,	dcdc->name, dcdc);
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					wm831x_dcdc_uv_irq, IRQF_TRIGGER_RISING,
+					dcdc->name, dcdc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
@@ -717,9 +712,6 @@ static __devexit int wm831x_buckp_remove(struct platform_device *pdev)
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
 
 	platform_set_drvdata(pdev, NULL);
-
-	free_irq(wm831x_irq(dcdc->wm831x, platform_get_irq_byname(pdev, "UV")),
-			    dcdc);
 	regulator_unregister(dcdc->regulator);
 
 	return 0;
@@ -828,9 +820,9 @@ static __devinit int wm831x_boostp_probe(struct platform_device *pdev)
 	}
 
 	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
-	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq,
-				   IRQF_TRIGGER_RISING, dcdc->name,
-				   dcdc);
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					wm831x_dcdc_uv_irq, IRQF_TRIGGER_RISING,
+					dcdc->name, dcdc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
@@ -852,9 +844,6 @@ static __devexit int wm831x_boostp_remove(struct platform_device *pdev)
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
 
 	platform_set_drvdata(pdev, NULL);
-
-	free_irq(wm831x_irq(dcdc->wm831x, platform_get_irq_byname(pdev, "UV")),
-		 dcdc);
 	regulator_unregister(dcdc->regulator);
 
 	return 0;
-- 
1.7.9.5



