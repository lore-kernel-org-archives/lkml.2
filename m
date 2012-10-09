Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2JIP4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:56:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35802 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2JIP4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:56:19 -0400
Date: Tue, 9 Oct 2012 16:56:13 +0100
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "pjt@google.com" <pjt@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "linaro-sched-sig@lists.linaro.org" 
	<linaro-sched-sig@lists.linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Robin Randhawa <Robin.Randhawa@arm.com>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>
Subject: Re: [RFC PATCH 02/10] sched: Task placement for heterogeneous
 systems based on task load-tracking
Message-ID: <20121009155613.GA3729@e103034-lin>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
 <1348252345-5642-3-git-send-email-morten.rasmussen@arm.com>
 <CAKohponOWLNSUOtqC_TMfat-yQH=tGC_kg3yNTTQwOoRGH+U5g@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAKohponOWLNSUOtqC_TMfat-yQH=tGC_kg3yNTTQwOoRGH+U5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 09 Oct 2012 15:56:16.0856 (UTC) FILETIME=[9DBE6D80:01CDA636]
X-MC-Unique: 112100916561705901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Thu, Oct 04, 2012 at 07:02:03AM +0100, Viresh Kumar wrote:
> Hi Morten,
> 
> On 22 September 2012 00:02,  <morten.rasmussen@arm.com> wrote:
> > From: Morten Rasmussen <morten.rasmussen@arm.com>
> >
> > This patch introduces the basic SCHED_HMP infrastructure. Each class of
> > cpus is represented by a hmp_domain and tasks will only be moved between
> > these domains when their load profiles suggest it is beneficial.
> >
> > SCHED_HMP relies heavily on the task load-tracking introduced in Paul
> > Turners fair group scheduling patch set:
> >
> > <https://lkml.org/lkml/2012/8/23/267>
> >
> > SCHED_HMP requires that the platform implements arch_get_hmp_domains()
> > which should set up the platform specific list of hmp_domains. It is
> > also assumed that the platform disables SD_LOAD_BALANCE for the
> > appropriate sched_domains.
> 
> An explanation of this requirement would be helpful here.
> 

Yes. This is to prevent the load-balancer from moving tasks between
hmp_domains. This will be done exclusively by SCHED_HMP instead to
implement a strict task migration policy and avoid changing the
load-balancer behaviour. The load-balancer will take care of
load-balacing within each hmp_domain.

> > Tasks placement takes place every time a task is to be inserted into
> > a runqueue based on its load history. The task placement decision is
> > based on load thresholds.
> >
> > There are no restrictions on the number of hmp_domains, however,
> > multiple (>2) has not been tested and the up/down migration policy is
> > rather simple.
> >
> > Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> > ---
> >  arch/arm/Kconfig      |   17 +++++
> >  include/linux/sched.h |    6 ++
> >  kernel/sched/fair.c   |  168 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  kernel/sched/sched.h  |    6 ++
> >  4 files changed, 197 insertions(+)
> >
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index f4a5d58..5b09684 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -1554,6 +1554,23 @@ config SCHED_SMT
> >           MultiThreading at a cost of slightly increased overhead in some
> >           places. If unsure say N here.
> >
> > +config DISABLE_CPU_SCHED_DOMAIN_BALANCE
> > +       bool "(EXPERIMENTAL) Disable CPU level scheduler load-balancing"
> > +       help
> > +         Disables scheduler load-balancing at CPU sched domain level.
> 
> Shouldn't this depend on EXPERIMENTAL?
> 

It should. The ongoing discussion about CONFIG_EXPERIMENTAL that Amit is
referring to hasn't come to a conclusion yet.

