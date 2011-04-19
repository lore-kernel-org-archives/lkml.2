Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab1DSX75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 19:59:57 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56715 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab1DSX64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 19:58:56 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 4/4] timers: posix interface for alarm-timers
Date: Tue, 19 Apr 2011 16:58:30 -0700
Message-Id: <1303257510-15054-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1303257510-15054-1-git-send-email-john.stultz@linaro.org>
References: <1303257510-15054-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exposes alarm-timers to userland via the posix clock
and timers interface, using two new clockids: CLOCK_REALTIME_ALARM
and CLOCK_BOOTTIME_ALARM. Both clockids behave identically to
CLOCK_REALTIME and CLOCK_BOOTTIME, respectively, but timers
set against the _ALARM suffixed clockids will wake the system if
it is suspended.

Some background can be found here:
	https://lwn.net/Articles/429925/

The concept for Alarm-timers was inspired by the Android Alarm
driver (by Arve Hjønnevåg) found in the Android kernel tree.

See: http://android.git.kernel.org/?p=kernel/common.git;a=blob;f=drivers/rtc/alarm.c;h=1250edfbdf3302f5e4ea6194847c6ef4bb7beb1c;hb=android-2.6.36

While the in-kernel interface is pretty similar between
alarm-timers and Android alarm driver, the user-space interface
for the Android alarm driver is via ioctls to a new char device.
As mentioned above, I've instead chosen to export this functionality
via the posix interface, as it seemed a little simpler and avoids
creating duplicate interfaces to things like CLOCK_REALTIME and
CLOCK_MONOTONIC under alternate names (ie:ANDROID_ALARM_RTC and
ANDROID_ALARM_SYSTEMTIME).

The semantics of the Android alarm driver are different from what
this posix interface provides. For instance, threads other then
the thread waiting on the Android alarm driver are able to modify
the alarm being waited on. Also this interface does not allow
the same wakelock semantics that the Android driver provides
(ie: kernel takes a wakelock on RTC alarm-interupt, and holds it
through process wakeup, and while the process runs, until the
process either closes the char device or calls back in to wait
on a new alarm).

One potential way to implement similar semantics may be via
the timerfd infrastructure, but this needs more research.

There may also need to be some sort of sysfs system level policy
hooks that allow alarm timers to be disabled to keep them
from firing at inappropriate times (ie: laptop in a well insulated
bag, mid-flight).

CC: Arve Hjønnevåg <arve@android.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/capability.h   |    7 +-
 include/linux/posix-timers.h |    2 +
 include/linux/time.h         |    2 +
 kernel/time/alarmtimer.c     |  330 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 340 insertions(+), 1 deletions(-)

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
 
diff --git a/include/linux/time.h b/include/linux/time.h
index 4ea5a75..b306178 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -295,6 +295,8 @@ struct itimerval {
 #define CLOCK_REALTIME_COARSE		5
 #define CLOCK_MONOTONIC_COARSE		6
 #define CLOCK_BOOTTIME			7
+#define CLOCK_REALTIME_ALARM		8
+#define CLOCK_BOOTTIME_ALARM		9
 
 /*
  * The IDs of various hardware clocks:
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 4d91f0e..5fec899 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -215,6 +215,21 @@ static int alarmtimer_suspend(struct device *dev)
 }
 
 
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
 /**************************************************************************
  * alarm kernel interface code
  */
@@ -279,6 +294,309 @@ void alarm_cancel(struct alarm *alarm)
 }
 
 
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
+	if (clockid == CLOCK_BOOTTIME_ALARM)
+		return ALARM_BOOTTIME;
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
 
 /**************************************************************************
  * alarmtimer initialization code
@@ -306,6 +624,18 @@ static int __init alarmtimer_init(void)
 {
 	int error = 0;
 	int i;
+	struct k_clock alarm_clock = {
+		.clock_getres = alarm_clock_getres,
+		.clock_get = alarm_clock_get,
+		.timer_create = alarm_timer_create,
+		.timer_set = alarm_timer_set,
+		.timer_del = alarm_timer_del,
+		.timer_get = alarm_timer_get,
+		.nsleep = alarm_timer_nsleep,
+	};
+
+	posix_timers_register_clock(CLOCK_REALTIME_ALARM, &alarm_clock);
+	posix_timers_register_clock(CLOCK_BOOTTIME_ALARM, &alarm_clock);
 
 	/* Initialize alarm bases */
 	alarm_bases[ALARM_REALTIME].base_clockid = CLOCK_REALTIME;
-- 
1.7.3.2.146.gca209

