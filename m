Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934703Ab1ESUg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:36:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50757 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933968Ab1ESUgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:36:55 -0400
Date: Thu, 19 May 2011 22:36:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timers/core changes for v2.6.40
Message-ID: <20110519203636.GA23801@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-core-for-linus

This, amongst other things, introduces a new ABI: alarm timers, via two new 
clock IDs, CLOCK_REALTIME_ALARM and CLOCK_BOOTTIME_ALARM.

 Thanks,

	Ingo

------------------>
John Stultz (8):
      time: Add timekeeping_inject_sleeptime
      timers: Add rb_init_node() to allow for stack allocated rb nodes
      timers: Introduce in-kernel alarm-timer interface
      timers: Posix interface for alarm-timers
      timers: Improve alarmtimer comments and minor fixes
      timers: Remove delayed irqwork from alarmtimers implementation
      timers: Fix alarmtimer build issues when CONFIG_RTC_CLASS=n
      RTC: Disable CONFIG_RTC_CLASS from being built as a module

Mike Frysinger (1):
      hrtimer: Make lookup table const


 drivers/rtc/Kconfig          |    7 +-
 drivers/rtc/class.c          |   23 +-
 include/linux/alarmtimer.h   |   40 +++
 include/linux/capability.h   |    7 +-
 include/linux/posix-timers.h |    2 +
 include/linux/rbtree.h       |    8 +
 include/linux/time.h         |    3 +
 include/linux/timerqueue.h   |    2 +-
 kernel/hrtimer.c             |    2 +-
 kernel/time/Makefile         |    2 +-
 kernel/time/alarmtimer.c     |  694 ++++++++++++++++++++++++++++++++++++++++++
 kernel/time/timekeeping.c    |   56 ++++-
 12 files changed, 820 insertions(+), 26 deletions(-)
 create mode 100644 include/linux/alarmtimer.h
 create mode 100644 kernel/time/alarmtimer.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index e187887..4289172 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -3,10 +3,10 @@
 #
 
 config RTC_LIB
-	tristate
+	bool
 
 menuconfig RTC_CLASS
-	tristate "Real Time Clock"
+	bool "Real Time Clock"
 	default n
 	depends on !S390
 	select RTC_LIB
@@ -15,9 +15,6 @@ menuconfig RTC_CLASS
  	  be allowed to plug one or more RTCs to your system. You will
 	  probably want to enable one or more of the interfaces below.
 
-	  This driver can also be built as a module. If so, the module
-	  will be called rtc-core.
-
 if RTC_CLASS
 
 config RTC_HCTOSYS
diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 3901386..4194e59 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -41,26 +41,21 @@ static void rtc_device_release(struct device *dev)
  * system's wall clock; restore it on resume().
  */
 
-static struct timespec	delta;
 static time_t		oldtime;
+static struct timespec	oldts;
 
 static int rtc_suspend(struct device *dev, pm_message_t mesg)
 {
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
-	struct timespec		ts = current_kernel_time();
 
 	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
 
 	rtc_read_time(rtc, &tm);
+	ktime_get_ts(&oldts);
 	rtc_tm_to_time(&tm, &oldtime);
 
-	/* RTC precision is 1 second; adjust delta for avg 1/2 sec err */
-	set_normalized_timespec(&delta,
-				ts.tv_sec - oldtime,
-				ts.tv_nsec - (NSEC_PER_SEC >> 1));
-
 	return 0;
 }
 
@@ -70,10 +65,12 @@ static int rtc_resume(struct device *dev)
 	struct rtc_time		tm;
 	time_t			newtime;
 	struct timespec		time;
+	struct timespec		newts;
 
 	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
 
+	ktime_get_ts(&newts);
 	rtc_read_time(rtc, &tm);
 	if (rtc_valid_tm(&tm) != 0) {
 		pr_debug("%s:  bogus resume time\n", dev_name(&rtc->dev));
@@ -85,15 +82,13 @@ static int rtc_resume(struct device *dev)
 			pr_debug("%s:  time travel!\n", dev_name(&rtc->dev));
 		return 0;
 	}
+	/* calculate the RTC time delta */
+	set_normalized_timespec(&time, newtime - oldtime, 0);
 
