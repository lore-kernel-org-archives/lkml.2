Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab0DMCMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 22:12:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:37974 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511Ab0DMCMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 22:12:42 -0400
Subject: Re: [PATCH 07/13] powerpc: Preemptible mmu_gather
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <1270800847.20295.3225.camel@laptop>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.901224587@chello.nl>  <20100409040756.GK5683@laptop>
	 <1270800847.20295.3225.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 12:06:40 +1000
Message-ID: <1271124400.13059.36.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 10:14 +0200, Peter Zijlstra wrote:
> 
> and doing that vaddr collection right along with it in the same batch.
> 
> I think that that would work, Ben, Dave?

Well, ours aren't struct pages.

IE. There's fundamentally 3 things that we are trying to batch here :-)

 1- The original mmu_gather: batching the freeing of the actual user
pages, so that the TLB flush can be delayed/gathered, plus there might
be some micro-improvement in passing the page list to the allocator for
freeing all at omce. This is thus purely a batch of struct pages.

 2- The batching of the TLB flushes (or hash invalidates in the ppc
case) proper, which needs the addition of the vaddr for things like
sparc and powerpc since we don't just invalidate the whole bloody thing
unlike x86 :-) On powerpc, we actually need more, we need the actual PTE
content since it also contains tracking information relative to where
things have been put in the hash table.

 3- The batching of the freeing of the page table structure, which we
want to delay more than batch, ie, the goal here is to delay that
freeing using RCU until everybody has stopped walking them. This does
rely on RCU grace period being "interrupt safe", ie, there's no
rcu_read_lock() in the low level TLB or hash miss code, but that code
runs with interrupts off.

Now, 2. has a problem I described earlier, which is that we must not
have the possibility of introducing a duplicate in the hash table, thus
it must not be possible to put a new PTE in until the previous one has
been flushed or bad things would happen. This is why powerpc doesn't use
the mmu_gather the way it was originally intended to do both 1. and 2.
but really only for 1., while for 2. we use a small batch that only
exist between lazy_mmu_enter/exit, since those are always fully enclosed
by a pte lock section.

3. As you have noticed, relies on the irq stuff. Plus there seem to be a
dubious optimization here with mm_users. Might be worth sorting that
out. However, it's a very different goal than 1. and 2. in the sense
that batching proper is a minor issue, what we want is synchronization
with walkers, and that batching is a way to lower the cost of that
synchronization (allocating of the RCU struct etc...).

Cheers,
Ben.
 

