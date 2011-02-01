Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab1BANwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:52:49 -0500
Received: from www.tglx.de ([62.245.132.106]:47403 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235Ab1BANwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:52:46 -0500
Message-Id: <20110201134419.389755466@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:52:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 20/28] posix-timers: Make posix-cpu-timers functions static
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline;
	filename=posix-timer-make-posix-cpu-timer-functions-static.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All functions are accessed via clock_posix_cpu now. So make them static.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 include/linux/posix-timers.h |   12 -------
 kernel/posix-cpu-timers.c    |   73 +++++++++++++++++++++----------------------
 2 files changed, 37 insertions(+), 48 deletions(-)

Index: linux-2.6-tip/include/linux/posix-timers.h
===================================================================
--- linux-2.6-tip.orig/include/linux/posix-timers.h
+++ linux-2.6-tip/include/linux/posix-timers.h
@@ -91,18 +91,6 @@ void register_posix_clock(const clockid_
 /* function to call to trigger timer event */
 int posix_timer_event(struct k_itimer *timr, int si_private);
 
-int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *ts);
-int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *ts);
-int posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *ts);
-int posix_cpu_timer_create(struct k_itimer *timer);
-int posix_cpu_nsleep(const clockid_t which_clock, int flags,
-		     struct timespec *rqtp, struct timespec __user *rmtp);
-long posix_cpu_nsleep_restart(struct restart_block *restart_block);
-int posix_cpu_timer_set(struct k_itimer *timer, int flags,
-			struct itimerspec *new, struct itimerspec *old);
-int posix_cpu_timer_del(struct k_itimer *timer);
-void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp);
-
 void posix_cpu_timer_schedule(struct k_itimer *timer);
 
 void run_posix_cpu_timers(struct task_struct *task);
Index: linux-2.6-tip/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-cpu-timers.c
+++ linux-2.6-tip/kernel/posix-cpu-timers.c
@@ -176,7 +176,8 @@ static inline cputime_t virt_ticks(struc
 	return p->utime;
 }
 
