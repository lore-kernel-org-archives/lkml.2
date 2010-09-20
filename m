Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab0ITQPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 12:15:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:60224 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839Ab0ITQPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 12:15:34 -0400
Subject: Re: [RFC PATCH] sched: START_NICE feature (temporarily niced
 forks) (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <20100920160249.GB12624@Krystal>
References: <20100914202503.GA1496@Krystal>
	 <1284983026.2275.695.camel@laptop>  <20100920160249.GB12624@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Sep 2010 18:15:19 +0200
Message-ID: <1284999319.2275.748.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 12:02 -0400, Mathieu Desnoyers wrote:
> > > Index: linux-2.6-lttng.git/kernel/sched_fair.c
> > > ===================================================================
> > > --- linux-2.6-lttng.git.orig/kernel/sched_fair.c
> > > +++ linux-2.6-lttng.git/kernel/sched_fair.c
> > > @@ -433,6 +433,14 @@ calc_delta_fair(unsigned long delta, str
> > >     if (unlikely(se->load.weight != NICE_0_LOAD))
> > >             delta = calc_delta_mine(delta, NICE_0_LOAD, &se->load);
> > >  
> > > +   if (se->fork_nice_penality) {
> > > +           delta <<= se->fork_nice_penality;
> > > +           if ((s64)(se->sum_exec_runtime - se->fork_nice_timeout) > 0) {
> > > +                   se->fork_nice_penality = 0;
> > > +                   se->fork_nice_timeout = 0;
> > > +           }
> > > +   }
> > > +
> > >     return delta;
> > >  }
> > 
> > Something like this ought to live at every place where you use se->load,
> > including sched_slice(), possibly wakeup_gran(), although that's more
> > heuristic, so you could possibly leave it out there.
> 
> Agreed for wakeup_gran(). I'll just remove the duplicate "if
> (unlikely(se->load.weight != NICE_0_LOAD))" check.
> 
> For sched_slice(), I don't know. sched_vslice() is used to take nice level into
> account when placing new tasks. sched_slice() takes only the weight into
> account, not the nice level. 

nice-level == weight

> So given that I want to mimic the nice level
> impact, I'm not sure we have to take this into account at the sched_slice level.

If you renice, we change the weight, hence you need to propagate this
penalty to every place we use the weight.

> Also, I wonder if leaving it out of account_entity_enqueue/dequeue() calls to
> add_cfs_task_weight() and inc/dec_cpu_load is OK ? Because it can be a pain to
> reequilibrate the cpu and task weights when the timeout occurs.  The temporary
> effect of this nice-on-fork is to make the tasks a little lighter, so the weight
> is not accurate. But I wonder if we really care that much about it.

Yeah, propagating the accumulated weight effect is a bit of a bother
like you noticed.

We can simply try, by lowering the effective weight and not propagating
this to the accumulated weight, the effect is even stronger. Suppose you
have 2 tasks of weight 1, then fork so that two tasks get half weight. 

Then if you propagate the accumulated weight it would look like:
1:.5:.5 with a total weight of 2, so that each of these light tasks get
1/4th the time. If, however you do not propagate, you get something
like: 1:.5:.5 on 3, so that each of these light tasks gets 1/6th of the
total time.
 
Its a bit of a trade-off, not propagating, simpler, less code, slightly
wrong numbers, against propagating, more complex/expensive but slightly
better numbers.

If you care you can implement both and measure it, but I'm not too
bothered -- we can always fix it if it turns out to have definite
down-sides.

> > > @@ -832,6 +840,11 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
> > >      */
> > >     if (!(flags & DEQUEUE_SLEEP))
> > >             se->vruntime -= cfs_rq->min_vruntime;
> > > +
> > > +   if (se->fork_nice_penality) {
> > > +           se->fork_nice_penality = 0;
> > > +           se->fork_nice_timeout = 0;
> > > +   }
> > >  }
> > >  
> > >  /*
> > 
> > So you want to reset this penalty on each de-schedule, not only sleep
> > (but also preemptions)?
> 
> only sleeps. So I should put this within a 
> 
> if (flags & DEQUEUE_SLEEP) {
>   ...
> }
> 
> I suppose ? 

Yep.
