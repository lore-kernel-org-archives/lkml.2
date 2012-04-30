Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab2D3HiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 03:38:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39975 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab2D3Hh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 03:37:58 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org,
        tim.gardner@canonical.com
Subject: [PATCH 01/19] led-triggers: rename *trigger to *trig for unified naming scheme
Date: Mon, 30 Apr 2012 15:37:06 +0800
Message-Id: <1335771444-26361-2-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1335771444-26361-1-git-send-email-bryan.wu@canonical.com>
References: <1335771444-26361-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/led-triggers.c |   84 +++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 46b4c76..b449ed8 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -99,7 +99,7 @@ ssize_t led_trigger_show(struct device *dev, struct device_attribute *attr,
 EXPORT_SYMBOL_GPL(led_trigger_show);
 
 /* Caller must ensure led_cdev->trigger_lock held */
-void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
+void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 {
 	unsigned long flags;
 
@@ -114,13 +114,13 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
 		led_cdev->trigger = NULL;
 		led_brightness_set(led_cdev, LED_OFF);
 	}
-	if (trigger) {
-		write_lock_irqsave(&trigger->leddev_list_lock, flags);
-		list_add_tail(&led_cdev->trig_list, &trigger->led_cdevs);
-		write_unlock_irqrestore(&trigger->leddev_list_lock, flags);
-		led_cdev->trigger = trigger;
-		if (trigger->activate)
-			trigger->activate(led_cdev);
+	if (trig) {
+		write_lock_irqsave(&trig->leddev_list_lock, flags);
+		list_add_tail(&led_cdev->trig_list, &trig->led_cdevs);
+		write_unlock_irqrestore(&trig->leddev_list_lock, flags);
+		led_cdev->trigger = trig;
+		if (trig->activate)
+			trig->activate(led_cdev);
 	}
 }
 EXPORT_SYMBOL_GPL(led_trigger_set);
@@ -153,24 +153,24 @@ EXPORT_SYMBOL_GPL(led_trigger_set_default);
 
 /* LED Trigger Interface */
 
-int led_trigger_register(struct led_trigger *trigger)
+int led_trigger_register(struct led_trigger *trig)
 {
 	struct led_classdev *led_cdev;
-	struct led_trigger *trig;
+	struct led_trigger *_trig;
 
-	rwlock_init(&trigger->leddev_list_lock);
-	INIT_LIST_HEAD(&trigger->led_cdevs);
+	rwlock_init(&trig->leddev_list_lock);
+	INIT_LIST_HEAD(&trig->led_cdevs);
 
 	down_write(&triggers_list_lock);
 	/* Make sure the trigger's name isn't already in use */
-	list_for_each_entry(trig, &trigger_list, next_trig) {
-		if (!strcmp(trig->name, trigger->name)) {
+	list_for_each_entry(_trig, &trigger_list, next_trig) {
+		if (!strcmp(_trig->name, trig->name)) {
 			up_write(&triggers_list_lock);
 			return -EEXIST;
 		}
 	}
 	/* Add to the list of led triggers */
-	list_add_tail(&trigger->next_trig, &trigger_list);
+	list_add_tail(&trig->next_trig, &trigger_list);
 	up_write(&triggers_list_lock);
 
 	/* Register with any LEDs that have this as a default trigger */
@@ -178,8 +178,8 @@ int led_trigger_register(struct led_trigger *trigger)
 	list_for_each_entry(led_cdev, &leds_list, node) {
 		down_write(&led_cdev->trigger_lock);
 		if (!led_cdev->trigger && led_cdev->default_trigger &&
-			    !strcmp(led_cdev->default_trigger, trigger->name))
-			led_trigger_set(led_cdev, trigger);
+			    !strcmp(led_cdev->default_trigger, trig->name))
+			led_trigger_set(led_cdev, trig);
 		up_write(&led_cdev->trigger_lock);
 	}
 	up_read(&leds_list_lock);
@@ -188,20 +188,20 @@ int led_trigger_register(struct led_trigger *trigger)
 }
 EXPORT_SYMBOL_GPL(led_trigger_register);
 
-void led_trigger_unregister(struct led_trigger *trigger)
+void led_trigger_unregister(struct led_trigger *trig)
 {
 	struct led_classdev *led_cdev;
 
 	/* Remove from the list of led triggers */
 	down_write(&triggers_list_lock);
-	list_del(&trigger->next_trig);
+	list_del(&trig->next_trig);
 	up_write(&triggers_list_lock);
 
 	/* Remove anyone actively using this trigger */
 	down_read(&leds_list_lock);
 	list_for_each_entry(led_cdev, &leds_list, node) {
 		down_write(&led_cdev->trigger_lock);
-		if (led_cdev->trigger == trigger)
+		if (led_cdev->trigger == trig)
 			led_trigger_set(led_cdev, NULL);
 		up_write(&led_cdev->trigger_lock);
 	}
@@ -211,58 +211,58 @@ EXPORT_SYMBOL_GPL(led_trigger_unregister);
 
 /* Simple LED Tigger Interface */
 
-void led_trigger_event(struct led_trigger *trigger,
+void led_trigger_event(struct led_trigger *trig,
 			enum led_brightness brightness)
 {
 	struct list_head *entry;
 
-	if (!trigger)
+	if (!trig)
 		return;
 
-	read_lock(&trigger->leddev_list_lock);
-	list_for_each(entry, &trigger->led_cdevs) {
+	read_lock(&trig->leddev_list_lock);
+	list_for_each(entry, &trig->led_cdevs) {
 		struct led_classdev *led_cdev;
 
 		led_cdev = list_entry(entry, struct led_classdev, trig_list);
 		led_set_brightness(led_cdev, brightness);
 	}
-	read_unlock(&trigger->leddev_list_lock);
+	read_unlock(&trig->leddev_list_lock);
 }
 EXPORT_SYMBOL_GPL(led_trigger_event);
 
-void led_trigger_blink(struct led_trigger *trigger,
+void led_trigger_blink(struct led_trigger *trig,
 		       unsigned long *delay_on,
 		       unsigned long *delay_off)
 {
 	struct list_head *entry;
 
-	if (!trigger)
+	if (!trig)
 		return;
 
-	read_lock(&trigger->leddev_list_lock);
-	list_for_each(entry, &trigger->led_cdevs) {
+	read_lock(&trig->leddev_list_lock);
+	list_for_each(entry, &trig->led_cdevs) {
 		struct led_classdev *led_cdev;
 
 		led_cdev = list_entry(entry, struct led_classdev, trig_list);
 		led_blink_set(led_cdev, delay_on, delay_off);
 	}
-	read_unlock(&trigger->leddev_list_lock);
+	read_unlock(&trig->leddev_list_lock);
 }
 EXPORT_SYMBOL_GPL(led_trigger_blink);
 
 void led_trigger_register_simple(const char *name, struct led_trigger **tp)
 {
-	struct led_trigger *trigger;
+	struct led_trigger *trig;
 	int err;
 
-	trigger = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
+	trig = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
 
-	if (trigger) {
-		trigger->name = name;
-		err = led_trigger_register(trigger);
+	if (trig) {
+		trig->name = name;
+		err = led_trigger_register(trig);
 		if (err < 0) {
-			kfree(trigger);
-			trigger = NULL;
+			kfree(trig);
+			trig = NULL;
 			printk(KERN_WARNING "LED trigger %s failed to register"
 				" (%d)\n", name, err);
 		}
@@ -270,15 +270,15 @@ void led_trigger_register_simple(const char *name, struct led_trigger **tp)
 		printk(KERN_WARNING "LED trigger %s failed to register"
 			" (no memory)\n", name);
 
-	*tp = trigger;
+	*tp = trig;
 }
 EXPORT_SYMBOL_GPL(led_trigger_register_simple);
 
-void led_trigger_unregister_simple(struct led_trigger *trigger)
+void led_trigger_unregister_simple(struct led_trigger *trig)
 {
-	if (trigger)
-		led_trigger_unregister(trigger);
-	kfree(trigger);
+	if (trig)
+		led_trigger_unregister(trig);
+	kfree(trig);
 }
 EXPORT_SYMBOL_GPL(led_trigger_unregister_simple);
 
-- 
1.7.9.5

