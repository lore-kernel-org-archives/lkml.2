Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab0F1C0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 22:26:55 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49950 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab0F1C0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 22:26:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/2] vmscan: don't subtraction of unsined 
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <alpine.DEB.2.00.1006250912380.18900@router.home>
References: <20100625202126.806A.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006250912380.18900@router.home>
Message-Id: <20100628101802.386A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 28 Jun 2010 11:26:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 25 Jun 2010, KOSAKI Motohiro wrote:
> 
> > 'slab_reclaimable' and 'nr_pages' are unsigned. so, subtraction is
> > unsafe.
> 
> Why? We are subtracting the current value of NR_SLAB_RECLAIMABLE from the
> earlier one. The result can be negative (maybe concurrent allocations) and
> then the nr_reclaimed gets decremented instead. This is  okay since we
> have not reached our goal then of reducing the number of reclaimable slab
> pages on the zone.

It's unsigned. negative mean very big value. so

"zone_page_state(zone, NR_SLAB_RECLAIMABLE) > slab_reclaimable - nr_pages)" will
be evaluated false.

ok, your mysterious 'order' parameter (as pointed [1/2]) almostly prevent this case.
because passing 'order' makes very heavy slab pressure and it avoid negative occur.

but unnaturall coding style can make confusing to reviewers. ya, it's not
big issue. but I also don't find no fixing reason.


> 
> > @@ -2622,17 +2624,21 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
> >  		 * Note that shrink_slab will free memory on all zones and may
> >  		 * take a long time.
> >  		 */
> > -		while (shrink_slab(sc.nr_scanned, gfp_mask, lru_pages) &&
> > -			zone_page_state(zone, NR_SLAB_RECLAIMABLE) >
> > -				slab_reclaimable - nr_pages)
> 
> The comparison could be a problem here. So
> 
> 			zone_page_state(zone, NR_SLAB_RECLAIMABLE) + nr_pages >
> 				slab_reclaimable
> 
> ?

My patch take the same thing. but It avoided two line comparision.
Do you mean you like this style? (personally, I don't). If so, I'll 
repost this patch.





