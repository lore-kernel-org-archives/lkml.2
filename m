Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1LUPB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:01:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab1LUPBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:01:24 -0500
Date: Wed, 21 Dec 2011 15:55:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-3.3] mempool: clean up and document synchronization
	and memory barrier usage
Message-ID: <20111221145556.GA25657@redhat.com>
References: <20111220221818.GJ10752@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220221818.GJ10752@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20, Tejun Heo wrote:
>
> For #1, The only necessary condition is that curr_nr visible at free
> is from after the allocation of the element being freed (details in
> the comment).  For most cases, this is true without any barrier but
> there can be fringe cases where the allocated pointer is passed to the
> freeing task without going through memory barriers.  To cover this
> case, wmb is necessary before returning from allocation and rmb is
> necessary before reading curr_nr.  IOW,
>
> 	ALLOCATING TASK			FREEING TASK
>
> 	update pool state after alloc;
> 	wmb();
> 	pass pointer to freeing task;
> 					read pointer;
> 					rmb();
> 					read pool state to free;
>
> The wmb can be the implied one from unlocking pool->lock and smp_mb()
> in mempool_free() can be replaced with smp_rmb().

OK... I do not know if this is the bug or not, but I agree this race
is possible.

> Furthermore, mempool_alloc() is already holding pool->lock when it
> decides that it needs to wait.  There is no reason to do unlock - add
> waitqueue - test condition again.  It can simply add itself to
> waitqueue while holding pool->lock and then unlock and sleep.

Confused. I agree, we can hold pool->lock until schedule(). But, at
the same time, why should we hold it?

Or I missed the reason why we must not unlock before prepare_to_wait?

> --- work.orig/mm/mempool.c
> +++ work/mm/mempool.c
> @@ -223,29 +223,31 @@ repeat_alloc:
>  	spin_lock_irqsave(&pool->lock, flags);
>  	if (likely(pool->curr_nr)) {
>  		element = remove_element(pool);
> +		/* implied wmb in unlock is faired with rmb in mempool_free() */
>  		spin_unlock_irqrestore(&pool->lock, flags);

Not really afaics. unlock() doesn't imply wmb().

So, if some thread does PTR = mempool_alloc(), the "final" store to PTR
can leak into the critical section, and it can be reordered inside this
section with --curr_nr.

See the fat comment about set_current_state() in prepare_to_wait().

> @@ -265,7 +267,39 @@ void mempool_free(void *element, mempool
>  	if (unlikely(element == NULL))
>  		return;
>  
> -	smp_mb();
> +	/*
> +	 * Paired with implied wmb of @pool->lock in mempool_alloc().  The
> +	 * preceding read is for @element and the following @pool->curr_nr.
> +	 * This ensures that the visible value of @pool->curr_nr is from
> +	 * after the allocation of @element.  This is necessary for fringe
> +	 * cases where @element was passed to this task without going
> +	 * through barriers.
> +	 *
> +	 * For example, assume @p is %NULL at the beginning and one task
> +	 * performs "p = mempool_alloc(...);" while another task is doing
> +	 * "while (!p) cpu_relax(); mempool_free(p, ...);".  This function
> +	 * may end up using curr_nr value which is from before allocation
> +	 * of @p without the following rmb.
> +	 */
> +	smp_rmb();
> +
> +	/*
> +	 * For correctness, we need a test which is guaranteed to trigger
> +	 * if curr_nr + #allocated == min_nr.  Testing curr_nr < min_nr
> +	 * without locking achieves that and refilling as soon as possible
> +	 * is desirable.
> +	 *
> +	 * Because curr_nr visible here is always a value after the
> +	 * allocation of @element, any task which decremented curr_nr below
> +	 * min_nr is guaranteed to see curr_nr < min_nr unless curr_nr gets
> +	 * incremented to min_nr afterwards.  If curr_nr gets incremented
> +	 * to min_nr after the allocation of @element, the elements
> +	 * allocated after that are subject to the same guarantee.
> +	 *
> +	 * Waiters happen iff curr_nr is 0 and the above guarantee also
> +	 * ensures that there will be frees which return elements to the
> +	 * pool waking up the waiters.
> +	 */
>  	if (pool->curr_nr < pool->min_nr) {
>  		spin_lock_irqsave(&pool->lock, flags);
>  		if (pool->curr_nr < pool->min_nr) {

Just to check my understanding...

IOW. Whatever we do, we can race with other threads and miss "curr_nr < min_nr"
condition. But this is fine, unless this element (which we are going to free)
was the reason for this condition. Otherwise we can rely on another mempool_free(),
the waiters in mempool_alloc() can never hang forever.

Yes, I think this is right.

Oleg.

