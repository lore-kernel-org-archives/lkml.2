Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2EHWnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:43:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61225 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab2EHWnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:43:40 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: socketcan@hartkopp.net, wg@grandegger.com, mkl@pengutronix.de,
        shuahkhan@gmail.com, Fabio Baltieri <fabio.baltieri@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [RFC PATCH] leds: add oneshot blink functions
Date: Wed,  9 May 2012 00:45:31 +0200
Message-Id: <1336517131-3711-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two new functions, led_blink_set_oneshot and
led_trigger_blink_oneshot, to be used by triggers for one-shot blink of
led devices.

This is implemented extending the existing software-blink code, and uses
the same timer and handler function.

The behavior of the code is to do a blink-on, blink-off sequence when
the function is called, ignoring other calls until the sequence is
completed so that the leds keep blinking at constant rate if the
functions are called repeatedly.

This is meant to be used by drivers which needs to trigger on sporadic
events, but doesn't have clear busy/idle trigger points.

After the blink sequence the led remains off. This behavior can be
inverted setting the "invert" argument, blinking the led off, than on
and leaving the led on after the sequence.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
Hello everyone,

I'm posting this one following a discussion on the linux-can list about the
implementation of led triggers for tx/rx events of socketcan devices and as
a reply for the recent patches from Shuah Khan about the transient led
triggers.

This patch adds one-shot blink functions similar to the ones used for normal
blink configuration, and are meant to be used to trigger blinking on
sporadic events.

My proposed implementation was similar to the ledtrig-ide-disk and the xt_LED
ones, and was to use a dedicated timer for each event with a simple logic to
keep the led blinking at a constant rate under heavy load of the bus.  The reason was that the led was also used to indicate interface state, as in:

- led ON: interface up
- led OFF: interface down
- led blinking: bus activity

Of course this is similar to how ethernet interface LEDs works.

My original patch can be found in this post:

http://article.gmane.org/gmane.linux.can/1085

Now, i think that the framework specific implementation was clean and
lightweight (the mod_timer has to be called in hardirq context after all),
but the guys on the list pointed out that adding another one-shot-blink
implementation was redundant and asked to re-implement the blink-part as a
led-framework extension, as least to discuss about what's the better way to
do the job... so I gave it a shot!

The implementation re-used most of the current soft-blink code, modifiying it
in the following way:
- add a _oneshoot function to both led_trigger_blink and led_blink_set,
  moving the common code into two _setup functions;
- add three flags to track the blink status and configuration for the led
  (oneshot or normal blink, stop after timer, inverted logic);
- modify led_timer_function to add necessary stop-timer logic;

Again, the timer-retriggering logic has been implemented to keep the led
blinking at constant rate if led_blink_set_oneshot is called quicker than the
blink rate (that's what the STOP flag is used for).

That's it, tested on an x86 with a stub driver not worth posting and a
with a modified version of my original can-led patch.

Altrough this code was meant for device drivers, it looks quite similar to
what was discussed into the "transient trigger for one shot timer activation"
patches from Shuah Khan, so I think that Shuah's trigger may be implemented
on this functions similarly to how ledtrig-timer works for normal blinking.

About the RFC, I was looking forward to discuss about this points:
- do you think is worth implementing some grade of generic trigger logic like
  this one into the led framework, or it just have to be kept as a simple
  abstraction for led-on/led-off event with just normal blink as special case
  (because it can be hardware assisted)? This is because I feel that this
  patch is polluting the code a bit.
- specifically to my can-led patch linked above, considering that some code
  (can_led_event) is ending up in hard-irq context and the led is going to
  retrigger quite often, do you think is worth going to a more optimized
  framework-specific implementation or it's better to come up with some
  generic code for it?

Regards,
Fabio

 drivers/leds/led-class.c    |   19 ++++++++++++++++
 drivers/leds/led-core.c     |   50 ++++++++++++++++++++++++++++++++----------
 drivers/leds/led-triggers.c |   30 ++++++++++++++++++++++---
 include/linux/leds.h        |   25 +++++++++++++++++++++
 4 files changed, 108 insertions(+), 16 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 5bff843..42d9359 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -91,6 +91,11 @@ static void led_timer_function(unsigned long data)
 		return;
 	}
 
