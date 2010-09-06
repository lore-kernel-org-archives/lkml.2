Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0IFRPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 13:15:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34295 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab0IFRPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 13:15:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dIIGSYpQdgXcgbXre83x8QUGr8OVNFLFdtaLzMj0ROIaeT6XXffUVAT1hiUVNSqqtf
         JCzBKWQp/75kXVXKQMVoiDjlauhs+t8KoqtU0RPZA8s6Yrby7TaPukclAQpXV3AB/rzE
         jWGig4PP5dnQ8d6T9iQVi2om1UIZcxcwYxGtM=
MIME-Version: 1.0
In-Reply-To: <20100906133914.GL8384@csn.ul.ie>
References: <20100906144019.946d3c49.kamezawa.hiroyu@jp.fujitsu.com>
	<20100906144228.4ee5a738.kamezawa.hiroyu@jp.fujitsu.com>
	<20100906133914.GL8384@csn.ul.ie>
Date: Tue, 7 Sep 2010 02:15:01 +0900
Message-ID: <AANLkTikPkKcxja4tqRPmJErEGs3YZ=NS4dBNyz1e--+d@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH 1/3] memory hotplug: fix next block calculation in is_removable
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, fengguang.wu@intel.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        andi.kleen@intel.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/6 Mel Gorman <mel@csn.ul.ie>:
> On Mon, Sep 06, 2010 at 02:42:28PM +0900, KAMEZAWA Hiroyuki wrote:
>>
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> next_active_pageblock() is for finding next _used_ freeblock. It skips
>> several blocks when it finds there are a chunk of free pages lager than
>> pageblock. But it has 2 bugs.
>>
>>   1. We have no lock. page_order(page) - pageblock_order can be minus.
>>   2. pageblocks_stride += is wrong. it should skip page_order(p) of pages.
>>
>> CC: stable@kernel.org
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>>  mm/memory_hotplug.c |   16 ++++++++--------
>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> Index: kametest/mm/memory_hotplug.c
>> ===================================================================
>> --- kametest.orig/mm/memory_hotplug.c
>> +++ kametest/mm/memory_hotplug.c
>> @@ -584,19 +584,19 @@ static inline int pageblock_free(struct
>>  /* Return the start of the next active pageblock after a given page */
>>  static struct page *next_active_pageblock(struct page *page)
>>  {
>> -     int pageblocks_stride;
>> -
>>       /* Ensure the starting page is pageblock-aligned */
>>       BUG_ON(page_to_pfn(page) & (pageblock_nr_pages - 1));
>>
>> -     /* Move forward by at least 1 * pageblock_nr_pages */
>> -     pageblocks_stride = 1;
>> -
>>       /* If the entire pageblock is free, move to the end of free page */
>> -     if (pageblock_free(page))
>> -             pageblocks_stride += page_order(page) - pageblock_order;
>> +     if (pageblock_free(page)) {
>> +             int order;
>> +             /* be careful. we don't have locks, page_order can be changed.*/
>> +             order = page_order(page);
>> +             if (order > pageblock_order)
>> +                     return page + (1 << order);
>> +     }
>
> As you note in your changelog, page_order() is unsafe because we do not have
> the zone lock but you don't check if order is somewhere between pageblock_order
> and MAX_ORDER_NR_PAGES. How is this safer?
>
Ah, I missed that.

if ((pageblock_order <= order) && (order < MAX_ORDER))
          return page + (1 << order);
ok ?

Thanks,
-Kame
