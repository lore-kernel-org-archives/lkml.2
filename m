Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab1BANw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:52:59 -0500
Received: from www.tglx.de ([62.245.132.106]:47433 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757251Ab1BANw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:52:58 -0500
Message-Id: <20110201134419.101243181@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:52:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 17/28] posix-timers: Convert timer_gettime() to
	clockid_to_kclock()
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline; filename=posix-timers-convert-timer-get.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the common function for CLOCK_MONOTONIC and CLOCK_REALTIME kclocks
and use the new decoding function. No need to check for the return
value of it. If we have data corruption in the timer, we explode
somewhere else anyway. Also all kclocks which implement timer_create()
need to provide timer_gettime() as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 kernel/posix-timers.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -253,6 +253,7 @@ static __init int init_posix_timers(void
 		.nsleep_restart	= hrtimer_nanosleep_restart,
 		.timer_create	= common_timer_create,
 		.timer_set	= common_timer_set,
+		.timer_get	= common_timer_get,
 	};
 	struct k_clock clock_monotonic = {
 		.clock_getres	= hrtimer_get_res,
@@ -261,6 +262,7 @@ static __init int init_posix_timers(void
 		.nsleep_restart	= hrtimer_nanosleep_restart,
 		.timer_create	= common_timer_create,
 		.timer_set	= common_timer_set,
+		.timer_get	= common_timer_get,
 	};
 	struct k_clock clock_monotonic_raw = {
 		.clock_getres	= hrtimer_get_res,
@@ -701,15 +703,17 @@ common_timer_get(struct k_itimer *timr, 
 SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
 		struct itimerspec __user *, setting)
 {
-	struct k_itimer *timr;
 	struct itimerspec cur_setting;
+	struct k_itimer *timr;
+	struct k_clock *kc;
 	unsigned long flags;
 
 	timr = lock_timer(timer_id, &flags);
 	if (!timr)
 		return -EINVAL;
 
-	CLOCK_DISPATCH(timr->it_clock, timer_get, (timr, &cur_setting));
+	kc = clockid_to_kclock(timr->it_clock);
+	kc->timer_get(timr, &cur_setting);
 
 	unlock_timer(timr, flags);
 


