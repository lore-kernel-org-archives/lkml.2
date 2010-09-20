Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab0ITQCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 12:02:53 -0400
Received: from mail.openrapids.net ([64.15.138.104]:55006 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752275Ab0ITQCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 12:02:52 -0400
Date: Mon, 20 Sep 2010 12:02:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC PATCH] sched: START_NICE feature (temporarily niced
	forks) (v3)
Message-ID: <20100920160249.GB12624@Krystal>
References: <20100914202503.GA1496@Krystal> <1284983026.2275.695.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284983026.2275.695.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:26:30 up 240 days, 18:03,  5 users,  load average: 0.02, 0.04,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2010-09-14 at 16:25 -0400, Mathieu Desnoyers wrote:
> 
> 
> > Index: linux-2.6-lttng.git/include/linux/sched.h
> > ===================================================================
> > --- linux-2.6-lttng.git.orig/include/linux/sched.h
> > +++ linux-2.6-lttng.git/include/linux/sched.h
> > @@ -1132,6 +1132,8 @@ struct sched_entity {
> >  	u64			prev_sum_exec_runtime;
> >  
> >  	u64			nr_migrations;
> > +	u64			fork_nice_timeout;
> > +	unsigned int		fork_nice_penality;
> >  
> >  #ifdef CONFIG_SCHEDSTATS
> >  	struct sched_statistics statistics;
> > Index: linux-2.6-lttng.git/kernel/sched.c
> > ===================================================================
> > --- linux-2.6-lttng.git.orig/kernel/sched.c
> > +++ linux-2.6-lttng.git/kernel/sched.c
> > @@ -2421,6 +2421,8 @@ static void __sched_fork(struct task_str
> >  	p->se.sum_exec_runtime		= 0;
> >  	p->se.prev_sum_exec_runtime	= 0;
> >  	p->se.nr_migrations		= 0;
> > +	p->se.fork_nice_timeout		= 0;
> > +	p->se.fork_nice_penality	= 0;
> >  
> >  #ifdef CONFIG_SCHEDSTATS
> >  	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
> > Index: linux-2.6-lttng.git/kernel/sched_fair.c
> > ===================================================================
> > --- linux-2.6-lttng.git.orig/kernel/sched_fair.c
> > +++ linux-2.6-lttng.git/kernel/sched_fair.c
> > @@ -433,6 +433,14 @@ calc_delta_fair(unsigned long delta, str
> >  	if (unlikely(se->load.weight != NICE_0_LOAD))
> >  		delta = calc_delta_mine(delta, NICE_0_LOAD, &se->load);
> >  
> > +	if (se->fork_nice_penality) {
> > +		delta <<= se->fork_nice_penality;
> > +		if ((s64)(se->sum_exec_runtime - se->fork_nice_timeout) > 0) {
> > +			se->fork_nice_penality = 0;
> > +			se->fork_nice_timeout = 0;
> > +		}
> > +	}
> > +
> >  	return delta;
> >  }
> 
> Something like this ought to live at every place where you use se->load,
> including sched_slice(), possibly wakeup_gran(), although that's more
> heuristic, so you could possibly leave it out there.

Agreed for wakeup_gran(). I'll just remove the duplicate "if
(unlikely(se->load.weight != NICE_0_LOAD))" check.

For sched_slice(), I don't know. sched_vslice() is used to take nice level into
account when placing new tasks. sched_slice() takes only the weight into
account, not the nice level. So given that I want to mimic the nice level
impact, I'm not sure we have to take this into account at the sched_slice level.

Also, I wonder if leaving it out of account_entity_enqueue/dequeue() calls to
add_cfs_task_weight() and inc/dec_cpu_load is OK ? Because it can be a pain to
reequilibrate the cpu and task weights when the timeout occurs.  The temporary
effect of this nice-on-fork is to make the tasks a little lighter, so the weight
is not accurate. But I wonder if we really care that much about it.

> 
> > @@ -832,6 +840,11 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
> >  	 */
> >  	if (!(flags & DEQUEUE_SLEEP))
> >  		se->vruntime -= cfs_rq->min_vruntime;
> > +
> > +	if (se->fork_nice_penality) {
> > +		se->fork_nice_penality = 0;
> > +		se->fork_nice_timeout = 0;
> > +	}
> >  }
> >  
> >  /*
> 
> So you want to reset this penalty on each de-schedule, not only sleep
> (but also preemptions)?

only sleeps. So I should put this within a 

if (flags & DEQUEUE_SLEEP) {
  ...
}

I suppose ?

> 
> > @@ -3544,8 +3557,27 @@ static void task_fork_fair(struct task_s
> >  
> >  	update_curr(cfs_rq);
> >  
> > -	if (curr)
> > +	if (curr) {
> >  		se->vruntime = curr->vruntime;
> > +		if (sched_feat(START_NICE)) {
> > +			if (curr->fork_nice_penality &&
> > +			    (s64)(curr->sum_exec_runtime
> > +				  - curr->fork_nice_timeout) > 0) {
> > +				curr->fork_nice_penality = 0;
> > +				curr->fork_nice_timeout = 0;
> > +			}
> > +
> > +			if (!curr->fork_nice_timeout)
> > +				curr->fork_nice_timeout =
> > +					curr->sum_exec_runtime;
> > +			curr->fork_nice_timeout += sched_slice(cfs_rq, curr);
> > +			curr->fork_nice_penality = min_t(unsigned int,
> > +							 curr->fork_nice_penality + 1, 8);
> > +			se->fork_nice_timeout = curr->fork_nice_timeout
> > +						- curr->sum_exec_runtime;
> > +			se->fork_nice_penality = curr->fork_nice_penality;
> > +		}
> > +	}
> >  	place_entity(cfs_rq, se, 1);
> >  
> >  	if (sysctl_sched_child_runs_first && curr && entity_before(curr, se)) {
> 
> If you stick than in a separate function you can loose 2 indent levels,
> which would help with readability.

Excellent point, will do! That will let me add more comments into the function
too.

Thanks a lot!

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
