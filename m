Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab1F3Chu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 22:37:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44429 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab1F3Chp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 22:37:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E0BE164.7080505@jp.fujitsu.com>
Date: Thu, 30 Jun 2011 11:37:24 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: mgorman@suse.de
CC: akpm@linux-foundation.org, P@draigBrady.com,
        James.Bottomley@HansenPartnership.com, colin.king@canonical.com,
        minchan.kim@gmail.com, luto@mit.edu, riel@redhat.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm: vmscan: Do not apply pressure to slab if we are
 not applying pressure to zone
References: <1308926697-22475-1-git-send-email-mgorman@suse.de> <1308926697-22475-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1308926697-22475-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/24 23:44), Mel Gorman wrote:
> During allocator-intensive workloads, kswapd will be woken frequently
> causing free memory to oscillate between the high and min watermark.
> This is expected behaviour.
> 
> When kswapd applies pressure to zones during node balancing, it checks
> if the zone is above a high+balance_gap threshold. If it is, it does
> not apply pressure but it unconditionally shrinks slab on a global
> basis which is excessive. In the event kswapd is being kept awake due to
> a high small unreclaimable zone, it skips zone shrinking but still
> calls shrink_slab().
> 
> Once pressure has been applied, the check for zone being unreclaimable
> is being made before the check is made if all_unreclaimable should be
> set. This miss of unreclaimable can cause has_under_min_watermark_zone
> to be set due to an unreclaimable zone preventing kswapd backing off
> on congestion_wait().
> 
> Reported-and-tested-by: Pádraig Brady <P@draigBrady.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  mm/vmscan.c |   23 +++++++++++++----------
>  1 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 841e3bf..9cebed1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2507,18 +2507,18 @@ loop_again:
>  				KSWAPD_ZONE_BALANCE_GAP_RATIO);
>  			if (!zone_watermark_ok_safe(zone, order,
>  					high_wmark_pages(zone) + balance_gap,
> -					end_zone, 0))
> +					end_zone, 0)) {
>  				shrink_zone(priority, zone, &sc);
> -			reclaim_state->reclaimed_slab = 0;
> -			nr_slab = shrink_slab(&shrink, sc.nr_scanned, lru_pages);
> -			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
> -			total_scanned += sc.nr_scanned;
>  
> -			if (zone->all_unreclaimable)
> -				continue;
> -			if (nr_slab == 0 &&
> -			    !zone_reclaimable(zone))
> -				zone->all_unreclaimable = 1;
> +				reclaim_state->reclaimed_slab = 0;
> +				nr_slab = shrink_slab(&shrink, sc.nr_scanned, lru_pages);
> +				sc.nr_reclaimed += reclaim_state->reclaimed_slab;
> +				total_scanned += sc.nr_scanned;
> +
> +				if (nr_slab == 0 && !zone_reclaimable(zone))
> +					zone->all_unreclaimable = 1;
> +			}
> +
>  			/*
>  			 * If we've done a decent amount of scanning and
>  			 * the reclaim ratio is low, start doing writepage
> @@ -2528,6 +2528,9 @@ loop_again:
>  			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
>  				sc.may_writepage = 1;
>  
> +			if (zone->all_unreclaimable)
> +				continue;
> +
>  			if (!zone_watermark_ok_safe(zone, order,
>  					high_wmark_pages(zone), end_zone, 0)) {
>  				all_zones_ok = 0;

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


