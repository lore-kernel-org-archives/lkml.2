Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab0KSDMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 22:12:51 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44702 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030Ab0KSDMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 22:12:23 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 5/5] [RFC] Introduce Alarm (hybrid) timers
Date: Thu, 18 Nov 2010 19:12:09 -0800
Message-Id: <1290136329-18291-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1290136329-18291-1-git-send-email-john.stultz@linaro.org>
References: <1290136329-18291-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new type of hybrid timer, called
alarm-timers.

Alarm-timers are similar to hrtimers, but when a system
is suspended, the RTC device is set to fire when the soonest
alarm timer expires.

Alarm-timers are exposed to userland via the posix clock and timers
interface, using two new clockids: CLOCK_REALTIME_ALARM and
CLOCK_MONOTONIC_ALARM. Both clockids behave identically to
CLOCK_REALTIME and CLOCK_MONOTONIC, respectively, but timers
set against the _ALARM suffixed clockids will wake the system if
it is suspended.

The concept for Alarm-timers was inspired by the Android Alarm
driver (by Arve Hjønnevåg) found in the Android kernel tree.

See: http://android.git.kernel.org/?p=kernel/common.git;a=blob;f=drivers/rtc/alarm.c;h=1250edfbdf3302f5e4ea6194847c6ef4bb7beb1c;hb=android-2.6.36

The android alarm driver was built on top of direct RTC
manipulation, and also implemented its own rbtree timer
code, so instead of trying to porting it over to my
timerlist and RTC timer code, I just re-implemented the
basic functionality roughly following the android in-kernel
interface.

Another distinction is that while the in-kernel interface
is pretty similar, the user-space interface for android alarm
timers is via ioctls. As mentioned above, I've instead chosen
to export this functionality via the posix interface, as it
seemed a little simpler and avoids creating duplicate interfaces
to things like CLOCK_REALTIME and CLOCK_MONOTONIC under alternate
names (ie:ANDROID_ALARM_RTC and ANDROID_ALARM_SYSTEMTIME).

Its possible that I've missed some subtleties of the Android
alarm driver interface, and that some of the interface decisions
I've made may not allow Android to use this interface directly,
I'd be very interested if those details could be pointed out,
and hopefully we can find a good solution to get this useful
functionality upstream.

Arve: I know you're busy now, so no rush on reviewing this.
I just wanted to send this out to get some early feedback
if anyone else wants to comment. I look forward to your
input when you are a bit less swamped.

One issue that is currently present in this version of the
patch, is that I've recently implemented clock_nanosleep(),
however, clock_nanosleep() calls against the _ALARM clockids
do not wake the system from suspend. This is because the
clock_nanosleep syscall is interrupted by suspend and
restarted on resume.

Thomas: Any thoughts on how to best solve this issue?

Signed-off-by: John Stultz <john.stultz@linaro.org>
CC: Arve Hjønnevåg <arve@android.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
---
 include/linux/alarmtimer.h   |   30 ++
 include/linux/posix-timers.h |    2 +
 include/linux/time.h         |    2 +
 kernel/time/Makefile         |    2 +-
 kernel/time/alarmtimer.c     |  657 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 692 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/alarmtimer.h
 create mode 100644 kernel/time/alarmtimer.c

