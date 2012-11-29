Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab2K2CZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 21:25:42 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:35046 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab2K2CZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 21:25:40 -0500
Message-ID: <50B6C77D.7070307@huawei.com>
Date: Thu, 29 Nov 2012 10:25:01 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jiang Liu <liuj97@gmail.com>, Wen Congyang <wency@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH v2 4/5] mm: provide more accurate estimation of pages
 occupied by memmap
References: <20121120111942.c9596d3f.akpm@linux-foundation.org> <1353510586-6393-1-git-send-email-jiang.liu@huawei.com> <20121128155221.df369ce4.akpm@linux-foundation.org>
In-Reply-To: <20121128155221.df369ce4.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/29 7:52, Andrew Morton wrote:

> On Wed, 21 Nov 2012 23:09:46 +0800
> Jiang Liu <liuj97@gmail.com> wrote:
> 
>> Subject: Re: [RFT PATCH v2 4/5] mm: provide more accurate estimation of pages occupied by memmap
> 
> How are people to test this?  "does it boot"?
> 

I have tested this in x86_64, it does boot.

Node 0, zone      DMA
  pages free     3972
        min      1
        low      1
        high     1
        scanned  0
        spanned  4080
        present  3979
        managed  3972

Node 0, zone    DMA32
  pages free     448783
        min      172
        low      215
        high     258
        scanned  0
        spanned  1044480
        present  500799
        managed  444545

Node 0, zone   Normal
  pages free     2375547
        min      1394
        low      1742
        high     2091
        scanned  0
        spanned  3670016
        present  3670016
        managed  3585105

Thanks,
Jianguo Wu

>> If SPARSEMEM is enabled, it won't build page structures for
>> non-existing pages (holes) within a zone, so provide a more accurate
>> estimation of pages occupied by memmap if there are bigger holes within
>> the zone.
>>
>> And pages for highmem zones' memmap will be allocated from lowmem, so
>> charge nr_kernel_pages for that.
>>
>> ...
>>
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -4442,6 +4442,26 @@ void __init set_pageblock_order(void)
>>  
>>  #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
>>  
>> +static unsigned long calc_memmap_size(unsigned long spanned_pages,
>> +				      unsigned long present_pages)
>> +{
>> +	unsigned long pages = spanned_pages;
>> +
>> +	/*
>> +	 * Provide a more accurate estimation if there are holes within
>> +	 * the zone and SPARSEMEM is in use. If there are holes within the
>> +	 * zone, each populated memory region may cost us one or two extra
>> +	 * memmap pages due to alignment because memmap pages for each
>> +	 * populated regions may not naturally algined on page boundary.
>> +	 * So the (present_pages >> 4) heuristic is a tradeoff for that.
>> +	 */
>> +	if (spanned_pages > present_pages + (present_pages >> 4) &&
>> +	    IS_ENABLED(CONFIG_SPARSEMEM))
>> +		pages = present_pages;
>> +
>> +	return PAGE_ALIGN(pages * sizeof(struct page)) >> PAGE_SHIFT;
>> +}
>> +
> 
> I spose we should do this, although it makes no difference as the
> compiler will inline calc_memmap_size() into its caller:
> 
> --- a/mm/page_alloc.c~mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix
> +++ a/mm/page_alloc.c
> @@ -4526,8 +4526,8 @@ void __init set_pageblock_order(void)
>  
>  #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
>  
> -static unsigned long calc_memmap_size(unsigned long spanned_pages,
> -				      unsigned long present_pages)
> +static unsigned long __paginginit calc_memmap_size(unsigned long spanned_pages,
> +						   unsigned long present_pages)
>  {
>  	unsigned long pages = spanned_pages;
>  
> 
> 
> .
> 



