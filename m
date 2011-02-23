Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1BWNdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:33:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:45312 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab1BWNdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:33:23 -0500
Subject: Re: [CFS Bandwidth Control v4 4/7] sched: unthrottle cfs_rq(s) who
 ran out of quota at period refresh
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
In-Reply-To: <20110216031841.161743484@google.com>
References: <20110216031831.571628191@google.com>
	 <20110216031841.161743484@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Feb 2011 14:32:12 +0100
Message-ID: <1298467932.2217.764.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 19:18 -0800, Paul Turner wrote:

> +static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
> +{
> +	struct rq *rq = rq_of(cfs_rq);
> +	struct sched_entity *se;
> +
> +	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
> +
> +	update_rq_clock(rq);
> +	/* (Try to) avoid maintaining share statistics for idle time */
> +	cfs_rq->load_stamp = cfs_rq->load_last = rq->clock_task;

Ok, so here you try to compensate for some of the weirdness from the
previous patch.. wouldn't it be much saner to fully consider the
throttled things dequeued for the load calculation etc.?

> +
> +	cfs_rq->throttled = 0;
> +	for_each_sched_entity(se) {
> +		if (se->on_rq)
> +			break;
> +
> +		cfs_rq = cfs_rq_of(se);
> +		enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
> +		if (cfs_rq_throttled(cfs_rq))
> +			break;

That's just weird, it was throttled, you enqueued it but find it
throttled.

> +	}
> +
> +	/* determine whether we need to wake up potentally idle cpu */

SP: potentially, also isn't there a determiner missing?

> +	if (rq->curr == rq->idle && rq->cfs.nr_running)
> +		resched_task(rq->curr);
> +}
> +
>  static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
>  		unsigned long delta_exec)
>  {
> @@ -1535,8 +1569,46 @@ static void account_cfs_rq_quota(struct 
>  
>  static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
>  {
> -	return 1;
> +	int i, idle = 1;
> +	u64 delta;
> +	const struct cpumask *span;
> +
> +	if (cfs_b->quota == RUNTIME_INF)
> +		return 1;
> +
> +	/* reset group quota */
> +	raw_spin_lock(&cfs_b->lock);
> +	cfs_b->runtime = cfs_b->quota;

Shouldn't that be something like:

cfs_b->runtime = 
   min(cfs_b->runtime + overrun * cfs_b->quota, cfs_b->quota);

afaict runtime can go negative in which case we need to compensate for
that, but we cannot ever get more than quota because we allow for
overcommit, so not limiting things would allow us to accrue an unlimited
amount of runtime.

Or can only the per-cpu quota muck go negative? In that case it should
probably be propagated back into the global bw on throttle, otherwise
you can get deficits on CPUs that remain unused for a while.

> +	raw_spin_unlock(&cfs_b->lock);
> +
> +	span = sched_bw_period_mask();
> +	for_each_cpu(i, span) {
> +		struct rq *rq = cpu_rq(i);
> +		struct cfs_rq *cfs_rq = cfs_bandwidth_cfs_rq(cfs_b, i);
> +
> +		if (cfs_rq->nr_running)
> +			idle = 0;
> +
> +		if (!cfs_rq_throttled(cfs_rq))
> +			continue;
> +
> +		delta = tg_request_cfs_quota(cfs_rq->tg);
> +
> +		if (delta) {
> +			raw_spin_lock(&rq->lock);
> +			cfs_rq->quota_assigned += delta;
> +
> +			/* avoid race with tg_set_cfs_bandwidth */

*what* race, and *how*

> +			if (cfs_rq_throttled(cfs_rq) &&
> +			     cfs_rq->quota_used < cfs_rq->quota_assigned)
> +				unthrottle_cfs_rq(cfs_rq);
> +			raw_spin_unlock(&rq->lock);
> +		}
> +	}
> +
> +	return idle;
>  }

This whole positive quota muck makes my head hurt, whatever did you do
that for? Also it doesn't deal with wrapping, which admittedly won't
really happen but still.



