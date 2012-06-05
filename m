Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2FEVhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 17:37:34 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56372 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2FEVhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 17:37:31 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH 2/2] leds: fix led_brightness_set when soft-blinking
Date: Tue,  5 Jun 2012 23:38:59 +0200
Message-Id: <1338932339-1660-2-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1338932339-1660-1-git-send-email-fabio.baltieri@gmail.com>
References: <1338932339-1660-1-git-send-email-fabio.baltieri@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change led_brightness_set to ensure software blink timer is stopped
before calling led_stop_software_blink() and use led_set_brightness()
instead of calling led_cdev->brightness_set() directly to ensure
led_cdev->brightness is always consistent with current LED status.

This ensure proper cleaning when changing triggers, as without this fix
a LED may be turned off while leaving it's led_cdev->brightness = 1,
leading to an erratic software-blink behaviour.

The problem was easy to reproduce by changing the trigger from "timer"
to "oneshot".

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/led-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index 579eb78..3e9f934 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -115,7 +115,8 @@ EXPORT_SYMBOL(led_blink_set_oneshot);
 void led_brightness_set(struct led_classdev *led_cdev,
 			enum led_brightness brightness)
 {
+	del_timer_sync(&led_cdev->blink_timer);
 	led_stop_software_blink(led_cdev);
-	led_cdev->brightness_set(led_cdev, brightness);
+	led_set_brightness(led_cdev, brightness);
 }
 EXPORT_SYMBOL(led_brightness_set);
-- 
1.7.10.2.520.g6a4a482.dirty

