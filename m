Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab1AKNsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 08:48:37 -0500
Received: from www.tglx.de ([62.245.132.106]:39827 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab1AKNsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 08:48:33 -0500
Date: Tue, 11 Jan 2011 14:48:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timers/rtc for 2.6.38
Message-ID: <alpine.LFD.2.00.1101111446240.12146@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus

Thanks,

	tglx

------------------>
John Stultz (2):
      RTC: Rework RTC code to use timerqueue for events
      RTC: Remove UIE emulation

Thomas Gleixner (1):
      rtc: Namespace fixup


 drivers/rtc/class.c     |   13 +
 drivers/rtc/interface.c |  574 ++++++++++++++++++++++++++++------------------
 drivers/rtc/rtc-dev.c   |  104 ---------
 drivers/rtc/rtc-lib.c   |   28 +++
 include/linux/rtc.h     |   51 +++--
 5 files changed, 426 insertions(+), 344 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 565562b..3243832 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -16,6 +16,7 @@
 #include <linux/kdev_t.h>
 #include <linux/idr.h>
 #include <linux/slab.h>
+#include <linux/workqueue.h>
 
 #include "rtc-core.h"
 
@@ -152,6 +153,18 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 	spin_lock_init(&rtc->irq_task_lock);
 	init_waitqueue_head(&rtc->irq_queue);
 
+	/* Init timerqueue */
+	timerqueue_init_head(&rtc->timerqueue);
+	INIT_WORK(&rtc->irqwork, rtc_timer_do_work);
+	/* Init aie timer */
+	rtc_timer_init(&rtc->aie_timer, rtc_aie_update_irq, (void *)rtc);
+	/* Init uie timer */
+	rtc_timer_init(&rtc->uie_rtctimer, rtc_uie_update_irq, (void *)rtc);
+	/* Init pie timer */
+	hrtimer_init(&rtc->pie_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	rtc->pie_timer.function = rtc_pie_update_irq;
+	rtc->pie_enabled = 0;
+
 	strlcpy(rtc->name, name, RTC_DEVICE_NAME_SIZE);
 	dev_set_name(&rtc->dev, "rtc%d", id);
 
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index a0c8162..90384b9 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -14,15 +14,11 @@
 #include <linux/rtc.h>
 #include <linux/sched.h>
 #include <linux/log2.h>
+#include <linux/workqueue.h>
 
-int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm)
+static int __rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm)
 {
 	int err;
-
-	err = mutex_lock_interruptible(&rtc->ops_lock);
-	if (err)
-		return err;
-
 	if (!rtc->ops)
 		err = -ENODEV;
 	else if (!rtc->ops->read_time)
@@ -31,7 +27,18 @@ int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm)
 		memset(tm, 0, sizeof(struct rtc_time));
 		err = rtc->ops->read_time(rtc->dev.parent, tm);
 	}
+	return err;
+}
+
+int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm)
+{
+	int err;
 
+	err = mutex_lock_interruptible(&rtc->ops_lock);
+	if (err)
+		return err;
+
+	err = __rtc_read_time(rtc, tm);
 	mutex_unlock(&rtc->ops_lock);
 	return err;
 }
@@ -106,188 +113,54 @@ int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs)
 }
 EXPORT_SYMBOL_GPL(rtc_set_mmss);
 
