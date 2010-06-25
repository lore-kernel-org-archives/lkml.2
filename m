Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab0FYOSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:18:24 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:44769 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab0FYOSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 10:18:23 -0400
Date: Fri, 25 Jun 2010 09:17:03 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] vmscan: don't subtraction of unsined 
In-Reply-To: <20100625202126.806A.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006250912380.18900@router.home>
References: <20100625201915.8067.A69D9226@jp.fujitsu.com> <20100625202126.806A.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010, KOSAKI Motohiro wrote:

> 'slab_reclaimable' and 'nr_pages' are unsigned. so, subtraction is
> unsafe.

Why? We are subtracting the current value of NR_SLAB_RECLAIMABLE from the
earlier one. The result can be negative (maybe concurrent allocations) and
then the nr_reclaimed gets decremented instead. This is  okay since we
have not reached our goal then of reducing the number of reclaimable slab
pages on the zone.

> @@ -2622,17 +2624,21 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  		 * Note that shrink_slab will free memory on all zones and may
>  		 * take a long time.
>  		 */
> -		while (shrink_slab(sc.nr_scanned, gfp_mask, lru_pages) &&
> -			zone_page_state(zone, NR_SLAB_RECLAIMABLE) >
> -				slab_reclaimable - nr_pages)

The comparison could be a problem here. So

			zone_page_state(zone, NR_SLAB_RECLAIMABLE) + nr_pages >
				slab_reclaimable

?

