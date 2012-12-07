Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab2LGHgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 02:36:31 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:61470 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab2LGHga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 02:36:30 -0500
Message-ID: <50C19C33.9030502@huawei.com>
Date: Fri, 7 Dec 2012 15:35:15 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, WuJianguo <wujianguo@huawei.com>,
        Liujiang <jiang.liu@huawei.com>, <andi@firstfloor.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>
Subject: Re: [PATCH] MCE: fix an error of mce_bad_pages statistics
References: <50C15A35.5020007@huawei.com> <20121207072541.GA27708@liondog.tnic>
In-Reply-To: <20121207072541.GA27708@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/12/7 15:25, Borislav Petkov wrote:

> On Fri, Dec 07, 2012 at 10:53:41AM +0800, Xishi Qiu wrote:
>> On x86 platform, if we use "/sys/devices/system/memory/soft_offline_page" to offline a
>> free page twice, the value of mce_bad_pages will be added twice. So this is an error,
>> since the page was already marked HWPoison, we should skip the page and don't add the
>> value of mce_bad_pages.
>>
>> $ cat /proc/meminfo | grep HardwareCorrupted
>>
>> soft_offline_page()
>> 	get_any_page()
>> 		atomic_long_add(1, &mce_bad_pages)
>>
>> The free page which marked HWPoison is still managed by page buddy allocator. So when
>> offlining it again, get_any_page() always returns 0 with
>> "pr_info("%s: %#lx free buddy page\n", __func__, pfn);".
>>
>> When page is allocated, the PageBuddy is removed in bad_page(), then get_any_page()
>> returns -EIO with pr_info("%s: %#lx: unknown zero refcount page type %lx\n", so
>> mce_bad_pages will not be added.
>>
>> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
>> ﻿Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> ---
>>  mm/memory-failure.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index 8b20278..02a522e 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -1375,6 +1375,11 @@ static int get_any_page(struct page *p, unsigned long pfn, int flags)
>>  	if (flags & MF_COUNT_INCREASED)
>>  		return 1;
>>
>> +	if (PageHWPoison(p)) {
>> +		pr_info("%s: %#lx page already poisoned\n", __func__, pfn);
>> +		return -EBUSY;
>> +	}
> 
> Shouldn't this be done in soft_offline_page() instead, like it is done
> in soft_offline_huge_page() for hugepages?
> 
> Thanks.
> 

Hi Borislav, you mean we should move this to the beginning of soft_offline_page()?

soft_offline_page()
{
	...
	get_any_page()
	...
	/*
	 * Synchronized using the page lock with memory_failure()
	 */
	if (PageHWPoison(page)) {
		unlock_page(page);
		put_page(page);
		pr_info("soft offline: %#lx page already poisoned\n", pfn);
		return -EBUSY;
	}
	...
}

Thanks
Xishi Qiu