-static int rtc_read_alarm_internal(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
+int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 {
 	int err;
 
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
 		return err;
-
-	if (rtc->ops == NULL)
-		err = -ENODEV;
-	else if (!rtc->ops->read_alarm)
-		err = -EINVAL;
-	else {
-		memset(alarm, 0, sizeof(struct rtc_wkalrm));
-		err = rtc->ops->read_alarm(rtc->dev.parent, alarm);
-	}
-
+	alarm->enabled = rtc->aie_timer.enabled;
+	if (alarm->enabled)
+		alarm->time = rtc_ktime_to_tm(rtc->aie_timer.node.expires);
 	mutex_unlock(&rtc->ops_lock);
-	return err;
+
+	return 0;
 }
+EXPORT_SYMBOL_GPL(rtc_read_alarm);
 
-int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
+int __rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 {
+	struct rtc_time tm;
+	long now, scheduled;
 	int err;
-	struct rtc_time before, now;
-	int first_time = 1;
-	unsigned long t_now, t_alm;
-	enum { none, day, month, year } missing = none;
-	unsigned days;
-
-	/* The lower level RTC driver may return -1 in some fields,
-	 * creating invalid alarm->time values, for reasons like:
-	 *
-	 *   - The hardware may not be capable of filling them in;
-	 *     many alarms match only on time-of-day fields, not
-	 *     day/month/year calendar data.
-	 *
-	 *   - Some hardware uses illegal values as "wildcard" match
-	 *     values, which non-Linux firmware (like a BIOS) may try
-	 *     to set up as e.g. "alarm 15 minutes after each hour".
-	 *     Linux uses only oneshot alarms.
-	 *
-	 * When we see that here, we deal with it by using values from
-	 * a current RTC timestamp for any missing (-1) values.  The
-	 * RTC driver prevents "periodic alarm" modes.
-	 *
-	 * But this can be racey, because some fields of the RTC timestamp
-	 * may have wrapped in the interval since we read the RTC alarm,
-	 * which would lead to us inserting inconsistent values in place
-	 * of the -1 fields.
-	 *
-	 * Reading the alarm and timestamp in the reverse sequence
-	 * would have the same race condition, and not solve the issue.
-	 *
-	 * So, we must first read the RTC timestamp,
-	 * then read the RTC alarm value,
-	 * and then read a second RTC timestamp.
-	 *
-	 * If any fields of the second timestamp have changed
-	 * when compared with the first timestamp, then we know
-	 * our timestamp may be inconsistent with that used by
-	 * the low-level rtc_read_alarm_internal() function.
-	 *
-	 * So, when the two timestamps disagree, we just loop and do
-	 * the process again to get a fully consistent set of values.
-	 *
-	 * This could all instead be done in the lower level driver,
-	 * but since more than one lower level RTC implementation needs it,
-	 * then it's probably best best to do it here instead of there..
-	 */
 
-	/* Get the "before" timestamp */
-	err = rtc_read_time(rtc, &before);
-	if (err < 0)
+	err = rtc_valid_tm(&alarm->time);
+	if (err)
 		return err;
-	do {
-		if (!first_time)
-			memcpy(&before, &now, sizeof(struct rtc_time));
-		first_time = 0;
-
-		/* get the RTC alarm values, which may be incomplete */
-		err = rtc_read_alarm_internal(rtc, alarm);
-		if (err)
-			return err;
-		if (!alarm->enabled)
-			return 0;
-
-		/* full-function RTCs won't have such missing fields */
-		if (rtc_valid_tm(&alarm->time) == 0)
-			return 0;
-
-		/* get the "after" timestamp, to detect wrapped fields */
-		err = rtc_read_time(rtc, &now);
-		if (err < 0)
-			return err;
-
-		/* note that tm_sec is a "don't care" value here: */
-	} while (   before.tm_min   != now.tm_min
-		 || before.tm_hour  != now.tm_hour
-		 || before.tm_mon   != now.tm_mon
-		 || before.tm_year  != now.tm_year);
-
-	/* Fill in the missing alarm fields using the timestamp; we
-	 * know there's at least one since alarm->time is invalid.
-	 */
-	if (alarm->time.tm_sec == -1)
-		alarm->time.tm_sec = now.tm_sec;
-	if (alarm->time.tm_min == -1)
-		alarm->time.tm_min = now.tm_min;
-	if (alarm->time.tm_hour == -1)
-		alarm->time.tm_hour = now.tm_hour;
-
-	/* For simplicity, only support date rollover for now */
-	if (alarm->time.tm_mday == -1) {
-		alarm->time.tm_mday = now.tm_mday;
-		missing = day;
-	}
-	if (alarm->time.tm_mon == -1) {
-		alarm->time.tm_mon = now.tm_mon;
-		if (missing == none)
-			missing = month;
-	}
-	if (alarm->time.tm_year == -1) {
-		alarm->time.tm_year = now.tm_year;
-		if (missing == none)
-			missing = year;
-	}
-
-	/* with luck, no rollover is needed */
-	rtc_tm_to_time(&now, &t_now);
-	rtc_tm_to_time(&alarm->time, &t_alm);
-	if (t_now < t_alm)
-		goto done;
-
-	switch (missing) {
+	rtc_tm_to_time(&alarm->time, &scheduled);
 
-	/* 24 hour rollover ... if it's now 10am Monday, an alarm that
-	 * that will trigger at 5am will do so at 5am Tuesday, which
-	 * could also be in the next month or year.  This is a common
-	 * case, especially for PCs.
-	 */
-	case day:
-		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "day");
-		t_alm += 24 * 60 * 60;
-		rtc_time_to_tm(t_alm, &alarm->time);
-		break;
-
-	/* Month rollover ... if it's the 31th, an alarm on the 3rd will
-	 * be next month.  An alarm matching on the 30th, 29th, or 28th
-	 * may end up in the month after that!  Many newer PCs support
-	 * this type of alarm.
+	/* Make sure we're not setting alarms in the past */
+	err = __rtc_read_time(rtc, &tm);
+	rtc_tm_to_time(&tm, &now);
+	if (scheduled <= now)
+		return -ETIME;
+	/*
+	 * XXX - We just checked to make sure the alarm time is not
+	 * in the past, but there is still a race window where if
+	 * the is alarm set for the next second and the second ticks
+	 * over right here, before we set the alarm.
 	 */
-	case month:
-		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "month");
-		do {
-			if (alarm->time.tm_mon < 11)
-				alarm->time.tm_mon++;
-			else {
-				alarm->time.tm_mon = 0;
-				alarm->time.tm_year++;
-			}
-			days = rtc_month_days(alarm->time.tm_mon,
-					alarm->time.tm_year);
-		} while (days < alarm->time.tm_mday);
-		break;
-
-	/* Year rollover ... easy except for leap years! */
-	case year:
-		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "year");
-		do {
-			alarm->time.tm_year++;
-		} while (rtc_valid_tm(&alarm->time) != 0);
-		break;
-
-	default:
-		dev_warn(&rtc->dev, "alarm rollover not handled\n");
-	}
 
