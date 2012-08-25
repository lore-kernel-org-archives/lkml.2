Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab2HYXDH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 19:03:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab2HYXDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 19:03:04 -0400
Message-ID: <50395999.1030004@redhat.com>
Date: Sat, 25 Aug 2012 19:02:49 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] vmscan: sleep only if backingdev is congested
References: <1345619717-5322-1-git-send-email-minchan@kernel.org> <1345619717-5322-3-git-send-email-minchan@kernel.org>
In-Reply-To: <1345619717-5322-3-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 03:15 AM, Minchan Kim wrote:

> +++ b/mm/vmscan.c
> @@ -2705,8 +2705,16 @@ loop_again:
>   		if (total_scanned && (sc.priority < DEF_PRIORITY - 2)) {
>   			if (has_under_min_watermark_zone)
>   				count_vm_event(KSWAPD_SKIP_CONGESTION_WAIT);
> -			else
> -				congestion_wait(BLK_RW_ASYNC, HZ/10);
> +			else {
> +				for (i = 0; i <= end_zone; i++) {
> +					struct zone *zone = pgdat->node_zones
> +								+ i;
> +					if (!populated_zone(zone))
> +						continue;
> +					wait_iff_congested(zone, BLK_RW_ASYNC,
> +								HZ/10);
> +				}
> +			}
>   		}

Do we really want to wait on every zone?

That could increase the sleep time by a factor 3.

-- 
All rights reversed
