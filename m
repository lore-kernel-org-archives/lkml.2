Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab1FVNrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 09:47:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:59203 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab1FVNrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 09:47:35 -0400
Date: Wed, 22 Jun 2011 15:47:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [RFC][PATCH 2/3] sched, workqueue: Move WQ-sleeper wakeup
In-Reply-To: <20110622092430.GA30101@htj.dyndns.org>
Message-ID: <alpine.LFD.2.02.1106221532460.11814@ionos>
References: <20110621233444.094372367@chello.nl> <20110621233648.861571721@chello.nl> <20110622092430.GA30101@htj.dyndns.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011, Tejun Heo wrote:
> On Wed, Jun 22, 2011 at 01:34:46AM +0200, Peter Zijlstra wrote:
> 
> Preemption could still be enabled here, right?  What prevents
> preemtion kicking after wq_worker_sleeping() and do it again thus
> breaking nr_running tracking.

That wq code should serialize itself and not magically abuse rq->lock
for this.
 
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

The accounting can be done at schedule entry and exit and not
somewhere magic in the wakeup code. It does really not matter, whether
nr_running is updated on wakeup or when the worker gets on the cpu.

Thanks,

	tglx
