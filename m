Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab2HWOVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:21:54 -0400
Received: from zose-mta15.web4all.fr ([176.31.217.11]:40920 "EHLO
	zose-mta15.web4all.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab2HWOVu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:21:50 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2012 10:21:50 EDT
Date: Thu, 23 Aug 2012 16:19:47 +0200 (CEST)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Cc: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>
Message-ID: <217877237.2758643.1345731587941.JavaMail.root@advansee.com>
In-Reply-To: <320569847.2756382.1345729013971.JavaMail.root@advansee.com>
Subject: [PATCH] pwm: Call pwm_enable() before pwm_config()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [88.188.188.98]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Win)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some PWM drivers enable the clock of the PWM peripheral in pwm_enable(). Hence,
for these drivers, a call to pwm_config() does not have any effect before
pwm_enable() has been called.

This patch fixes the PWM users to make sure that they call pwm_enable() before
pwm_config().

This fixes the first setting of brightness through sysfs that had no effect with
leds-pwm and the i.MX PWM driver.

Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: <linux-kernel@vger.kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: <linux-arm-kernel@lists.infradead.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: <linux-input@vger.kernel.org>
Cc: Bryan Wu <bryan.wu@canonical.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: <linux-leds@vger.kernel.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: <linux-fbdev@vger.kernel.org>
Cc: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
Signed-off-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
---
 .../drivers/input/misc/pwm-beeper.c                |    6 +++---
 .../drivers/leds/leds-pwm.c                        |    2 +-
 .../drivers/video/backlight/pwm_bl.c               |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git linux-next-c94456b.orig/drivers/input/misc/pwm-beeper.c linux-next-c94456b/drivers/input/misc/pwm-beeper.c
index fc84c8a..97d322b 100644
--- linux-next-c94456b.orig/drivers/input/misc/pwm-beeper.c
+++ linux-next-c94456b/drivers/input/misc/pwm-beeper.c
@@ -53,10 +53,10 @@ static int pwm_beeper_event(struct input_dev *input,
 		pwm_disable(beeper->pwm);
 	} else {
 		period = HZ_TO_NANOSECONDS(value);
-		ret = pwm_config(beeper->pwm, period / 2, period);
+		ret = pwm_enable(beeper->pwm);
 		if (ret)
 			return ret;
-		ret = pwm_enable(beeper->pwm);
+		ret = pwm_config(beeper->pwm, period / 2, period);
 		if (ret)
 			return ret;
 		beeper->period = period;
@@ -156,8 +156,8 @@ static int pwm_beeper_resume(struct device *dev)
 	struct pwm_beeper *beeper = dev_get_drvdata(dev);
 
 	if (beeper->period) {
-		pwm_config(beeper->pwm, beeper->period / 2, beeper->period);
 		pwm_enable(beeper->pwm);
+		pwm_config(beeper->pwm, beeper->period / 2, beeper->period);
 	}
 
 	return 0;
diff --git linux-next-c94456b.orig/drivers/leds/leds-pwm.c linux-next-c94456b/drivers/leds/leds-pwm.c
index f2e44c7..c2e0c22 100644
--- linux-next-c94456b.orig/drivers/leds/leds-pwm.c
+++ linux-next-c94456b/drivers/leds/leds-pwm.c
@@ -42,8 +42,8 @@ static void led_pwm_set(struct led_classdev *led_cdev,
 		pwm_config(led_dat->pwm, 0, period);
 		pwm_disable(led_dat->pwm);
 	} else {
-		pwm_config(led_dat->pwm, brightness * period / max, period);
 		pwm_enable(led_dat->pwm);
+		pwm_config(led_dat->pwm, brightness * period / max, period);
 	}
 }
 
diff --git linux-next-c94456b.orig/drivers/video/backlight/pwm_bl.c linux-next-c94456b/drivers/video/backlight/pwm_bl.c
index 995f016..a4bb95c 100644
--- linux-next-c94456b.orig/drivers/video/backlight/pwm_bl.c
+++ linux-next-c94456b/drivers/video/backlight/pwm_bl.c
@@ -65,8 +65,8 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 
 		duty_cycle = pb->lth_brightness +
 		     (duty_cycle * (pb->period - pb->lth_brightness) / max);
-		pwm_config(pb->pwm, duty_cycle, pb->period);
 		pwm_enable(pb->pwm);
+		pwm_config(pb->pwm, duty_cycle, pb->period);
 	}
 
 	if (pb->notify_after)
