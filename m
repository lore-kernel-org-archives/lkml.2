Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab1BAN4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:56:20 -0500
Received: from www.tglx.de ([62.245.132.106]:47232 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757117Ab1BANwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:52:00 -0500
Message-Id: <20110201134418.518851246@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:51:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 11/28] posix-timers: Convert clock_settime to
	clockid_to_kclock()
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline; filename=posix-timers-convert-clock-set.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new kclock decoding function in clock_settime and cleanup all
kclocks which use the default functions. Rename the misnomed
common_clock_set() to posix_clock_realtime_set().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 include/linux/posix-timers.h |    3 ---
 kernel/posix-cpu-timers.c    |    2 --
 kernel/posix-timers.c        |   31 ++++++++++++-------------------
 3 files changed, 12 insertions(+), 24 deletions(-)

Index: linux-2.6-tip/include/linux/posix-timers.h
===================================================================
--- linux-2.6-tip.orig/include/linux/posix-timers.h
+++ linux-2.6-tip/include/linux/posix-timers.h
@@ -89,9 +89,6 @@ extern struct k_clock clock_posix_cpu;
 
 void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
 
-/* error handlers for timer_create, nanosleep and settime */
-int do_posix_clock_nosettime(const clockid_t, const struct timespec *tp);
-
 /* function to call to trigger timer event */
 int posix_timer_event(struct k_itimer *timr, int si_private);
 
Index: linux-2.6-tip/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-cpu-timers.c
+++ linux-2.6-tip/kernel/posix-cpu-timers.c
@@ -1604,7 +1604,6 @@ static __init int init_posix_cpu_timers(
 	struct k_clock process = {
 		.clock_getres	= process_cpu_clock_getres,
 		.clock_get	= process_cpu_clock_get,
-		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= process_cpu_timer_create,
 		.nsleep		= process_cpu_nsleep,
 		.nsleep_restart	= process_cpu_nsleep_restart,
@@ -1612,7 +1611,6 @@ static __init int init_posix_cpu_timers(
 	struct k_clock thread = {
 		.clock_getres	= thread_cpu_clock_getres,
 		.clock_get	= thread_cpu_clock_get,
-		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= thread_cpu_timer_create,
 	};
 	struct timespec ts;
Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -199,12 +199,6 @@ static int common_clock_get(clockid_t wh
 	return 0;
 }
 
-static inline int common_clock_set(const clockid_t which_clock,
-				   const struct timespec *tp)
-{
-	return do_sys_settimeofday(tp, NULL);
-}
-
 static int common_timer_create(struct k_itimer *new_timer)
 {
 	hrtimer_init(&new_timer->it.real.timer, new_timer->it_clock, 0);
@@ -232,6 +226,13 @@ static inline int invalid_clockid(const 
 	return 1;
 }
 
+/* Set clock_realtime */
+static inline int posix_clock_realtime_set(const clockid_t which_clock,
+					   const struct timespec *tp)
+{
+	return do_sys_settimeofday(tp, NULL);
+}
+
 /*
  * Get monotonic time for posix timers
  */
@@ -276,32 +277,29 @@ static __init int init_posix_timers(void
 {
 	struct k_clock clock_realtime = {
 		.clock_getres	= hrtimer_get_res,
+		.clock_set	= posix_clock_realtime_set,
 		.nsleep		= common_nsleep,
 		.nsleep_restart	= hrtimer_nanosleep_restart,
 	};
 	struct k_clock clock_monotonic = {
 		.clock_getres	= hrtimer_get_res,
 		.clock_get	= posix_ktime_get_ts,
-		.clock_set	= do_posix_clock_nosettime,
 		.nsleep		= common_nsleep,
 		.nsleep_restart	= hrtimer_nanosleep_restart,
 	};
 	struct k_clock clock_monotonic_raw = {
 		.clock_getres	= hrtimer_get_res,
 		.clock_get	= posix_get_monotonic_raw,
-		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= no_timer_create,
 	};
 	struct k_clock clock_realtime_coarse = {
 		.clock_getres	= posix_get_coarse_res,
 		.clock_get	= posix_get_realtime_coarse,
-		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= no_timer_create,
 	};
 	struct k_clock clock_monotonic_coarse = {
 		.clock_getres	= posix_get_coarse_res,
 		.clock_get	= posix_get_monotonic_coarse,
-		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= no_timer_create,
 	};
 
@@ -940,24 +938,19 @@ void exit_itimers(struct signal_struct *
 	}
 }
 
-/* Not available / possible... functions */
-int do_posix_clock_nosettime(const clockid_t clockid, const struct timespec *tp)
-{
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(do_posix_clock_nosettime);
-
 SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
 		const struct timespec __user *, tp)
 {
+	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec new_tp;
 
-	if (invalid_clockid(which_clock))
+	if (!kc || !kc->clock_set)
 		return -EINVAL;
+
 	if (copy_from_user(&new_tp, tp, sizeof (*tp)))
 		return -EFAULT;
 
-	return CLOCK_DISPATCH(which_clock, clock_set, (which_clock, &new_tp));
+	return kc->clock_set(which_clock, &new_tp);
 }
 
 SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,


