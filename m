Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab2BPO3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:29:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45097 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2BPO3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:29:37 -0500
Message-ID: <1329402561.2293.225.camel@twins>
Subject: Re: [PATCH v4] sched: Avoid unnecessary work in reweight_entity
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 16 Feb 2012 15:29:21 +0100
In-Reply-To: <4F3D0F41.1010205@linux.vnet.ibm.com>
References: <4F2F9F6C.1090608@linux.vnet.ibm.com>
	 <4F3089F9.6010609@linux.vnet.ibm.com> <4F308E25.7060101@linux.vnet.ibm.com>
	 <4F31D9B2.5090501@linux.vnet.ibm.com> <4F3D0F41.1010205@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 22:14 +0800, Michael Wang wrote:
> From: Michael Wang <wangyun@linux.vnet.ibm.com>
> 
> In original code, using account_entity_dequeue and account_entity_enqueue
> as a pair will do some work unnecessary, such like remove node from list
> and add it back again immediately.
> 
> And because there are no really enqueue and dequeue happen here, it is not
> suitable to use account_entity_dequeue and account_entity_enqueue here.
> 
> This patch combine the work of them in order to save time.

And yet no numbers on how much it saves :-(

> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  kernel/sched/fair.c  |   27 +++++++++++++++++++++------
>  kernel/sched/sched.h |    8 ++++++++
>  2 files changed, 29 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7c6414f..fda63ec 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -777,16 +777,28 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
>   */
>  
>  #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
> -static void
> +static inline void
>  add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
>  {
>  	cfs_rq->task_weight += weight;
>  }
> +
> +static inline void
> +sub_add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long sub, unsigned long add)
> +{
> +	cfs_rq->task_weight -= sub;
> +	cfs_rq->task_weight += add;
> +}

This is pointless, just use: add_cfs_task_weight(cfs_rq, add - sub);

>  #else
>  static inline void
>  add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
>  {
>  }
> +
> +static inline void
> +sub_add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long sub, unsigned long add)
> +{
> +}
>  #endif
>  
>  static void
> @@ -938,6 +950,7 @@ static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
>  {
>  }
>  # endif /* CONFIG_SMP */
> +
>  static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
>  			    unsigned long weight)
>  {
> @@ -945,13 +958,15 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
>  		/* commit outstanding execution time */
>  		if (cfs_rq->curr == se)
>  			update_curr(cfs_rq);
> -		account_entity_dequeue(cfs_rq, se);
> +		update_load_sub_add(&cfs_rq->load, se->load.weight, weight);
> +		if (!parent_entity(se)) {
> +			update_load_sub_add(&rq_of(cfs_rq)->load, se->load.weight, weight);

same here:
	update_load_add(&rq_of(cfs_rq)->load, weight - se->load.weight);

Also superfluous use of curly-braces here.

> +		}
> +		if (entity_is_task(se)) {
> +			sub_add_cfs_task_weight(cfs_rq, se->load.weight, weight);
> +		}

idem.

>  	}
> -
>  	update_load_set(&se->load, weight);
> -
> -	if (se->on_rq)
> -		account_entity_enqueue(cfs_rq, se);
>  }
>  
>  static void update_cfs_shares(struct cfs_rq *cfs_rq)
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 98c0c26..ec4430f 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -779,6 +779,14 @@ static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
>  	lw->inv_weight = 0;
>  }
>  
> +static inline void update_load_sub_add(struct load_weight *lw, unsigned long dec,
> +					unsigned long inc)
> +{
> +	lw->weight -= dec;
> +	lw->weight += inc;
> +	lw->inv_weight = 0;
> +}

again, pointless stuff.

>  static inline void update_load_set(struct load_weight *lw, unsigned long w)
>  {
>  	lw->weight = w;

