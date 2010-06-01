Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab0FAJFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 05:05:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:60334 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab0FAJFo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 05:05:44 -0400
Subject: Re: [rfc] forked kernel task and mm structures imbalanced on NUMA
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
In-Reply-To: <20100601084157.GS9453@laptop>
References: <20100601073343.GQ9453@laptop>
	 <1275380202.27810.26214.camel@twins>  <20100601084157.GS9453@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 01 Jun 2010 11:05:52 +0200
Message-ID: <1275383152.27810.26387.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 18:41 +1000, Nick Piggin wrote:
> > So I think it would make sense to rework the fork balancing muck to be
> > called only once and stick with its decision.
> 
> Just need to close that race somehow. AFAIKS we can't use TASK_WAKING
> because that must not be preempted?

Right its basically a bit-spinlock and since it interacts with the
rq->lock it needs to have IRQs disabled while we have it set -- which
isn't a problem for the wakeup path, but it would be for the whole fork
path.

> > One thing that would make the whole fork path much easier is fully
> > ripping out that child_runs_first mess for CONFIG_SMP, I think its been
> > disabled by default for long enough, and its always been broken in the
> > face of fork balancing anyway.
> 
> Interesting problem. vfork is nice for fork+exec, but it's a bit
> restrictive.

Right, and all that is a separate issue, its broken now, its still
broken with child_runs_first ripped out.
 
> > So basically we have to move fork balancing back to sched_fork(), I'd
> > have to again look at wth happens to ->cpus_allowed, but I guess it
> > should be fixable, and I don't think we should care overly much about
> > cpu-hotplug.
> 
> No more than simply getting it right. Simply calling into the balancer
> again seems to be the simplest way to do it.

Right.

> > A specific code comment:
> > 
> > > @@ -2550,14 +2561,16 @@ void wake_up_new_task(struct task_struct
> > >          * We set TASK_WAKING so that select_task_rq() can drop rq->lock
> > >          * without people poking at ->cpus_allowed.
> > >          */
> > > -       cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
> > > -       set_task_cpu(p, cpu);
> > > -
> > > -       p->state = TASK_RUNNING;
> > > -       task_rq_unlock(rq, &flags);
> > > +       if (!cpumask_test_cpu(cpu, &p->cpus_allowed)) {
> > > +               p->state = TASK_WAKING;
> > > +               cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
> > > +               set_task_cpu(p, cpu);
> > > +               p->state = TASK_RUNNING;
> > > +               task_rq_unlock(rq, &flags);
> > > +               rq = task_rq_lock(p, &flags);
> > > +       }
> > >  #endif
> > 
> > That's iffy because p->cpus_allowed isn't stable when we're not holding
> > the task's current rq->lock or p->state is not TASK_WAKING.
> > 
> 
> Oop, yeah missed that. Half hearted attempt to avoid more rq locks. 

Yeah, something well worth the effort. At one point I considered making
p->cpus_allowed an RCU managed cpumask, but I never sat down and ran
through all the interesting races that that would bring.
