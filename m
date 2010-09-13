Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0IMRgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:36:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43653 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab0IMRgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:36:51 -0400
Date: Mon, 13 Sep 2010 19:36:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC PATCH] check_preempt_tick should not compare vruntime with
 wall time
Message-ID: <20100913173634.GA17815@elte.hu>
References: <20100911174003.051303123@efficios.com>
 <1284231470.2251.52.camel@laptop>
 <20100911195708.GA9273@Krystal>
 <1284288072.2251.91.camel@laptop>
 <20100912203712.GD32327@Krystal>
 <1284382387.2275.265.camel@laptop>
 <1284383758.2275.283.camel@laptop>
 <20100913135621.GA13442@Krystal>
 <1284387398.2275.311.camel@laptop>
 <20100913161641.GA28707@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913161641.GA28707@Krystal>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Mon, 2010-09-13 at 09:56 -0400, Mathieu Desnoyers wrote:
> [...]
> > > >  static void
> > > >  check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> > > >  {
> > > > -     unsigned long ideal_runtime, delta_exec;
> > > > +     unsigned long slice = sched_slice(cfs_rq, curr);
> > > 
> > > So you still compute the sched_slice(), based on sched_period(), based on
> > > sysctl_sched_min_granularity *= nr_running when there are more than nr_latency
> > > running threads.
> > 
> > What's wrong with that? I keep asking you, you keep not giving an
> > answer. Stop focussing on nr_latency, its an by produce not a
> > fundamental entity.
> > 
> >  period := max(latency, min_gran * nr_running)
> > 
> > See, no nr_latency -- the one and only purpose of nr_latency is avoiding
> > that multiplication when possible.
> 
> OK, the long IRC discussions we just had convinced me that the current 
> scheme takes things into account by adapting the granularity 
> dynamically, but also got me to notice that check_preempt seems to 
> compare vruntime with wall time, which is utterly incorrect. So maybe 
> all my patch was doing was to expose this bug:
> 
> ---
>  kernel/sched_fair.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng.git/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6-lttng.git.orig/kernel/sched_fair.c
> +++ linux-2.6-lttng.git/kernel/sched_fair.c
> @@ -869,7 +869,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq
>  		struct sched_entity *se = __pick_next_entity(cfs_rq);
>  		s64 delta = curr->vruntime - se->vruntime;
>  
> -		if (delta > ideal_runtime)
> +		if (delta > calc_delta_fair(ideal_runtime, curr))
>  			resched_task(rq_of(cfs_rq)->curr);
>  	}
>  }

It should have no effect at all on your latency measurements, as 
calc_delta_fair() is a NOP for nice-0 tasks:

 static inline unsigned long
 calc_delta_fair(unsigned long delta, struct sched_entity *se)
 {
         if (unlikely(se->load.weight != NICE_0_LOAD))
                 delta = calc_delta_mine(delta, NICE_0_LOAD, &se->load);

         return delta;
 }

Thanks,

	Ingo
