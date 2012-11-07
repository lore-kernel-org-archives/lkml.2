Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2KGPOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:14:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63722 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab2KGPOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:14:24 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH] pwm-backlight: Allow any kind of brightness curve
Date: Wed,  7 Nov 2012 16:14:08 +0100
Message-Id: <1352301248-8418-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.7.0.4
X-Provags-ID: V02:K0:mj0rjQFrz4oS4gBABDLYowv71ulI8IClAX8GTniBwAQ
 4VPLoPqge9d0OboPb31EMEfDIpPXpw+128PtoSJtVPvd7iJylm
 u5VLFTkBPt9BfwnOudlY59HvlM/sUo9GasidmoUON+Qaz2c3Mv
 Wc2LsMy4IrOuq6IcRo4GCbRgUV5oExuUFgT7FUISEMZpvMiF1L
 BC85sgbqmefhpA9ibFZLl7CLDGy8gXSg+D91lgYfjAf9mbb0rt
 MLBSbiH61A0hJbG5UU7c56+tTWgp1T1Z0hL0L4cRxy/s0VQmJP
 68BjkPglyQdjBRz7zSda3/bUwLxq220aCjsFQ+WJZl2rS08e8h
 z80l4zZdmkbvJHFKm0cFoWaTbj+ieh+ZFYi7CzWEfjfCwyiixo
 xYLp5vi8vtHz/DIJUUORONYxjNCk8guX2sx+UgiGqURD9SekQk
 0u0cS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The brightness curve assume that the first level always have a duty
cycle of 0% and the last level 100%. However it is desirable to allow
any kind of curve to handle low-active devices, or devices that need
to clamp the curve to some range.

To allow defining any kind of curve the brightness levels are expected
to be in the range from 0 to 255, where 0 is 0% duty and 255 is 100% duty.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 .../bindings/video/backlight/pwm-backlight.txt     |    8 ++---
 drivers/video/backlight/pwm_bl.c                   |   28 +++++++++----------
 include/linux/pwm_backlight.h                      |    2 +
 3 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 1e4fc72..d0ecbd4 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -3,11 +3,9 @@ pwm-backlight bindings
 Required properties:
   - compatible: "pwm-backlight"
   - pwms: OF device-tree PWM specification (see PWM binding[0])
-  - brightness-levels: Array of distinct brightness levels. Typically these
-      are in the range from 0 to 255, but any range starting at 0 will do.
-      The actual brightness level (PWM duty cycle) will be interpolated
-      from these values. 0 means a 0% duty cycle (darkest/off), while the
-      last value in the array represents a 100% duty cycle (brightest).
+  - brightness-levels: Array of distinct brightness levels in the
+      range from 0 to 255. 0 means a 0% duty cycle, while 255
+      represents a 100% duty cycle.
   - default-brightness-level: the default brightness level (index into the
       array defined by the "brightness-levels" property)
 
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 995f016..09ce501 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -40,6 +40,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
 	int brightness = bl->props.brightness;
 	int max = bl->props.max_brightness;
+	int duty_cycle;
 
 	if (bl->props.power != FB_BLANK_UNBLANK)
 		brightness = 0;
@@ -50,24 +51,21 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 	if (pb->notify)
 		brightness = pb->notify(pb->dev, brightness);
 
-	if (brightness == 0) {
-		pwm_config(pb->pwm, 0, pb->period);
-		pwm_disable(pb->pwm);
+	if (pb->levels) {
+		duty_cycle = pb->levels[brightness];
+		max = PWM_BL_MAX_LEVEL;
 	} else {
-		int duty_cycle;
+		duty_cycle = brightness;
+	}
 
-		if (pb->levels) {
-			duty_cycle = pb->levels[brightness];
-			max = pb->levels[max];
-		} else {
-			duty_cycle = brightness;
-		}
+	duty_cycle = pb->lth_brightness +
+		(duty_cycle * (pb->period - pb->lth_brightness) / max);
 
-		duty_cycle = pb->lth_brightness +
-		     (duty_cycle * (pb->period - pb->lth_brightness) / max);
-		pwm_config(pb->pwm, duty_cycle, pb->period);
+	pwm_config(pb->pwm, duty_cycle, pb->period);
+	if (duty_cycle == 0)
+		pwm_disable(pb->pwm);
+	else
 		pwm_enable(pb->pwm);
-	}
 
 	if (pb->notify_after)
 		pb->notify_after(pb->dev, brightness);
@@ -202,7 +200,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	}
 
 	if (data->levels) {
-		max = data->levels[data->max_brightness];
+		max = PWM_BL_MAX_LEVEL;
 		pb->levels = data->levels;
 	} else
 		max = data->max_brightness;
diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
index 56f4a86..f5ed046 100644
--- a/include/linux/pwm_backlight.h
+++ b/include/linux/pwm_backlight.h
@@ -6,6 +6,8 @@
 
 #include <linux/backlight.h>
 
+#define PWM_BL_MAX_LEVEL	255
+
 struct platform_pwm_backlight_data {
 	int pwm_id;
 	unsigned int max_brightness;
-- 
1.7.0.4