-done:
-	return 0;
+	if (!rtc->ops)
+		err = -ENODEV;
+	else if (!rtc->ops->set_alarm)
+		err = -EINVAL;
+	else
+		err = rtc->ops->set_alarm(rtc->dev.parent, alarm);
+
+	return err;
 }
-EXPORT_SYMBOL_GPL(rtc_read_alarm);
 
 int rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 {
@@ -300,16 +173,18 @@ int rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
 		return err;
-
-	if (!rtc->ops)
-		err = -ENODEV;
-	else if (!rtc->ops->set_alarm)
-		err = -EINVAL;
-	else
-		err = rtc->ops->set_alarm(rtc->dev.parent, alarm);
-
+	if (rtc->aie_timer.enabled) {
+		rtc_timer_remove(rtc, &rtc->aie_timer);
+		rtc->aie_timer.enabled = 0;
+	}
+	rtc->aie_timer.node.expires = rtc_tm_to_ktime(alarm->time);
+	rtc->aie_timer.period = ktime_set(0, 0);
+	if (alarm->enabled) {
+		rtc->aie_timer.enabled = 1;
+		rtc_timer_enqueue(rtc, &rtc->aie_timer);
+	}
 	mutex_unlock(&rtc->ops_lock);
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(rtc_set_alarm);
 
@@ -319,6 +194,16 @@ int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 	if (err)
 		return err;
 
+	if (rtc->aie_timer.enabled != enabled) {
+		if (enabled) {
+			rtc->aie_timer.enabled = 1;
+			rtc_timer_enqueue(rtc, &rtc->aie_timer);
+		} else {
+			rtc_timer_remove(rtc, &rtc->aie_timer);
+			rtc->aie_timer.enabled = 0;
+		}
+	}
+
 	if (!rtc->ops)
 		err = -ENODEV;
 	else if (!rtc->ops->alarm_irq_enable)
@@ -337,52 +222,53 @@ int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 	if (err)
 		return err;
 
-#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
-	if (enabled == 0 && rtc->uie_irq_active) {
-		mutex_unlock(&rtc->ops_lock);
-		return rtc_dev_update_irq_enable_emul(rtc, enabled);
+	/* make sure we're changing state */
+	if (rtc->uie_rtctimer.enabled == enabled)
+		goto out;
+
+	if (enabled) {
+		struct rtc_time tm;
+		ktime_t now, onesec;
+
+		__rtc_read_time(rtc, &tm);
+		onesec = ktime_set(1, 0);
+		now = rtc_tm_to_ktime(tm);
+		rtc->uie_rtctimer.node.expires = ktime_add(now, onesec);
+		rtc->uie_rtctimer.period = ktime_set(1, 0);
+		rtc->uie_rtctimer.enabled = 1;
+		rtc_timer_enqueue(rtc, &rtc->uie_rtctimer);
+	} else {
+		rtc_timer_remove(rtc, &rtc->uie_rtctimer);
+		rtc->uie_rtctimer.enabled = 0;
 	}
-#endif
-
-	if (!rtc->ops)
-		err = -ENODEV;
-	else if (!rtc->ops->update_irq_enable)
-		err = -EINVAL;
-	else
-		err = rtc->ops->update_irq_enable(rtc->dev.parent, enabled);
 
+out:
 	mutex_unlock(&rtc->ops_lock);
-
-#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
-	/*
-	 * Enable emulation if the driver did not provide
-	 * the update_irq_enable function pointer or if returned
-	 * -EINVAL to signal that it has been configured without
-	 * interrupts or that are not available at the moment.
-	 */
-	if (err == -EINVAL)
-		err = rtc_dev_update_irq_enable_emul(rtc, enabled);
-#endif
 	return err;
+
 }
 EXPORT_SYMBOL_GPL(rtc_update_irq_enable);
 
+
 /**
- * rtc_update_irq - report RTC periodic, alarm, and/or update irqs
- * @rtc: the rtc device
- * @num: how many irqs are being reported (usually one)
- * @events: mask of RTC_IRQF with one or more of RTC_PF, RTC_AF, RTC_UF
- * Context: any
+ * rtc_handle_legacy_irq - AIE, UIE and PIE event hook
+ * @rtc: pointer to the rtc device
+ *
+ * This function is called when an AIE, UIE or PIE mode interrupt
+ * has occured (or been emulated).
+ *
+ * Triggers the registered irq_task function callback.
  */
-void rtc_update_irq(struct rtc_device *rtc,
-		unsigned long num, unsigned long events)
+static void rtc_handle_legacy_irq(struct rtc_device *rtc, int num, int mode)
 {
 	unsigned long flags;
 
+	/* mark one irq of the appropriate mode */
 	spin_lock_irqsave(&rtc->irq_lock, flags);
-	rtc->irq_data = (rtc->irq_data + (num << 8)) | events;
+	rtc->irq_data = (rtc->irq_data + (num << 8)) | (RTC_IRQF|mode);
 	spin_unlock_irqrestore(&rtc->irq_lock, flags);
 
+	/* call the task func */
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task)
 		rtc->irq_task->func(rtc->irq_task->private_data);
@@ -391,6 +277,69 @@ void rtc_update_irq(struct rtc_device *rtc,
 	wake_up_interruptible(&rtc->irq_queue);
 	kill_fasync(&rtc->async_queue, SIGIO, POLL_IN);
 }
+
+
+/**
+ * rtc_aie_update_irq - AIE mode rtctimer hook
+ * @private: pointer to the rtc_device
+ *
+ * This functions is called when the aie_timer expires.
+ */
+void rtc_aie_update_irq(void *private)
+{
+	struct rtc_device *rtc = (struct rtc_device *)private;
+	rtc_handle_legacy_irq(rtc, 1, RTC_AF);
+}
+
+
+/**
+ * rtc_uie_update_irq - UIE mode rtctimer hook
+ * @private: pointer to the rtc_device
+ *
+ * This functions is called when the uie_timer expires.
+ */
+void rtc_uie_update_irq(void *private)
+{
+	struct rtc_device *rtc = (struct rtc_device *)private;
+	rtc_handle_legacy_irq(rtc, 1,  RTC_UF);
+}
+
+
+/**
+ * rtc_pie_update_irq - PIE mode hrtimer hook
+ * @timer: pointer to the pie mode hrtimer
+ *
+ * This function is used to emulate PIE mode interrupts
+ * using an hrtimer. This function is called when the periodic
+ * hrtimer expires.
+ */
+enum hrtimer_restart rtc_pie_update_irq(struct hrtimer *timer)
+{
+	struct rtc_device *rtc;
+	ktime_t period;
+	int count;
+	rtc = container_of(timer, struct rtc_device, pie_timer);
+
+	period = ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
+	count = hrtimer_forward_now(timer, period);
+
+	rtc_handle_legacy_irq(rtc, count, RTC_PF);
+
+	return HRTIMER_RESTART;
+}
+
+/**
+ * rtc_update_irq - Triggered when a RTC interrupt occurs.
+ * @rtc: the rtc device
+ * @num: how many irqs are being reported (usually one)
+ * @events: mask of RTC_IRQF with one or more of RTC_PF, RTC_AF, RTC_UF
+ * Context: any
+ */
+void rtc_update_irq(struct rtc_device *rtc,
+		unsigned long num, unsigned long events)
+{
+	schedule_work(&rtc->irqwork);
+}
 EXPORT_SYMBOL_GPL(rtc_update_irq);
 
 static int __rtc_match(struct device *dev, void *data)
@@ -477,18 +426,20 @@ int rtc_irq_set_state(struct rtc_device *rtc, struct rtc_task *task, int enabled
 	int err = 0;
 	unsigned long flags;
 
-	if (rtc->ops->irq_set_state == NULL)
-		return -ENXIO;
-
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
 	if (rtc->irq_task != task)
 		err = -EACCES;
-	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 
-	if (err == 0)
-		err = rtc->ops->irq_set_state(rtc->dev.parent, enabled);
+	if (enabled) {
+		ktime_t period = ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
+		hrtimer_start(&rtc->pie_timer, period, HRTIMER_MODE_REL);
+	} else {
+		hrtimer_cancel(&rtc->pie_timer);
+	}
+	rtc->pie_enabled = enabled;
+	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 
 	return err;
 }
@@ -509,21 +460,194 @@ int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
 	int err = 0;
 	unsigned long flags;
 
-	if (rtc->ops->irq_set_freq == NULL)
-		return -ENXIO;
-
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
 	if (rtc->irq_task != task)
 		err = -EACCES;
-	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
-
 	if (err == 0) {
-		err = rtc->ops->irq_set_freq(rtc->dev.parent, freq);
-		if (err == 0)
-			rtc->irq_freq = freq;
+		rtc->irq_freq = freq;
+		if (rtc->pie_enabled) {
+			ktime_t period;
+			hrtimer_cancel(&rtc->pie_timer);
+			period = ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
+			hrtimer_start(&rtc->pie_timer, period,
+					HRTIMER_MODE_REL);
+		}
 	}
+	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_irq_set_freq);
+
+/**
+ * rtc_timer_enqueue - Adds a rtc_timer to the rtc_device timerqueue
+ * @rtc rtc device
+ * @timer timer being added.
+ *
+ * Enqueues a timer onto the rtc devices timerqueue and sets
+ * the next alarm event appropriately.
+ *
+ * Must hold ops_lock for proper serialization of timerqueue
+ */
+void rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
+{
+	timerqueue_add(&rtc->timerqueue, &timer->node);
+	if (&timer->node == timerqueue_getnext(&rtc->timerqueue)) {
+		struct rtc_wkalrm alarm;
+		int err;
+		alarm.time = rtc_ktime_to_tm(timer->node.expires);
+		alarm.enabled = 1;
+		err = __rtc_set_alarm(rtc, &alarm);
+		if (err == -ETIME)
+			schedule_work(&rtc->irqwork);
+	}
+}
+
+/**
+ * rtc_timer_remove - Removes a rtc_timer from the rtc_device timerqueue
+ * @rtc rtc device
+ * @timer timer being removed.
+ *
+ * Removes a timer onto the rtc devices timerqueue and sets
+ * the next alarm event appropriately.
+ *
+ * Must hold ops_lock for proper serialization of timerqueue
+ */
+void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer)
+{
+	struct timerqueue_node *next = timerqueue_getnext(&rtc->timerqueue);
+	timerqueue_del(&rtc->timerqueue, &timer->node);
+
+	if (next == &timer->node) {
+		struct rtc_wkalrm alarm;
+		int err;
+		next = timerqueue_getnext(&rtc->timerqueue);
+		if (!next)
+			return;
+		alarm.time = rtc_ktime_to_tm(next->expires);
+		alarm.enabled = 1;
+		err = __rtc_set_alarm(rtc, &alarm);
+		if (err == -ETIME)
+			schedule_work(&rtc->irqwork);
+	}
+}
+
+/**
+ * rtc_timer_do_work - Expires rtc timers
+ * @rtc rtc device
+ * @timer timer being removed.
+ *
+ * Expires rtc timers. Reprograms next alarm event if needed.
+ * Called via worktask.
+ *
+ * Serializes access to timerqueue via ops_lock mutex
+ */
+void rtc_timer_do_work(struct work_struct *work)
+{
+	struct rtc_timer *timer;
+	struct timerqueue_node *next;
+	ktime_t now;
+	struct rtc_time tm;
+
+	struct rtc_device *rtc =
+		container_of(work, struct rtc_device, irqwork);
+
+	mutex_lock(&rtc->ops_lock);
+again:
+	__rtc_read_time(rtc, &tm);
+	now = rtc_tm_to_ktime(tm);
+	while ((next = timerqueue_getnext(&rtc->timerqueue))) {
+		if (next->expires.tv64 > now.tv64)
+			break;
+
+		/* expire timer */
+		timer = container_of(next, struct rtc_timer, node);
+		timerqueue_del(&rtc->timerqueue, &timer->node);
+		timer->enabled = 0;
+		if (timer->task.func)
+			timer->task.func(timer->task.private_data);
+
+		/* Re-add/fwd periodic timers */
+		if (ktime_to_ns(timer->period)) {
+			timer->node.expires = ktime_add(timer->node.expires,
+							timer->period);
+			timer->enabled = 1;
+			timerqueue_add(&rtc->timerqueue, &timer->node);
+		}
+	}
+
+	/* Set next alarm */
+	if (next) {
+		struct rtc_wkalrm alarm;
+		int err;
+		alarm.time = rtc_ktime_to_tm(next->expires);
+		alarm.enabled = 1;
+		err = __rtc_set_alarm(rtc, &alarm);
+		if (err == -ETIME)
+			goto again;
+	}
+
+	mutex_unlock(&rtc->ops_lock);
+}
+
+
+/* rtc_timer_init - Initializes an rtc_timer
+ * @timer: timer to be intiialized
+ * @f: function pointer to be called when timer fires
+ * @data: private data passed to function pointer
+ *
+ * Kernel interface to initializing an rtc_timer.
+ */
+void rtc_timer_init(struct rtc_timer *timer, void (*f)(void* p), void* data)
+{
+	timerqueue_init(&timer->node);
+	timer->enabled = 0;
+	timer->task.func = f;
+	timer->task.private_data = data;
+}
+
+/* rtc_timer_start - Sets an rtc_timer to fire in the future
+ * @ rtc: rtc device to be used
+ * @ timer: timer being set
+ * @ expires: time at which to expire the timer
+ * @ period: period that the timer will recur
+ *
+ * Kernel interface to set an rtc_timer
+ */
+int rtc_timer_start(struct rtc_device *rtc, struct rtc_timer* timer,
+			ktime_t expires, ktime_t period)
+{
+	int ret = 0;
+	mutex_lock(&rtc->ops_lock);
+	if (timer->enabled)
+		rtc_timer_remove(rtc, timer);
+
+	timer->node.expires = expires;
+	timer->period = period;
+
+	timer->enabled = 1;
+	rtc_timer_enqueue(rtc, timer);
+
+	mutex_unlock(&rtc->ops_lock);
+	return ret;
+}
+
+/* rtc_timer_cancel - Stops an rtc_timer
+ * @ rtc: rtc device to be used
+ * @ timer: timer being set
+ *
+ * Kernel interface to cancel an rtc_timer
+ */
+int rtc_timer_cancel(struct rtc_device *rtc, struct rtc_timer* timer)
+{
+	int ret = 0;
+	mutex_lock(&rtc->ops_lock);
+	if (timer->enabled)
+		rtc_timer_remove(rtc, timer);
+	timer->enabled = 0;
+	mutex_unlock(&rtc->ops_lock);
+	return ret;
+}
+
+
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 62227cd..212b16e 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -46,105 +46,6 @@ static int rtc_dev_open(struct inode *inode, struct file *file)
 	return err;
 }
 
