Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab0DMB56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 21:57:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:51170 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279Ab0DMB55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 21:57:57 -0400
Subject: Re: [PATCH 07/13] powerpc: Preemptible mmu_gather
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20100409040756.GK5683@laptop>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.901224587@chello.nl>  <20100409040756.GK5683@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 11:56:40 +1000
Message-ID: <1271123800.13059.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 14:07 +1000, Nick Piggin wrote:
> > PPC has an extra batching queue to RCU free the actual pagetable
> > allocations, use the ARCH extentions for that for now.
> > 
> > For the ppc64_tlb_batch, which tracks the vaddrs to unhash from the
> > hardware hash-table, keep using per-cpu arrays but flush on context
> > switch and use a TIF bit to track the laxy_mmu state.
> 
> Hm. Pity powerpc can't just use tlb flush gathering for this batching,
> (which is what it was designed for). Then it could avoid these tricks.
> What's preventing this? Adding a tlb gather for COW case in
> copy_page_range? 

We must flush before the pte_lock is released. If not, we end up with
this funny situation:

	- PTE is read-only, hash contains a translation for it
	- PTE gets cleared & added to the batch, hash not flushed yet
	- PTE lock released, maybe even VMA fully removed
	- Other CPU takes a write fault, puts in a new PTE
	- Hash ends up with duplicates of the vaddr -> arch violation

Now we could get out of that one, I suppose, if we had some kind of way
to force flush any batch pertaining to a given mm before a new valid PTE
can be written, but that doesn't sound such a trivial thing to do.

Any better idea ?

Cheers,
Ben.

