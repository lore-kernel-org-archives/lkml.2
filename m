Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030274Ab2HIOKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:10:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60480 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262Ab2HIOKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:10:35 -0400
Message-ID: <5023C4CA.4020402@ti.com>
Date: Thu, 9 Aug 2012 10:10:18 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>, <nico@linaro.org>,
        <will.deacon@arm.com>, Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH 03/22] ARM: LPAE: use phys_addr_t on virt <--> phys conversion
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-4-git-send-email-cyril@ti.com> <20120806111413.GB18957@n2100.arm.linux.org.uk>
In-Reply-To: <20120806111413.GB18957@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On 8/6/2012 7:14 AM, Russell King - ARM Linux wrote:
> On Tue, Jul 31, 2012 at 07:04:39PM -0400, Cyril Chemparathy wrote:
>> This patch fixes up the types used when converting back and forth between
>> physical and virtual addresses.
>>
>> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
>> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
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
>
> This as a whole does not fill me with a great amount of enthusiasm,
> because it breaks some of the typechecking that we have here.
>
> The whole point of __phys_to_virt() and __virt_to_phys() is that they work
> on integer types, and warn if you dare to use them with pointers.  Adding
> a cast into them breaks that.
>
> The whole point is that the typecasting is explicitly inside phys_to_virt()
> and virt_to_phys() and not their macro counterparts.
>

The casts in __phys_to_virt() and __virt_to_phys() were necessary to 
widen integer types in case of LPAE without phys/virt patching.

I assume that this specifically is the typecasting that you are 
concerned about.  Would it be better then to convert these to inlines 
then?  That way we could get the typechecking, with proper widening as 
needed.

-- 
Thanks
- Cyril
