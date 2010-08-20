Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0HTJVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:21:49 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:59193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab0HTJVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:21:45 -0400
Subject: [RFC] led-class: always implement blinking
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 11:21:42 +0200
Message-ID: <1282296102.3785.28.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Currently, blinking LEDs can be awkward because it is
not guaranteed that all LEDs implement blinking. The
trigger that wants it to blink then needs to implement
its own timer solution. Rather than require that, make
the core always implement LED "blinkability" with a
timer implementation in the core. The timer trigger
then becomes a very trivial one, and all code using
LEDs can rely on them to be able to blink.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/leds/led-class.c     |   78 +++++++++++++++++++++++++++
 drivers/leds/led-triggers.c  |    2 
 drivers/leds/ledtrig-timer.c |  124 ++++---------------------------------------
 include/linux/leds.h         |    5 +
 4 files changed, 97 insertions(+), 112 deletions(-)

--- wireless-testing.orig/drivers/leds/ledtrig-timer.c	2010-08-20 11:12:07.000000000 +0200
+++ wireless-testing/drivers/leds/ledtrig-timer.c	2010-08-20 11:12:22.000000000 +0200
@@ -12,73 +12,25 @@
  */
 
 #include <linux/module.h>
-#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/list.h>
-#include <linux/spinlock.h>
 #include <linux/device.h>
-#include <linux/sysdev.h>
-#include <linux/timer.h>
 #include <linux/ctype.h>
 #include <linux/leds.h>
-#include <linux/slab.h>
 #include "leds.h"
 
-struct timer_trig_data {
-	int brightness_on;		/* LED brightness during "on" period.
-					 * (LED_OFF < brightness_on <= LED_FULL)
-					 */
-	unsigned long delay_on;		/* milliseconds on */
-	unsigned long delay_off;	/* milliseconds off */
-	struct timer_list timer;
-};
-
-static void led_timer_function(unsigned long data)
-{
-	struct led_classdev *led_cdev = (struct led_classdev *) data;
-	struct timer_trig_data *timer_data = led_cdev->trigger_data;
-	unsigned long brightness;
-	unsigned long delay;
-
-	if (!timer_data->delay_on || !timer_data->delay_off) {
-		led_set_brightness(led_cdev, LED_OFF);
-		return;
-	}
-
-	brightness = led_get_brightness(led_cdev);
-	if (!brightness) {
-		/* Time to switch the LED on. */
-		brightness = timer_data->brightness_on;
-		delay = timer_data->delay_on;
-	} else {
-		/* Store the current brightness value to be able
-		 * to restore it when the delay_off period is over.
-		 */
-		timer_data->brightness_on = brightness;
-		brightness = LED_OFF;
-		delay = timer_data->delay_off;
-	}
-
-	led_set_brightness(led_cdev, brightness);
-
-	mod_timer(&timer_data->timer, jiffies + msecs_to_jiffies(delay));
-}
-
 static ssize_t led_delay_on_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 
-	return sprintf(buf, "%lu\n", timer_data->delay_on);
+	return sprintf(buf, "%lu\n", led_cdev->blink_delay_on);
 }
 
 static ssize_t led_delay_on_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 	int ret = -EINVAL;
 	char *after;
 	unsigned long state = simple_strtoul(buf, &after, 10);