-#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
-/*
- * Routine to poll RTC seconds field for change as often as possible,
- * after first RTC_UIE use timer to reduce polling
- */
-static void rtc_uie_task(struct work_struct *work)
-{
-	struct rtc_device *rtc =
-		container_of(work, struct rtc_device, uie_task);
-	struct rtc_time tm;
-	int num = 0;
-	int err;
-
-	err = rtc_read_time(rtc, &tm);
-
-	spin_lock_irq(&rtc->irq_lock);
-	if (rtc->stop_uie_polling || err) {
-		rtc->uie_task_active = 0;
-	} else if (rtc->oldsecs != tm.tm_sec) {
-		num = (tm.tm_sec + 60 - rtc->oldsecs) % 60;
-		rtc->oldsecs = tm.tm_sec;
-		rtc->uie_timer.expires = jiffies + HZ - (HZ/10);
-		rtc->uie_timer_active = 1;
-		rtc->uie_task_active = 0;
-		add_timer(&rtc->uie_timer);
-	} else if (schedule_work(&rtc->uie_task) == 0) {
-		rtc->uie_task_active = 0;
-	}
-	spin_unlock_irq(&rtc->irq_lock);
-	if (num)
-		rtc_update_irq(rtc, num, RTC_UF | RTC_IRQF);
-}
-static void rtc_uie_timer(unsigned long data)
-{
-	struct rtc_device *rtc = (struct rtc_device *)data;
-	unsigned long flags;
-
-	spin_lock_irqsave(&rtc->irq_lock, flags);
-	rtc->uie_timer_active = 0;
-	rtc->uie_task_active = 1;
-	if ((schedule_work(&rtc->uie_task) == 0))
-		rtc->uie_task_active = 0;
-	spin_unlock_irqrestore(&rtc->irq_lock, flags);
-}
-
-static int clear_uie(struct rtc_device *rtc)
-{
-	spin_lock_irq(&rtc->irq_lock);
-	if (rtc->uie_irq_active) {
-		rtc->stop_uie_polling = 1;
-		if (rtc->uie_timer_active) {
-			spin_unlock_irq(&rtc->irq_lock);
-			del_timer_sync(&rtc->uie_timer);
-			spin_lock_irq(&rtc->irq_lock);
-			rtc->uie_timer_active = 0;
-		}
-		if (rtc->uie_task_active) {
-			spin_unlock_irq(&rtc->irq_lock);
-			flush_scheduled_work();
-			spin_lock_irq(&rtc->irq_lock);
-		}
-		rtc->uie_irq_active = 0;
-	}
-	spin_unlock_irq(&rtc->irq_lock);
-	return 0;
-}
-
-static int set_uie(struct rtc_device *rtc)
-{
-	struct rtc_time tm;
-	int err;
-
-	err = rtc_read_time(rtc, &tm);
-	if (err)
-		return err;
-	spin_lock_irq(&rtc->irq_lock);
-	if (!rtc->uie_irq_active) {
-		rtc->uie_irq_active = 1;
-		rtc->stop_uie_polling = 0;
-		rtc->oldsecs = tm.tm_sec;
-		rtc->uie_task_active = 1;
-		if (schedule_work(&rtc->uie_task) == 0)
-			rtc->uie_task_active = 0;
-	}
-	rtc->irq_data = 0;
-	spin_unlock_irq(&rtc->irq_lock);
-	return 0;
-}
-
-int rtc_dev_update_irq_enable_emul(struct rtc_device *rtc, unsigned int enabled)
-{
-	if (enabled)
-		return set_uie(rtc);
-	else
-		return clear_uie(rtc);
-}
-EXPORT_SYMBOL(rtc_dev_update_irq_enable_emul);
-
-#endif /* CONFIG_RTC_INTF_DEV_UIE_EMUL */
 
 static ssize_t
 rtc_dev_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
