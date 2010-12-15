Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab0LOKnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 05:43:06 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34299 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab0LOKnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 05:43:03 -0500
Date: Wed, 15 Dec 2010 10:42:44 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] mm: kswapd: Stop high-order balancing when any
	suitable zone is balanced
Message-ID: <20101215104244.GH13914@csn.ul.ie>
References: <1291995985-5913-1-git-send-email-mel@csn.ul.ie> <1291995985-5913-2-git-send-email-mel@csn.ul.ie> <20101214143306.485f2c7c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101214143306.485f2c7c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 02:33:06PM -0800, Andrew Morton wrote:
> On Fri, 10 Dec 2010 15:46:20 +0000
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > When the allocator enters its slow path, kswapd is woken up to balance the
> > node. It continues working until all zones within the node are balanced. For
> > order-0 allocations, this makes perfect sense but for higher orders it can
> > have unintended side-effects. If the zone sizes are imbalanced, kswapd may
> > reclaim heavily within a smaller zone discarding an excessive number of
> > pages.
> 
> Why was it doing this?  
> 

Partially because of lumpy reclaim but mostly because it simply stays
awake. If the zone is unbalanced, kswapd will reclaim in there,
shrinking slabs, rotating lists etc. even if ultimately it cannot
balance that zone.

> > The user-visible behaviour is that kswapd is awake and reclaiming
> > even though plenty of pages are free from a suitable zone.
> 
> Suitable for what?  I assume you refer to a future allocation which can
> be satisfied from more than one of the zones?
> 

Yes.

> But what if that allocation wanted to allocate a high-order page from
> a zone which we just abandoned?
> 

classzone_idx is taken into account by the series overall and it doesn't
count zones above the classzone_idx.

> > This patch alters the "balance" logic for high-order reclaim allowing kswapd
> > to stop if any suitable zone becomes balanced to reduce the number of pages
> 
> again, suitable for what?
> 

Suitable for a future allocation of the same type that woke kswapd.

> > it reclaims from other zones. kswapd still tries to ensure that order-0
> > watermarks for all zones are met before sleeping.
> 
> Handling order-0 pages differently from higher-order pages sounds weird
> and wrong.
> 
> I don't think I understand this patch.
> 

The objective is that kswapd will go to sleep again. It has been found
when there is a constant source of high-order allocations that kswapd
stays awake constantly trying to reclaim even though a suitable zone had
free pages.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
