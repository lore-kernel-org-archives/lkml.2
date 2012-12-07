Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2LGHGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 02:06:45 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:20368 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab2LGHGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 02:06:42 -0500
Message-ID: <50C19568.7080500@huawei.com>
Date: Fri, 7 Dec 2012 15:06:16 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: Wen Congyang <wency@cn.fujitsu.com>, <x86@kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
        <linux-ia64@vger.kernel.org>, <cmetcalf@tilera.com>,
        <sparclinux@vger.kernel.org>, David Rientjes <rientjes@google.com>,
        Jiang Liu <liuj97@gmail.com>, Len Brown <len.brown@intel.com>,
        <benh@kernel.crashing.org>, <paulus@samba.org>,
        Christoph Lameter <cl@linux.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [Patch v4 09/12] memory-hotplug: remove page table of x86_64
 architecture
References: <1354010422-19648-1-git-send-email-wency@cn.fujitsu.com> <1354010422-19648-10-git-send-email-wency@cn.fujitsu.com> <50C19022.9000501@cn.fujitsu.com>
In-Reply-To: <50C19022.9000501@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/12/7 14:43, Tang Chen wrote:

> On 11/27/2012 06:00 PM, Wen Congyang wrote:
>> For hot removing memory, we sholud remove page table about the memory.
>> So the patch searches a page table about the removed memory, and clear
>> page table.
> 
> (snip)
> 
>> +void __meminit
>> +kernel_physical_mapping_remove(unsigned long start, unsigned long end)
>> +{
>> +    unsigned long next;
>> +    bool pgd_changed = false;
>> +
>> +    start = (unsigned long)__va(start);
>> +    end = (unsigned long)__va(end);
> 
> Hi Wu,
> 
> Here, you expect start and end are physical addresses. But in
> phys_xxx_remove() function, I think using virtual addresses is just
> fine. Functions like pmd_addr_end() and pud_index() only calculate
> an offset.
>

Hi Tang,

 

Virtual addresses will work fine, I used physical addresses in order to
keep consistent with phys_pud[pmd/pte]_init(), So I think we should keep this.

Thanks,
Jianguo Wu

> So, would you please tell me if we have to use physical addresses here ?
> 
> Thanks. :)
> 
>> +
>> +    for (; start<  end; start = next) {
>> +        pgd_t *pgd = pgd_offset_k(start);
>> +        pud_t *pud;
>> +
>> +        next = pgd_addr_end(start, end);
>> +
>> +        if (!pgd_present(*pgd))
>> +            continue;
>> +
>> +        pud = map_low_page((pud_t *)pgd_page_vaddr(*pgd));
>> +        phys_pud_remove(pud, __pa(start), __pa(next));
>> +        if (free_pud_table(pud, pgd))
>> +            pgd_changed = true;
>> +        unmap_low_page(pud);
>> +    }
>> +
>> +    if (pgd_changed)
>> +        sync_global_pgds(start, end - 1);
>> +
>> +    flush_tlb_all();
>> +}
>> +
>>   #ifdef CONFIG_MEMORY_HOTREMOVE
>>   int __ref arch_remove_memory(u64 start, u64 size)
>>   {
>> @@ -692,6 +921,8 @@ int __ref arch_remove_memory(u64 start, u64 size)
>>       ret = __remove_pages(zone, start_pfn, nr_pages);
>>       WARN_ON_ONCE(ret);
>>
>> +    kernel_physical_mapping_remove(start, start + size);
>> +
>>       return ret;
>>   }
>>   #endif
> 
> 
> 
> .
> 



