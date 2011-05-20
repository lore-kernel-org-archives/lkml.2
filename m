Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935324Ab1ETQtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:49:39 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:57761 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935006Ab1ETQth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:49:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=hy617j3M0nWueVQI5ClM4I7H8kalWBBFagVlcsipme9GtyTZCzaQz7pJbvSRM5qDq4
         uaM03+OI2kk3TsLXZCl3vHpK5ohDS7t74gEUwfMYqShI8unApOmyt1/fSwk6rfFyG9XU
         WJbENi1iJSsqXAggE3WQEwpImW8nJbpojH9Z4=
Date: Sat, 21 May 2011 01:49:24 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Barry <abarry@cray.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Unending loop in __alloc_pages_slowpath following OOM-kill;
 rfc: patch.
Message-ID: <20110520164924.GB2386@barrios-desktop>
References: <4DCDA347.9080207@cray.com>
 <BANLkTikiXUzbsUkzaKZsZg+5ugruA2JdMA@mail.gmail.com>
 <4DD2991B.5040707@cray.com>
 <BANLkTimYEs315jjY9OZsL6--mRq3O_zbDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimYEs315jjY9OZsL6--mRq3O_zbDA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 07:29:01AM +0900, Minchan Kim wrote:
> Hi Andrew,
> 
> On Wed, May 18, 2011 at 12:49 AM, Andrew Barry <abarry@cray.com> wrote:
> > On 05/17/2011 05:34 AM, Minchan Kim wrote:
> >> On Sat, May 14, 2011 at 6:31 AM, Andrew Barry <abarry@cray.com> wrote:
> >>> I believe I found a problem in __alloc_pages_slowpath, which allows a process to
> >>> get stuck endlessly looping, even when lots of memory is available.
> >>>
> >>> Running an I/O and memory intensive stress-test I see a 0-order page allocation
> >>> with __GFP_IO and __GFP_WAIT, running on a system with very little free memory.
> >>> Right about the same time that the stress-test gets killed by the OOM-killer,
> >>> the utility trying to allocate memory gets stuck in __alloc_pages_slowpath even
> >>> though most of the systems memory was freed by the oom-kill of the stress-test.
> >>>
> >>> The utility ends up looping from the rebalance label down through the
> >>> wait_iff_congested continiously. Because order=0, __alloc_pages_direct_compact
> >>> skips the call to get_page_from_freelist. Because all of the reclaimable memory
> >>> on the system has already been reclaimed, __alloc_pages_direct_reclaim skips the
> >>> call to get_page_from_freelist. Since there is no __GFP_FS flag, the block with
> >>> __alloc_pages_may_oom is skipped. The loop hits the wait_iff_congested, then
> >>> jumps back to rebalance without ever trying to get_page_from_freelist. This loop
> >>> repeats infinitely.
> >>>
> >>> Is there a reason that this loop is set up this way for 0 order allocations? I
> >>> applied the below patch, and the problem corrects itself. Does anyone have any
> >>> thoughts on the patch, or on a better way to address this situation?
> >>>
> >>> The test case is pretty pathological. Running a mix of I/O stress-tests that do
> >>> a lot of fork() and consume all of the system memory, I can pretty reliably hit
> >>> this on 600 nodes, in about 12 hours. 32GB/node.
> >>>
> >>
> >> It's amazing.
> >> I think it's _very_ rare but it's possible if test program killed by
> >> oom has only lots of anonymous pages and allocation tasks try to
> >> allocate order-0 page with GFP_NOFS.
> >
> > Unfortunately very rare is a subjective thing. We have been hitting it a couple
> > times a week in our test lab.
> 
> Okay.
> 
> >
> >> When the [in]active lists are empty suddenly(But I am not sure how
> >> come the situation happens.) and we are reclaiming order-0 page,
> >> compaction and __alloc_pages_direct_reclaim doesn't work. compaction
> >> doesn't work as it's order-0 page reclaiming.  In case of
> >> __alloc_pages_direct_reclaim, it would work only if we have lru pages
> >> in [in]active list. But unfortunately we don't have any pages in lru
> >> list.
> >> So, last resort is following codes in do_try_to_free_pages.
> >>
> >>         /* top priority shrink_zones still had more to do? don't OOM, then */
> >>         if (scanning_global_lru(sc) && !all_unreclaimable(zonelist, sc))
> >>                 return 1;
> >>
> >> But it has a problem, too. all_unreclaimable checks zone->all_unreclaimable.
> >> zone->all_unreclaimable is set by below condition.
> >>
> >> zone->pages_scanned < zone_reclaimable_pages(zone) * 6
> >>
> >> If lru list is completely empty, shrink_zone doesn't work so
> >> zone->pages_scanned would be zero. But as we know, zone_page_state
> >> isn't exact by per_cpu_pageset. So it might be positive value. After
> >> all, zone_reclaimable always return true. It means kswapd never set
> >> zone->all_unreclaimable.  So last resort become nop.
> >>
> >> In this case, current allocation doesn't have a chance to call
> >> get_page_from_freelist as Andrew Barry said.
> >>
> >> Does it make sense?
> >> If it is, how about this?
> >>
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index ebc7faa..4f64355 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -2105,6 +2105,7 @@ restart:
> >>                 first_zones_zonelist(zonelist, high_zoneidx, NULL,
> >>                                         &preferred_zone);
> >>
> >> +rebalance:
> >>         /* This is the last chance, in general, before the goto nopage. */
> >>         page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
> >>                         high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
> >> @@ -2112,7 +2113,6 @@ restart:
> >>         if (page)
> >>                 goto got_pg;
> >>
> >> -rebalance:
> >>         /* Allocate without watermarks if the context allows */
> >>         if (alloc_flags & ALLOC_NO_WATERMARKS) {
> >>                 page = __alloc_pages_high_priority(gfp_mask, order,
> >
> > I think your solution is simpler than my patch.
> > Thanks very much.
> 
> You find the problem and it's harder than fix, I think.
> So I think you have to get a credit.
> 
> Could you send the patch to akpm with Cced Mel and me?
> (Maybe it's the subject to send stable).
> You can get my Reviewed-by.
> 
> Thanks for the good bug reporting.

>From 8bd3f16736548375238161d1bd85f7d7c381031f Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan.kim@gmail.com>
Date: Sat, 21 May 2011 01:37:41 +0900
Subject: [PATCH] Prevent unending loop in __alloc_pages_slowpath

From: Andrew Barry <abarry@cray.com>

I believe I found a problem in __alloc_pages_slowpath, which allows a process to
get stuck endlessly looping, even when lots of memory is available.

Running an I/O and memory intensive stress-test I see a 0-order page allocation
with __GFP_IO and __GFP_WAIT, running on a system with very little free memory.
Right about the same time that the stress-test gets killed by the OOM-killer,
the utility trying to allocate memory gets stuck in __alloc_pages_slowpath even
though most of the systems memory was freed by the oom-kill of the stress-test.

The utility ends up looping from the rebalance label down through the
wait_iff_congested continiously. Because order=0, __alloc_pages_direct_compact
skips the call to get_page_from_freelist. Because all of the reclaimable memory
on the system has already been reclaimed, __alloc_pages_direct_reclaim skips the
call to get_page_from_freelist. Since there is no __GFP_FS flag, the block with
__alloc_pages_may_oom is skipped. The loop hits the wait_iff_congested, then
jumps back to rebalance without ever trying to get_page_from_freelist. This loop
repeats infinitely.

The test case is pretty pathological. Running a mix of I/O stress-tests that do
a lot of fork() and consume all of the system memory, I can pretty reliably hit
this on 600 nodes, in about 12 hours. 32GB/node.

Signed-off-by: Andrew Barry <abarry@cray.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3f8bce2..e78b324 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2064,6 +2064,7 @@ restart:
 		first_zones_zonelist(zonelist, high_zoneidx, NULL,
 					&preferred_zone);
 
+rebalance:
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
@@ -2071,7 +2072,6 @@ restart:
 	if (page)
 		goto got_pg;
 
-rebalance:
 	/* Allocate without watermarks if the context allows */
 	if (alloc_flags & ALLOC_NO_WATERMARKS) {
 		page = __alloc_pages_high_priority(gfp_mask, order,
-- 
1.7.1


> 
> > -Andrew
> >
> >
> >
> >
> >
> >
> 
> 
> 
> -- 
> Kind regards,
> Minchan Kim

-- 
Kind regards,
Minchan Kim
