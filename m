Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab0LHXAC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:00:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756548Ab0LHXAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:00:00 -0500
Message-ID: <4D000DDF.9090300@redhat.com>
Date: Wed, 08 Dec 2010 17:59:43 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>,
        Paul Turner <pjt@google.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
References: <20101202144129.4357fe00@annuminas.surriel.com>	 <20101202144423.3ad1908d@annuminas.surriel.com>	 <1291382619.32004.2124.camel@laptop>  <4CFFC68D.30506@redhat.com> <1291838420.28378.159.camel@laptop>
In-Reply-To: <1291838420.28378.159.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 03:00 PM, Peter Zijlstra wrote:

> Anyway, complete untested and such..

Looks very promising.  I've been making a few changes in the same
direction (except for the fancy CFS bits) and have one way to solve
the one problem you pointed out in your patch.

> +void yield_to(struct task_struct *p)
> +{
...
> +	on_rq = p->se.on_rq;
> +	if (on_rq)
> +		dequeue_task(p_rq, p, 0);
> +
> +	ret = 0;
> +	if (p->sched_class == curr->sched_class&&  curr->sched_class->yield_to)
> +		curr->sched_class->yield_to(p);
> +
> +	if (on_rq)
> +		enqueue_task(p_rq, p, 0);

> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index c886717..8689bcd 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c

> +static void yield_to_fair(struct task_stuct *p)
> +{
> +	struct sched_entity *se =&current->se;
> +	struct sched_entity *p_se =&p->se;
> +	u64 lag0, p_lag0;
> +	s64 lag, p_lag;
> +
> +	lag0 = avg_vruntime(cfs_rq_of(se));
> +	p_lag0 = avg_vruntime(cfs_rq_of(p_se));
> +
> +	lag = se->vruntime - avg_vruntime(cfs_rq);
> +	p_lag = p_se->vruntime - avg_vruntime(p_cfs_rq);
> +
> +	if (p_lag>  lag) { /* if P is owed less service */
> +		se->vruntime = lag0 + p_lag;
> +		p_se->vruntime = p_lag + lag;
> +	}
> +
> +	/*
> +	 * XXX try something smarter here
> +	 */
> +	resched_task(p);
> +	resched_task(current);
> +}

If we do the dequeue_task and enqueue_task here, we can use
check_preempt_curr in yield_to_fair.

Alternatively, we can do the rescheduling from the main
yield_to function, not from yield_to_fair, by calling
check_preempt_curr on p and current after p has been
enqueued.

-- 
All rights reversed
