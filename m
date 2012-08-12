Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab2HLX2L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 19:28:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60220 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab2HLX2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 19:28:09 -0400
Message-ID: <50283BF5.1050908@ti.com>
Date: Sun, 12 Aug 2012 19:27:49 -0400
From: Cyril Chemparathy <cyril@ti.com>
Reply-To: <cyril@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>,
        <grant.likely@secretlab.ca>, <linux@arm.linux.org.uk>,
        <will.deacon@arm.com>
Subject: Re: [PATCH v2 05/22] ARM: LPAE: support 64-bit virt_to_phys patching
References: <1344648306-15619-1-git-send-email-cyril@ti.com> <1344648306-15619-6-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1208112316560.5231@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1208112316560.5231@xanadu.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/12 23:39, Nicolas Pitre wrote:
> On Fri, 10 Aug 2012, Cyril Chemparathy wrote:
>
>> This patch adds support for 64-bit physical addresses in virt_to_phys()
>> patching.  This does not do real 64-bit add/sub, but instead patches in the
>> upper 32-bits of the phys_offset directly into the output of virt_to_phys.
>>
>> There is no corresponding change on the phys_to_virt() side, because
>> computations on the upper 32-bits would be discarded anyway.
>>
>> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
>> ---
>>   arch/arm/include/asm/memory.h |   22 ++++++++++++++++++----
>>   arch/arm/kernel/head.S        |    4 ++++
>>   arch/arm/kernel/setup.c       |    2 +-
>>   3 files changed, 23 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
>> index 81e1714..dc5fbf3 100644
>> --- a/arch/arm/include/asm/memory.h
>> +++ b/arch/arm/include/asm/memory.h
>> @@ -154,14 +154,28 @@
>>   #ifdef CONFIG_ARM_PATCH_PHYS_VIRT
>>
>>   extern unsigned long	__pv_offset;
>> -extern unsigned long	__pv_phys_offset;
>> +extern phys_addr_t	__pv_phys_offset;
>>   #define PHYS_OFFSET	__virt_to_phys(PAGE_OFFSET)
>>
>>   static inline phys_addr_t __virt_to_phys(unsigned long x)
>>   {
>> -	unsigned long t;
>> -	early_patch_imm8("add", t, x, __pv_offset, 0);
>> -	return t;
>> +	unsigned long tlo, thi;
>> +
>> +	early_patch_imm8("add", tlo, x, __pv_offset, 0);
>> +
>> +#ifdef CONFIG_ARM_LPAE
>> +	/*
>> +	 * On LPAE, we do not _need_ to do 64-bit arithmetic because the high
>> +	 * order 32 bits are never changed by the phys-virt offset.  We simply
>> +	 * patch in the high order physical address bits instead.
>> +	 */
>> +#ifdef __ARMEB__
>> +	early_patch_imm8_mov("mov", thi, __pv_phys_offset, 0);
>> +#else
>> +	early_patch_imm8_mov("mov", thi, __pv_phys_offset, 4);
>> +#endif
>> +#endif
>> +	return (u64)tlo | (u64)thi << 32;
>>   }
>
> Hmmm...  I'm afraid this is going to be suboptimal when LPAE is not
> selected.
>

I understand your concern, but I don't see the sub-optimality.  I tested 
the following function with GCC versions 4.3.3 and 4.7.  This is after 
the other changes that I mentioned in my previous email, but with the 
__virt_to_phys() code itself unchanged:

phys_addr_t ____test_virt_to_phys(unsigned long addr)
{
         return __virt_to_phys(addr);
}

The resulting code in both cases looks like:

<____test_virt_to_phys>:
	b       c04f0528
	bx      lr

[the branch of course gets patched to an add]

> First of all, you do not need to cast tlo to a u64 in the return value.
>

True enough.

> Then, I'm not sure if the compiler is smart enough to see that the
> returned value is a phys_addr_t which can be a u32, and in this case the
> (u64)thi << 32 is going to be truncated right away, and therefore there
> is no point in emiting the corresponding instructions.
>

