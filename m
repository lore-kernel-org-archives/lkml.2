Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab1BANwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:52:09 -0500
Received: from www.tglx.de ([62.245.132.106]:47265 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141Ab1BANwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:52:06 -0500
Message-Id: <20110201134418.903604289@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:51:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 15/28] posix-timers: Convert timer_create() to
	clockid_to_kclock()
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline;
	filename=posix-timers-convert-clock-timer-create.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup timer_create for CLOCK_MONOTONIC and CLOCK_REALTIME kclocks and
remove the no_timer_create() implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 kernel/posix-timers.c |   40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -146,6 +146,7 @@ static struct k_clock posix_clocks[MAX_C
  */
 static int common_nsleep(const clockid_t, int flags, struct timespec *t,
 			 struct timespec __user *rmtp);
+static int common_timer_create(struct k_itimer *new_timer);
 static void common_timer_get(struct k_itimer *, struct itimerspec *);
 static int common_timer_set(struct k_itimer *, int,
 			    struct itimerspec *, struct itimerspec *);
@@ -175,25 +176,6 @@ static inline void unlock_timer(struct k
  	  ? (*posix_clocks[clock].call) arglist : common_##call arglist))
 
 /*
- * Default clock hook functions when the struct k_clock passed
- * to register_posix_clock leaves a function pointer null.
- *
- * The function common_CALL is the default implementation for
- * the function pointer CALL in struct k_clock.
- */
-
-static int common_timer_create(struct k_itimer *new_timer)
-{
-	hrtimer_init(&new_timer->it.real.timer, new_timer->it_clock, 0);
-	return 0;
-}
-
-static int no_timer_create(struct k_itimer *new_timer)
-{
-	return -EOPNOTSUPP;
-}
-
-/*
  * Return nonzero if we know a priori this clockid_t value is bogus.
  */
 static inline int invalid_clockid(const clockid_t which_clock)
@@ -269,27 +251,26 @@ static __init int init_posix_timers(void
 		.clock_set	= posix_clock_realtime_set,
 		.nsleep		= common_nsleep,
 		.nsleep_restart	= hrtimer_nanosleep_restart,
+		.timer_create	= common_timer_create,
 	};
 	struct k_clock clock_monotonic = {
 		.clock_getres	= hrtimer_get_res,
 		.clock_get	= posix_ktime_get_ts,
 		.nsleep		= common_nsleep,
 		.nsleep_restart	= hrtimer_nanosleep_restart,
+		.timer_create	= common_timer_create,
 	};
 	struct k_clock clock_monotonic_raw = {
 		.clock_getres	= hrtimer_get_res,
 		.clock_get	= posix_get_monotonic_raw,
-		.timer_create	= no_timer_create,
 	};
 	struct k_clock clock_realtime_coarse = {
 		.clock_getres	= posix_get_coarse_res,
 		.clock_get	= posix_get_realtime_coarse,
-		.timer_create	= no_timer_create,
 	};
 	struct k_clock clock_monotonic_coarse = {
 		.clock_getres	= posix_get_coarse_res,
 		.clock_get	= posix_get_monotonic_coarse,
-		.timer_create	= no_timer_create,
 	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
@@ -523,19 +504,28 @@ static struct k_clock *clockid_to_kclock
 	return &posix_clocks[id];
 }
 
+static int common_timer_create(struct k_itimer *new_timer)
+{
+	hrtimer_init(&new_timer->it.real.timer, new_timer->it_clock, 0);
+	return 0;
+}
+
 /* Create a POSIX.1b interval timer. */
 
 SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 		struct sigevent __user *, timer_event_spec,
 		timer_t __user *, created_timer_id)
 {
+	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct k_itimer *new_timer;
 	int error, new_timer_id;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
 
-	if (invalid_clockid(which_clock))
+	if (!kc)
 		return -EINVAL;
+	if (!kc->timer_create)
+		return -EOPNOTSUPP;
 
 	new_timer = alloc_posix_timer();
 	if (unlikely(!new_timer))
@@ -597,7 +587,7 @@ SYSCALL_DEFINE3(timer_create, const cloc
 		goto out;
 	}
 
-	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
+	error = kc->timer_create(new_timer);
 	if (error)
 		goto out;
 
@@ -607,7 +597,7 @@ SYSCALL_DEFINE3(timer_create, const cloc
 	spin_unlock_irq(&current->sighand->siglock);
 
 	return 0;
- 	/*
+	/*
 	 * In the case of the timer belonging to another task, after
 	 * the task is unlocked, the timer is owned by the other task
 	 * and may cease to exist at any time.  Don't use or modify


