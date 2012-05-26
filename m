Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab2EZXTA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 19:19:00 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50605 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2EZXS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 19:18:58 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH 2/3] ledtrig-ide-disk: use generic one-shot blink api
Date: Sun, 27 May 2012 01:19:23 +0200
Message-Id: <1338074364-1829-2-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1338074364-1829-1-git-send-email-fabio.baltieri@gmail.com>
References: <1338074364-1829-1-git-send-email-fabio.baltieri@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert ledtrig-ide-disk code to use the generic API for one-shot LED
blinking.

This patch changes slightly the behaviour of the trigger, as while the
original version kept the LED on under heavy activity, the new one keeps
a constant on-off blink at 1 / (2 * BLINK_DELAY) Hz.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/ledtrig-ide-disk.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/leds/ledtrig-ide-disk.c b/drivers/leds/ledtrig-ide-disk.c
index ec099fc..0ff16fb 100644
--- a/drivers/leds/ledtrig-ide-disk.c
+++ b/drivers/leds/ledtrig-ide-disk.c
@@ -18,33 +18,18 @@
 #include <linux/timer.h>
 #include <linux/leds.h>
 
-static void ledtrig_ide_timerfunc(unsigned long data);
+#define BLINK_DELAY 30
 
 DEFINE_LED_TRIGGER(ledtrig_ide);
-static DEFINE_TIMER(ledtrig_ide_timer, ledtrig_ide_timerfunc, 0, 0);
-static int ide_activity;
-static int ide_lastactivity;
+static unsigned long ide_blink_delay = BLINK_DELAY;
 
 void ledtrig_ide_activity(void)
 {
-	ide_activity++;
-	if (!timer_pending(&ledtrig_ide_timer))
-		mod_timer(&ledtrig_ide_timer, jiffies + msecs_to_jiffies(10));
+	led_trigger_blink_oneshot(ledtrig_ide,
+				  &ide_blink_delay, &ide_blink_delay, 0);
 }
 EXPORT_SYMBOL(ledtrig_ide_activity);
 
-static void ledtrig_ide_timerfunc(unsigned long data)
-{
-	if (ide_lastactivity != ide_activity) {
-		ide_lastactivity = ide_activity;
-		/* INT_MAX will set each LED to its maximum brightness */
-		led_trigger_event(ledtrig_ide, INT_MAX);
-		mod_timer(&ledtrig_ide_timer, jiffies + msecs_to_jiffies(10));
-	} else {
-		led_trigger_event(ledtrig_ide, LED_OFF);
-	}
-}
-
 static int __init ledtrig_ide_init(void)
 {
 	led_trigger_register_simple("ide-disk", &ledtrig_ide);
-- 
1.7.10.2.520.g6a4a482.dirty

