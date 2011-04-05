Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1DEN3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:29:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:54541 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab1DEN2j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:28:39 -0400
Subject: Re: [patch 13/15] sched: expire slack quota using generation
 counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <20110323030449.941304760@google.com>
References: <20110323030326.789836913@google.com>
	 <20110323030449.941304760@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Apr 2011 15:28:09 +0200
Message-ID: <1302010089.2225.1313.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:

Argh, this patch is terrible for the reason that it changes the whole
accounting just introduced and me having to re-open all the previous
patches to look up hth stuff worked before.

> @@ -436,8 +438,10 @@ void init_cfs_bandwidth(struct cfs_bandw
>  	raw_spin_lock_init(&cfs_b->lock);
>  	cfs_b->quota = cfs_b->runtime = quota;
>  	cfs_b->period = ns_to_ktime(period);
> +	cfs_b->quota_generation = 0;
>  	INIT_LIST_HEAD(&cfs_b->throttled_cfs_rq);
>  
> +
>  	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>  	cfs_b->period_timer.function = sched_cfs_period_timer;

We're in desperate need of more whitespace there? :-)

> @@ -9333,6 +9337,8 @@ static int tg_set_cfs_bandwidth(struct t
>  	raw_spin_lock_irq(&cfs_b->lock);
>  	cfs_b->period = ns_to_ktime(period);
>  	cfs_b->runtime = cfs_b->quota = quota;
> +
> +	cfs_bump_quota_generation(cfs_b);
>  	raw_spin_unlock_irq(&cfs_b->lock);
>  
>  	for_each_possible_cpu(i) {
> Index: tip/kernel/sched_fair.c
> ===================================================================
> --- tip.orig/kernel/sched_fair.c
> +++ tip/kernel/sched_fair.c
> @@ -1331,11 +1331,25 @@ static void check_cfs_rq_quota(struct cf
>  	resched_task(rq_of(cfs_rq)->curr);
>  }
>  
> +static void cfs_bump_quota_generation(struct cfs_bandwidth *cfs_b)
> +{
> +	cfs_b->quota_generation++;
> +	smp_mb();
> +}

Memory barriers come in pairs and with a comment, you fail on both
counts.

> +
> +static inline int cfs_rq_quota_current(struct cfs_rq *cfs_rq)
> +{
> +	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
> +
> +	return cfs_rq->quota_generation == cfs_b->quota_generation;
> +}
> +
>  static void request_cfs_rq_quota(struct cfs_rq *cfs_rq)
>  {
>  	struct task_group *tg = cfs_rq->tg;
>  	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
>  	u64 amount = 0, min_amount;
> +	int generation;

Not initialized,

>  	min_amount = sched_cfs_bandwidth_slice() + (-cfs_rq->quota_remaining);
>  
> @@ -1347,10 +1361,18 @@ static void request_cfs_rq_quota(struct 
>  		} else {
>  			amount = min_amount;
>  		}
> +		generation = cfs_b->quota_generation;
>  		raw_spin_unlock(&cfs_b->lock);
>  	}

and since there's an if there, one can fail it, leaving generation
uninitialized,

>  
> +	/* a deficit should be carried forwards, surplus should be dropped */
> +
> +	if (generation != cfs_rq->quota_generation &&
> +	    cfs_rq->quota_remaining > 0)
> +		cfs_rq->quota_remaining = 0;
> +
>  	cfs_rq->quota_remaining += amount;
> +	cfs_rq->quota_generation = generation;
>  }

Resulting in uninitialized usage right there.

