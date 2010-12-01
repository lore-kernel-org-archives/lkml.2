Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0LAK2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:28:09 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:35329 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab0LAK2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:28:06 -0500
Date: Wed, 1 Dec 2010 11:27:45 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] mm: vmscan: Reclaim order-0 and use compaction
 instead of lumpy reclaim
Message-ID: <20101201102745.GL15564@cmpxchg.org>
References: <1290440635-30071-1-git-send-email-mel@csn.ul.ie>
 <1290440635-30071-4-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290440635-30071-4-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 03:43:51PM +0000, Mel Gorman wrote:
> Lumpy reclaim is disruptive. It reclaims a large number of pages and ignores
> the age of the pages it reclaims. This can incur significant stalls and
> potentially increase the number of major faults.
> 
> Compaction has reached the point where it is considered reasonably stable
> (meaning it has passed a lot of testing) and is a potential candidate for
> displacing lumpy reclaim. This patch introduces an alternative to lumpy
> reclaim whe compaction is available called reclaim/compaction. The basic
> operation is very simple - instead of selecting a contiguous range of pages
> to reclaim, a number of order-0 pages are reclaimed and then compaction is
> later by either kswapd (compact_zone_order()) or direct compaction
> (__alloc_pages_direct_compact()).
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

> @@ -286,18 +290,20 @@ static void set_lumpy_reclaim_mode(int priority, struct scan_control *sc,
>  	lumpy_mode syncmode = sync ? LUMPY_MODE_SYNC : LUMPY_MODE_ASYNC;
>  
>  	/*
> -	 * Some reclaim have alredy been failed. No worth to try synchronous
> -	 * lumpy reclaim.
> +	 * Initially assume we are entering either lumpy reclaim or
> +	 * reclaim/compaction.Depending on the order, we will either set the
> +	 * sync mode or just reclaim order-0 pages later.
>  	 */
> -	if (sync && sc->lumpy_reclaim_mode & LUMPY_MODE_SINGLE)
> -		return;
> +	if (COMPACTION_BUILD)
> +		sc->lumpy_reclaim_mode = LUMPY_MODE_COMPACTION;
> +	else
> +		sc->lumpy_reclaim_mode = LUMPY_MODE_CONTIGRECLAIM;

Isn't this a regression for !COMPACTION_BUILD in that earlier kernels
would not do sync lumpy reclaim when somebody disabled it during the
async run?

If so, it should be trivial to fix.  Aside from that

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
