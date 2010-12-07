Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab0LGSzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 13:55:16 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:53176 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753833Ab0LGSzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 13:55:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18G3swqL5IG/lOrEeYzK3C8MtY2h+dS5qzNZ/EF45
	Z+rCGAul5t7nC3
Subject: Re: [patchlet] Re: Scheduler bug related to rq->skip_clock_update?
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        "Bjoern B. Brandenburg" <bbb.lst@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Andrea Bastoni <bastoni@sprg.uniroma2.it>,
        "James H. Anderson" <anderson@cs.unc.edu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291740081.2032.751.camel@laptop>
References: <alpine.LNX.2.00.1011202315290.8927@jupiter-cs.cs.unc.edu>
	 <1290359641.4816.69.camel@maggy.simson.net>
	 <alpine.LNX.2.00.1011212327250.8927@jupiter-cs.cs.unc.edu>
	 <1290442781.16393.22.camel@maggy.simson.net>
	 <alpine.LNX.2.00.1011221310430.8927@jupiter-cs.cs.unc.edu>
	 <20101205052819.GA2878@zhy> <1291613607.9457.5.camel@marge.simson.net>
	 <AANLkTimH0YN0fd4zOk3A=_Q7waqM=6V4pw4N+0g0-k=7@mail.gmail.com>
	 <1291624329.9457.38.camel@marge.simson.net>
	 <1291740081.2032.751.camel@laptop>
Content-Type: text/plain
Date: Tue, 07 Dec 2010 19:55:09 +0100
Message-Id: <1291748109.7475.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 17:41 +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-06 at 09:32 +0100, Mike Galbraith wrote:
> 
> >  kernel/fork.c  |    1 +
> >  kernel/sched.c |    6 +++---
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > Index: linux-2.6.37.git/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.37.git.orig/kernel/sched.c
> > +++ linux-2.6.37.git/kernel/sched.c
> > @@ -660,6 +660,7 @@ inline void update_rq_clock(struct rq *r
> >  
> >  		sched_irq_time_avg_update(rq, irq_time);
> >  	}
> > +	rq->skip_clock_update = 0;
> >  }
> >  
> >  /*
> 
> Shouldn't we do that at the end of schedule()? Since the purpose of
> ->skip_clock_update is to avoid multiple calls to:
>   - avoid overhead
>   - ensure scheduling is accounted at a single point
> 
> [ for that latter purpose it might also make sense to put that point
> somewhere around context_switch() but due to the fact that we need a
> clock update early that's a bit impractical. ]
> 
> Hmm?

Yeah, could do that instead.  There's no gain in any call that may
happen in the interval between.  Think I'll measure though, this bug was
a surprise :)

> > @@ -2138,7 +2139,7 @@ static void check_preempt_curr(struct rq
> >  	 * A queue event has occurred, and we're going to schedule.  In
> >  	 * this case, we can save a useless back to back clock update.
> >  	 */
> > -	if (test_tsk_need_resched(rq->curr))
> > +	if (rq->curr->se.on_rq && test_tsk_need_resched(rq->curr))
> >  		rq->skip_clock_update = 1;
> >  }
> 
> OK, I initially tried to replace the test with a return value of
> ->check_preempt_curr() and such, but that turns into a lot of code and
> won't necessarily be any better.

(Yeah, I considered doing the same)

> > @@ -3854,7 +3855,6 @@ static void put_prev_task(struct rq *rq,
> >  {
> >  	if (prev->se.on_rq)
> >  		update_rq_clock(rq);
> > -	rq->skip_clock_update = 0;
> >  	prev->sched_class->put_prev_task(rq, prev);
> >  }
> 
> See the first note.
> 
> > @@ -3912,7 +3912,6 @@ need_resched_nonpreemptible:
> >  		hrtick_clear(rq);
> >  
> >  	raw_spin_lock_irq(&rq->lock);
> > -	clear_tsk_need_resched(prev);
> >  
> >  	switch_count = &prev->nivcsw;
> >  	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
> > @@ -3942,6 +3941,7 @@ need_resched_nonpreemptible:
> >  	if (unlikely(!rq->nr_running))
> >  		idle_balance(cpu, rq);
> >  
> > +	clear_tsk_need_resched(prev);
> >  	put_prev_task(rq, prev);
> >  	next = pick_next_task(rq);
> 
> Good find, this needs to be done after the idle balancing because that
> can release the rq->lock and allow for TIF_NEED_RESCHED to be set again.
> 
> Maybe complement this with a WARN_ON_ONCE(test_tsk_need_resched(next))
> somewhere after pick_next_task() so as to ensure that !current has !
> TIF_NEED_RESCHED.
> 
> > Index: linux-2.6.37.git/kernel/fork.c
> > ===================================================================
> > --- linux-2.6.37.git.orig/kernel/fork.c
> > +++ linux-2.6.37.git/kernel/fork.c
> > @@ -275,6 +275,7 @@ static struct task_struct *dup_task_stru
> >  
> >  	setup_thread_stack(tsk, orig);
> >  	clear_user_return_notifier(tsk);
> > +	clear_tsk_need_resched(tsk);
> >  	stackend = end_of_stack(tsk);
> >  	*stackend = STACK_END_MAGIC;	/* for overflow detection */
> >  
> 
> OK.. have we looked if there's more TIF flags that could do with a
> reset?

mmm, no.

	-Mike

