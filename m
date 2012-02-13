Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab2BMRXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:23:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62530 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab2BMRXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:23:20 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=wom5GMh1gUkA:10 a=hzoqAax4KOoA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=auprABb9FrqYKwN20m4A:9 a=Hft9JkaGdzxrXyazHzUA:7 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Date: Mon, 13 Feb 2012 12:23:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH]sched_rt.c: Avoid unnecessary dequeue and enqueue of
 pushable tasks in set_cpus_allowed_rt()
Message-ID: <20120213172316.GA24145@home.goodmis.org>
References: <1322774765.8386.2.camel@hp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322774765.8386.2.camel@hp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wasn't on the Cc of the original message, but it was bounced to me
awhile ago. I'm cleaning out my email and came across it.

Can you send me the latest version of this patch, either against latest
Linus, or against tip/master.

Thanks,

-- Steve

P.S. I'll be at ELC this week so it may not get processed right away.


On Fri, Dec 02, 2011 at 01:26:05AM +0400, Kirill Tkhai wrote:
> [PATCH]sched_rt.c: Avoid unnecessary dequeue and enqueue of pushable
> tasks in set_cpus_allowed_rt()
> 
> Migration status depends on a difference of weight from 0 and 1. If
> weight > 1 (<= 1) and old weight <= 1 (> 1) then task becomes pushable
> (not pushable). We are not insterested in exact values of it, is it 3 or
> 4, for example.
> 
> Now if we are changing affinity from a set of 3 cpus to a set of 4, the
> task will be dequeued and enqueued sequentially without important
> difference in comparison with initial state. The only difference is in
> internal representation of plist queue of pushable tasks and the fact
> that the task may won't be the first in a sequence of the same priority
> tasks. But it seems to me it gives nothing.
> 
> Signed-off-by: Tkhai Kirill <tkhai@yandex.ru>
> 
> --- kernel/sched_rt.c.orig	2011-12-02 00:29:11.970243145 +0400
> +++ kernel/sched_rt.c	2011-12-02 00:37:43.622846606 +0400
> @@ -1572,43 +1572,37 @@ static void set_cpus_allowed_rt(struct t
>  				const struct cpumask *new_mask)
>  {
>  	int weight = cpumask_weight(new_mask);
> +	struct rq *rq;
>  
>  	BUG_ON(!rt_task(p));
>  
>  	/*
> -	 * Update the migration status of the RQ if we have an RT task
> -	 * which is running AND changing its weight value.
> +	 * Just exit if it's not necessary to change migration status
>  	 */
> -	if (p->on_rq && (weight != p->rt.nr_cpus_allowed)) {
> -		struct rq *rq = task_rq(p);
> +	if ((p->rt.nr_cpus_allowed <= 1 && weight <= 1)
> +		|| (p->rt.nr_cpus_allowed > 1 && weight > 1))
> +		return;
>  
> -		if (!task_current(rq, p)) {
> -			/*
> -			 * Make sure we dequeue this task from the pushable list
> -			 * before going further.  It will either remain off of
> -			 * the list because we are no longer pushable, or it
> -			 * will be requeued.
> -			 */
> -			if (p->rt.nr_cpus_allowed > 1)
> -				dequeue_pushable_task(rq, p);
> -
> -			/*
> -			 * Requeue if our weight is changing and still > 1
> -			 */
> -			if (weight > 1)
> -				enqueue_pushable_task(rq, p);
> -
> -		}
> -
> -		if ((p->rt.nr_cpus_allowed <= 1) && (weight > 1)) {
> -			rq->rt.rt_nr_migratory++;
> -		} else if ((p->rt.nr_cpus_allowed > 1) && (weight <= 1)) {
> -			BUG_ON(!rq->rt.rt_nr_migratory);
> -			rq->rt.rt_nr_migratory--;
> -		}
> +	if (!p->on_rq)
> +		return;
>  
> -		update_rt_migration(&rq->rt);
> +	rq = task_rq(p);
> +
> +	/*
> +	 * Several cpus were allowed but now it's not so OR vice versa
> +	 */
> +	if (weight <= 1) {
> +		if (!task_current(rq, p))
> +			dequeue_pushable_task(rq, p);
> +		BUG_ON(!rq->rt.rt_nr_migratory);
> +		rq->rt.rt_nr_migratory--;
> +	} else {
> +		if (!task_current(rq, p))
> +			enqueue_pushable_task(rq, p);
> +		rq->rt.rt_nr_migratory++;
>  	}
> +
> +	update_rt_migration(&rq->rt);
>  }
>  
>  /* Assumes rq->lock is held */
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
