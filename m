Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2DQXFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 19:05:16 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:31478 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2DQXFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 19:05:15 -0400
Message-ID: <1334703911.2655.9.camel@lorien2>
Subject: [PATCH] leds: ledtrig-timer trigger_data allocation fix
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shuahkhan@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Date: Tue, 17 Apr 2012 17:05:11 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ledtrig-timer doesn't allocate memory for trigger_data and assigns
(void *)1 to save state. Fixed it to allocate int instead. Please 
note that non-null trigger_data is used to key off of to do proper
cleanup in deactivation routine and not used during the life of the
trigger itself.

>From 9f7a6fc40ce7322145b6adea8771c8d547c151ec Mon Sep 17 00:00:00 2001
From: Shuah Khan <shuahkhan@gmail.com>
Date: Tue, 17 Apr 2012 16:04:56 -0600
Subject: [PATCH] leds: ledtrig-timer trigger_data allocation fix


Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 drivers/leds/ledtrig-timer.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
index b32d5ea..64b6915 100644
--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/ctype.h>
+#include <linux/slab.h>
 #include <linux/leds.h>
 #include "leds.h"
 
@@ -88,10 +89,14 @@ static void timer_trig_activate(struct led_classdev *led_cdev)
 	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
 		      &led_cdev->blink_delay_off);
 
-	led_cdev->trigger_data = (void *)1;
+	led_cdev->trigger_data = kzalloc(sizeof(int), GFP_KERNEL);
+	if (!led_cdev->trigger_data)
+		goto err_out_delayoff;
 
 	return;
 
+err_out_delayoff:
+	device_remove_file(led_cdev->dev, &dev_attr_delay_off);
 err_out_delayon:
 	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
 }
@@ -101,6 +106,7 @@ static void timer_trig_deactivate(struct led_classdev *led_cdev)
 	if (led_cdev->trigger_data) {
 		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
 		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
+		kfree(led_cdev->trigger_data);
 	}
 
 	/* Stop blinking */
-- 
1.7.5.4





