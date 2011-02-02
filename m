Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab1BBWBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:01:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:50637 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab1BBWBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:01:16 -0500
Date: Wed, 2 Feb 2011 22:00:58 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134418.903604289@linutronix.de>
References: <20110201134418.903604289@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Convert timer_create() to clockid_to_kclock()
Message-ID: <tip-838394fbf989973ec7f5a0ad82cb6ff09e5c39aa@git.kernel.org>
Git-Commit-ID: 838394fbf989973ec7f5a0ad82cb6ff09e5c39aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 22:00:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  838394fbf989973ec7f5a0ad82cb6ff09e5c39aa
Gitweb:     http://git.kernel.org/tip/838394fbf989973ec7f5a0ad82cb6ff09e5c39aa
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:51:58 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:15 +0100

posix-timers: Convert timer_create() to clockid_to_kclock()

Setup timer_create for CLOCK_MONOTONIC and CLOCK_REALTIME kclocks and
remove the no_timer_create() implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134418.903604289@linutronix.de>
---
 kernel/posix-timers.c |   40 +++++++++++++++-------------------------
 1 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index f9142a9..4f71382 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -146,6 +146,7 @@ static struct k_clock posix_clocks[MAX_CLOCKS];
  */
 static int common_nsleep(const clockid_t, int flags, struct timespec *t,
 			 struct timespec __user *rmtp);
+static int common_timer_create(struct k_itimer *new_timer);
 static void common_timer_get(struct k_itimer *, struct itimerspec *);
 static int common_timer_set(struct k_itimer *, int,
 			    struct itimerspec *, struct itimerspec *);
@@ -175,25 +176,6 @@ static inline void unlock_timer(struct k_itimer *timr, unsigned long flags)
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
@@ -269,27 +251,26 @@ static __init int init_posix_timers(void)
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
@@ -534,19 +515,28 @@ static struct k_clock *clockid_to_kclock(const clockid_t id)
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
@@ -608,7 +598,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 		goto out;
 	}
 
-	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
+	error = kc->timer_create(new_timer);
 	if (error)
 		goto out;
 
@@ -618,7 +608,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	spin_unlock_irq(&current->sighand->siglock);
 
 	return 0;
- 	/*
+	/*
 	 * In the case of the timer belonging to another task, after
 	 * the task is unlocked, the timer is owned by the other task
 	 * and may cease to exist at any time.  Don't use or modify
