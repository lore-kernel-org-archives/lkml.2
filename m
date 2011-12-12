Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1LLPWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:22:49 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51126 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1LLPWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:22:45 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Mel Gorman" <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Ankita Garg" <ankita@in.ibm.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Shariq Hasnain" <shariq.hasnain@linaro.org>,
        "Chunsang Jeong" <chunsang.jeong@linaro.org>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 02/11] mm: compaction: introduce
 isolate_{free,migrate}pages_range().
References: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com>
 <1321634598-16859-3-git-send-email-m.szyprowski@samsung.com>
 <20111212140728.GC3277@csn.ul.ie>
Date: Mon, 12 Dec 2011 16:22:39 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v6dub1ms3l0zgt@mpn-glaptop>
In-Reply-To: <20111212140728.GC3277@csn.ul.ie>
User-Agent: Opera Mail/11.60 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Nov 18, 2011 at 05:43:09PM +0100, Marek Szyprowski wrote:
>> From: Michal Nazarewicz <mina86@mina86.com>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index 899d956..6afae0e 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -54,51 +54,64 @@ static unsigned long release_freepages(struct list_head *freelist)
>>  	return count;
>>  }
>>
>> -/* Isolate free pages onto a private freelist. Must hold zone->lock */
>> -static unsigned long isolate_freepages_block(struct zone *zone,
>> -				unsigned long blockpfn,
>> -				struct list_head *freelist)
>> +/**
>> + * isolate_freepages_range() - isolate free pages, must hold zone->lock.
>> + * @zone:	Zone pages are in.
>> + * @start:	The first PFN to start isolating.
>> + * @end:	The one-past-last PFN.
>> + * @freelist:	A list to save isolated pages to.
>> + *
>> + * If @freelist is not provided, holes in range (either non-free pages
>> + * or invalid PFNs) are considered an error and function undos its
>> + * actions and returns zero.
>> + *
>> + * If @freelist is provided, function will simply skip non-free and
>> + * missing pages and put only the ones isolated on the list.
>> + *
>> + * Returns number of isolated pages.  This may be more then end-start
>> + * if end fell in a middle of a free page.
>> + */
>> +static unsigned long
>> +isolate_freepages_range(struct zone *zone,
>> +			unsigned long start, unsigned long end,
>> +			struct list_head *freelist)

On Mon, 12 Dec 2011 15:07:28 +0100, Mel Gorman <mel@csn.ul.ie> wrote:
> Use start_pfn and end_pfn to keep it consistent with the rest of
> compaction.c.

Will do.

>>  {
>> -	unsigned long zone_end_pfn, end_pfn;
>> -	int nr_scanned = 0, total_isolated = 0;
>> -	struct page *cursor;
>> -
>> -	/* Get the last PFN we should scan for free pages at */
>> -	zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
>> -	end_pfn = min(blockpfn + pageblock_nr_pages, zone_end_pfn);
>> +	unsigned long nr_scanned = 0, total_isolated = 0;
>> +	unsigned long pfn = start;
>> +	struct page *page;
>>
>> -	/* Find the first usable PFN in the block to initialse page cursor */
>> -	for (; blockpfn < end_pfn; blockpfn++) {
>> -		if (pfn_valid_within(blockpfn))
>> -			break;
>> -	}
>> -	cursor = pfn_to_page(blockpfn);
>> +	VM_BUG_ON(!pfn_valid(pfn));
>> +	page = pfn_to_page(pfn);
>>
>>  	/* Isolate free pages. This assumes the block is valid */
>> -	for (; blockpfn < end_pfn; blockpfn++, cursor++) {
>> -		int isolated, i;
>> -		struct page *page = cursor;
>> -
>> -		if (!pfn_valid_within(blockpfn))
>> -			continue;
>> -		nr_scanned++;
>> -
>> -		if (!PageBuddy(page))
>> -			continue;
>> +	while (pfn < end) {
>> +		unsigned isolated = 1, i;
>> +

> Do not use implcit types. These are unsigned ints, call them unsigned
> ints.

Will do.

>
>> +		if (!pfn_valid_within(pfn))
>> +			goto skip;
>
> The flow of this function in general with gotos of skipped and next
> is confusing in comparison to the existing function. For example,
> if this PFN is not valid, and no freelist is provided, then we call
> __free_page() on a PFN that is known to be invalid.
>
>> +		++nr_scanned;
>> +
>> +		if (!PageBuddy(page)) {
>> +skip:
>> +			if (freelist)
>> +				goto next;
>> +			for (; start < pfn; ++start)
>> +				__free_page(pfn_to_page(pfn));
>> +			return 0;
>> +		}
>
> So if a PFN is valid and !PageBuddy and no freelist is provided, we
> call __free_page() on it regardless of reference count. That does not
> sound safe.

Sorry about that.  It's a bug in the code which was caught later on.  The
code should read “__free_page(pfn_to_page(start))”.

>>
>>  		/* Found a free page, break it into order-0 pages */
>>  		isolated = split_free_page(page);
>>  		total_isolated += isolated;
>> -		for (i = 0; i < isolated; i++) {
>> -			list_add(&page->lru, freelist);
>> -			page++;
>> +		if (freelist) {
>> +			struct page *p = page;
>> +			for (i = isolated; i; --i, ++p)
>> +				list_add(&p->lru, freelist);
>>  		}
>>
>> -		/* If a page was split, advance to the end of it */
>> -		if (isolated) {
>> -			blockpfn += isolated - 1;
>> -			cursor += isolated - 1;
>> -		}
>> +next:
>> +		pfn += isolated;
>> +		page += isolated;
>
> The name isolated is now confusing because it can mean either
> pages isolated or pages scanned depending on context. Your patch
> appears to be doing a lot more than is necessary to convert
> isolate_freepages_block into isolate_freepages_range and at this point,
> it's unclear why you did that.

When CMA uses this function, it requires all pages in the range to be valid
and free.  (Both conditions should be met but you never know.)  This change
adds a second way isolate_freepages_range() works, which is when freelist is
not specified, abort on invalid or non-free page, but continue as usual if
freelist is provided.

I can try and restructure this function a bit so that there are fewer “gotos”,
but without the above change, CMA won't really be able to use it effectively
(it would have to provide a freelist and then validate if pages on it are
added in order).

>>  	}
>>
>>  	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated);

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
