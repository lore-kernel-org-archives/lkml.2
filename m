Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1BAPvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:51:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:47625 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab1BAPvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:51:15 -0500
Subject: Re: [PATCH -v8a 4/7] sched: Add yield_to(task, preempt)
 functionality
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
In-Reply-To: <20110201095051.4ddb7738@annuminas.surriel.com>
References: <20110201094433.72829892@annuminas.surriel.com>
	 <20110201095051.4ddb7738@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 01 Feb 2011 16:52:02 +0100
Message-ID: <1296575522.26581.210.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 09:50 -0500, Rik van Riel wrote:

> +/**
> + * yield_to - yield the current processor to another thread in
> + * your thread group, or accelerate that thread toward the
> + * processor it's on.
> + *
> + * It's the caller's job to ensure that the target task struct
> + * can't go away on us before we can do any checks.
> + *
> + * Returns true if we indeed boosted the target task.
> + */
> +bool __sched yield_to(struct task_struct *p, bool preempt)
> +{
> +	struct task_struct *curr = current;
> +	struct rq *rq, *p_rq;
> +	unsigned long flags;
> +	bool yielded = 0;
> +
> +	local_irq_save(flags);
> +	rq = this_rq();
> +
> +again:
> +	p_rq = task_rq(p);
> +	double_rq_lock(rq, p_rq);
> +	while (task_rq(p) != p_rq) {
> +		double_rq_unlock(rq, p_rq);
> +		goto again;
> +	}
> +
> +	if (!curr->sched_class->yield_to_task)
> +		goto out;
> +
> +	if (curr->sched_class != p->sched_class)
> +		goto out;
> +
> +	if (task_running(p_rq, p) || p->state)
> +		goto out;
> +
> +	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
> +
> +	if (yielded) {
> +		schedstat_inc(rq, yld_count);
> +		current->sched_class->yield_task(rq);
> +	}

We can avoid this second indirect function call by

> +
> +out:
> +	double_rq_unlock(rq, p_rq);
> +	local_irq_restore(flags);
> +
> +	if (yielded)
> +		schedule();
> +
> +	return yielded;
> +}
> +EXPORT_SYMBOL_GPL(yield_to);


> +static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preempt)
> +{
> +	struct sched_entity *se = &p->se;
> +
> +	if (!se->on_rq)
> +		return false;
> +
> +	/* Tell the scheduler that we'd really like pse to run next. */
> +	set_next_buddy(se);
> +
> +	/* Make p's CPU reschedule; pick_next_entity takes care of fairness. */
> +	if (preempt)
> +		resched_task(rq->curr);

calling: yield_task_fair(rq); here.

> +	return true;
> +}


I'll make that change on commit.