diff --git a/include/linux/alarmtimer.h b/include/linux/alarmtimer.h
new file mode 100644
index 0000000..0c9c8aa
--- /dev/null
+++ b/include/linux/alarmtimer.h
@@ -0,0 +1,30 @@
+#ifndef _LINUX_ALARMTIMER_H
+#define _LINUX_ALARMTIMER_H
+
+#include <linux/time.h>
+#include <linux/hrtimer.h>
+#include <linux/timerlist.h>
+#include <linux/rtc.h>
+
+enum alarmtimer_type {
+	ALARM_REALTIME,
+	ALARM_MONOTONIC,
+
+	ALARM_NUMTYPE,
+};
+
+struct alarm {
+	struct timerlist_node node;
+	ktime_t period;
+	void (*function)(struct alarm *);
+	enum alarmtimer_type type;
+	char enabled;
+	void *data;
+};
+
+void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
+		void (*function)(struct alarm *));
+void alarm_start(struct alarm *alarm, ktime_t start, ktime_t period);
+void alarm_cancel(struct alarm *alarm);
+
+#endif
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 3e23844a..0361309 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -4,6 +4,7 @@
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/sched.h>
+#include <linux/alarmtimer.h>
 
 union cpu_time_count {
 	cputime_t cpu;
@@ -63,6 +64,7 @@ struct k_itimer {
 			unsigned long incr;
 			unsigned long expires;
 		} mmtimer;
+		struct alarm alarmtimer;
 	} it;
 };
 
