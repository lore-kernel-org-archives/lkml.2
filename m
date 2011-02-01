Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab1BANwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:52:00 -0500
Received: from www.tglx.de ([62.245.132.106]:47223 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757110Ab1BANv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:51:58 -0500
Message-Id: <20110201134418.611097203@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:51:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 12/28] posix-timers: Convert clock_gettime() to
	clockid_to_kclock()
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline; filename=posix-timers-convert-clock-get.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new kclock decoding mechanism and rename the misnomed
common_clock_get() to posix_clock_realtime_get().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 kernel/posix-timers.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -190,15 +190,6 @@ static inline int common_clock_getres(co
 	return 0;
 }
 
-/*
- * Get real time for posix timers
- */
-static int common_clock_get(clockid_t which_clock, struct timespec *tp)
-{
-	ktime_get_real_ts(tp);
-	return 0;
-}
-
 static int common_timer_create(struct k_itimer *new_timer)
 {
 	hrtimer_init(&new_timer->it.real.timer, new_timer->it_clock, 0);
@@ -226,6 +217,13 @@ static inline int invalid_clockid(const 
 	return 1;
 }
 
+/* Get clock_realtime */
+static int posix_clock_realtime_get(clockid_t which_clock, struct timespec *tp)
+{
+	ktime_get_real_ts(tp);
+	return 0;
+}
+
 /* Set clock_realtime */
 static inline int posix_clock_realtime_set(const clockid_t which_clock,
 					   const struct timespec *tp)
@@ -277,6 +275,7 @@ static __init int init_posix_timers(void
 {
 	struct k_clock clock_realtime = {
 		.clock_getres	= hrtimer_get_res,
+		.clock_get	= posix_clock_realtime_get,
 		.clock_set	= posix_clock_realtime_set,
 		.nsleep		= common_nsleep,
 		.nsleep_restart	= hrtimer_nanosleep_restart,
@@ -956,18 +955,21 @@ SYSCALL_DEFINE2(clock_settime, const clo
 SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
 		struct timespec __user *,tp)
 {
+	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec kernel_tp;
 	int error;
 
-	if (invalid_clockid(which_clock))
+	if (!kc)
 		return -EINVAL;
-	error = CLOCK_DISPATCH(which_clock, clock_get,
-			       (which_clock, &kernel_tp));
+	if (!kc->clock_get)
+		return -EOPNOTSUPP;
+
+	error = kc->clock_get(which_clock, &kernel_tp);
+
 	if (!error && copy_to_user(tp, &kernel_tp, sizeof (kernel_tp)))
 		error = -EFAULT;
 
 	return error;
-
 }
 
 SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock,


