Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1EXEzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 00:55:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47796 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1EXEzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 00:55:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB3A1E.6090206@jp.fujitsu.com>
Date: Tue, 24 May 2011 13:54:54 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: minchan.kim@gmail.com
CC: abarry@cray.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mgorman@suse.de, riel@redhat.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org
Subject: Re: Unending loop in __alloc_pages_slowpath following OOM-kill; rfc:
 patch.
References: <4DCDA347.9080207@cray.com> <BANLkTikiXUzbsUkzaKZsZg+5ugruA2JdMA@mail.gmail.com> <4DD2991B.5040707@cray.com> <BANLkTimYEs315jjY9OZsL6--mRq3O_zbDA@mail.gmail.com> <20110520164924.GB2386@barrios-desktop>
In-Reply-To: <20110520164924.GB2386@barrios-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>From 8bd3f16736548375238161d1bd85f7d7c381031f Mon Sep 17 00:00:00 2001
> From: Minchan Kim <minchan.kim@gmail.com>
> Date: Sat, 21 May 2011 01:37:41 +0900
> Subject: [PATCH] Prevent unending loop in __alloc_pages_slowpath
> 
> From: Andrew Barry <abarry@cray.com>
> 
> I believe I found a problem in __alloc_pages_slowpath, which allows a process to
> get stuck endlessly looping, even when lots of memory is available.
> 
> Running an I/O and memory intensive stress-test I see a 0-order page allocation
> with __GFP_IO and __GFP_WAIT, running on a system with very little free memory.
> Right about the same time that the stress-test gets killed by the OOM-killer,
> the utility trying to allocate memory gets stuck in __alloc_pages_slowpath even
> though most of the systems memory was freed by the oom-kill of the stress-test.
> 
> The utility ends up looping from the rebalance label down through the
> wait_iff_congested continiously. Because order=0, __alloc_pages_direct_compact
> skips the call to get_page_from_freelist. Because all of the reclaimable memory
> on the system has already been reclaimed, __alloc_pages_direct_reclaim skips the
> call to get_page_from_freelist. Since there is no __GFP_FS flag, the block with
> __alloc_pages_may_oom is skipped. The loop hits the wait_iff_congested, then
> jumps back to rebalance without ever trying to get_page_from_freelist. This loop
> repeats infinitely.
> 
> The test case is pretty pathological. Running a mix of I/O stress-tests that do
> a lot of fork() and consume all of the system memory, I can pretty reliably hit
> this on 600 nodes, in about 12 hours. 32GB/node.
> 
> Signed-off-by: Andrew Barry <abarry@cray.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Cc: Mel Gorman <mgorman@suse.de>
> ---
>  mm/page_alloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3f8bce2..e78b324 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2064,6 +2064,7 @@ restart:
>  		first_zones_zonelist(zonelist, high_zoneidx, NULL,
>  					&preferred_zone);
>  
> +rebalance:
>  	/* This is the last chance, in general, before the goto nopage. */
>  	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
>  			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
> @@ -2071,7 +2072,6 @@ restart:
>  	if (page)
>  		goto got_pg;
>  
> -rebalance:
>  	/* Allocate without watermarks if the context allows */
>  	if (alloc_flags & ALLOC_NO_WATERMARKS) {
>  		page = __alloc_pages_high_priority(gfp_mask, order,

I'm sorry I missed this thread long time.

In this case, I think we should call drain_all_pages(). then following
patch is better.
However I also think your patch is valuable. because while the task is
sleeping in wait_iff_congested(), an another task may free some pages.
thus, rebalance path should try to get free pages. iow, you makes sense.

So, I'd like to propose to merge both your and my patch.

Thanks.


>From 2e77784668f6ca53d88ecb46aa6b99d9d0f33ffa Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 24 May 2011 13:41:57 +0900
Subject: [PATCH] vmscan: remove painful micro optimization

Currently, __alloc_pages_direct_reclaim() call get_page_from_freelist()
only if try_to_free_pages() return !0.

It's no necessary micro optimization becauase "return 0" mean vmscan reached
priority 0 and didn't get any pages, iow, it's really slow path. But also it
has bad side effect. If we don't call drain_all_pages(), we have a chance to
get infinite loop.

This patch remove its bad and meaningless micro optimization.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/page_alloc.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1572079..c41d488 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1950,9 +1950,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,

 	cond_resched();

-	if (unlikely(!(*did_some_progress)))
-		return NULL;
-
 retry:
 	page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
-- 
1.7.3.1




