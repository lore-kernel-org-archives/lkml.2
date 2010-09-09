Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0IILa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:30:26 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:39431 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955Ab0IILaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:30:23 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <rpurdie@rpsys.net>, <linux@simtec.co.uk>, <ben@simtec.co.uk>,
        <tj@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <STEricsson_nomadik_linux@list.st.com>,
        <arun.murthy@stericsson.com>
Subject: [PATCH] backlight: add low threshold to pwm backlight
Date: Thu, 9 Sep 2010 16:59:32 +0530
Message-ID: <1284031772-3496-1-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intensity of the backlight can be varied from a range of
max_brightness to zero. Though most, if not all the pwm based backlight
devices start flickering at lower brightness value. And also for each
device there exists a brightness value below which the backlight appears
to be turned off though the value is not equal to zero.

If the range of brightness for a device is from zero to
max_brightness. A graph is plotted for brightness Vs intensity fo the
pwm based backlight device has to be a linear graph.

intensity
	  |   /
	  |  /
	  | /
	  |/
	  ---------
	 0	max_brightness
But pratically on measuring the above we note that the intensity of
backlight goes to zero(OFF) when the value in not zero almost nearing to
zero(some x%). so the graph looks like

intensity
	  |    /
	  |   /
	  |  /
	  |  |
	  ------------
	 0   x	 max_brightness

In order to overcome this drawback knowing this x% i.e nothing but the
low threshold beyond which the backlight is off and will have no effect,
the brightness value is being offset by the low threshold
value(retaining the linearity of the graph). Now the graph becomes

intensity
	  |     /
	  |    /
	  |   /
	  |  /
	  -------------
	   0	  max_brightness
With this for each and every digit increment in the brightness from zero
there is a change in the intensity of backlight.
Devices having this behaviour can set the low threshold
brightness(lth_brightness) and pass the same as platform data else can
have it as zero.

Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/video/backlight/pwm_bl.c |    7 ++++++-
 include/linux/pwm_backlight.h    |    1 +
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 5504435..1f958ce 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -25,6 +25,7 @@ struct pwm_bl_data {
 	struct pwm_device	*pwm;
 	struct device		*dev;
 	unsigned int		period;
+	unsigned int		lth_brightness;
 	int			(*notify)(struct device *,
 					  int brightness);
 };
@@ -48,7 +49,9 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 		pwm_config(pb->pwm, 0, pb->period);
 		pwm_disable(pb->pwm);
 	} else {
-		pwm_config(pb->pwm, brightness * pb->period / max, pb->period);
+		brightness = pb->lth_brightness +
+			(brightness * (pb->period - pb->lth_brightness)/ max);
+		pwm_config(pb->pwm, brightness, pb->period);
 		pwm_enable(pb->pwm);
 	}
 	return 0;
@@ -92,6 +95,8 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 
 	pb->period = data->pwm_period_ns;
 	pb->notify = data->notify;
+	pb->lth_brightness = data->lth_brightness *
+		(data->pwm_period_ns / data->max_brightness);
 	pb->dev = &pdev->dev;
 
 	pb->pwm = pwm_request(data->pwm_id, "backlight");
diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
index 01b3d75..e031e1a 100644
--- a/include/linux/pwm_backlight.h
+++ b/include/linux/pwm_backlight.h
@@ -8,6 +8,7 @@ struct platform_pwm_backlight_data {
 	int pwm_id;
 	unsigned int max_brightness;
 	unsigned int dft_brightness;
+	unsigned int lth_brightness;
 	unsigned int pwm_period_ns;
 	int (*init)(struct device *dev);
 	int (*notify)(struct device *dev, int brightness);
-- 
1.7.2.dirty

