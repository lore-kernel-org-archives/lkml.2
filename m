Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab1BANvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:51:53 -0500
Received: from www.tglx.de ([62.245.132.106]:47140 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757018Ab1BANv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:51:26 -0500
Message-Id: <20110201134418.131263211@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:51:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 07/28] posix-timers: Convert clock_nanosleep_restart to
	clockid_to_kclock()
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline;
	filename=posix-timers-convert-nanosleep-restart.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new kclock decoding function in clock_nanosleep_restart. No
need to check kclock here as the restart block always contains a valid
clockid. If not, we are in serious trouble anyway.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 kernel/posix-timers.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -277,12 +277,14 @@ static __init int init_posix_timers(void
 	struct k_clock clock_realtime = {
 		.clock_getres	= hrtimer_get_res,
 		.nsleep		= common_nsleep,
+		.nsleep_restart	= hrtimer_nanosleep_restart,
 	};
 	struct k_clock clock_monotonic = {
 		.clock_getres	= hrtimer_get_res,
 		.clock_get	= posix_ktime_get_ts,
 		.clock_set	= do_posix_clock_nosettime,
 		.nsleep		= common_nsleep,
+		.nsleep_restart	= hrtimer_nanosleep_restart,
 	};
 	struct k_clock clock_monotonic_raw = {
 		.clock_getres	= hrtimer_get_res,
@@ -1027,22 +1029,13 @@ SYSCALL_DEFINE4(clock_nanosleep, const c
 }
 
 /*
- * nanosleep_restart for monotonic and realtime clocks
- */
-static int common_nsleep_restart(struct restart_block *restart_block)
-{
-	return hrtimer_nanosleep_restart(restart_block);
-}
-
-/*
  * This will restart clock_nanosleep. This is required only by
  * compat_clock_nanosleep_restart for now.
  */
-long
-clock_nanosleep_restart(struct restart_block *restart_block)
+long clock_nanosleep_restart(struct restart_block *restart_block)
 {
 	clockid_t which_clock = restart_block->arg0;
+	struct k_clock *kc = clockid_to_kclock(which_clock);
 
-	return CLOCK_DISPATCH(which_clock, nsleep_restart,
-			      (restart_block));
+	return kc->nsleep_restart(restart_block);
 }


