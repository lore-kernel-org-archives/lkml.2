Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab0KZCbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 21:31:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41154 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0KZCbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 21:31:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: Free memory never fully used, swapping
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        Simon Kirby <sim@hostway.ca>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <1290736844.12777.10.camel@sli10-conroe>
References: <20101125161524.GE26037@csn.ul.ie> <1290736844.12777.10.camel@sli10-conroe>
Message-Id: <20101126110244.B6DC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 26 Nov 2010 11:31:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> record the order seems not sufficient. in balance_pgdat(), the for look
> exit only when:
> priority <0 or sc.nr_reclaimed >= SWAP_CLUSTER_MAX.
> but we do if (sc.nr_reclaimed < SWAP_CLUSTER_MAX)
>                         order = sc.order = 0;
> this means before we set order to 0, we already reclaimed a lot of
> pages, so I thought we need set order to 0 earlier before there are
> enough free pages. below is a debug patch.
> 
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d31d7ce..ee5d2ed 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2117,6 +2117,26 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
>  }
>  #endif
>  
> +static int all_zone_enough_free_pages(pg_data_t *pgdat)
> +{
> +	int i;
> +
> +	for (i = 0; i < pgdat->nr_zones; i++) {
> +		struct zone *zone = pgdat->node_zones + i;
> +
> +		if (!populated_zone(zone))
> +			continue;
> +
> +		if (zone->all_unreclaimable)
> +			continue;
> +
> +		if (!zone_watermark_ok(zone, 0, high_wmark_pages(zone) * 8,
> +								0, 0))
> +			return 0;
> +	}
> +	return 1;
> +}
> +
>  /* is kswapd sleeping prematurely? */
>  static int sleeping_prematurely(pg_data_t *pgdat, int order, long remaining)
>  {
> @@ -2355,7 +2375,8 @@ out:
>  		 * back to sleep. High-order users can still perform direct
>  		 * reclaim if they wish.
>  		 */
> -		if (sc.nr_reclaimed < SWAP_CLUSTER_MAX)
> +		if (sc.nr_reclaimed < SWAP_CLUSTER_MAX ||
> +		    (order > 0 && all_zone_enough_free_pages(pgdat)))
>  			order = sc.order = 0;

Ummm. this doesn't work. this place is processed every 32 pages reclaimed.
(see below code and comment). Theresore your patch break high order reclaim
logic.


                /*
                 * We do this so kswapd doesn't build up large priorities for
                 * example when it is freeing in parallel with allocators. It
                 * matches the direct reclaim path behaviour in terms of impact
                 * on zone->*_priority.
                 */
                if (sc.nr_reclaimed >= SWAP_CLUSTER_MAX)
                        break;


