Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab2FYBAz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 21:00:55 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53535 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab2FYBAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 21:00:54 -0400
X-AuditID: 9c930179-b7befae000006417-9d-4fe7b843f272
Message-ID: <4FE7B861.6020906@kernel.org>
Date: Mon, 25 Jun 2012 10:01:21 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: undisclosed-recipients:";
	KOSAKI Motohiro" <kosaki.motohiro@gmail.com>,
        Aaditya Kumar <aaditya.kumar.30@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	undisclosed-recipients:;KOSAKI Motohiro <kosaki.motohiro@gmail.com>
						^-missing end of address
Subject: Re: Accounting problem of MIGRATE_ISOLATED freed page
References: <4FE169B1.7020600@kernel.org> <4FE16E80.9000306@gmail.com> <4FE18187.3050103@kernel.org> <4FE23069.5030702@gmail.com> <4FE26470.90401@kernel.org> <CAHGf_=pjoiHQ9vxXXe-GtbkYRzhxdDhu3pf6pwDsCe5pBQE8Nw@mail.gmail.com> <4FE27F15.8050102@kernel.org> <CAHGf_=pDw4axwG2tQ+B5hPks-sz2S5+G1Kk-=HSDmo=DSXOkEw@mail.gmail.com> <4FE2A937.6040701@kernel.org> <4FE2FCFB.4040808@jp.fujitsu.com> <4FE3C4E4.2050107@kernel.org> <4FE414A2.3000700@kernel.org> <4FE5482C.3010501@jp.fujitsu.com>
In-Reply-To: <4FE5482C.3010501@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2012 01:38 PM, Kamezawa Hiroyuki wrote:

> (2012/06/22 15:45), Minchan Kim wrote:
>> On 06/22/2012 10:05 AM, Minchan Kim wrote:
>>
>>> Second approach which is suggested by KOSAKI is what you mentioned.
>>> But the concern about second approach is how to make sure matched
>>> count increase/decrease of nr_isolated_areas.
>>> I mean how to make sure nr_isolated_areas would be zero when
>>> isolation is done.
>>> Of course, we can investigate all of current caller and make sure
>>> they don't make mistake
>>> now. But it's very error-prone if we consider future's user.
>>> So we might need test_set_pageblock_migratetype(page, MIGRATE_ISOLATE);
>>
>>
>> It's an implementation about above approach.
>>
> 
> I like this approach.

> 

> 
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index bf3404e..3e9a9e1 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -474,6 +474,11 @@ struct zone {
>>           * rarely used fields:
>>           */
>>          const char              *name;
>> +       /*
>> +        * the number of MIGRATE_ISOLATE pageblock
>> +        * We need this for accurate free page counting.
>> +        */
>> +       atomic_t                nr_migrate_isolate;
>>   } ____cacheline_internodealigned_in_smp;
> 
> Isn't this counter modified only under zone->lock ?


AFAIUC, you want to add comment about it. It's no problem. :)

Off-topic:
As I look the code, I found this. Could you confirm this problem?


	CPU A					CPU B

start_isolate_page_range
set_migratetype_isolate
spin_lock_irqsave(zone->lock)
					free_hot_cold_page(Page A)
					migratetype = get_pageblock_migratetype(Page A); /* without zone->lock holding */
					list_add_tail(&page->lru, &pcp->lists[migratetype]); /* Page A could return page into !MIGRATE_ISOLATE */
set_pageblock_migrate
move_freepages_block
drain_all_pages
					/* Page A could be in MIGRATE_MOVABLE of buddy. */
check_pages_isolated
__test_page_isolated_in_pageblock
if (PageBuddy(page A))
	pfn += 1 << page_order(page A);
					/* Page A could be allocated */

__offline_isolated_pages
	BUG_ON(!PageBuddy(page A)); <- HIT! or offline the page is used by someone.

> 
> 
>>
>>   typedef enum {
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 2c29b1c..6cb1f9f 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -219,6 +219,11 @@ EXPORT_SYMBOL(nr_online_nodes);
>>
>>   int page_group_by_mobility_disabled __read_mostly;
>>
>> +/*
>> + * NOTE:
>> + * Don't use set_pageblock_migratetype(page, MIGRATE_ISOLATE) direclty.
>> + * Instead, use {un}set_pageblock_isolate.
>> + */
>>   void set_pageblock_migratetype(struct page *page, int migratetype)
>>   {
>>          if (unlikely(page_group_by_mobility_disabled))
>> @@ -1622,6 +1627,28 @@ bool zone_watermark_ok(struct zone *z, int
>> order, unsigned long mark,
>>                                          zone_page_state(z,
>> NR_FREE_PAGES));
>>   }
> 
> I'm glad if this function can be static...Hm. With easy grep, I think it
> can be...


Yes. :)

-- 
Kind regards,
Minchan Kim
