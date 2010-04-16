Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab0DPEXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 00:23:38 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:44202 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751373Ab0DPEXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 00:23:37 -0400
Date: Fri, 16 Apr 2010 14:23:08 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 06/10] vmscan: Split shrink_zone to reduce stack usage
Message-ID: <20100416042308.GZ2493@dastard>
References: <1271352103-2280-1-git-send-email-mel@csn.ul.ie>
 <1271352103-2280-7-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271352103-2280-7-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 06:21:39PM +0100, Mel Gorman wrote:
> shrink_zone() calculculates how many pages it needs to shrink from each
> LRU list in a given pass. It uses a number of temporary variables to
> work this out that then remain on the stack. This patch splits the
> function so that some of the stack variables can be discarded.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/vmscan.c |   29 +++++++++++++++++++----------
>  1 files changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1ace7c6..a374879 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1595,19 +1595,14 @@ static unsigned long nr_scan_try_batch(unsigned long nr_to_scan,
>  	return nr;
>  }
>  
> -/*
> - * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
> - */
> -static void shrink_zone(struct zone *zone, struct scan_control *sc)
> +/* Calculate how many pages from each LRU list should be scanned */
> +static void calc_scan_trybatch(struct zone *zone,
> +				 struct scan_control *sc, unsigned long *nr)

Needs "noinline_for_stack" to stop the compiler re-inlining it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
