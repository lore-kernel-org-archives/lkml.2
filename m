Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab1DTAAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 20:00:19 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48098 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab1DSX6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 19:58:52 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/4] time: Add timekeeping_inject_sleeptime
Date: Tue, 19 Apr 2011 16:58:27 -0700
Message-Id: <1303257510-15054-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1303257510-15054-1-git-send-email-john.stultz@linaro.org>
References: <1303257510-15054-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms cannot implement read_persistent_clock, as
their RTC devices are only accessible when interrupts are enabled.
This keeps them from being used by the timekeeping code on resume
to measure the time in suspend.

The RTC layer tries to work around this, by calling do_settimeofday
on resume after irqs are reenabled to set the time properly. However,
this only corrects CLOCK_REALTIME, and does not properly adjust
the sleep time value. This causes btime in /proc/stat to be incorrect
as well as making the new CLOCK_BOTTTIME inaccurate.

This patch resolves the issue by introducing a new timekeeping hook
to allow the RTC layer to inject the sleep time on resume.

The code also checks to make sure that read_persistent_clock is
nonfunctional before setting the sleep time, so that should the RTC's
HCTOSYS option be configured in on a system that does support
read_persistent_clock we will not increase the total_sleep_time twice.

CC: Arve Hjønnevåg <arve@android.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/class.c       |   23 +++++++-----------
 include/linux/time.h      |    1 +
 kernel/time/timekeeping.c |   56 ++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 63 insertions(+), 17 deletions(-)

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
 
diff --git a/include/linux/time.h b/include/linux/time.h
index 454a262..4ea5a75 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -126,6 +126,7 @@ struct timespec __current_kernel_time(void); /* does not take xtime_lock */
 struct timespec get_monotonic_coarse(void);
 void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 				struct timespec *wtom, struct timespec *sleep);
+void timekeeping_inject_sleeptime(struct timespec *delta);
 
 #define CURRENT_TIME		(current_kernel_time())
 #define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
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
-- 
1.7.3.2.146.gca209

