Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab2FFTLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 15:11:04 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59966 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab2FFTLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 15:11:01 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH v3] leds: fix led_brightness_set when soft-blinking
Date: Wed,  6 Jun 2012 21:12:34 +0200
Message-Id: <1339009954-1464-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <20120606191149.GA1376@gmail.com>
References: <20120606191149.GA1376@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move led_stop_software_blink() code into led_brightness_set() to ensure
software blink timer is stopped and cleared when changing trigger.

Also use led_set_brightness() instead of calling
led_cdev->brightness_set() directly to keep led_cdev->brightness
consistent with current LED status.

This ensure proper cleaning when changing triggers, as without this fix
a LED may be turned off while leaving it's led_cdev->brightness = 1,
leading to an erratic software-blink behaviour.

The problem was easy to reproduce by changing the trigger from "timer"
to "oneshot".

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/led-core.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index a6f4d91..31f1f78 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -24,13 +24,6 @@ EXPORT_SYMBOL_GPL(leds_list_lock);
 LIST_HEAD(leds_list);
 EXPORT_SYMBOL_GPL(leds_list);
 
-static void led_stop_software_blink(struct led_classdev *led_cdev)
-{
-	/* deactivate previous settings */
-	led_cdev->blink_delay_on = 0;
-	led_cdev->blink_delay_off = 0;
-}
-
 static void led_set_software_blink(struct led_classdev *led_cdev,
 				   unsigned long delay_on,
 				   unsigned long delay_off)
@@ -113,7 +106,11 @@ EXPORT_SYMBOL(led_blink_set_oneshot);
 void led_brightness_set(struct led_classdev *led_cdev,
 			enum led_brightness brightness)
 {
-	led_stop_software_blink(led_cdev);
-	led_cdev->brightness_set(led_cdev, brightness);
+	/* stop and clear soft-blink timer */
+	del_timer_sync(&led_cdev->blink_timer);
+	led_cdev->blink_delay_on = 0;
+	led_cdev->blink_delay_off = 0;
+
+	led_set_brightness(led_cdev, brightness);
 }
 EXPORT_SYMBOL(led_brightness_set);
-- 
1.7.11.rc1.9.gf623ca1.dirty

