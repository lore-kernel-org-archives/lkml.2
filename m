Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab2FNOcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:32:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17410 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2FNOcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:32:04 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Pk-anzhfY00A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=vPFr32TSczNc_ThjeC4A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339684321.13377.215.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH 2/4] sched: Push put_prev_task() into
 pick_next_task()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, pjt@google.com, venki@google.com, efault@gmx.de,
        glommer@parallels.com, linux-kernel@vger.kernel.org
Date: Thu, 14 Jun 2012 10:32:01 -0400
In-Reply-To: <20120614133212.690691207@chello.nl>
References: <20120614132902.800827488@chello.nl>
	 <20120614133212.690691207@chello.nl>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 15:29 +0200, Peter Zijlstra wrote:


> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3176,7 +3176,7 @@ static void put_prev_task(struct rq *rq,
>   * Pick up the highest-prio task:
>   */
>  static inline struct task_struct *
> -pick_next_task(struct rq *rq)
> +pick_next_task(struct rq *rq, struct task_struct *prev)
>  {
>  	const struct sched_class *class;
>  	struct task_struct *p;
> @@ -3186,13 +3186,13 @@ pick_next_task(struct rq *rq)
>  	 * the fair class we can call that function directly:
>  	 */
>  	if (likely(rq->nr_running == rq->cfs.h_nr_running)) {
> -		p = fair_sched_class.pick_next_task(rq);
> +		p = fair_sched_class.pick_next_task(rq, prev);
>  		if (likely(p))
>  			return p;
>  	}
>  
>  	for_each_class(class) {
> -		p = class->pick_next_task(rq);
> +		p = class->pick_next_task(rq, prev);
>  		if (p)
>  			return p;
>  	}
> @@ -3253,8 +3253,9 @@ static void __sched __schedule(void)
>  	if (unlikely(!rq->nr_running))
>  		idle_balance(cpu, rq);
>  
> -	put_prev_task(rq, prev);

You remove the call to put_prev_task() which looks to be the only user
of this static function. But I don't see the deletion of this function.

-- Steve

> -	next = pick_next_task(rq);
> +	if (prev->on_rq || rq->skip_clock_update < 0)
> +		update_rq_clock(rq);
> +	next = pick_next_task(rq, prev);
>  	clear_tsk_need_resched(prev);
>  	rq->skip_clock_update = 0;
>  
> @@ -5200,7 +5201,7 @@ static void migrate_tasks(unsigned int d
>  		if (rq->nr_running == 1)
>  			break;
>  
> -		next = pick_next_task(rq);
> +		next = pick_next_task(rq, NULL);
>  		BUG_ON(!next);
>  		next->sched_class->put_prev_task(rq, next);
>  


