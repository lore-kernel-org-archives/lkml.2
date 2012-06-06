Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab2FFHR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:17:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42302 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2FFHR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:17:27 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH v2] leds: fix led_brightness_set when soft-blinking
Date: Wed,  6 Jun 2012 09:19:02 +0200
Message-Id: <1338967142-6249-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <20120606070008.GA1494@gmail.com>
References: <20120606070008.GA1494@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put del_timer_sync() back into led_stop_software_blink() and move the
call earlier into led_blink_set() to ensure software blink timer is
stopped when changing trigger.  Also use led_set_brightness() instead of
calling led_cdev->brightness_set() directly to ensure
led_cdev->brightness is always consistent with current LED status.

This ensure proper cleaning when changing triggers, as without this fix
a LED may be turned off while leaving it's led_cdev->brightness = 1,
leading to an erratic software-blink behaviour.

The problem was easy to reproduce by changing the trigger from "timer"
to "oneshot".

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Bryan Wu <bryan.wu@canonical.com>
---

...maybe that version makes more sense.

Fabio

 drivers/leds/led-core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index 579eb78..2477109 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -27,6 +27,7 @@ EXPORT_SYMBOL_GPL(leds_list);
 static void led_stop_software_blink(struct led_classdev *led_cdev)
 {
 	/* deactivate previous settings */
+	del_timer_sync(&led_cdev->blink_timer);
 	led_cdev->blink_delay_on = 0;
 	led_cdev->blink_delay_off = 0;
 }
@@ -43,8 +44,6 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
 	if (!led_cdev->blink_brightness)
 		led_cdev->blink_brightness = led_cdev->max_brightness;
 
-	led_stop_software_blink(led_cdev);
-
 	led_cdev->blink_delay_on = delay_on;
 	led_cdev->blink_delay_off = delay_off;
 
@@ -82,7 +81,7 @@ void led_blink_set(struct led_classdev *led_cdev,
 		   unsigned long *delay_on,
 		   unsigned long *delay_off)
 {
-	del_timer_sync(&led_cdev->blink_timer);
+	led_stop_software_blink(led_cdev);
 
 	led_cdev->flags &= ~LED_BLINK_ONESHOT;
 	led_cdev->flags &= ~LED_BLINK_ONESHOT_STOP;
@@ -116,6 +115,6 @@ void led_brightness_set(struct led_classdev *led_cdev,
 			enum led_brightness brightness)
 {
 	led_stop_software_blink(led_cdev);
-	led_cdev->brightness_set(led_cdev, brightness);
+	led_set_brightness(led_cdev, brightness);
 }
 EXPORT_SYMBOL(led_brightness_set);
-- 
1.7.11.rc1.9.gf623ca1.dirty

