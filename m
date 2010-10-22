Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab0JVTLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:11:32 -0400
Received: from kroah.org ([198.145.64.141]:34162 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759361Ab0JVS4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:30 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:31 2010
Message-Id: <20101022185231.748920418@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Salman Qazi <sqazi@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [049/103] hrtimer: Preserve timer state in remove_hrtimer()
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/hrtimer.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -936,6 +936,7 @@ static inline int
 remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 {
 	if (hrtimer_is_queued(timer)) {
+		unsigned long state;
 		int reprogram;
 
 		/*
@@ -949,8 +950,13 @@ remove_hrtimer(struct hrtimer *timer, st
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
@@ -1237,6 +1243,9 @@ static void __run_hrtimer(struct hrtimer
 		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
 		enqueue_hrtimer(timer, base);
 	}
+
+	WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
+
 	timer->state &= ~HRTIMER_STATE_CALLBACK;
 }
 


