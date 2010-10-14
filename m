Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0JNLfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 07:35:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:55858 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab0JNLfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 07:35:16 -0400
Date: Thu, 14 Oct 2010 11:34:31 GMT
From: tip-bot for Salman Qazi <sqazi@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, sqazi@google.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sqazi@google.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20101012142351.8485.21823.stgit@dungbeetle.mtv.corp.google.com>
References: <20101012142351.8485.21823.stgit@dungbeetle.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] hrtimer: Preserve timer state in remove_hrtimer()
Message-ID: <tip-f13d4f979c518119bba5439dd2364d76d31dcd3f@git.kernel.org>
Git-Commit-ID: f13d4f979c518119bba5439dd2364d76d31dcd3f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Oct 2010 11:34:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f13d4f979c518119bba5439dd2364d76d31dcd3f
Gitweb:     http://git.kernel.org/tip/f13d4f979c518119bba5439dd2364d76d31dcd3f
Author:     Salman Qazi <sqazi@google.com>
AuthorDate: Tue, 12 Oct 2010 07:25:19 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 14 Oct 2010 13:29:59 +0200

hrtimer: Preserve timer state in remove_hrtimer()

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
Cc: stable@kernel.org
---
 kernel/hrtimer.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 1decafb..72206cf 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -931,6 +931,7 @@ static inline int
 remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 {
 	if (hrtimer_is_queued(timer)) {
+		unsigned long state;
 		int reprogram;
 
 		/*
@@ -944,8 +945,13 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
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
@@ -1231,6 +1237,9 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
 		enqueue_hrtimer(timer, base);
 	}
+
+	WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
+
 	timer->state &= ~HRTIMER_STATE_CALLBACK;
 }
 
