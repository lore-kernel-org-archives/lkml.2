Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0JMNbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:31:14 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:38570 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab0JMNbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:31:13 -0400
Date: Wed, 13 Oct 2010 19:00:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
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
Subject: Re: [PATCH v3 2/7] sched: accumulate per-cfs_rq cpu usage
Message-ID: <20101013133053.GD3914@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101012074910.GA9893@in.ibm.com>
 <20101012075109.GC9893@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101012075109.GC9893@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bharata B Rao <bharata@linux.vnet.ibm.com> [2010-10-12 13:21:09]:

> sched: accumulate per-cfs_rq cpu usage
> 
> From: Paul Turner <pjt@google.com>
> 
> Introduce account_cfs_rq_quota() to account bandwidth usage on the cfs_rq
> level versus task_groups for which bandwidth has been assigned.  This is
> tracked by whether the local cfs_rq->quota_assigned is finite or infinite
> (RUNTIME_INF).
> 
> For cfs_rq's that belong to a bandwidth constrained task_group we introduce
> tg_request_cfs_quota() which attempts to allocate quota from the global pool
> for use locally.  Updates involving the global pool are currently protected
> under cfs_bandwidth->lock, local pools are protected by rq->lock.
> 
> This patch only attempts to assign and track quota, no action is taken in the
> case that cfs_rq->quota_used exceeds cfs_rq->quota_assigned.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> Signed-off-by: Nikhil Rao <ncrao@google.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
>  include/linux/sched.h |    4 ++++
>  kernel/sched.c        |   13 +++++++++++++
>  kernel/sched_fair.c   |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sysctl.c       |   10 ++++++++++
>  4 files changed, 77 insertions(+)
> 
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1898,6 +1898,10 @@ int sched_rt_handler(struct ctl_table *t
>  		void __user *buffer, size_t *lenp,
>  		loff_t *ppos);
> 
> +#ifdef CONFIG_CFS_BANDWIDTH
> +extern unsigned int sysctl_sched_cfs_bandwidth_slice;
> +#endif
> +
>  extern unsigned int sysctl_sched_compat_yield;
> 
>  #ifdef CONFIG_RT_MUTEXES
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1929,6 +1929,19 @@ static const struct sched_class rt_sched
>   * default: 0.5s
>   */
>  static u64 sched_cfs_bandwidth_period = 500000000ULL;
> +
> +/*
> + * default slice of quota to allocate from global tg to local cfs_rq pool on
> + * each refresh
> + * default: 10ms
> + */
> +unsigned int sysctl_sched_cfs_bandwidth_slice = 10000UL;
> +
> +static inline u64 sched_cfs_bandwidth_slice(void)
> +{
> +	return (u64)sysctl_sched_cfs_bandwidth_slice * NSEC_PER_USEC;
> +}
> +
>  #endif
> 
>  #define sched_class_highest (&rt_sched_class)
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -267,6 +267,16 @@ find_matching_se(struct sched_entity **s
> 
>  #endif	/* CONFIG_FAIR_GROUP_SCHED */
> 
> +#ifdef CONFIG_CFS_BANDWIDTH
> +static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
> +{
> +	return &tg->cfs_bandwidth;
> +}
> +
> +static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
> +		unsigned long delta_exec);
> +#endif
> +
> 
>  /**************************************************************
>   * Scheduling class tree data structure manipulation methods:
> @@ -547,6 +557,9 @@ static void update_curr(struct cfs_rq *c
>  		cpuacct_charge(curtask, delta_exec);
>  		account_group_exec_runtime(curtask, delta_exec);
>  	}
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	account_cfs_rq_quota(cfs_rq, delta_exec);
> +#endif
>  }
> 
>  static inline void
> @@ -1130,6 +1143,43 @@ static void yield_task_fair(struct rq *r
>  }
> 
>  #ifdef CONFIG_CFS_BANDWIDTH
> +static u64 tg_request_cfs_quota(struct task_group *tg)
> +{
> +	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
> +	u64 delta = 0;
> +
> +	if (cfs_b->runtime > 0 || cfs_b->quota == RUNTIME_INF) {

Quick question for cfs_b->quota == RUNTIME_INF, won't cfs_b->runtime
be always > 0?

> +		raw_spin_lock(&cfs_b->lock);
> +		/*
> +		 * it's possible a bandwidth update has changed the global
> +		 * pool.
> +		 */
> +		if (cfs_b->quota == RUNTIME_INF)
> +			delta = sched_cfs_bandwidth_slice();
> +		else {
> +			delta = min(cfs_b->runtime,
> +					sched_cfs_bandwidth_slice());
> +			cfs_b->runtime -= delta;
> +		}
> +		raw_spin_unlock(&cfs_b->lock);
> +	}
> +	return delta;
> +}
> +
> +static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
> +		unsigned long delta_exec)
> +{
> +	if (cfs_rq->quota_assigned == RUNTIME_INF)
> +		return;
> +
> +	cfs_rq->quota_used += delta_exec;
> +
> +	if (cfs_rq->quota_used < cfs_rq->quota_assigned)
> +		return;
> +
> +	cfs_rq->quota_assigned += tg_request_cfs_quota(cfs_rq->tg);
> +}
> +
>  static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
>  {
>  	return 1;
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -384,6 +384,16 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec,
>  	},
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	{
> +		.procname	= "sched_cfs_bandwidth_slice_us",
> +		.data		= &sysctl_sched_cfs_bandwidth_slice,
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= &one,
> +	},
> +#endif
>  #ifdef CONFIG_PROVE_LOCKING
>  	{
>  		.procname	= "prove_locking",

-- 
	Three Cheers,
	Balbir
