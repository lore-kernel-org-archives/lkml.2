Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab1JXTcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 15:32:53 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:58570 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab1JXTcu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 15:32:50 -0400
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
Subject: Re: [PATCH 4/9] mm: MIGRATE_CMA migration type added
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
 <1317909290-29832-5-git-send-email-m.szyprowski@samsung.com>
 <20111018130826.GD6660@csn.ul.ie>
Date: Mon, 24 Oct 2011 12:32:45 -0700
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v3ve8vbl3l0zgt@mpn-glaptop>
In-Reply-To: <20111018130826.GD6660@csn.ul.ie>
User-Agent: Opera Mail/11.52 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Oct 06, 2011 at 03:54:44PM +0200, Marek Szyprowski wrote:
>> The MIGRATE_CMA migration type has two main characteristics:
>> (i) only movable pages can be allocated from MIGRATE_CMA
>> pageblocks and (ii) page allocator will never change migration
>> type of MIGRATE_CMA pageblocks.
>>
>> This guarantees that page in a MIGRATE_CMA page block can
>> always be migrated somewhere else (unless there's no memory left
>> in the system).

On Tue, 18 Oct 2011 06:08:26 -0700, Mel Gorman <mel@csn.ul.ie> wrote:
> Or the count is premanently elevated by a device driver for some reason or if
> the page is backed by a filesystem with a broken or unusable migrate_page()
> function. This is unavoidable, I'm just pointing out that you can stil have
> migration failures, particularly if GFP_MOVABLE has been improperly used.

CMA does not handle that well right now.  I guess it's something to think about
once the rest is nice and working.

>> It is designed to be used with Contiguous Memory Allocator
>> (CMA) for allocating big chunks (eg. 10MiB) of physically
>> contiguous memory.  Once driver requests contiguous memory,
>> CMA will migrate pages from MIGRATE_CMA pageblocks.
>>
>> To minimise number of migrations, MIGRATE_CMA migration type
>> is the last type tried when page allocator falls back to other
>> migration types then requested.

> It would be preferable if you could figure out how to reuse the
> MIGRATE_RESERVE type for just the bitmap.

I'm not entirely sure of what you mean here.

> Like MIGRATE_CMA, it does not
> change type except when min_free_kbytes changes. However, it is
> something that could be done in the future to keep the size of the
> pageblock bitmap where it is now.


>> +enum {
>> +	MIGRATE_UNMOVABLE,
>> +	MIGRATE_RECLAIMABLE,
>> +	MIGRATE_MOVABLE,
>> +	MIGRATE_PCPTYPES,	/* the number of types on the pcp lists */
>> +	MIGRATE_RESERVE = MIGRATE_PCPTYPES,
>> +	/*
>> +	 * MIGRATE_CMA migration type is designed to mimic the way
>> +	 * ZONE_MOVABLE works.  Only movable pages can be allocated
>> +	 * from MIGRATE_CMA pageblocks and page allocator never
>> +	 * implicitly change migration type of MIGRATE_CMA pageblock.
>> +	 *
>> +	 * The way to use it is to change migratetype of a range of
>> +	 * pageblocks to MIGRATE_CMA which can be done by
>> +	 * __free_pageblock_cma() function.  What is important though
>> +	 * is that a range of pageblocks must be aligned to
>> +	 * MAX_ORDER_NR_PAGES should biggest page be bigger then
>> +	 * a single pageblock.
>> +	 */
>> +	MIGRATE_CMA,

> This does mean that MIGRATE_CMA also does not have a per-cpu list.
> I don't know if that matters to you but all allocations using
> MIGRATE_CMA will take the zone lock.

This is sort of an artefact of my misunderstanding of pcp lists in the
past.  I'll have to re-evaluate the decision not to include CMA on pcp
list.

Still, I think that CMA not being on pcp lists should not be a problem
for us.  At least we can try and get CMA running and then consider adding
CMA to pcp lists.

> I'm not sure this can be easily avoided because
> if there is a per-CPU list for MIGRATE_CMA, it might use a new cache
> line for it and incur a different set of performance problems.

>> +	MIGRATE_ISOLATE,	/* can't allocate from here */
>> +	MIGRATE_TYPES
>> +};

>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index 97254e4..9cf6b2b 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -115,6 +115,16 @@ static bool suitable_migration_target(struct page *page)
>>  	if (migratetype == MIGRATE_ISOLATE || migratetype == MIGRATE_RESERVE)
>>  		return false;
>>
>> +	/* Keep MIGRATE_CMA alone as well. */
>> +	/*
>> +	 * XXX Revisit.  We currently cannot let compaction touch CMA
>> +	 * pages since compaction insists on changing their migration
>> +	 * type to MIGRATE_MOVABLE (see split_free_page() called from
>> +	 * isolate_freepages_block() above).
>> +	 */
>> +	if (is_migrate_cma(migratetype))
>> +		return false;
>> +
>
> This is another reason why CMA and compaction should be using almost
> identical code. It does mean that the compact_control may need to be
> renamed and get flags to control things like the setting of pageblock
> flags but it would be preferable to having two almost identical pieces
> of code.

I've addressed it in my other mail where I've changed the split_free_page()
to not touch CMA and ISOLATE pageblocks.  I think that this change should
make the above comment no longer accurate and the check unnecessary.

>>  	/* If the page is a large free page, then allow migration */
>>  	if (PageBuddy(page) && page_order(page) >= pageblock_order)
>>  		return true;

>> @@ -940,12 +963,12 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
>>  	/* Find the largest possible block of pages in the other list */
>>  	for (current_order = MAX_ORDER-1; current_order >= order;
>>  						--current_order) {
>> -		for (i = 0; i < MIGRATE_TYPES - 1; i++) {
>> +		for (i = 0; i < ARRAY_SIZE(fallbacks[0]); i++) {
>
> I don't see why this change is necessary.

It changes a sort of a magic number into a value that is calculated
 from the array.  This makes it resistant to changes in the definition
of the fallbacks array.  I think this is a reasonable change.

>>  			migratetype = fallbacks[start_migratetype][i];
>>
>>  			/* MIGRATE_RESERVE handled later if necessary */
>>  			if (migratetype == MIGRATE_RESERVE)
>> -				continue;
>> +				break;
>>
>>  			area = &(zone->free_area[current_order]);
>>  			if (list_empty(&area->free_list[migratetype]))

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
