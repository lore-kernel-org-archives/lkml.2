Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750981Ab1H0GoL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 02:44:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54122 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab1H0GoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 02:44:10 -0400
Message-ID: <4E589232.9050601@openvz.org>
Date: Sat, 27 Aug 2011 10:44:02 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110702 Iceape/2.0.14
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: add free_hot_cold_page_list helper
References: <20110729075837.12274.58405.stgit@localhost6> <20110826152101.b1b453c0.akpm@linux-foundation.org>
In-Reply-To: <20110826152101.b1b453c0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 29 Jul 2011 11:58:37 +0400
> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>
>> This patch adds helper free_hot_cold_page_list() to free list of 0-order pages.
>> It frees pages directly from list without temporary page-vector.
>> It also calls trace_mm_pagevec_free() to simulate pagevec_free() behaviour.
>>
>> bloat-o-meter:
>>
>> add/remove: 1/1 grow/shrink: 1/3 up/down: 267/-295 (-28)
>> function                                     old     new   delta
>> free_hot_cold_page_list                        -     264    +264
>> get_page_from_freelist                      2129    2132      +3
>> __pagevec_free                               243     239      -4
>> split_free_page                              380     373      -7
>> release_pages                                606     510     -96
>> free_page_list                               188       -    -188
>>
>
> It saves a total of 150 bytes for me.
>
>> index cb40892..dd7b9cc 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -358,6 +358,7 @@ void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
>>   extern void __free_pages(struct page *page, unsigned int order);
>>   extern void free_pages(unsigned long addr, unsigned int order);
>>   extern void free_hot_cold_page(struct page *page, int cold);
>> +extern void free_hot_cold_page_list(struct list_head *list, int cold);
>>
>>   #define __free_page(page) __free_pages((page), 0)
>>   #define free_page(addr) free_pages((addr), 0)
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 1dbcf88..af486e4 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1209,6 +1209,18 @@ out:
>>   	local_irq_restore(flags);
>>   }
>>
>> +void free_hot_cold_page_list(struct list_head *list, int cold)
>> +{
>> +	struct page *page, *next;
>> +
>> +	list_for_each_entry_safe(page, next, list, lru) {
>> +		trace_mm_pagevec_free(page, cold);
>> +		free_hot_cold_page(page, cold);
>> +	}
>> +
>> +	INIT_LIST_HEAD(list);
>> +}
>> +
>>   /*
>>    * split_page takes a non-compound higher-order page, and splits it into
>>    * n (1<<order) sub-pages: page[0..n]
>> diff --git a/mm/swap.c b/mm/swap.c
>> index 3a442f1..b9138c7 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -562,11 +562,10 @@ int lru_add_drain_all(void)
>>   void release_pages(struct page **pages, int nr, int cold)
>>   {
>>   	int i;
>> -	struct pagevec pages_to_free;
>> +	LIST_HEAD(pages_to_free);
>>   	struct zone *zone = NULL;
>>   	unsigned long uninitialized_var(flags);
>>
>> -	pagevec_init(&pages_to_free, cold);
>>   	for (i = 0; i<  nr; i++) {
>>   		struct page *page = pages[i];
>>
>> @@ -597,19 +596,12 @@ void release_pages(struct page **pages, int nr, int cold)
>>   			del_page_from_lru(zone, page);
>>   		}
>>
>> -		if (!pagevec_add(&pages_to_free, page)) {
>> -			if (zone) {
>> -				spin_unlock_irqrestore(&zone->lru_lock, flags);
>> -				zone = NULL;
>> -			}
>> -			__pagevec_free(&pages_to_free);
>> -			pagevec_reinit(&pages_to_free);
>> -  		}
>> +		list_add_tail(&page->lru,&pages_to_free);
>
> There's a potential problem here with cache longevity.  If
> release_pages() is called with a large number of pages then the current
> code's approach of freeing pages 16-at-a-time will hopefully cause
> those pageframes to still be in CPU cache when we get to actually
> freeing them.
>
> But after this change, we free all the pages in a single operation
> right at the end, which adds risk that we'll have to reload all their
> pageframes into CPU cache again.
>
> That'll only be a problem if release_pages() _is_ called with a large
> number of pages.  And manipulating large numbers of pages represents a
> lot of work, so the additional work from one cachemiss per page will
> presumably be tiny.
>
>

all release_pages() callers (except fuse) call it for pages array not bigger than PAGEVEC_SIZE (=14).
while for fuse it put likely not last page reference, so we didn't free them on this path.
