Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab1DZN7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:59:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab1DZN7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:59:44 -0400
Date: Tue, 26 Apr 2011 14:59:40 +0100
From: Mel Gorman <mgorman@suse.de>
To: NeilBrown <neilb@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 02/13] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
Message-ID: <20110426135940.GE4658@suse.de>
References: <1303803414-5937-1-git-send-email-mgorman@suse.de>
 <1303803414-5937-3-git-send-email-mgorman@suse.de>
 <20110426213758.450f6f49@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110426213758.450f6f49@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 09:37:58PM +1000, NeilBrown wrote:
> On Tue, 26 Apr 2011 08:36:43 +0100 Mel Gorman <mgorman@suse.de> wrote:
> 
> > +		/*
> > +		 * If there are full empty slabs and we were not forced to
> > +		 * allocate a slab, mark this one !pfmemalloc
> > +		 */
> > +		l3 = cachep->nodelists[numa_mem_id()];
> > +		if (!list_empty(&l3->slabs_free) && force_refill) {
> > +			struct slab *slabp = virt_to_slab(objp);
> > +			slabp->pfmemalloc = false;
> > +			clear_obj_pfmemalloc(&objp);
> > +			check_ac_pfmemalloc(cachep, ac);
> > +			return objp;
> > +		}
> 
> The comment doesn't match the code.  I think you need to remove the words
> "full" and "not" assuming the code is correct which it probably is...
> 

I'll fix up the comment, you're right, it's confusing.

> But the code seems to be much more complex than Peter's original, and I don't
> see the gain.
> 

You're right, it is more complex.

> Peter's code had only one 'reserved' flag for each kmem_cache. 

The reserve was set in a per-cpu structure so there was a "lag" time
before that information was available to other CPUs. Fine on smaller
machines but a bit more of a problem today. 

> You seem to
> have one for every slab.  I don't see the point.
> It is true that yours is in some sense more fair - but I'm not sure the
> complexity is worth it.
> 

More fairness was one of the objects.

> Was there some particular reason you made the change?
> 

This version survives under considerably more stress than Peter's
original version did without requiring the additional complexity of
memory reserves.

-- 
Mel Gorman
SUSE Labs
