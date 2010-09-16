Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab0IPTll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:41:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56766 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab0IPTlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:41:40 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        David Brownell <david-b@pacbell.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Posix CLOCK_RTC interface proof of concept
Date: Thu, 16 Sep 2010 12:41:32 -0700
Message-Id: <1284666092-23347-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a CLOCK_RTC clockid allowing the rtc to be managed
via a posix_clocks/timers interface. This allows applications to
program timer events that will wake the system from suspend state.
If the system is not suspended, the timers fire like normal
posix timers.

Currently, if an application wants to trigger a RTC alarm to wake up
from suspend, they must use the sysfs wakealarm interface or the rtc
chardev RTC_WKALM_SET ioctl. The limitation with this interface is
that it is fairly hardware oriented, so multiple applications cannot
set an RTC alarm without overwriting any previous alarms set by other
applications.

The in-kernel posix interface allows for the kernel to manage a list
of timers that control when the alarm is fired, so applications
do not need to coordinate access to the alarm hardware.

This patch is provided as a proof of concept, and is not submitted
for inclusion. There are still a number of issues I'd like to decide
upon before submitting any similar change.

1) This implementation does not block the direct RTC alarm control via
sysfs or chardev ioctl. It just creates a parallel interface, which
means there are race issues if both methods are used at the same time.

I'd prefer to embed the posix timer list below the sysfs/ioctl
interfaces, so those interfaces are in effect virtualized. Instead
of directly accessing the hardware, alarms set via that interface
would be only one of many possible timers managed in the timer list
by the kernel. This will provide ABI compatibility, but will cause
some heavy churn in the generic RTC management code.

2) While not commonly seen on PC/server hardware, many architectures
allow for multiple RTC devices on a system. I'm not completely
aware of the utility of multiple RTCs (other then allowing
multiple apps to trigger multiple wake events without a kernel managed
timer list), but I'm willing to be enlightened.

Exposing multiple RTCs via the posix clock interface has some tradeoffs.

a) Some application programmers may really want to see the underlying
hardware and be sophisticated enough to deal with the multiple,
possibly unsynchronized, time domains.

b) Some application programmers may not care about the hardware, and
just want a interface that works like CLOCK_REALTIME, but fires
wakeup alarms if the system is suspended.

Exposing all the RTC devices in a somewhat raw manner is probably
the most straight forward. Some extra infrastructure, like
the dynamic posix-clockid allocation Richard Cochran has
started to look into will be needed. More concerning is that
this will probably cause some grief if someone creates a cron-like
tool that uses the RTC where the RTC isn't exactly synced with
system time. When the user specified a job for 6am, do they mean
6am system time, or RTC?

And note: on many PCs, the RTC is synchronized, but kept in local
time, not UTC. So the unsynched RTC case is likely to be common.

To resolve this, we could create a somewhat meta CLOCK_RTC, which
really sets timers against CLOCK_REALTIME, but upon suspend
sets a relative alarm on the RTC for time interval remaining
on the next timer. This would probably need to be in addition to
the per-RTC interface, as we still need the per-RTC kernel
managed timer list to avoid races.

3) Adding the posix time interface makes it easier to have finer
grained capability management to decide what applications can
set a alarm timer. While this is great for creating applications
that can wake servers up from suspend mode, and simplifying the
wakeup infrastructure on cell phones, some systems may not
want applications being able to set wakeup timers. I can
imagine the "laptop in well insulated carry-on luggage" case
that comes up occasional being one of them. So some additional
thought and policy may be needed to decide when non-user-triggered
wake events should be masked or not in suspend.

So there is it. Clearly there is more work to be done, but
any comments or feedback would be greatly appreciated!

