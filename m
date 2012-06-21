Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab2FUCpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:45:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62741 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615Ab2FUCpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:45:38 -0400
MIME-Version: 1.0
In-Reply-To: <4FE27F15.8050102@kernel.org>
References: <4FE169B1.7020600@kernel.org> <4FE16E80.9000306@gmail.com>
 <4FE18187.3050103@kernel.org> <4FE23069.5030702@gmail.com>
 <4FE26470.90401@kernel.org> <CAHGf_=pjoiHQ9vxXXe-GtbkYRzhxdDhu3pf6pwDsCe5pBQE8Nw@mail.gmail.com>
 <4FE27F15.8050102@kernel.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 20 Jun 2012 22:45:17 -0400
Message-ID: <CAHGf_=pDw4axwG2tQ+B5hPks-sz2S5+G1Kk-=HSDmo=DSXOkEw@mail.gmail.com>
Subject: Re: Accounting problem of MIGRATE_ISOLATED freed page
To: Minchan Kim <minchan@kernel.org>
Cc: Aaditya Kumar <aaditya.kumar.30@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 9:55 PM, Minchan Kim <minchan@kernel.org> wrote:
> On 06/21/2012 10:39 AM, KOSAKI Motohiro wrote:
>
>>>> number of isolate page block is almost always 0. then if we have such counter,
>>>> we almost always can avoid zone->lock. Just idea.
>>>
>>> Yeb. I thought about it but unfortunately we can't have a counter for MIGRATE_ISOLATE.
>>> Because we have to tweak in page free path for pages which are going to free later after we
>>> mark pageblock type to MIGRATE_ISOLATE.
>>
>> I mean,
>>
>> if (nr_isolate_pageblock != 0)
>>    free_pages -= nr_isolated_free_pages(); // your counting logic
>>
>> return __zone_watermark_ok(z, alloc_order, mark,
>>                               classzone_idx, alloc_flags, free_pages);
>>
>>
>> I don't think this logic affect your race. zone_watermark_ok() is already
>> racy. then new little race is no big matter.
>
>
> It seems my explanation wasn't enough. :(
> I already understand your intention but we can't make nr_isolate_pageblock.
> Because we should count two type of free pages.

I mean, move_freepages_block increment number of page *block*, not pages.
number of free *pages* are counted by zone_watermark_ok_safe().


> 1. Already freed page so they are already in buddy list.
>   Of course, we can count it with return value of move_freepages_block(zone, page, MIGRATE_ISOLATE) easily.
>
> 2. Will be FREEed page by do_migrate_range.
>   It's a _PROBLEM_. For it, we should tweak free path. No?

No.


> If All of pages are PageLRU when hot-plug happens(ie, 2), nr_isolate_pagblock is zero and
> zone_watermk_ok_safe can't do his role.

number of isolate pageblock don't depend on number of free pages. It's
a concept of
an attribute of PFN range.
