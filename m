Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab0JLMhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 08:37:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:35665 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932221Ab0JLMhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 08:37:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,320,1283756400"; 
   d="scan'208";a="335092617"
Message-ID: <4CB45672.7020206@linux.intel.com>
Date: Tue, 12 Oct 2010 14:37:06 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andi Kleen <andi@firstfloor.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HWPOISON: Implement hwpoison-on-free for soft offlining
References: <1286402951-1881-1-git-send-email-andi@firstfloor.org> <1286402951-1881-2-git-send-email-andi@firstfloor.org> <20101012122647.GA14208@localhost>
In-Reply-To: <20101012122647.GA14208@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/12/2010 2:26 PM, Wu Fengguang wrote:
>
>>
>> +#if defined(CONFIG_MEMORY_FAILURE)&&  BITS_PER_LONG == 64
> We have the simpler CONFIG_HWPOISON_ON_FREE :)
>

Leftover from when I didn't have that. Fixed.

>> +PAGEFLAG(HWPoisonOnFree, hwpoison_on_free)
>> +TESTSCFLAG(HWPoisonOnFree, hwpoison_on_free)
>> +#define __PG_HWPOISON_ON_FREE (1UL<<  PG_hwpoison_on_free)
>> +#else
>> +PAGEFLAG_FALSE(HWPoisonOnFree)
> Could define SETPAGEFLAG_NOOP(HWPoisonOnFree) too, for eliminating an
> #ifdef in the .c file.

Ok.

>
>>   	}
>> +
>> +	if (PageHWPoisonOnFree(page)) {
>> +		pr_info("soft_offline: %#lx: Delaying poision of unknown page %lx to free\n",
>> +			pfn, page->flags);
>> +		return -EIO; /* or 0? */
> -EIO looks safer because HWPoisonOnFree does not guarantee success.
>
Ok.

>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index a8cfa9c..519c24c 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -564,6 +564,8 @@ static inline int free_pages_check(struct page *page)
>>   		(page->mapping != NULL)  |
>>   		(atomic_read(&page->_count) != 0) |
>>   		(page->flags&  PAGE_FLAGS_CHECK_AT_FREE))) {
>> +		if (PageHWPoisonOnFree(page))
>> +			hwpoison_page_on_free(page);
> hwpoison_page_on_free() seems to be undefined when
> CONFIG_HWPOISON_ON_FREE is not defined.

Yes, but I rely on the compiler never generating the call in this case 
because
the test is zero.

It would fail on a unoptimized build, but the kernel doesn't support 
that anyways.

Thanks for the review.

-Andi