NOT FOR INCLUSION!
NOT FOR INCLUSION!
Signed-off-by: John Stultz <john.stultz@linaro.org>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: David Brownell <david-b@pacbell.net>
CC: Paul McKenney paulmck@linux.vnet.ibm.com>
CC: Richard Cochran <richardcochran@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/rtc/Makefile         |    2 +-
 drivers/rtc/posix.c          |  448 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/posix-timers.h |    5 +
 include/linux/time.h         |    1 +
 4 files changed, 455 insertions(+), 1 deletions(-)
 create mode 100644 drivers/rtc/posix.c

diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 0f207b3..e4a0b05 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -9,7 +9,7 @@ endif
 obj-$(CONFIG_RTC_LIB)		+= rtc-lib.o
 obj-$(CONFIG_RTC_HCTOSYS)	+= hctosys.o
 obj-$(CONFIG_RTC_CLASS)		+= rtc-core.o
-rtc-core-y			:= class.o interface.o
+rtc-core-y			:= class.o interface.o posix.o
 
 rtc-core-$(CONFIG_RTC_INTF_DEV)	+= rtc-dev.o
 rtc-core-$(CONFIG_RTC_INTF_PROC) += rtc-proc.o
diff --git a/drivers/rtc/posix.c b/drivers/rtc/posix.c
new file mode 100644
index 0000000..65e6bfc
--- /dev/null
+++ b/drivers/rtc/posix.c
@@ -0,0 +1,448 @@
+/*
+ * RTC posix-clock/timer interface
+ *
+ * Copyright (C) 2010 IBM Corperation
+ *
+ * Author: John Stultz <john.stultz@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/spinlock.h>
+#include <linux/posix-timers.h>
+#include <linux/rbtree.h>
+#include <linux/rtc.h>
+#include <linux/slab.h>
+
+struct rtc_device *rtc;
+
+/*
+ * Timer list structures.
+ */
+static DEFINE_SPINLOCK(rtctimer_lock);
+struct rb_root timer_head;
+struct rb_node *next_timer;
+
+
+/**
+ * timespec_to_time - Convert timespec to time.
+ * @ts: a timespec
+ *
+ * Helper function that converts timespec -> time.
+ * Rounds any nanoseconds up to the next second.
+ */
+static time_t timespec_to_time(struct timespec ts)
+{
+	time_t time = ts.tv_sec;
+	if (ts.tv_nsec)
+		time++;
+
+	return time;
+}
+
+/**
+ * time_to_timespec - Convert time to timespec
+ * @t: a time_t
+ *
+ * Helper function that converts time -> timespec
+ */
+static struct timespec time_to_timespec(time_t t)
+{
+	struct timespec ts;
+	ts.tv_sec = t;
+	ts.tv_nsec = 0;
+	return ts;
+}
+
+/**
+ * rtctimer_add_list - Add a timer to the timerlist
+ * @t: Pointer to timer to be added.
+ *
+ * The rtctimer_lock must be held when calling.
+ */
+static void rtctimer_add_list(struct k_itimer *t)
+{
+	struct rb_node **p = &timer_head.rb_node;
+	struct rb_node *parent = NULL;
+	struct k_itimer *ptr;
+
+	time_t expires = timespec_to_time(t->it.simple.it.it_value);
+
+	while (*p) {
+		time_t time;
+		parent = *p;
+		ptr = rb_entry(parent, struct k_itimer, it.simple.list);
+		time = timespec_to_time(ptr->it.simple.it.it_value);
+		if (expires < time)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&t->it.simple.list, parent, p);
+	rb_insert_color(&t->it.simple.list, &timer_head);
+
+	if (!next_timer ||
+		expires < rb_entry(next_timer, struct k_itimer,
+				it.simple.list)->it.simple.it.it_value.tv_sec)
+		next_timer = &t->it.simple.list;
+}
+
+/**
+ * rtctimer_del_list - Removes a timer from the timerlist
+ * @tmr: Pointer to timer to be removed
+ *
+ * The rtctimer_lock must be held when calling.
+ */
+static void rtctimer_del_list(struct k_itimer *tmr)
+{
+	struct rb_node *node = &tmr->it.simple.list;
+
+	/* update next pointer */
+	if (next_timer == node)
+		next_timer = rb_next(node);
+	rb_erase(node, &timer_head);
+}
+
+
+/**
+ * rtctimer_get_next - Returns the next timer to be expired
+ *
+ * The rtctimer_lock must be held when calling.
+ */
+static struct k_itimer *rtctimer_get_next(void)
+{
+	if (!next_timer)
+		return NULL;
+	return rb_entry(next_timer, struct k_itimer, it.simple.list);
+}
+
+
+/**
+ * rtc_clock_getres - posix getres interface
+ * @which_clock: clockid (ignored)
+ * @tp: timespec to fill.
+ *
+ * Returns the 1sec granularity of rtc interface
+ */
+static int rtc_clock_getres(const clockid_t which_clock, struct timespec *tp)
+{
+	*tp = time_to_timespec(1);
+	return 0;
+}
+
+/**
+ * rtc_clock_get - posix clock_get interface
+ * @which_clock: clockid (ignored)
+ * @tp: timespec to fill.
+ *
+ * Provides the time from the RTC
+ */
+static int rtc_clock_get(clockid_t which_clock, struct timespec *tp)
+{
+	struct rtc_time tm;
+	time_t sec;
+	int ret;
+
+	ret = rtc_read_time(rtc, &tm);
+	if (ret)
+		return ret;
+
+	rtc_tm_to_time(&tm, &sec);
+
+	*tp = time_to_timespec(sec);
+	return 0;
+}
+
+/**
+ * rtc_clock_set - posix clock_set interface
+ * @which_clock: clockid (ignored)
+ * @tp: timespec to fill.
+ *
+ * Sets the RTC to the specified time
+ */
+static int rtc_clock_set(clockid_t clockid, struct timespec *tp)
+{
+	struct rtc_time tm;
+	int ret;
+
+	rtc_time_to_tm(tp->tv_sec, &tm);
+
+	ret = rtc_set_time(rtc, &tm);
+	return ret;
+}
+
+
+
+/**
+ * rtc_timer_create - posix timer_create interface
+ * @new_timer: k_itimer pointer to manage
+ *
+ * Initializes the k_itimer structure.
+ */
+static int rtc_timer_create(struct k_itimer *new_timer)
+{
+	new_timer->it.simple.it.it_interval = time_to_timespec(0);
+	new_timer->it.simple.it.it_value = time_to_timespec(0);
+	new_timer->it.simple.enabled = 0;
+
+	return 0;
+}
+
+
+/**
+ * rtc_timer_get - posix timer_get interface
+ * @new_timer: k_itimer pointer
+ * @cur_setting: itimerspec data to fill
+ *
+ * Copies the itimerspec data out from the k_itimer
+ */
+static void rtc_timer_get(struct k_itimer *timr, struct itimerspec *cur_setting)
+{
+	*cur_setting = timr->it.simple.it;
+	return;
+}
+
+
+/**
+ * rtc_timer_del - posix timer_del interface
+ * @timr: k_itimer pointer to be deleted
+ *
+ * Cancels any programmed alarms for the given timer,
+ * then removes it from the timer list,then if needed,
+ * re-program the alarm for the next timer.
+ */
+static int rtc_timer_del(struct k_itimer *timr)
+{
+	unsigned long flags;
+	struct rtc_wkalrm alrm;
+	struct k_itimer *t;
+
+	spin_lock_irqsave(&rtctimer_lock, flags);
+
+	/* check if this timer is the current one */
+	t = rtctimer_get_next();
+	if (t && t == timr) {
+		/* Stop irq */
+		rtc_time_to_tm(0, &alrm.time);
+		alrm.enabled = 0;
+		rtc_set_alarm(rtc, &alrm);
+	}
+
+	/* Remove from list */
+	rtctimer_del_list(timr);
+	timr->it.simple.enabled = 0;
+
+	/* Set the alarm to fire on the next event */
+	t = rtctimer_get_next();
+	if (t) {
+		time_t exp = timespec_to_time(t->it.simple.it.it_value);
+		rtc_time_to_tm(exp, &alrm.time);
+		alrm.enabled = 1;
+		rtc_set_alarm(rtc, &alrm);
+	}
+	spin_unlock_irqrestore(&rtctimer_lock, flags);
+
+	return 0;
+}
+
+/**
+ * rtc_timer_set - posix timer_set interface
+ * @timr: k_itimer pointer to be deleted
+ * @flags: timer flags
+ * @new_setting: itimerspec to be used
+ * @old_setting: itimerspec being replaced
+ *
+ * Sets the timer to new_setting, adds the timer to
+ * the timer list, and if necessary sets an alarm for
+ * the new timer.
+ *
+ * If the timer was already set, it will cancel
+ * the old timer and return its value in old_settings.
+ */
+static int rtc_timer_set(struct k_itimer *timr, int flags,
+	struct itimerspec *new_setting,
+	struct itimerspec *old_setting)
+{
+	struct rtc_wkalrm alrm;
+	struct k_itimer *t;
+	unsigned long irqflag;
+	int ret = 0;
+
+	spin_lock_irqsave(&rtctimer_lock, irqflag);
+
+	if (old_setting)
+		rtc_timer_get(timr, old_setting);
+
+	/* If this timer was next up, cancel alarm */
+	t = rtctimer_get_next();
+	if (t && t == timr) {
+		rtc_time_to_tm(0, &alrm.time);
+		alrm.enabled = 0;
+		rtc_set_alarm(rtc, &alrm);
+	}
+
+	if (timr->it.simple.enabled) {
+		/* remove it from list */
+		rtctimer_del_list(timr);
+		timr->it.simple.enabled = 0;
+	}
+
+	if (!(flags & TIMER_ABSTIME)) {
+		/* Convert relative to abs */
+		struct rtc_time tm;
+		time_t now;
+		rtc_read_time(rtc, &tm);
+		rtc_tm_to_time(&tm, &now);
+
+		timr->it.simple.it.it_value = new_setting->it_value;
+		timr->it.simple.it.it_value.tv_sec += now;
+	} else
+		timr->it.simple.it.it_value = new_setting->it_value;
+
+	timr->it.simple.it.it_interval = new_setting->it_interval;
+
+	rtctimer_add_list(timr);
+	timr->it.simple.enabled = 1;
+
+	/* Set alarm */
+	t = rtctimer_get_next();
+	if (t == timr) {
+		time_t exp = timespec_to_time(t->it.simple.it.it_value);
+		rtc_time_to_tm(exp, &alrm.time);
+		alrm.enabled = 1;
+		rtc_set_alarm(rtc, &alrm);
+	}
+	spin_unlock_irqrestore(&rtctimer_lock, irqflag);
+
+	return ret;
+}
+
+
+/**
+ * no_nsleep - posix nsleep dummy interface
+ * @which_clock: ignored
+ * @flags: ignored
+ * @tsave: ignored
+ * @rmtp: ignored
+ *
+ * We don't implement nsleep, so this stub returns an error.
+ */
+static int no_nsleep(const clockid_t which_clock, int flags,
+		     struct timespec *tsave, struct timespec __user *rmtp)
+{
+	return -EOPNOTSUPP;
+}
+
+
+struct rtc_task irqhandler;
+/**
+ * rtc_handle_irq - RTC alarm interrupt callback
+ * @data: ignored
+ *
+ * This function is called when the RTC interrupt triggers.
+ * It runs through the timer list, expiring timers,
+ * then programs the alarm to fire on the next event.
+ */
+void rtc_handle_irq(void *data)
+{
+	unsigned long flags;
+	struct rtc_time tm;
+	unsigned long now;
+	struct k_itimer *ptr;
+	struct rtc_wkalrm alrm;
+
+	spin_lock_irqsave(&rtctimer_lock, flags);
+
+	/* read the clock */
+	rtc_read_time(rtc, &tm);
+	rtc_tm_to_time(&tm, &now);
+
+	/* expire timers */
+	ptr = rtctimer_get_next();
+	while (ptr) {
+		time_t exp = timespec_to_time(ptr->it.simple.it.it_value);
+		if (now < exp)
+			break;
+		if (posix_timer_event(ptr, 0) != 0)
+			ptr->it_overrun++;
+
+		rtctimer_del_list(ptr);
+		if (ptr->it.simple.it.it_interval.tv_sec ||
+				ptr->it.simple.it.it_interval.tv_nsec) {
+			/* Handle interval timers */
+			ptr->it.simple.it.it_value =
+				timespec_add(ptr->it.simple.it.it_value,
+					ptr->it.simple.it.it_interval);
+			rtctimer_add_list(ptr);
+		} else
+			ptr->it.simple.enabled = 0;
+
+		ptr = rtctimer_get_next();
+	}
+
+	/* Set the alarm to fire on the next event */
+	ptr = rtctimer_get_next();
+	if (ptr) {
+		time_t exp = timespec_to_time(ptr->it.simple.it.it_value);
+		rtc_time_to_tm(exp, &alrm.time);
+		alrm.enabled = 1;
+		rtc_set_alarm(rtc, &alrm);
+	}
+
+	spin_unlock_irqrestore(&rtctimer_lock, flags);
+}
+
+
+
+static int __init is_rtc(struct device *dev, void *name_ptr)
+{
+	*(const char **)name_ptr = dev_name(dev);
+	return 1;
+}
+
+
+/**
+ * init_rtc_posix_timers - Set up the RTC posix interface
+ *
+ * This function sets up and installs the RTC posix interface.
+ * Locates an RTC device that is usable, registers an irq handler,
+ * and installs the rtc k_clock.
+ */
+static __init int init_rtc_posix_timers(void)
+{
+	char *str = NULL;
+	int ret;
+	struct k_clock rtc_clock = {
+		.clock_getres = rtc_clock_getres,
+		.clock_get = rtc_clock_get,
+		.clock_set = rtc_clock_set,
+		.timer_create = rtc_timer_create,
+		.timer_set = rtc_timer_set,
+		.timer_del = rtc_timer_del,
+		.timer_get = rtc_timer_get,
+		.nsleep = no_nsleep,
+	};
+
+	/* Dig up an RTC device */
+	class_find_device(rtc_class, NULL, &str, is_rtc);
+	if (str)
+		rtc = rtc_class_open(str);
+	if (!rtc)
+		return -1;
+
+	irqhandler.func = rtc_handle_irq;
+	ret = rtc_irq_register(rtc, &irqhandler);
+	if (ret)
+		goto out_error;
+
+	register_posix_clock(CLOCK_RTC, &rtc_clock);
+
+	return 0;
+
+out_error:
+	rtc_class_close(rtc);
+	return -1;
+}
+late_initcall(init_rtc_posix_timers);
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 3e23844..a923a1e 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -63,6 +63,11 @@ struct k_itimer {
 			unsigned long incr;
 			unsigned long expires;
 		} mmtimer;
+		struct {
+			struct itimerspec it;
+			struct rb_node list;
+			char enabled;
+		} simple;
 	} it;
 };
 
diff --git a/include/linux/time.h b/include/linux/time.h
index 9f15ac7..418ee44 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -295,6 +295,7 @@ struct itimerval {
  * The IDs of various hardware clocks:
  */
 #define CLOCK_SGI_CYCLE			10
+#define CLOCK_RTC			11
 #define MAX_CLOCKS			16
 #define CLOCKS_MASK			(CLOCK_REALTIME | CLOCK_MONOTONIC)
 #define CLOCKS_MONO			CLOCK_MONOTONIC
-- 
1.6.0.4

