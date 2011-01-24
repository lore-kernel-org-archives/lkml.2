Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1AXSvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:51:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab1AXSvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:51:42 -0500
Subject: Re: [PATCH 16/16] KVM-GST: adjust scheduler cpu power
From: Glauber Costa <glommer@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1295893920.28776.468.camel@laptop>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
	 <1295892397-11354-17-git-send-email-glommer@redhat.com>
	 <1295893920.28776.468.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Mon, 24 Jan 2011 16:51:23 -0200
Message-ID: <1295895083.15920.9.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 19:32 +0100, Peter Zijlstra wrote:
> On Mon, 2011-01-24 at 13:06 -0500, Glauber Costa wrote:
> > This is a first proposal for using steal time information
> > to influence the scheduler. There are a lot of optimizations
> > and fine grained adjustments to be done, but it is working reasonably
> > so far for me (mostly)
> > 
> > With this patch (and some host pinnings to demonstrate the situation),
> > two vcpus with very different steal time (Say 80 % vs 1 %) will not get
> > an even distribution of processes. This is a situation that can naturally
> > arise, specially in overcommited scenarios. Previosly, the guest scheduler
> > would wrongly think that all cpus have the same ability to run processes,
> > lowering the overall throughput.
> > 
> > Signed-off-by: Glauber Costa <glommer@redhat.com>
> > CC: Rik van Riel <riel@redhat.com>
> > CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > CC: Peter Zijlstra <peterz@infradead.org>
> > CC: Avi Kivity <avi@redhat.com>
> > ---
> >  include/linux/sched.h |    1 +
> >  kernel/sched.c        |    4 ++++
> >  kernel/sched_fair.c   |   10 ++++++++++
> >  3 files changed, 15 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index d747f94..beab72d 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -302,6 +302,7 @@ long io_schedule_timeout(long timeout);
> >  extern void cpu_init (void);
> >  extern void trap_init(void);
> >  extern void update_process_times(int user);
> > +extern cputime_t (*hypervisor_steal_time)(void);
> >  extern void scheduler_tick(void);
> >  
> >  extern void sched_show_task(struct task_struct *p);
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 3b3e88d..c460f0d 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -501,6 +501,8 @@ struct rq {
> >  	struct sched_domain *sd;
> >  
> >  	unsigned long cpu_power;
> > +	unsigned long real_ticks;
> > +	unsigned long total_ticks;
> >  
> >  	unsigned char idle_at_tick;
> >  	/* For active balancing */
> > @@ -3533,10 +3535,12 @@ static int touch_steal_time(int is_idle)
> >  	if (is_idle)
> >  		return 0;
> >  
> > +	rq->total_ticks++;
> >  	if (steal) {
> >  		account_steal_time(steal);
> >  		return 1;
> >  	}
> > +	rq->real_ticks++;
> >  	return 0;
> >  }
> 
> yuck!! is ticks really the best you can do?
No, but it is simple enough for a first try. With those variables, we're
not accounting anything, but rather, getting a rough estimate of the %
of steal time compared to the useful (non-idle) time.

> I thought kvm had a ns resolution steal-time clock?
Yes, the one I introduced earlier in this series is nsec. However, user
and system will be accounted in usec at most, so there is no point in
using nsec here.

> 
> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index c62ebae..1364c28 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -2509,6 +2509,16 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
> >  		power >>= SCHED_LOAD_SHIFT;
> >  	}
> >  
> > +	WARN_ON(cpu_rq(cpu)->real_ticks > cpu_rq(cpu)->total_ticks);
> > +
> > +	if (cpu_rq(cpu)->total_ticks) {
> > +		power *= cpu_rq(cpu)->real_ticks;
> > +		power /= cpu_rq(cpu)->total_ticks;
> > +	}
> > +
> > +	cpu_rq(cpu)->total_ticks = 0;
> > +	cpu_rq(cpu)->real_ticks = 0;
> > +
> >  	sdg->cpu_power_orig = power;
> >  
> >  	if (sched_feat(ARCH_POWER))
> 
> I would really much rather see you change update_rq_clock_task() and
> subtract your ns resolution steal time from our wall-time,
> update_rq_clock_task() already updates the cpu_power relative to the
> remaining time available.

But then we get into the problems we already discussed in previous
submissions, which is, we don't really want to alter any notion of
wallclock time. Could you list any more concrete advantages of the
specific way you proposed?

I found that updating cpu power directly is pretty simple, and seems
to work well enough, without disturbing any notion of real time.

