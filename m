Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab1CXGgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 02:36:07 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:35256 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab1CXGgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 02:36:05 -0400
Date: Thu, 24 Mar 2011 12:06:43 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Subject: Re: [patch 04/15] sched: throttle cfs_rq entities which exceed their
 local quota
Message-ID: <20110324063642.GB2721@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110323030326.789836913@google.com>
 <20110323030449.047028257@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323030449.047028257@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 08:03:30PM -0700, Paul Turner wrote:
> In account_cfs_rq_quota() (via update_curr()) we track consumption versus a
> cfs_rqs locally assigned quota and whether there is global quota available 
> to provide a refill when it runs out.
> 
> In the case that there is no quota remaining it's necessary to throttle so
> that execution ceases until the susbequent period.  While it is at this
> boundary that we detect (and signal for, via reshed_task) that a throttle is
> required, the actual operation is deferred until put_prev_entity().
> 
> At this point the cfs_rq is marked as throttled and not re-enqueued, this
> avoids potential interactions with throttled runqueues in the event that we
> are not immediately able to evict the running task.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> Signed-off-by: Nikhil Rao <ncrao@google.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
>  kernel/sched.c      |    2 
>  kernel/sched_fair.c |  117 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 113 insertions(+), 6 deletions(-)
> 
> Index: tip/kernel/sched.c
> ===================================================================
> --- tip.orig/kernel/sched.c
> +++ tip/kernel/sched.c
> @@ -386,7 +386,7 @@ struct cfs_rq {
>  	unsigned long load_contribution;
>  #endif
>  #ifdef CONFIG_CFS_BANDWIDTH
> -	int quota_enabled;
> +	int quota_enabled, throttled;
>  	s64 quota_remaining;
>  #endif
>  #endif
> Index: tip/kernel/sched_fair.c
> ===================================================================
> --- tip.orig/kernel/sched_fair.c
> +++ tip/kernel/sched_fair.c
> @@ -321,9 +321,6 @@ find_matching_se(struct sched_entity **s
> 
>  #endif	/* CONFIG_FAIR_GROUP_SCHED */
> 
> -static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
> -		                 unsigned long delta_exec);
> -
>  /**************************************************************
>   * Scheduling class tree data structure manipulation methods:
>   */
> @@ -588,6 +585,9 @@ __update_curr(struct cfs_rq *cfs_rq, str
>  #endif
>  }
> 
> +static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
> +		unsigned long delta_exec);
> +
>  static void update_curr(struct cfs_rq *cfs_rq)
>  {
>  	struct sched_entity *curr = cfs_rq->curr;
> @@ -1221,6 +1221,9 @@ static struct sched_entity *pick_next_en
>  	return se;
>  }
> 
> +static void throttle_cfs_rq(struct cfs_rq *cfs_rq);
> +static inline int within_bandwidth(struct cfs_rq *cfs_rq);
> +
>  static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
>  {
>  	/*
> @@ -1230,6 +1233,9 @@ static void put_prev_entity(struct cfs_r
>  	if (prev->on_rq)
>  		update_curr(cfs_rq);
> 
> +	if (!within_bandwidth(cfs_rq))
> +		throttle_cfs_rq(cfs_rq);
> +
>  	check_spread(cfs_rq, prev);
>  	if (prev->on_rq) {
>  		update_stats_wait_start(cfs_rq, prev);
> @@ -1241,6 +1247,8 @@ static void put_prev_entity(struct cfs_r
>  	cfs_rq->curr = NULL;
>  }
> 
> +static void check_cfs_rq_quota(struct cfs_rq *cfs_rq);
> +
>  static void
>  entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
>  {
> @@ -1249,6 +1257,9 @@ entity_tick(struct cfs_rq *cfs_rq, struc
>  	 */
>  	update_curr(cfs_rq);
> 
> +	/* check that entity's usage is still within quota (if enabled) */
> +	check_cfs_rq_quota(cfs_rq);
> +
>  	/*
>  	 * Update share accounting for long-running entities.
>  	 */
> @@ -1294,6 +1305,46 @@ static inline u64 sched_cfs_bandwidth_sl
>         return (u64)sysctl_sched_cfs_bandwidth_slice * NSEC_PER_USEC;
>  }
> 
> +static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
> +{
> +	return cfs_rq->throttled;
> +}
> +
> +static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
> +{
> +	struct task_group *tg;
> +	struct sched_entity *se;
> +
> +	if (cfs_rq_throttled(cfs_rq))
> +		return 1;
> +
> +	tg = cfs_rq->tg;
> +	se = tg->se[cpu_of(rq_of(cfs_rq))];
> +	if (!se)
> +		return 0;
> +
> +	for_each_sched_entity(se) {
> +		if (cfs_rq_throttled(cfs_rq_of(se)))
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline int within_bandwidth(struct cfs_rq *cfs_rq)
> +{
> +	return !cfs_rq->quota_enabled || cfs_rq->quota_remaining > 0;
> +}
> +
> +static void check_cfs_rq_quota(struct cfs_rq *cfs_rq)
> +{
> +	if (within_bandwidth(cfs_rq))
> +		return;
> +
> +
> +	resched_task(rq_of(cfs_rq)->curr);
> +}
> +
>  static void request_cfs_rq_quota(struct cfs_rq *cfs_rq)
>  {
>  	struct task_group *tg = cfs_rq->tg;
> @@ -1330,6 +1381,29 @@ static void account_cfs_rq_quota(struct 
>  	request_cfs_rq_quota(cfs_rq);
>  }
> 
> +static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
> +{
> +	struct sched_entity *se;
> +
> +	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
> +
> +	/* account load preceding throttle */
> +	update_cfs_load(cfs_rq, 0);
> +
> +	for_each_sched_entity(se) {
> +		struct cfs_rq *qcfs_rq = cfs_rq_of(se);
> +		/* throttled entity or throttle-on-deactivate */
> +		if (!se->on_rq)
> +			break;
> +
> +		dequeue_entity(qcfs_rq, se, DEQUEUE_SLEEP);
> +		if (qcfs_rq->load.weight)
> +			break;
> +	}
> +
> +	cfs_rq->throttled = 1;
> +}

Since throttling is done from put_prev_entity(), iiuc, you will be
doing 'put' for current entities which are not on the tree. Can you
avoid the dequeue_entity() call here which I think will anyway bail out
from actual dequeueing (se != cfs_rq->curr check in dequeue_entity).

Regards,
Bharata.
