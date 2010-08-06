Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab0HFAwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 20:52:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62255 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759378Ab0HFAwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 20:52:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WiFd4IoCKQAneZbzMBWTnzbVMmHdr0r/fv4J+kvrzrC0qL1E9Ejff+IIsTo8ERNPO1
         g7sJGUQK5E1fGXQTHW8sdauv1am7l/XsYgEWNLNBOxKIEgG06wwfHsp9YK+NRtFvWT03
         1G/Ozj/MQVSqbjPDZvI4Yeb3KNxWJU1KeJ+F4=
MIME-Version: 1.0
In-Reply-To: <20100805141706.GB2985@barrios-desktop>
References: <20100805150624.31B7.A69D9226@jp.fujitsu.com>
	<20100805151304.31C0.A69D9226@jp.fujitsu.com>
	<20100805141706.GB2985@barrios-desktop>
Date: Fri, 6 Aug 2010 09:52:37 +0900
Message-ID: <AANLkTimYxERF5Gj300tKyF-DANQ4dae-wHpadf2putyh@mail.gmail.com>
Subject: Re: [PATCH 3/7] vmscan: synchrounous lumpy reclaim use lock_page() 
	instead trylock_page()
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 11:17 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Thu, Aug 05, 2010 at 03:13:39PM +0900, KOSAKI Motohiro wrote:
>> When synchrounous lumpy reclaim, there is no reason to give up to
>> reclaim pages even if page is locked. We use lock_page() instead
>> trylock_page() in this case.
>>
>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> ---
>>  mm/vmscan.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 1cdc3db..833b6ad 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -665,7 +665,9 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>>               page = lru_to_page(page_list);
>>               list_del(&page->lru);
>>
>> -             if (!trylock_page(page))
>> +             if (sync_writeback == PAGEOUT_IO_SYNC)
>> +                     lock_page(page);
>> +             else if (!trylock_page(page))
>>                       goto keep;
>>
>>               VM_BUG_ON(PageActive(page));
>> --
>> 1.6.5.2
>>
>>
>>
>
> Hmm. We can make sure lumpy already doesn't select the page locked?
> I mean below scenario.
>
> LRU head -> page A -> page B -> LRU tail
>
> lock_page(page A)
> some_function()
> direct reclaim
> select victim page B
> enter lumpy mode
> select victim page A as well as page B
> shrink_page_list
> lock_page(page A)
>
>
> --
> Kind regards,
> Minchan Kim
>

Ignore above comment.
lock_page doesn't have a deadlock problem. My bad.

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>



-- 
Kind regards,
Minchan Kim
