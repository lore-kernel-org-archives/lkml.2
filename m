Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab1DSJbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:31:48 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57055 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab1DSJbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:31:46 -0400
Date: Tue, 19 Apr 2011 10:31:18 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@kernel.dk>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm/vmalloc: remove block allocation bitmap
Message-ID: <20110419093118.GB23041@csn.ul.ie>
References: <20110414211656.GB1700@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110414211656.GB1700@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 05:16:56PM -0400, Johannes Weiner wrote:
> Space in a vmap block that was once allocated is considered dirty and
> not made available for allocation again before the whole block is
> recycled.
> 
> The result is that free space within a vmap block is always contiguous
> and the allocation bitmap can be replaced by remembering the offset of
> free space in the block.
> 
> The fragmented block purging was never invoked from vb_alloc() either,
> as it skips blocks that do not have enough free space for the
> allocation in the first place.  According to the above, it is
> impossible for a block to have enough free space and still fail the
> allocation.  Thus, this dead code is removed.  Partially consumed
> blocks will be reclaimed anyway when an attempt is made to allocate a
> new vmap block altogether and no free space is found.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Nick Piggin <npiggin@kernel.dk>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Hugh Dickins <hughd@google.com>

I didn't see a problem with the patch per-se but I wonder if your patch
is the intended behaviour. It looks like the intention was that dirty
blocks could be flushed from the TLB and made available for allocations
leading to the possibility of fragmented vmap blocks.

It's this check that is skipping over blocks without taking dirty into
account.

  		spin_lock(&vb->lock);
 		if (vb->free < 1UL << order)
 			goto next;

It was introduced by [02b709d: mm: purge fragmented percpu vmap blocks]
but is there any possibility that this is what should be fixed instead?
Do we know what the consequences of blocks only getting flushed when
they have been fully allocated are?

> <SNIP>

-- 
Mel Gorman
SUSE Labs
