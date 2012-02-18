Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2BRBoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 20:44:13 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:41692 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab2BRBoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 20:44:12 -0500
Message-ID: <4F3F025B.5010400@linux.vnet.ibm.com>
Date: Sat, 18 Feb 2012 09:43:55 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.26) Gecko/20120131 Thunderbird/3.1.18
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] sched: Avoid unnecessary work in reweight_entity
References: <4F2F9F6C.1090608@linux.vnet.ibm.com> <4F3089F9.6010609@linux.vnet.ibm.com> <4F308E25.7060101@linux.vnet.ibm.com> <4F31D9B2.5090501@linux.vnet.ibm.com> <4F3D0F41.1010205@linux.vnet.ibm.com> <1329402561.2293.225.camel@twins> <4F3DEDC3.4010004@linux.vnet.ibm.com>
In-Reply-To: <4F3DEDC3.4010004@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12021801-5564-0000-0000-0000016AA716
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter

This is the v5, any I found there will be the case that weight == se->load.weight 
in reweight_entity(very often according to the log), so I add the check point.

And I try to use perf to see whether it can help to prove the improvement, but get:

invalid or unsupported event: 'sched:sched_switch'

when use command "perf sched record".

And also someone told me that even use perf sched may not be able to prove anything 
because what I do may only help improve little performance which can not be easily 
detected :(

So may be we can prove this patch's performance improvement logically, the summary is:

1. reduce times to check "se->on" from 2 to 1.
2. reduce times to check "parent_entity(se)" from 2 to 1.
3. reduce times to check "entity_is_task(se)" from 2 to 1.
4. reduce times to set "cfs_rq->load.inv_weight" from 4 to 2.
5. reduce times to set "rq_of(cfs_rq)->load.inv_weight" from 2 to 1.
6. no need to use "list_add(&se->group_node, &cfs_rq->tasks);" any more.
7. no need to use "list_del_init(&se->group_node);" any more.
8. no need to do "cfs_rq->nr_running++" and "cfs_rq->nr_running--" any more.

above summary is already in previous mail, any for v5, we get one more:

9. do nothing if the new weight is same to the old weight.

And as reight_entity is invoked very often, I think this patch can do some help to the 
performance, although there are no numbers, we can prove it logically :)  

Best regards,
Michael Wang

On 02/17/2012 02:03 PM, Michael Wang wrote:

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
> 
> since v1:
> 	Add more description.
> 	Mark add_cfs_task_weight as inline. 
> 	correct useless and wrong code. 
> 	Add check point for the case there is no change on weight.
> 
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  kernel/sched/fair.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7c6414f..20aa355 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -777,7 +777,7 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
>   */
> 
>  #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
> -static void
> +static inline void
>  add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
>  {
>  	cfs_rq->task_weight += weight;
> @@ -938,20 +938,24 @@ static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
>  {
>  }
>  # endif /* CONFIG_SMP */
> +
>  static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
>  			    unsigned long weight)
>  {
> +	if (weight == se->load.weight)
> +		return;
> +
>  	if (se->on_rq) {
>  		/* commit outstanding execution time */
>  		if (cfs_rq->curr == se)
>  			update_curr(cfs_rq);
> -		account_entity_dequeue(cfs_rq, se);
> +		update_load_add(&cfs_rq->load, weight - se->load.weight);
> +		if (!parent_entity(se))
> +			update_load_add(&rq_of(cfs_rq)->load, weight - se->load.weight);
> +		if (entity_is_task(se))
> +			add_cfs_task_weight(cfs_rq, weight - se->load.weight);
>  	}
> -
>  	update_load_set(&se->load, weight);
> -
> -	if (se->on_rq)
> -		account_entity_enqueue(cfs_rq, se);
>  }
> 
>  static void update_cfs_shares(struct cfs_rq *cfs_rq)


