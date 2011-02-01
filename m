Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab1BANwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:52:41 -0500
Received: from www.tglx.de ([62.245.132.106]:47373 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757207Ab1BANwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:52:34 -0500
Message-Id: <20110201134419.001863714@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:52:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 16/28] posix-timers: Convert timer_settime() to
	clockid_to_kclock()
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline; filename=posix-timers-convert-timer-set.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the common function for CLOCK_MONOTONIC and CLOCK_REALTIME kclocks
and use the new decoding function. No need to check for the return
value of it. If we have data corruption in the timer, we explode
somewhere else anyway. Also all kclocks which implement timer_create()
need to provide timer_settime() as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 kernel/posix-timers.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -252,6 +252,7 @@ static __init int init_posix_timers(void
 		.nsleep		= common_nsleep,
 		.nsleep_restart	= hrtimer_nanosleep_restart,
 		.timer_create	= common_timer_create,
+		.timer_set	= common_timer_set,
 	};
 	struct k_clock clock_monotonic = {
 		.clock_getres	= hrtimer_get_res,
@@ -259,6 +260,7 @@ static __init int init_posix_timers(void
 		.nsleep		= common_nsleep,
 		.nsleep_restart	= hrtimer_nanosleep_restart,
 		.timer_create	= common_timer_create,
+		.timer_set	= common_timer_set,
 	};
 	struct k_clock clock_monotonic_raw = {
 		.clock_getres	= hrtimer_get_res,
@@ -803,6 +805,7 @@ SYSCALL_DEFINE4(timer_settime, timer_t, 
 	int error = 0;
 	unsigned long flag;
 	struct itimerspec *rtn = old_setting ? &old_spec : NULL;
+	struct k_clock *kc;
 
 	if (!new_setting)
 		return -EINVAL;
@@ -818,8 +821,8 @@ retry:
 	if (!timr)
 		return -EINVAL;
 
-	error = CLOCK_DISPATCH(timr->it_clock, timer_set,
-			       (timr, flags, &new_spec, rtn));
+	kc = clockid_to_kclock(timr->it_clock);
+	error = kc->timer_set(timr, flags, &new_spec, rtn);
 
 	unlock_timer(timr, flag);
 	if (error == TIMER_RETRY) {


