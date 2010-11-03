Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab0KCSgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:36:48 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55524 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab0KCSgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:36:43 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: =?UTF-8?q?=5BPATCH=203/7=5D=20=5BRFC=5D=20RTC=3A=20Rework=20RTC=20code=20to=20use=20timerlist=20for=20events?=
Date: Wed,  3 Nov 2010 11:31:15 -0700
Message-Id: <1288809079-14663-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288809079-14663-1-git-send-email-john.stultz@linaro.org>
References: <1288809079-14663-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reworks a large portion of the generic RTC code
to in-effect virtualize the rtc interrupt code.

The current RTC interface is very much a raw hardware interface.
Via the proc, /dev/, or sysfs interfaces, applciations can set
the hardware to trigger interrupts in one of three modes:

AIE: Alarm interrupt
UIE: Update interrupt (ie: once per second)
PIE: Periodic interrupt (sub-second irqs)

The problem with this interface is that it limits the RTC hardware
so it can only be used by one application at a time.

The purpose of this patch is to extend the RTC code so that we can
multiplex multiple applications event needs onto a single RTC device.
This is done by utilizing the timerlist infrastructure to manage
a list of events, which cause the RTC hardware to be programmed
to fire an interrupt for the next event in the list.

In order to preserve the functionality of the exsting proc,/dev/ and
sysfs interfaces, we emulate the different interrupt modes as follows:

AIE: We create a rtc_timer dedicated to AIE mode interrupts. There is
only one per device, so we don't change existing interface semantics.

UIE: Again, a dedicated rtc_timer, set for periodic mode, is used
to emulate UIE interrupts. Again, only one per device.

PIE: Since PIE mode interrupts fire faster then the RTC's clock read
granularity, we emulate PIE mode interrupts using a hrtimer. Again,
one per device.

With this patch, the rtctest.c application in Documentation/rtc.txt
passes fine on x86 hardware. However, there may very well still be
bugs, so greatly I'd appreciate any feedback or testing!

Signed-off-by: John Stultz <john.stultz@linaro.org>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Richard Cochran <richardcochran@gmail.com>
CC: Arve Hjønnevåg <arve@android.com>
---
 drivers/rtc/class.c     |   13 +
 drivers/rtc/interface.c |  574 ++++++++++++++++++++++++++++------------------
 drivers/rtc/rtc-lib.c   |   26 +++
 include/linux/rtc.h     |   43 +++-
 4 files changed, 426 insertions(+), 230 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index e6539cb..fb59222 100644
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
 
