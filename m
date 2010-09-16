Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab0IPW2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:28:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877Ab0IPW2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:28:50 -0400
Date: Thu, 16 Sep 2010 15:28:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 8/8] writeback: Do not sleep on the congestion queue if
 there are no congested BDIs or if significant congestion is not being
 encountered in the current zone
Message-Id: <20100916152810.cb074e9f.akpm@linux-foundation.org>
In-Reply-To: <1284553671-31574-9-git-send-email-mel@csn.ul.ie>
References: <1284553671-31574-1-git-send-email-mel@csn.ul.ie>
	<1284553671-31574-9-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 13:27:51 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> If wait_iff_congested() is called with no BDI congested, the function simply
> calls cond_resched(). In the event there is significant writeback happening
> in the zone that is being reclaimed, this can be a poor decision as reclaim
> would succeed once writeback was completed. Without any backoff logic,
> younger clean pages can be reclaimed resulting in more reclaim overall and
> poor performance.

This is because cond_resched() is a no-op, and we skip around the
under-writeback pages and go off and look further along the LRU for
younger clean pages, yes?

> This patch tracks how many pages backed by a congested BDI were found during
> scanning. If all the dirty pages encountered on a list isolated from the
> LRU belong to a congested BDI, the zone is marked congested until the zone
> reaches the high watermark.

High watermark, or low watermark?

The terms are rather ambiguous so let's avoid them.  Maybe "full"
watermark and "empty"?

>
> ...
>
> @@ -706,6 +726,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  			goto keep;
>  
>  		VM_BUG_ON(PageActive(page));
> +		VM_BUG_ON(page_zone(page) != zone);

?

>  		sc->nr_scanned++;
>  
>
> ...
>
> @@ -903,6 +928,15 @@ keep_lumpy:
>  		VM_BUG_ON(PageLRU(page) || PageUnevictable(page));
>  	}
>  
> +	/*
> +	 * Tag a zone as congested if all the dirty pages encountered were
> +	 * backed by a congested BDI. In this case, reclaimers should just
> +	 * back off and wait for congestion to clear because further reclaim
> +	 * will encounter the same problem
> +	 */
> +	if (nr_dirty == nr_congested)
> +		zone_set_flag(zone, ZONE_CONGESTED);

The implicit "100%" there is a magic number.  hrm.


