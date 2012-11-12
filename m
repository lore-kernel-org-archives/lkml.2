Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab2KLOlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:41:35 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42980 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2KLOlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:41:32 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
CC: <linux-leds@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH v2 1/3] leds: leds-pwm: Convert to use devm_get_pwm
Date: Mon, 12 Nov 2012 15:41:08 +0100
Message-ID: <1352731270-27534-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352731270-27534-1-git-send-email-peter.ujfalusi@ti.com>
References: <1352731270-27534-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the driver to use the new API for requesting pwm so we can take
advantage of the pwm_lookup table to find the correct pwm to be used for the
LED functionality.
If the devm_get_pwm fails we fall back to legacy mode to try to get the pwm.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/leds/leds-pwm.c  | 19 ++++++-------------
 include/linux/leds_pwm.h |  2 +-
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index f2e44c7..c953c75 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -67,12 +67,11 @@ static int led_pwm_probe(struct platform_device *pdev)
 		cur_led = &pdata->leds[i];
 		led_dat = &leds_data[i];
 
-		led_dat->pwm = pwm_request(cur_led->pwm_id,
-				cur_led->name);
+		led_dat->pwm = devm_pwm_get(&pdev->dev, cur_led->name);
 		if (IS_ERR(led_dat->pwm)) {
 			ret = PTR_ERR(led_dat->pwm);
-			dev_err(&pdev->dev, "unable to request PWM %d\n",
-					cur_led->pwm_id);
+			dev_err(&pdev->dev, "unable to request PWM for %s\n",
+				cur_led->name);
 			goto err;
 		}
 
@@ -86,10 +85,8 @@ static int led_pwm_probe(struct platform_device *pdev)
 		led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
 
 		ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
-		if (ret < 0) {
-			pwm_free(led_dat->pwm);
+		if (ret < 0)
 			goto err;
-		}
 	}
 
 	platform_set_drvdata(pdev, leds_data);
@@ -98,10 +95,8 @@ static int led_pwm_probe(struct platform_device *pdev)
 
 err:
 	if (i > 0) {
-		for (i = i - 1; i >= 0; i--) {
+		for (i = i - 1; i >= 0; i--)
 			led_classdev_unregister(&leds_data[i].cdev);
-			pwm_free(leds_data[i].pwm);
-		}
 	}
 
 	return ret;
@@ -115,10 +110,8 @@ static int __devexit led_pwm_remove(struct platform_device *pdev)
 
 	leds_data = platform_get_drvdata(pdev);
 
-	for (i = 0; i < pdata->num_leds; i++) {
+	for (i = 0; i < pdata->num_leds; i++)
 		led_classdev_unregister(&leds_data[i].cdev);
-		pwm_free(leds_data[i].pwm);
-	}
 
 	return 0;
 }
diff --git a/include/linux/leds_pwm.h b/include/linux/leds_pwm.h
index 33a0711..a65e964 100644
--- a/include/linux/leds_pwm.h
+++ b/include/linux/leds_pwm.h
@@ -7,7 +7,7 @@
 struct led_pwm {
 	const char	*name;
 	const char	*default_trigger;
-	unsigned	pwm_id;
+	unsigned	pwm_id __deprecated;
 	u8 		active_low;
 	unsigned 	max_brightness;
 	unsigned	pwm_period_ns;
-- 
1.8.0