-	/* restore wall clock using delta against this RTC;
-	 * adjust again for avg 1/2 second RTC sampling error
-	 */
-	set_normalized_timespec(&time,
-				newtime + delta.tv_sec,
-				(NSEC_PER_SEC >> 1) + delta.tv_nsec);
-	do_settimeofday(&time);
+	/* subtract kernel time between rtc_suspend to rtc_resume */
+	time = timespec_sub(time, timespec_sub(newts, oldts));
 
+	timekeeping_inject_sleeptime(&time);
 	return 0;
 }
 
diff --git a/include/linux/alarmtimer.h b/include/linux/alarmtimer.h
new file mode 100644
index 0000000..c5d6095
--- /dev/null
+++ b/include/linux/alarmtimer.h
@@ -0,0 +1,40 @@
+#ifndef _LINUX_ALARMTIMER_H
+#define _LINUX_ALARMTIMER_H
+
+#include <linux/time.h>
+#include <linux/hrtimer.h>
+#include <linux/timerqueue.h>
+#include <linux/rtc.h>
+
+enum alarmtimer_type {
+	ALARM_REALTIME,
+	ALARM_BOOTTIME,
+
+	ALARM_NUMTYPE,
+};
+
+/**
+ * struct alarm - Alarm timer structure
+ * @node:	timerqueue node for adding to the event list this value
+ *		also includes the expiration time.
+ * @period:	Period for recuring alarms
+ * @function:	Function pointer to be executed when the timer fires.
+ * @type:	Alarm type (BOOTTIME/REALTIME)
+ * @enabled:	Flag that represents if the alarm is set to fire or not
+ * @data:	Internal data value.
+ */
+struct alarm {
+	struct timerqueue_node	node;
+	ktime_t			period;
+	void			(*function)(struct alarm *);
+	enum alarmtimer_type	type;
+	bool			enabled;
+	void			*data;
+};
+
+void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
+		void (*function)(struct alarm *));
+void alarm_start(struct alarm *alarm, ktime_t start, ktime_t period);
+void alarm_cancel(struct alarm *alarm);
+
+#endif
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 16ee8b4..7cb23ea 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -355,7 +355,12 @@ struct cpu_vfs_cap_data {
 
 #define CAP_SYSLOG           34
 
-#define CAP_LAST_CAP         CAP_SYSLOG
+/* Allow triggering something that will wake the system */
+
+#define CAP_WAKE_ALARM            35
+
+
+#define CAP_LAST_CAP         CAP_WAKE_ALARM
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index d51243a..808227d 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -5,6 +5,7 @@
 #include <linux/list.h>
 #include <linux/sched.h>
 #include <linux/timex.h>
+#include <linux/alarmtimer.h>
 
 union cpu_time_count {
 	cputime_t cpu;
@@ -80,6 +81,7 @@ struct k_itimer {
 			unsigned long incr;
 			unsigned long expires;
 		} mmtimer;
+		struct alarm alarmtimer;
 	} it;
 };
 
diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 7066acb..033b507 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -136,6 +136,14 @@ static inline void rb_set_color(struct rb_node *rb, int color)
 #define RB_EMPTY_NODE(node)	(rb_parent(node) == node)
 #define RB_CLEAR_NODE(node)	(rb_set_parent(node, node))
 
+static inline void rb_init_node(struct rb_node *rb)
+{
+	rb->rb_parent_color = 0;
+	rb->rb_right = NULL;
+	rb->rb_left = NULL;
+	RB_CLEAR_NODE(rb);
+}
+
 extern void rb_insert_color(struct rb_node *, struct rb_root *);
 extern void rb_erase(struct rb_node *, struct rb_root *);
 
diff --git a/include/linux/time.h b/include/linux/time.h
index 454a262..b306178 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -126,6 +126,7 @@ struct timespec __current_kernel_time(void); /* does not take xtime_lock */
 struct timespec get_monotonic_coarse(void);
 void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 				struct timespec *wtom, struct timespec *sleep);
+void timekeeping_inject_sleeptime(struct timespec *delta);
 
 #define CURRENT_TIME		(current_kernel_time())
 #define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