In this case, it appears to be smart enough.  However, I agree that 
relying on compiler smarts is probably not the best thing for us to do.

> Furthermore, if LPAE is not defined, then thi never gets initialized and
> should produce a warning. Did you test compilation of the code with LPAE
> turned off?
>

Sure.  One of our test platforms is non-LPAE.  The compiler does not 
produce warnings on this, and this is consistent across both compiler 
versions.

> I'd prefer something like this where more stuff is validated by the
> compiler:
>
> static inline phys_addr_t __virt_to_phys(unsigned long x)
> {
> 	unsigned long tlo, thi;
> 	phys_addr_t ret;
>
> 	early_patch_imm8("add", tlo, x, __pv_offset, 0);
> 	ret = tlo;
>
> 	if (sizeof(phys_addr_t) > 4) {
> #ifdef __ARMEB__
> 		early_patch_imm8_mov("mov", thi, __pv_phys_offset, 0);
> #else
> 		early_patch_imm8_mov("mov", thi, __pv_phys_offset, 4);
> #endif
> 		ret |= ((u64)thi) << 32;
> 	}
>
> 	return ret);
> }
>
> This should let the compiler optimize things whether LPAE is enabledor
> not while validating both cases.
>

Agreed on the principal, but more below...


I've meanwhile been chasing down another problem - the code generated 
for the LPAE case.  The original code resulted in the following:

<____test_virt_to_phys>:
         mov     r2, #0
         b       c01bc800	# patch: add r1, r0, __pv_offset
         b       c01bc810	# patch: mov r0, __phys_offset_high
         orr     r2, r2, r1
         mov     r3, r0
         mov     r1, r3
         mov     r0, r2
         bx      lr

Yikes! This code does a bunch of futile register shuffling and a 
pointless or, all in the name of generating the result in a 64-bit 
register-pair from the 32-bit halves.

In order to get past this, I tried adding operand qualifiers (R = upper 
32-bits, Q = lower 32-bits) in the patch macros, in the hope that 
treating these as native 64-bit register pairs would eliminate the need 
to shuffle them around after the inline assembly blocks.  This then 
allows us to implement __virt_to_phys() as follows:

static inline phys_addr_t __virt_to_phys(unsigned long x)
{
         phys_addr_t t;

         if (sizeof(t) == 4) {
		t = x;
                 early_patch_imm8("add", t, "", t, __pv_offset, 0);
                 return t;
         }

         /*
          * On LPAE, we do not _need_ to do 64-bit arithmetic because
          * the high order 32 bits are never changed by the phys-virt
          * offset.  We simply patch in the high order physical address
          * bits instead.
          *
          * Note: the mov _must_ be first here.  From the compiler's
          * perspective, this is the initializer for the variable. The
          * mov itself initializes only the upper half. The subsequent
          * add treats t as a read/write operand and initializes the
          * lower half.
          */
#ifdef __ARMEB__
         early_patch_imm8_mov("mov", t, "R", __pv_phys_offset, 0);
#else
         early_patch_imm8_mov("mov", t, "R", __pv_phys_offset, 4);
#endif
         early_patch_imm8("add", t, "Q", x, __pv_offset, 0);

         return t;
}

With this, we get significantly better looking generated code:

<____test_virt_to_phys>:
	b       c01d519c	# patch: mov r3, __phys_offset_high
	b       c01d51ac	# patch: add r2, r0, __phys_offset_high
	mov     r0, r2
	mov     r1, r3
	bx      lr

This is about as far along as I've been able to proceed.  I still 
haven't figured out a way to get it to patch in place without an extra 
register pair.

Overall, this is still a bit too kludgy for my liking.  In particular, 
the read/write operand forces add/sub/... users to initialize the result 
variable.  I am currently leaning towards adding native support for 
64-bit operations in the runtime patch code, instead of having to hack 
around it with 32-bit primitives.  Better ideas, any one?

Thanks
-- Cyril.