> > +config SCHED_HMP
> > +       bool "(EXPERIMENTAL) Heterogenous multiprocessor scheduling"
> 
> ditto.
> 
> > +       depends on DISABLE_CPU_SCHED_DOMAIN_BALANCE && SCHED_MC && FAIR_GROUP_SCHED && !SCHED_AUTOGROUP
> > +       help
> > +         Experimental scheduler optimizations for heterogeneous platforms.
> > +         Attempts to introspectively select task affinity to optimize power
> > +         and performance. Basic support for multiple (>2) cpu types is in place,
> > +         but it has only been tested with two types of cpus.
> > +         There is currently no support for migration of task groups, hence
> > +         !SCHED_AUTOGROUP. Furthermore, normal load-balancing must be disabled
> > +         between cpus of different type (DISABLE_CPU_SCHED_DOMAIN_BALANCE).
> > +
> >  config HAVE_ARM_SCU
> >         bool
> >         help
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 81e4e82..df971a3 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1039,6 +1039,12 @@ unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
> >
> >  bool cpus_share_cache(int this_cpu, int that_cpu);
> >
> > +#ifdef CONFIG_SCHED_HMP
> > +struct hmp_domain {
> > +       struct cpumask cpus;
> > +       struct list_head hmp_domains;
> 
> Probably need a better name here. domain_list?
> 

Yes. hmp_domain_list would be better and stick with the hmp_* naming
convention.

> > +};
> > +#endif /* CONFIG_SCHED_HMP */
> >  #else /* CONFIG_SMP */
> >
> >  struct sched_domain_attr;
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 3e17dd5..d80de46 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -3077,6 +3077,125 @@ static int select_idle_sibling(struct task_struct *p, int target)
> >         return target;
> >  }
> >
> > +#ifdef CONFIG_SCHED_HMP
> > +/*
> > + * Heterogenous multiprocessor (HMP) optimizations
> > + *
> > + * The cpu types are distinguished using a list of hmp_domains
> > + * which each represent one cpu type using a cpumask.
> > + * The list is assumed ordered by compute capacity with the
> > + * fastest domain first.
> > + */
> > +DEFINE_PER_CPU(struct hmp_domain *, hmp_cpu_domain);
> > +
> > +extern void __init arch_get_hmp_domains(struct list_head *hmp_domains_list);
> > +
> > +/* Setup hmp_domains */
> > +static int __init hmp_cpu_mask_setup(void)
> 
> How should we interpret its return value? Can you mention what does 0 & 1 mean
> here?
> 

Returns 0 if domain setup failed, i.e. the domain list is empty, and 1
otherwise.

> > +{
> > +       char buf[64];
> > +       struct hmp_domain *domain;
> > +       struct list_head *pos;
> > +       int dc, cpu;
> > +
> > +       pr_debug("Initializing HMP scheduler:\n");
> > +
> > +       /* Initialize hmp_domains using platform code */
> > +       arch_get_hmp_domains(&hmp_domains);
> > +       if (list_empty(&hmp_domains)) {
> > +               pr_debug("HMP domain list is empty!\n");
> > +               return 0;
> > +       }
> > +
> > +       /* Print hmp_domains */
> > +       dc = 0;
> 
> Should be done during definition of dc.
> 
> > +       list_for_each(pos, &hmp_domains) {
> > +               domain = list_entry(pos, struct hmp_domain, hmp_domains);
> > +               cpulist_scnprintf(buf, 64, &domain->cpus);
> > +               pr_debug("  HMP domain %d: %s\n", dc, buf);
> 
> Spaces before HMP are intentional?
> 

Yes. It makes the boot log easier to read when the hmp_domain listing is
indented.

> > +
> > +               for_each_cpu_mask(cpu, domain->cpus) {
> > +                       per_cpu(hmp_cpu_domain, cpu) = domain;
> > +               }
> 
> Should use hmp_cpu_domain(cpu) here. Also no need of {} for single
> line loop.
> 
> > +               dc++;
> 
> You aren't using it... Only for testing? Should we remove it from mainline
> patchset and keep it locally?
> 

I'm using it in the pr_debug line a little earlier. It is used for
enumerating the hmp_domains.

> > +       }
> > +
> > +       return 1;
> > +}
> > +
> > +/*
> > + * Migration thresholds should be in the range [0..1023]
> > + * hmp_up_threshold: min. load required for migrating tasks to a faster cpu
> > + * hmp_down_threshold: max. load allowed for tasks migrating to a slower cpu
> > + * The default values (512, 256) offer good responsiveness, but may need
> > + * tweaking suit particular needs.
> > + */
> > +unsigned int hmp_up_threshold = 512;
> > +unsigned int hmp_down_threshold = 256;
> 
> For default values, it is fine. But still we should get user preferred
> values via DT
> or CONFIG_*.
> 

