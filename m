Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1D1GTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 02:19:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab1D1GTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 02:19:45 -0400
Date: Thu, 28 Apr 2011 16:19:33 +1000
From: NeilBrown <neilb@suse.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 08/13] netvm: Allow skb allocation to use PFMEMALLOC
 reserves
Message-ID: <20110428161933.1f1266e6@notabene.brown>
In-Reply-To: <1303920491-25302-9-git-send-email-mgorman@suse.de>
References: <1303920491-25302-1-git-send-email-mgorman@suse.de>
	<1303920491-25302-9-git-send-email-mgorman@suse.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 17:08:06 +0100 Mel Gorman <mgorman@suse.de> wrote:


> @@ -1578,7 +1589,7 @@ static inline struct sk_buff *netdev_alloc_skb_ip_align(struct net_device *dev,
>   */
>  static inline struct page *__netdev_alloc_page(struct net_device *dev, gfp_t gfp_mask)
>  {
> -	return alloc_pages_node(NUMA_NO_NODE, gfp_mask, 0);
> +	return alloc_pages_node(NUMA_NO_NODE, gfp_mask | __GFP_MEMALLOC, 0);
>  }
>  

I'm puzzling a bit over this change.
__netdev_alloc_page appears to be used to get pages to put in ring buffer
for a network card to DMA received packets into.  So it is OK to use
__GFP_MEMALLOC for these allocations providing we mark the resulting skb as
'pfmemalloc' if a reserved page was used.

However I don't see where that marking is done.
I think it should be in skb_fill_page_desc, something like:

  if (page->pfmemalloc)
	skb->pfmemalloc = true;

Is this covered somewhere else that I am missing?

Thanks,
NeilBrown