+	if (led_cdev->flags & LED_BLINK_ONESHOT_STOP) {
+		led_cdev->flags &= ~LED_BLINK_ONESHOT_STOP;
+		return;
+	}
+
 	brightness = led_get_brightness(led_cdev);
 	if (!brightness) {
 		/* Time to switch the LED on. */
@@ -107,6 +112,20 @@ static void led_timer_function(unsigned long data)
 
 	led_set_brightness(led_cdev, brightness);
 
+	/* Return in next iteration if led is in one-shot mode and we are in
+	 * the final blink state so that the led is toggled each delay_on +
+	 * delay_off milliseconds in worst case.
+	 */
+	if (led_cdev->flags & LED_BLINK_ONESHOT) {
+		if (led_cdev->flags & LED_BLINK_INVERT) {
+			if (brightness)
+				led_cdev->flags |= LED_BLINK_ONESHOT_STOP;
+		} else {
+			if (!brightness)
+				led_cdev->flags |= LED_BLINK_ONESHOT_STOP;
+		}
+	}
+
 	mod_timer(&led_cdev->blink_timer, jiffies + msecs_to_jiffies(delay));
 }
 
diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index d686004..579eb78 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -27,7 +27,6 @@ EXPORT_SYMBOL_GPL(leds_list);
 static void led_stop_software_blink(struct led_classdev *led_cdev)
 {
 	/* deactivate previous settings */
-	del_timer_sync(&led_cdev->blink_timer);
 	led_cdev->blink_delay_on = 0;
 	led_cdev->blink_delay_off = 0;
 }
@@ -44,11 +43,6 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
 	if (!led_cdev->blink_brightness)
 		led_cdev->blink_brightness = led_cdev->max_brightness;
 
-	if (led_get_trigger_data(led_cdev) &&
-	    delay_on == led_cdev->blink_delay_on &&
-	    delay_off == led_cdev->blink_delay_off)
-		return;
-
 	led_stop_software_blink(led_cdev);
 
 	led_cdev->blink_delay_on = delay_on;
@@ -68,13 +62,12 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
 }
 
 
