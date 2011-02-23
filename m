Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1BWNck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:32:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:45297 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab1BWNcj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:32:39 -0500
Subject: Re: [CFS Bandwidth Control v4 2/7] sched: accumulate per-cfs_rq
 cpu usage
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
In-Reply-To: <20110216031840.979831163@google.com>
References: <20110216031831.571628191@google.com>
	 <20110216031840.979831163@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Feb 2011 14:32:14 +0100
Message-ID: <1298467934.2217.766.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 19:18 -0800, Paul Turner wrote:

> @@ -609,6 +631,9 @@ static void update_curr(struct cfs_rq *c
>  		cpuacct_charge(curtask, delta_exec);
>  		account_group_exec_runtime(curtask, delta_exec);
>  	}
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	account_cfs_rq_quota(cfs_rq, delta_exec);
> +#endif
>  }

Not too hard to make the #ifdef'ery go away I'd guess.

>  static inline void
> @@ -1382,6 +1407,43 @@ static void dequeue_task_fair(struct rq 
>  }
>  
>  #ifdef CONFIG_CFS_BANDWIDTH
> +static u64 tg_request_cfs_quota(struct task_group *tg)
> +{
> +	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
> +	u64 delta = 0;
> +
> +	if (cfs_b->runtime > 0 || cfs_b->quota == RUNTIME_INF) {
> +		raw_spin_lock(&cfs_b->lock);
> +		/*
> +		 * it's possible a bandwidth update has changed the global
> +		 * pool.
> +		 */
> +		if (cfs_b->quota == RUNTIME_INF)
> +			delta = sched_cfs_bandwidth_slice();

Why do we bother at all when there's infinite time? Shouldn't the action
that sets it to infinite also make cfs_rq->quota_assinged to to
RUNTIME_INF, in which case the below check will make it all go away?

> +		else {
> +			delta = min(cfs_b->runtime,
> +					sched_cfs_bandwidth_slice());
> +			cfs_b->runtime -= delta;
> +		}
> +		raw_spin_unlock(&cfs_b->lock);
> +	}
> +	return delta;
> +}

Also, shouldn't this all try and steal time from other cpus when the
global limit ran out? Suppose you have say 24 cpus, and you had a short
burst where all 24 cpus had some runtime, so you distribute 240ms. But
23 of those cpus only ran for 0.5ms, leaving 23.5ms of unused time on 23
cpus while your one active cpu will then throttle.

I would much rather see all the accounting tight first and optimize
later than start with leaky stuff and try and plug holes later.

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

So why isn't this hierarchical?, also all this positive quota stuff
looks weird, why not decrement and try to supplement when negative?
