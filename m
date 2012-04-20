Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab2DTUOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 16:14:40 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:37910 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2DTUOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 16:14:38 -0400
Message-ID: <1334952876.3255.14.camel@lorien2>
Subject: [PATCH ] leds: change existing triggers to use activated flag
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shuahkhan@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Date: Fri, 20 Apr 2012 14:14:36 -0600
In-Reply-To: <1334893688.3051.5.camel@lorien2>
References: <1334703911.2655.9.camel@lorien2>
	 <20120417161239.57c41966.akpm@linux-foundation.org>
	 <1334893688.3051.5.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed existing triggers backlight, gpio, and heartbeat to use 
activated flag to set activate successful status in their activate
routines and check it in their deactivate routines to do cleanup.

>From c0afeb736a5cb23d4212ac5900e2b514d0e75e90 Mon Sep 17 00:00:00 2001
From: Shuah Khan <shuahkhan@gmail.com>
Date: Fri, 20 Apr 2012 12:41:00 -0600
Subject: [PATCH] leds: change existing triggers to use activated flag


Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 drivers/leds/ledtrig-backlight.c |    4 +++-
 drivers/leds/ledtrig-gpio.c      |    4 +++-
 drivers/leds/ledtrig-heartbeat.c |    4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/ledtrig-backlight.c b/drivers/leds/ledtrig-backlight.c
index 2b513a2..e272686 100644
--- a/drivers/leds/ledtrig-backlight.c
+++ b/drivers/leds/ledtrig-backlight.c
@@ -120,6 +120,7 @@ static void bl_trig_activate(struct led_classdev *led)
 	ret = fb_register_client(&n->notifier);
 	if (ret)
 		dev_err(led->dev, "unable to register backlight trigger\n");
+	led->activated = true;
 
 	return;
 
@@ -133,10 +134,11 @@ static void bl_trig_deactivate(struct led_classdev *led)
 	struct bl_trig_notifier *n =
 		(struct bl_trig_notifier *) led->trigger_data;
 
-	if (n) {
+	if (led->activated) {
 		device_remove_file(led->dev, &dev_attr_inverted);
 		fb_unregister_client(&n->notifier);
 		kfree(n);
+		led->activated = false;
 	}
 }
 
diff --git a/drivers/leds/ledtrig-gpio.c b/drivers/leds/ledtrig-gpio.c
index ecc4bf3..f057c10 100644
--- a/drivers/leds/ledtrig-gpio.c
+++ b/drivers/leds/ledtrig-gpio.c
@@ -200,6 +200,7 @@ static void gpio_trig_activate(struct led_classdev *led)
 	gpio_data->led = led;
 	led->trigger_data = gpio_data;
 	INIT_WORK(&gpio_data->work, gpio_trig_work);
+	led->activated = true;
 
 	return;
 
@@ -217,7 +218,7 @@ static void gpio_trig_deactivate(struct led_classdev *led)
 {
 	struct gpio_trig_data *gpio_data = led->trigger_data;
 
-	if (gpio_data) {
+	if (led->activated) {
 		device_remove_file(led->dev, &dev_attr_gpio);
 		device_remove_file(led->dev, &dev_attr_inverted);
 		device_remove_file(led->dev, &dev_attr_desired_brightness);
@@ -225,6 +226,7 @@ static void gpio_trig_deactivate(struct led_classdev *led)
 		if (gpio_data->gpio != 0)
 			free_irq(gpio_to_irq(gpio_data->gpio), led);
 		kfree(gpio_data);
+		led->activated = false;
 	}
 }
 
diff --git a/drivers/leds/ledtrig-heartbeat.c b/drivers/leds/ledtrig-heartbeat.c
index 759c0bb..1aacf4c 100644
--- a/drivers/leds/ledtrig-heartbeat.c
+++ b/drivers/leds/ledtrig-heartbeat.c
@@ -83,15 +83,17 @@ static void heartbeat_trig_activate(struct led_classdev *led_cdev)
 		    led_heartbeat_function, (unsigned long) led_cdev);
 	heartbeat_data->phase = 0;
 	led_heartbeat_function(heartbeat_data->timer.data);
+	led_cdev->activated = true;
 }
 
 static void heartbeat_trig_deactivate(struct led_classdev *led_cdev)
 {
 	struct heartbeat_trig_data *heartbeat_data = led_cdev->trigger_data;
 
-	if (heartbeat_data) {
+	if (led_cdev->activated) {
 		del_timer_sync(&heartbeat_data->timer);
 		kfree(heartbeat_data);
+		led_cdev->activated = false;
 	}
 }
 
-- 
1.7.5.4



