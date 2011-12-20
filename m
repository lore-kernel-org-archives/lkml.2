Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab1LTBih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:38:37 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:59961 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1LTBie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:38:34 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 2/4] sched: Adding gang scheduling infrastrucure
In-Reply-To: <1324309904.24621.15.camel@twins>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219083424.32311.23559.stgit@abhimanyu.in.ibm.com> <1324309904.24621.15.camel@twins>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Tue, 20 Dec 2011 07:09:29 +0530
Message-ID: <87ehw02f8u.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11121916-3568-0000-0000-000000E971CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011 16:51:44 +0100, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-12-19 at 14:04 +0530, Nikunj A. Dadhania wrote:
> 
> > +	raw_spin_lock_irqsave(&rq->lock, flags);
> > +
> > +	/* Check if the runqueue has runnable tasks */
> > +	if (cfs_rq->nr_running) {
> > +		/* Favour this task group and set need_resched flag,
> > +		 * added by following patches */
> 
> That's just plain insanity, patch 3 is all of 4 lines, why split that
> and have an incomplete patch here?
> 
I will fold that in this patch.

> > +	}
> > +	raw_spin_unlock_irqrestore(&rq->lock, flags);
> > +}
> > +
> > +#define GANG_SCHED_GRANULARITY 8
> 
> Why have this magical number to begin with?
> 
We do not want to gang across the complete machine say 128cpus. Break it
to 16 independent gang. So that way we can scale up. 

This can be a sysctl or architecture specific define.

> > +void gang_sched(struct task_group *tg, struct rq *rq)
> > +{
> > +	/* We do not gang sched here */
> > +	if (rq->gang_leader == 0 || !tg || tg->gang == 0)
> > +		return;
> > +
> > +	/* Yes thats the leader */
> > +	if (rq->gang_leader == 1) {
> > +
> > +		if (!in_interrupt() && !irqs_disabled()) {
> 
> How can this ever happen, schedule() can't be called from interrupt
> context and post_schedule() ensures interrupts are enabled.
> 
Ah... thought that schedule can get called from interrupt
context. Sometime back I had some crash without this, let me remove this
and check it.

And smp_call_function_many required that, so those conditions. From the
function header;

 * You must not call this function with disabled interrupts or from a
 * hardware interrupt handler or from a bottom half handler. Preemption
 * must be disabled when calling this function.
 */

> > +			smp_call_function_many(rq->gang_cpumask,
> > +					gang_sched_member, tg, 0);
> 
> See this is just not going to happen..
> 
Why do you say that? I had trace functions in my debug code and I was
hitting gang_sched_member on the other cpus.

> > +
> > +		for_each_domain(cpu_of(rq), sd) {
> > +			count = 0;
> > +			for_each_cpu(i, sched_domain_span(sd))
> > +				count++;
> 
> That's just incompetent; there's cpumask_weight(), also that's called
> sd->span_weight.
> 
Let me go and check that out, will use them. It will definitely reduce
the code here.

Regards
Nikunj

