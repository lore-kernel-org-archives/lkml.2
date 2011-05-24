Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1EXIen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:34:43 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56021 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab1EXIel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:34:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b4DSc6+b82aHfCuDwN/Jq/Z9KZHJfaCzmtDzwTgIkKIkWp5devAwuWvIhYSqi9/oax
         iEBwEQ/HwM9kzf9IePWtMfb87LrVW2SIHXmDBiVRF1nenFz8lVyYR8pIm7JY8GJLu+oF
         36iYf9TT1Wfm8uoaFLlv2J6wDfvV2gjWTIJ9Q=
MIME-Version: 1.0
In-Reply-To: <4DDB3A1E.6090206@jp.fujitsu.com>
References: <4DCDA347.9080207@cray.com>
	<BANLkTikiXUzbsUkzaKZsZg+5ugruA2JdMA@mail.gmail.com>
	<4DD2991B.5040707@cray.com>
	<BANLkTimYEs315jjY9OZsL6--mRq3O_zbDA@mail.gmail.com>
	<20110520164924.GB2386@barrios-desktop>
	<4DDB3A1E.6090206@jp.fujitsu.com>
Date: Tue, 24 May 2011 17:34:40 +0900
Message-ID: <BANLkTinkcu5j1H8tHNT4aTmOL-GXfSwPQw@mail.gmail.com>
Subject: Re: Unending loop in __alloc_pages_slowpath following OOM-kill; rfc: patch.
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: abarry@cray.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mgorman@suse.de, riel@redhat.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 1:54 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>>>From 8bd3f16736548375238161d1bd85f7d7c381031f Mon Sep 17 00:00:00 2001
>> From: Minchan Kim <minchan.kim@gmail.com>
>> Date: Sat, 21 May 2011 01:37:41 +0900
>> Subject: [PATCH] Prevent unending loop in __alloc_pages_slowpath
>>
>> From: Andrew Barry <abarry@cray.com>
>>
>> I believe I found a problem in __alloc_pages_slowpath, which allows a process to
>> get stuck endlessly looping, even when lots of memory is available.
>>
>> Running an I/O and memory intensive stress-test I see a 0-order page allocation
>> with __GFP_IO and __GFP_WAIT, running on a system with very little free memory.
>> Right about the same time that the stress-test gets killed by the OOM-killer,
>> the utility trying to allocate memory gets stuck in __alloc_pages_slowpath even
>> though most of the systems memory was freed by the oom-kill of the stress-test.
>>
>> The utility ends up looping from the rebalance label down through the
>> wait_iff_congested continiously. Because order=0, __alloc_pages_direct_compact
>> skips the call to get_page_from_freelist. Because all of the reclaimable memory
>> on the system has already been reclaimed, __alloc_pages_direct_reclaim skips the
>> call to get_page_from_freelist. Since there is no __GFP_FS flag, the block with
>> __alloc_pages_may_oom is skipped. The loop hits the wait_iff_congested, then
>> jumps back to rebalance without ever trying to get_page_from_freelist. This loop
>> repeats infinitely.
>>
>> The test case is pretty pathological. Running a mix of I/O stress-tests that do
>> a lot of fork() and consume all of the system memory, I can pretty reliably hit
>> this on 600 nodes, in about 12 hours. 32GB/node.
>>
>> Signed-off-by: Andrew Barry <abarry@cray.com>
>> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
>> Cc: Mel Gorman <mgorman@suse.de>
>> ---
>>  mm/page_alloc.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 3f8bce2..e78b324 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -2064,6 +2064,7 @@ restart:
>>               first_zones_zonelist(zonelist, high_zoneidx, NULL,
>>                                       &preferred_zone);
>>
>> +rebalance:
>>       /* This is the last chance, in general, before the goto nopage. */
>>       page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
>>                       high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
>> @@ -2071,7 +2072,6 @@ restart:
>>       if (page)
>>               goto got_pg;
>>
>> -rebalance:
>>       /* Allocate without watermarks if the context allows */
>>       if (alloc_flags & ALLOC_NO_WATERMARKS) {
>>               page = __alloc_pages_high_priority(gfp_mask, order,
>
> I'm sorry I missed this thread long time.

No problem. It would be better than not review.

>
> In this case, I think we should call drain_all_pages(). then following
> patch is better.

Strictly speaking, this problem isn't related to drain_all_pages.
This problem caused by lru empty but I admit it could work well if
your patch applied.
So yours could help, too.

> However I also think your patch is valuable. because while the task is
> sleeping in wait_iff_congested(), an another task may free some pages.
> thus, rebalance path should try to get free pages. iow, you makes sense.

Yes.
Off-topic.
I would like to move cond_resched below get_page_from_freelist in
__alloc_pages_direct_reclaim. Otherwise, it is likely we can be stolen
pages to other processes.
One more benefit is that if it's apparently OOM path(ie,
did_some_progress = 0), we can reduce OOM kill latency due to remove
unnecessary cond_resched.

>
> So, I'd like to propose to merge both your and my patch.

Recently, there was discussion on drain_all_pages with Wu.
He saw much overhead in 8-core system, AFAIR.
I Cced Wu.

How about checking per-cpu before calling drain_all_pages() than
unconditional calling?
if (per_cpu_ptr(zone->pageset, smp_processor_id())
    drain_all_pages();

Of course, It can miss other CPU free pages. But above routine assume
local cpu direct reclaim is successful but it failed by per-cpu. So I
think it works.

Thanks for good suggestion and Reviewed-by, KOSAKI.
-- 
Kind regards,
Minchan Kim
