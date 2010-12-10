Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab0LJB3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 20:29:22 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45858 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab0LJB3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 20:29:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 10 Dec 2010 10:23:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] mm: kswapd: Treat zone->all_unreclaimable in
 sleeping_prematurely similar to balance_pgdat()
Message-Id: <20101210102337.8ff1fad2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1291893500-12342-6-git-send-email-mel@csn.ul.ie>
References: <1291893500-12342-1-git-send-email-mel@csn.ul.ie>
	<1291893500-12342-6-git-send-email-mel@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 Dec 2010 11:18:19 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> After DEF_PRIORITY, balance_pgdat() considers all_unreclaimable zones to
> be balanced but sleeping_prematurely does not. This can force kswapd to
> stay awake longer than it should. This patch fixes it.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Hmm, maybe the logic works well but I don't like very much.

How about adding below instead of pgdat->node_present_pages ?

static unsigned long required_balanced_pages(pgdat, classzone_idx)
{
	unsigned long present = 0;

	for_each_zone_in_node(zone, pgdat) {
		if (zone->all_unreclaimable) /* Ignore unreclaimable zone at checking balance */
			continue;
		if (zone_idx(zone) > classzone_idx)
			continue;
		present = zone->present_pages;
	}
	return present;
}

> ---
>  mm/vmscan.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bc233d8..d7b0a3c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2149,8 +2149,16 @@ static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining)
>  		if (!populated_zone(zone))
>  			continue;
>  
> -		if (zone->all_unreclaimable)
> +		/*
> +		 * balance_pgdat() skips over all_unreclaimable after
> +		 * DEF_PRIORITY. Effectively, it considers them balanced so
> +		 * they must be considered balanced here as well if kswapd
> +		 * is to sleep
> +		 */
> +		if (zone->all_unreclaimable) {
> +			balanced += zone->present_pages;
>  			continue;
> +		}
>  
>  		if (!zone_watermark_ok(zone, order, high_wmark_pages(zone),
>  								0, 0))
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