Yes, but for now getting the scheduler to do the right thing has higher
priority than proper integration with DT.

> > +static unsigned int hmp_up_migration(int cpu, struct sched_entity *se);
> > +static unsigned int hmp_down_migration(int cpu, struct sched_entity *se);
> > +
> > +/* Check if cpu is in fastest hmp_domain */
> > +static inline unsigned int hmp_cpu_is_fastest(int cpu)
> > +{
> > +       struct list_head *pos;
> > +
> > +       pos = &hmp_cpu_domain(cpu)->hmp_domains;
> > +       return pos == hmp_domains.next;
> 
> better create list_is_first() for this.
> 

I had the same thought, but I see that as a separate patch that should
be submitted separately.

> > +}
> > +
> > +/* Check if cpu is in slowest hmp_domain */
> > +static inline unsigned int hmp_cpu_is_slowest(int cpu)
> > +{
> > +       struct list_head *pos;
> > +
> > +       pos = &hmp_cpu_domain(cpu)->hmp_domains;
> > +       return list_is_last(pos, &hmp_domains);
> > +}
> > +
> > +/* Next (slower) hmp_domain relative to cpu */
> > +static inline struct hmp_domain *hmp_slower_domain(int cpu)
> > +{
> > +       struct list_head *pos;
> > +
> > +       pos = &hmp_cpu_domain(cpu)->hmp_domains;
> > +       return list_entry(pos->next, struct hmp_domain, hmp_domains);
> > +}
> > +
> > +/* Previous (faster) hmp_domain relative to cpu */
> > +static inline struct hmp_domain *hmp_faster_domain(int cpu)
> > +{
> > +       struct list_head *pos;
> > +
> > +       pos = &hmp_cpu_domain(cpu)->hmp_domains;
> > +       return list_entry(pos->prev, struct hmp_domain, hmp_domains);
> > +}
> 
> For all four routines, first two lines of body can be merged. If u wish :)
> 

I have kept these helper functions fairly generic on purpose. It might
be necessary for multi-domain platforms (>2) to modify these functions
to implement better multi-domain task migration policies. I don't know
any such platform, so for know these functions are very simple.

> > +
> > +/*
> > + * Selects a cpu in previous (faster) hmp_domain
> > + * Note that cpumask_any_and() returns the first cpu in the cpumask
> > + */
> > +static inline unsigned int hmp_select_faster_cpu(struct task_struct *tsk,
> > +                                                       int cpu)
> > +{
> > +       return cpumask_any_and(&hmp_faster_domain(cpu)->cpus,
> > +                               tsk_cpus_allowed(tsk));
> > +}
> > +
> > +/*
> > + * Selects a cpu in next (slower) hmp_domain
> > + * Note that cpumask_any_and() returns the first cpu in the cpumask
> > + */
> > +static inline unsigned int hmp_select_slower_cpu(struct task_struct *tsk,
> > +                                                       int cpu)
> > +{
> > +       return cpumask_any_and(&hmp_slower_domain(cpu)->cpus,
> > +                               tsk_cpus_allowed(tsk));
> > +}
> > +
> > +#endif /* CONFIG_SCHED_HMP */
> > +
> >  /*
> >   * sched_balance_self: balance the current task (running on cpu) in domains
> >   * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
> > @@ -3203,6 +3322,16 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
> >  unlock:
> >         rcu_read_unlock();
> >
> > +#ifdef CONFIG_SCHED_HMP
> > +       if (hmp_up_migration(prev_cpu, &p->se))
> > +               return hmp_select_faster_cpu(p, prev_cpu);
> > +       if (hmp_down_migration(prev_cpu, &p->se))
> > +               return hmp_select_slower_cpu(p, prev_cpu);
> > +       /* Make sure that the task stays in its previous hmp domain */
> > +       if (!cpumask_test_cpu(new_cpu, &hmp_cpu_domain(prev_cpu)->cpus))
> 
> Why is this tested?
> 

