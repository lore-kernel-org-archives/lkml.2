Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab0KWPqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:46:08 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25956 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab0KWPqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:46:06 -0500
Date: Tue, 23 Nov 2010 16:46:03 +0100
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 0/4] big chunk memory allocator v4
In-reply-to: <20101122090431.4ff9c941.kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        minchan.kim@gmail.com, Bob Liu <lliubbo@gmail.com>,
        fujita.tomonori@lab.ntt.co.jp, pawel@osciak.com, andi.kleen@intel.com,
        felipe.contreras@gmail.com,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <op.vmmre1vv7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.63 (Linux)
References: <20101119171033.a8d9dc8f.kamezawa.hiroyu@jp.fujitsu.com>
 <20101119125653.16dd5452.akpm@linux-foundation.org>
 <20101122090431.4ff9c941.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010 01:04:31 +0100, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri, 19 Nov 2010 12:56:53 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Fri, 19 Nov 2010 17:10:33 +0900
>> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>
>> > Hi, this is an updated version.
>> >
>> > No major changes from the last one except for page allocation function.
>> > removed RFC.
>> >
>> > Order of patches is
>> >
>> > [1/4] move some functions from memory_hotplug.c to page_isolation.c
>> > [2/4] search physically contiguous range suitable for big chunk alloc.
>> > [3/4] allocate big chunk memory based on memory hotplug(migration) technique
>> > [4/4] modify page allocation function.
>> >
>> > For what:
>> >
>> >   I hear there is requirements to allocate a chunk of page which is larger than
>> >   MAX_ORDER. Now, some (embeded) device use a big memory chunk. To use memory,
>> >   they hide some memory range by boot option (mem=) and use hidden memory
>> >   for its own purpose. But this seems a lack of feature in memory management.
>> >
>> >   This patch adds
>> > 	alloc_contig_pages(start, end, nr_pages, gfp_mask)
>> >   to allocate a chunk of page whose length is nr_pages from [start, end)
>> >   phys address. This uses similar logic of memory-unplug, which tries to
>> >   offline [start, end) pages. By this, drivers can allocate 30M or 128M or
>> >   much bigger memory chunk on demand. (I allocated 1G chunk in my test).
>> >
>> >   But yes, because of fragmentation, this cannot guarantee 100% alloc.
>> >   If alloc_contig_pages() is called in system boot up or movable_zone is used,
>> >   this allocation succeeds at high rate.
>>
>> So this is an alternatve implementation for the functionality offered
>> by Michal's "The Contiguous Memory Allocator framework".
>>
>
> Yes, this will be a backends for that kind of works.

As a matter of fact CMA's v6 tries to use code "borrowed" from the alloc_contig_pages()
patches.

The most important difference is that alloc_contig_pages() would look for a chunk
of memory that can be allocated and then perform migration whereas CMA assumes that
regions it controls are always "migratable".

Also, I've tried to remove the requirement for MAX_ORDER alignment.

> I think there are two ways to allocate contiguous pages larger than MAX_ORDER.
>
> 1) hide some memory at boot and add an another memory allocator.
> 2) support a range allocator as [start, end)
>
> This is an trial from 2). I used memory-hotplug technique because I know some.
> This patch itself has no "map" and "management" function, so it should be
> developped in another patch (but maybe it will be not my work.)

Yes, this is also a valid point.  From my use cases, the alloc_contig_pages()
would probably not be enough and require some management code to be added.

>> >   I tested this on x86-64, and it seems to work as expected. But feedback from
>> >   embeded guys are appreciated because I think they are main user of this
>> >   function.
>>
>> From where I sit, feedback from the embedded guys is *vital*, because
>> they are indeed the main users.
>>
>> Michal, I haven't made a note of all the people who are interested in
>> and who are potential users of this code.  Your patch series has a
>> billion cc's and is up to version 6.

Ah, yes...  I was thinking about shrinking the cc list but didn't want to
seem rude or anything removing ppl who have shown interest in the previous
posted version.

>> Could I ask that you review and
>> test this code, and also hunt down other people (probably at other
>> organisations) who can do likewise for us?  Because until we hear from
>> those people that this work satisfies their needs, we can't really
>> proceed much further.

A few things than:

1. As Felipe mentioned, on ARM it is often desired to have the memory
    mapped as non-cacheable, which most often mean that the memory never
    reaches the page allocator.  This means, that alloc_contig_pages()
    would not be suitable for cases where one needs such memory.

    Or could this be overcome by adding the memory back as highmem?  But
    then, it would force to compile in highmem support even if platform
    does not really need it.

2. Device drivers should not by themselves know what ranges of memory to
    allocate memory from.  Moreover, some device drivers could require
    allocation different buffers from different ranges.  As such, this
    would require some management code on top of alloc_contig_pages().

3. When posting hwmem, Johan Mossberg mentioned that he'd like to see
    notion of "pinning" chunks (so that not-pinned chunks can be moved
    around when hardware does not use them to defragment memory).  This
    would again require some management code on top of
    alloc_contig_pages().

4. I might be mistaken here, but the way I understand ZONE_MOVABLE work
    is that it is cut of from the end of memory.  Or am I talking nonsense?
    My concern is that at least one chip I'm working with requires
    allocations from different memory banks which would basically mean that
    there would have to be two movable zones, ie:

    +-------------------+-------------------+
    | Memory Bank #1    | Memory Bank #2    |
    +---------+---------+---------+---------+
    | normal  | movable | normal  | movable |
    +---------+---------+---------+---------+

So even though I'm personally somehow drawn by alloc_contig_pages()'s
simplicity (compared to CMA at least), those quick thoughts make me think
that alloc_contig_pages() would work rather as a backend (as Kamezawa
mentioned) for some, maybe even tiny but still present, management code
which would handle "marking memory fragments as ZONE_MOVABLE" (whatever
that would involve) and deciding which memory ranges drivers can allocate
from.

I'm also wondering whether alloc_contig_pages()'s first-fit is suitable but
that probably cannot be judged without some benchmarks.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
