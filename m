Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab0DIJWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 05:22:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35884 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab0DIJWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 05:22:12 -0400
Subject: Re: [PATCH 07/13] powerpc: Preemptible mmu_gather
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20100409084614.GN5683@laptop>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.901224587@chello.nl> <20100409040756.GK5683@laptop>
	 <1270800847.20295.3225.camel@laptop>  <20100409084614.GN5683@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 11:22:06 +0200
Message-ID: <1270804926.20295.3295.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 18:46 +1000, Nick Piggin wrote:
> > struct mmu_page {
> >   struct page *page;
> > #ifdef HAVE_ARCH_TLB_VADDR
> >   unsigned long vaddr;
> > #endif
> > };
> 
> Well you could also have a per-arch struct for this, which they can
> fill in their own info with (I think powerpc takes the pte as well)

Ah, right you are.

Maybe something like:

#ifndef tlb_fill_page
struct mmu_page {
	struct page *page;
};

#define tlb_fill_page(tlb, pte, addr) do { } while (0)
#endif

Which can be used from the tlb_remove_tlb_entry() implementation to
gather both the pte and addr. The only complication seems to be that
tlb_remove_tlb_entry() and tlb_remove_page() aren't always matched.

Also, it looks like both power and sparc drive the pte/vaddr flush from
the pte_update/set_pte_at like functions. Which means its not synced to
the mmu_gather at all.

So I'm not at all sure its feasible to link these, but I'll keep it in
mind.

