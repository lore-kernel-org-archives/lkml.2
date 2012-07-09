Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165Ab2GIEUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 00:20:01 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5227 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2GIET7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 00:19:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 08 Jul 2012 21:19:59 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] pwm_backlight: pass correct brightness to callback
Date: Mon, 9 Jul 2012 13:21:40 +0900
Message-ID: <1341807700-7103-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.11.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pwm_backlight_update_status calls two callbacks before and after
applying the new PWM settings. However, the brightness scale is
completely changed in between if brightness levels are used. This patch
ensures that both callbacks are passed brightness values of the same
meaning.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/video/backlight/pwm_bl.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 057389d..dd4d24d 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -39,6 +39,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 {
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
 	int brightness = bl->props.brightness;
+	int pwm_brightness;
 	int max = bl->props.max_brightness;
 
 	if (bl->props.power != FB_BLANK_UNBLANK)
@@ -55,13 +56,14 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 		pwm_disable(pb->pwm);
 	} else {
 		if (pb->levels) {
-			brightness = pb->levels[brightness];
+			pwm_brightness = pb->levels[brightness];
 			max = pb->levels[max];
-		}
+		} else
+			pwm_brightness = brightness;
 
-		brightness = pb->lth_brightness +
-			(brightness * (pb->period - pb->lth_brightness) / max);
-		pwm_config(pb->pwm, brightness, pb->period);
+		pwm_brightness = pb->lth_brightness +
+		     (pwm_brightness * (pb->period - pb->lth_brightness) / max);
+		pwm_config(pb->pwm, pwm_brightness, pb->period);
 		pwm_enable(pb->pwm);
 	}
 
-- 
1.7.11.1

