Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab2DJPwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:52:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7261 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054Ab2DJPwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:52:11 -0400
X-Authority-Analysis: v=2.0 cv=T5EOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=hzoqAax4KOoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=FIcwm6BZTl3EgIBhKX0A:9 a=sQOqe1Mv0rP-zYQuevwA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334073127.23924.213.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH]sched_rt.c: Avoid unnecessary dequeue and enqueue of
 pushable tasks in set_cpus_allowed_rt()
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Date: Tue, 10 Apr 2012 11:52:07 -0400
In-Reply-To: <944171329661049@web81.yandex.ru>
References: <1322774765.8386.2.camel@hp>
	 <20120213172316.GA24145@home.goodmis.org> <944171329661049@web81.yandex.ru>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-19 at 18:17 +0400, Kirill Tkhai wrote:
> ---
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 3640ebb..bf48343 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1779,43 +1779,36 @@ static void set_cpus_allowed_rt(struct task_struct *p,
>  				const struct cpumask *new_mask)
>  {
>  	int weight = cpumask_weight(new_mask);

Lets move the assignment of weight down. Gcc may optimize, but I don't
want to rely on it.

> +	struct rq *rq;
>  
>  	BUG_ON(!rt_task(p));
>  
>  	/*
> -	 * Update the migration status of the RQ if we have an RT task
> -	 * which is running AND changing its weight value.
> +	 * Just exit if it's not necessary to change migration status

Let's comment this better. Something like:

	Only update if the process changes its state from whether it
	can migrate or not.


>  	 */
> -	if (p->on_rq && (weight != p->rt.nr_cpus_allowed)) {
> -		struct rq *rq = task_rq(p);
> -
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
> +	if ((p->rt.nr_cpus_allowed > 1) == (weight > 1))
> +		return;
>  
> -		}
> +	if (!p->on_rq)
> +		return;

Make the on_rq check first, and move the weight calculation below it.
Why calculate the weight if we don't plan on doing anything with it?

>  
> -		if ((p->rt.nr_cpus_allowed <= 1) && (weight > 1)) {
> -			rq->rt.rt_nr_migratory++;
> -		} else if ((p->rt.nr_cpus_allowed > 1) && (weight <= 1)) {
> -			BUG_ON(!rq->rt.rt_nr_migratory);
> -			rq->rt.rt_nr_migratory--;
> -		}
> +	rq = task_rq(p);
>  
> -		update_rt_migration(&rq->rt);
> +	/*
> +	 * Several cpus were allowed but now it's not so OR vice versa

I rather say:

	The process use to be able to migrate OR it can now migrate

Otherwise, the patch looks good.

Thanks,

-- Steve

P.S. I don't have any more trips in the near future, so I should be much
quicker in my responses ;-)



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


