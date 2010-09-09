Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab0IIDTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 23:19:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43612 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab0IIDT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 23:19:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 9 Sep 2010 12:14:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 06/10] vmscan: Narrow the scenarios lumpy reclaim uses
 synchrounous reclaim
Message-Id: <20100909121415.a1c05a45.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1283770053-18833-7-git-send-email-mel@csn.ul.ie>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
	<1283770053-18833-7-git-send-email-mel@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  6 Sep 2010 11:47:29 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> shrink_page_list() can decide to give up reclaiming a page under a
> number of conditions such as
> 
>   1. trylock_page() failure
>   2. page is unevictable
>   3. zone reclaim and page is mapped
>   4. PageWriteback() is true
>   5. page is swapbacked and swap is full
>   6. add_to_swap() failure
>   7. page is dirty and gfpmask don't have GFP_IO, GFP_FS
>   8. page is pinned
>   9. IO queue is congested
>  10. pageout() start IO, but not finished
> 
> When lumpy reclaim, all of failure result in entering synchronous lumpy
> reclaim but this can be unnecessary.  In cases (2), (3), (5), (6), (7) and
> (8), there is no point retrying.  This patch causes lumpy reclaim to abort
> when it is known it will fail.
> 
> Case (9) is more interesting. current behavior is,
>   1. start shrink_page_list(async)
>   2. found queue_congested()
>   3. skip pageout write
>   4. still start shrink_page_list(sync)
>   5. wait on a lot of pages
>   6. again, found queue_congested()
>   7. give up pageout write again
> 
> So, it's meaningless time wasting. However, just skipping page reclaim is
> also not a good as as x86 allocating a huge page needs 512 pages for example.
> It can have more dirty pages than queue congestion threshold (~=128).
> 
> After this patch, pageout() behaves as follows;
> 
>  - If order > PAGE_ALLOC_COSTLY_ORDER
> 	Ignore queue congestion always.
>  - If order <= PAGE_ALLOC_COSTLY_ORDER
> 	skip write page and disable lumpy reclaim.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

seems nice.
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


