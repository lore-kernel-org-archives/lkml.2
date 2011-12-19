Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab1LSPvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:51:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45635 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab1LSPvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:51:51 -0500
Message-ID: <1324309904.24621.15.camel@twins>
Subject: Re: [RFC PATCH 2/4] sched: Adding gang scheduling infrastrucure
From: Peter Zijlstra <peterz@infradead.org>
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Date: Mon, 19 Dec 2011 16:51:44 +0100
In-Reply-To: <20111219083424.32311.23559.stgit@abhimanyu.in.ibm.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
	 <20111219083424.32311.23559.stgit@abhimanyu.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-19 at 14:04 +0530, Nikunj A. Dadhania wrote:

> +static void gang_sched_member(void *info)
> +{
> +	struct task_group *tg = (struct task_group *) info;
> +	struct cfs_rq *cfs_rq;
> +	struct rq *rq;
> +	int cpu;
> +	unsigned long flags;
> +
> +	cpu  = smp_processor_id();
> +	cfs_rq = tg->cfs_rq[cpu];
> +	rq = cfs_rq->rq;
> +
> +	raw_spin_lock_irqsave(&rq->lock, flags);
> +
> +	/* Check if the runqueue has runnable tasks */
> +	if (cfs_rq->nr_running) {
> +		/* Favour this task group and set need_resched flag,
> +		 * added by following patches */

That's just plain insanity, patch 3 is all of 4 lines, why split that
and have an incomplete patch here?

> +	}
> +	raw_spin_unlock_irqrestore(&rq->lock, flags);
> +}
> +
> +#define GANG_SCHED_GRANULARITY 8

Why have this magical number to begin with?

> +void gang_sched(struct task_group *tg, struct rq *rq)
> +{
> +	/* We do not gang sched here */
> +	if (rq->gang_leader == 0 || !tg || tg->gang == 0)
> +		return;
> +
> +	/* Yes thats the leader */
> +	if (rq->gang_leader == 1) {
> +
> +		if (!in_interrupt() && !irqs_disabled()) {

How can this ever happen, schedule() can't be called from interrupt
context and post_schedule() ensures interrupts are enabled.

> +			smp_call_function_many(rq->gang_cpumask,
> +					gang_sched_member, tg, 0);

See this is just not going to happen..

> +			rq->gang_schedule = 0;
> +		}
> +
> +	} else {
> +		/*
> +		 * find the gang leader according to the span,
> +		 * currently we have it as 8cpu, this can be made
> +		 * dynamic
> +		 */
> +		struct sched_domain *sd;
> +		unsigned int count;
> +		int i;
> +
> +		for_each_domain(cpu_of(rq), sd) {
> +			count = 0;
> +			for_each_cpu(i, sched_domain_span(sd))
> +				count++;

That's just incompetent; there's cpumask_weight(), also that's called
sd->span_weight.

> +			if (count >= GANG_SCHED_GRANULARITY)
> +				break;
> +		}
> +
> +		if (sd && cpu_of(rq) == domain_first_cpu(sd)) {
> +			printk(KERN_INFO "Selected CPU %d as gang leader\n",
> +				cpu_of(rq));
> +			rq->gang_leader = 1;
> +			rq->gang_cpumask = sched_domain_span(sd);
> +		} else if (sd) {
> +			/*
> +			 * A fellow cpu, it will receive gang
> +			 * initiations from the gang leader now
> +			 */
> +			rq->gang_leader = 0;
> +		}
> +	}
> +}
