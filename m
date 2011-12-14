Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab1LNSYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:24:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54293 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757873Ab1LNSYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:24:14 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] leds: Convert wm8350 driver to devm_kzalloc()
Date: Thu, 15 Dec 2011 02:24:08 +0800
Message-Id: <1323887048-9437-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323887048-9437-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1323887048-9437-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saves a small amount of code and systematically eliminates leaks.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/leds/leds-wm8350.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-wm8350.c b/drivers/leds/leds-wm8350.c
index 390c0f6..918d4ba 100644
--- a/drivers/leds/leds-wm8350.c
+++ b/drivers/leds/leds-wm8350.c
@@ -227,7 +227,7 @@ static int wm8350_led_probe(struct platform_device *pdev)
 		goto err_isink;
 	}
 
-	led = kzalloc(sizeof(*led), GFP_KERNEL);
+	led = devm_kzalloc(&pdev->dev, sizeof(*led), GFP_KERNEL);
 	if (led == NULL) {
 		ret = -ENOMEM;
 		goto err_dcdc;
@@ -259,12 +259,10 @@ static int wm8350_led_probe(struct platform_device *pdev)
 
 	ret = led_classdev_register(&pdev->dev, &led->cdev);
 	if (ret < 0)
-		goto err_led;
+		goto err_dcdc;
 
 	return 0;
 
- err_led:
-	kfree(led);
  err_dcdc:
 	regulator_put(dcdc);
  err_isink:
@@ -281,7 +279,6 @@ static int wm8350_led_remove(struct platform_device *pdev)
 	wm8350_led_disable(led);
 	regulator_put(led->dcdc);
 	regulator_put(led->isink);
-	kfree(led);
 	return 0;
 }
 
-- 
1.7.7.3

