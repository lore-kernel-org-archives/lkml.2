Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab2INHxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 03:53:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50263 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab2INHxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 03:53:18 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-leds@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        fabio.baltieri@gmail.com, shuahkhan@gmail.com, raph@8d.com,
        tpiepho@freescale.com
Subject: [PATCH 1/2] leds: use workqueue in led_set_brightness() API internally
Date: Fri, 14 Sep 2012 15:53:02 +0800
Message-Id: <1347609183-26730-2-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347609183-26730-1-git-send-email-bryan.wu@canonical.com>
References: <1347609183-26730-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API function led_set_brightness() and __led_set_brightness will
call .brightness_set() function provided by led class drivers. So
.brightness_set() function will run in atomic context, which requires
led class drivers use workqueue in .brightness_set().

Finally, all the led class driver implemented their own workqueue in
.brightness_set(). For those missing this, we will face runtime warning
or error when running it in atomic context.

This patch adds a workqueue in led_set_brightness() internally. LED
class driver doesn't need to care about duplicated workqueue stuff in
their own driver.

Also this patch unified the led_set_brightness() and __led_set_brightness()

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/led-class.c          | 23 ++++++++++++-----------
 drivers/leds/led-core.c           | 15 +++++++--------
 drivers/leds/leds.h               | 11 ++---------
 drivers/leds/ledtrig-backlight.c  |  8 ++++----
 drivers/leds/ledtrig-default-on.c |  2 +-
 drivers/leds/ledtrig-gpio.c       |  6 +++---
 drivers/leds/ledtrig-heartbeat.c  |  2 +-
 drivers/leds/ledtrig-oneshot.c    |  4 ++--
 drivers/leds/ledtrig-transient.c  |  8 ++++----
 include/linux/leds.h              | 12 +++++++-----
 10 files changed, 43 insertions(+), 48 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 48cce18..7a3e886 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -53,7 +53,7 @@ static ssize_t led_brightness_store(struct device *dev,
 
 	if (state == LED_OFF)
 		led_trigger_remove(led_cdev);
-	__led_set_brightness(led_cdev, state);
+	led_set_brightness(led_cdev, state);
 
 	return size;
 }
@@ -82,7 +82,7 @@ static void led_timer_function(unsigned long data)
 	unsigned long delay;
 
 	if (!led_cdev->blink_delay_on || !led_cdev->blink_delay_off) {
-		__led_set_brightness(led_cdev, LED_OFF);
+		led_set_brightness(led_cdev, LED_OFF);
 		return;
 	}
 
@@ -105,7 +105,7 @@ static void led_timer_function(unsigned long data)
 		delay = led_cdev->blink_delay_off;
 	}
 
-	__led_set_brightness(led_cdev, brightness);
+	led_set_brightness(led_cdev, brightness);
 
 	/* Return in next iteration if led is in one-shot mode and we are in
 	 * the final blink state so that the led is toggled each delay_on +
@@ -124,14 +124,15 @@ static void led_timer_function(unsigned long data)
 	mod_timer(&led_cdev->blink_timer, jiffies + msecs_to_jiffies(delay));
 }
 
-static void set_brightness_delayed(struct work_struct *ws)
+static void led_set_brightness_work(struct work_struct *ws)
 {
 	struct led_classdev *led_cdev =
 		container_of(ws, struct led_classdev, set_brightness_work);
 
-	led_stop_software_blink(led_cdev);
+	if (led_cdev->blink_delay_on || led_cdev->blink_delay_off)
+		led_stop_software_blink(led_cdev);
 
-	__led_set_brightness(led_cdev, led_cdev->delayed_set_value);
+	led_cdev->brightness_set(led_cdev, led_cdev->brightness);
 }
 
 /**
@@ -141,7 +142,7 @@ static void set_brightness_delayed(struct work_struct *ws)
 void led_classdev_suspend(struct led_classdev *led_cdev)
 {
 	led_cdev->flags |= LED_SUSPENDED;
-	led_cdev->brightness_set(led_cdev, 0);
+	led_set_brightness(led_cdev, 0);
 }
 EXPORT_SYMBOL_GPL(led_classdev_suspend);
 
@@ -151,7 +152,7 @@ EXPORT_SYMBOL_GPL(led_classdev_suspend);
  */
 void led_classdev_resume(struct led_classdev *led_cdev)
 {
-	led_cdev->brightness_set(led_cdev, led_cdev->brightness);
+	led_set_brightness(led_cdev, led_cdev->brightness);
 	led_cdev->flags &= ~LED_SUSPENDED;
 }
 EXPORT_SYMBOL_GPL(led_classdev_resume);
@@ -201,7 +202,7 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 
 	led_update_brightness(led_cdev);
 
-	INIT_WORK(&led_cdev->set_brightness_work, set_brightness_delayed);
+	INIT_WORK(&led_cdev->set_brightness_work, led_set_brightness_work);
 
 	init_timer(&led_cdev->blink_timer);
 	led_cdev->blink_timer.function = led_timer_function;
