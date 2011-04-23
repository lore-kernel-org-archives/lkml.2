Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab1DWCIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 22:08:52 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:47460 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143Ab1DWCIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 22:08:51 -0400
Date: Sat, 23 Apr 2011 04:08:35 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@kernel.dk>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm/vmalloc: remove block allocation bitmap
Message-ID: <20110423020835.GM2333@cmpxchg.org>
References: <20110414211656.GB1700@cmpxchg.org>
 <20110419093118.GB23041@csn.ul.ie>
 <20110419233905.GA2333@cmpxchg.org>
 <20110420094647.GB1306@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420094647.GB1306@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 10:46:47AM +0100, Mel Gorman wrote:
> On Wed, Apr 20, 2011 at 01:39:05AM +0200, Johannes Weiner wrote:
> > On Tue, Apr 19, 2011 at 10:31:18AM +0100, Mel Gorman wrote:
> > > On Thu, Apr 14, 2011 at 05:16:56PM -0400, Johannes Weiner wrote:
> > > > Space in a vmap block that was once allocated is considered dirty and
> > > > not made available for allocation again before the whole block is
> > > > recycled.
> > > > 
> > > > The result is that free space within a vmap block is always contiguous
> > > > and the allocation bitmap can be replaced by remembering the offset of
> > > > free space in the block.
> > > > 
> > > > The fragmented block purging was never invoked from vb_alloc() either,
> > > > as it skips blocks that do not have enough free space for the
> > > > allocation in the first place.  According to the above, it is
> > > > impossible for a block to have enough free space and still fail the
> > > > allocation.  Thus, this dead code is removed.  Partially consumed
> > > > blocks will be reclaimed anyway when an attempt is made to allocate a
> > > > new vmap block altogether and no free space is found.
> > > > 
> > > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > > > Cc: Nick Piggin <npiggin@kernel.dk>
> > > > Cc: Mel Gorman <mel@csn.ul.ie>
> > > > Cc: Hugh Dickins <hughd@google.com>
> > > 
> > > I didn't see a problem with the patch per-se but I wonder if your patch
> > > is the intended behaviour. It looks like the intention was that dirty
> > > blocks could be flushed from the TLB and made available for allocations
> > > leading to the possibility of fragmented vmap blocks.
> > >
> > > It's this check that is skipping over blocks without taking dirty into
> > > account.
> > > 
> > >   		spin_lock(&vb->lock);
> > >  		if (vb->free < 1UL << order)
> > >  			goto next;
> > > 
> > > It was introduced by [02b709d: mm: purge fragmented percpu vmap blocks]
> > > but is there any possibility that this is what should be fixed instead?
> > 
> > I would like to emphasize that the quoted check only made it clear
> > that the allocation bitmap is superfluous.  There is no partial
> > recycling of a block with live allocations, not even before this
> > commit.
> 
> You're right in that the allocation bitmap does look superfluous. I was
> wondering if it was meant to be doing something useful.

Ok, just wanted to make sure we are on the same page.

> > Theoretically, we could end up with all possible vmap blocks being
> > pinned by single allocations with most of their area being dirty and
> > not reusable.  But I believe this is unlikely to happen.
> > 
> > Would you be okay with printing out block usage statistics on
> > allocation errors for the time being, so we can identify this case if
> > problems show up?
> 
> It'd be interesting but for the purposes of this patch I think it
> would be more useful to see the results of some benchmark that is vmap
> intensive. Something directory intensive running on XFS should do the
> job just to confirm no regression, right? A profile might indicate
> how often we end up scanning the full list, finding it dirty and
> calling new_vmap_block but even if something odd showed up there,
> it would be a new patch.

Ok, I am still a bit confused.  You say 'regression' in the overall
flow of vmap block allocation, but my patch does not change that.
Which kernel versions do you want to have compared?

Profiling the algorithm in general sounds like a good idea and I shall
give it a go.

> > And consider this patch an optimization/simplification of a status quo
> > that does not appear problematic?  We can still revert it and
> > implement live block recycling when it turns out to be necessary.
> 
> I see no problem with your patch so;
> 
> Acked-by: Mel Gorman <mel@csn.ul.ie>

Thanks!

	Hannes
