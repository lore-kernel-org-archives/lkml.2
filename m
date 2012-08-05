Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2HEOF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 10:05:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40780 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab2HEOF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 10:05:29 -0400
Message-ID: <501E7D97.7070007@ti.com>
Date: Sun, 5 Aug 2012 10:05:11 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>, <linux@arm.linux.org.uk>,
        <will.deacon@arm.com>, Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH 03/22] ARM: LPAE: use phys_addr_t on virt <--> phys conversion
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-4-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1208040222110.5231@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1208040222110.5231@xanadu.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/2012 2:24 AM, Nicolas Pitre wrote:
> On Tue, 31 Jul 2012, Cyril Chemparathy wrote:
>
>> This patch fixes up the types used when converting back and forth between
>> physical and virtual addresses.
>>
>> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
>> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
>
> Did you verify that this didn't introduce any compilation warning when
> compiling for non LPAE?  If so and there were no warnings then...
>

Yes.  This series has been tested on vanilla ARMv7 Cortex-A8 non-LPAE 
hardware as well.

> Acked-by: Nicolas Pitre <nico@linaro.org>
>
>
>> ---
>>   arch/arm/include/asm/memory.h |   17 +++++++++++------
>>   1 file changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
>> index 01c710d..4a0108f 100644
>> --- a/arch/arm/include/asm/memory.h
>> +++ b/arch/arm/include/asm/memory.h
>> @@ -157,22 +157,27 @@ extern unsigned long __pv_phys_offset;
>>
>>   extern unsigned long __pv_offset;
>>
>> -static inline unsigned long __virt_to_phys(unsigned long x)
>> +static inline phys_addr_t __virt_to_phys(unsigned long x)
>>   {
>>   	unsigned long t;
>>   	early_patch_imm8(x, t, "add", __pv_offset);
>>   	return t;
>>   }
>>
>> -static inline unsigned long __phys_to_virt(unsigned long x)
>> +static inline unsigned long __phys_to_virt(phys_addr_t x)
>>   {
>>   	unsigned long t;
>>   	early_patch_imm8(x, t, "sub", __pv_offset);
>>   	return t;
>>   }
>>   #else
>> -#define __virt_to_phys(x)	((x) - PAGE_OFFSET + PHYS_OFFSET)
>> -#define __phys_to_virt(x)	((x) - PHYS_OFFSET + PAGE_OFFSET)
>> +
>> +#define __virt_to_phys(x)		\
>> +	((phys_addr_t)(x) - PAGE_OFFSET + PHYS_OFFSET)
>> +
>> +#define __phys_to_virt(x)		\
>> +	((unsigned long)((phys_addr_t)(x) - PHYS_OFFSET + PAGE_OFFSET))
>> +
>>   #endif
>>   #endif
>>
>> @@ -207,14 +212,14 @@ static inline phys_addr_t virt_to_phys(const volatile void *x)
>>
>>   static inline void *phys_to_virt(phys_addr_t x)
>>   {
>> -	return (void *)(__phys_to_virt((unsigned long)(x)));
>> +	return (void *)__phys_to_virt(x);
>>   }
>>
>>   /*
>>    * Drivers should NOT use these either.
>>    */
>>   #define __pa(x)			__virt_to_phys((unsigned long)(x))
>> -#define __va(x)			((void *)__phys_to_virt((unsigned long)(x)))
>> +#define __va(x)			((void *)__phys_to_virt((phys_addr_t)(x)))
>>   #define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
>>
>>   /*
>> --
>> 1.7.9.5
>>

-- 
Thanks
- Cyril
