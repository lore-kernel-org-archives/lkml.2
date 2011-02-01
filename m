Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab1BANwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:52:25 -0500
Received: from www.tglx.de ([62.245.132.106]:47323 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700Ab1BANwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:52:22 -0500
Message-Id: <20110201134419.198999420@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:52:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 18/28] posix-timers: Convert timer_delete() to
	clockid_to_kclock()
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline; filename=posix-timers-convert-timer-del.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the common function for CLOCK_MONOTONIC and CLOCK_REALTIME kclocks
and use the new decoding function. No need to check for the return
value of it. If we have data corruption in the timer, we explode
somewhere else anyway. Also all kclocks which implement timer_create()
need to provide timer_delete() as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 kernel/posix-timers.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -254,6 +254,7 @@ static __init int init_posix_timers(void
 		.timer_create	= common_timer_create,
 		.timer_set	= common_timer_set,
 		.timer_get	= common_timer_get,
+		.timer_del	= common_timer_del,
 	};
 	struct k_clock clock_monotonic = {
 		.clock_getres	= hrtimer_get_res,
@@ -263,6 +264,7 @@ static __init int init_posix_timers(void
 		.timer_create	= common_timer_create,
 		.timer_set	= common_timer_set,
 		.timer_get	= common_timer_get,
+		.timer_del	= common_timer_del,
 	};
 	struct k_clock clock_monotonic_raw = {
 		.clock_getres	= hrtimer_get_res,
@@ -852,7 +854,9 @@ static inline int common_timer_del(struc
 
 static inline int timer_delete_hook(struct k_itimer *timer)
 {
-	return CLOCK_DISPATCH(timer->it_clock, timer_del, (timer));
+	struct k_clock *kc = clockid_to_kclock(timer->it_clock);
+
+	return kc->timer_del(timer);
 }
 
 /* Delete a POSIX.1b interval timer. */


