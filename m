Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab2HXCb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 22:31:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45646 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab2HXCbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 22:31:23 -0400
Message-ID: <5036E773.6020609@gmail.com>
Date: Fri, 24 Aug 2012 10:31:15 +0800
From: wujianguo <wujianguo106@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Petr Tesarik <ptesarik@suse.cz>
CC: tony.luck@intel.com, fenghua.yu@intel.com, dhowells@redhat.com,
        tj@kernel.org, mgorman@suse.de, yinghai@kernel.org,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, aarcange@redhat.com, davem@davemloft.net,
        hannes@cmpxchg.org, liuj97@gmail.com, wency@cn.fujitsu.com,
        rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jiang.liu@huawei.com, guohanjun@huawei.com,
        qiuxishi@huawei.com
Subject: Re: [PATCH]mm: fix-up zone present pages
References: <5031DB52.9030806@gmail.com> <201208210555.41312.ptesarik@suse.cz>
In-Reply-To: <201208210555.41312.ptesarik@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-8-21 11:55, Petr Tesarik wrote:
> Dne Po 20. srpna 2012 08:38:10 wujianguo napsal(a):
>> From: Jianguo Wu <wujianguo@huawei.com>
>>
>> Hi all,
>> 	I think zone->present_pages indicates pages that buddy system can
>> management, it should be:
>> 	zone->present_pages = spanned pages - absent pages - bootmem pages,
>> but now:
>> 	zone->present_pages = spanned pages - absent pages - memmap pages.
>> spanned pages：total size, including holes.
>> absent pages: holes.
>> bootmem pages: pages used in system boot, managed by bootmem allocator.
>> memmap pages: pages used by page structs.
> 
> Absolutely. The memory allocated to page structs should be counted in.
> 

Hi Petr,
	Bootmem pages include the memory allocated to page structs.

Thanks!
Jianguo Wu

>> This may cause zone->present_pages less than it should be.
>> For example, numa node 1 has ZONE_NORMAL and ZONE_MOVABLE,
>> it's memmap and other bootmem will be allocated from ZONE_MOVABLE,
>> so ZONE_NORMAL's present_pages should be spanned pages - absent pages,
>> but now it also minus memmap pages(free_area_init_core), which are actually
>> allocated from ZONE_MOVABLE. When offline all memory of a zone, This will
>> cause zone->present_pages less than 0, because present_pages is unsigned
>> long type, it is actually a very large integer, it indirectly caused
>> zone->watermark[WMARK_MIN] become a large
>> integer(setup_per_zone_wmarks()), than cause totalreserve_pages become a
>> large integer(calculate_totalreserve_pages()), and finally cause memory
>> allocating failure when fork process(__vm_enough_memory()).
>>
>> [root@localhost ~]# dmesg
>> -bash: fork: Cannot allocate memory
>>
>> I think bug described in http://marc.info/?l=linux-mm&m=134502182714186&w=2
>> is also caused by wrong zone present pages.
> 
> And yes, I can confirm that the bug I reported is caused by a too low number 
> for the present pages counter. Your patch does fix the bug for me.
> 
> Thanks!
> Petr Tesarik
> 

