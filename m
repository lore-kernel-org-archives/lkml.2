Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab0DIISx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 04:18:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:41612 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab0DIISs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 04:18:48 -0400
Subject: Re: [PATCH 06/13] mm: Preemptible mmu_gather
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
In-Reply-To: <20100409032509.GH5683@laptop>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.858079986@chello.nl>  <20100409032509.GH5683@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 10:18:43 +0200
Message-ID: <1270801123.20295.3235.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 13:25 +1000, Nick Piggin wrote:
> On Thu, Apr 08, 2010 at 09:17:43PM +0200, Peter Zijlstra wrote:
> > @@ -39,30 +33,48 @@
> >  struct mmu_gather {
> >  	struct mm_struct	*mm;
> >  	unsigned int		nr;	/* set to ~0U means fast mode */
> > +	unsigned int		max;	/* nr < max */
> >  	unsigned int		need_flush;/* Really unmapped some ptes? */
> >  	unsigned int		fullmm; /* non-zero means full mm flush */
> > -	struct page *		pages[FREE_PTE_NR];
> > +#ifdef HAVE_ARCH_MMU_GATHER
> > +	struct arch_mmu_gather	arch;
> > +#endif
> > +	struct page		**pages;
> > +	struct page		*local[8];
> 
> Have you done some profiling on this? What I would like to see, if
> it's not too much complexity, is to have a small set of pages to
> handle common size frees, and then use them up first by default
> before attempting to allocate more.
> 
> Also, it would be cool to be able to chain allocations to avoid
> TLB flushes even on big frees (overridable by arch of course, in
> case they're doing some non-preeemptible work or you wish to break
> up lock hold times). But that might be just getting over engineered.

Did no profiling at all, back when I wrote this I was in a hurry to get
this working for -rt.

But yes, those things do look like something we want to look into, we
can easily add a head structure to these pages like we did for the RCU
batches.

But as it stands I think we can do those things as incrementals on top
of this, no?

What kind of workload would you recommend I use to profile this?

