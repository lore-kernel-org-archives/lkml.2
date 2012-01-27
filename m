Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2A0Xb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 18:31:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2A0Xb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 18:31:28 -0500
Date: Fri, 27 Jan 2012 15:31:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v3 -mm 1/3] mm: reclaim at order 0 when compaction is
 enabled
Message-Id: <20120127153127.f1fa82c3.akpm@linux-foundation.org>
In-Reply-To: <20120126145914.58619765@cuia.bos.redhat.com>
References: <20120126145450.2d3d2f4c@cuia.bos.redhat.com>
	<20120126145914.58619765@cuia.bos.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012 14:59:14 -0500
Rik van Riel <riel@redhat.com> wrote:

> When built with CONFIG_COMPACTION, kswapd should not try to free
> contiguous pages, because it is not trying hard enough to have
> a real chance at being successful, but still disrupts the LRU
> enough to break other things.
> 
> Do not do higher order page isolation unless we really are in
> lumpy reclaim mode.
> 
> Stop reclaiming pages once we have enough free pages that
> compaction can deal with things, and we hit the normal order 0
> watermarks used by kswapd.
> 
> Also remove a line of code that increments balanced right before
> exiting the function.
> 
> ...
>
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1139,7 +1139,7 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode, int file)
>   * @mz:		The mem_cgroup_zone to pull pages from.
>   * @dst:	The temp list to put pages on to.
>   * @nr_scanned:	The number of pages that were scanned.
> - * @order:	The caller's attempted allocation order
> + * @sc:		The scan_control struct for this reclaim session
>   * @mode:	One of the LRU isolation modes
>   * @active:	True [1] if isolating active pages
>   * @file:	True [1] if isolating file [!anon] pages
> @@ -1148,8 +1148,8 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode, int file)
>   */
>  static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
>  		struct mem_cgroup_zone *mz, struct list_head *dst,
> -		unsigned long *nr_scanned, int order, isolate_mode_t mode,
> -		int active, int file)
> +		unsigned long *nr_scanned, struct scan_control *sc,
> +		isolate_mode_t mode, int active, int file)
>  {
>  	struct lruvec *lruvec;
>  	struct list_head *src;
> @@ -1195,7 +1195,7 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
>  			BUG();
>  		}
>  
> -		if (!order)
> +		if (!sc->order || !(sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM))

We should have a comment here explaining the reason for the code.

And the immediately following comment isn't very good: "Only take those
pages of the same active state as that tag page".  As is common with
poor comments, it tells us "what", but not "why".  Reclaiming inactive
_and_ inactive pages would make larger-page freeing more successful and
might be a good thing!  Apparently someone felt otherwise, but the
reader is kept in the dark...

