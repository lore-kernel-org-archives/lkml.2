Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab1GNBpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 21:45:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38826 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1GNBpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 21:45:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 14 Jul 2011 10:38:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/5] mm: vmscan: Do not writeback filesystem pages in
 direct reclaim
Message-Id: <20110714103801.83e10fdb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1310567487-15367-2-git-send-email-mgorman@suse.de>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
	<1310567487-15367-2-git-send-email-mgorman@suse.de>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 15:31:23 +0100
Mel Gorman <mgorman@suse.de> wrote:

> From: Mel Gorman <mel@csn.ul.ie>
> 
> When kswapd is failing to keep zones above the min watermark, a process
> will enter direct reclaim in the same manner kswapd does. If a dirty
> page is encountered during the scan, this page is written to backing
> storage using mapping->writepage.
> 
> This causes two problems. First, it can result in very deep call
> stacks, particularly if the target storage or filesystem are complex.
> Some filesystems ignore write requests from direct reclaim as a result.
> The second is that a single-page flush is inefficient in terms of IO.
> While there is an expectation that the elevator will merge requests,
> this does not always happen. Quoting Christoph Hellwig;
> 
> 	The elevator has a relatively small window it can operate on,
> 	and can never fix up a bad large scale writeback pattern.
> 
> This patch prevents direct reclaim writing back filesystem pages by
> checking if current is kswapd. Anonymous pages are still written to
> swap as there is not the equivalent of a flusher thread for anonymos
> pages. If the dirty pages cannot be written back, they are placed
> back on the LRU lists.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Hm.


> ---
>  include/linux/mmzone.h |    1 +
>  mm/vmscan.c            |    9 +++++++++
>  mm/vmstat.c            |    1 +
>  3 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 9f7c3eb..b70a0c0 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -100,6 +100,7 @@ enum zone_stat_item {
>  	NR_UNSTABLE_NFS,	/* NFS unstable pages */
>  	NR_BOUNCE,
>  	NR_VMSCAN_WRITE,
> +	NR_VMSCAN_WRITE_SKIP,
>  	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
>  	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
>  	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 4f49535..2d3e5b6 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -825,6 +825,15 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  		if (PageDirty(page)) {
>  			nr_dirty++;
>  
> +			/*
> +			 * Only kswapd can writeback filesystem pages to
> +			 * avoid risk of stack overflow
> +			 */
> +			if (page_is_file_cache(page) && !current_is_kswapd()) {
> +				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
> +				goto keep_locked;
> +			}
> +


This will cause tons of memcg OOM kill because we have no help of kswapd (now).

Could you make this

	if (scanning_global_lru(sc) && page_is_file_cache(page) && !current_is_kswapd())
...


Then...sorry, please keep file system hook for a while. I'll do memcg dirty_ratio work
by myself if Greg will not post new version until the next month. After that, we can
remove scanning_global_lru(sc), I think.

Thanks,
-Kame

