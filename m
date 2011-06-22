Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab1FVJ2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:28:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:47328 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab1FVJ2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:28:13 -0400
Subject: Re: [RFC][PATCH 2/3] sched, workqueue: Move WQ-sleeper wakeup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <20110622092430.GA30101@htj.dyndns.org>
References: <20110621233444.094372367@chello.nl>
	 <20110621233648.861571721@chello.nl>
	 <20110622092430.GA30101@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Jun 2011 11:27:28 +0200
Message-ID: <1308734848.1022.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-22 at 11:24 +0200, Tejun Heo wrote:
> Hello, Peter.
> 
> On Wed, Jun 22, 2011 at 01:34:46AM +0200, Peter Zijlstra wrote:
> > -/**
> >   * wake_up_process - Wake up a specific process
> >   * @p: The process to be woken up.
> >   *
> > @@ -4215,6 +4181,19 @@ static inline void sched_submit_work(voi
> >  
> >  	if (tsk->state && !(preempt_count() & PREEMPT_ACTIVE)) {
> >  		/*
> > +		 * If a worker went to sleep, notify and ask workqueue
> > +		 * whether it wants to wake up a task to maintain
> > +		 * concurrency.
> > +		 */
> > +		if (tsk->flags & PF_WQ_WORKER) {
> > +			struct task_struct *to_wakeup;
> > +
> > +			to_wakeup = wq_worker_sleeping(tsk, smp_processor_id());
> > +			if (to_wakeup)
> > +				wake_up_process(to_wakeup);
> > +		}
> > +
> > +		/*
> 
> Preemption could still be enabled here, right?  What prevents
> preemtion kicking after wq_worker_sleeping() and do it again thus
> breaking nr_running tracking.

Aren't all PF_WQ_WORKER threads cpu-bound?

> >  		 * If we are going to sleep and we have plugged IO
> >  		 * queued, make sure to submit it to avoid deadlocks.
> >  		 */
> > @@ -4256,19 +4235,6 @@ asmlinkage void __sched schedule(void)
> >  		} else {
> >  			deactivate_task(rq, prev, DEQUEUE_SLEEP);
> >  			prev->on_rq = 0;
> > -
> > -			/*
> > -			 * If a worker went to sleep, notify and ask workqueue
> > -			 * whether it wants to wake up a task to maintain
> > -			 * concurrency.
> > -			 */
> > -			if (prev->flags & PF_WQ_WORKER) {
> > -				struct task_struct *to_wakeup;
> > -
> > -				to_wakeup = wq_worker_sleeping(prev, cpu);
> > -				if (to_wakeup)
> > -					try_to_wake_up_local(to_wakeup);
> > -			}
> 
> Similarly, the if the 'if {}' part of the above if/else is taken, the
> task never goes to sleep and nr_running will again be broken.

Bah, indeed, I forgot about that, 2am isn't the best of times to do
these things.
