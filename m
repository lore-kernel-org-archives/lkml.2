Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab1EKVKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:10:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42538 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914Ab1EKVKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:10:49 -0400
Date: Wed, 11 May 2011 22:10:43 +0100
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 2/3] mm: slub: Do not take expensive steps for SLUBs
 speculative high-order allocations
Message-ID: <20110511211043.GB17898@suse.de>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
 <1305127773-10570-3-git-send-email-mgorman@suse.de>
 <alpine.DEB.2.00.1105111312020.9346@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105111312020.9346@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 01:38:44PM -0700, David Rientjes wrote:
> On Wed, 11 May 2011, Mel Gorman wrote:
> 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 9f8a97b..057f1e2 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1972,6 +1972,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
> >  {
> >  	int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
> >  	const gfp_t wait = gfp_mask & __GFP_WAIT;
> > +	const gfp_t can_wake_kswapd = !(gfp_mask & __GFP_NO_KSWAPD);
> >  
> >  	/* __GFP_HIGH is assumed to be the same as ALLOC_HIGH to save a branch. */
> >  	BUILD_BUG_ON(__GFP_HIGH != (__force gfp_t) ALLOC_HIGH);
> > @@ -1984,7 +1985,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
> >  	 */
> >  	alloc_flags |= (__force int) (gfp_mask & __GFP_HIGH);
> >  
> > -	if (!wait) {
> > +	if (!wait && can_wake_kswapd) {
> >  		/*
> >  		 * Not worth trying to allocate harder for
> >  		 * __GFP_NOMEMALLOC even if it can't schedule.
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 98c358d..1071723 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -1170,7 +1170,8 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
> >  	 * Let the initial higher-order allocation fail under memory pressure
> >  	 * so we fall-back to the minimum order allocation.
> >  	 */
> > -	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY | __GFP_NO_KSWAPD) & ~__GFP_NOFAIL;
> > +	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY | __GFP_NO_KSWAPD) &
> > +			~(__GFP_NOFAIL | __GFP_WAIT);
> 
> __GFP_NORETRY is a no-op without __GFP_WAIT.
> 

True. I'll remove it in a V2 but I won't respin just yet.

> >  
> >  	page = alloc_slab_page(alloc_gfp, node, oo);
> >  	if (unlikely(!page)) {

-- 
Mel Gorman
SUSE Labs