@@ -294,6 +295,8 @@ struct itimerval {
 #define CLOCK_REALTIME_COARSE		5
 #define CLOCK_MONOTONIC_COARSE		6
 #define CLOCK_BOOTTIME			7
+#define CLOCK_REALTIME_ALARM		8
+#define CLOCK_BOOTTIME_ALARM		9
 
 /*
  * The IDs of various hardware clocks:
diff --git a/include/linux/timerqueue.h b/include/linux/timerqueue.h
index a520fd7..5088727 100644
--- a/include/linux/timerqueue.h
+++ b/include/linux/timerqueue.h
@@ -39,7 +39,7 @@ struct timerqueue_node *timerqueue_getnext(struct timerqueue_head *head)
 
 static inline void timerqueue_init(struct timerqueue_node *node)
 {
-	RB_CLEAR_NODE(&node->node);
+	rb_init_node(&node->node);
 }
 
 static inline void timerqueue_init_head(struct timerqueue_head *head)
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 87fdb3f..dbbbf7d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -81,7 +81,7 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 	}
 };
 
-static int hrtimer_clock_to_base_table[MAX_CLOCKS] = {
+static const int hrtimer_clock_to_base_table[MAX_CLOCKS] = {
 	[CLOCK_REALTIME]	= HRTIMER_BASE_REALTIME,
 	[CLOCK_MONOTONIC]	= HRTIMER_BASE_MONOTONIC,
 	[CLOCK_BOOTTIME]	= HRTIMER_BASE_BOOTTIME,
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index b042599..e2fd74b 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -1,5 +1,5 @@
 obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o timecompare.o
-obj-y += timeconv.o posix-clock.o
+obj-y += timeconv.o posix-clock.o alarmtimer.o
 
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BUILD)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
new file mode 100644
index 0000000..9265014
--- /dev/null
+++ b/kernel/time/alarmtimer.c
@@ -0,0 +1,694 @@
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
+#include <linux/timerqueue.h>
+#include <linux/rtc.h>
+#include <linux/alarmtimer.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/posix-timers.h>
+#include <linux/workqueue.h>
+#include <linux/freezer.h>
+
+/**
+ * struct alarm_base - Alarm timer bases
+ * @lock:		Lock for syncrhonized access to the base
+ * @timerqueue:		Timerqueue head managing the list of events
+ * @timer: 		hrtimer used to schedule events while running
+ * @gettime:		Function to read the time correlating to the base
+ * @base_clockid:	clockid for the base
+ */
+static struct alarm_base {
+	spinlock_t		lock;
+	struct timerqueue_head	timerqueue;
+	struct hrtimer		timer;
+	ktime_t			(*gettime)(void);
+	clockid_t		base_clockid;
+} alarm_bases[ALARM_NUMTYPE];
+
+#ifdef CONFIG_RTC_CLASS
+/* rtc timer and device for setting alarm wakeups at suspend */
+static struct rtc_timer		rtctimer;
+static struct rtc_device	*rtcdev;
+#endif
+
+/* freezer delta & lock used to handle clock_nanosleep triggered wakeups */
+static ktime_t freezer_delta;
+static DEFINE_SPINLOCK(freezer_delta_lock);
+
+
+/**
+ * alarmtimer_enqueue - Adds an alarm timer to an alarm_base timerqueue
+ * @base: pointer to the base where the timer is being run
+ * @alarm: pointer to alarm being enqueued.
+ *
+ * Adds alarm to a alarm_base timerqueue and if necessary sets
+ * an hrtimer to run.
+ *
+ * Must hold base->lock when calling.
+ */
+static void alarmtimer_enqueue(struct alarm_base *base, struct alarm *alarm)
+{
+	timerqueue_add(&base->timerqueue, &alarm->node);
+	if (&alarm->node == timerqueue_getnext(&base->timerqueue)) {
+		hrtimer_try_to_cancel(&base->timer);
+		hrtimer_start(&base->timer, alarm->node.expires,
+				HRTIMER_MODE_ABS);
+	}
+}
+
+/**
+ * alarmtimer_remove - Removes an alarm timer from an alarm_base timerqueue
+ * @base: pointer to the base where the timer is running
+ * @alarm: pointer to alarm being removed
+ *
+ * Removes alarm to a alarm_base timerqueue and if necessary sets
+ * a new timer to run.
+ *
+ * Must hold base->lock when calling.
+ */
+static void alarmtimer_remove(struct alarm_base *base, struct alarm *alarm)
+{
+	struct timerqueue_node *next = timerqueue_getnext(&base->timerqueue);
+
+	timerqueue_del(&base->timerqueue, &alarm->node);
+	if (next == &alarm->node) {
+		hrtimer_try_to_cancel(&base->timer);
+		next = timerqueue_getnext(&base->timerqueue);
+		if (!next)
+			return;
+		hrtimer_start(&base->timer, next->expires, HRTIMER_MODE_ABS);
+	}
+}
+
+
+/**
+ * alarmtimer_fired - Handles alarm hrtimer being fired.
+ * @timer: pointer to hrtimer being run
+ *
+ * When a alarm timer fires, this runs through the timerqueue to
+ * see which alarms expired, and runs those. If there are more alarm
+ * timers queued for the future, we set the hrtimer to fire when
+ * when the next future alarm timer expires.
+ */
+static enum hrtimer_restart alarmtimer_fired(struct hrtimer *timer)
+{
+	struct alarm_base *base = container_of(timer, struct alarm_base, timer);
+	struct timerqueue_node *next;
+	unsigned long flags;
+	ktime_t now;
+	int ret = HRTIMER_NORESTART;
+
+	spin_lock_irqsave(&base->lock, flags);
+	now = base->gettime();
+	while ((next = timerqueue_getnext(&base->timerqueue))) {
+		struct alarm *alarm;
+		ktime_t expired = next->expires;
+
+		if (expired.tv64 >= now.tv64)
+			break;
+
+		alarm = container_of(next, struct alarm, node);
+
+		timerqueue_del(&base->timerqueue, &alarm->node);
+		alarm->enabled = 0;
+		/* Re-add periodic timers */
+		if (alarm->period.tv64) {
+			alarm->node.expires = ktime_add(expired, alarm->period);
+			timerqueue_add(&base->timerqueue, &alarm->node);
+			alarm->enabled = 1;
+		}
+		spin_unlock_irqrestore(&base->lock, flags);
+		if (alarm->function)
+			alarm->function(alarm);
+		spin_lock_irqsave(&base->lock, flags);
+	}
+
+	if (next) {
+		hrtimer_set_expires(&base->timer, next->expires);
+		ret = HRTIMER_RESTART;
+	}
+	spin_unlock_irqrestore(&base->lock, flags);
+
+	return ret;
+
+}
+
+#ifdef CONFIG_RTC_CLASS
+/**
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
+	ktime_t min, now;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&freezer_delta_lock, flags);
+	min = freezer_delta;
+	freezer_delta = ktime_set(0, 0);
+	spin_unlock_irqrestore(&freezer_delta_lock, flags);
+
+	/* If we have no rtcdev, just return */
+	if (!rtcdev)
+		return 0;
+
+	/* Find the soonest timer to expire*/
+	for (i = 0; i < ALARM_NUMTYPE; i++) {
+		struct alarm_base *base = &alarm_bases[i];
+		struct timerqueue_node *next;
+		ktime_t delta;
+
+		spin_lock_irqsave(&base->lock, flags);
+		next = timerqueue_getnext(&base->timerqueue);
+		spin_unlock_irqrestore(&base->lock, flags);
+		if (!next)
+			continue;
+		delta = ktime_sub(next->expires, base->gettime());
+		if (!min.tv64 || (delta.tv64 < min.tv64))
+			min = delta;
+	}
+	if (min.tv64 == 0)
+		return 0;
+
+	/* XXX - Should we enforce a minimum sleep time? */
+	WARN_ON(min.tv64 < NSEC_PER_SEC);
+
+	/* Setup an rtc timer to fire that far in the future */
+	rtc_timer_cancel(rtcdev, &rtctimer);
+	rtc_read_time(rtcdev, &tm);
+	now = rtc_tm_to_ktime(tm);
+	now = ktime_add(now, min);
+
+	rtc_timer_start(rtcdev, &rtctimer, now, ktime_set(0, 0));
+
+	return 0;
+}
+#else
+static int alarmtimer_suspend(struct device *dev)
+{
+	return 0;
+}
+#endif
+
+static void alarmtimer_freezerset(ktime_t absexp, enum alarmtimer_type type)
+{
+	ktime_t delta;
+	unsigned long flags;
+	struct alarm_base *base = &alarm_bases[type];
+
+	delta = ktime_sub(absexp, base->gettime());
+
+	spin_lock_irqsave(&freezer_delta_lock, flags);
+	if (!freezer_delta.tv64 || (delta.tv64 < freezer_delta.tv64))
+		freezer_delta = delta;
+	spin_unlock_irqrestore(&freezer_delta_lock, flags);
+}
+
+
+/**
+ * alarm_init - Initialize an alarm structure
+ * @alarm: ptr to alarm to be initialized
+ * @type: the type of the alarm
+ * @function: callback that is run when the alarm fires
+ */
+void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
+		void (*function)(struct alarm *))
+{
+	timerqueue_init(&alarm->node);
+	alarm->period = ktime_set(0, 0);
+	alarm->function = function;
+	alarm->type = type;
+	alarm->enabled = 0;
+}
+
+/**
+ * alarm_start - Sets an alarm to fire
+ * @alarm: ptr to alarm to set
+ * @start: time to run the alarm
+ * @period: period at which the alarm will recur
+ */
+void alarm_start(struct alarm *alarm, ktime_t start, ktime_t period)
+{
+	struct alarm_base *base = &alarm_bases[alarm->type];
+	unsigned long flags;
+
+	spin_lock_irqsave(&base->lock, flags);
+	if (alarm->enabled)
+		alarmtimer_remove(base, alarm);
+	alarm->node.expires = start;
+	alarm->period = period;
+	alarmtimer_enqueue(base, alarm);
+	alarm->enabled = 1;
+	spin_unlock_irqrestore(&base->lock, flags);
+}
+
+/**
+ * alarm_cancel - Tries to cancel an alarm timer
+ * @alarm: ptr to alarm to be canceled
+ */
+void alarm_cancel(struct alarm *alarm)
+{
+	struct alarm_base *base = &alarm_bases[alarm->type];
+	unsigned long flags;
+
+	spin_lock_irqsave(&base->lock, flags);
+	if (alarm->enabled)
+		alarmtimer_remove(base, alarm);
+	alarm->enabled = 0;
+	spin_unlock_irqrestore(&base->lock, flags);
+}
+
+
+/**
+ * clock2alarm - helper that converts from clockid to alarmtypes
+ * @clockid: clockid.
+ */
+static enum alarmtimer_type clock2alarm(clockid_t clockid)
+{
+	if (clockid == CLOCK_REALTIME_ALARM)
+		return ALARM_REALTIME;
+	if (clockid == CLOCK_BOOTTIME_ALARM)
+		return ALARM_BOOTTIME;
+	return -1;
+}
+
+/**
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
+/**
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
+	if (!capable(CAP_WAKE_ALARM))
+		return -EPERM;
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
+
+	if (freezing(current))
+		alarmtimer_freezerset(exp, type);
+
+	rmtp = restart->nanosleep.rmtp;
+	if (rmtp) {
+		ret = update_rmtp(exp, type, rmtp);
+		if (ret <= 0)
+			goto out;
+	}
+
+
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
+	if (!capable(CAP_WAKE_ALARM))
+		return -EPERM;
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
+
+	if (freezing(current))
+		alarmtimer_freezerset(exp, type);
+
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
+		.clock_getres	= alarm_clock_getres,
+		.clock_get	= alarm_clock_get,
+		.timer_create	= alarm_timer_create,
+		.timer_set	= alarm_timer_set,
+		.timer_del	= alarm_timer_del,
+		.timer_get	= alarm_timer_get,
+		.nsleep		= alarm_timer_nsleep,
+	};
+
+	posix_timers_register_clock(CLOCK_REALTIME_ALARM, &alarm_clock);
+	posix_timers_register_clock(CLOCK_BOOTTIME_ALARM, &alarm_clock);
+
+	/* Initialize alarm bases */
+	alarm_bases[ALARM_REALTIME].base_clockid = CLOCK_REALTIME;
+	alarm_bases[ALARM_REALTIME].gettime = &ktime_get_real;
+	alarm_bases[ALARM_BOOTTIME].base_clockid = CLOCK_BOOTTIME;
+	alarm_bases[ALARM_BOOTTIME].gettime = &ktime_get_boottime;
+	for (i = 0; i < ALARM_NUMTYPE; i++) {
+		timerqueue_init_head(&alarm_bases[i].timerqueue);
+		spin_lock_init(&alarm_bases[i].lock);
+		hrtimer_init(&alarm_bases[i].timer,
+				alarm_bases[i].base_clockid,
+				HRTIMER_MODE_ABS);
+		alarm_bases[i].timer.function = alarmtimer_fired;
+	}
+	error = platform_driver_register(&alarmtimer_driver);
+	platform_device_register_simple("alarmtimer", -1, NULL, 0);
+
+	return error;
+}
+device_initcall(alarmtimer_init);
+
+#ifdef CONFIG_RTC_CLASS
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
+	/* Find an rtc device and init the rtc_timer */
+	class_find_device(rtc_class, NULL, &str, has_wakealarm);
+	if (str)
+		rtcdev = rtc_class_open(str);
+	if (!rtcdev) {
+		printk(KERN_WARNING "No RTC device found, ALARM timers will"
+			" not wake from suspend");
+	}
+	rtc_timer_init(&rtctimer, NULL, NULL);
+
+	return 0;
+}
+#else
+static int __init alarmtimer_init_late(void)
+{
+	printk(KERN_WARNING "Kernel not built with RTC support, ALARM timers"
+		" will not wake from suspend");
+	return 0;
+}
+#endif
+late_initcall(alarmtimer_init_late);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 8ad5d57..8e6a05a 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -596,6 +596,58 @@ void __init timekeeping_init(void)
 static struct timespec timekeeping_suspend_time;
 
 /**
+ * __timekeeping_inject_sleeptime - Internal function to add sleep interval
+ * @delta: pointer to a timespec delta value
+ *
+ * Takes a timespec offset measuring a suspend interval and properly
+ * adds the sleep offset to the timekeeping variables.
+ */
+static void __timekeeping_inject_sleeptime(struct timespec *delta)
+{
+	xtime = timespec_add(xtime, *delta);
+	wall_to_monotonic = timespec_sub(wall_to_monotonic, *delta);
+	total_sleep_time = timespec_add(total_sleep_time, *delta);
+}
+
+
+/**
+ * timekeeping_inject_sleeptime - Adds suspend interval to timeekeeping values
+ * @delta: pointer to a timespec delta value
+ *
+ * This hook is for architectures that cannot support read_persistent_clock
+ * because their RTC/persistent clock is only accessible when irqs are enabled.
+ *
+ * This function should only be called by rtc_resume(), and allows
+ * a suspend offset to be injected into the timekeeping values.
+ */
+void timekeeping_inject_sleeptime(struct timespec *delta)
+{
+	unsigned long flags;
+	struct timespec ts;
+
+	/* Make sure we don't set the clock twice */
+	read_persistent_clock(&ts);
+	if (!(ts.tv_sec == 0 && ts.tv_nsec == 0))
+		return;
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+	timekeeping_forward_now();
+
+	__timekeeping_inject_sleeptime(delta);
+
+	timekeeper.ntp_error = 0;
+	ntp_clear();
+	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+				timekeeper.mult);
+
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	/* signal hrtimers about time change */
+	clock_was_set();
+}
+
+
+/**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
  *
  * This is for the generic clocksource timekeeping.
@@ -615,9 +667,7 @@ static void timekeeping_resume(void)
 
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
 		ts = timespec_sub(ts, timekeeping_suspend_time);
-		xtime = timespec_add(xtime, ts);
-		wall_to_monotonic = timespec_sub(wall_to_monotonic, ts);
-		total_sleep_time = timespec_add(total_sleep_time, ts);
+		__timekeeping_inject_sleeptime(&ts);
 	}
 	/* re-base the last cycle value */
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
