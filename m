Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0LJKZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:25:51 -0500
Received: from gir.skynet.ie ([193.1.99.77]:60559 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab0LJKZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:25:50 -0500
Date: Fri, 10 Dec 2010 10:25:32 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] mm: kswapd: Keep kswapd awake for high-order
	allocations until a percentage of the node is balanced
Message-ID: <20101210102532.GJ20133@csn.ul.ie>
References: <1291893500-12342-1-git-send-email-mel@csn.ul.ie> <1291893500-12342-3-git-send-email-mel@csn.ul.ie> <20101210101649.824e35ed.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101210101649.824e35ed.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 10:16:49AM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu,  9 Dec 2010 11:18:16 +0000
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > When reclaiming for high-orders, kswapd is responsible for balancing a
> > node but it should not reclaim excessively. It avoids excessive reclaim by
> > considering if any zone in a node is balanced then the node is balanced. In
> > the cases where there are imbalanced zone sizes (e.g. ZONE_DMA with both
> > ZONE_DMA32 and ZONE_NORMAL), kswapd can go to sleep prematurely as just
> > one small zone was balanced.
> > 
> > This alters the sleep logic of kswapd slightly. It counts the number of pages
> > that make up the balanced zones. If the total number of balanced pages is
> > more than a quarter of the zone, kswapd will go back to sleep. This should
> > keep a node balanced without reclaiming an excessive number of pages.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> 
> Hmm, does this work well in
> 
> for example, x86-32,
> 	DMA: 16MB
> 	NORMAL: 700MB
> 	HIGHMEM: 11G
> ?
> 
> At 1st look, it's balanced when HIGHMEM has enough free pages...
> This is not good for NICs which requests high-order allocations.
> 

Good question.

In this case, the classzone_idx for the NICs high-order allocation will
be the Normal zone. In balance_pgdat(), this check is made

                                if (i <= classzone_idx)
                                        balanced += zone->present_pages;

Highmem will be too high and so the pages will not be counted and the node
will not be balanced.

> Can't we take claszone_idx into account at checking rather than
> node->present_pages ?
> 
> as
> 	balanced > present_pages_below_classzone_idx(node, classzone_idx)/4
> 
> ?

We can, but not for the reasons you list above. When a heavily
imbalanced highmem zone like this, the node might never be considered
balanced as the sum of DMA and Normal is less than 25% of the node.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
