Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab1D1KFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:05:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:46591 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758244Ab1D1KFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:05:10 -0400
Date: Thu, 28 Apr 2011 11:05:06 +0100
From: Mel Gorman <mgorman@suse.de>
To: NeilBrown <neilb@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 08/13] netvm: Allow skb allocation to use PFMEMALLOC
 reserves
Message-ID: <20110428100035.GO4658@suse.de>
References: <1303920491-25302-1-git-send-email-mgorman@suse.de>
 <1303920491-25302-9-git-send-email-mgorman@suse.de>
 <20110428161933.1f1266e6@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110428161933.1f1266e6@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 04:19:33PM +1000, NeilBrown wrote:
> On Wed, 27 Apr 2011 17:08:06 +0100 Mel Gorman <mgorman@suse.de> wrote:
> 
> 
> > @@ -1578,7 +1589,7 @@ static inline struct sk_buff *netdev_alloc_skb_ip_align(struct net_device *dev,
> >   */
> >  static inline struct page *__netdev_alloc_page(struct net_device *dev, gfp_t gfp_mask)
> >  {
> > -	return alloc_pages_node(NUMA_NO_NODE, gfp_mask, 0);
> > +	return alloc_pages_node(NUMA_NO_NODE, gfp_mask | __GFP_MEMALLOC, 0);
> >  }
> >  
> 
> I'm puzzling a bit over this change.
> __netdev_alloc_page appears to be used to get pages to put in ring buffer
> for a network card to DMA received packets into.  So it is OK to use
> __GFP_MEMALLOC for these allocations providing we mark the resulting skb as
> 'pfmemalloc' if a reserved page was used.
> 
> However I don't see where that marking is done.
> I think it should be in skb_fill_page_desc, something like:
> 
>   if (page->pfmemalloc)
> 	skb->pfmemalloc = true;
> 
> Is this covered somewhere else that I am missing?
> 

You're not missing anything.

>From the context of __netdev_alloc_page, we do not know if the skb
is suitable for marking pfmemalloc or not (we don't have SKB_ALLOC_RX
flag for example that __alloc_skb has). The reserves are potentially
being dipped into for an unsuitable packet but it gets dropped in
__netif_receive_skb() and the memory is returned. If we mark the skb
pfmemalloc as a result of __netdev_alloc_page using a reserve page, the
packets would not get dropped as expected.

-- 
Mel Gorman
SUSE Labs
