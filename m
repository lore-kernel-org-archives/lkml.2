Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab1JWGiD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:38:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab1JWGeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:14 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:38 2011
Message-Id: <20111023062538.403220218@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:35 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [07/27] cputimer: Cure lock inversion
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit bcd5cff7216f9b2de0a148cc355eac199dc6f1cf upstream.

There's a lock inversion between the cputimer->lock and rq->lock;
notably the two callchains involved are:

 update_rlimit_cpu()
   sighand->siglock
   set_process_cpu_timer()
     cpu_timer_sample_group()
       thread_group_cputimer()
         cputimer->lock
         thread_group_cputime()
           task_sched_runtime()
             ->pi_lock
             rq->lock

 scheduler_tick()
   rq->lock
   task_tick_fair()
     update_curr()
       account_group_exec()
         cputimer->lock

Where the first one is enabling a CLOCK_PROCESS_CPUTIME_ID timer, and
the second one is keeping up-to-date.

This problem was introduced by e8abccb7193 ("posix-cpu-timers: Cure
SMP accounting oddities").

Cure the problem by removing the cputimer->lock and rq->lock nesting,
this leaves concurrent enablers doing duplicate work, but the time
wasted should be on the same order otherwise wasted spinning on the
lock and the greater-than assignment filter should ensure we preserve
monotonicity.

Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Simon Kirby <sim@hostway.ca>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Link: http://lkml.kernel.org/r/1318928713.21167.4.camel@twins
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/posix-cpu-timers.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -274,9 +274,7 @@ void thread_group_cputimer(struct task_s
 	struct task_cputime sum;
 	unsigned long flags;
 
-	spin_lock_irqsave(&cputimer->lock, flags);
 	if (!cputimer->running) {
-		cputimer->running = 1;
 		/*
 		 * The POSIX timer interface allows for absolute time expiry
 		 * values through the TIMER_ABSTIME flag, therefore we have
@@ -284,8 +282,11 @@ void thread_group_cputimer(struct task_s
 		 * it.
 		 */
 		thread_group_cputime(tsk, &sum);
+		spin_lock_irqsave(&cputimer->lock, flags);
+		cputimer->running = 1;
 		update_gt_cputime(&cputimer->cputime, &sum);
-	}
+	} else
+		spin_lock_irqsave(&cputimer->lock, flags);
 	*times = cputimer->cputime;
 	spin_unlock_irqrestore(&cputimer->lock, flags);
 }