-void led_blink_set(struct led_classdev *led_cdev,
-		   unsigned long *delay_on,
-		   unsigned long *delay_off)
+void led_blink_setup(struct led_classdev *led_cdev,
+		     unsigned long *delay_on,
+		     unsigned long *delay_off)
 {
-	del_timer_sync(&led_cdev->blink_timer);
-
-	if (led_cdev->blink_set &&
+	if (!(led_cdev->flags & LED_BLINK_ONESHOT) &&
+	    led_cdev->blink_set &&
 	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
 		return;
 
@@ -84,8 +77,41 @@ void led_blink_set(struct led_classdev *led_cdev,
 
 	led_set_software_blink(led_cdev, *delay_on, *delay_off);
 }
+
+void led_blink_set(struct led_classdev *led_cdev,
+		   unsigned long *delay_on,
+		   unsigned long *delay_off)
+{
+	del_timer_sync(&led_cdev->blink_timer);
+
+	led_cdev->flags &= ~LED_BLINK_ONESHOT;
+	led_cdev->flags &= ~LED_BLINK_ONESHOT_STOP;
+
+	led_blink_setup(led_cdev, delay_on, delay_off);
+}
 EXPORT_SYMBOL(led_blink_set);
 
+void led_blink_set_oneshot(struct led_classdev *led_cdev,
+			   unsigned long *delay_on,
+			   unsigned long *delay_off,
+			   int invert)
+{
+	if ((led_cdev->flags & LED_BLINK_ONESHOT) &&
+	     timer_pending(&led_cdev->blink_timer))
+		return;
+
+	led_cdev->flags |= LED_BLINK_ONESHOT;
+	led_cdev->flags &= ~LED_BLINK_ONESHOT_STOP;
+
+	if (invert)
+		led_cdev->flags |= LED_BLINK_INVERT;
+	else
+		led_cdev->flags &= ~LED_BLINK_INVERT;
+
+	led_blink_setup(led_cdev, delay_on, delay_off);
+}
+EXPORT_SYMBOL(led_blink_set_oneshot);
+
 void led_brightness_set(struct led_classdev *led_cdev,
 			enum led_brightness brightness)
 {
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 46b4c76..351cbde 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -230,9 +230,11 @@ void led_trigger_event(struct led_trigger *trigger,
 }
 EXPORT_SYMBOL_GPL(led_trigger_event);
 
-void led_trigger_blink(struct led_trigger *trigger,
-		       unsigned long *delay_on,
-		       unsigned long *delay_off)
+void led_trigger_blink_setup(struct led_trigger *trigger,
+			     unsigned long *delay_on,
+			     unsigned long *delay_off,
+			     int oneshot,
+			     int invert)
 {
 	struct list_head *entry;
 
@@ -244,12 +246,32 @@ void led_trigger_blink(struct led_trigger *trigger,
 		struct led_classdev *led_cdev;
 
 		led_cdev = list_entry(entry, struct led_classdev, trig_list);
-		led_blink_set(led_cdev, delay_on, delay_off);
+		if (oneshot)
+			led_blink_set_oneshot(led_cdev, delay_on, delay_off,
+					      invert);
+		else
+			led_blink_set(led_cdev, delay_on, delay_off);
 	}
 	read_unlock(&trigger->leddev_list_lock);
 }
+
+void led_trigger_blink(struct led_trigger *trigger,
+		       unsigned long *delay_on,
+		       unsigned long *delay_off)
+{
+	led_trigger_blink_setup(trigger, delay_on, delay_off, 0, 0);
+}
 EXPORT_SYMBOL_GPL(led_trigger_blink);
 
+void led_trigger_blink_oneshot(struct led_trigger *trigger,
+			       unsigned long *delay_on,
+			       unsigned long *delay_off,
+			       int invert)
+{
+	led_trigger_blink_setup(trigger, delay_on, delay_off, 1, invert);
+}
+EXPORT_SYMBOL_GPL(led_trigger_blink_oneshot);
+
 void led_trigger_register_simple(const char *name, struct led_trigger **tp)
 {
 	struct led_trigger *trigger;
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 5884def..f252438 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -38,6 +38,9 @@ struct led_classdev {
 #define LED_SUSPENDED		(1 << 0)
 	/* Upper 16 bits reflect control information */
 #define LED_CORE_SUSPENDRESUME	(1 << 16)
+#define LED_BLINK_ONESHOT	(1 << 17)
+#define LED_BLINK_ONESHOT_STOP	(1 << 18)
+#define LED_BLINK_INVERT	(1 << 19)
 
 	/* Set LED brightness level */
 	/* Must not sleep, use a workqueue if needed */
@@ -101,6 +104,24 @@ extern void led_blink_set(struct led_classdev *led_cdev,
 			  unsigned long *delay_on,
 			  unsigned long *delay_off);
 /**
+ * led_blink_set_oneshot - do a oneshot software blink
+ * @led_cdev: the LED to start blinking
+ * @delay_on: the time it should be on (in ms)
+ * @delay_off: the time it should ble off (in ms)
+ * @invert: blink off, then on, leaving the led on
+ *
+ * This function makes the LED blink one time for delay_on +
+ * delay_off time, ignoring the request if another one-shot
+ * blink is already in progress.
+ *
+ * If invert is set, led blinks for delay_off first, then for
+ * delay_on and leave the led on after the on-off cycle.
+ */
+extern void led_blink_set_oneshot(struct led_classdev *led_cdev,
+				  unsigned long *delay_on,
+				  unsigned long *delay_off,
+				  int invert);
+/**
  * led_brightness_set - set LED brightness
  * @led_cdev: the LED to set
  * @brightness: the brightness to set it to
@@ -148,6 +169,10 @@ extern void led_trigger_event(struct led_trigger *trigger,
 extern void led_trigger_blink(struct led_trigger *trigger,
 			      unsigned long *delay_on,
 			      unsigned long *delay_off);
+extern void led_trigger_blink_oneshot(struct led_trigger *trigger,
+				      unsigned long *delay_on,
+				      unsigned long *delay_off,
+				      int invert);
 
 #else
 
-- 
1.7.5.1

