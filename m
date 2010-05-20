Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab0ETP3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 11:29:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60439 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751835Ab0ETP3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 11:29:13 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alessandro Zummo <a.zummo@towertech.it>, akpm@linux-foundation.org
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] rtc: Use genirq directly in rtc-wm831x
Date: Thu, 20 May 2010 08:29:16 -0700
Message-Id: <1274369356-8680-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the WM831x core uses genirq for the IRQ controller there is
no need to use the WM831x-specific wrappers to request interrupts so
convert to use genirq directly.

Also use more meaningful strings to make /proc/interrupts more readily
legible.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/rtc/rtc-wm831x.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-wm831x.c b/drivers/rtc/rtc-wm831x.c
index b16cfe5..82931dc 100644
--- a/drivers/rtc/rtc-wm831x.c
+++ b/drivers/rtc/rtc-wm831x.c
@@ -449,17 +449,17 @@ static int wm831x_rtc_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	ret = wm831x_request_irq(wm831x, per_irq, wm831x_per_irq,
-				 IRQF_TRIGGER_RISING, "wm831x_rtc_per",
-				 wm831x_rtc);
+	ret = request_threaded_irq(per_irq, NULL, wm831x_per_irq,
+				   IRQF_TRIGGER_RISING, "RTC period",
+				   wm831x_rtc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request periodic IRQ %d: %d\n",
 			per_irq, ret);
 	}
 
-	ret = wm831x_request_irq(wm831x, alm_irq, wm831x_alm_irq,
-				 IRQF_TRIGGER_RISING, "wm831x_rtc_alm",
-				 wm831x_rtc);
+	ret = request_threaded_irq(alm_irq, NULL, wm831x_alm_irq,
+				   IRQF_TRIGGER_RISING, "RTC alarm",
+				   wm831x_rtc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request alarm IRQ %d: %d\n",
 			alm_irq, ret);
@@ -478,8 +478,8 @@ static int __devexit wm831x_rtc_remove(struct platform_device *pdev)
 	int per_irq = platform_get_irq_byname(pdev, "PER");
 	int alm_irq = platform_get_irq_byname(pdev, "ALM");
 
-	wm831x_free_irq(wm831x_rtc->wm831x, alm_irq, wm831x_rtc);
-	wm831x_free_irq(wm831x_rtc->wm831x, per_irq, wm831x_rtc);
+	free_irq(alm_irq, wm831x_rtc);
+	free_irq(per_irq, wm831x_rtc);
 	rtc_device_unregister(wm831x_rtc->rtc);
 	kfree(wm831x_rtc);
 
-- 
1.7.1

