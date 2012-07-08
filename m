Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab2GHSMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 14:12:39 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33997 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768Ab2GHSMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 14:12:37 -0400
Date: Sun, 8 Jul 2012 20:12:11 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 04/16] mm: allow PF_MEMALLOC from softirq context
Message-ID: <20120708181211.GE2872@breakpoint.cc>
References: <1340375443-22455-1-git-send-email-mgorman@suse.de>
 <1340375443-22455-5-git-send-email-mgorman@suse.de>
 <20120626165513.GD6509@breakpoint.cc>
 <20120627082614.GE8271@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627082614.GE8271@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 09:26:14AM +0100, Mel Gorman wrote:
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index b6c0727..5c6d9c6 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -2265,7 +2265,11 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
> > >  	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
> > >  		if (gfp_mask & __GFP_MEMALLOC)
> > >  			alloc_flags |= ALLOC_NO_WATERMARKS;
> > > -		else if (likely(!(gfp_mask & __GFP_NOMEMALLOC)) && !in_interrupt())
> > > +		else if (in_serving_softirq() && (current->flags & PF_MEMALLOC))
> > > +			alloc_flags |= ALLOC_NO_WATERMARKS;
> > > +		else if (!in_interrupt() &&
> > > +				((current->flags & PF_MEMALLOC) ||
> > > +				 unlikely(test_thread_flag(TIF_MEMDIE))))
> > >  			alloc_flags |= ALLOC_NO_WATERMARKS;
> > >  	}
> > 
> > You allocate in RX path with __GFP_MEMALLOC and your sk->sk_allocation has
> > also __GFP_MEMALLOC set. That means you should get ALLOC_NO_WATERMARKS in
> > alloc_flags.
> 
> In the cases where they are annotated correctly, yes. It is recordeed if
> the page gets allocated from the PFMEMALLOC reserves. If the received
> packet is not SOCK_MEMALLOC and the page was allocated from PFMEMALLOC
> reserves it is then discarded and the packet must be retransmitted.

Let me try again:
- lets assume your allocation happens with alloc_page(), without
  __GFP_MEMALLOC in GFP_FLAGS and with PF_MEMALLOC in current->flags. Now
  you may get memory which you wouldn't receive otherwise (without
  PF_MEMALLOC). Okay, understood. So you don't have to annotate each page
  allocation in your receive path for instance as long as the process has the
  flag set.
- lets assume your allocation happens with kmalloc() without __GFP_MEMALLOC
  and current->flags has PF_MEMALLOC ORed and your SLAB pool is empty. This
  forces SLAB to allocate more pages from the buddy allocator with it will
  receive more likely (due to ->current->flags + PF_MEMALLOC) but SLAB will
  drop this extra memory because the page has ->pf_memory (or something like
  that) set and the GFP_FLAGS do not have __GFP_MEMALLOC set.

Is there something I missed?

Sebastian
