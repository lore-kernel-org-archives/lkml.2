Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab0JPAj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 20:39:58 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46708 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0JPAjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 20:39:00 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 6/6] [RFC] RTC: Add posix clock/timer interface
Date: Fri, 15 Oct 2010 17:38:55 -0700
Message-Id: <1287189535-24649-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287189535-24649-6-git-send-email-john.stultz@linaro.org>
References: <1287189535-24649-1-git-send-email-john.stultz@linaro.org>
 <1287189535-24649-2-git-send-email-john.stultz@linaro.org>
 <1287189535-24649-3-git-send-email-john.stultz@linaro.org>
 <1287189535-24649-4-git-send-email-john.stultz@linaro.org>
 <1287189535-24649-5-git-send-email-john.stultz@linaro.org>
 <1287189535-24649-6-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides an initial implementation of the
posix clock/timer interface to the RTC. Since the current
/dev, proc, and sysfs interfaces don't queue events, two
applications trying to set a wakeup events in the future
might race, causing events to be missed. The posix interface
allows multiple applications to be able to set timers against
a single RTC device, letting the kernel manage the multiplexing.

One example use would be a backup job that is done at night
on a desktop system that suspends after 15 minutes of idle time.
A cron-like job manager could set a posix timer against the RTC
to ensure the system woke from suspend in order to run the backup.

However, the system might also run a DVR application to record
a favorite show. That application could also use the posix
interface to set a timer against the RTC without having to worry
if it had overwritten the timer set for the backup job.

Since there can be multiple RTCs on a system, we utilize the
dynamic posix clock registration code, and export the clockid
via /sys/class/rtc/rtcN/posix_clockid.

Signed-off-by: John Stultz <john.stultz@linaro.org>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Richard Cochran <richardcochran@gmail.com>
---
 drivers/rtc/Makefile         |    2 +-
 drivers/rtc/class.c          |    2 +
 drivers/rtc/posix.c          |  274 ++++++++++++++++++++++++++++++++++++++++++
 drivers/rtc/rtc-sysfs.c      |   10 ++
 include/linux/posix-timers.h |    2 +
 include/linux/rtc.h          |    3 +
 6 files changed, 292 insertions(+), 1 deletions(-)
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
diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index e642673..8eb6ca5 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -173,6 +173,8 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 	rtc->pie_timer.function = rtc_pie_update_irq;
 	rtc->pie_enabled = 0;
 
+	init_rtc_posix_timer(rtc);
+
 	strlcpy(rtc->name, name, RTC_DEVICE_NAME_SIZE);
 	dev_set_name(&rtc->dev, "rtc%d", id);
 
