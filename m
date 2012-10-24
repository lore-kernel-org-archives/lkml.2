Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934855Ab2JXNxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:53:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60637 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934739Ab2JXNxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:53:07 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Shawn Guo <shawn.guo@linaro.org>, kernel@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org
Subject: [PATCH] RFC: leds-pwm: don't disable pwm when setting brightness to 0
Date: Wed, 24 Oct 2012 15:52:46 +0200
Message-Id: <1351086766-5837-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20121024095603.GH639@pengutronix.de>
References: <20121024095603.GH639@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes disabling the LED on i.MX28. The PWM hardware delays using
the newly set pwm-config until the beginning of a new period.  It's very
likely that pwm_disable is called before the current period ends. In
case the LED was on brightness=max before the LED stays on because in
the disabled PWM block the period never ends.

It's unclear if the mxs-pwm driver doesn't implement the API as expected
(i.e. it should block until the newly set config is effective) or if the
leds-pwm driver makes wrong assumptions. This patch assumes the latter.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

I'm not sure this is correct, but this is the workaround I'm using until
I get some feed back.

Best regards
Uwe

 drivers/leds/leds-pwm.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index f2e44c7..a909f4f 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -38,13 +38,8 @@ static void led_pwm_set(struct led_classdev *led_cdev,
 	unsigned int max = led_dat->cdev.max_brightness;
 	unsigned int period =  led_dat->period;
 
-	if (brightness == 0) {
-		pwm_config(led_dat->pwm, 0, period);
-		pwm_disable(led_dat->pwm);
-	} else {
-		pwm_config(led_dat->pwm, brightness * period / max, period);
-		pwm_enable(led_dat->pwm);
-	}
+	pwm_config(led_dat->pwm, brightness * period / max, period);
+	pwm_enable(led_dat->pwm);
 }
 
 static int led_pwm_probe(struct platform_device *pdev)
-- 
1.7.10.4

