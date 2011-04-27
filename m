Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab1D0JIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:08:07 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42527 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab1D0JIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:08:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o3+jDJJ5zZ85rcwzCIlI6IouMMNrypJGfVJ2EljBOGJjVKJRyHpvDpsDxryzU7T4D/
         9ZCe0LSacrbFsjbkZ7B+HFFDynN9oGzc82n5ec9Vpo80pC9RkdSMl6BhjfQl8HF52jSQ
         5CPhJKS72ISk2bXUnFTUqfx8RKs+B+hWiXImM=
MIME-Version: 1.0
In-Reply-To: <20110427173922.4d65534b.kamezawa.hiroyu@jp.fujitsu.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
	<b7bcce639e9b9bf515431cda79b15d482f889ff2.1303833418.git.minchan.kim@gmail.com>
	<20110427173922.4d65534b.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 27 Apr 2011 18:08:04 +0900
Message-ID: <BANLkTikNa+Bq3PjXwX12-uKaNjFRrwdhaQ@mail.gmail.com>
Subject: Re: [RFC 8/8] compaction: make compaction use in-order putback
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 5:39 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 27 Apr 2011 01:25:25 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> Compaction is good solution to get contiguos page but it makes
>> LRU churing which is not good.
>> This patch makes that compaction code use in-order putback so
>> after compaction completion, migrated pages are keeping LRU ordering.
>>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Rik van Riel <riel@redhat.com>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> ---
>>  mm/compaction.c |   22 +++++++++++++++-------
>>  1 files changed, 15 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index a2f6e96..480d2ac 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -211,11 +211,11 @@ static void isolate_freepages(struct zone *zone,
>>  /* Update the number of anon and file isolated pages in the zone */
>>  static void acct_isolated(struct zone *zone, struct compact_control *cc)
>>  {
>> -     struct page *page;
>> +     struct pages_lru *pages_lru;
>>       unsigned int count[NR_LRU_LISTS] = { 0, };
>>
>> -     list_for_each_entry(page, &cc->migratepages, lru) {
>> -             int lru = page_lru_base_type(page);
>> +     list_for_each_entry(pages_lru, &cc->migratepages, lru) {
>> +             int lru = page_lru_base_type(pages_lru->page);
>>               count[lru]++;
>>       }
>>
>> @@ -281,6 +281,7 @@ static unsigned long isolate_migratepages(struct zone *zone,
>>       spin_lock_irq(&zone->lru_lock);
>>       for (; low_pfn < end_pfn; low_pfn++) {
>>               struct page *page;
>> +             struct pages_lru *pages_lru;
>>               bool locked = true;
>>
>>               /* give a chance to irqs before checking need_resched() */
>> @@ -334,10 +335,16 @@ static unsigned long isolate_migratepages(struct zone *zone,
>>                       continue;
>>               }
>>
>> +             pages_lru = kmalloc(sizeof(struct pages_lru), GFP_ATOMIC);
>> +             if (pages_lru)
>> +                     continue;
>
> Hmm, can't we use fixed size of statically allocated pages_lru, per-node or
> per-zone ? I think using kmalloc() in memory reclaim path is risky.

Yes. we can enhance it with pagevec-like approach.
It's my TODO list.  :)

In compaction POV, it is used by reclaiming big order pages so most of
time order-0 pages are enough. It's basic assumption of compaction so
it shouldn't be a problem.

Thanks for the review, Kame.


-- 
Kind regards,
Minchan Kim