-int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
+static int
+posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
 {
 	int error = check_clock(which_clock);
 	if (!error) {
@@ -194,7 +195,8 @@ int posix_cpu_clock_getres(const clockid
 	return error;
 }
 
-int posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *tp)
+static int
+posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *tp)
 {
 	/*
 	 * You can never reset a CPU clock, but we check for other errors
@@ -317,7 +319,7 @@ static int cpu_clock_sample_group(const 
 }
 
 
-int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
+static int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 {
 	const pid_t pid = CPUCLOCK_PID(which_clock);
 	int error = -EINVAL;
@@ -379,7 +381,7 @@ int posix_cpu_clock_get(const clockid_t 
  * This is called from sys_timer_create() and do_cpu_nanosleep() with the
  * new timer already all-zeros initialized.
  */
-int posix_cpu_timer_create(struct k_itimer *new_timer)
+static int posix_cpu_timer_create(struct k_itimer *new_timer)
 {
 	int ret = 0;
 	const pid_t pid = CPUCLOCK_PID(new_timer->it_clock);
@@ -425,7 +427,7 @@ int posix_cpu_timer_create(struct k_itim
  * If we return TIMER_RETRY, it's necessary to release the timer's lock
  * and try again.  (This happens when the timer is in the middle of firing.)
  */
-int posix_cpu_timer_del(struct k_itimer *timer)
+static int posix_cpu_timer_del(struct k_itimer *timer)
 {
 	struct task_struct *p = timer->it.cpu.task;
 	int ret = 0;
@@ -665,8 +667,8 @@ static int cpu_timer_sample_group(const 
  * If we return TIMER_RETRY, it's necessary to release the timer's lock
  * and try again.  (This happens when the timer is in the middle of firing.)
  */
-int posix_cpu_timer_set(struct k_itimer *timer, int flags,
-			struct itimerspec *new, struct itimerspec *old)
+static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
+			       struct itimerspec *new, struct itimerspec *old)
 {
 	struct task_struct *p = timer->it.cpu.task;
 	union cpu_time_count old_expires, new_expires, old_incr, val;
@@ -820,7 +822,7 @@ int posix_cpu_timer_set(struct k_itimer 
 	return ret;
 }
 
-void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
+static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 {
 	union cpu_time_count now;
 	struct task_struct *p = timer->it.cpu.task;
@@ -1481,68 +1483,67 @@ static int do_cpu_nanosleep(const clocki
 	return error;
 }
 
-int posix_cpu_nsleep(const clockid_t which_clock, int flags,
-		     struct timespec *rqtp, struct timespec __user *rmtp)
+static long posix_cpu_nsleep_restart(struct restart_block *restart_block)
 {
-	struct restart_block *restart_block =
-		&current_thread_info()->restart_block;
+	clockid_t which_clock = restart_block->nanosleep.index;
+	struct timespec t;
 	struct itimerspec it;
 	int error;
 
-	/*
-	 * Diagnose required errors first.
-	 */
-	if (CPUCLOCK_PERTHREAD(which_clock) &&
-	    (CPUCLOCK_PID(which_clock) == 0 ||
-	     CPUCLOCK_PID(which_clock) == current->pid))
-		return -EINVAL;
+	t = ns_to_timespec(restart_block->nanosleep.expires);
 
-	error = do_cpu_nanosleep(which_clock, flags, rqtp, &it);
+	error = do_cpu_nanosleep(which_clock, TIMER_ABSTIME, &t, &it);
 
 	if (error == -ERESTART_RESTARTBLOCK) {
-
-		if (flags & TIMER_ABSTIME)
-			return -ERESTARTNOHAND;
+		struct timespec __user *rmtp = restart_block->nanosleep.rmtp;
 		/*
 		 * Report back to the user the time still remaining.
 		 */
 		if (rmtp && copy_to_user(rmtp, &it.it_value, sizeof *rmtp))
 			return -EFAULT;
 
-		restart_block->fn = posix_cpu_nsleep_restart;
-		restart_block->nanosleep.index = which_clock;
-		restart_block->nanosleep.rmtp = rmtp;
-		restart_block->nanosleep.expires = timespec_to_ns(rqtp);
+		restart_block->nanosleep.expires = timespec_to_ns(&t);
 	}
 	return error;
+
 }
 
-long posix_cpu_nsleep_restart(struct restart_block *restart_block)
+static int posix_cpu_nsleep(const clockid_t which_clock, int flags,
+			    struct timespec *rqtp, struct timespec __user *rmtp)
 {
-	clockid_t which_clock = restart_block->nanosleep.index;
-	struct timespec t;
+	struct restart_block *restart_block =
+		&current_thread_info()->restart_block;
 	struct itimerspec it;
 	int error;
 
-	t = ns_to_timespec(restart_block->nanosleep.expires);
+	/*
+	 * Diagnose required errors first.
+	 */
+	if (CPUCLOCK_PERTHREAD(which_clock) &&
+	    (CPUCLOCK_PID(which_clock) == 0 ||
+	     CPUCLOCK_PID(which_clock) == current->pid))
+		return -EINVAL;
 
-	error = do_cpu_nanosleep(which_clock, TIMER_ABSTIME, &t, &it);
+	error = do_cpu_nanosleep(which_clock, flags, rqtp, &it);
 
 	if (error == -ERESTART_RESTARTBLOCK) {
-		struct timespec __user *rmtp = restart_block->nanosleep.rmtp;
+
+		if (flags & TIMER_ABSTIME)
+			return -ERESTARTNOHAND;
 		/*
 		 * Report back to the user the time still remaining.
 		 */
 		if (rmtp && copy_to_user(rmtp, &it.it_value, sizeof *rmtp))
 			return -EFAULT;
 
-		restart_block->nanosleep.expires = timespec_to_ns(&t);
+		restart_block->fn = posix_cpu_nsleep_restart;
+		restart_block->nanosleep.index = which_clock;
+		restart_block->nanosleep.rmtp = rmtp;
+		restart_block->nanosleep.expires = timespec_to_ns(rqtp);
 	}
 	return error;
-
 }
 
-
 #define PROCESS_CLOCK	MAKE_PROCESS_CPUCLOCK(0, CPUCLOCK_SCHED)
 #define THREAD_CLOCK	MAKE_THREAD_CPUCLOCK(0, CPUCLOCK_SCHED)
 


