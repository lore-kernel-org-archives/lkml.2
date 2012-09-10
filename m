Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab2IJRnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:43:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40161 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2IJRnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:43:43 -0400
Message-ID: <504E26BB.4020205@ti.com>
Date: Mon, 10 Sep 2012 13:43:23 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>,
        <grant.likely@secretlab.ca>, <linux@arm.linux.org.uk>,
        <will.deacon@arm.com>, Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH v2 16/22] ARM: mm: cleanup checks for membank overlap
 with vmalloc area
References: <1344648306-15619-1-git-send-email-cyril@ti.com> <1344648306-15619-17-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1208120034220.5231@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1208120034220.5231@xanadu.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/2012 12:36 AM, Nicolas Pitre wrote:
> On Fri, 10 Aug 2012, Cyril Chemparathy wrote:
>
>> On Keystone platforms, physical memory is entirely outside the 32-bit
>> addressible range.  Therefore, the (bank->start > ULONG_MAX) check below marks
>> the entire system memory as highmem, and this causes unpleasentness all over.
>>
>> This patch eliminates the extra bank start check (against ULONG_MAX) by
>> checking bank->start against the physical address corresponding to vmalloc_min
>> instead.
>>
>> In the process, this patch also cleans up parts of the highmem sanity check
>> code by removing what has now become a redundant check for banks that entirely
>> overlap with the vmalloc range.
>
> Are you sure of this?  The code that you removed not only checks for
> banks that fall into the vmalloc area, but it also skipp them.  This is
> now lost.
>

I almost missed out on this email...

The check is not quite lost, we still have the following in the 
!CONFIG_HIGHMEM block:

	if (highmem) {
		printk(...);
		continue;
	}

The change is that highmem is now set outside the #ifdef when 
(bank->start >= vmalloc_limit), and therefore the check is truly redundant.

>> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
>> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
>> ---
>>   arch/arm/mm/mmu.c |   19 +------------------
>>   1 file changed, 1 insertion(+), 18 deletions(-)
>>
>> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
>> index f764c03..3d685c6 100644
>> --- a/arch/arm/mm/mmu.c
>> +++ b/arch/arm/mm/mmu.c
>> @@ -901,15 +901,12 @@ void __init sanity_check_meminfo(void)
>>   		struct membank *bank = &meminfo.bank[j];
>>   		*bank = meminfo.bank[i];
>>
>> -		if (bank->start > ULONG_MAX)
>> -			highmem = 1;
>> -
>> -#ifdef CONFIG_HIGHMEM
>>   		if (bank->start >= vmalloc_limit)
>>   			highmem = 1;
>>
>>   		bank->highmem = highmem;
>>
>> +#ifdef CONFIG_HIGHMEM
>>   		/*
>>   		 * Split those memory banks which are partially overlapping
>>   		 * the vmalloc area greatly simplifying things later.
>> @@ -932,8 +929,6 @@ void __init sanity_check_meminfo(void)
>>   			bank->size = vmalloc_limit - bank->start;
>>   		}
>>   #else
>> -		bank->highmem = highmem;
>> -
>>   		/*
>>   		 * Highmem banks not allowed with !CONFIG_HIGHMEM.
>>   		 */
>> @@ -946,18 +941,6 @@ void __init sanity_check_meminfo(void)
>>   		}
>>
>>   		/*
>> -		 * Check whether this memory bank would entirely overlap
>> -		 * the vmalloc area.
>> -		 */
>> -		if (bank->start >= vmalloc_limit) {
>> -			printk(KERN_NOTICE "Ignoring RAM at %.8llx-%.8llx "
>> -			       "(vmalloc region overlap).\n",
>> -			       (unsigned long long)bank->start,
>> -			       (unsigned long long)bank->start + bank->size - 1);
>> -			continue;
>> -		}
>> -
>> -		/*
>>   		 * Check whether this memory bank would partially overlap
>>   		 * the vmalloc area.
>>   		 */
>> --
>> 1.7.9.5
>>

-- 
Thanks
- Cyril