@@ -233,12 +234,12 @@ void led_classdev_unregister(struct led_classdev *led_cdev)
 	up_write(&led_cdev->trigger_lock);
 #endif
 
-	cancel_work_sync(&led_cdev->set_brightness_work);
-
 	/* Stop blinking */
 	led_stop_software_blink(led_cdev);
 	led_set_brightness(led_cdev, LED_OFF);
 
+	flush_work(&led_cdev->set_brightness_work);
+
 	device_unregister(led_cdev->dev);
 
 	down_write(&leds_list_lock);
diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index ce8921a..c212262 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -45,7 +45,7 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
 
 	/* never off - just set to brightness */
 	if (!delay_off) {
-		__led_set_brightness(led_cdev, led_cdev->blink_brightness);
+		led_set_brightness(led_cdev, led_cdev->blink_brightness);
 		return;
 	}
 
@@ -114,13 +114,12 @@ EXPORT_SYMBOL_GPL(led_stop_software_blink);
 void led_set_brightness(struct led_classdev *led_cdev,
 			enum led_brightness brightness)
 {
-	/* delay brightness setting if need to stop soft-blink timer */
-	if (led_cdev->blink_delay_on || led_cdev->blink_delay_off) {
-		led_cdev->delayed_set_value = brightness;
-		schedule_work(&led_cdev->set_brightness_work);
-		return;
-	}
+	if (brightness > led_cdev->max_brightness)
+		brightness = led_cdev->max_brightness;
 
-	__led_set_brightness(led_cdev, brightness);
+	led_cdev->brightness = brightness;
+
+	if (!(led_cdev->flags & LED_SUSPENDED))
+		schedule_work(&led_cdev->set_brightness_work);
 }
 EXPORT_SYMBOL(led_set_brightness);
diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
index 4c50365..745bf06 100644
--- a/drivers/leds/leds.h
+++ b/drivers/leds/leds.h
@@ -17,15 +17,8 @@
 #include <linux/rwsem.h>
 #include <linux/leds.h>
 
