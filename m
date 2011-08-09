Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab1HICGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 22:06:49 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6106 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1HICGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 22:06:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 08 Aug 2011 19:06:47 -0700
From: dilee@nvidia.com
To: rpurdie@rpsys.net, lethal@linux-sh.org, akpm@linux-foundation.org,
        arun.murthy@stericsson.com, rmorell@nvidia.com,
        linus.walleij@stericsson.com
Cc: jnien@nvidia.com, swarren@nvidia.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Dilan Lee <dilee@nvidia.com>
Subject: [PATCH] video: Add a callback 'notify_after' for backlight control
Date: Tue,  9 Aug 2011 10:05:25 +0800
Message-Id: <1312855525-21464-1-git-send-email-dilee@nvidia.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dilan Lee <dilee@nvidia.com>

We need a callback to do some things after pwm_enable, pwm_disable
and pwm_config.

This may be necessary to properly sequence timing on
certain devices.

For example, GPIO backlight_en has to be risen after pwm has been enabled
to meet panel power on sequence defined in panel specification.

Signed-off-by: Dilan Lee <dilee@nvidia.com>
---
 drivers/video/backlight/pwm_bl.c |   11 ++++++++++-
 include/linux/pwm_backlight.h    |    1 +
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index b8f38ec..e92e6e0 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -27,7 +27,9 @@ struct pwm_bl_data {
 	unsigned int		period;
 	unsigned int		lth_brightness;
 	int			(*notify)(struct device *,
-					  int brightness);
+					int brightness);
+	void			(*notify_after)(struct device *,
+					int brightness);
 	int			(*check_fb)(struct device *, struct fb_info *);
 };
 
@@ -55,6 +57,10 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 		pwm_config(pb->pwm, brightness, pb->period);
 		pwm_enable(pb->pwm);
 	}
+
+	if (pb->notify_after)
+		pb->notify_after(pb->dev, brightness);
+
 	return 0;
 }
 
@@ -105,6 +111,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 
 	pb->period = data->pwm_period_ns;
 	pb->notify = data->notify;
+	pb->notify_after = data->notify_after;
 	pb->check_fb = data->check_fb;
 	pb->lth_brightness = data->lth_brightness *
 		(data->pwm_period_ns / data->max_brightness);
@@ -172,6 +179,8 @@ static int pwm_backlight_suspend(struct platform_device *pdev,
 		pb->notify(pb->dev, 0);
 	pwm_config(pb->pwm, 0, pb->period);
 	pwm_disable(pb->pwm);
+	if (pb->notify_after)
+		pb->notify_after(pb->dev, 0);
 	return 0;
 }
 
diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
index 5e3e25a..63d2df4 100644
--- a/include/linux/pwm_backlight.h
+++ b/include/linux/pwm_backlight.h
@@ -14,6 +14,7 @@ struct platform_pwm_backlight_data {
 	unsigned int pwm_period_ns;
 	int (*init)(struct device *dev);
 	int (*notify)(struct device *dev, int brightness);
+	void (*notify_after)(struct device *dev, int brightness);
 	void (*exit)(struct device *dev);
 	int (*check_fb)(struct device *dev, struct fb_info *info);
 };
-- 
1.7.6

