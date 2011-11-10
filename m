Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935730Ab1KJQa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:30:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37243 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935702Ab1KJQaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:30:25 -0500
MIME-Version: 1.0
In-Reply-To: <20111110161331.GG3083@suse.de>
References: <20111110100616.GD3083@suse.de>
	<20111110142202.GE3083@suse.de>
	<CAEwNFnCRCxrru5rBk7FpypqeL8nD=SY5W3-TaA7Ap5o4CgDSbg@mail.gmail.com>
	<20111110161331.GG3083@suse.de>
Date: Fri, 11 Nov 2011 01:30:24 +0900
Message-ID: <CAEwNFnCjZ9u-XsoJckQoz9WAs3O2_rRLJXjsDDFE_n+zMSf+Lw@mail.gmail.com>
Subject: Re: [PATCH] mm: Do not stall in synchronous compaction for THP allocations
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 1:13 AM, Mel Gorman <mgorman@suse.de> wrote:
> On Fri, Nov 11, 2011 at 12:12:01AM +0900, Minchan Kim wrote:
>> Hi Mel,
>>
>> You should have Cced with me because __GFP_NORETRY is issued by me.
>>
>
> I don't understand. __GFP_NORETRY has been around a long time ago
> and has loads of users. Do you have particular concerns about the
> behaviour of __GFP_NORETRY?

It seems that I got misunderstood your point.
I thought you mentioned this.

http://www.spinics.net/lists/linux-mm/msg16371.html


>
>> On Thu, Nov 10, 2011 at 11:22 PM, Mel Gorman <mgorman@suse.de> wrote:
>> > On Thu, Nov 10, 2011 at 10:06:16AM +0000, Mel Gorman wrote:
>> >> than stall. It was suggested that __GFP_NORETRY be used instead of
>> >> __GFP_NO_KSWAPD. This would look less like a special case but would
>> >> still cause compaction to run at least once with sync compaction.
>> >>
>> >
>> > This comment is bogus - __GFP_NORETRY would have caught THP allocations
>> > and would not call sync compaction. The issue was that it would also
>> > have caught any hypothetical high-order GFP_THISNODE allocations that
>> > end up calling compaction here
>>
>> In fact, the I support patch concept so I would like to give
>>
>> Acked-by: Minchan Kim <minchan.kim@gmail.com>
>> But it is still doubt about code.
>>
>> __GFP_NORETRY: The VM implementation must not retry indefinitely
>>
>> What could people think if they look at above comment?
>> At least, I can imagine two
>>
>> First, it is related on *latency*.
>
> I never read it to mean that. I always read it to mean "it must
> not retry indefinitely". I expected it was still fine to try direct
> reclaim which is not a latency-sensitive operation.
>
>> Second, "I can handle if VM fails allocation"
>>
>
> Fully agreed.
>
>> I am biased toward latter.
>> Then, __GFP_NO_KSWAPD is okay? It means "let's avoid sync compaction
>> or long latency"?
>
> and do not wake kswapd to swap additional pages.
>
>> It's rather awkward name. Already someone started to use
>> __GFP_NO_KSWAPD as such purpose.
>> See mtd_kmalloc_up_to. He mentioned in comment of function as follows,
>>
>>  * the system page size. This attempts to make sure it does not adversely
>>  * impact system performance, so when allocating more than one page, we
>>  * ask the memory allocator to avoid re-trying, swapping, writing back
>>  * or performing I/O.
>>
>
> I was not aware of this user although their reason for using it
> seems fine. We are not breaking their expectations with this patch but
> it is a slippery slope.
>
>> That thing was what I concerned.
>> In future, new users of __GFP_NO_KSWAPD is coming and we can't prevent
>> them under our sight.
>> So I hope we can change the flag name or fix above code and comment
>> out __GFP_NO_KSWAPD
>>
>
> I can't think of a better name but we can at least improve the comment.
>
>> /*
>>  * __GFP_NO_KSWAPD is very VM internal flag so Please don't use it
>> without allowing mm guys
>>  *
>> #define __GFP_NO_KSWAPD xxxx
>>
>> >
>> >                /*
>> >                 * High-order allocations do not necessarily loop after
>> >                 * direct reclaim and reclaim/compaction depends on
>> >                 * compaction being called after reclaim so call directly if
>> >                 * necessary
>> >                 */
>> >                page = __alloc_pages_direct_compact(gfp_mask, order,
>> >                                        zonelist, high_zoneidx,
>> >                                        nodemask,
>> >                                        alloc_flags, preferred_zone,
>> >                                        migratetype, &did_some_progress,
>> >                                        sync_migration);
>> >
>> > __GFP_NORETRY is used in a bunch of places and while the most
>> > of them are not high-order, some of them potentially are like in
>> > sound/core/memalloc.c. Using __GFP_NO_KSWAPD as the flag allows
>> > these callers to continue using sync compaction.  It could be argued
>>
>> Okay. If I was biased first, I have opposed this comment because they
>> might think __GFP_NORETRY is very latency sensitive.
>
> As __GFP_NORETRY uses direct reclaim, I do not think users expect it
> to be latency sensitive. If they were latency sensitive, they would
> mask out __GFP_WAIT.

Indeed.

>
>> So they wanted allocation is very fast without any writeback/retrial.
>> In view point, __GFP_NORETRY isn't bad, I think.
>>
>> Having said that, I was biased latter, as I said earlier.
>>
>> > that they would prefer __GFP_NORETRY but the potential side-effects
>> > should be taken should be taken into account and the comment updated
>>
>> Considering side-effect, your patch is okay.
>> But I can't understand you mentioned "the comment updated if that
>> happens" sentence. :(
>>
>
> I meant the comment above sync_migration = !(gfp_mask & __GFP_NO_KSWAPD) should
> be updated if it changes to __GFP_NORETRY.
>
> I updated the commentary a bit. Does this help?

I am happy with your updated comment but there is a concern.
We are adding additional flags to be considered for all page allocation callers.
If it isn't, there are too many flags in there.

I really hope this flag makes VM internal so let other do not care about it.
Until now, users was happy without such flag and it's only huge page problem.

-- 
Kind regards,
Minchan Kim
