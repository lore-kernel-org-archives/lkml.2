Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab1GMAml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 20:42:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41159 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab1GMAmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 20:42:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E1CE9FF.3050707@jp.fujitsu.com>
Date: Wed, 13 Jul 2011 09:42:39 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: mgorman@suse.de
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: page allocator: Reconsider zones for allocation
 after direct reclaim
References: <1310389274-13995-1-git-send-email-mgorman@suse.de> <1310389274-13995-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1310389274-13995-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/11 22:01), Mel Gorman wrote:
> With zone_reclaim_mode enabled, it's possible for zones to be considered
> full in the zonelist_cache so they are skipped in the future. If the
> process enters direct reclaim, the ZLC may still consider zones to be
> full even after reclaiming pages. Reconsider all zones for allocation
> if direct reclaim returns successfully.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Hmmm...

I like the concept, but I'm worry about a corner case a bit.

If users are using cpusets/mempolicy, direct reclaim don't scan all zones.
Then, zlc_clear_zones_full() seems too aggressive operation.
Instead, couldn't we turn zlc->fullzones off from kswapd?


> ---
>  mm/page_alloc.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6913854..149409c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1616,6 +1616,21 @@ static void zlc_mark_zone_full(struct zonelist *zonelist, struct zoneref *z)
>  	set_bit(i, zlc->fullzones);
>  }
>  
> +/*
> + * clear all zones full, called after direct reclaim makes progress so that
> + * a zone that was recently full is not skipped over for up to a second
> + */
> +static void zlc_clear_zones_full(struct zonelist *zonelist)
> +{
> +	struct zonelist_cache *zlc;	/* cached zonelist speedup info */
> +
> +	zlc = zonelist->zlcache_ptr;
> +	if (!zlc)
> +		return;
> +
> +	bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
> +}
> +
>  #else	/* CONFIG_NUMA */
>  
>  static nodemask_t *zlc_setup(struct zonelist *zonelist, int alloc_flags)
> @@ -1963,6 +1978,10 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
>  	if (unlikely(!(*did_some_progress)))
>  		return NULL;
>  
> +	/* After successful reclaim, reconsider all zones for allocation */
> +	if (NUMA_BUILD)
> +		zlc_clear_zones_full(zonelist);
> +
>  retry:
>  	page = get_page_from_freelist(gfp_mask, nodemask, order,
>  					zonelist, high_zoneidx,


