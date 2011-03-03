Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab1CCOGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:06:05 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61794 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab1CCOGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:06:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pA5TQq21TIxpkbxL+eSDtxBFJ1BTw0kVTk7gATMjDD8xxlqcpQOkq0ht2bm23X7Ixh
         C7IuPvW285FBskEGZzkYxsj0uow6cdXm7krvy59vuqzHmdCkOipz/ZO7Vp8SVEgiMaHM
         u2kwsqBn2edhaFsNSe918jgx0maLg9pYUELB0=
Date: Thu, 3 Mar 2011 22:05:51 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <pzijlstr@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Bharata B Rao <bharata.rao@in.ibm.com>
Subject: Re: [BUGFIX][PATCH] Fix sched rt group scheduling when hierachy is
 enabled
Message-ID: <20110303140551.GA20677@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110303113435.GA2868@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110303113435.GA2868@balbir.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 05:04:35PM +0530, Balbir Singh wrote:
> Fix hierarchical scheduling in sched rt group
> 
> From: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> The current sched rt code is broken when it comes to hierarchical
> scheduling, this patch fixes two problems
> 
> 1. It adds redundant enqueuing (harmless) when it finds a queue
>    has tasks enqueued, but it has no run time and it is not
>    throttled.

You say redundant here, so in fact we don't need it, right?

> 2. The most important change is in sched_rt_rq_enqueue/dequeue.
>    The code just picks the rt_rq belonging to the current cpu
>    on which the period timer runs, the patch fixes it, so that
>    the correct rt_se is enqueued/dequeued.

Ah, this is true. It is also needed for stable-2.6.33+

Thanks,
Yong

> 
> Tested with a simple hierarchy
> 
> /c/d, c and d assigned similar runtimes of 50,000 and a while
> 1 loop runs within "d". Both c and d get throttled, without
> the patch, the task just stops running and never runs (depends
> on where the sched_rt b/w timer runs). With the patch, the
> task is throttled and runs as expected.
> 
> [bharata, suggestions on how to pick the rt_se belong to the rt_rq
> and correct cpu]
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
>  kernel/sched_rt.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index ad62677..01f75a5 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -210,11 +210,12 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
>  
>  static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
>  {
> -	int this_cpu = smp_processor_id();
>  	struct task_struct *curr = rq_of_rt_rq(rt_rq)->curr;
>  	struct sched_rt_entity *rt_se;
>  
> -	rt_se = rt_rq->tg->rt_se[this_cpu];
> +	int cpu = cpu_of(rq_of_rt_rq(rt_rq));
> +
> +	rt_se = rt_rq->tg->rt_se[cpu];
>  
>  	if (rt_rq->rt_nr_running) {
>  		if (rt_se && !on_rt_rq(rt_se))
> @@ -226,10 +227,10 @@ static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
>  
>  static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
>  {
> -	int this_cpu = smp_processor_id();
>  	struct sched_rt_entity *rt_se;
> +	int cpu = cpu_of(rq_of_rt_rq(rt_rq));
>  
> -	rt_se = rt_rq->tg->rt_se[this_cpu];
> +	rt_se = rt_rq->tg->rt_se[cpu];
>  
>  	if (rt_se && on_rt_rq(rt_se))
>  		dequeue_rt_entity(rt_se);
> @@ -565,8 +566,11 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
>  			if (rt_rq->rt_time || rt_rq->rt_nr_running)
>  				idle = 0;
>  			raw_spin_unlock(&rt_rq->rt_runtime_lock);
> -		} else if (rt_rq->rt_nr_running)
> +		} else if (rt_rq->rt_nr_running) {
>  			idle = 0;
> +			if (!rt_rq_throttled(rt_rq))
> +				enqueue = 1;
> +		}
>  
>  		if (enqueue)
>  			sched_rt_rq_enqueue(rt_rq);
> 
> -- 
> 	Three Cheers,
> 	Balbir
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
