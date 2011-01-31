Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab1AaLqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:46:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54079 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab1AaLqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:46:43 -0500
Subject: Re: [RFC -v7 PATCH 3/7] sched: use a buddy to implement
 yield_task_fair
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, "Nakajima, Jun" <jun.nakajima@intel.com>
In-Reply-To: <20110126172101.7b5c22e6@annuminas.surriel.com>
References: <20110126165657.2ddd2ac9@annuminas.surriel.com>
	 <20110126172101.7b5c22e6@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 Jan 2011 12:47:27 +0100
Message-ID: <1296474447.15234.392.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 17:21 -0500, Rik van Riel wrote:

> +static struct sched_entity *__pick_second_entity(struct cfs_rq *cfs_rq)
> +{
> +	struct rb_node *left = cfs_rq->rb_leftmost;
> +	struct rb_node *second;
> +
> +	if (!left)
> +		return NULL;
> +
> +	second = rb_next(left);
> +
> +	if (!second)
> +		second = left;
> +
> +	return rb_entry(second, struct sched_entity, run_node);
> +}

I would still prefer:

sed -i 's/__pick_next_entity/__pick_first_entity/g' kernel/sched*.[ch]

and

static struct sched_entity *__pick_next_entity(struct sched_entity *se)
{
	struct rb_node *next = rb_next(&se->run_node);

	if (!next)
		return NULL;

	return rb_entry(next, struct sched_entity, run_node);
}

Its simpler and more versatile.

>  static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
>  {
>  	struct sched_entity *se = __pick_next_entity(cfs_rq);
>  	struct sched_entity *left = se;
>  
> -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
> -		se = cfs_rq->next;
> +	/*
> +	 * Avoid running the skip buddy, if running something else can
> +	 * be done without getting too unfair.
> +	 */
> +	if (cfs_rq->skip == se) {
> +		struct sched_entity *second = __pick_second_entity(cfs_rq);

which then becomes *next = __pick_next_entity(se);

> +		if (wakeup_preempt_entity(second, left) < 1)

oops when !second. (!next)

> +			se = second;
> +	}

> -/*
> - * sched_yield() support is very simple - we dequeue and enqueue.
> - *
> - * If compat_yield is turned on then we requeue to the end of the tree.
> - */
> -static void yield_task_fair(struct rq *rq)
> -{
> -	struct task_struct *curr = rq->curr;
> -	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
> -	struct sched_entity *rightmost, *se = &curr->se;
> -
> -	/*
> -	 * Are we the only task in the tree?
> -	 */
> -	if (unlikely(rq->nr_running == 1))
> -		return;
> -
> -	clear_buddies(cfs_rq, se);
> -
> -	if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
> -		update_rq_clock(rq);
> -		/*
> -		 * Update run-time statistics of the 'current'.
> -		 */
> -		update_curr(cfs_rq);
> -
> -		return;
> -	}
> -	/*
> -	 * Find the rightmost entry in the rbtree:
> -	 */
> -	rightmost = __pick_last_entity(cfs_rq);
> -	/*
> -	 * Already in the rightmost position?
> -	 */
> -	if (unlikely(!rightmost || entity_before(rightmost, se)))
> -		return;
> -
> -	/*
> -	 * Minimally necessary key value to be last in the tree:
> -	 * Upon rescheduling, sched_class::put_prev_task() will place
> -	 * 'current' within the tree based on its new key value.
> -	 */
> -	se->vruntime = rightmost->vruntime + 1;
> -}

You seem to have lost the hunk removing sysctl_sched_compat_yield from
kernel/sysctl.c :-)

