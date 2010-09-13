Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab0IMR43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:56:29 -0400
Received: from mail.openrapids.net ([64.15.138.104]:43002 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751771Ab0IMR42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:56:28 -0400
Date: Mon, 13 Sep 2010 13:56:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC PATCH] check_preempt_tick should not compare vruntime
	with wall time
Message-ID: <20100913175626.GB15653@Krystal>
References: <1284231470.2251.52.camel@laptop> <20100911195708.GA9273@Krystal> <1284288072.2251.91.camel@laptop> <20100912203712.GD32327@Krystal> <1284382387.2275.265.camel@laptop> <1284383758.2275.283.camel@laptop> <20100913135621.GA13442@Krystal> <1284387398.2275.311.camel@laptop> <20100913161641.GA28707@Krystal> <20100913173634.GA17815@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913173634.GA17815@elte.hu>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:45:54 up 233 days, 20:22,  5 users,  load average: 0.20, 0.11,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > On Mon, 2010-09-13 at 09:56 -0400, Mathieu Desnoyers wrote:
> > [...]
> > > > >  static void
> > > > >  check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> > > > >  {
> > > > > -     unsigned long ideal_runtime, delta_exec;
> > > > > +     unsigned long slice = sched_slice(cfs_rq, curr);
> > > > 
> > > > So you still compute the sched_slice(), based on sched_period(), based on
> > > > sysctl_sched_min_granularity *= nr_running when there are more than nr_latency
> > > > running threads.
> > > 
> > > What's wrong with that? I keep asking you, you keep not giving an
> > > answer. Stop focussing on nr_latency, its an by produce not a
> > > fundamental entity.
> > > 
> > >  period := max(latency, min_gran * nr_running)
> > > 
> > > See, no nr_latency -- the one and only purpose of nr_latency is avoiding
> > > that multiplication when possible.
> > 
> > OK, the long IRC discussions we just had convinced me that the current 
> > scheme takes things into account by adapting the granularity 
> > dynamically, but also got me to notice that check_preempt seems to 
> > compare vruntime with wall time, which is utterly incorrect. So maybe 
> > all my patch was doing was to expose this bug:
> > 
> > ---
> >  kernel/sched_fair.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6-lttng.git/kernel/sched_fair.c
> > ===================================================================
> > --- linux-2.6-lttng.git.orig/kernel/sched_fair.c
> > +++ linux-2.6-lttng.git/kernel/sched_fair.c
> > @@ -869,7 +869,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq
> >  		struct sched_entity *se = __pick_next_entity(cfs_rq);
> >  		s64 delta = curr->vruntime - se->vruntime;
> >  
> > -		if (delta > ideal_runtime)
> > +		if (delta > calc_delta_fair(ideal_runtime, curr))
> >  			resched_task(rq_of(cfs_rq)->curr);
> >  	}
> >  }
> 
> It should have no effect at all on your latency measurements, as 
> calc_delta_fair() is a NOP for nice-0 tasks:
> 
>  static inline unsigned long
>  calc_delta_fair(unsigned long delta, struct sched_entity *se)
>  {
>          if (unlikely(se->load.weight != NICE_0_LOAD))
>                  delta = calc_delta_mine(delta, NICE_0_LOAD, &se->load);
> 
>          return delta;
>  }

That's right. My latency measurements stay roughly the same (see my email to
Linus). As for Xorg responsiveness, this is not based on some scientifically
proven data (only my impression). My Xorg is running as nice 0 too.

So the effect of this vruntime vs wall time comparison would just be that tasks
with non-zero positive nice level would run for longer slices, and tasks with
negative nice level would run for shorter slices, am I correct ?

Thanks,

Mathieu

> 
> Thanks,
> 
> 	Ingo

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
