Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0LGNOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 08:14:00 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42480 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705Ab0LGNN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 08:13:59 -0500
Date: Tue, 7 Dec 2010 18:43:33 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>,
        Nikhil Rao <ncrao@google.com>
Subject: Re: [PATCH v3 4/7] sched: unthrottle cfs_rq(s) who ran out of
	quota at period refresh
Message-ID: <20101207131333.GA10723@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20101012074910.GA9893@in.ibm.com> <20101012075247.GE9893@in.ibm.com> <20101015044552.GI13048@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015044552.GI13048@balbir.in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Balbir, didn't realize that we haven't replied to these comments from you.

On Fri, Oct 15, 2010 at 10:15:52AM +0530, Balbir Singh wrote:
> * Bharata B Rao <bharata@linux.vnet.ibm.com> [2010-10-12 13:22:47]:
> 
> > sched: unthrottle cfs_rq(s) who ran out of quota at period refresh
> > 
> > From: Paul Turner <pjt@google.com>
> > 
> > At the start of a new period there are several actions we must take:
> > - Refresh global bandwidth pool
> > - Unthrottle entities who ran out of quota as refreshed bandwidth permits
> > 
> > Unthrottled entities have the cfs_rq->throttled flag set and are re-enqueued
> > into the cfs entity hierarchy.
> >
> 
> Am I reading this right?

Yes, Needs to be corrected. Thanks.

> 
> > sched_rt_period_mask() is refactored slightly into sched_bw_period_mask()
> > since it is now shared by both cfs and rt bandwidth period timers.
> > 
> > The !CONFIG_RT_GROUP_SCHED && CONFIG_SMP case has been collapsed to use
> > rd->span instead of cpu_online_mask since I think that was incorrect before
> > (don't want to hit cpu's outside of your root_domain for RT bandwidth).
> > 
> > Signed-off-by: Paul Turner <pjt@google.com>
> > Signed-off-by: Nikhil Rao <ncrao@google.com>
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > ---
> >  kernel/sched.c      |   16 ++++++++++++
> >  kernel/sched_fair.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  kernel/sched_rt.c   |   19 --------------
> >  3 files changed, 84 insertions(+), 19 deletions(-)
> > 
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -1565,6 +1565,8 @@ static int tg_nop(struct task_group *tg,
> >  }
> >  #endif
> > 
> > +static inline const struct cpumask *sched_bw_period_mask(void);
> > +
> >  #ifdef CONFIG_SMP
> >  /* Used instead of source_load when we know the type == 0 */
> >  static unsigned long weighted_cpuload(const int cpu)
> > @@ -1933,6 +1935,18 @@ static inline void __set_task_cpu(struct
> > 
> >  static const struct sched_class rt_sched_class;
> > 
> > +#ifdef CONFIG_SMP
> > +static inline const struct cpumask *sched_bw_period_mask(void)
> > +{
> > +	return cpu_rq(smp_processor_id())->rd->span;
> > +}
> > +#else
> > +static inline const struct cpumask *sched_bw_period_mask(void)
> > +{
> > +	return cpu_online_mask;
> > +}
> > +#endif
> > +
> >  #ifdef CONFIG_CFS_BANDWIDTH
> >  /*
> >   * default period for cfs group bandwidth.
> > @@ -8937,6 +8951,8 @@ static int tg_set_cfs_bandwidth(struct t
> > 
> >  		raw_spin_lock_irq(&rq->lock);
> >  		init_cfs_rq_quota(cfs_rq);
> > +		if (cfs_rq_throttled(cfs_rq))
> > +			unthrottle_cfs_rq(cfs_rq);
> >  		raw_spin_unlock_irq(&rq->lock);
> >  	}
> >  	mutex_unlock(&mutex);
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -268,6 +268,13 @@ find_matching_se(struct sched_entity **s
> >  #endif	/* CONFIG_FAIR_GROUP_SCHED */
> > 
> >  #ifdef CONFIG_CFS_BANDWIDTH
> > +static inline
> > +struct cfs_rq *cfs_bandwidth_cfs_rq(struct cfs_bandwidth *cfs_b, int cpu)
> > +{
> 
> Nit pick, but I'd call this function cfs_bandwidth_cfs_cpu_rq
> 
> > +	return container_of(cfs_b, struct task_group,
> > +			cfs_bandwidth)->cfs_rq[cpu];
> > +}
> > +
> >  static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
> >  {
> >  	return &tg->cfs_bandwidth;
> > @@ -1219,6 +1226,29 @@ out_throttled:
> >  	cfs_rq->throttled = 1;
> >  }
> > 
> > +static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
> > +{
> > +	struct sched_entity *se;
> > +	struct rq *rq = rq_of(cfs_rq);
> > +
> > +	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
> > +
> > +	cfs_rq->throttled = 0;
> > +	for_each_sched_entity(se) {
> > +		if (se->on_rq)
> > +			break;
> > +
> > +		cfs_rq = cfs_rq_of(se);
> > +		enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
> 
> Should we really enqueue with ENQUEUE_WAKEUP - the task throttled, not
> slept.

Yes, but the actions are quite similar. In both the cases, they go off
the runqueque and get enqueued back. I see two (side)effects of using
DEQUEUE_SLEEP during dequeue and ENQUEUE_WAKEUP during enqueue:

- vruntime normalization isn't done for throttled entities. This should be
  fine since they don't get pulled around when throttled.
- vruntime of throttled entities are re-calculated during unthrottling(enqueue).
  This will ensure that throttled entities don't get undue vruntime-advantage
  when they are enqueued back.

This is my understanding. I would request Paul to comment here.

> 
> > +		if (cfs_rq_throttled(cfs_rq))
> > +			break;
> > +	}
> > +
> > +	/* determine whether we need to wake up potentally idle cpu */
> > +	if (rq->curr == rq->idle && rq->cfs.nr_running)
> > +		resched_task(rq->curr);
> > +}
> > +
> >  static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
> >  		unsigned long delta_exec)
> >  {
> > @@ -1241,8 +1271,44 @@ static void account_cfs_rq_quota(struct 
> > 
> >  static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
> >  {
> > -	return 1;
> > +	int i, idle = 1;
> > +	u64 delta;
> > +	const struct cpumask *span;
> > +
> > +	if (cfs_b->quota == RUNTIME_INF)
> > +		return 1;
> 
> I am afraid I don't understand how return codes are being used here.
> idle is set to 1 if there are no running tasks across all CPUs. Why do
> we return a 1 from here?

Remember we are in hrtimer handler here, returning 1 will ensure that hrtimer
isn't restarted. So we don't restart the timer for a group that isn't
bandwidth constrained.

Regards,
Bharata.