diff --git a/include/linux/time.h b/include/linux/time.h
index 9f15ac7..59eccd7 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -290,6 +290,8 @@ struct itimerval {
 #define CLOCK_MONOTONIC_RAW		4
 #define CLOCK_REALTIME_COARSE		5
 #define CLOCK_MONOTONIC_COARSE		6
+#define CLOCK_REALTIME_ALARM		7
+#define CLOCK_MONOTONIC_ALARM		8
 
 /*
  * The IDs of various hardware clocks:
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index ee26662..f85145f 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -1,4 +1,4 @@
-obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o timecompare.o timeconv.o
+obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o timecompare.o timeconv.o alarmtimer.o
 
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BUILD)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
new file mode 100644
index 0000000..7bff7dd
--- /dev/null
+++ b/kernel/time/alarmtimer.c
@@ -0,0 +1,657 @@
+/*
+ * Alarmtimer interface
+ *
+ * This interface provides a timer which is similarto hrtimers,
+ * but triggers a RTC alarm if the box is suspend.
+ *
+ * This interface is influenced by the Android RTC Alarm timer
+ * interface.
+ *
+ * Copyright (C) 2010 IBM Corperation
+ *
+ * Author: John Stultz <john.stultz@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/time.h>
+#include <linux/hrtimer.h>
+#include <linux/timerlist.h>
+#include <linux/rtc.h>
+#include <linux/alarmtimer.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/posix-timers.h>
+#include <linux/workqueue.h>
+
+
+static struct alarm_base {
+	struct mutex lock;
+	struct timerlist_head timerlist;
+	struct hrtimer timer;
+	ktime_t (*gettime)(void);
+	clockid_t base_clockid;
+	struct work_struct irqwork;
+} alarm_bases[ALARM_NUMTYPE];
+
+static struct rtc_timer rtctimer;
+static struct rtc_device *rtcdev;
+
+/**************************************************************************
+ * alarmtimer management code
+ */
+
+/*
+ * alarmtimer_enqueue - Adds an alarm timer to an alarm_base timerlist
+ * @base: pointer to the base where the timer is being run
+ * @alarm: pointer to alarm being enqueued.
+ *
+ * Adds alarm to a alarm_base timerlist and if necessary sets
+ * an hrtimer to run.
+ *
+ * Must hold base->lock when calling.
+ */
+static void alarmtimer_enqueue(struct alarm_base *base, struct alarm *alarm)
+{
+	timerlist_add(&base->timerlist, &alarm->node);
+	if (&alarm->node == timerlist_getnext(&base->timerlist)) {
+		hrtimer_try_to_cancel(&base->timer);
+		hrtimer_start(&base->timer, alarm->node.expires,
+				HRTIMER_MODE_ABS);
+	}
+}
+
+/*
+ * alarmtimer_remove - Removes an alarm timer from an alarm_base timerlist
+ * @base: pointer to the base where the timer is running
+ * @alarm: pointer to alarm being removed
+ *
+ * Removes alarm to a alarm_base timerlist and if necessary sets
+ * a new timer to run.
+ *
+ * Must hold base->lock when calling.
+ */
+static void alarmtimer_remove(struct alarm_base *base, struct alarm *alarm)
+{
+	struct timerlist_node *next = timerlist_getnext(&base->timerlist);
+
+	timerlist_del(&base->timerlist, &alarm->node);
+	if (next == &alarm->node) {
+		hrtimer_try_to_cancel(&base->timer);
+		next = timerlist_getnext(&base->timerlist);
+		if (!next)
+			return;
+		hrtimer_start(&base->timer, next->expires, HRTIMER_MODE_ABS);
+	}
+}
+
+/*
+ * alarmtimer_do_work - Handles alarm being fired.
+ * @work: pointer to workqueue being run
+ *
+ * When a timer fires, this runs through the timerlist to see
+ * which alarm timers, and run those that expired. If there are
+ * more alarm timers queued, we set the hrtimer to fire in the
+ * future.
+ */
+void alarmtimer_do_work(struct work_struct *work)
+{
+	struct alarm_base *base = container_of(work, struct alarm_base,
+						irqwork);
+	struct timerlist_node *next;
+	ktime_t now;
+
+	mutex_lock(&base->lock);
+	now = base->gettime();
+	while ((next = timerlist_getnext(&base->timerlist))) {
+		struct alarm *alarm;
+		ktime_t expired = next->expires;
+
+		if (expired.tv64 >= now.tv64)
+			break;
+
+		alarm = container_of(next, struct alarm, node);
+
+		timerlist_del(&base->timerlist, &alarm->node);
+		alarm->enabled = 0;
+		/* Re-add periodic timers */
+		if (alarm->period.tv64) {
+			alarm->node.expires = ktime_add(expired, alarm->period);
+			timerlist_add(&base->timerlist, &alarm->node);
+			alarm->enabled = 1;
+		}
+		mutex_unlock(&base->lock);
+		if (alarm->function)
+			alarm->function(alarm);
+		mutex_lock(&base->lock);
+	}
+
+	if (next) {
+		hrtimer_start(&base->timer, next->expires,
+				HRTIMER_MODE_ABS);
+	}
+	mutex_unlock(&base->lock);
+}
+
+
+/*
+ * alarmtimer_fired - Handles alarm hrtimer being fired.
+ * @timer: pointer to hrtimer being run
+ *
+ * When a timer fires, this schedules the do_work function to
+ * be run.
+ */
+static enum hrtimer_restart alarmtimer_fired(struct hrtimer *timer)
+{
+	struct alarm_base *base = container_of(timer, struct alarm_base, timer);
+	schedule_work(&base->irqwork);
+	return HRTIMER_NORESTART;
+}
+
+/*
+ * alarmtimer_suspend - Suspend time callback
+ * @dev: unused
+ * @state: unused
+ *
+ * When we are going into suspend, we look through the bases
+ * to see which is the soonest timer to expire. We then
+ * set an rtc timer to fire that far into the future, which
+ * will wake us from suspend.
+ */
+static int alarmtimer_suspend(struct device *dev)
+{
+	struct rtc_time tm;
+	ktime_t min = ktime_set(0, 0);
+	ktime_t now;
+	int i;
+
+	/* If we have no rtcdev, just return */
+	if (!rtcdev)
+		return 0;
+
+	/* Find the soonest timer to expire*/
+	for (i = 0; i < ALARM_NUMTYPE; i++) {
+		struct alarm_base *base = &alarm_bases[i];
+		struct timerlist_node *next;
+		ktime_t delta;
+
+		mutex_lock(&base->lock);
+		next = timerlist_getnext(&base->timerlist);
+		mutex_unlock(&base->lock);
+		if (!next)
+			continue;
+		delta = ktime_sub(next->expires, base->gettime());
+		if (!min.tv64 || (delta.tv64 < min.tv64))
+			min = delta;
+	}
+	if (min.tv64 == 0)
+		return 0;
+
+	/* Setup an rtc timer to fire that far in the future */
+	rtctimer_cancel(rtcdev, &rtctimer);
+	rtc_read_time(rtcdev, &tm);
+	now = rtc_tm_to_ktime(tm);
+	now = ktime_add(now, min);
+
+	rtctimer_start(rtcdev, &rtctimer, now, ktime_set(0, 0));
+
+	return 0;
+}
+
+/**************************************************************************
+ * alarm kernel interface code
+ */
+
+/*
+ * alarm_init - Initialize an alarm structure
+ * @alarm: ptr to alarm to be initialized
+ * @type: the type of the alarm
+ * @function: callback that is run when the alarm fires
+ *
+ * In-kernel interface to initializes the alarm structure.
+ */
+void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
+		void (*function)(struct alarm *))
+{
+	timerlist_init(&alarm->node);
+	alarm->period = ktime_set(0, 0);
+	alarm->function = function;
+	alarm->type = type;
+	alarm->enabled = 0;
+}
+
+/*
+ * alarm_start - Sets an alarm to fire
+ * @alarm: ptr to alarm to set
+ * @start: time to run the alarm
+ * @period: period at which the alarm will recur
+ *
+ * In-kernel interface set an alarm timer.
+ */
+void alarm_start(struct alarm *alarm, ktime_t start, ktime_t period)
+{
+	struct alarm_base *base = &alarm_bases[alarm->type];
+
+	mutex_lock(&base->lock);
+	if (alarm->enabled)
+		alarmtimer_remove(base, alarm);
+	alarm->node.expires = start;
+	alarm->period = period;
+	alarmtimer_enqueue(base, alarm);
+	alarm->enabled = 1;
+	mutex_unlock(&base->lock);
+}
+
+/*
+ * alarm_cancel - Tries to cancel an alarm timer
+ * @alarm: ptr to alarm to be canceled
+ *
+ * In-kernel interface to cancel an alarm timer.
+ */
+void alarm_cancel(struct alarm *alarm)
+{
+	struct alarm_base *base = &alarm_bases[alarm->type];
+
+	mutex_lock(&base->lock);
+	if (alarm->enabled)
+		alarmtimer_remove(base, alarm);
+	alarm->enabled = 0;
+	mutex_unlock(&base->lock);
+}
+
+
+/**************************************************************************
+ * alarm posix interface code
+ */
+
+/*
+ * clock2alarm - helper that converts from clockid to alarmtypes
+ * @clockid: clockid.
+ *
+ * Helper function that converts from clockids to alarmtypes
+ */
+static enum alarmtimer_type clock2alarm(clockid_t clockid)
+{
+	if (clockid == CLOCK_REALTIME_ALARM)
+		return ALARM_REALTIME;
+	if (clockid == CLOCK_MONOTONIC_ALARM)
+		return ALARM_MONOTONIC;
+	return -1;
+}
+
+/*
+ * alarm_handle_timer - Callback for posix timers
+ * @alarm: alarm that fired
+ *
+ * Posix timer callback for expired alarm timers.
+ */
+static void alarm_handle_timer(struct alarm *alarm)
+{
+	struct k_itimer *ptr = container_of(alarm, struct k_itimer,
+						it.alarmtimer);
+	if (posix_timer_event(ptr, 0) != 0)
+		ptr->it_overrun++;
+}
+
+/*
+ * alarm_clock_getres - posix getres interface
+ * @which_clock: clockid
+ * @tp: timespec to fill
+ *
+ * Returns the granularity of underlying alarm base clock
+ */
+static int alarm_clock_getres(const clockid_t which_clock, struct timespec *tp)
+{
+	clockid_t baseid = alarm_bases[clock2alarm(which_clock)].base_clockid;
+
+	return hrtimer_get_res(baseid, tp);
+}
+
+/**
+ * alarm_clock_get - posix clock_get interface
+ * @which_clock: clockid
+ * @tp: timespec to fill.
+ *
+ * Provides the underlying alarm base time.
+ */
+static int alarm_clock_get(clockid_t which_clock, struct timespec *tp)
+{
+	struct alarm_base *base = &alarm_bases[clock2alarm(which_clock)];
+
+	*tp = ktime_to_timespec(base->gettime());
+	return 0;
+}
+
+/**
+ * alarm_timer_create - posix timer_create interface
+ * @new_timer: k_itimer pointer to manage
+ *
+ * Initializes the k_itimer structure.
+ */
+static int alarm_timer_create(struct k_itimer *new_timer)
+{
+	enum  alarmtimer_type type;
+	struct alarm_base *base;
+
+	type = clock2alarm(new_timer->it_clock);
+	base = &alarm_bases[type];
+	alarm_init(&new_timer->it.alarmtimer, type, alarm_handle_timer);
+	return 0;
+}
+
+/**
+ * alarm_timer_get - posix timer_get interface
+ * @new_timer: k_itimer pointer
+ * @cur_setting: itimerspec data to fill
+ *
+ * Copies the itimerspec data out from the k_itimer
+ */
+static void alarm_timer_get(struct k_itimer *timr,
+				struct itimerspec *cur_setting)
+{
+	cur_setting->it_interval =
+			ktime_to_timespec(timr->it.alarmtimer.period);
+	cur_setting->it_value =
+			ktime_to_timespec(timr->it.alarmtimer.node.expires);
+	return;
+}
+
+/**
+ * alarm_timer_del - posix timer_del interface
+ * @timr: k_itimer pointer to be deleted
+ *
+ * Cancels any programmed alarms for the given timer.
+ */
+static int alarm_timer_del(struct k_itimer *timr)
+{
+	alarm_cancel(&timr->it.alarmtimer);
+	return 0;
+}
+
+/**
+ * alarm_timer_set - posix timer_set interface
+ * @timr: k_itimer pointer to be deleted
+ * @flags: timer flags
+ * @new_setting: itimerspec to be used
+ * @old_setting: itimerspec being replaced
+ *
+ * Sets the timer to new_setting, and starts the timer.
+ */
+static int alarm_timer_set(struct k_itimer *timr, int flags,
+				struct itimerspec *new_setting,
+				struct itimerspec *old_setting)
+{
+	/* Save old values */
+	old_setting->it_interval =
+			ktime_to_timespec(timr->it.alarmtimer.period);
+	old_setting->it_value =
+			ktime_to_timespec(timr->it.alarmtimer.node.expires);
+
+	/* If the timer was already set, cancel it */
+	alarm_cancel(&timr->it.alarmtimer);
+
+	/* start the timer */
+	alarm_start(&timr->it.alarmtimer,
+			timespec_to_ktime(new_setting->it_value),
+			timespec_to_ktime(new_setting->it_interval));
+	return 0;
+}
+
+/**
+ * alarmtimer_nsleep_wakeup - Wakeup function for alarm_timer_nsleep
+ * @alarm: ptr to alarm that fired
+ *
+ * Wakes up the task that set the alarmtimer
+ */
+static void alarmtimer_nsleep_wakeup(struct alarm *alarm)
+{
+	struct task_struct *task = (struct task_struct *)alarm->data;
+
+	alarm->data = NULL;
+	if (task)
+		wake_up_process(task);
+}
+
+/**
+ * alarmtimer_do_nsleep - Internal alarmtimer nsleep implementation
+ * @alarm: ptr to alarmtimer
+ * @absexp: absolute expiration time
+ *
+ * Sets the alarm timer and sleeps until it is fired or interrupted.
+ */
+static int alarmtimer_do_nsleep(struct alarm *alarm, ktime_t absexp)
+{
+	alarm->data = (void *)current;
+	do {
+		set_current_state(TASK_INTERRUPTIBLE);
+		alarm_start(alarm, absexp, ktime_set(0, 0));
+		if (likely(alarm->data))
+			schedule();
+
+		alarm_cancel(alarm);
+	} while (alarm->data && !signal_pending(current));
+
+	__set_current_state(TASK_RUNNING);
+
+	return (alarm->data == NULL);
+}
+
+
+/**
+ * update_rmtp - Update remaining timespec value
+ * @exp: expiration time
+ * @type: timer type
+ * @rmtp: user pointer to remaining timepsec value
+ *
+ * Helper function that fills in rmtp value with time between
+ * now and the exp value
+ */
+static int update_rmtp(ktime_t exp, enum  alarmtimer_type type,
+			struct timespec __user *rmtp)
+{
+	struct timespec rmt;
+	ktime_t rem;
+
+	rem = ktime_sub(exp, alarm_bases[type].gettime());
+
+	if (rem.tv64 <= 0)
+		return 0;
+	rmt = ktime_to_timespec(rem);
+
+	if (copy_to_user(rmtp, &rmt, sizeof(*rmtp)))
+		return -EFAULT;
+
+	return 1;
+
+}
+
+/**
+ * alarm_timer_nsleep_restart - restartblock alarmtimer nsleep
+ * @restart: ptr to restart block
+ *
+ * Handles restarted clock_nanosleep calls
+ */
+static long __sched alarm_timer_nsleep_restart(struct restart_block *restart)
+{
+	enum  alarmtimer_type type = restart->nanosleep.index;
+	ktime_t exp;
+	struct timespec __user  *rmtp;
+	struct alarm alarm;
+	int ret = 0;
+
+	exp.tv64 = restart->nanosleep.expires;
+	alarm_init(&alarm, type, alarmtimer_nsleep_wakeup);
+
+	if (alarmtimer_do_nsleep(&alarm, exp))
+		goto out;
+	rmtp = restart->nanosleep.rmtp;
+	if (rmtp) {
+		ret = update_rmtp(exp, type, rmtp);
+		if (ret <= 0)
+			goto out;
+	}
+	/* The other values in restart are already filled in */
+	ret = -ERESTART_RESTARTBLOCK;
+out:
+	return ret;
+}
+
+/**
+ * alarm_timer_nsleep - alarmtimer nanosleep
+ * @which_clock: clockid
+ * @flags: determins abstime or relative
+ * @tsreq: requested sleep time (abs or rel)
+ * @rmtp: remaining sleep time saved
+ *
+ * Handles clock_nanosleep calls against _ALARM clockids
+ */
+static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
+		     struct timespec *tsreq, struct timespec __user *rmtp)
+{
+	enum  alarmtimer_type type = clock2alarm(which_clock);
+	struct alarm alarm;
+	ktime_t exp;
+	int ret = 0;
+	struct restart_block *restart;
+
+	alarm_init(&alarm, type, alarmtimer_nsleep_wakeup);
+
+	exp = timespec_to_ktime(*tsreq);
+	/* Convert (if necessary) to absolute time */
+	if (flags != TIMER_ABSTIME) {
+		ktime_t now = alarm_bases[type].gettime();
+		exp = ktime_add(now, exp);
+	}
+
+	if (alarmtimer_do_nsleep(&alarm, exp))
+		goto out;
+	/* abs timers don't set remaining time or restart */
+	if (flags == TIMER_ABSTIME) {
+		ret = -ERESTARTNOHAND;
+		goto out;
+	}
+
+	if (rmtp) {
+		ret = update_rmtp(exp, type, rmtp);
+		if (ret <= 0)
+			goto out;
+	}
+
+	restart = &current_thread_info()->restart_block;
+	restart->fn = alarm_timer_nsleep_restart;
+	restart->nanosleep.index = type;
+	restart->nanosleep.expires = exp.tv64;
+	restart->nanosleep.rmtp = rmtp;
+	ret = -ERESTART_RESTARTBLOCK;
+
+out:
+	return ret;
+}
+
+/**************************************************************************
+ * alarmtimer initialization code
+ */
+
+/* Suspend hook structures */
+static const struct dev_pm_ops alarmtimer_pm_ops = {
+	.suspend = alarmtimer_suspend,
+};
+
+static struct platform_driver alarmtimer_driver = {
+	.driver = {
+		.name = "alarmtimer",
+		.pm = &alarmtimer_pm_ops,
+	}
+};
+
+/**
+ * alarmtimer_init - Initialize alarm timer code
+ *
+ * This function initializes the alarm bases and registers
+ * the posix clock ids.
+ */
+static int __init alarmtimer_init(void)
+{
+	int error = 0;
+	int i;
+	struct k_clock alarm_clock = {
+		.clock_getres = alarm_clock_getres,
+		.clock_get = alarm_clock_get,
+		.clock_set = do_posix_clock_nosettime,
+		.timer_create = alarm_timer_create,
+		.timer_set = alarm_timer_set,
+		.timer_del = alarm_timer_del,
+		.timer_get = alarm_timer_get,
+		.nsleep = alarm_timer_nsleep,
+	};
+
+	register_posix_clock(CLOCK_REALTIME_ALARM, &alarm_clock);
+	register_posix_clock(CLOCK_MONOTONIC_ALARM, &alarm_clock);
+
+	/* Initialize alarm bases */
+	alarm_bases[ALARM_REALTIME].base_clockid = CLOCK_REALTIME;
+	alarm_bases[ALARM_REALTIME].gettime = &ktime_get_real;
+	alarm_bases[ALARM_MONOTONIC].base_clockid = CLOCK_MONOTONIC;
+	alarm_bases[ALARM_MONOTONIC].gettime = &ktime_get;
+	for (i = 0; i < ALARM_NUMTYPE; i++) {
+		timerlist_init_head(&alarm_bases[i].timerlist);
+		mutex_init(&alarm_bases[i].lock);
+		hrtimer_init(&alarm_bases[i].timer,
+				alarm_bases[i].base_clockid,
+				HRTIMER_MODE_ABS);
+		alarm_bases[i].timer.function = alarmtimer_fired;
+		INIT_WORK(&alarm_bases[i].irqwork, alarmtimer_do_work);
+	}
+	error = platform_driver_register(&alarmtimer_driver);
+	platform_device_register_simple("alarmtimer", -1, NULL, 0);
+
+	return error;
+}
+device_initcall(alarmtimer_init);
+
+/**
+ * has_wakealarm - check rtc device has wakealarm ability
+ * @dev: current device
+ * @name_ptr: name to be returned
+ *
+ * This helper function checks to see if the rtc device can wake
+ * from suspend.
+ */
+static int __init has_wakealarm(struct device *dev, void *name_ptr)
+{
+	struct rtc_device *candidate = to_rtc_device(dev);
+
+	if (!candidate->ops->set_alarm)
+		return 0;
+	if (!device_may_wakeup(candidate->dev.parent))
+		return 0;
+
+	*(const char **)name_ptr = dev_name(dev);
+	return 1;
+}
+
+/**
+ * alarmtimer_init_late - Late initializing of alarmtimer code
+ *
+ * This function locates a rtc device to use for wakealarms.
+ * Run as late_initcall to make sure rtc devices have been
+ * registered.
+ */
+static int __init alarmtimer_init_late(void)
+{
+	char *str;
+
+	/* Find an rtc device and init the rtctimer */
+	class_find_device(rtc_class, NULL, &str, has_wakealarm);
+	if (str)
+		rtcdev = rtc_class_open(str);
+	if (!rtcdev) {
+		printk(KERN_WARNING "No RTC device found, ALARM timers will"
+			" not wake from suspend");
+	}
+	rtctimer_init(&rtctimer, NULL, NULL);
+
+	return 0;
+}
+late_initcall(alarmtimer_init_late);
-- 
1.7.3.2.146.gca209

