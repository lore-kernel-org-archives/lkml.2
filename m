Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382Ab2FGEW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:22:56 -0400
Received: from plane.gmane.org ([80.91.229.3]:45840 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933337Ab2FGEWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:22:49 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v9] mm: compaction: handle incorrect MIGRATE_UNMOVABLE
 type pageblocks
Date: Thu, 07 Jun 2012 13:23:06 +0900
Message-ID: <4FD02CAA.5090105@kernel.org>
References: <201206041543.56917.b.zolnierkie@samsung.com> <op.wfdt8dh53l0zgt@mpn-glaptop> <201206061455.28980.b.zolnierkie@samsung.com> <op.wfhnpri93l0zgt@mpn-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 121.50.20.41
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
In-Reply-To: <op.wfhnpri93l0zgt@mpn-glaptop>
Cc: linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 12:52 AM, Michal Nazarewicz wrote:

> On Wed, 06 Jun 2012 14:55:28 +0200, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> 
>> On Monday 04 June 2012 16:22:51 Michal Nazarewicz wrote:
>>> On Mon, 04 Jun 2012 15:43:56 +0200, Bartlomiej Zolnierkiewicz
>>> <b.zolnierkie@samsung.com> wrote:
>>> > +/*
>>> > + * Returns true if MIGRATE_UNMOVABLE pageblock can be successfully
>>> > + * converted to MIGRATE_MOVABLE type, false otherwise.
>>> > + */
>>> > +static bool can_rescue_unmovable_pageblock(struct page *page, bool
>>> locked)
>>> > +{
>>> > +    unsigned long pfn, start_pfn, end_pfn;
>>> > +    struct page *start_page, *end_page, *cursor_page;
>>> > +
>>> > +    pfn = page_to_pfn(page);
>>> > +    start_pfn = pfn & ~(pageblock_nr_pages - 1);
>>> > +    end_pfn = start_pfn + pageblock_nr_pages - 1;
>>> > +
>>> > +    start_page = pfn_to_page(start_pfn);
>>> > +    end_page = pfn_to_page(end_pfn);
>>> > +
>>> > +    for (cursor_page = start_page, pfn = start_pfn; cursor_page <=
>>> end_page;
>>> > +        pfn++, cursor_page++) {
>>> > +        struct zone *zone = page_zone(start_page);
>>> > +        unsigned long flags;
>>> > +
>>> > +        if (!pfn_valid_within(pfn))
>>> > +            continue;
>>> > +
>>> > +        /* Do not deal with pageblocks that overlap zones */
>>> > +        if (page_zone(cursor_page) != zone)
>>> > +            return false;
>>> > +
>>> > +        if (!locked)
>>> > +            spin_lock_irqsave(&zone->lock, flags);
>>> > +
>>> > +        if (PageBuddy(cursor_page)) {
>>> > +            int order = page_order(cursor_page);
>>> >-/* Returns true if the page is within a block suitable for
>>> migration to */
>>> > -static bool suitable_migration_target(struct page *page)
>>> > +            pfn += (1 << order) - 1;
>>> > +            cursor_page += (1 << order) - 1;
>>> > +
>>> > +            if (!locked)
>>> > +                spin_unlock_irqrestore(&zone->lock, flags);
>>> > +            continue;
>>> > +        } else if (page_count(cursor_page) == 0 ||
>>> > +               PageLRU(cursor_page)) {
>>> > +            if (!locked)
>>> > +                spin_unlock_irqrestore(&zone->lock, flags);
>>> > +            continue;
>>> > +        }
>>> > +
>>> > +        if (!locked)
>>> > +            spin_unlock_irqrestore(&zone->lock, flags);
>>>
>>> spin_unlock in three spaces is ugly.  How about adding a flag that
>>> holds the
>>> result of the function which you use as for loop condition and you
>>> set it to
>>> false inside an additional else clause?  Eg.:
>>>
>>>     bool result = true;
>>>     for (...; result && cursor_page <= end_page; ...) {
>>>         ...
>>>         if (!pfn_valid_within(pfn)) continue;
>>>         if (page_zone(cursor_page) != zone) return false;
>>>         if (!locked) spin_lock_irqsave(...);
>>>        
>>>         if (PageBuddy(...)) {
>>>             ...
>>>         } else if (page_count(cursor_page) == 0 ||
>>>                PageLRU(cursor_page)) {
>>>             ...
>>>         } else {
>>>             result = false;
>>>         }
>>>         if (!locked) spin_unlock_irqsave(...);
>>>     }
>>>     return result;
>>
>> Thanks, I'll use the hint (if still applicable) in the next patch
>> version.
>>
>>> > +        return false;
>>> > +    }
>>> > +
>>> > +    return true;
>>> > +}
>>>
>>> How do you make sure that a page is not allocated while this runs? 
>>> Or you just
>>> don't care?  Not that even with zone lock, page may be allocated from
>>> pcp list
>>> on (another) CPU.
>>
>> Ok, I see the issue (i.e. pcp page can be returned by rmqueue_bulk() in
>> buffered_rmqueue() and its page count will be increased in
>> prep_new_page()
>> a bit later with zone lock dropped so while we may not see the page as
>> "bad" one in can_rescue_unmovable_pageblock() it may end up as unmovable
>> one in a pageblock that was just changed to MIGRATE_MOVABLE type).
> 
> Allocating unmovable pages from movable pageblock is allowed though.  But,
> consider those two scenarios:
> 
> thread A                               thread B
>                                        allocate page from pcp list
> call can_rescue_unmovable_pageblock()
>  iterate over all pages
>   find that one of them is allocated
>    so return false
> 
> Second one:
> 
> thread A                               thread B
> call can_rescue_unmovable_pageblock()
>  iterate over all pages
>   find that all of them are free
>                                        allocate page from pcp list
>    return true
> 
> Note that the second scenario can happen even if zone lock is
> held.  So, why in both the function returns different result?
> 
>> It is basically similar problem to page allocation vs
>> alloc_contig_range()
>> races present in CMA so we may deal with it in a similar manner as
>> CMA: isolate pageblock so no new allocations will be allowed from it,
>> check if we can do pageblock transition to MIGRATE_MOVABLE type and do
>> it if so, drain pcp lists, check if the transition was successful and
>> if there are some pages that slipped through just revert the operation..
> 
> To me this sounds like too much work.
> 
> I'm also not sure if you are not overthinking it, which is why I asked
> at the beginning “or you just don't care?”  I'm not entirely sure that
> you need to make sure that all pages in the pageblock are in fact free.


Free page isn't only problem but also PageLRU check.
We can't make sure it without lru_lock or isolation of the page.

> If some of them slip through, nothing catastrophic happens, does it?
> 


Right. It can regress anti-fragmentation but I believe it would be not severe.
The more problem than it is to use page_count without a pin of page which ends up
racing with THP free by another CPU so that kernel would crash by dangling pointer of compound_head.


>> [*] BTW please see http://marc.info/?l=linux-mm&m=133775797022645&w=2
>> for CMA related fixes
> 
> Could you mail it to me again, that would be great, thanks.
> 
> 



-- 
Kind regards,
Minchan Kim

