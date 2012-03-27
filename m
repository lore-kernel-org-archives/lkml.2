Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2C0PVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:21:46 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:10183 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab2C0PVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:21:40 -0400
Message-ID: <1332861697.2834.9.camel@lorien2>
Subject: [PATCH] LEDS-One-Shot-Timer-Trigger-implementation
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: rpurdie@rpsys.net, LKML <linux-kernel@vger.kernel.org>
Cc: shuahkhan@gmail.com, neilb@suse.de
Date: Tue, 27 Mar 2012 09:21:37 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LED infrastructure lacks support for one shot timer trigger and activation.
The current support allows for setting two timers, one for specifying how 
long a state to be on, and the second for how long the state to be off. For
example, delay_on value specifies the time period an LED should stay in on
state, followed by a delay_off value that specifies how long the LED should
stay in off state. The on and off cycle repeats until the trigger gets 
deactivated. There is no provision for one time activation to implement
features that require an on or off state to be held just once and then stay
in the original state forever.

This feature will help implement vibrate functionality which requires one
shot activation of vibrate mode without a continuous vibrate on/off cycles.

This patch implements the one-shot-timer trigger support by enhancing the
current led-class and ledtrig-timer drivers to support the following
use-cases:

use-case 1:
echo one-shot-timer > /sys/class/leds/SOMELED/trigger
echo 2000 > /sys/class/leds/SOMELED/delay_on
echo forever > /sys/class/leds/SOMELED/delay_off

When one-shot-timer is activated in step1, unlike the timer trigger case,
one-shot-timer activate routine activates the trigger without starting
any timers. The default 1 HZ delay_on and delay_off timers won't be started
like in the case of timer trigger activation. Not starting timers ensures 
that the one shot state isn't stuck if some error occurs before actual timer
periods are specified. delay_on and delay_off files get created with 0
values.

When delay_on value is specified in step 2, a timer gets started for delay_on
period, and delay_off stays at 0 or whatever its current value is. 

When delay_off value is specified in step 3, delay_off_store recognizes the
special forever tag and records it and returns without starting any timer.

use-case 2:
echo one-shot-timer > /sys/class/leds/SOMELED/trigger
echo 2000 > /sys/class/leds/SOMELED/delay_off
echo forever > /sys/class/leds/SOMELED/delay_on

When one-shot-timer is activated in step1, unlike the timer trigger case,
one-shot-timer activate routine activates the trigger without starting
any timers. The default 1 HZ delay_on and delay_off timers won't be started
like in the case of timer trigger activation. Not starting timers ensures 
that the one shot state isn't stuck if some error occurs before actual timer
periods are specified. delay_on and delay_off files get created with 0
values.

When delay_off value is specified in step 2, a timer gets started for delay_off
period, and delay_on stays at 0 or whatever its current value is. 

When delay_on value is specified in step 3, delay_on_store recognizes the
special forever tag and records it and returns without starting any timer.

>From ebc4c08c138bc8ac1ac8f4eb80f879e8e7f105d3 Mon Sep 17 00:00:00 2001
From: Shuah Khan <shuahkhan@gmail.com>
Date: Mon, 26 Mar 2012 17:34:42 -0600
Subject: [PATCH] LEDS-One-Shot-Timer-Trigger-implementation


Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 drivers/leds/led-class.c     |    4 +-
 drivers/leds/led-core.c      |   26 +++++++++--
 drivers/leds/ledtrig-timer.c |  101 +++++++++++++++++++++++++++++------------
 3 files changed, 96 insertions(+), 35 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 5bff843..be7400a 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -107,7 +107,9 @@ static void led_timer_function(unsigned long data)
 
 	led_set_brightness(led_cdev, brightness);
 
-	mod_timer(&led_cdev->blink_timer, jiffies + msecs_to_jiffies(delay));
+	if (delay != ULONG_MAX)
+		mod_timer(&led_cdev->blink_timer,
+			jiffies + msecs_to_jiffies(delay));
 }
 
 /**
diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index d686004..40685f1 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -72,17 +72,35 @@ void led_blink_set(struct led_classdev *led_cdev,
 		   unsigned long *delay_on,
 		   unsigned long *delay_off)
 {
+	unsigned long val_on;
+	unsigned long val_off;
+
 	del_timer_sync(&led_cdev->blink_timer);
 
-	if (led_cdev->blink_set &&
+	if (delay_on && delay_off && led_cdev->blink_set &&
 	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
 		return;
 
+	/* if delay_on is null, leave it on forever after delay_off period
+	   if delay_off is null, leave it off forever after delay on period */
+	if (!delay_on)
+		val_on = ULONG_MAX;
+	else
+		val_on = *delay_on;
+
+	if (!delay_off)
+		val_off = ULONG_MAX;
+	else
+		val_off = *delay_off;
+
 	/* blink with 1 Hz as default if nothing specified */
-	if (!*delay_on && !*delay_off)
-		*delay_on = *delay_off = 500;
+	if (!val_on && !val_off) {
+		val_on = val_off = 500;
+		*delay_on = 500;
+		*delay_off = 500;
+	}
 
-	led_set_software_blink(led_cdev, *delay_on, *delay_off);
+	led_set_software_blink(led_cdev, val_on, val_off);
 }
 EXPORT_SYMBOL(led_blink_set);
 
diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
index 328c64c..bfda51c 100644
--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -24,6 +24,9 @@ static ssize_t led_delay_on_show(struct device *dev,
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 
+	if (led_cdev->blink_delay_on == ULONG_MAX)
+		return sprintf(buf, "%s\n", "forever");
+
 	return sprintf(buf, "%lu\n", led_cdev->blink_delay_on);
 }
 
@@ -32,17 +35,25 @@ static ssize_t led_delay_on_store(struct device *dev,
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	int ret = -EINVAL;
-	char *after;
-	unsigned long state = simple_strtoul(buf, &after, 10);
-	size_t count = after - buf;
-
-	if (isspace(*after))
-		count++;
 
-	if (count == size) {
-		led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
-		led_cdev->blink_delay_on = state;
-		ret = count;
+	if (strncmp(buf, "forever", 7) == 0) {
+		led_blink_set(led_cdev, NULL, &led_cdev->blink_delay_off);
+		led_cdev->blink_delay_on = ULONG_MAX;
+		ret = size;
+	} else {
+		char *after;
+		unsigned long state = simple_strtoul(buf, &after, 10);
+		size_t count = after - buf;
+
+		if (isspace(*after))
+			count++;
+
+		if (count == size) {
+			led_blink_set(led_cdev, &state,
+				&led_cdev->blink_delay_off);
+			led_cdev->blink_delay_on = state;
+			ret = count;
+		}
 	}
 
 	return ret;
@@ -53,6 +64,9 @@ static ssize_t led_delay_off_show(struct device *dev,
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 
+	if (led_cdev->blink_delay_off == ULONG_MAX)
+		return sprintf(buf, "%s\n", "forever");
+
 	return sprintf(buf, "%lu\n", led_cdev->blink_delay_off);
 }
 
@@ -61,17 +75,24 @@ static ssize_t led_delay_off_store(struct device *dev,
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	int ret = -EINVAL;
-	char *after;
-	unsigned long state = simple_strtoul(buf, &after, 10);
-	size_t count = after - buf;
 
-	if (isspace(*after))
-		count++;
-
-	if (count == size) {
-		led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
-		led_cdev->blink_delay_off = state;
-		ret = count;
+	if (strncmp(buf, "forever", 7) == 0) {
+		led_blink_set(led_cdev, &led_cdev->blink_delay_on, NULL);
+		led_cdev->blink_delay_off = ULONG_MAX;
+	} else {
+		char *after;
+		unsigned long state = simple_strtoul(buf, &after, 10);
+		size_t count = after - buf;
+
+		if (isspace(*after))
+			count++;
+
+		if (count == size) {
+			led_blink_set(led_cdev, &led_cdev->blink_delay_on,
+				&state);
+			led_cdev->blink_delay_off = state;
+			ret = count;
+		}
 	}
 
 	return ret;
@@ -80,7 +101,7 @@ static ssize_t led_delay_off_store(struct device *dev,
 static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_store);
 static DEVICE_ATTR(delay_off, 0644, led_delay_off_show, led_delay_off_store);
 
-static void timer_trig_activate(struct led_classdev *led_cdev)
+static void timer_trig_activate_common(struct led_classdev *led_cdev)
 {
 	int rc;
 
@@ -91,17 +112,24 @@ static void timer_trig_activate(struct led_classdev *led_cdev)
 		return;
 	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
 	if (rc)
-		goto err_out_delayon;
-
-	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
-		      &led_cdev->blink_delay_off);
+		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
 
-	led_cdev->trigger_data = (void *)1;
+	else
+		led_cdev->trigger_data = (void *)1;
+}
 
-	return;
+static void timer_trig_activate_one_shot(struct led_classdev *led_cdev)
+{
+	timer_trig_activate_common(led_cdev);
+}
 
-err_out_delayon:
-	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
+static void timer_trig_activate(struct led_classdev *led_cdev)
+{
+	timer_trig_activate_common(led_cdev);
+	if (led_cdev->trigger_data) {
+		led_blink_set(led_cdev, &led_cdev->blink_delay_on,
+		      &led_cdev->blink_delay_off);
+	}
 }
 
 static void timer_trig_deactivate(struct led_classdev *led_cdev)
@@ -121,14 +149,27 @@ static struct led_trigger timer_led_trigger = {
 	.deactivate = timer_trig_deactivate,
 };
 
+static struct led_trigger one_shot_timer_led_trigger = {
+	.name     = "one-shot-timer",
+	.activate = timer_trig_activate_one_shot,
+	.deactivate = timer_trig_deactivate,
+};
+
 static int __init timer_trig_init(void)
 {
-	return led_trigger_register(&timer_led_trigger);
+	int rc = 0;
+
+	rc = led_trigger_register(&timer_led_trigger);
+	if (!rc)
+		rc = led_trigger_register(&one_shot_timer_led_trigger);
+
+	return rc;
 }
 
 static void __exit timer_trig_exit(void)
 {
 	led_trigger_unregister(&timer_led_trigger);
+	led_trigger_unregister(&one_shot_timer_led_trigger);
 }
 
 module_init(timer_trig_init);
-- 
1.7.5.4



