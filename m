Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab2GIGC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:02:59 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10925 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab2GIGCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:02:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 08 Jul 2012 22:58:55 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCHv3] pwm_backlight: pass correct brightness to callback
Date: Mon, 9 Jul 2012 15:04:23 +0900
Message-ID: <1341813863-18822-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <4FFA6BCA.2040101@nvidia.com>
References: <4FFA6BCA.2040101@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pwm_backlight_update_status calls the notify() and notify_after()
callbacks before and after applying the new PWM settings. However, if
brightness levels are used, the brightness value will be changed from
the index into the levels array to the PWM duty cycle length before
being passed to notify_after(), which results in inconsistent behavior.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/video/backlight/pwm_bl.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 057389d..be48517 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -54,14 +54,17 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 		pwm_config(pb->pwm, 0, pb->period);
 		pwm_disable(pb->pwm);
 	} else {
+		int duty_cycle;
 		if (pb->levels) {
-			brightness = pb->levels[brightness];
+			duty_cycle = pb->levels[brightness];
 			max = pb->levels[max];
+		} else {
+			duty_cycle = brightness;
 		}
 
-		brightness = pb->lth_brightness +
-			(brightness * (pb->period - pb->lth_brightness) / max);
-		pwm_config(pb->pwm, brightness, pb->period);
+		duty_cycle = pb->lth_brightness +
+		     (duty_cycle * (pb->period - pb->lth_brightness) / max);
+		pwm_config(pb->pwm, duty_cycle, pb->period);
 		pwm_enable(pb->pwm);
 	}
 
-- 
1.7.11.1