diff --git a/drivers/rtc/posix.c b/drivers/rtc/posix.c
new file mode 100644
index 0000000..ba715a7
--- /dev/null
+++ b/drivers/rtc/posix.c
@@ -0,0 +1,274 @@
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
+
+static void rtc_handle_irq(void *data);
+
+static int find_clockid(struct device *dev, void *clockid)
+{
+	clockid_t* id = (clockid_t*)clockid;
+
+	if (to_rtc_device(dev)->posix_id == *id)
+		return 1;
+	return 0;
+}
+
+/* XXX - This can probably be optimized better then scanning the list */
+static struct rtc_device *clock_to_rtc(clockid_t id)
+{
+	struct device *dev;
+
+	dev = class_find_device(rtc_class, NULL, &id, find_clockid);
+	if (!dev)
+		return NULL;
+	return to_rtc_device(dev);
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
+	tp->tv_sec = 1;
+	tp->tv_nsec = 0;
+	return 0;
+}
+
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
+	struct rtc_device *rtc;
+	struct rtc_time tm;
+	time_t sec;
+	int ret;
+
+	rtc = clock_to_rtc(which_clock);
+	if (rtc == NULL)
+		return -ENODEV;
+
+	ret = rtc_read_time(rtc, &tm);
+	if (ret)
+		return ret;
+
+	rtc_tm_to_time(&tm, &sec);
+
+	tp->tv_sec = sec;
+	tp->tv_nsec = 0;
+	return 0;
+}
+
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
+	struct rtc_device *rtc;
+	struct rtc_time tm;
+	int ret;
+
+	rtc_time_to_tm(tp->tv_sec, &tm);
+	rtc = clock_to_rtc(clockid);
+	if (rtc == NULL)
+		return -ENODEV;
+
+	ret = rtc_set_time(rtc, &tm);
+	return ret;
+}
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
+	struct rtc_device *rtc;
+
+	rtc = clock_to_rtc(new_timer->it_clock);
+	if (rtc == NULL)
+		return -ENODEV;
+
+	timerlist_init(&new_timer->it.rtctimer.node);
+	new_timer->it.rtctimer.enabled = 0;
+	new_timer->it.rtctimer.task.func = rtc_handle_irq;
+	new_timer->it.rtctimer.task.private_data = (void*)new_timer;
+	new_timer->it.rtctimer.period = ktime_set(0,0);
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
+	cur_setting->it_interval = ktime_to_timespec(timr->it.rtctimer.period);
+	cur_setting->it_value =
+			ktime_to_timespec(timr->it.rtctimer.node.expires);
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
+	struct rtc_device *rtc;
+
+	rtc = clock_to_rtc(timr->it_clock);
+	if (rtc == NULL)
+		return -ENODEV;
+
+	mutex_lock(&rtc->ops_lock);
+	if (timr->it.rtctimer.enabled)
+		rtctimer_remove(rtc, &timr->it.rtctimer);
+	timr->it.rtctimer.enabled = 0;
+	mutex_unlock(&rtc->ops_lock);
+	return 0;
+}
+
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
+	struct rtc_device *rtc;
+
+	rtc = clock_to_rtc(timr->it_clock);
+	if (rtc == NULL)
+		return -ENODEV;
+
+	mutex_lock(&rtc->ops_lock);
+	if (timr->it.rtctimer.enabled)
+		rtctimer_remove(rtc, &timr->it.rtctimer);
+
+	/* Save old values */
+	old_setting->it_interval = ktime_to_timespec(timr->it.rtctimer.period);
+	old_setting->it_value =
+			ktime_to_timespec(timr->it.rtctimer.node.expires);
+
+	/* Set new values */
+	timr->it.rtctimer.period = timespec_to_ktime(new_setting->it_interval);
+	timr->it.rtctimer.node.expires =
+				timespec_to_ktime(new_setting->it_value);
+
+	timr->it.rtctimer.enabled = 1;
+	rtctimer_enqueue(rtc, &timr->it.rtctimer);
+	mutex_unlock(&rtc->ops_lock);
+	return 0;
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
+ * We don't implement nsleep yet, so this stub returns an error.
+ */
+static int no_nsleep(const clockid_t which_clock, int flags,
+		     struct timespec *tsave, struct timespec __user *rmtp)
+{
+	return -EOPNOTSUPP;
+}
+
+
+/**
+ * rtc_handle_irq - RTC alarm interrupt callback
+ * @data: ignored
+ *
+ * This function is called when the RTC interrupt triggers.
+ * It runs through the timer list, expiring timers,
+ * then programs the alarm to fire on the next event.
+ */
+static void rtc_handle_irq(void *data)
+{
+	struct k_itimer *ptr = (struct k_itimer *)data;
+
+	if (posix_timer_event(ptr, 0) != 0)
+		ptr->it_overrun++;
+}
+
+
+/**
+ * init_rtc_posix_timer - Registers and initializes rtc posix clockid
+ * @rtc: pointer to rtc device being initialized
+ *
+ * This function is called when an rtc device is added to the system.
+ */
+void init_rtc_posix_timer(struct rtc_device * rtc)
+{
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
+	rtc->posix_id = create_posix_clock(&rtc_clock);
+}
diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index 380083c..d302760 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -81,6 +81,15 @@ rtc_sysfs_show_since_epoch(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
+rtc_sysfs_show_posix_clockid(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	ssize_t retval;
+	retval = sprintf(buf, "%lu\n", to_rtc_device(dev)->posix_id);
+	return retval;
+}
+
+static ssize_t
 rtc_sysfs_show_max_user_freq(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
@@ -121,6 +130,7 @@ static struct device_attribute rtc_attrs[] = {
 	__ATTR(date, S_IRUGO, rtc_sysfs_show_date, NULL),
 	__ATTR(time, S_IRUGO, rtc_sysfs_show_time, NULL),
 	__ATTR(since_epoch, S_IRUGO, rtc_sysfs_show_since_epoch, NULL),
+	__ATTR(posix_clockid, S_IRUGO, rtc_sysfs_show_posix_clockid, NULL),
 	__ATTR(max_user_freq, S_IRUGO | S_IWUSR, rtc_sysfs_show_max_user_freq,
 			rtc_sysfs_set_max_user_freq),
 	__ATTR(hctosys, S_IRUGO, rtc_sysfs_show_hctosys, NULL),
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index a9e601a..e6b46b5 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -4,6 +4,7 @@
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/sched.h>
+#include <linux/rtc.h>
 
 union cpu_time_count {
 	cputime_t cpu;
@@ -63,6 +64,7 @@ struct k_itimer {
 			unsigned long incr;
 			unsigned long expires;
 		} mmtimer;
+		struct rtc_timer rtctimer;
 	} it;
 };
 
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 7350748..f0dd351 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -203,6 +203,8 @@ struct rtc_device
 	struct hrtimer pie_timer; /* sub second exp, so needs hrtimer */
 	int pie_enabled;
 	struct work_struct irqwork;
+
+	clockid_t posix_id;
 };
 #define to_rtc_device(d) container_of(d, struct rtc_device, dev)
 
@@ -246,6 +248,7 @@ int rtc_register(rtc_task_t *task);
 int rtc_unregister(rtc_task_t *task);
 int rtc_control(rtc_task_t *t, unsigned int cmd, unsigned long arg);
 
+void init_rtc_posix_timer(struct rtc_device * rtc);
 void rtctimer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer);
 void rtctimer_remove(struct rtc_device *rtc, struct rtc_timer *timer);
 
-- 
1.6.0.4

