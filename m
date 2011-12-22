Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1LVQo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:44:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab1LVQo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:44:27 -0500
Date: Thu, 22 Dec 2011 17:39:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: + mempool-fix-first-round-failure-behavior.patch added to -mm
	tree
Message-ID: <20111222163900.GA1448@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> For the initial allocation, mempool passes modified gfp mask to the
> backing allocator so that it doesn't try too hard when there are reserved
> elements waiting in the pool; however, when that allocation fails and pool
> is empty too, it either waits for the pool to be replenished before
> retrying or fails if !__GFP_WAIT.
>
> * If the caller was calling in with GFP_ATOMIC, it never gets to try
>   emergency reserve.  Allocations which would have succeeded without
>   mempool may fail, which is just wrong.
>
> * Allocation which could have succeeded after a bit of reclaim now has
>   to wait on the reserved items and it's not like mempool doesn't retry
>   with the original gfp mask.  It just does that *after* someone returns
>   an element, pointlessly delaying things.
>
> Fix it by retrying immediately with the gfp mask requested by the caller
> if the first round of allocation attempts fails with modified mask.

I can't even explain why this (simple!) logic looks confusing to me,
with or without the patch. A couple of questions:

	1. Why do we remove __GFP_WAIT unconditionally before the the
	   very 1st allocation?

	2. Why do we always restore it after io_schedule(), even if
	   we have the reserved items?

IOW, what do you think about the patch below instead?

Oleg.

--- x/mm/mempool.c
+++ x/mm/mempool.c
@@ -212,10 +212,12 @@ void * mempool_alloc(mempool_t *pool, gf
 	gfp_mask |= __GFP_NORETRY;	/* don't loop in __alloc_pages */
 	gfp_mask |= __GFP_NOWARN;	/* failures are OK */
 
-	gfp_temp = gfp_mask & ~(__GFP_WAIT|__GFP_IO);
-
 repeat_alloc:
 
+	gfp_temp = gfp_mask;
+	if (pool->curr_nr)
+		gfp_temp &= ~(__GFP_WAIT|__GFP_IO);
+
 	element = pool->alloc(gfp_temp, pool->pool_data);
 	if (likely(element != NULL))
 		return element;
@@ -229,13 +231,15 @@ repeat_alloc:
 	}
 
 	/* We must not sleep in the GFP_ATOMIC case */
-	if (!(gfp_mask & __GFP_WAIT)) {
+	if (!(gfp_temp & __GFP_WAIT)) {
 		spin_unlock_irqrestore(&pool->lock, flags);
+		/* raced with another mempool_alloc? */
+		if (gfp_mask & __GFP_WAIT)
+			goto repeat_alloc;
 		return NULL;
 	}
 
 	/* Let's wait for someone else to return an element to @pool */
-	gfp_temp = gfp_mask;
 	init_wait(&wait);
 	prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
 

