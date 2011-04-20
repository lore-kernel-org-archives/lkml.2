Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1DTIs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:48:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:34448 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1DTIsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:48:55 -0400
Subject: Re: [PATCH 01/20] mm: mmu_gather rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Tony Luck <tony.luck@intel.com>,
        Hugh Dickins <hughd@google.com>
In-Reply-To: <20110419130606.fb7139b2.akpm@linux-foundation.org>
References: <20110401121258.211963744@chello.nl>
	 <20110401121725.360704327@chello.nl>
	 <20110419130606.fb7139b2.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Apr 2011 10:47:28 +0200
Message-ID: <1303289248.8345.62.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 13:06 -0700, Andrew Morton wrote:
> On Fri, 01 Apr 2011 14:12:59 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Remove the first obstackle towards a fully preemptible mmu_gather.
> > 
> > The current scheme assumes mmu_gather is always done with preemption
> > disabled and uses per-cpu storage for the page batches. Change this to
> > try and allocate a page for batching and in case of failure, use a
> > small on-stack array to make some progress.
> > 
> > Preemptible mmu_gather is desired in general and usable once
> > i_mmap_lock becomes a mutex. Doing it before the mutex conversion
> > saves us from having to rework the code by moving the mmu_gather
> > bits inside the pte_lock.
> > 
> > Also avoid flushing the tlb batches from under the pte lock,
> > this is useful even without the i_mmap_lock conversion as it
> > significantly reduces pte lock hold times.
> 
> There doesn't seem much point in reviewing this closely, as a lot of it
> gets tossed away later in the series..

That's a result of breaking patches along concept boundaries :/

> >  		free_pages_and_swap_cache(tlb->pages, tlb->nr);
> 
> It seems inappropriate that this code uses
> free_page[s]_and_swap_cache().  It should go direct to put_page() and
> release_pages()?  Please review this code's implicit decision to pass
> "cold==0" into release_pages().

Well, that isn't new with this patch, however it does look to be
correct. We're freeing user pages, those could indeed still be part of
the swapcache. Furthermore, the PAGEVEC_SIZE split in
free_pages_and_swap_cache() alone makes it worth calling that over
release_pages().

As to the cold==0, I think that too is correct since we don't actually
touch the pages themselves and we have no inkling as to their cache
state, we're simply wiping out user pages.

> > -static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
> > +static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
> 
> I wonder if all the inlining which remains in this code is needed and
> desirable.

Probably not, the big plan was to make everybody use the generic code
and then move it into mm/memory.c or so.

But I guess I can have asm-generic/tlb.h define HAVE_GENERIC_MMU_GATHER
and make the compilation in mm/memory.c conditional on that (or generate
lots of Kconfig churn).
