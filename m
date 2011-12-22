Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1LVBJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:09:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1LVBJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:09:21 -0500
Date: Wed, 21 Dec 2011 17:09:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 2/2] mempool: fix first round failure behavior
Message-Id: <20111221170919.f7d49fc6.akpm@linux-foundation.org>
In-Reply-To: <20111222004629.GO9213@google.com>
References: <20111222001800.GL9213@google.com>
	<20111222001939.GM9213@google.com>
	<20111222004629.GO9213@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 16:46:29 -0800
Tejun Heo <tj@kernel.org> wrote:

> mempool modifies gfp_mask so that the backing allocator doesn't try
> too hard or trigger warning message when there's pool to fall back on.
> In addition, for the first try, it removes __GFP_WAIT and IO, so that
> it doesn't trigger reclaim or wait when allocation can be fulfilled
> from pool; however, when that allocation fails and pool is empty too,
> it waits for the pool to be replenished before retrying.
> 
> Allocation which could have succeeded after a bit of reclaim has to
> wait on the reserved items and it's not like mempool doesn't retry
> with __GFP_WAIT and IO.  It just does that *after* someone returns an
> element, pointlessly delaying things.
> 
> Fix it by retrying immediately if the first round of allocation
> attempts w/o __GFP_WAIT and IO fails.

If the pool is empty and the memory allocator is down into its
emergency reserves then we have:

Old behaviour: Wait for someone to return an item, then retry

New behaviour: enable page reclaim in gfp_mask, retry a
               single time then wait for someone to return an item.


So what we can expect to see is that in this low-memory situation,
mempool_alloc() will perform a lot more page reclaim, and more mempool
items will be let loose into the kernel.

I'm not sure what the effects of this will be.  I can't immediately
point at any bad ones.  Probably not much, as the mempool_alloc()
caller will probably be doing other allocations, using the
reclaim-permitting gfp_mask.

But I have painful memories of us (me and Jens, iirc) churning this
code over and over again until it stopped causing problems.  Some were
subtle and nasty.  Much dumpster diving into the pre-git changelogs
should be done before changing it, lest we rediscover long-fixed
problems :(


I have a feeling that if we go for "New behaviour" then the
implementation could be made simpler than this, but laziness
is setting in.

> That said, I still find it a bit unsettling that a GFP_ATOMIC
> allocation which would otherwise succeed may fail when issued through
> mempool.

Spose so.  It would be strange to call mempool_alloc() with GFP_ATOMIC.
Because "wait for an item to be returned" is the whole point of the
thing.

> Maybe the RTTD is clearing __GFP_NOMEMALLOC on retry if the
> gfp requsted by the caller is !__GFP_WAIT && !__GFP_NOMEMALLOC?
> 

What the heck is an RTTD?

> +	/*
> +	 * We use gfp mask w/o __GFP_WAIT or IO for the first round.  If
> +	 * alloc failed with that and @pool was empty, retry immediately.
> +	 */
> +	if (gfp_temp != gfp_mask) {
> +		gfp_temp = gfp_mask;
> +		spin_unlock_irqrestore(&pool->lock, flags);
> +		goto repeat_alloc;
> +	}
> +

Here, have a faster kernel ;)

--- a/mm/mempool.c~mempool-fix-first-round-failure-behavior-fix
+++ a/mm/mempool.c
@@ -227,8 +227,8 @@ repeat_alloc:
 	 * original gfp mask.
 	 */
 	if (gfp_temp != gfp_mask) {
-		gfp_temp = gfp_mask;
 		spin_unlock_irqrestore(&pool->lock, flags);
+		gfp_temp = gfp_mask;
 		goto repeat_alloc;
 	}
 
_

