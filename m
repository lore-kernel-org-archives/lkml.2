Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab1BANwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:52:14 -0500
Received: from www.tglx.de ([62.245.132.106]:47278 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141Ab1BANwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:52:10 -0500
Message-Id: <20110201134418.709802797@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:51:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 13/28] posix-timers: Convert clock_getres() to
	clockid_to_kclock()
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline; filename=posix-timers-convert-clock-getres.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new kclock decoding. Fixup the fallout in mmtimer.c

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 drivers/char/mmtimer.c |   10 ++++++++++
 kernel/posix-timers.c  |   17 ++++-------------
 2 files changed, 14 insertions(+), 13 deletions(-)

Index: linux-2.6-tip/drivers/char/mmtimer.c
===================================================================
--- linux-2.6-tip.orig/drivers/char/mmtimer.c
+++ linux-2.6-tip/drivers/char/mmtimer.c
@@ -53,6 +53,8 @@ MODULE_LICENSE("GPL");
 
 #define RTC_BITS 55 /* 55 bits for this implementation */
 
+static struct k_clock sgi_clock;
+
 extern unsigned long sn_rtc_cycles_per_second;
 
 #define RTC_COUNTER_ADDR        ((long *)LOCAL_MMR_ADDR(SH_RTC))
@@ -763,10 +765,18 @@ static int sgi_timer_set(struct k_itimer
 	return err;
 }
 
+static int sgi_clock_getres(const clockid_t which_clock, struct timespec *tp)
+{
+	tp->tv_sec = 0;
+	tp->tv_nsec = sgi_clock.res;
+	return 0;
+}
+
 static struct k_clock sgi_clock = {
 	.res = 0,
 	.clock_set	= sgi_clock_set,
 	.clock_get	= sgi_clock_get,
+	.clock_getres	= sgi_clock_getres,
 	.timer_create	= sgi_timer_create,
 	.timer_set	= sgi_timer_set,
 	.timer_del	= sgi_timer_del,
Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -182,14 +182,6 @@ static inline void unlock_timer(struct k
  * the function pointer CALL in struct k_clock.
  */
 
-static inline int common_clock_getres(const clockid_t which_clock,
-				      struct timespec *tp)
-{
-	tp->tv_sec = 0;
-	tp->tv_nsec = posix_clocks[which_clock].res;
-	return 0;
-}
-
 static int common_timer_create(struct k_itimer *new_timer)
 {
 	hrtimer_init(&new_timer->it.real.timer, new_timer->it_clock, 0);
@@ -975,18 +967,17 @@ SYSCALL_DEFINE2(clock_gettime, const clo
 SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock,
 		struct timespec __user *, tp)
 {
+	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec rtn_tp;
 	int error;
 
-	if (invalid_clockid(which_clock))
+	if (!kc)
 		return -EINVAL;
 
-	error = CLOCK_DISPATCH(which_clock, clock_getres,
-			       (which_clock, &rtn_tp));
+	error = kc->clock_getres(which_clock, &rtn_tp);
 
-	if (!error && tp && copy_to_user(tp, &rtn_tp, sizeof (rtn_tp))) {
+	if (!error && tp && copy_to_user(tp, &rtn_tp, sizeof (rtn_tp)))
 		error = -EFAULT;
-	}
 
 	return error;
 }


