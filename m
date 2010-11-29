Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab0K2CNY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:13:24 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55848 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab0K2CNX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:13:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pKS2ZzsaKv6O7ME6yuTvgFCsrrouKT/QtF6qPNMdMEzpP1ZsU4rRRCyW9pAn/OsCbW
         nUDIu68xe9hjJxYBC2ja3PAjehGLVME2OjlDNUoIMTQQgLCD/ZlFS8cRqDOTgv5tciLv
         AYtAXM7/7mEPRyCVX10tgbtLhEX5u1lgnJCQQ=
MIME-Version: 1.0
In-Reply-To: <20101129090514.829C.A69D9226@jp.fujitsu.com>
References: <7b50614882592047dfd96f6ca2bb2d0baa8f5367.1290956059.git.minchan.kim@gmail.com>
	<20101129090514.829C.A69D9226@jp.fujitsu.com>
Date: Mon, 29 Nov 2010 11:13:22 +0900
Message-ID: <AANLkTikBvHn3Tc_RKTM8tGKjK1kgEZYsBCjXZSZ+Ri+-@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] deactivate invalidated pages
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KOSAKI,

On Mon, Nov 29, 2010 at 9:33 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> ---
>>  mm/swap.c |   84 +++++++++++++++++++++++++++++++++++++++++++++---------------
>>  1 files changed, 63 insertions(+), 21 deletions(-)
>>
>> diff --git a/mm/swap.c b/mm/swap.c
>> index 31f5ec4..345eca1 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -268,10 +268,65 @@ void add_page_to_unevictable_list(struct page *page)
>>       spin_unlock_irq(&zone->lru_lock);
>>  }
>>
>> -static void __pagevec_lru_deactive(struct pagevec *pvec)
>> +/*
>> + * This function is used by invalidate_mapping_pages.
>> + * If the page can't be invalidated, this function moves the page
>> + * into inative list's head or tail to reclaim ASAP and evict
>> + * working set page.
>> + *
>> + * PG_reclaim means when the page's writeback completes, the page
>> + * will move into tail of inactive for reclaiming ASAP.
>> + *
>> + * 1. active, mapped page -> inactive, head
>> + * 2. active, dirty/writeback page -> inactive, head, PG_reclaim
>> + * 3. inactive, mapped page -> none
>> + * 4. inactive, dirty/writeback page -> inactive, head, PG_reclaim
>> + * 5. others -> none
>> + *
>> + * In 4, why it moves inactive's head, the VM expects the page would
>> + * be writeout by flusher. The flusher's writeout is much effective than
>> + * reclaimer's random writeout.
>> + */
>> +static void __lru_deactivate(struct page *page, struct zone *zone)
>>  {
>> -     int i, lru, file;
>> +     int lru, file;
>> +     int active = 0;
>> +
>> +     if (!PageLRU(page))
>> +             return;
>> +
>> +     if (PageActive(page))
>> +             active = 1;
>> +     /* Some processes are using the page */
>> +     if (page_mapped(page) && !active)
>> +             return;
>> +
>> +     else if (PageWriteback(page)) {
>> +             SetPageReclaim(page);
>> +             /* Check race with end_page_writeback */
>> +             if (!PageWriteback(page))
>> +                     ClearPageReclaim(page);
>> +     } else if (PageDirty(page))
>> +             SetPageReclaim(page);
>> +
>> +     file = page_is_file_cache(page);
>> +     lru = page_lru_base_type(page);
>> +     del_page_from_lru_list(zone, page, lru + active);
>> +     ClearPageActive(page);
>> +     ClearPageReferenced(page);
>> +     add_page_to_lru_list(zone, page, lru);
>> +     if (active)
>> +             __count_vm_event(PGDEACTIVATE);
>> +
>> +     update_page_reclaim_stat(zone, page, file, 0);
>> +}
>
> I don't like this change because fadvise(DONT_NEED) is rarely used
> function and this PG_reclaim trick doesn't improve so much. In the
> other hand, It increase VM state mess.

Chick-egg problem.
Why fadvise(DONT_NEED) is rarely used is it's hard to use effective.
mincore + fdatasync + fadvise series is very ugly.
This patch's goal is to solve it.

PG_reclaim trick would prevent working set eviction.
If you fadvise call and there are the invalidated page which are
dirtying in middle of inactive LRU,
reclaimer would evict working set of inactive LRU's tail even if we
have a invalidated page in LRU.
It's bad.

About VM state mess, PG_readahead already have done it.
But I admit this patch could make it worse and that's why I Cced Wu Fengguang.

The problem it can make is readahead confusing and working set
eviction after writeback.
I can add ClearPageReclaim of mark_page_accessed for clear flag if the
page is accessed during race.
But I didn't add it in this version because I think it's very rare case.

I don't want to add new page flag due to this function or revert merge
patch of (PG_readahead and PG_reclaim)


>
> However, I haven't found any fault and unworked reason in this patch.
>
Thanks for the good review, KOSAKI. :)


-- 
Kind regards,
Minchan Kim