@@ -493,11 +394,6 @@ void rtc_dev_prepare(struct rtc_device *rtc)
 
 	rtc->dev.devt = MKDEV(MAJOR(rtc_devt), rtc->id);
 
-#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
-	INIT_WORK(&rtc->uie_task, rtc_uie_task);
-	setup_timer(&rtc->uie_timer, rtc_uie_timer, (unsigned long)rtc);
-#endif
-
 	cdev_init(&rtc->char_dev, &rtc_dev_fops);
 	rtc->char_dev.owner = rtc->owner;
 }
diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
index 773851f..075f170 100644
--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -117,4 +117,32 @@ int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time)
 }
 EXPORT_SYMBOL(rtc_tm_to_time);
 
+/*
+ * Convert rtc_time to ktime
+ */
+ktime_t rtc_tm_to_ktime(struct rtc_time tm)
+{
+	time_t time;
+	rtc_tm_to_time(&tm, &time);
+	return ktime_set(time, 0);
+}
+EXPORT_SYMBOL_GPL(rtc_tm_to_ktime);
+
+/*
+ * Convert ktime to rtc_time
+ */
+struct rtc_time rtc_ktime_to_tm(ktime_t kt)
+{
+	struct timespec ts;
+	struct rtc_time ret;
+
+	ts = ktime_to_timespec(kt);
+	/* Round up any ns */
+	if (ts.tv_nsec)
+		ts.tv_sec++;
+	rtc_time_to_tm(ts.tv_sec, &ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rtc_ktime_to_tm);
+
 MODULE_LICENSE("GPL");
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 14dbc83..3c995b4 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -107,12 +107,17 @@ extern int rtc_year_days(unsigned int day, unsigned int month, unsigned int year
 extern int rtc_valid_tm(struct rtc_time *tm);
 extern int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time);
 extern void rtc_time_to_tm(unsigned long time, struct rtc_time *tm);
+ktime_t rtc_tm_to_ktime(struct rtc_time tm);
+struct rtc_time rtc_ktime_to_tm(ktime_t kt);
+
 
 #include <linux/device.h>
 #include <linux/seq_file.h>
 #include <linux/cdev.h>
 #include <linux/poll.h>
 #include <linux/mutex.h>
+#include <linux/timerqueue.h>
+#include <linux/workqueue.h>
 
 extern struct class *rtc_class;
 
@@ -151,7 +156,19 @@ struct rtc_class_ops {
 };
 
 #define RTC_DEVICE_NAME_SIZE 20
-struct rtc_task;
+typedef struct rtc_task {
+	void (*func)(void *private_data);
+	void *private_data;
+} rtc_task_t;
+
+
+struct rtc_timer {
+	struct rtc_task	task;
+	struct timerqueue_node node;
+	ktime_t period;
+	int enabled;
+};
+
 
 /* flags */
 #define RTC_DEV_BUSY 0
@@ -179,16 +196,13 @@ struct rtc_device
 	spinlock_t irq_task_lock;
 	int irq_freq;
 	int max_user_freq;
-#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
-	struct work_struct uie_task;
-	struct timer_list uie_timer;
-	/* Those fields are protected by rtc->irq_lock */
-	unsigned int oldsecs;
-	unsigned int uie_irq_active:1;
-	unsigned int stop_uie_polling:1;
-	unsigned int uie_task_active:1;
-	unsigned int uie_timer_active:1;
-#endif
+
+	struct timerqueue_head timerqueue;
+	struct rtc_timer aie_timer;
+	struct rtc_timer uie_rtctimer;
+	struct hrtimer pie_timer; /* sub second exp, so needs hrtimer */
+	int pie_enabled;
+	struct work_struct irqwork;
 };
 #define to_rtc_device(d) container_of(d, struct rtc_device, dev)
 
@@ -224,15 +238,22 @@ extern int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled);
 extern int rtc_dev_update_irq_enable_emul(struct rtc_device *rtc,
 						unsigned int enabled);
 
-typedef struct rtc_task {
-	void (*func)(void *private_data);
-	void *private_data;
-} rtc_task_t;
+void rtc_aie_update_irq(void *private);
+void rtc_uie_update_irq(void *private);
+enum hrtimer_restart rtc_pie_update_irq(struct hrtimer *timer);
 
 int rtc_register(rtc_task_t *task);
 int rtc_unregister(rtc_task_t *task);
 int rtc_control(rtc_task_t *t, unsigned int cmd, unsigned long arg);
 
+void rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer);
+void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer);
+void rtc_timer_init(struct rtc_timer *timer, void (*f)(void* p), void* data);
+int rtc_timer_start(struct rtc_device *rtc, struct rtc_timer* timer,
+			ktime_t expires, ktime_t period);
+int rtc_timer_cancel(struct rtc_device *rtc, struct rtc_timer* timer);
+void rtc_timer_do_work(struct work_struct *work);
+
 static inline bool is_leap_year(unsigned int year)
 {
 	return (!(year % 4) && (year % 100)) || !(year % 400);
