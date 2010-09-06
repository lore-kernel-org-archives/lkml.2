Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab0IFNap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 09:30:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65381 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab0IFNao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 09:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rIDIr8CLjjdUIDK80pchW8E38op0KOIx6H2w0k2hAjfhQww76LPIr+GAWJvVyFpMz/
         xCGpntC5GhdHkMbKSUtjlTOi55dNSqPtUS4TRXwl2s06QsBNbPI8f4WdxC5wC+PSiYDY
         72eqYWGYYWRO96AhojDze+ekQA9T+oP+Mmbd4=
MIME-Version: 1.0
In-Reply-To: <20100906093042.GB23089@tiehlicka.suse.cz>
References: <20100906144019.946d3c49.kamezawa.hiroyu@jp.fujitsu.com>
	<20100906144716.dfd6d536.kamezawa.hiroyu@jp.fujitsu.com>
	<20100906093042.GB23089@tiehlicka.suse.cz>
Date: Mon, 6 Sep 2010 22:30:43 +0900
Message-ID: <AANLkTikOi6BqXs2wiLetFP9OgYtXD+vbC+Ez8a7z0dcU@mail.gmail.com>
Subject: Re: [PATCH 3/3] memory hotplug: use unified logic for is_removable
 and offline_pages
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        fengguang.wu@intel.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, andi.kleen@intel.com,
        Dave Hansen <dave@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/6 Michal Hocko <mhocko@suse.cz>:
> On Mon 06-09-10 14:47:16, KAMEZAWA Hiroyuki wrote:
>>
>> Now, sysfs interface of memory hotplug shows whether the section is
>> removable or not. But it checks only migrateype of pages and doesn't
>> check details of cluster of pages.
>>
>> Next, memory hotplug's set_migratetype_isolate() has the same kind
>> of check, too. But the migrate-type is just a "hint" and the pageblock
>> can contain several types of pages if fragmentation is very heavy.
>>
>> To get precise information, we need to check
>>  - the pageblock only contains free pages or LRU pages.
>>
>> This patch adds the function __count_unmovable_pages() and makes
>> above 2 checks to use the same logic. This will improve user experience
>> of memory hotplug because sysfs interface tells accurate information.
>>
>> Note:
>> it may be better to check MIGRATE_UNMOVABLE for making failure case quick.
>>
>> Changelog: 2010/09/06
>>  - added comments.
>>  - removed zone->lock.
>>  - changed the name of the function to be is_pageblock_removable_async().
>>    because I removed the zone->lock.
>
> wouldn't be __is_pageblock_removable a better name? _async suffix is
> usually used for asynchronous operations and this is just a function
> withtout locks.
>
rename as _is_pagebloc_removable_nolock().


>>
>> Reported-by: Michal Hocko <mhocko@suse.cz>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>>  include/linux/memory_hotplug.h |    1
>>  mm/memory_hotplug.c            |   15 -------
>>  mm/page_alloc.c                |   77 ++++++++++++++++++++++++++++++-----------
>>  3 files changed, 60 insertions(+), 33 deletions(-)
>>
>> Index: kametest/mm/page_alloc.c
>> ===================================================================
>> --- kametest.orig/mm/page_alloc.c
>> +++ kametest/mm/page_alloc.c
>> @@ -5274,11 +5274,61 @@ void set_pageblock_flags_group(struct pa
>>   * page allocater never alloc memory from ISOLATE block.
>>   */
>>
>
> Can we add a comment on the locking? Something like:
> Caller should hold zone->lock if he needs consistent results.
>
Hmm. ok.

>> +static int __count_immobile_pages(struct zone *zone, struct page *page)
>> +{
>> +     unsigned long pfn, iter, found;
>> +     /*
>> +      * For avoiding noise data, lru_add_drain_all() should be called
>> +      * If ZONE_MOVABLE, the zone never contains immobile pages
>> +      */
>> +     if (zone_idx(zone) == ZONE_MOVABLE)
>> +             return 0;
>> +
>> +     pfn = page_to_pfn(page);
>> +     for (found = 0, iter = 0; iter < pageblock_nr_pages; iter++) {
>> +             unsigned long check = pfn + iter;
>> +
>> +             if (!pfn_valid_within(check)) {
>> +                     iter++;
>> +                     continue;
>> +             }
>> +             page = pfn_to_page(check);
>> +             if (!page_count(page)) {
>> +                     if (PageBuddy(page))
>> +                             iter += (1 << page_order(page)) - 1;
>> +                     continue;
>> +             }
>> +             if (!PageLRU(page))
>> +                     found++;
>> +             /*
>> +              * If the page is not RAM, page_count()should be 0.
>> +              * we don't need more check. This is an _used_ not-movable page.
>> +              *
>> +              * The problematic thing here is PG_reserved pages. PG_reserved
>> +              * is set to both of a memory hole page and a _used_ kernel
>> +              * page at boot.
>> +              */
>> +     }
>> +     return found;
>> +}
>> +
>> +bool is_pageblock_removable_async(struct page *page)
>> +{
>> +     struct zone *zone = page_zone(page);
>> +     unsigned long flags;
>> +     int num;
>> +     /* Don't take zone->lock interntionally. */
>
> Could you add the reason?
> Don't take zone-> lock intentionally because we are called from the
> userspace (sysfs interface).
>
I don't like to assume caller context which will limit the callers.

/* holding zone->lock or not is caller's job. */


> [...]
>>       /* All pageblocks in the memory block are likely to be hot-removable */
>> Index: kametest/include/linux/memory_hotplug.h
>> ===================================================================
>> --- kametest.orig/include/linux/memory_hotplug.h
>> +++ kametest/include/linux/memory_hotplug.h
>> @@ -69,6 +69,7 @@ extern void online_page(struct page *pag
>>  /* VM interface that may be used by firmware interface */
>>  extern int online_pages(unsigned long, unsigned long);
>>  extern void __offline_isolated_pages(unsigned long, unsigned long);
>
> #ifdef CONFIG_HOTREMOVE
>
>> +extern bool is_pageblock_removable_async(struct page *page);
>
> #else
> #define is_pageblock_removable_async(p) 0
> #endif
> ?

Is this function is called even if HOTREMOVE is off ?
If so, the caller is buggy. I'll check tomorrow.

Thanks,
-Kame
