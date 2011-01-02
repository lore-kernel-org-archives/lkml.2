Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1ABHZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:25:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:36971 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab1ABHZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Salman Qazi <sqazi@google.com>,
        akpm@linux-foundation.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 184/260] hrtimer: Preserve timer state in remove_hrtimer()
Date: Sun,  2 Jan 2011 02:18:00 -0500
Message-Id: <1293952756-15010-185-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:32.0401 (UTC) FILETIME=[F5D8A210:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Salman Qazi <sqazi@google.com>

commit f13d4f979c518119bba5439dd2364d76d31dcd3f upstream.

The race is described as follows:

CPU X                                 CPU Y
remove_hrtimer
// state & QUEUED == 0
timer->state = CALLBACK
unlock timer base
timer->f(n) //very long
                                  hrtimer_start
                                    lock timer base
                                    remove_hrtimer // no effect
                                    hrtimer_enqueue
                                    timer->state = CALLBACK |
                                                   QUEUED
                                    unlock timer base
                                  hrtimer_start
                                    lock timer base
                                    remove_hrtimer
                                        mode = INACTIVE
                                        // CALLBACK bit lost!
                                    switch_hrtimer_base
                                            CALLBACK bit not set:
                                                    timer->base
                                                    changes to a
                                                    different CPU.
lock this CPU's timer base

The bug was introduced with commit ca109491f (hrtimer: removing all ur
callback modes) in 2.6.29

[ tglx: Feed new state via local variable and add a comment. ]

Signed-off-by: Salman Qazi <sqazi@google.com>
Cc: akpm@linux-foundation.org
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20101012142351.8485.21823.stgit@dungbeetle.mtv.corp.google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/hrtimer.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0086628..3c727aa 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -936,6 +936,7 @@ static inline int
 remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 {
 	if (hrtimer_is_queued(timer)) {
+		unsigned long state;
 		int reprogram;
 
 		/*
@@ -949,8 +950,13 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 		debug_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
 		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
-		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
-				 reprogram);
+		/*
+		 * We must preserve the CALLBACK state flag here,
+		 * otherwise we could move the timer base in
+		 * switch_hrtimer_base.
+		 */
+		state = timer->state & HRTIMER_STATE_CALLBACK;
+		__remove_hrtimer(timer, base, state, reprogram);
 		return 1;
 	}
 	return 0;
@@ -1237,6 +1243,9 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
 		enqueue_hrtimer(timer, base);
 	}
+
+	WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
+
 	timer->state &= ~HRTIMER_STATE_CALLBACK;
 }
 
-- 
1.7.3.3

