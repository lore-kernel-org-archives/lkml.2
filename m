Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030247Ab2GMFhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:37:47 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18839 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030184Ab2GMFho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:37:44 -0400
Message-ID: <4FFFB42A.60303@oracle.com>
Date: Fri, 13 Jul 2012 13:37:46 +0800
From: "zhenzhong.duan" <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, jeremy@goop.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        xen-devel@lists.xensource.com, x86@kernel.org,
        Feng Jin <joe.jin@oracle.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Xen-devel] [PATCH] xen: populate correct number of pages when
 across mem boundary
References: <4FF3E781.5040603@oracle.com> <4FFEE552.4070201@citrix.com>
In-Reply-To: <4FFEE552.4070201@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



于 2012-07-12 22:55, David Vrabel 写道:
> On 04/07/12 07:49, zhenzhong.duan wrote:
>> When populate pages across a mem boundary at bootup, the page count
>> populated isn't correct. This is due to mem populated to non-mem
>> region and ignored.
>>
>> Pfn range is also wrongly aligned when mem boundary isn't page aligned.
>>
>> Also need consider the rare case when xen_do_chunk fail(populate).
>>
>> For a dom0 booted with dom_mem=3368952K(0xcd9ff000-4k) dmesg diff is:
>>   [    0.000000] Freeing 9e-100 pfn range: 98 pages freed
>>   [    0.000000] 1-1 mapping on 9e->100
>>   [    0.000000] 1-1 mapping on cd9ff->100000
>>   [    0.000000] Released 98 pages of unused memory
>>   [    0.000000] Set 206435 page(s) to 1-1 mapping
>> -[    0.000000] Populating cd9fe-cda00 pfn range: 1 pages added
>> +[    0.000000] Populating cd9fe-cd9ff pfn range: 1 pages added
>> +[    0.000000] Populating 100000-100061 pfn range: 97 pages added
>>   [    0.000000] BIOS-provided physical RAM map:
>>   [    0.000000] Xen: 0000000000000000 - 000000000009e000 (usable)
>>   [    0.000000] Xen: 00000000000a0000 - 0000000000100000 (reserved)
>>   [    0.000000] Xen: 0000000000100000 - 00000000cd9ff000 (usable)
>>   [    0.000000] Xen: 00000000cd9ffc00 - 00000000cda53c00 (ACPI NVS)
>> ...
>>   [    0.000000] Xen: 0000000100000000 - 0000000100061000 (usable)
>>   [    0.000000] Xen: 0000000100061000 - 000000012c000000 (unusable)
>> ...
>>   [    0.000000] MEMBLOCK configuration:
>> ...
>> -[    0.000000]  reserved[0x4]       [0x000000cd9ff000-0x000000cd9ffbff], 0xc00 bytes
>> -[    0.000000]  reserved[0x5]       [0x00000100000000-0x00000100060fff], 0x61000 bytes
>>
>> Related xen memory layout:
>> (XEN) Xen-e820 RAM map:
>> (XEN)  0000000000000000 - 000000000009ec00 (usable)
>> (XEN)  00000000000f0000 - 0000000000100000 (reserved)
>> (XEN)  0000000000100000 - 00000000cd9ffc00 (usable)
>>
>> Signed-off-by: Zhenzhong Duan<zhenzhong.duan@oracle.com>
>> ---
>>   arch/x86/xen/setup.c |   24 +++++++++++-------------
>>   1 files changed, 11 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
>> index a4790bf..bd78773 100644
>> --- a/arch/x86/xen/setup.c
>> +++ b/arch/x86/xen/setup.c
>> @@ -157,50 +157,48 @@ static unsigned long __init xen_populate_chunk(
>>   	unsigned long dest_pfn;
>>
>>   	for (i = 0, entry = list; i<  map_size; i++, entry++) {
>> -		unsigned long credits = credits_left;
>>   		unsigned long s_pfn;
>>   		unsigned long e_pfn;
>>   		unsigned long pfns;
>>   		long capacity;
>>
>> -		if (credits<= 0)
>> +		if (credits_left<= 0)
>>   			break;
>>
>>   		if (entry->type != E820_RAM)
>>   			continue;
>>
>> -		e_pfn = PFN_UP(entry->addr + entry->size);
>> +		e_pfn = PFN_DOWN(entry->addr + entry->size);
> Ok.
>
>>
>>   		/* We only care about E820 after the xen_start_info->nr_pages */
>>   		if (e_pfn<= max_pfn)
>>   			continue;
>>
>> -		s_pfn = PFN_DOWN(entry->addr);
>> +		s_pfn = PFN_UP(entry->addr);
> Ok.
>
>>   		/* If the E820 falls within the nr_pages, we want to start
>>   		 * at the nr_pages PFN.
>>   		 * If that would mean going past the E820 entry, skip it
>>   		 */
>> +again:
>>   		if (s_pfn<= max_pfn) {
>>   			capacity = e_pfn - max_pfn;
>>   			dest_pfn = max_pfn;
>>   		} else {
>> -			/* last_pfn MUST be within E820_RAM regions */
>> -			if (*last_pfn&&  e_pfn>= *last_pfn)
>> -				s_pfn = *last_pfn;
>>   			capacity = e_pfn - s_pfn;
>>   			dest_pfn = s_pfn;
>>   		}
>> -		/* If we had filled this E820_RAM entry, go to the next one. */
>> -		if (capacity<= 0)
>> -			continue;
>>
>> -		if (credits>  capacity)
>> -			credits = capacity;
>> +		if (credits_left<  capacity)
>> +			capacity = credits_left;
>>
>> -		pfns = xen_do_chunk(dest_pfn, dest_pfn + credits, false);
>> +		pfns = xen_do_chunk(dest_pfn, dest_pfn + capacity, false);
>>   		done += pfns;
>>   		credits_left -= pfns;
>>   		*last_pfn = (dest_pfn + pfns);
>> +		if (credits_left>  0&&  *last_pfn<  e_pfn) {
>> +			s_pfn = *last_pfn;
>> +			goto again;
>> +		}
> This looks like it will loop forever if xen_do_chunk() repeatedly fails
> because Xen is out of pages.  I think if xen_do_chunk() cannot get a
> page from Xen the repopulation process should stop -- aborting this
> chunk and any others.  This will allow the guest to continue to boot
> just with less memory than expected.
>
> David
Ok, I'll update the patch, loop forever isn't a good idea.
Originally, I considered the case there is dynamic memory control 
functionality in the system.
thanks for comment.
