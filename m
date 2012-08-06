Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab2HFNaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:30:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42801 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab2HFNaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:30:12 -0400
Message-ID: <501FC6D8.3010900@ti.com>
Date: Mon, 6 Aug 2012 09:30:00 -0400
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

Understood.  Thanks.  The casts were needed to upgrade to 64-bit before 
arithmetic.  We should convert the non-patch __phys_to_virt and 
__virt_to_phys to inlines to keep the typechecking intact.

> The whole point is that the typecasting is explicitly inside phys_to_virt()
> and virt_to_phys() and not their macro counterparts.
>
> Secondly, are you sure that this patch is correct on its own?  You're
> passing a u64 into assembly only expecting a 32-bit register.  Have you
> checked it does the right thing with a 64-bit phys_addr_t on both LE
> and BE?
>

We should explicitly pass in the lower order bits here, at least until 
the next patch in the series fixes things up for 64-bit.  Thanks.

We've tested with 64-bit and 32-bit phys_addr_t, but only on LE.  Thanks 
for pointing this out, we'll figure out a way to run BE as well.

-- 
Thanks
- Cyril
