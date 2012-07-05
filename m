Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab2GEL64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 07:58:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:54778 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab2GEL6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 07:58:42 -0400
Subject: Re: [PATCH 12/16] sched: refactor update_shares_cpu() ->
 update_blocked_avgs()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
In-Reply-To: <20120628022415.30496.57167.stgit@kitami.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
	 <20120628022415.30496.57167.stgit@kitami.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Jul 2012 13:58:28 +0200
Message-ID: <1341489508.19870.30.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 19:24 -0700, Paul Turner wrote:
> Now that running entities maintain their own load-averages the work we must do
> in update_shares() is largely restricted to the periodic decay of blocked
> entities.  This allows us to be a little less pessimistic regarding our
> occupancy on rq->lock and the associated rq->clock updates required.

So what you're saying is that since 'weight' now includes runtime
behaviour (where we hope the recent past matches the near future) we
don't need to update shares quite as often since the effect of
sleep-wakeup cycles isn't near as big since they're already anticipated.

So how is the decay of blocked load still significant, surely that too
is mostly part of the anticipated sleep/wake cycle already caught in the
runtime behaviour.

Or is this the primary place where we decay? If so that wasn't obvious
and thus wants a comment someplace.

> Signed-off-by: Paul Turner <pjt@google.com>
> ---

> +static void update_blocked_averages(int cpu)
>  {
>  	struct rq *rq = cpu_rq(cpu);
> +	struct cfs_rq *cfs_rq;
> +
> +	unsigned long flags;
> +	int num_updates = 0;
>  
>  	rcu_read_lock();
> +	raw_spin_lock_irqsave(&rq->lock, flags);
> +	update_rq_clock(rq);
>  	/*
>  	 * Iterates the task_group tree in a bottom up fashion, see
>  	 * list_add_leaf_cfs_rq() for details.
>  	 */
>  	for_each_leaf_cfs_rq(rq, cfs_rq) {
> +		__update_blocked_averages_cpu(cfs_rq->tg, rq->cpu);
>  
> +		/*
> +		 * Periodically release the lock so that a cfs_rq with many
> +		 * children cannot hold it for an arbitrary period of time.
> +		 */
> +		if (num_updates++ % 20 == 0) {
> +			raw_spin_unlock_irqrestore(&rq->lock, flags);
> +			cpu_relax();
> +			raw_spin_lock_irqsave(&rq->lock, flags);

Gack.. that's not real pretty is it.. Esp. since we're still holding RCU
lock and are thus (mostly) still not preemptable.

How much of a problem was this?, the changelog is silent on this.

> +			update_rq_clock(rq);
> +		}
>  	}
> +
> +	raw_spin_unlock_irqrestore(&rq->lock, flags);
>  	rcu_read_unlock();
>  }
>  



