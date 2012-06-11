Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab2FKU4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:56:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65415 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab2FKU4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:56:08 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH] leds: use led_brightness_set in led_trigger_event
Date: Mon, 11 Jun 2012 22:57:40 +0200
Message-Id: <1339448260-1733-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.10.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix led_trigger_event() to use led_brightness_set() instead of
led_set_brightness(), so that any pending blink timer is stopped before
setting the new brightness value.  Without this fix LED status may be
overridden by a pending timer.

This allows a trigger to use a mix of led_trigger_event(),
led_trigger_blink() and led_trigger_blink_oneshot() without races.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Bryan Wu <bryan.wu@canonical.com>
---
Hi Bryan,

I found this one while working on another patch but I think it's also needed by
other drivers which mixes led_trigger_blink() and led_trigger_event(), such as
power_supply_leds.

Without this a led don't stop blinking as it should when calling
led_trigger_event().

Should not cause any harm on other drivers.

(I'm starting to find the whole led_set_brightness/led_brightness_set thing a
bit confusing BTW...)

Fabio

 drivers/leds/led-triggers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index fa0b9be..b88d3b9 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -224,7 +224,7 @@ void led_trigger_event(struct led_trigger *trig,
 		struct led_classdev *led_cdev;
 
 		led_cdev = list_entry(entry, struct led_classdev, trig_list);
-		led_set_brightness(led_cdev, brightness);
+		led_brightness_set(led_cdev, brightness);
 	}
 	read_unlock(&trig->leddev_list_lock);
 }
-- 
1.7.11.rc1.9.gf623ca1.dirty

