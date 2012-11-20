Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab2KTO3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:29:00 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45792 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab2KTO25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:28:57 -0500
Date: Tue, 20 Nov 2012 14:28:54 +0000
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pjt@google.com" <pjt@google.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [RFC 3/6] sched: pack small tasks
Message-ID: <20121120142854.GB4619@e103034-lin>
References: <1349595838-31274-1-git-send-email-vincent.guittot@linaro.org>
 <1349595838-31274-4-git-send-email-vincent.guittot@linaro.org>
 <20121109171344.GB16082@e103034-lin>
 <CAKfTPtBf3b2DdLHGHaJP0_mZO2mgH6dH3bcZR=ppputyMAGLqQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAKfTPtBf3b2DdLHGHaJP0_mZO2mgH6dH3bcZR=ppputyMAGLqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 20 Nov 2012 14:28:54.0351 (UTC) FILETIME=[5E5125F0:01CDC72B]
X-MC-Unique: 112112014285427601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On Mon, Nov 12, 2012 at 01:51:00PM +0000, Vincent Guittot wrote:
> On 9 November 2012 18:13, Morten Rasmussen <Morten.Rasmussen@arm.com> wrote:
> > Hi Vincent,
> >
> > I have experienced suboptimal buddy selection on a dual cluster setup
> > (ARM TC2) if SD_SHARE_POWERLINE is enabled at MC level and disabled at
> > CPU level. This seems to be the correct flag settings for a system with
> > only cluster level power gating.
> >
> > To me it looks like update_packing_domain() is not doing the right
> > thing. See inline comments below.
> 
> Hi Morten,
> 
> Thanks for testing the patches.
> 
> It seems that I have too optimized the loop and remove some use cases.
> 
> >
> > On Sun, Oct 07, 2012 at 08:43:55AM +0100, Vincent Guittot wrote:
> >> During sched_domain creation, we define a pack buddy CPU if available.
> >>
> >> On a system that share the powerline at all level, the buddy is set to -1
> >>
> >> On a dual clusters / dual cores system which can powergate each core and
> >> cluster independantly, the buddy configuration will be :
> >>       | CPU0 | CPU1 | CPU2 | CPU3 |
> >> -----------------------------------
> >> buddy | CPU0 | CPU0 | CPU0 | CPU2 |
> >>
> >> Small tasks tend to slip out of the periodic load balance.
> >> The best place to choose to migrate them is at their wake up.
> >>
> >> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> >> ---
> >>  kernel/sched/core.c  |    1 +
> >>  kernel/sched/fair.c  |  109 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >>  kernel/sched/sched.h |    1 +
> >>  3 files changed, 111 insertions(+)
> >>
> >> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> >> index dab7908..70cadbe 100644
> >> --- a/kernel/sched/core.c
> >> +++ b/kernel/sched/core.c
> >> @@ -6131,6 +6131,7 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
> >>       rcu_assign_pointer(rq->sd, sd);
> >>       destroy_sched_domains(tmp, cpu);
> >>
> >> +     update_packing_domain(cpu);
> >>       update_top_cache_domain(cpu);
> >>  }
> >>
> >> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> >> index 4f4a4f6..8c9d3ed 100644
> >> --- a/kernel/sched/fair.c
> >> +++ b/kernel/sched/fair.c
> >> @@ -157,6 +157,63 @@ void sched_init_granularity(void)
> >>       update_sysctl();
> >>  }
> >>
> >> +
> >> +/*
> >> + * Save the id of the optimal CPU that should be used to pack small tasks
> >> + * The value -1 is used when no buddy has been found
> >> + */
> >> +DEFINE_PER_CPU(int, sd_pack_buddy);
> >> +
> >> +/* Look for the best buddy CPU that can be used to pack small tasks
> >> + * We make the assumption that it doesn't wort to pack on CPU that share the
> >> + * same powerline. We looks for the 1st sched_domain without the
> >> + * SD_SHARE_POWERLINE flag. Then We look for the sched_group witht the lowest
> >> + * power per core based on the assumption that their power efficiency is
> >> + * better */
> >> +void update_packing_domain(int cpu)
> >> +{
> >> +     struct sched_domain *sd;
> >> +     int id = -1;
> >> +
> >> +     sd = highest_flag_domain(cpu, SD_SHARE_POWERLINE);
> >> +     if (!sd)
> >> +             sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
> >> +     else
> >> +             sd = sd->parent;
> > sd is the highest level where SD_SHARE_POWERLINE is enabled so the sched
> > groups of the parent level would represent the power domains. If get it
> > right, we want to pack inside the cluster first and only let first cpu
> 
> You probably wanted to use sched_group instead of cluster because
> cluster is only a special use case, didn't you ?
> 
> > of the cluster do packing on another cluster. So all cpus - except the
> > first one - in the current sched domain should find its buddy within the
> > domain and only the first one should go to the parent sched domain to
> > find its buddy.
> 
> We don't want to pack in the current sched_domain because it shares
> power domain. We want to pack at the parent level
> 

Yes. I think we mean the same thing. The packing takes place at the
parent sched_domain but the sched_group that we are looking at only
contains the cpus of the level below.

> >
> > I propose the following fix:
> >
> > -               sd = sd->parent;
> > +               if (cpumask_first(sched_domain_span(sd)) == cpu
> > +                       || !sd->parent)
> > +                       sd = sd->parent;
> 
> We always look for the buddy in the parent level whatever the cpu
> position in the mask is.
> 
> >
> >
> >> +
> >> +     while (sd) {
> >> +             struct sched_group *sg = sd->groups;
> >> +             struct sched_group *pack = sg;
> >> +             struct sched_group *tmp = sg->next;
> >> +
> >> +             /* 1st CPU of the sched domain is a good candidate */
> >> +             if (id == -1)
> >> +                     id = cpumask_first(sched_domain_span(sd));
> >
> > There is no guarantee that id is in the sched group pointed to by
> > sd->groups, which is implicitly assumed later in the search loop. We
> > need to find the sched group that contains id and point sg to that
> > instead. I haven't found an elegant way to find that group, but the fix
> > below should at least give the right result.
> >
> > +               /* Find sched group of candidate */
> > +               tmp = sd->groups;
> > +               do {
> > +                       if (cpumask_test_cpu(id, sched_group_cpus(tmp)))
> > +                       {
> > +                               sg = tmp;
> > +                               break;
> > +                       }
> > +               } while (tmp = tmp->next, tmp != sd->groups);
> > +
> > +               pack = sg;
> > +               tmp = sg->next;
> 
> 
> I have a new loop which solves your issue and others. I will use it
> for the next version
> 
> +	while (sd) {
> +		struct sched_group *sg = sd->groups;
> +		struct sched_group *pack = sg;
> +		struct sched_group *tmp;
> +
> +		/* The 1st CPU of the local group is a good candidate */
> +		id = cpumask_first(sched_group_cpus(pack));

You make the assumption that the first sched_group in the list always contains
the current cpu. I think that is always the case, but I haven't verified
it. Maybe a comment about this would help people to understand the code
easier.

> +
> +		/* loop the sched groups to find the best one */
> +		for (tmp = sg->next; tmp != sg; tmp = tmp->next) {
> +			if (tmp->sgp->power * pack->group_weight >
> +					pack->sgp->power * tmp->group_weight)
> +				continue;
> +
> +			if ((tmp->sgp->power * pack->group_weight ==
> +					pack->sgp->power * tmp->group_weight)
> +			 && (cpumask_first(sched_group_cpus(tmp)) >= id))
> +				continue;
> +
> +			/* we have found a better group */
> +			pack = tmp;
> +
> +			/* Take the 1st CPU of the new group */
> +			id = cpumask_first(sched_group_cpus(pack));
> +		}
> +

Works great on my setup.

> +		/* Look for another CPU than itself */
> +		if ((id != cpu)
> +		 || ((sd->parent) && !(sd->parent->flags && SD_LOAD_BALANCE)))
> +			break;

If I understand correctly the last part of this check should avoid
selecting a buddy in a sched_group that is not load balanced with the
current one. In that case, I think that this check (or a similar check)
should be done before the loop as well. As it is, the first iteration of
the loop will always search all the groups of the first domain where
SD_SHARE_POWERLINE is disabled regardless of the state of
SD_LOAD_BALANCE flag. So if they are both disabled at the same level
packing will happen across groups that are not supposed to be
load-balanced.

Regards,
Morten

> +
> +		sd = sd->parent;
> +	}
> 
> Regards,
> Vincent
> 
> >
> > Regards,
> > Morten
> >
> >> +
> >> +             /* loop the sched groups to find the best one */
> >> +             while (tmp != sg) {
> >> +                     if (tmp->sgp->power * sg->group_weight <
> >> +                                     sg->sgp->power * tmp->group_weight)
> >> +                             pack = tmp;
> >> +                     tmp = tmp->next;
> >> +             }
> >> +
> >> +             /* we have found a better group */
> >> +             if (pack != sg)
> >> +                     id = cpumask_first(sched_group_cpus(pack));
> >> +
> >> +             /* Look for another CPU than itself */
> >> +             if ((id != cpu)
> >> +              || ((sd->parent) && !(sd->parent->flags && SD_LOAD_BALANCE)))
> >> +                     break;
> >> +
> >> +             sd = sd->parent;
> >> +     }
> >> +
> >> +     pr_info(KERN_INFO "CPU%d packing on CPU%d\n", cpu, id);
> >> +     per_cpu(sd_pack_buddy, cpu) = id;
> >> +}
> >> +
> >>  #if BITS_PER_LONG == 32
> >>  # define WMULT_CONST (~0UL)
> >>  #else
> >> @@ -3073,6 +3130,55 @@ static int select_idle_sibling(struct task_struct *p, int target)
> >>       return target;
> >>  }
> >>
> >> +static inline bool is_buddy_busy(int cpu)
> >> +{
> >> +     struct rq *rq = cpu_rq(cpu);
> >> +
> >> +     /*
> >> +      * A busy buddy is a CPU with a high load or a small load with a lot of
> >> +      * running tasks.
> >> +      */
> >> +     return ((rq->avg.usage_avg_sum << rq->nr_running) >
> >> +                     rq->avg.runnable_avg_period);
> >> +}
> >> +
> >> +static inline bool is_light_task(struct task_struct *p)
> >> +{
> >> +     /* A light task runs less than 25% in average */
> >> +     return ((p->se.avg.usage_avg_sum << 2) < p->se.avg.runnable_avg_period);
> >> +}
> >> +
> >> +static int check_pack_buddy(int cpu, struct task_struct *p)
> >> +{
> >> +     int buddy = per_cpu(sd_pack_buddy, cpu);
> >> +
> >> +     /* No pack buddy for this CPU */
> >> +     if (buddy == -1)
> >> +             return false;
> >> +
> >> +     /*
> >> +      * If a task is waiting for running on the CPU which is its own buddy,
> >> +      * let the default behavior to look for a better CPU if available
> >> +      * The threshold has been set to 37.5%
> >> +      */
> >> +     if ((buddy == cpu)
> >> +      && ((p->se.avg.usage_avg_sum << 3) < (p->se.avg.runnable_avg_sum * 5)))
> >> +             return false;
> >> +
> >> +     /* buddy is not an allowed CPU */
> >> +     if (!cpumask_test_cpu(buddy, tsk_cpus_allowed(p)))
> >> +             return false;
> >> +
> >> +     /*
> >> +      * If the task is a small one and the buddy is not overloaded,
> >> +      * we use buddy cpu
> >> +      */
> >> +      if (!is_light_task(p) || is_buddy_busy(buddy))
> >> +             return false;
> >> +
> >> +     return true;
> >> +}
> >> +
> >>  /*
> >>   * sched_balance_self: balance the current task (running on cpu) in domains
> >>   * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
> >> @@ -3098,6 +3204,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
> >>       if (p->nr_cpus_allowed == 1)
> >>               return prev_cpu;
> >>
> >> +     if (check_pack_buddy(cpu, p))
> >> +             return per_cpu(sd_pack_buddy, cpu);
> >> +
> >>       if (sd_flag & SD_BALANCE_WAKE) {
> >>               if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
> >>                       want_affine = 1;
> >> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> >> index a95d5c1..086d8bf 100644
> >> --- a/kernel/sched/sched.h
> >> +++ b/kernel/sched/sched.h
> >> @@ -875,6 +875,7 @@ static inline void idle_balance(int cpu, struct rq *rq)
> >>
> >>  extern void sysrq_sched_debug_show(void);
> >>  extern void sched_init_granularity(void);
> >> +extern void update_packing_domain(int cpu);
> >>  extern void update_max_interval(void);
> >>  extern void update_group_power(struct sched_domain *sd, int cpu);
> >>  extern int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu);
> >> --
> >> 1.7.9.5
> >>
> >>
> >> _______________________________________________
> >> linaro-dev mailing list
> >> linaro-dev@lists.linaro.org
> >> http://lists.linaro.org/mailman/listinfo/linaro-dev
> >>
> >
> 

