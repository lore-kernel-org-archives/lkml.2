Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab2KUBFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:05:50 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49952 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab2KUBFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:05:49 -0500
X-AuditID: 9c930197-b7bd3ae000003f1c-2d-50ac28eb7c8d
Date: Wed, 21 Nov 2012 10:05:56 +0900
From: Minchan Kim <minchan@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] mm: cma: allocate pages from CMA if NR_FREE_PAGES
 approaches low water mark
Message-ID: <20121121010556.GD447@bbox>
References: <1352710782-25425-1-git-send-email-m.szyprowski@samsung.com>
 <20121120000137.GC447@bbox>
 <50AB987F.30002@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AB987F.30002@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 03:49:35PM +0100, Marek Szyprowski wrote:
> Hello,
> 
> On 11/20/2012 1:01 AM, Minchan Kim wrote:
> >Hi Marek,
> >
> >On Mon, Nov 12, 2012 at 09:59:42AM +0100, Marek Szyprowski wrote:
> >> It has been observed that system tends to keep a lot of CMA free pages
> >> even in very high memory pressure use cases. The CMA fallback for movable
> >
> >CMA free pages are just fallback for movable pages so if user requires many
> >user pages, it ends up consuming cma free pages after out of movable pages.
> >What do you mean that system tend to keep free pages even in very
> >high memory pressure?
> >> pages is used very rarely, only when system is completely pruned from
> >> MOVABLE pages, what usually means that the out-of-memory even will be
> >> triggered very soon. To avoid such situation and make better use of CMA
> >
> >Why does OOM is triggered very soon if movable pages are burned out while
> >there are many cma pages?
> >
> >It seems I can't understand your point quitely.
> >Please make your problem clear for silly me to understand clearly.
> 
> Right now running out of 'plain' movable pages is the only possibility to
> get movable pages allocated from CMA. On the other hand running out of
> 'plain' movable pages is very deadly for the system, as movable pageblocks
> are also the main fallbacks for reclaimable and non-movable pages.
> 
> Then, once we run out of movable pages and kernel needs non-mobable or
> reclaimable page (what happens quite often), it usually triggers OOM to
> satisfy the memory needs. Such OOM is very strange, especially on a system
> with dozen of megabytes of CMA memory, having most of them free at the OOM
> event. By high memory pressure I mean the high memory usage.

So your concern is that too many free pages in MIGRATE_CMA when OOM happens
is odd? It's natural with considering CMA design which kernel never fallback
non-movable page allocation to CMA area. I guess it's not a your concern.

Let's think below extreme cases.

= Before =

* 1000M DRAM system.
* 400M kernel used pages.
* 300M movable used pages.
* 300M cma freed pages.

1. kernel want to request 400M non-movable memory, additionally.
2. VM start to reclaim 300M movable pages.
3. But it's not enough to meet 400M request.
4. go to OOM. (It's natural)

= After(with your patch) =

* 1000M DRAM system.
* 400M kernel used pages.
* 300M movable *freed* pages.
* 300M cma used pages(by your patch, I simplified your concept)

1. kernel want to request 400M non-movable memory.
2. 300M movable freed pages isn't enough to meet 400M request.
3. Also, there is no point to reclaim CMA pages for non-movable allocation.
4. go to OOM. (It's natural)

There is no difference between before and after in allocation POV.
Let's think another example.

= Before =

* 1000M DRAM system.
* 400M kernel used pages.
* 300M movable used pages.
* 300M cma freed pages.

1. kernel want to request 300M non-movable memory.
2. VM start to reclaim 300M movable pages.
3. It's enough to meet 300M request.
4. happy end

= After(with your patch) =

* 1000M DRAM system.
* 400M kernel used pages.
* 300M movable *freed* pages.
* 300M cma used pages(by your patch, I simplified your concept)

1. kernel want to request 300M non-movable memory.
2. 300M movable freed pages is enough to meet 300M request.
3. happy end.

There is no difference in allocation POV, too.

So I guess that if you see OOM while there are many movable pages,
I think principal problem is VM reclaimer which should try to reclaim
best effort if there are freeable movable pages. If VM reclaimer has
some problem for your workload, firstly we should try fix it rather than
adding such heuristic to hot path. Otherwise, if you see OOM while there
are many free CMA pages, it's not odd to me.

> 
> This patch introduces a heuristics which let kernel to consume free CMA
> pages before it runs out of 'plain' movable pages, what is usually enough to
> keep some spare movable pages for emergency cases before the reclaim occurs.
> 
> Best regards
> -- 
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
