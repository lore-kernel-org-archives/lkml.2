Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1KXBJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 20:09:10 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59283 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1KXBJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 20:09:08 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Nov 2011 10:07:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Shaohua Li <shaohua.li@intel.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/5] mm: try to distribute dirty pages fairly across
 zones
Message-Id: <20111124100755.d8b783a8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322055258-3254-4-git-send-email-hannes@cmpxchg.org>
References: <1322055258-3254-1-git-send-email-hannes@cmpxchg.org>
	<1322055258-3254-4-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Can I make a question ?

On Wed, 23 Nov 2011 14:34:16 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:


> +		/*
> +		 * When allocating a page cache page for writing, we
> +		 * want to get it from a zone that is within its dirty
> +		 * limit, such that no single zone holds more than its
> +		 * proportional share of globally allowed dirty pages.
> +		 * The dirty limits take into account the zone's
> +		 * lowmem reserves and high watermark so that kswapd
> +		 * should be able to balance it without having to
> +		 * write pages from its LRU list.
> +		 *
> +		 * This may look like it could increase pressure on
> +		 * lower zones by failing allocations in higher zones
> +		 * before they are full.  But the pages that do spill
> +		 * over are limited as the lower zones are protected
> +		 * by this very same mechanism.  It should not become
> +		 * a practical burden to them.
> +		 *
> +		 * XXX: For now, allow allocations to potentially
> +		 * exceed the per-zone dirty limit in the slowpath
> +		 * (ALLOC_WMARK_LOW unset) before going into reclaim,
> +		 * which is important when on a NUMA setup the allowed
> +		 * zones are together not big enough to reach the
> +		 * global limit.  The proper fix for these situations
> +		 * will require awareness of zones in the
> +		 * dirty-throttling and the flusher threads.
> +		 */
> +		if ((alloc_flags & ALLOC_WMARK_LOW) &&
> +		    (gfp_mask & __GFP_WRITE) && !zone_dirty_ok(zone))
> +			goto this_zone_full;
>  
>  		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
>  		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {

This wil call 

                if (NUMA_BUILD)
                        zlc_mark_zone_full(zonelist, z);

And this zone will be marked as full. 

IIUC, zlc_clear_zones_full() is called only when direct reclaim ends.
So, if no one calls direct-reclaim, 'full' mark may never be cleared
even when number of dirty pages goes down to safe level ?
I'm sorry if this is alread discussed.

Thanks,
-Kame


