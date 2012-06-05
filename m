Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2FEOkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 10:40:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51533 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2FEOkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 10:40:21 -0400
Message-ID: <4FCE1A51.3040407@gmail.com>
Date: Tue, 05 Jun 2012 10:40:17 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH v9] mm: compaction: handle incorrect MIGRATE_UNMOVABLE
 type pageblocks
References: <201206041543.56917.b.zolnierkie@samsung.com> <4FCD18FD.5030307@gmail.com> <4FCD6806.7070609@kernel.org> <4FCD713D.3020100@kernel.org> <4FCD8C99.3010401@gmail.com> <4FCDA1B4.9050301@kernel.org>
In-Reply-To: <4FCDA1B4.9050301@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/5/12 2:05 AM), Minchan Kim wrote:
> On 06/05/2012 01:35 PM, KOSAKI Motohiro wrote:
>
>>>>> Minchan, are you interest this patch? If yes, can you please rewrite
>>>>> it?
>>>>
>>>> Can do it but I want to give credit to Bartlomiej.
>>>> Bartlomiej, if you like my patch, could you resend it as formal patch
>>>> after you do broad testing?
>>>>
>>>> Frankly speaking, I don't want to merge it without any data which
>>>> prove it's really good for real practice.
>>>>
>>>> When the patch firstly was submitted, it wasn't complicated so I was
>>>> okay at that time but it has been complicated
>>>> than my expectation. So if Andrew might pass the decision to me, I'm
>>>> totally NACK if author doesn't provide
>>>> any real data or VOC of some client.
>>
>> I agree. And you don't need to bother this patch if you are not interest
>> this one. I'm sorry.
>
>
> Never mind.
>
>> Let's throw it away until the author send us data.
>>
>
> I guess it's hard to make such workload to prove it's useful normally.
> But we can't make sure there isn't such workload in the world.
> So I hope listen VOC. At least, Mel might require it.
>
> If anyone doesn't support it, I hope let's add some vmstat like stuff for proving
> this patch's effect. If we can't see the benefit through vmstat, we can deprecate
> it later.

Eek, bug we can not deprecate the vmstat. I hope to make good decision _before_
inclusion. ;-)


>>> +static bool can_rescue_unmovable_pageblock(struct page *page, bool
>>> need_lrulock)
>>> +{
>>> +    struct zone *zone;
>>> +    unsigned long pfn, start_pfn, end_pfn;
>>> +    struct page *start_page, *end_page, *cursor_page;
>>> +    bool lru_locked = false;
>>> +
>>> +    zone = page_zone(page);
>>> +    pfn = page_to_pfn(page);
>>> +    start_pfn = pfn&  ~(pageblock_nr_pages - 1);
>>> +    end_pfn = start_pfn + pageblock_nr_pages - 1;
>>> +
>>> +    start_page = pfn_to_page(start_pfn);
>>> +    end_page = pfn_to_page(end_pfn);
>>> +
>>> +    for (cursor_page = start_page, pfn = start_pfn; cursor_page<=
>>> end_page;
>>> +        pfn++, cursor_page++) {
>>>
>>> -/* Returns true if the page is within a block suitable for migration
>>> to */
>>> -static bool suitable_migration_target(struct page *page)
>>> +        if (!pfn_valid_within(pfn))
>>> +            continue;
>>> +
>>> +        /* Do not deal with pageblocks that overlap zones */
>>> +        if (page_zone(cursor_page) != zone)
>>> +            goto out;
>>> +
>>> +        if (PageBuddy(cursor_page)) {
>>> +            unsigned long order = page_order(cursor_page);
>>> +
>>> +            pfn += (1<<  order) - 1;
>>> +            cursor_page += (1<<  order) - 1;
>>> +            continue;
>>> +        } else if (page_count(cursor_page) == 0) {
>>> +            continue;
>>
>> Can we assume freed tail page always have page_count()==0? if yes, why
>> do we
>> need dangerous PageBuddy(cursor_page) check? ok, but this may be harmless.
>
> page_count check is for pcp pages.

Right. but my point was, I doubt we can do buddy walk w/o zone->lock.


> Am I missing your point?
>
>
>> But if no, this code is seriously dangerous. think following scenario,
>>
>> 1) cursor page points free page
>>
>>      +----------------+------------------+
>>      | free (order-1) |  used (order-1)  |
>>      +----------------+------------------+
>>      |
>>     cursor
>>
>> 2) moved cursor
>>
>>      +----------------+------------------+
>>      | free (order-1) |  used (order-1)  |
>>      +----------------+------------------+
>>                       |
>>                       cursor
>>
>> 3) neighbor block was freed
>>
>>
>>      +----------------+------------------+
>>      | free (order-2)                    |
>>      +----------------+------------------+
>>                       |
>>                       cursor
>>
>> now, cursor points to middle of free block.
>
>> Anyway, I recommend to avoid dangerous no zone->lock game and change
>> can_rescue_unmovable_pageblock() is only called w/ zone->lock. I have
>
>
>
> I can't understand your point.
> If the page is middle of free block, what's the problem in can_rescue_unmovable_pageblock
> at first trial of can_rescue_xxx?

I'm not sure. but other all pfn scanning code carefully avoid to touch a middle of free pages
block. (also they take zone->lock anytime)


> I think we can stabilize it in second trial of can_rescue_unmovable_pageblock with zone->lock.
>
>> no seen any worth to include this high complex for mere minor optimization.
>
>>
>
>>
>>> +        } else if (PageLRU(cursor_page)) {
>>> +            if (!need_lrulock)
>>> +                continue;
>>> +            else if (lru_locked)
>>> +                continue;
>>> +            else {
>>> +                spin_lock(&zone->lru_lock);
>>
>> Hmm...
>> I don't like to take lru_lock. 1) Until now, we carefully avoid to take
>> both zone->lock and zone->lru_lock. they are both performance critical
>> lock. And I think pageblock migratetype don't need strictly correct. It
>> is only optimization of anti fragmentation. Why do we need take it?
>
> movable_block has unmovable page can make regression of anti-fragmentation.
> So I did it. I agree it's a sort of optimization.
> If others don't want it at the cost of regression anti-fragmentation, we can remove the lock.

ok.


>
>>
>>
>>> +                lru_locked = true;
>>> +                if (PageLRU(page))
>>> +                    continue;
>>> +            }
>>> +        }
>>> +
>>> +        goto out;
>>> +    }
>>> +
>>
>> Why don't we need to release lru_lock when returning true.
>
>
> Because my brain has gone. :(

Never mind.


