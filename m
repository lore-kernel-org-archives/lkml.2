Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab1BANvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:51:38 -0500
Received: from www.tglx.de ([62.245.132.106]:47144 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757050Ab1BANvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:51:35 -0500
Message-Id: <20110201134418.034175556@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:51:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 06/28] posix-timers: Convert clock_nanosleep to
	clockid_to_kclock()
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline; filename=posix-timers-convert-nanosleep.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new kclock decoding function in clock_nanosleep and cleanup all
kclocks which use the default functions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 drivers/char/mmtimer.c       |    1 -
 include/linux/posix-timers.h |    2 --
 kernel/posix-timers.c        |   26 +++++++-------------------
 3 files changed, 7 insertions(+), 22 deletions(-)

Index: linux-2.6-tip/drivers/char/mmtimer.c
===================================================================
--- linux-2.6-tip.orig/drivers/char/mmtimer.c
+++ linux-2.6-tip/drivers/char/mmtimer.c
@@ -768,7 +768,6 @@ static struct k_clock sgi_clock = {
 	.clock_set	= sgi_clock_set,
 	.clock_get	= sgi_clock_get,
 	.timer_create	= sgi_timer_create,
-	.nsleep		= do_posix_clock_nonanosleep,
 	.timer_set	= sgi_timer_set,
 	.timer_del	= sgi_timer_del,
 	.timer_get	= sgi_timer_get
Index: linux-2.6-tip/include/linux/posix-timers.h
===================================================================
--- linux-2.6-tip.orig/include/linux/posix-timers.h
+++ linux-2.6-tip/include/linux/posix-timers.h
@@ -90,8 +90,6 @@ extern struct k_clock clock_posix_cpu;
 void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
 
 /* error handlers for timer_create, nanosleep and settime */
-int do_posix_clock_nonanosleep(const clockid_t, int flags, struct timespec *,
-			       struct timespec __user *);
 int do_posix_clock_nosettime(const clockid_t, const struct timespec *tp);
 
 /* function to call to trigger timer event */
Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -216,12 +216,6 @@ static int no_timer_create(struct k_itim
 	return -EOPNOTSUPP;
 }
 
-static int no_nsleep(const clockid_t which_clock, int flags,
-		     struct timespec *tsave, struct timespec __user *rmtp)
-{
-	return -EOPNOTSUPP;
-}
-
 /*
  * Return nonzero if we know a priori this clockid_t value is bogus.
  */
@@ -282,32 +276,31 @@ static __init int init_posix_timers(void
 {
 	struct k_clock clock_realtime = {
 		.clock_getres	= hrtimer_get_res,
+		.nsleep		= common_nsleep,
 	};
 	struct k_clock clock_monotonic = {
 		.clock_getres	= hrtimer_get_res,
 		.clock_get	= posix_ktime_get_ts,
 		.clock_set	= do_posix_clock_nosettime,
+		.nsleep		= common_nsleep,
 	};
 	struct k_clock clock_monotonic_raw = {
 		.clock_getres	= hrtimer_get_res,
 		.clock_get	= posix_get_monotonic_raw,
 		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= no_timer_create,
-		.nsleep		= no_nsleep,
 	};
 	struct k_clock clock_realtime_coarse = {
 		.clock_getres	= posix_get_coarse_res,
 		.clock_get	= posix_get_realtime_coarse,
 		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= no_timer_create,
-		.nsleep		= no_nsleep,
 	};
 	struct k_clock clock_monotonic_coarse = {
 		.clock_getres	= posix_get_coarse_res,
 		.clock_get	= posix_get_monotonic_coarse,
 		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= no_timer_create,
-		.nsleep		= no_nsleep,
 	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
@@ -952,13 +945,6 @@ int do_posix_clock_nosettime(const clock
 }
 EXPORT_SYMBOL_GPL(do_posix_clock_nosettime);
 
-int do_posix_clock_nonanosleep(const clockid_t clock, int flags,
-			       struct timespec *t, struct timespec __user *r)
-{
-	return -ENANOSLEEP_NOTSUP;
-}
-EXPORT_SYMBOL_GPL(do_posix_clock_nonanosleep);
-
 SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
 		const struct timespec __user *, tp)
 {
@@ -1023,10 +1009,13 @@ SYSCALL_DEFINE4(clock_nanosleep, const c
 		const struct timespec __user *, rqtp,
 		struct timespec __user *, rmtp)
 {
+	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec t;
 
-	if (invalid_clockid(which_clock))
+	if (!kc)
 		return -EINVAL;
+	if (!kc->nsleep)
+		return -ENANOSLEEP_NOTSUP;
 
 	if (copy_from_user(&t, rqtp, sizeof (struct timespec)))
 		return -EFAULT;
@@ -1034,8 +1023,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const c
 	if (!timespec_valid(&t))
 		return -EINVAL;
 
-	return CLOCK_DISPATCH(which_clock, nsleep,
-			      (which_clock, flags, &t, rmtp));
+	return kc->nsleep(which_clock, flags, &t, rmtp);
 }
 
 /*


