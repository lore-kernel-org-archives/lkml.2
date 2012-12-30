Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab2L3FnL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 00:43:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:38733 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab2L3FnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 00:43:06 -0500
X-IronPort-AV: E=Sophos;i="4.84,379,1355068800"; 
   d="scan'208";a="6500583"
Message-ID: <50DFD5FF.7050609@cn.fujitsu.com>
Date: Sun, 30 Dec 2012 13:49:51 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Tang Chen <tangchen@cn.fujitsu.com>, akpm@linux-foundation.org,
        rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com, hpa@zytor.com,
        linfeng@cn.fujitsu.com, laijs@cn.fujitsu.com, mgorman@suse.de,
        yinghai@kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-ia64@vger.kernel.org,
        cmetcalf@tilera.com, sparclinux@vger.kernel.org
Subject: Re: [PATCH v5 01/14] memory-hotplug: try to offline the memory twice
 to avoid dependence
References: <1356350964-13437-1-git-send-email-tangchen@cn.fujitsu.com> <1356350964-13437-2-git-send-email-tangchen@cn.fujitsu.com> <50DA68A8.4060001@jp.fujitsu.com>
In-Reply-To: <50DA68A8.4060001@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/30 13:42:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/30 13:42:45,
	Serialize complete at 2012/12/30 13:42:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 12/26/2012 11:02 AM, Kamezawa Hiroyuki Wrote:
> (2012/12/24 21:09), Tang Chen wrote:
>> From: Wen Congyang <wency@cn.fujitsu.com>
>>
>> memory can't be offlined when CONFIG_MEMCG is selected.
>> For example: there is a memory device on node 1. The address range
>> is [1G, 1.5G). You will find 4 new directories memory8, memory9, memory10,
>> and memory11 under the directory /sys/devices/system/memory/.
>>
>> If CONFIG_MEMCG is selected, we will allocate memory to store page cgroup
>> when we online pages. When we online memory8, the memory stored page cgroup
>> is not provided by this memory device. But when we online memory9, the memory
>> stored page cgroup may be provided by memory8. So we can't offline memory8
>> now. We should offline the memory in the reversed order.
>>
> 
> If memory8 is onlined as NORMAL memory ...right ?

Yes, memory8 is onlined as NORMAL memory. And when we online memory9, we allocate
memory from memory8 to store page cgroup information.

> 
> IIUC, vmalloc() uses __GFP_HIGHMEM but doesn't use __GFP_MOVABLE.
> 
>> When the memory device is hotremoved, we will auto offline memory provided
>> by this memory device. But we don't know which memory is onlined first, so
>> offlining memory may fail. In such case, iterate twice to offline the memory.
>> 1st iterate: offline every non primary memory block.
>> 2nd iterate: offline primary (i.e. first added) memory block.
>>
>> This idea is suggested by KOSAKI Motohiro.
>>
>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> 
> I'm not sure but the whole DIMM should be onlined as MOVABLE mem ?

If the whole DIMM is onlined as MOVABLE mem, we can offline it, and don't
retry again.

> 
> Anyway, I agree this kind of retry is required if memory is onlined as NORMAL mem.
> But retry-once is ok ?

I'am not sure, but I think in most cases the user may online the memory according first
which is hot-added first. So we may always fail in the first time, and retry-once can
success.

Thanks
Wen Congyang

> 
> Thanks,
> -Kame
> 
>> ---
>>   mm/memory_hotplug.c |   16 ++++++++++++++--
>>   1 files changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index d04ed87..62e04c9 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1388,10 +1388,13 @@ int remove_memory(u64 start, u64 size)
>>   	unsigned long start_pfn, end_pfn;
>>   	unsigned long pfn, section_nr;
>>   	int ret;
>> +	int return_on_error = 0;
>> +	int retry = 0;
>>   
>>   	start_pfn = PFN_DOWN(start);
>>   	end_pfn = start_pfn + PFN_DOWN(size);
>>   
>> +repeat:
>>   	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
>>   		section_nr = pfn_to_section_nr(pfn);
>>   		if (!present_section_nr(section_nr))
>> @@ -1410,14 +1413,23 @@ int remove_memory(u64 start, u64 size)
>>   
>>   		ret = offline_memory_block(mem);
>>   		if (ret) {
>> -			kobject_put(&mem->dev.kobj);
>> -			return ret;
>> +			if (return_on_error) {
>> +				kobject_put(&mem->dev.kobj);
>> +				return ret;
>> +			} else {
>> +				retry = 1;
>> +			}
>>   		}
>>   	}
>>   
>>   	if (mem)
>>   		kobject_put(&mem->dev.kobj);
>>   
>> +	if (retry) {
>> +		return_on_error = 1;
>> +		goto repeat;
>> +	}
>> +
>>   	return 0;
>>   }
>>   #else
>>
> 
> 
> 

