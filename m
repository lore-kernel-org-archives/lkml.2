Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab0FAImI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:42:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab0FAImG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:42:06 -0400
Date: Tue, 1 Jun 2010 18:41:57 +1000
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [rfc] forked kernel task and mm structures imbalanced on NUMA
Message-ID: <20100601084157.GS9453@laptop>
References: <20100601073343.GQ9453@laptop>
 <1275380202.27810.26214.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275380202.27810.26214.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 10:16:42AM +0200, Peter Zijlstra wrote:
> On Tue, 2010-06-01 at 17:33 +1000, Nick Piggin wrote:
> > Another problem I found when testing this patch is that the scheduler
> > has some issues of its own when balancing. This is improved by
> > traversing the sd groups starting from a different spot each time, so
> > processes get sprinkled around the nodes a bit better.
> 
> Right, makes sense. And I think we could merge that group iteration
> without much problems.
> 
> Your alternative placement for sched_exec() seems to make sense too, the
> earlier we do that the better the memory allocations will be.
> 
> Your changes to sched_fork() and wake_up_new_task() made my head hurt a
> bit -- but that's not your fault. I'm not quite sure why you're changing
> that though.

Well because we indeed don't want to select a new CPU for it unless
there has been a cpus_allowed race in the meantime.

 
> The addition of sched_fork_suggest_cpu() to select a target node seems
> to make sense, but since you then call fork balancing a second time we
> have a chance of ending up on a totally different node all together.
> 
> So I think it would make sense to rework the fork balancing muck to be
> called only once and stick with its decision.

Just need to close that race somehow. AFAIKS we can't use TASK_WAKING
because that must not be preempted?

Otherwise I don't see a problem with just taking another balance on
the extremely rare case of task failure.


 
> One thing that would make the whole fork path much easier is fully
> ripping out that child_runs_first mess for CONFIG_SMP, I think its been
> disabled by default for long enough, and its always been broken in the
> face of fork balancing anyway.

Interesting problem. vfork is nice for fork+exec, but it's a bit
restrictive.

 
> So basically we have to move fork balancing back to sched_fork(), I'd
> have to again look at wth happens to ->cpus_allowed, but I guess it
> should be fixable, and I don't think we should care overly much about
> cpu-hotplug.

No more than simply getting it right. Simply calling into the balancer
again seems to be the simplest way to do it.

 
> A specific code comment:
> 
> > @@ -2550,14 +2561,16 @@ void wake_up_new_task(struct task_struct
> >          * We set TASK_WAKING so that select_task_rq() can drop rq->lock
> >          * without people poking at ->cpus_allowed.
> >          */
> > -       cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
> > -       set_task_cpu(p, cpu);
> > -
> > -       p->state = TASK_RUNNING;
> > -       task_rq_unlock(rq, &flags);
> > +       if (!cpumask_test_cpu(cpu, &p->cpus_allowed)) {
> > +               p->state = TASK_WAKING;
> > +               cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
> > +               set_task_cpu(p, cpu);
> > +               p->state = TASK_RUNNING;
> > +               task_rq_unlock(rq, &flags);
> > +               rq = task_rq_lock(p, &flags);
> > +       }
> >  #endif
> 
> That's iffy because p->cpus_allowed isn't stable when we're not holding
> the task's current rq->lock or p->state is not TASK_WAKING.
> 

Oop, yeah missed that. Half hearted attempt to avoid more rq locks.
