Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab1JRJFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:05:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:40399 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab1JRJFa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:05:30 -0400
Subject: Re: Linux 3.1-rc9
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Date: Tue, 18 Oct 2011 11:05:13 +0200
In-Reply-To: <alpine.LFD.2.02.1110181037120.3240@ionos>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
	  <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca>
	  <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca>
	  <1318060551.8395.0.camel@twins> <20111012213555.GC24461@hostway.ca>
	  <20111013232521.GA5654@hostway.ca>
	  <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
	  <1318847658.6594.40.camel@twins>
	  <CA+55aFxaGKEyhXdHXNxvPrPQ-SGSpbXdfoeXrxfjPx3VXsgvtg@mail.gmail.com>
	  <1318874090.4172.84.camel@twins>
	  <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com>
	 <1318879396.4172.92.camel@twins> <alpine.LFD.2.02.1110172237030.3240@ionos>
	 <alpine.LFD.2.02.1110181037120.3240@ionos>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318928713.21167.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 10:39 +0200, Thomas Gleixner wrote:
> On Mon, 17 Oct 2011, Thomas Gleixner wrote:
> > That said, I really need some sleep before I can make a final
> > judgement on that horror. The call paths are such an intermingled mess
> > that it's not funny anymore. I do that tomorrow morning first thing.
> 
> The patch is safe and the exit race just existed in my confused tired
> brain. Peter, can you please provide a changelog. That wants a cc
> stable as well, because that deadlock causing commit hit 3.0.7 :( 

---
Subject: cputimer: Cure lock inversion
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Oct 17 11:50:30 CEST 2011

There's a lock inversion between the cputimer->lock and rq->lock; notably
the two callchains involved are:

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
Cc: stable@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/posix-cpu-timers.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)
Index: linux-2.6/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6.orig/kernel/posix-cpu-timers.c
+++ linux-2.6/kernel/posix-cpu-timers.c
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