-static inline void __led_set_brightness(struct led_classdev *led_cdev,
-					enum led_brightness value)
-{
-	if (value > led_cdev->max_brightness)
-		value = led_cdev->max_brightness;
-	led_cdev->brightness = value;
-	if (!(led_cdev->flags & LED_SUSPENDED))
-		led_cdev->brightness_set(led_cdev, value);
-}
+void led_set_brightness(struct led_classdev *led_cdev,
+				enum led_brightness value);
 
 static inline int led_get_brightness(struct led_classdev *led_cdev)
 {
diff --git a/drivers/leds/ledtrig-backlight.c b/drivers/leds/ledtrig-backlight.c
index b941685..e272686 100644
--- a/drivers/leds/ledtrig-backlight.c
+++ b/drivers/leds/ledtrig-backlight.c
@@ -46,9 +46,9 @@ static int fb_notifier_callback(struct notifier_block *p,
 
 		if ((n->old_status == UNBLANK) ^ n->invert) {
 			n->brightness = led->brightness;
-			__led_set_brightness(led, LED_OFF);
+			led_set_brightness(led, LED_OFF);
 		} else {
-			__led_set_brightness(led, n->brightness);
+			led_set_brightness(led, n->brightness);
 		}
 
 		n->old_status = new_status;
@@ -87,9 +87,9 @@ static ssize_t bl_trig_invert_store(struct device *dev,
 
 	/* After inverting, we need to update the LED. */
 	if ((n->old_status == BLANK) ^ n->invert)
-		__led_set_brightness(led, LED_OFF);
+		led_set_brightness(led, LED_OFF);
 	else
-		__led_set_brightness(led, n->brightness);
+		led_set_brightness(led, n->brightness);
 
 	return num;
 }
diff --git a/drivers/leds/ledtrig-default-on.c b/drivers/leds/ledtrig-default-on.c
index eac1f1b..a4ef54b 100644
--- a/drivers/leds/ledtrig-default-on.c
+++ b/drivers/leds/ledtrig-default-on.c
@@ -19,7 +19,7 @@
 
 static void defon_trig_activate(struct led_classdev *led_cdev)
 {
-	__led_set_brightness(led_cdev, led_cdev->max_brightness);
+	led_set_brightness(led_cdev, led_cdev->max_brightness);
 }
 
 static struct led_trigger defon_led_trigger = {
diff --git a/drivers/leds/ledtrig-gpio.c b/drivers/leds/ledtrig-gpio.c
index ba215dc..f057c10 100644
--- a/drivers/leds/ledtrig-gpio.c
+++ b/drivers/leds/ledtrig-gpio.c
@@ -54,12 +54,12 @@ static void gpio_trig_work(struct work_struct *work)
 
 	if (tmp) {
 		if (gpio_data->desired_brightness)
-			__led_set_brightness(gpio_data->led,
+			led_set_brightness(gpio_data->led,
 					   gpio_data->desired_brightness);
 		else
-			__led_set_brightness(gpio_data->led, LED_FULL);
+			led_set_brightness(gpio_data->led, LED_FULL);
 	} else {
-		__led_set_brightness(gpio_data->led, LED_OFF);
+		led_set_brightness(gpio_data->led, LED_OFF);
 	}
 }
 
diff --git a/drivers/leds/ledtrig-heartbeat.c b/drivers/leds/ledtrig-heartbeat.c
index 1edc746..a019fbb 100644
--- a/drivers/leds/ledtrig-heartbeat.c
+++ b/drivers/leds/ledtrig-heartbeat.c
@@ -74,7 +74,7 @@ static void led_heartbeat_function(unsigned long data)
 		break;
 	}
 
-	__led_set_brightness(led_cdev, brightness);
+	led_set_brightness(led_cdev, brightness);
 	mod_timer(&heartbeat_data->timer, jiffies + delay);
 }
 
diff --git a/drivers/leds/ledtrig-oneshot.c b/drivers/leds/ledtrig-oneshot.c
index 2c029aa..2b10b28 100644
--- a/drivers/leds/ledtrig-oneshot.c
+++ b/drivers/leds/ledtrig-oneshot.c
@@ -63,9 +63,9 @@ static ssize_t led_invert_store(struct device *dev,
 	oneshot_data->invert = !!state;
 
 	if (oneshot_data->invert)
-		__led_set_brightness(led_cdev, LED_FULL);
+		led_set_brightness(led_cdev, LED_FULL);
 	else
-		__led_set_brightness(led_cdev, LED_OFF);
+		led_set_brightness(led_cdev, LED_OFF);
 
 	return size;
 }
diff --git a/drivers/leds/ledtrig-transient.c b/drivers/leds/ledtrig-transient.c
index 398f104..83179f4 100644
--- a/drivers/leds/ledtrig-transient.c
+++ b/drivers/leds/ledtrig-transient.c
@@ -41,7 +41,7 @@ static void transient_timer_function(unsigned long data)
 	struct transient_trig_data *transient_data = led_cdev->trigger_data;
 
 	transient_data->activate = 0;
-	__led_set_brightness(led_cdev, transient_data->restore_state);
+	led_set_brightness(led_cdev, transient_data->restore_state);
 }
 
 static ssize_t transient_activate_show(struct device *dev,
@@ -72,7 +72,7 @@ static ssize_t transient_activate_store(struct device *dev,
 	if (state == 0 && transient_data->activate == 1) {
 		del_timer(&transient_data->timer);
 		transient_data->activate = state;
-		__led_set_brightness(led_cdev, transient_data->restore_state);
+		led_set_brightness(led_cdev, transient_data->restore_state);
 		return size;
 	}
 
@@ -80,7 +80,7 @@ static ssize_t transient_activate_store(struct device *dev,
 	if (state == 1 && transient_data->activate == 0 &&
 	    transient_data->duration != 0) {
 		transient_data->activate = state;
-		__led_set_brightness(led_cdev, transient_data->state);
+		led_set_brightness(led_cdev, transient_data->state);
 		transient_data->restore_state =
 		    (transient_data->state == LED_FULL) ? LED_OFF : LED_FULL;
 		mod_timer(&transient_data->timer,
@@ -203,7 +203,7 @@ static void transient_trig_deactivate(struct led_classdev *led_cdev)
 
 	if (led_cdev->activated) {
 		del_timer_sync(&transient_data->timer);
-		__led_set_brightness(led_cdev, transient_data->restore_state);
+		led_set_brightness(led_cdev, transient_data->restore_state);
 		device_remove_file(led_cdev->dev, &dev_attr_activate);
 		device_remove_file(led_cdev->dev, &dev_attr_duration);
 		device_remove_file(led_cdev->dev, &dev_attr_state);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 5676197..d7f5697 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -43,10 +43,15 @@ struct led_classdev {
 #define LED_BLINK_ONESHOT_STOP	(1 << 18)
 #define LED_BLINK_INVERT	(1 << 19)
 
-	/* Set LED brightness level */
-	/* Must not sleep, use a workqueue if needed */
+	/*
+	 * Set LED brightness level
+	 * use a workqueue internally, so driver writer doesn't need to
+	 * care about using duplicated workqueue in brightness_set()
+	 */
 	void		(*brightness_set)(struct led_classdev *led_cdev,
 					  enum led_brightness brightness);
+	struct work_struct	set_brightness_work;
+
 	/* Get LED brightness level */
 	enum led_brightness (*brightness_get)(struct led_classdev *led_cdev);
 
@@ -70,9 +75,6 @@ struct led_classdev {
 	struct timer_list	 blink_timer;
 	int			 blink_brightness;
 
-	struct work_struct	set_brightness_work;
-	int			delayed_set_value;
-
 #ifdef CONFIG_LEDS_TRIGGERS
 	/* Protects the trigger data below */
 	struct rw_semaphore	 trigger_lock;
-- 
1.7.11.4

