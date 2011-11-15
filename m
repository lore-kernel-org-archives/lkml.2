Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1KOEE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:04:56 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35084 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab1KOEEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:04:55 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 10/16] time: Remove most of xtime_lock usage in timekeeping.c
Date: Mon, 14 Nov 2011 20:04:00 -0800
Message-Id: <1321329846-14755-11-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
References: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
x-cbid: 11111504-3534-0000-0000-000001E29A23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that ntp.c's locking is reworked, we can remove most
of the xtime_lock usage in timekeeping.c

The remaining xtime_lock presence is really for jiffies access
and the global load calculation.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   44 +++++++++++++++-----------------------------
 1 files changed, 15 insertions(+), 29 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f92e636..810b974 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -172,7 +172,6 @@ static inline s64 timekeeping_get_ns_raw(void)
 	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 }
 
-/* must hold xtime_lock */
 void timekeeping_leap_insert(int leapsecond)
 {
 	unsigned long flags;
@@ -368,13 +367,12 @@ EXPORT_SYMBOL(do_gettimeofday);
 int do_settimeofday(const struct timespec *tv)
 {
 	struct timespec ts_delta;
-	unsigned long flags1,flags2;
+	unsigned long flags;
 
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&xtime_lock, flags1);
-	write_seqlock_irqsave(&timekeeper.lock, flags2);
+	write_seqlock_irqsave(&timekeeper.lock, flags);
 
 	timekeeping_forward_now();
 
@@ -391,8 +389,7 @@ int do_settimeofday(const struct timespec *tv)
 	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
 			timekeeper.clock, timekeeper.mult);
 
-	write_sequnlock_irqrestore(&timekeeper.lock, flags2);
-	write_sequnlock_irqrestore(&xtime_lock, flags1);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -411,13 +408,12 @@ EXPORT_SYMBOL(do_settimeofday);
  */
 int timekeeping_inject_offset(struct timespec *ts)
 {
-	unsigned long flags1,flags2;
+	unsigned long flags;
 
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&xtime_lock, flags1);
-	write_seqlock_irqsave(&timekeeper.lock, flags2);
+	write_seqlock_irqsave(&timekeeper.lock, flags);
 
 	timekeeping_forward_now();
 
@@ -431,8 +427,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
 			timekeeper.clock, timekeeper.mult);
 
-	write_sequnlock_irqrestore(&timekeeper.lock, flags2);
-	write_sequnlock_irqrestore(&xtime_lock, flags1);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -594,9 +589,7 @@ void __init timekeeping_init(void)
 
 	seqlock_init(&timekeeper.lock);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
 	ntp_init();
-	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	write_seqlock_irqsave(&timekeeper.lock, flags);
 	clock = clocksource_default_clock();
@@ -657,7 +650,7 @@ static void __timekeeping_inject_sleeptime(struct timespec *delta)
  */
 void timekeeping_inject_sleeptime(struct timespec *delta)
 {
-	unsigned long flags1,flags2;
+	unsigned long flags;
 	struct timespec ts;
 
 	/* Make sure we don't set the clock twice */
@@ -665,8 +658,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	if (!(ts.tv_sec == 0 && ts.tv_nsec == 0))
 		return;
 
-	write_seqlock_irqsave(&xtime_lock, flags1);
-	write_seqlock_irqsave(&timekeeper.lock, flags2);
+	write_seqlock_irqsave(&timekeeper.lock, flags);
 
 	timekeeping_forward_now();
 
@@ -677,8 +669,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
 			timekeeper.clock, timekeeper.mult);
 
-	write_sequnlock_irqrestore(&timekeeper.lock, flags2);
-	write_sequnlock_irqrestore(&xtime_lock, flags1);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -694,15 +685,14 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
  */
 static void timekeeping_resume(void)
 {
-	unsigned long flags1,flags2;
+	unsigned long flags;
 	struct timespec ts;
 
 	read_persistent_clock(&ts);
 
 	clocksource_resume();
 
-	write_seqlock_irqsave(&xtime_lock, flags1);
-	write_seqlock_irqsave(&timekeeper.lock, flags2);
+	write_seqlock_irqsave(&timekeeper.lock, flags);
 
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
 		ts = timespec_sub(ts, timekeeping_suspend_time);
@@ -712,8 +702,7 @@ static void timekeeping_resume(void)
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
-	write_sequnlock_irqrestore(&timekeeper.lock, flags2);
-	write_sequnlock_irqrestore(&xtime_lock, flags1);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
 	touch_softlockup_watchdog();
 
@@ -725,14 +714,13 @@ static void timekeeping_resume(void)
 
 static int timekeeping_suspend(void)
 {
-	unsigned long flags1,flags2;
+	unsigned long flags;
 	struct timespec		delta, delta_delta;
 	static struct timespec	old_delta;
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
-	write_seqlock_irqsave(&xtime_lock, flags1);
-	write_seqlock_irqsave(&timekeeper.lock, flags2);
+	write_seqlock_irqsave(&timekeeper.lock, flags);
 	timekeeping_forward_now();
 	timekeeping_suspended = 1;
 
@@ -755,8 +743,7 @@ static int timekeeping_suspend(void)
 		timekeeping_suspend_time =
 			timespec_add(timekeeping_suspend_time, delta_delta);
 	}
-	write_sequnlock_irqrestore(&timekeeper.lock, flags2);
-	write_sequnlock_irqrestore(&xtime_lock, flags1);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	clocksource_suspend();
@@ -916,7 +903,6 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 /**
  * update_wall_time - Uses the current clocksource to increment the wall time
  *
- * Called from the timer interrupt, must hold a write on xtime_lock.
  */
 static void update_wall_time(void)
 {
-- 
1.7.3.2.146.gca209