+	/* Init timerlist */
+	timerlist_init_head(&rtc->timerlist);
+	INIT_WORK(&rtc->irqwork, rtctimer_do_work);
+	/* Init aie timer */
+	rtctimer_init(&rtc->aie_timer, rtc_aie_update_irq, (void*)rtc);
+	/* Init uie timer */
+	rtctimer_init(&rtc->uie_rtctimer, rtc_uie_update_irq, (void*)rtc);
+	/* Init pie timer */
+	hrtimer_init(&rtc->pie_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	rtc->pie_timer.function = rtc_pie_update_irq;
+	rtc->pie_enabled = 0;
+
 	strlcpy(rtc->name, name, RTC_DEVICE_NAME_SIZE);
 	dev_set_name(&rtc->dev, "rtc%d", id);
 
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index a0c8162..55894ee 100644
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
+		rtctimer_remove(rtc, &rtc->aie_timer);
+		rtc->aie_timer.enabled = 0;
+	}
+	rtc->aie_timer.node.expires = rtc_tm_to_ktime(alarm->time);
+	rtc->aie_timer.period = ktime_set(0,0);
+	if (alarm->enabled) {
+		rtc->aie_timer.enabled = 1;
+		rtctimer_enqueue(rtc, &rtc->aie_timer);
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
+		if (enabled){
+			rtc->aie_timer.enabled = 1;
+			rtctimer_enqueue(rtc, &rtc->aie_timer);
+		} else {
+			rtctimer_remove(rtc, &rtc->aie_timer);
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
+	if(rtc->uie_rtctimer.enabled == enabled)
+		goto out;
+
+	if (enabled) {
+		struct rtc_time tm;
+		ktime_t now, onesec;
+
+		__rtc_read_time(rtc, &tm);
+		onesec = ktime_set(1,0);
+		now = rtc_tm_to_ktime(tm);
+		rtc->uie_rtctimer.node.expires = ktime_add(now,onesec);
+		rtc->uie_rtctimer.period = ktime_set(1,0);
+		rtc->uie_rtctimer.enabled = 1;
+		rtctimer_enqueue(rtc, &rtc->uie_rtctimer);
+	} else {
+		rtctimer_remove(rtc, &rtc->uie_rtctimer);
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
+static void rtc_handle_legacy_irq(struct rtc_device* rtc, int num, int mode)
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
+	period = ktime_set(0,NSEC_PER_SEC/rtc->irq_freq);
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
+	if(enabled) {
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
+ * rtctimer_enqueue - Adds a rtc_timer to the rtc_device timerlist
+ * @rtc rtc device
+ * @timer timer being added.
+ *
+ * Enqueues a timer onto the rtc devices timerlist and sets
+ * the next alarm event appropriately.
+ *
+ * Must hold ops_lock for proper serialization of timerlist
+ */
+void rtctimer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
+{
+	timerlist_add(&rtc->timerlist, &timer->node);
+	if (&timer->node == timerlist_getnext(&rtc->timerlist)) {
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
+ * rtctimer_remove - Removes a rtc_timer from the rtc_device timerlist
+ * @rtc rtc device
+ * @timer timer being removed.
+ *
+ * Removes a timer onto the rtc devices timerlist and sets
+ * the next alarm event appropriately.
+ *
+ * Must hold ops_lock for proper serialization of timerlist
+ */
+void rtctimer_remove(struct rtc_device *rtc, struct rtc_timer *timer)
+{
+	struct timerlist_node *next = timerlist_getnext(&rtc->timerlist);
+	timerlist_del(&rtc->timerlist, &timer->node);
+
+	if (next == &timer->node) {
+		struct rtc_wkalrm alarm;
+		int err;
+		next = timerlist_getnext(&rtc->timerlist);
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
+ * rtctimer_do_work - Expires rtc timers
+ * @rtc rtc device
+ * @timer timer being removed.
+ *
+ * Expires rtc timers. Reprograms next alarm event if needed.
+ * Called via worktask.
+ *
+ * Serializes access to timerlist via ops_lock mutex
+ */
+void rtctimer_do_work(struct work_struct *work)
+{
+	struct rtc_timer *timer;
+	struct timerlist_node *next;
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
+	while ((next = timerlist_getnext(&rtc->timerlist))) {
+		if (next->expires.tv64 > now.tv64)
+			break;
+
+		/* expire timer */
+		timer = container_of(next, struct rtc_timer, node);
+		timerlist_del(&rtc->timerlist, &timer->node);
+		timer->enabled = 0;
+		if (timer->task.func)
+			timer->task.func(timer->task.private_data);
+
+		/* Re-add/fwd periodic timers */
+		if (ktime_to_ns(timer->period)) {
+			timer->node.expires = ktime_add(timer->node.expires,
+							timer->period);
+			timer->enabled = 1;
+			timerlist_add(&rtc->timerlist, &timer->node);
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
+/* rtctimer_init - Initializes an rtc_timer
+ * @timer: timer to be intiialized
+ * @f: function pointer to be called when timer fires
+ * @data: private data passed to function pointer
+ *
+ * Kernel interface to initializing an rtc_timer.
+ */
+void rtctimer_init(struct rtc_timer *timer, void (*f)(void* p), void* data)
+{
+	timerlist_init(&timer->node);
+	timer->enabled = 0;
+	timer->task.func = f;
+	timer->task.private_data = data;
+}
+
+/* rtctimer_start - Sets an rtc_timer to fire in the future
+ * @ rtc: rtc device to be used
+ * @ timer: timer being set
+ * @ expires: time at which to expire the timer
+ * @ period: period that the timer will recur
+ *
+ * Kernel interface to set an rtc_timer
+ */
+int rtctimer_start(struct rtc_device *rtc, struct rtc_timer* timer,
+			ktime_t expires, ktime_t period)
+{
+	int ret = 0;
+	mutex_lock(&rtc->ops_lock);
+	if (timer->enabled)
+		rtctimer_remove(rtc, timer);
+
+	timer->node.expires = expires;
+	timer->period = period;
+
+	timer->enabled = 1;
+	rtctimer_enqueue(rtc, timer);
+
+	mutex_unlock(&rtc->ops_lock);
+	return ret;
+}
+
+/* rtctimer_cancel - Stops an rtc_timer
+ * @ rtc: rtc device to be used
+ * @ timer: timer being set
+ *
+ * Kernel interface to cancel an rtc_timer
+ */
+int rtctimer_cancel(struct rtc_device *rtc, struct rtc_timer* timer)
+{
+	int ret = 0;
+	mutex_lock(&rtc->ops_lock);
+	if (timer->enabled)
+		rtctimer_remove(rtc, timer);
+	timer->enabled = 0;
+	mutex_unlock(&rtc->ops_lock);
+	return ret;
+}
+
+
diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
index 773851f..00df788 100644
--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -117,4 +117,30 @@ int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time)
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
+
 MODULE_LICENSE("GPL");
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 14dbc83..c50fae5 100644
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
+#include <linux/timerlist.h>
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
+	struct timerlist_node node;
+	ktime_t period;
+	int enabled;
+};
+
 
 /* flags */
 #define RTC_DEV_BUSY 0
@@ -179,6 +196,15 @@ struct rtc_device
 	spinlock_t irq_task_lock;
 	int irq_freq;
 	int max_user_freq;
+
+	struct timerlist_head timerlist;
+	struct rtc_timer aie_timer;
+	struct rtc_timer uie_rtctimer;
+	struct hrtimer pie_timer; /* sub second exp, so needs hrtimer */
+	int pie_enabled;
+	struct work_struct irqwork;
+
+
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	struct work_struct uie_task;
 	struct timer_list uie_timer;
@@ -224,15 +250,22 @@ extern int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled);
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
 
+void rtctimer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer);
+void rtctimer_remove(struct rtc_device *rtc, struct rtc_timer *timer);
+void rtctimer_init(struct rtc_timer *timer, void (*f)(void* p), void* data);
+int rtctimer_start(struct rtc_device *rtc, struct rtc_timer* timer,
+			ktime_t expires, ktime_t period);
+int rtctimer_cancel(struct rtc_device *rtc, struct rtc_timer* timer);
+void rtctimer_do_work(struct work_struct *work);
+
 static inline bool is_leap_year(unsigned int year)
 {
 	return (!(year % 4) && (year % 100)) || !(year % 400);
-- 
1.7.3.2.146.gca209

