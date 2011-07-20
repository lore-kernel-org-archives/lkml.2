Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab1GTGaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 02:30:08 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59050 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab1GTGaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 02:30:07 -0400
MIME-Version: 1.0
In-Reply-To: <1311142253.15392.361.camel@sli10-conroe>
References: <1311130413.15392.326.camel@sli10-conroe>
	<CAEwNFnDj30Bipuxrfe9upD-OyuL4v21tLs0ayUKYUfye5TcGyA@mail.gmail.com>
	<1311142253.15392.361.camel@sli10-conroe>
Date: Wed, 20 Jul 2011 15:30:05 +0900
Message-ID: <CAEwNFnD3iCMBpZK95Ks+Z7DYbrzbZbSTLf3t6WXDQdeHrE6bLQ@mail.gmail.com>
Subject: Re: [PATCH]vmscan: add block plug for page reclaim
From: Minchan Kim <minchan.kim@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "mgorman@suse.de" <mgorman@suse.de>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 3:10 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> On Wed, 2011-07-20 at 13:53 +0800, Minchan Kim wrote:
>> On Wed, Jul 20, 2011 at 11:53 AM, Shaohua Li <shaohua.li@intel.com> wrote:
>> > per-task block plug can reduce block queue lock contention and increase request
>> > merge. Currently page reclaim doesn't support it. I originally thought page
>> > reclaim doesn't need it, because kswapd thread count is limited and file cache
>> > write is done at flusher mostly.
>> > When I test a workload with heavy swap in a 4-node machine, each CPU is doing
>> > direct page reclaim and swap. This causes block queue lock contention. In my
>> > test, without below patch, the CPU utilization is about 2% ~ 7%. With the
>> > patch, the CPU utilization is about 1% ~ 3%. Disk throughput isn't changed.
>>
>> Why doesn't it enhance through?
> throughput? The disk isn't that fast. We already can make it run in full

Yes. Sorry for the typo.

> speed, CPU isn't bottleneck here.

But you try to optimize CPU. so your experiment is not good.

>
>> It means merge is rare?
> Merge is still there even without my patch, but maybe not be able to
> make the request size biggest in cocurrent I/O.
>
>> > This should improve normal kswapd write and file cache write too (increase
>> > request merge for example), but might not be so obvious as I explain above.
>>
>> CPU utilization enhance on  4-node machine with heavy swap?
>> I think it isn't common situation.
>>
>> And I don't want to add new stack usage if it doesn't have a benefit.
>> As you know, direct reclaim path has a stack overflow.
>> These days, Mel, Dave and Christoph try to remove write path in
>> reclaim for solving stack usage and enhance write performance.
> it will use a little stack, yes. When I said the benefit isn't so
> obvious, it doesn't mean it has no benefit. For example, if kswapd and
> other threads write the same disk, this can still reduce lock contention
> and increase request merge. Part reason I didn't see obvious affect for
> file cache is my disk is slow.

If it begin swapping, I think the the performance would be less important,
But your patch is so simple that it would be mergable(Maybe Andrew
would merge regardless of my comment) but impact is a little in your
experiment.

I suggest you test it with fast disk like SSD and show the benefit to
us certainly. (I think you intel guy have a good SSD, apparently :D )

-- 
Kind regards,
Minchan Kim
