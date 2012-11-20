Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab2KTPSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:18:51 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45101 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2KTPSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:18:48 -0500
Message-ID: <50AB9F4A.5050500@gmail.com>
Date: Tue, 20 Nov 2012 23:18:34 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Wen Congyang <wency@cn.fujitsu.com>, David Rientjes <rientjes@google.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFT PATCH v1 4/5] mm: provide more accurate estimation of pages
 occupied by memmap
References: <20121115112454.e582a033.akpm@linux-foundation.org> <1353254850-27336-1-git-send-email-jiang.liu@huawei.com> <1353254850-27336-5-git-send-email-jiang.liu@huawei.com> <20121119154240.91efcc53.akpm@linux-foundation.org>
In-Reply-To: <20121119154240.91efcc53.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 07:42 AM, Andrew Morton wrote:
> On Mon, 19 Nov 2012 00:07:29 +0800
> Jiang Liu <liuj97@gmail.com> wrote:
> 
>> If SPARSEMEM is enabled, it won't build page structures for
>> non-existing pages (holes) within a zone, so provide a more accurate
>> estimation of pages occupied by memmap if there are big holes within
>> the zone.
>>
>> And pages for highmem zones' memmap will be allocated from lowmem,
>> so charge nr_kernel_pages for that.
>>
>> ...
>>
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -4435,6 +4435,22 @@ void __init set_pageblock_order(void)
>>  
>>  #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
>>  
>> +static unsigned long calc_memmap_size(unsigned long spanned_pages,
>> +				      unsigned long present_pages)
>> +{
>> +	unsigned long pages = spanned_pages;
>> +
>> +	/*
>> +	 * Provide a more accurate estimation if there are big holes within
>> +	 * the zone and SPARSEMEM is in use.
>> +	 */
>> +	if (spanned_pages > present_pages + (present_pages >> 4) &&
>> +	    IS_ENABLED(CONFIG_SPARSEMEM))
>> +		pages = present_pages;
>> +
>> +	return PAGE_ALIGN(pages * sizeof(struct page)) >> PAGE_SHIFT;
>> +}
> 
> Please explain the ">> 4" heuristc more completely - preferably in both
> the changelog and code comments.  Why can't we calculate this
> requirement exactly?  That might require a second pass, but that's OK for
> code like this?
Hi Andrew,
	A normal x86 platform always have some holes within the DMA ZONE,
so the ">> 4" heuristic is to avoid applying this adjustment to the DMA
ZONE on x86 platforms. 
	Because the memmap_size is just an estimation, I feel it's OK to
remove the ">> 4" heuristic, that shouldn't affect much.

Thanks
Gerry
