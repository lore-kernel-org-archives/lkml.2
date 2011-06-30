Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab1F3CYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 22:24:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36414 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab1F3CYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 22:24:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E0BDE2B.50006@jp.fujitsu.com>
Date: Thu, 30 Jun 2011 11:23:39 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: mgorman@suse.de
CC: akpm@linux-foundation.org, P@draigBrady.com,
        James.Bottomley@HansenPartnership.com, colin.king@canonical.com,
        minchan.kim@gmail.com, luto@mit.edu, riel@redhat.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm: vmscan: Correct check for kswapd sleeping in
 sleeping_prematurely
References: <1308926697-22475-1-git-send-email-mgorman@suse.de> <1308926697-22475-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1308926697-22475-2-git-send-email-mgorman@suse.de>
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
> A problem occurs if the highest zone is small.  balance_pgdat()
> only considers unreclaimable zones when priority is DEF_PRIORITY
> but sleeping_prematurely considers all zones. It's possible for this
> sequence to occur
> 
>   1. kswapd wakes up and enters balance_pgdat()
>   2. At DEF_PRIORITY, marks highest zone unreclaimable
>   3. At DEF_PRIORITY-1, ignores highest zone setting end_zone
>   4. At DEF_PRIORITY-1, calls shrink_slab freeing memory from
>         highest zone, clearing all_unreclaimable. Highest zone
>         is still unbalanced
>   5. kswapd returns and calls sleeping_prematurely
>   6. sleeping_prematurely looks at *all* zones, not just the ones
>      being considered by balance_pgdat. The highest small zone
>      has all_unreclaimable cleared but but the zone is not
>      balanced. all_zones_ok is false so kswapd stays awake
> 
> This patch corrects the behaviour of sleeping_prematurely to check
> the zones balance_pgdat() checked.
> 
> Reported-and-tested-by: Pádraig Brady <P@draigBrady.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  mm/vmscan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8ff834e..841e3bf 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2323,7 +2323,7 @@ static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining,
>  		return true;
>  
>  	/* Check the watermark levels */
> -	for (i = 0; i < pgdat->nr_zones; i++) {
> +	for (i = 0; i <= classzone_idx; i++) {
>  		struct zone *zone = pgdat->node_zones + i;
>  
>  		if (!populated_zone(zone))

sorry for the delay.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




