Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab1LVBXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:23:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45661 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1LVBXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:23:17 -0500
Date: Wed, 21 Dec 2011 17:23:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 2/2] mempool: fix first round failure behavior
Message-ID: <20111222012312.GP9213@google.com>
References: <20111222001800.GL9213@google.com>
 <20111222001939.GM9213@google.com>
 <20111222004629.GO9213@google.com>
 <20111221170919.f7d49fc6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221170919.f7d49fc6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Wed, Dec 21, 2011 at 05:09:19PM -0800, Andrew Morton wrote:
> If the pool is empty and the memory allocator is down into its
> emergency reserves then we have:
> 
> Old behaviour: Wait for someone to return an item, then retry
> 
> New behaviour: enable page reclaim in gfp_mask, retry a
>                single time then wait for someone to return an item.
> 
> So what we can expect to see is that in this low-memory situation,
> mempool_alloc() will perform a lot more page reclaim, and more mempool
> items will be let loose into the kernel.
> 
> I'm not sure what the effects of this will be.  I can't immediately
> point at any bad ones.  Probably not much, as the mempool_alloc()
> caller will probably be doing other allocations, using the
> reclaim-permitting gfp_mask.
> 
> But I have painful memories of us (me and Jens, iirc) churning this
> code over and over again until it stopped causing problems.  Some were
> subtle and nasty.  Much dumpster diving into the pre-git changelogs
> should be done before changing it, lest we rediscover long-fixed
> problems :(

I see.  It just seemed like a weird behavior and looking at the commit
log, there was originally code to kick reclaim there, so the sequence
made sense - first try w/o reclaim, look at the mempool, kick reclaim
and retry w/ GFP_WAIT and then wait for someone else to free.  That
part was removed by 20a77776c24 "[PATCH] mempool: simplify alloc" back
in 05.  In the process, it also lost retry w/ reclaim before waiting
for mempool reserves.

I was trying to add percpu mempool and this bit me as percpu allocator
can't to NOIO and the above delayed retry logic ended up adding random
5s delay (or until the next free).

> > That said, I still find it a bit unsettling that a GFP_ATOMIC
> > allocation which would otherwise succeed may fail when issued through
> > mempool.
> 
> Spose so.  It would be strange to call mempool_alloc() with GFP_ATOMIC.
> Because "wait for an item to be returned" is the whole point of the
> thing.

Yeah but the pool can be used from multiple code paths and I think it
plausible to use it that way and expect at least the same or better
alloc behavior as not using mempool.  Eh... this doesn't really affect
correctness, so not such a big deal but still weird.

> > Maybe the RTTD is clearing __GFP_NOMEMALLOC on retry if the
> > gfp requsted by the caller is !__GFP_WAIT && !__GFP_NOMEMALLOC?
> 
> What the heck is an RTTD?

Right thing to do?  Hmmm... I thought other people were using it too.
It's quite possible that I just dreamed it up tho.

> > +	/*
> > +	 * We use gfp mask w/o __GFP_WAIT or IO for the first round.  If
> > +	 * alloc failed with that and @pool was empty, retry immediately.
> > +	 */
> > +	if (gfp_temp != gfp_mask) {
> > +		gfp_temp = gfp_mask;
> > +		spin_unlock_irqrestore(&pool->lock, flags);
> > +		goto repeat_alloc;
> > +	}
> > +
> 
> Here, have a faster kernel ;)

;)

Thanks.

-- 
tejun
