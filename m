Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0DIDZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 23:25:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:52935 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab0DIDZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 23:25:14 -0400
Date: Fri, 9 Apr 2010 13:25:09 +1000
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 06/13] mm: Preemptible mmu_gather
Message-ID: <20100409032509.GH5683@laptop>
References: <20100408191737.296180458@chello.nl>
 <20100408192722.858079986@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100408192722.858079986@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 09:17:43PM +0200, Peter Zijlstra wrote:
> @@ -39,30 +33,48 @@
>  struct mmu_gather {
>  	struct mm_struct	*mm;
>  	unsigned int		nr;	/* set to ~0U means fast mode */
> +	unsigned int		max;	/* nr < max */
>  	unsigned int		need_flush;/* Really unmapped some ptes? */
>  	unsigned int		fullmm; /* non-zero means full mm flush */
> -	struct page *		pages[FREE_PTE_NR];
> +#ifdef HAVE_ARCH_MMU_GATHER
> +	struct arch_mmu_gather	arch;
> +#endif
> +	struct page		**pages;
> +	struct page		*local[8];

Have you done some profiling on this? What I would like to see, if
it's not too much complexity, is to have a small set of pages to
handle common size frees, and then use them up first by default
before attempting to allocate more.

Also, it would be cool to be able to chain allocations to avoid
TLB flushes even on big frees (overridable by arch of course, in
case they're doing some non-preeemptible work or you wish to break
up lock hold times). But that might be just getting over engineered.

>  };
>  
> -/* Users of the generic TLB shootdown code must declare this storage space. */
> -DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
> +static inline void __tlb_alloc_pages(struct mmu_gather *tlb)
> +{
> +	unsigned long addr = __get_free_pages(GFP_ATOMIC, 0);

Slab allocations should be faster, so it's nice to use them in
performance critical code if you don't need the struct page.

Otherwise, looks ok to me.
