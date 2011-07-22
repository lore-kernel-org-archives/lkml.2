Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1GVOPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:15:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56060 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab1GVOPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:15:16 -0400
Date: Fri, 22 Jul 2011 16:14:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timers/core changes for v3.1
Message-ID: <20110722141428.GA9650@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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

 Thanks,

	Ingo

------------------>
John Stultz (4):
      time: Catch invalid timespec sleep values in __timekeeping_inject_sleeptime
      time: Avoid accumulating time drift in suspend/resume
      rtc: Avoid accumulating time drift in suspend/resume
      time: Fix stupid KERN_WARN compile issue


 drivers/rtc/class.c       |   65 +++++++++++++++++++++++++++++++++------------
 kernel/time/timekeeping.c |   28 +++++++++++++++++++
 2 files changed, 76 insertions(+), 17 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 4194e59..01a7df5 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -41,20 +41,41 @@ static void rtc_device_release(struct device *dev)
  * system's wall clock; restore it on resume().
  */
 
-static time_t		oldtime;
-static struct timespec	oldts;
+static struct timespec old_rtc, old_system, old_delta;
+
 
 static int rtc_suspend(struct device *dev, pm_message_t mesg)
 {
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
-
+	struct timespec		delta, delta_delta;
 	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
 
+	/* snapshot the current RTC and system time at suspend*/
 	rtc_read_time(rtc, &tm);
-	ktime_get_ts(&oldts);
-	rtc_tm_to_time(&tm, &oldtime);
+	getnstimeofday(&old_system);
+	rtc_tm_to_time(&tm, &old_rtc.tv_sec);
+
+
+	/*
+	 * To avoid drift caused by repeated suspend/resumes,
+	 * which each can add ~1 second drift error,
+	 * try to compensate so the difference in system time
+	 * and rtc time stays close to constant.
+	 */
+	delta = timespec_sub(old_system, old_rtc);
+	delta_delta = timespec_sub(delta, old_delta);
+	if (abs(delta_delta.tv_sec)  >= 2) {
+		/*
+		 * if delta_delta is too large, assume time correction
+		 * has occured and set old_delta to the current delta.
+		 */
+		old_delta = delta;
+	} else {
+		/* Otherwise try to adjust old_system to compensate */
+		old_system = timespec_sub(old_system, delta_delta);
+	}
 
 	return 0;
 }
@@ -63,32 +84,42 @@ static int rtc_resume(struct device *dev)
 {
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
-	time_t			newtime;
-	struct timespec		time;
-	struct timespec		newts;
+	struct timespec		new_system, new_rtc;
+	struct timespec		sleep_time;
 
 	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
 
-	ktime_get_ts(&newts);
+	/* snapshot the current rtc and system time at resume */
+	getnstimeofday(&new_system);
 	rtc_read_time(rtc, &tm);
 	if (rtc_valid_tm(&tm) != 0) {
 		pr_debug("%s:  bogus resume time\n", dev_name(&rtc->dev));
 		return 0;
 	}
-	rtc_tm_to_time(&tm, &newtime);
-	if (newtime <= oldtime) {
-		if (newtime < oldtime)
+	rtc_tm_to_time(&tm, &new_rtc.tv_sec);
+	new_rtc.tv_nsec = 0;
+
+	if (new_rtc.tv_sec <= old_rtc.tv_sec) {
+		if (new_rtc.tv_sec < old_rtc.tv_sec)
 			pr_debug("%s:  time travel!\n", dev_name(&rtc->dev));
 		return 0;
 	}
-	/* calculate the RTC time delta */
-	set_normalized_timespec(&time, newtime - oldtime, 0);
 
-	/* subtract kernel time between rtc_suspend to rtc_resume */
-	time = timespec_sub(time, timespec_sub(newts, oldts));
+	/* calculate the RTC time delta (sleep time)*/
+	sleep_time = timespec_sub(new_rtc, old_rtc);
+
+	/*
+	 * Since these RTC suspend/resume handlers are not called
+	 * at the very end of suspend or the start of resume,
+	 * some run-time may pass on either sides of the sleep time
+	 * so subtract kernel run-time between rtc_suspend to rtc_resume
+	 * to keep things accurate.
+	 */
+	sleep_time = timespec_sub(sleep_time,
+			timespec_sub(new_system, old_system));
 
-	timekeeping_inject_sleeptime(&time);
+	timekeeping_inject_sleeptime(&sleep_time);
 	return 0;
 }
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 342408c..2b021b0e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -604,6 +604,12 @@ static struct timespec timekeeping_suspend_time;
  */
 static void __timekeeping_inject_sleeptime(struct timespec *delta)
 {
+	if (!timespec_valid(delta)) {
+		printk(KERN_WARNING "__timekeeping_inject_sleeptime: Invalid "
+					"sleep delta value!\n");
+		return;
+	}
+
 	xtime = timespec_add(xtime, *delta);
 	wall_to_monotonic = timespec_sub(wall_to_monotonic, *delta);
 	total_sleep_time = timespec_add(total_sleep_time, *delta);
@@ -686,12 +692,34 @@ static void timekeeping_resume(void)
 static int timekeeping_suspend(void)
 {
 	unsigned long flags;
+	struct timespec		delta, delta_delta;
+	static struct timespec	old_delta;
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 	timekeeping_forward_now();
 	timekeeping_suspended = 1;
+
+	/*
+	 * To avoid drift caused by repeated suspend/resumes,
+	 * which each can add ~1 second drift error,
+	 * try to compensate so the difference in system time
+	 * and persistent_clock time stays close to constant.
+	 */
+	delta = timespec_sub(xtime, timekeeping_suspend_time);
+	delta_delta = timespec_sub(delta, old_delta);
+	if (abs(delta_delta.tv_sec)  >= 2) {
+		/*
+		 * if delta_delta is too large, assume time correction
+		 * has occured and set old_delta to the current delta.
+		 */
+		old_delta = delta;
+	} else {
+		/* Otherwise try to adjust old_system to compensate */
+		timekeeping_suspend_time =
+			timespec_add(timekeeping_suspend_time, delta_delta);
+	}
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
