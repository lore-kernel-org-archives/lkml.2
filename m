Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416Ab2EUTpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:45:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34494 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab2EUTpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:45:23 -0400
From: Nasir Abed <nasirabed+kernel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nasir Abed <nasirabed+kernel@gmail.com>
Subject: [PATCH] Staging: android: alarm: Renamed pr_alarm to alarm_dbg
Date: Mon, 21 May 2012 21:44:50 +0200
Message-Id: <1337629490-7446-1-git-send-email-nasirabed+kernel@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I renamed a macro to make it explicit that it's for debugging and
fixed a warning about a quoted string split across multiple lines.

Signed-off-by: Nasir Abed <nasirabed+kernel@gmail.com>
---
 drivers/staging/android/alarm.c |   53 +++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/android/alarm.c b/drivers/staging/android/alarm.c
index c68950b..3fbb497 100644
--- a/drivers/staging/android/alarm.c
+++ b/drivers/staging/android/alarm.c
@@ -46,11 +46,10 @@ static int debug_mask = ANDROID_ALARM_PRINT_ERROR | \
 			ANDROID_ALARM_PRINT_INIT_STATUS;
 module_param_named(debug_mask, debug_mask, int, S_IRUGO | S_IWUSR | S_IWGRP);
 
-#define pr_alarm(debug_level_mask, args...) \
+#define alarm_dbg(debug_level_mask, fmt, ...) \
 	do { \
-		if (debug_mask & ANDROID_ALARM_PRINT_##debug_level_mask) { \
-			pr_info(args); \
-		} \
+		if (debug_mask & ANDROID_ALARM_PRINT_##debug_level_mask) \
+			pr_info(fmt, ##__VA_ARGS__); \
 	} while (0)
 
 #define ANDROID_ALARM_WAKEUP_MASK ( \
@@ -85,7 +84,7 @@ static void update_timer_locked(struct alarm_queue *base, bool head_removed)
 			base == &alarms[ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP];
 
 	if (base->stopped) {
-		pr_alarm(FLOW, "changed alarm while setting the wall time\n");
+		alarm_dbg(FLOW, "changed alarm while setting the wall time\n");
 		return;
 	}
 
@@ -97,11 +96,11 @@ static void update_timer_locked(struct alarm_queue *base, bool head_removed)
 
 	alarm = container_of(base->first, struct android_alarm, node);
 
-	pr_alarm(FLOW, "selected alarm, type %d, func %pF at %lld\n",
+	alarm_dbg(FLOW, "selected alarm, type %d, func %pF at %lld\n",
 		alarm->type, alarm->function, ktime_to_ns(alarm->expires));
 
 	if (is_wakeup && suspended) {
-		pr_alarm(FLOW, "changed alarm while suspened\n");
+		alarm_dbg(FLOW, "changed alarm while suspened\n");
 		wake_lock_timeout(&alarm_rtc_wake_lock, 1 * HZ);
 		return;
 	}
@@ -121,7 +120,7 @@ static void alarm_enqueue_locked(struct android_alarm *alarm)
 	int leftmost = 1;
 	bool was_first = false;
 
-	pr_alarm(FLOW, "added alarm, type %d, func %pF at %lld\n",
+	alarm_dbg(FLOW, "added alarm, type %d, func %pF at %lld\n",
 		alarm->type, alarm->function, ktime_to_ns(alarm->expires));
 
 	if (base->first == &alarm->node) {
@@ -169,7 +168,7 @@ void android_alarm_init(struct android_alarm *alarm,
 	alarm->type = type;
 	alarm->function = function;
 
-	pr_alarm(FLOW, "created alarm, type %d, func %pF\n", type, function);
+	alarm_dbg(FLOW, "created alarm, type %d, func %pF\n", type, function);
 }
 
 
@@ -210,7 +209,7 @@ int android_alarm_try_to_cancel(struct android_alarm *alarm)
 
 	spin_lock_irqsave(&alarm_slock, flags);
 	if (!RB_EMPTY_NODE(&alarm->node)) {
-		pr_alarm(FLOW, "canceled alarm, type %d, func %pF at %lld\n",
+		alarm_dbg(FLOW, "canceled alarm, type %d, func %pF at %lld\n",
 			alarm->type, alarm->function,
 			ktime_to_ns(alarm->expires));
 		ret = 1;
@@ -223,7 +222,7 @@ int android_alarm_try_to_cancel(struct android_alarm *alarm)
 		if (first)
 			update_timer_locked(base, true);
 	} else
-		pr_alarm(FLOW, "tried to cancel alarm, type %d, func %pF\n",
+		alarm_dbg(FLOW, "tried to cancel alarm, type %d, func %pF\n",
 			alarm->type, alarm->function);
 	spin_unlock_irqrestore(&alarm_slock, flags);
 	if (!ret && hrtimer_callback_running(&base->timer))
@@ -263,7 +262,7 @@ int android_alarm_set_rtc(struct timespec new_time)
 
 	rtc_time_to_tm(new_time.tv_sec, &rtc_new_rtc_time);
 
-	pr_alarm(TSET, "set rtc %ld %ld - rtc %02d:%02d:%02d %02d/%02d/%04d\n",
+	alarm_dbg(TSET, "set rtc %ld %ld - rtc %02d:%02d:%02d %02d/%02d/%04d\n",
 		new_time.tv_sec, new_time.tv_nsec,
 		rtc_new_rtc_time.tm_hour, rtc_new_rtc_time.tm_min,
 		rtc_new_rtc_time.tm_sec, rtc_new_rtc_time.tm_mon + 1,
@@ -292,18 +291,18 @@ int android_alarm_set_rtc(struct timespec new_time)
 	}
 	spin_unlock_irqrestore(&alarm_slock, flags);
 	if (ret < 0) {
-		pr_alarm(ERROR, "alarm_set_rtc: Failed to set time\n");
+		alarm_dbg(ERROR, "alarm_set_rtc: Failed to set time\n");
 		goto err;
 	}
 	if (!alarm_rtc_dev) {
-		pr_alarm(ERROR,
+		alarm_dbg(ERROR,
 			"alarm_set_rtc: no RTC, time will be lost on reboot\n");
 		goto err;
 	}
 	ret = rtc_set_time(alarm_rtc_dev, &rtc_new_rtc_time);
 	if (ret < 0)
-		pr_alarm(ERROR, "alarm_set_rtc: "
-			"Failed to set RTC, time will be lost on reboot\n");
+		alarm_dbg(ERROR,
+			"alarm_set_rtc: Failed to set RTC, time will be lost on reboot\n");
 err:
 	wake_unlock(&alarm_rtc_wake_lock);
 	mutex_unlock(&alarm_setrtc_mutex);
@@ -341,13 +340,13 @@ static enum hrtimer_restart alarm_timer_triggered(struct hrtimer *timer)
 	now = base->stopped ? base->stopped_time : hrtimer_cb_get_time(timer);
 	now = ktime_sub(now, base->delta);
 
-	pr_alarm(INT, "alarm_timer_triggered type %ld at %lld\n",
+	alarm_dbg(INT, "alarm_timer_triggered type %ld at %lld\n",
 		base - alarms, ktime_to_ns(now));
 
 	while (base->first) {
 		alarm = container_of(base->first, struct android_alarm, node);
 		if (alarm->softexpires.tv64 > now.tv64) {
-			pr_alarm(FLOW, "don't call alarm, %pF, %lld (s %lld)\n",
+			alarm_dbg(FLOW, "don't call alarm, %pF, %lld (s %lld)\n",
 				alarm->function, ktime_to_ns(alarm->expires),
 				ktime_to_ns(alarm->softexpires));
 			break;
@@ -355,7 +354,7 @@ static enum hrtimer_restart alarm_timer_triggered(struct hrtimer *timer)
 		base->first = rb_next(&alarm->node);
 		rb_erase(&alarm->node, &base->alarms);
 		RB_CLEAR_NODE(&alarm->node);
-		pr_alarm(CALL, "call alarm, type %d, func %pF, %lld (s %lld)\n",
+		alarm_dbg(CALL, "call alarm, type %d, func %pF, %lld (s %lld)\n",
 			alarm->type, alarm->function,
 			ktime_to_ns(alarm->expires),
 			ktime_to_ns(alarm->softexpires));
@@ -364,7 +363,7 @@ static enum hrtimer_restart alarm_timer_triggered(struct hrtimer *timer)
 		spin_lock_irqsave(&alarm_slock, flags);
 	}
 	if (!base->first)
-		pr_alarm(FLOW, "no more alarms of type %ld\n", base - alarms);
+		alarm_dbg(FLOW, "no more alarms of type %ld\n", base - alarms);
 	update_timer_locked(base, true);
 	spin_unlock_irqrestore(&alarm_slock, flags);
 	return HRTIMER_NORESTART;
@@ -375,7 +374,7 @@ static void alarm_triggered_func(void *p)
 	struct rtc_device *rtc = alarm_rtc_dev;
 	if (!(rtc->irq_data & RTC_AF))
 		return;
-	pr_alarm(INT, "rtc alarm triggered\n");
+	alarm_dbg(INT, "rtc alarm triggered\n");
 	wake_lock_timeout(&alarm_rtc_wake_lock, 1 * HZ);
 }
 
@@ -392,7 +391,7 @@ static int alarm_suspend(struct platform_device *pdev, pm_message_t state)
 	struct alarm_queue *wakeup_queue = NULL;
 	struct alarm_queue *tmp_queue = NULL;
 
-	pr_alarm(SUSPEND, "alarm_suspend(%p, %d)\n", pdev, state.event);
+	alarm_dbg(SUSPEND, "alarm_suspend(%p, %d)\n", pdev, state.event);
 
 	spin_lock_irqsave(&alarm_slock, flags);
 	suspended = true;
@@ -427,12 +426,12 @@ static int alarm_suspend(struct platform_device *pdev, pm_message_t state)
 		rtc_set_alarm(alarm_rtc_dev, &rtc_alarm);
 		rtc_read_time(alarm_rtc_dev, &rtc_current_rtc_time);
 		rtc_tm_to_time(&rtc_current_rtc_time, &rtc_current_time);
-		pr_alarm(SUSPEND,
+		alarm_dbg(SUSPEND,
 			"rtc alarm set at %ld, now %ld, rtc delta %ld.%09ld\n",
 			rtc_alarm_time, rtc_current_time,
 			rtc_delta.tv_sec, rtc_delta.tv_nsec);
 		if (rtc_current_time + 1 >= rtc_alarm_time) {
-			pr_alarm(SUSPEND, "alarm about to go off\n");
+			alarm_dbg(SUSPEND, "alarm about to go off\n");
 			memset(&rtc_alarm, 0, sizeof(rtc_alarm));
 			rtc_alarm.enabled = 0;
 			rtc_set_alarm(alarm_rtc_dev, &rtc_alarm);
@@ -456,7 +455,7 @@ static int alarm_resume(struct platform_device *pdev)
 	struct rtc_wkalrm alarm;
 	unsigned long       flags;
 
-	pr_alarm(SUSPEND, "alarm_resume(%p)\n", pdev);
+	alarm_dbg(SUSPEND, "alarm_resume(%p)\n", pdev);
 
 	memset(&alarm, 0, sizeof(alarm));
 	alarm.enabled = 0;
@@ -499,7 +498,7 @@ static int rtc_alarm_add_device(struct device *dev,
 	if (err)
 		goto err3;
 	alarm_rtc_dev = rtc;
-	pr_alarm(INIT_STATUS, "using rtc device, %s, for alarms", rtc->name);
+	alarm_dbg(INIT_STATUS, "using rtc device, %s, for alarms", rtc->name);
 	mutex_unlock(&alarm_setrtc_mutex);
 
 	return 0;
@@ -516,7 +515,7 @@ static void rtc_alarm_remove_device(struct device *dev,
 				    struct class_interface *class_intf)
 {
 	if (dev == &alarm_rtc_dev->dev) {
-		pr_alarm(INIT_STATUS, "lost rtc device for alarms");
+		alarm_dbg(INIT_STATUS, "lost rtc device for alarms");
 		rtc_irq_unregister(alarm_rtc_dev, &alarm_rtc_task);
 		platform_device_unregister(alarm_platform_dev);
 		alarm_rtc_dev = NULL;
-- 
1.7.9.5

