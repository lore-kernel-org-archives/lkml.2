Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab2KEPtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:49:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60037 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2KEPtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:49:07 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH] pwm-backlight: Add support for active low PWM backlights
Date: Mon,  5 Nov 2012 16:49:01 +0100
Message-Id: <1352130541-16819-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.7.0.4
X-Provags-ID: V02:K0:i8f0G7kyMkfqPep9uENVEc+ZsU70vQwE9anxMiLhyUd
 dmXLPFikrsV8RPLQWn4YL5COeqwxNM/YUUDJQvtQGQn4J+TKLs
 RsRGRKkh6esM7q8NOcyCJDMJo+/ZhU3NlfgKpQrF42ZcydJjso
 STZ45zytB2vd/SEtlledbMFOWn6b+fAv4XffB5PZOP1N089ozH
 /9KBzBlRho8qoG46ML17MEGkUg0+ifVMm7VnM22GzSC2n1JI/U
 iYSE0pBVuFWN4oVlDay+EVZvCr6+VQeSiUF4xgDrieuuBD7EfJ
 VR4Fs+R6SnIBBr1cRJLn/Wb3I/TewyzcPD7m2ud0D18eeyAltu
 zU31qCdi55Hwci644i386OEg7bLbsyosb1k00g+q03LumUky45
 6zFtj0yqWO6bTzINIGhFSwyV896AXfYHlKm5wk5HsLU1nXLm0I
 ixY4s
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 .../bindings/video/backlight/pwm-backlight.txt     |    1 +
 drivers/video/backlight/pwm_bl.c                   |   22 ++++++++++++++-----
 include/linux/pwm_backlight.h                      |    1 +
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 1e4fc72..3a40539 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -14,6 +14,7 @@ Required properties:
 Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
                "pwms" property (see PWM binding[0])
+  - active-low: boolean indicating that the backlight use active low logic
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
 
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 995f016..109c703 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -25,6 +25,7 @@ struct pwm_bl_data {
 	struct pwm_device	*pwm;
 	struct device		*dev;
 	unsigned int		period;
+	unsigned int		active_low;
 	unsigned int		lth_brightness;
 	unsigned int		*levels;
 	int			(*notify)(struct device *,
@@ -40,6 +41,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
 	int brightness = bl->props.brightness;
 	int max = bl->props.max_brightness;
+	int duty_cycle;
 
 	if (bl->props.power != FB_BLANK_UNBLANK)
 		brightness = 0;
@@ -51,11 +53,8 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 		brightness = pb->notify(pb->dev, brightness);
 
 	if (brightness == 0) {
-		pwm_config(pb->pwm, 0, pb->period);
-		pwm_disable(pb->pwm);
+		duty_cycle = 0;
 	} else {
-		int duty_cycle;
-
 		if (pb->levels) {
 			duty_cycle = pb->levels[brightness];
 			max = pb->levels[max];
@@ -65,10 +64,17 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 
 		duty_cycle = pb->lth_brightness +
 		     (duty_cycle * (pb->period - pb->lth_brightness) / max);
-		pwm_config(pb->pwm, duty_cycle, pb->period);
-		pwm_enable(pb->pwm);
 	}
 
+	if (pb->active_low)
+		duty_cycle = pb->period - duty_cycle;
+
+	pwm_config(pb->pwm, duty_cycle, pb->period);
+	if (duty_cycle == 0)
+		pwm_disable(pb->pwm);
+	else
+		pwm_enable(pb->pwm);
+
 	if (pb->notify_after)
 		pb->notify_after(pb->dev, brightness);
 
@@ -145,6 +151,9 @@ static int pwm_backlight_parse_dt(struct device *dev,
 		data->max_brightness--;
 	}
 
+	/* Is the backlight low active? */
+	data->active_low = of_property_read_bool(node, "active-low");
+
 	/*
 	 * TODO: Most users of this driver use a number of GPIOs to control
 	 *       backlight power. Support for specifying these needs to be
@@ -237,6 +246,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 
 	pb->period = pwm_get_period(pb->pwm);
 	pb->lth_brightness = data->lth_brightness * (pb->period / max);
+	pb->active_low = data->active_low;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
index 56f4a86..52b19d9 100644
--- a/include/linux/pwm_backlight.h
+++ b/include/linux/pwm_backlight.h
@@ -12,6 +12,7 @@ struct platform_pwm_backlight_data {
 	unsigned int dft_brightness;
 	unsigned int lth_brightness;
 	unsigned int pwm_period_ns;
+	unsigned int active_low;
 	unsigned int *levels;
 	int (*init)(struct device *dev);
 	int (*notify)(struct device *dev, int brightness);
-- 
1.7.0.4

