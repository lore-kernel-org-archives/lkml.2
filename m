Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab1D1RLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 13:11:04 -0400
Received: from adelie.canonical.com ([91.189.90.139]:55624 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867Ab1D1RLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 13:11:02 -0400
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback
 related.
From: Colin Ian King <colin.king@canonical.com>
To: Mel Gorman <mgorman@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, Jan Kara <jack@suse.cz>,
        Chris Mason <chris.mason@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>, mgorman@novell.com
In-Reply-To: <20110428150827.GY4658@suse.de>
References: <1303923000.2583.8.camel@mulgrave.site>
	 <1303923177-sup-2603@think> <1303924902.2583.13.camel@mulgrave.site>
	 <1303925374-sup-7968@think> <1303926637.2583.17.camel@mulgrave.site>
	 <1303934716.2583.22.camel@mulgrave.site> <1303990590.2081.9.camel@lenovo>
	 <20110428135228.GC1696@quack.suse.cz> <20110428140725.GX4658@suse.de>
	 <1304000714.2598.0.camel@mulgrave.site>  <20110428150827.GY4658@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 18:10:54 +0100
Message-ID: <1304010654.2081.25.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 16:08 +0100, Mel Gorman wrote:

[ text deleted ]

> Another consequence of this patch is that when high order allocations
> are in progress (is the test case fork heavy in any way for
> example? alternatively, it might be something in the storage stack
> that requires high-order allocs) we are no longer necessarily going
> to sleep because of should_reclaim_continue() check. This could
> explain kswapd-at-99% but would only apply if CONFIG_COMPACTION is
> set (does unsetting CONFIG_COMPACTION help). If the bug only triggers
> for CONFIG_COMPACTION, does the following *untested* patch help any?

Afraid to report this patch didn't help either.
> 
> (as a warning, I'm offline Friday until Tuesday morning. I'll try
> check mail over the weekend but it's unlikely I'll find a terminal
> or be allowed to use it without an ass kicking)

Ditto, me, to, I will pick this up Tuesday.
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 148c6e6..c74a501 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1842,15 +1842,22 @@ static inline bool should_continue_reclaim(struct zone *zone,
>  		return false;
>  
>  	/*
> -	 * If we failed to reclaim and have scanned the full list, stop.
> -	 * NOTE: Checking just nr_reclaimed would exit reclaim/compaction far
> -	 *       faster but obviously would be less likely to succeed
> -	 *       allocation. If this is desirable, use GFP_REPEAT to decide
> -	 *       if both reclaimed and scanned should be checked or just
> -	 *       reclaimed
> +	 * For direct reclaimers
> +	 *   If we failed to reclaim and have scanned the full list, stop.
> +	 *   The caller will check congestion and sleep if necessary until
> +	 *   some IO completes.
> +	 * For kswapd
> +	 *   Check just nr_reclaimed. If we are failing to reclaim, we
> +	 *   want to stop this reclaim loop, increase the priority and
> +	 *   go to sleep if necessary to allow IO a change to complete.
> +	 *   This avoids kswapd going into a busy loop in shrink_zone()
>  	 */
> -	if (!nr_reclaimed && !nr_scanned)
> -		return false;
> +	if (!nr_reclaimed) {
> +		if (current_is_kswapd())
> +			return false;
> +		else if (!nr_scanned)
> +			return false;
> +	}
>  
>  	/*
>  	 * If we have not reclaimed enough pages for compaction and the
> @@ -1924,8 +1931,13 @@ restart:
>  
>  	/* reclaim/compaction might need reclaim to continue */
>  	if (should_continue_reclaim(zone, nr_reclaimed,
> -					sc->nr_scanned - nr_scanned, sc))
> +					sc->nr_scanned - nr_scanned, sc)) {
> +		/* Throttle direct reclaimers if congested */
> +		if (!current_is_kswapd())
> +			wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
> +
>  		goto restart;
> +	}
>  
>  	throttle_vm_writeout(sc->gfp_mask);
>  }


