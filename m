Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab2KGLnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 06:43:10 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54402 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab2KGLnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 06:43:07 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
CC: Luotao Fu <l.fu@pengutronix.de>, <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds: leds-pwm: Convert to use devm_get_pwm
Date: Wed, 7 Nov 2012 12:42:50 +0100
Message-ID: <1352288570-32565-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
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
 drivers/leds/leds-pwm.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index f2e44c7..6bf9445 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -47,6 +47,19 @@ static void led_pwm_set(struct led_classdev *led_cdev,
 	}
 }
 
+static struct pwm_device *led_pwm_request_pwm(struct platform_device *pdev,
+					      struct led_pwm *cur_led)
+{
+	struct pwm_device *pwm;
+
+	pwm = devm_pwm_get(&pdev->dev, cur_led->name);
+	if (IS_ERR(pwm)) {
+		dev_err(&pdev->dev, "unable to request PWM, trying legacy API\n");
+		pwm = pwm_request(cur_led->pwm_id, cur_led->name);
+	}
+	return pwm;
+}
+
 static int led_pwm_probe(struct platform_device *pdev)
 {
 	struct led_pwm_platform_data *pdata = pdev->dev.platform_data;
@@ -67,8 +80,7 @@ static int led_pwm_probe(struct platform_device *pdev)
 		cur_led = &pdata->leds[i];
 		led_dat = &leds_data[i];
 
-		led_dat->pwm = pwm_request(cur_led->pwm_id,
-				cur_led->name);
+		led_dat->pwm = led_pwm_request_pwm(pdev, cur_led);
 		if (IS_ERR(led_dat->pwm)) {
 			ret = PTR_ERR(led_dat->pwm);
 			dev_err(&pdev->dev, "unable to request PWM %d\n",
-- 
1.8.0

