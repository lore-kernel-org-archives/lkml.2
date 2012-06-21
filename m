Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab2FUQip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 12:38:45 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42773 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759824Ab2FUQin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 12:38:43 -0400
Subject: Re: [PATCH 10/17] netvm: Allow skb allocation to use PFMEMALLOC
 reserves
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>
In-Reply-To: <20120621163029.GB6045@breakpoint.cc>
References: <1340192652-31658-1-git-send-email-mgorman@suse.de>
	 <1340192652-31658-11-git-send-email-mgorman@suse.de>
	 <20120621163029.GB6045@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jun 2012 18:38:39 +0200
Message-ID: <1340296719.4604.5984.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 18:30 +0200, Sebastian Andrzej Siewior wrote:
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 1d6ecc8..9a58dcc 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -167,14 +206,19 @@ static void skb_under_panic(struct sk_buff *skb, int sz, void *here)
> >   *	%GFP_ATOMIC.
> >   */
> >  struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
> > -			    int fclone, int node)
> > +			    int flags, int node)
> >  {
> >  	struct kmem_cache *cache;
> >  	struct skb_shared_info *shinfo;
> >  	struct sk_buff *skb;
> >  	u8 *data;
> > +	bool pfmemalloc;
> >  
> > -	cache = fclone ? skbuff_fclone_cache : skbuff_head_cache;
> > +	cache = (flags & SKB_ALLOC_FCLONE)
> > +		? skbuff_fclone_cache : skbuff_head_cache;
> > +
> > +	if (sk_memalloc_socks() && (flags & SKB_ALLOC_RX))
> > +		gfp_mask |= __GFP_MEMALLOC;
> >  
> >  	/* Get the HEAD */
> >  	skb = kmem_cache_alloc_node(cache, gfp_mask & ~__GFP_DMA, node);
> 
> This is mostly used by nic to refil their RX skb pool. You add the
> __GFP_MEMALLOC to the allocation to rise the change of a successfull refill
> for the swap case.
> A few drivers use build_skb() to create the skb. __netdev_alloc_skb()
> shouldn't be affected since the allocation happens with GFP_ATOMIC. Looking at
> TG3 it uses build_skb() and get_pages() / kmalloc(). Shouldn't this be some
> considered?

Please look at net-next, this was changed recently.

In fact most RX allocations are done using netdev_alloc_frag(), because
its called from __netdev_alloc_skb()

So tg3 is not anymore the exception, but the norm.