@@ -88,21 +40,8 @@ static ssize_t led_delay_on_store(struct
 		count++;
 
 	if (count == size) {
-		if (timer_data->delay_on != state) {
-			/* the new value differs from the previous */
-			timer_data->delay_on = state;
-
-			/* deactivate previous settings */
-			del_timer_sync(&timer_data->timer);
-
-			/* try to activate hardware acceleration, if any */
-			if (!led_cdev->blink_set ||
-			    led_cdev->blink_set(led_cdev,
-			      &timer_data->delay_on, &timer_data->delay_off)) {
-				/* no hardware acceleration, blink via timer */
-				mod_timer(&timer_data->timer, jiffies + 1);
-			}
-		}
+		led_cdev->blink_set(led_cdev, &state,
+				    &led_cdev->blink_delay_off);
 		ret = count;
 	}
 
@@ -113,16 +52,14 @@ static ssize_t led_delay_off_show(struct
 		struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 
-	return sprintf(buf, "%lu\n", timer_data->delay_off);
+	return sprintf(buf, "%lu\n", led_cdev->blink_delay_off);
 }
 
 static ssize_t led_delay_off_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 	int ret = -EINVAL;
 	char *after;
 	unsigned long state = simple_strtoul(buf, &after, 10);
@@ -132,21 +69,8 @@ static ssize_t led_delay_off_store(struc
 		count++;
 
 	if (count == size) {
-		if (timer_data->delay_off != state) {
-			/* the new value differs from the previous */
-			timer_data->delay_off = state;
-
-			/* deactivate previous settings */
-			del_timer_sync(&timer_data->timer);
-
-			/* try to activate hardware acceleration, if any */
-			if (!led_cdev->blink_set ||
-			    led_cdev->blink_set(led_cdev,
-			      &timer_data->delay_on, &timer_data->delay_off)) {
-				/* no hardware acceleration, blink via timer */
-				mod_timer(&timer_data->timer, jiffies + 1);
-			}
-		}
+		led_cdev->blink_set(led_cdev, &led_cdev->blink_delay_on,
+				    &state);
 		ret = count;
 	}
 
@@ -158,60 +82,36 @@ static DEVICE_ATTR(delay_off, 0644, led_
 
 static void timer_trig_activate(struct led_classdev *led_cdev)
 {
-	struct timer_trig_data *timer_data;
 	int rc;
 
-	timer_data = kzalloc(sizeof(struct timer_trig_data), GFP_KERNEL);
-	if (!timer_data)
-		return;
-
-	timer_data->brightness_on = led_get_brightness(led_cdev);
-	if (timer_data->brightness_on == LED_OFF)
-		timer_data->brightness_on = led_cdev->max_brightness;
-	led_cdev->trigger_data = timer_data;
-
-	init_timer(&timer_data->timer);
-	timer_data->timer.function = led_timer_function;
-	timer_data->timer.data = (unsigned long) led_cdev;
+	led_cdev->trigger_data = NULL;
 
 	rc = device_create_file(led_cdev->dev, &dev_attr_delay_on);
 	if (rc)
-		goto err_out;
+		return;
 	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
 	if (rc)
 		goto err_out_delayon;
 
-	/* If there is hardware support for blinking, start one
-	 * user friendly blink rate chosen by the driver.
-	 */
-	if (led_cdev->blink_set)
-		led_cdev->blink_set(led_cdev,
-			&timer_data->delay_on, &timer_data->delay_off);
+	led_cdev->trigger_data = (void *)1;
 
 	return;
 
 err_out_delayon:
 	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
-err_out:
-	led_cdev->trigger_data = NULL;
-	kfree(timer_data);
 }
 
 static void timer_trig_deactivate(struct led_classdev *led_cdev)
 {
-	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 	unsigned long on = 0, off = 0;
 
-	if (timer_data) {
+	if (led_cdev->trigger_data) {
 		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
 		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
-		del_timer_sync(&timer_data->timer);
-		kfree(timer_data);
 	}
 
-	/* If there is hardware support for blinking, stop it */
-	if (led_cdev->blink_set)
-		led_cdev->blink_set(led_cdev, &on, &off);
+	/* Stop blinking */
+	led_cdev->blink_set(led_cdev, &on, &off);
 }
 
 static struct led_trigger timer_led_trigger = {
--- wireless-testing.orig/drivers/leds/led-class.c	2010-08-20 11:12:07.000000000 +0200
+++ wireless-testing/drivers/leds/led-class.c	2010-08-20 11:17:49.000000000 +0200
@@ -81,6 +81,73 @@ static struct device_attribute led_class
 	__ATTR_NULL,
 };
 
+static void led_timer_function(unsigned long data)
+{
+	struct led_classdev *led_cdev = (void *)data;
+	unsigned long brightness;
+	unsigned long delay;
+
+	if (!led_cdev->blink_delay_on || !led_cdev->blink_delay_off) {
+		led_set_brightness(led_cdev, LED_OFF);
+		return;
+	}
+
+	brightness = led_get_brightness(led_cdev);
+	if (!brightness) {
+		/* Time to switch the LED on. */
+		brightness = led_cdev->blink_brightness;
+		delay = led_cdev->blink_delay_on;
+	} else {
+		/* Store the current brightness value to be able
+		 * to restore it when the delay_off period is over.
+		 */
+		led_cdev->blink_brightness = brightness;
+		brightness = LED_OFF;
+		delay = led_cdev->blink_delay_off;
+	}
+
+	led_set_brightness(led_cdev, brightness);
+
+	mod_timer(&led_cdev->blink_timer, jiffies + msecs_to_jiffies(delay));
+}
+
+static int led_blink_set(struct led_classdev *led_cdev,
+			 unsigned long *delay_on, unsigned long *delay_off)
+{
+	int current_brightness;
+
+	current_brightness = led_get_brightness(led_cdev);
+	if (current_brightness)
+		led_cdev->blink_brightness = current_brightness;
+	if (!led_cdev->blink_brightness)
+		led_cdev->blink_brightness = led_cdev->max_brightness;
+
+	if (*delay_on == led_cdev->blink_delay_on &&
+	    *delay_off == led_cdev->blink_delay_off)
+		return 0;
+
+	/* deactivate previous settings */
+	del_timer_sync(&led_cdev->blink_timer);
+
+	led_cdev->blink_delay_on = *delay_on;
+	led_cdev->blink_delay_off = *delay_off;
+
+	/* never on - don't blink */
+	if (!*delay_on)
+		return 0;
+
+	/* never off - just set to brightness */
+	if (!*delay_off) {
+		led_set_brightness(led_cdev, led_cdev->blink_brightness);
+		return 0;
+	}
+
+	mod_timer(&led_cdev->blink_timer, jiffies + 1);
+
+	return 0;
+}
+
+
 /**
  * led_classdev_suspend - suspend an led_classdev.
  * @led_cdev: the led_classdev to suspend.
@@ -148,6 +215,13 @@ int led_classdev_register(struct device
 
 	led_update_brightness(led_cdev);
 
+	init_timer(&led_cdev->blink_timer);
+	led_cdev->blink_timer.function = led_timer_function;
+	led_cdev->blink_timer.data = (unsigned long)led_cdev;
+
+	if (!led_cdev->blink_set)
+		led_cdev->blink_set = led_blink_set;
+
 #ifdef CONFIG_LEDS_TRIGGERS
 	led_trigger_set_default(led_cdev);
 #endif
@@ -168,6 +242,8 @@ EXPORT_SYMBOL_GPL(led_classdev_register)
  */
 void led_classdev_unregister(struct led_classdev *led_cdev)
 {
+	unsigned long on = 0, off = 0;
+
 #ifdef CONFIG_LEDS_TRIGGERS
 	down_write(&led_cdev->trigger_lock);
 	if (led_cdev->trigger)
@@ -175,6 +251,8 @@ void led_classdev_unregister(struct led_
 	up_write(&led_cdev->trigger_lock);
 #endif
 
+	led_cdev->blink_set(led_cdev, &on, &off);
+
 	device_unregister(led_cdev->dev);
 
 	down_write(&leds_list_lock);
--- wireless-testing.orig/drivers/leds/led-triggers.c	2010-08-20 11:12:07.000000000 +0200
+++ wireless-testing/drivers/leds/led-triggers.c	2010-08-20 11:12:22.000000000 +0200
@@ -103,6 +103,7 @@ EXPORT_SYMBOL_GPL(led_trigger_show);
 void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
 {
 	unsigned long flags;
+	unsigned long on = 0, off = 0;
 
 	/* Remove any existing trigger */
 	if (led_cdev->trigger) {
@@ -113,6 +114,7 @@ void led_trigger_set(struct led_classdev
 		if (led_cdev->trigger->deactivate)
 			led_cdev->trigger->deactivate(led_cdev);
 		led_cdev->trigger = NULL;
+		led_cdev->blink_set(led_cdev, &on, &off);
 		led_set_brightness(led_cdev, LED_OFF);
 	}
 	if (trigger) {
--- wireless-testing.orig/include/linux/leds.h	2010-08-20 11:12:07.000000000 +0200
+++ wireless-testing/include/linux/leds.h	2010-08-20 11:12:22.000000000 +0200
@@ -15,6 +15,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/rwsem.h>
+#include <linux/timer.h>
 
 struct device;
 /*
@@ -57,6 +58,10 @@ struct led_classdev {
 	struct list_head	 node;			/* LED Device list */
 	const char		*default_trigger;	/* Trigger to use */
 
+	unsigned long		 blink_delay_on, blink_delay_off;
+	struct timer_list	 blink_timer;
+	int			 blink_brightness;
+
 #ifdef CONFIG_LEDS_TRIGGERS
 	/* Protects the trigger data below */
 	struct rw_semaphore	 trigger_lock;