I don't think it is needed. It is there as an extra guarantee that
select_task_rq_fair() doesn't pick a cpu outside the task's current
hmp_domain in cases where there is no up or down migration. Disabling
SD_LOAD_BALANCE for the appropriate domains should give that guarantee.
I just haven't completely convinced myself yet.

> > +               return prev_cpu;
> > +#endif
> > +
> >         return new_cpu;
> >  }
> >
> > @@ -5354,6 +5483,41 @@ need_kick:
> >  static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }
> >  #endif
> >
> > +#ifdef CONFIG_SCHED_HMP
> > +/* Check if task should migrate to a faster cpu */
> > +static unsigned int hmp_up_migration(int cpu, struct sched_entity *se)
> > +{
> > +       struct task_struct *p = task_of(se);
> > +
> > +       if (hmp_cpu_is_fastest(cpu))
> > +               return 0;
> > +
> > +       if (cpumask_intersects(&hmp_faster_domain(cpu)->cpus,
> > +                                       tsk_cpus_allowed(p))
> > +               && se->avg.load_avg_ratio > hmp_up_threshold) {
> > +               return 1;
> > +       }
> 
> I know all these comparisons are not very costly, still i would prefer
> 
> se->avg.load_avg_ratio > hmp_up_threshold
> 
> as the first comparison in this routine.
> 
> We should check first, if the task needs migration or not. Rather than
> checking if it can migrate to other cpus or not.
> 

Agree.

> > +       return 0;
> > +}
> > +
> > +/* Check if task should migrate to a slower cpu */
> > +static unsigned int hmp_down_migration(int cpu, struct sched_entity *se)
> > +{
> > +       struct task_struct *p = task_of(se);
> > +
> > +       if (hmp_cpu_is_slowest(cpu))
> > +               return 0;
> > +
> > +       if (cpumask_intersects(&hmp_slower_domain(cpu)->cpus,
> > +                                       tsk_cpus_allowed(p))
> > +               && se->avg.load_avg_ratio < hmp_down_threshold) {
> > +               return 1;
> > +       }
> 
> same here.
> 

Agree.

> > +       return 0;
> > +}
> > +
> > +#endif /* CONFIG_SCHED_HMP */
> > +
> >  /*
> >   * run_rebalance_domains is triggered when needed from the scheduler tick.
> >   * Also triggered for nohz idle balancing (with nohz_balancing_kick set).
> > @@ -5861,6 +6025,10 @@ __init void init_sched_fair_class(void)
> >         zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
> >         cpu_notifier(sched_ilb_notifier, 0);
> >  #endif
> > +
> > +#ifdef CONFIG_SCHED_HMP
> > +       hmp_cpu_mask_setup();
> 
> Should we check the return value? If not required then should we
> make fn() declaration return void?
> 

It can be changed to void if we don't add any error handling anyway.

> > +#endif
> >  #endif /* SMP */
> >
> >  }
> > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> > index 81135f9..4990d9e 100644
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -547,6 +547,12 @@ DECLARE_PER_CPU(int, sd_llc_id);
> >
> >  extern int group_balance_cpu(struct sched_group *sg);
> >
> > +#ifdef CONFIG_SCHED_HMP
> > +static LIST_HEAD(hmp_domains);
> > +DECLARE_PER_CPU(struct hmp_domain *, hmp_cpu_domain);
> > +#define hmp_cpu_domain(cpu)    (per_cpu(hmp_cpu_domain, (cpu)))
> 
> can drop "()" around per_cpu().
> 
> Both, per_cpu variable and macro to get it, have the same name. Can
> we try giving them better names. Or atleast add an "_" before per_cpu
> pointers name?
> 

Yes.

> --
> viresh
> 

