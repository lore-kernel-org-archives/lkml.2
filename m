Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab1BCRQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:16:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47900 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab1BCRQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:16:05 -0500
Subject: Re: [RFC][PATCH 11/18] sched: Add p->pi_lock to task_rq_lock()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: frank.rowand@am.sony.com
Cc: Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D435DA6.70208@am.sony.com>
References: <20110104145929.772813816@chello.nl>
	 <20110104150102.862431889@chello.nl>  <4D435DA6.70208@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Feb 2011 18:16:50 +0100
Message-ID: <1296753410.26581.463.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 16:21 -0800, Frank Rowand wrote:
> On 01/04/11 06:59, Peter Zijlstra wrote:
> > In order to be able to call set_task_cpu() while either holding
> > p->pi_lock or task_rq(p)->lock we need to hold both locks in order to
> > stabilize task_rq().
> > 
> > This makes task_rq_lock() acquire both locks, and have
> > __task_rq_lock() validate that p->pi_lock is held. This increases the
> > locking overhead for most scheduler syscalls but allows reduction of
> > rq->lock contention for some scheduler hot paths (ttwu).
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  kernel/sched.c |   81 ++++++++++++++++++++++++++-------------------------------
> >  1 file changed, 37 insertions(+), 44 deletions(-)
> > 
> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > 
> 
> > @@ -980,10 +972,13 @@ static void __task_rq_unlock(struct rq *
> >  	raw_spin_unlock(&rq->lock);
> >  }
> >  
> > -static inline void task_rq_unlock(struct rq *rq, unsigned long *flags)
> > +static inline void
> > +task_rq_unlock(struct rq *rq, struct task_struct *p, unsigned long *flags)
> >  	__releases(rq->lock)
> > +	__releases(p->pi_lock)
> >  {
> > -	raw_spin_unlock_irqrestore(&rq->lock, *flags);
> > +	raw_spin_unlock(&rq->lock);
> > +	raw_spin_unlock_irqrestore(&p->pi_lock, *flags);
> >  }
> >  
> >  /*
> 
> Most of the callers of task_rq_unlock() were also fixed up to reflect
> the newly added parameter "*p", but a couple were missed.  By the end
> of the patch series that is ok because the couple that were missed
> get removed in patches 12 and 13.  But if you want the patch series
> to be bisectable (which I think it is otherwise), you might want to
> fix those last couple of callers of task_rq_unlock() in this patch.

Fixed those up indeed, thanks!

> 
> > @@ -2646,9 +2647,9 @@ void sched_fork(struct task_struct *p, i
> >          *
> >          * Silence PROVE_RCU.
> >          */
> > -       rcu_read_lock();
> > +       raw_spin_lock_irqsave(&p->pi_lock, flags);
> >         set_task_cpu(p, cpu);
> > -       rcu_read_unlock();
> > +       raw_spin_unlock_irqrestore(&p->pi_lock, flags);
> 
> Does "* Silence PROVE_RCU." no longer apply after remove rcu_read_lock() and
> rcu_read_unlock()?

I think the locking is still strictly superfluous, I can't seem to
recollect why I changed it from RCU to pi_lock, but since the task is
fresh and unhashed it really cannot be subject to concurrency.

