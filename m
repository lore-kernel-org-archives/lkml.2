Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1DTKlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 06:41:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab1DTKlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 06:41:44 -0400
Subject: Re: [PATCH 12/20] mm: Extended batches for generic mmu_gather
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
        Hugh Dickins <hughd@google.com>
In-Reply-To: <20110419130633.3d8cd5ae.akpm@linux-foundation.org>
References: <20110401121258.211963744@chello.nl>
	 <20110401121725.892956392@chello.nl>
	 <20110419130633.3d8cd5ae.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Apr 2011 12:40:40 +0200
Message-ID: <1303296040.8345.156.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 13:06 -0700, Andrew Morton wrote:
> On Fri, 01 Apr 2011 14:13:10 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Instead of using a single batch (the small on-stack, or an allocated
> > page), try and extend the batch every time it runs out and only flush
> > once either the extend fails or we're done.
> 
> why?

To avoid sending extra TLB invalidates.

> > @@ -86,22 +86,48 @@ struct mmu_gather {
> >  #ifdef CONFIG_HAVE_RCU_TABLE_FREE
> >  	struct mmu_table_batch	*batch;
> >  #endif
> > +	unsigned int		need_flush : 1,	/* Did free PTEs */
> > +				fast_mode  : 1; /* No batching   */
> 
> mmu_gather.fast_mode gets modified in several places apparently without
> locking to protect itself.  I don't think that these modifications will
> accidentally trash need_flush, mainly by luck.

The other way around I'd think.

> Please review the concurrency issues here and document them clearly.

Its an on-stack structure, there is no concurrency. /me shall add a
comment.

> > +#ifdef CONFIG_SMP
> > +  #define tlb_fast_mode(tlb) (tlb->fast_mode)
> > +#else
> > +  #define tlb_fast_mode(tlb) 1
> > +#endif
> 
> Mutter.
> 
> Could have been written in C.

Fixed in my last patch uninlining bits

> Will cause a compile error with, for example, tlb_fast_mode(tlb + 1).

Well, that'd actually be a good reason to keep the macro ;-)

> > +static inline int tlb_next_batch(struct mmu_gather *tlb)
> >  {
> > +	struct mmu_gather_batch *batch;
> >  
> > +	batch = tlb->active;
> > +	if (batch->next) {
> > +		tlb->active = batch->next;
> > +		return 1;
> >  	}
> > +
> > +	batch = (void *)__get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
> 
> A comment explaining the gfp_t decision would be useful.

Done

> > +	if (!batch)
> > +		return 0;
> > +
> > +	batch->next = NULL;
> > +	batch->nr   = 0;
> > +	batch->max  = MAX_GATHER_BATCH;
> > +
> > +	tlb->active->next = batch;
> > +	tlb->active = batch;
> > +
> > +	return 1;
> >  }
> >  
> >  /* tlb_gather_mmu
> > @@ -114,16 +140,13 @@ tlb_gather_mmu(struct mmu_gather *tlb, s
> >  {
> >  	tlb->mm = mm;
> >  
> > +	tlb->fullmm     = fullmm;
> > +	tlb->need_flush = 0;
> > +	tlb->fast_mode  = (num_possible_cpus() == 1);
> 
> The changelog didn't tell us why we switched from num_online_cpus() to
> num_possible_cpus().

And that is a very good question... somehow I remember a conversation
with BenH about this, but on second thought that might have been about
his pgtable_free_tlb() optimization (which is somewhat similar).

Let me restore that to num_online_cpus() and maybe do a later patch
removing fast_mode all together as Hugh suggested, since even UP might
have benefit from the batching due to less zone-lock activity on bulk
frees.

> > +	tlb->local.next = NULL;
> > +	tlb->local.nr   = 0;
> > +	tlb->local.max  = ARRAY_SIZE(tlb->__pages);
> > +	tlb->active     = &tlb->local;
> >  
> >  #ifdef CONFIG_HAVE_RCU_TABLE_FREE
> >  	tlb->batch = NULL;
> >
> > ...
> >
> > @@ -177,15 +205,24 @@ tlb_finish_mmu(struct mmu_gather *tlb, u
> > +	batch = tlb->active;
> > +	batch->pages[batch->nr++] = page;
> > +	VM_BUG_ON(batch->nr > batch->max);
> > +	if (batch->nr == batch->max) {
> > +		if (!tlb_next_batch(tlb))
> > +			return 0;
> > +	}
> 
> Moving the VM_BUG_ON() down to after the if() would save a few cycles.

Done.

> > +	return batch->max - batch->nr;
> >  }
> >  
> >  /* tlb_remove_page
> > 

