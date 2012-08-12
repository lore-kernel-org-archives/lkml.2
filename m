Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab2HLSOP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 14:14:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42745 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab2HLSOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 14:14:14 -0400
Message-ID: <5027F265.4030501@ti.com>
Date: Sun, 12 Aug 2012 14:13:57 -0400
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
Subject: Re: [PATCH v2 01/22] ARM: add mechanism for late code patching
References: <1344648306-15619-1-git-send-email-cyril@ti.com> <1344648306-15619-2-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1208112220400.5231@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1208112220400.5231@xanadu.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/12 22:22, Nicolas Pitre wrote:
> On Fri, 10 Aug 2012, Cyril Chemparathy wrote:
>
>> The original phys_to_virt/virt_to_phys patching implementation relied on early
>> patching prior to MMU initialization.  On PAE systems running out of >4G
>> address space, this would have entailed an additional round of patching after
>> switching over to the high address space.
>>
>> The approach implemented here conceptually extends the original PHYS_OFFSET
>> patching implementation with the introduction of "early" patch stubs.  Early
>> patch code is required to be functional out of the box, even before the patch
>> is applied.  This is implemented by inserting functional (but inefficient)
>> load code into the .runtime.patch.code init section.  Having functional code
>> out of the box then allows us to defer the init time patch application until
>> later in the init sequence.
>>
>> In addition to fitting better with our need for physical address-space
>> switch-over, this implementation should be somewhat more extensible by virtue
>> of its more readable (and hackable) C implementation.  This should prove
>> useful for other similar init time specialization needs, especially in light
>> of our multi-platform kernel initiative.
>>
>> This code has been boot tested in both ARM and Thumb-2 modes on an ARMv7
>> (Cortex-A8) device.
>>
>> Note: the obtuse use of stringified symbols in patch_stub() and
>> early_patch_stub() is intentional.  Theoretically this should have been
>> accomplished with formal operands passed into the asm block, but this requires
>> the use of the 'c' modifier for instantiating the long (e.g. .long %c0).
>> However, the 'c' modifier has been found to ICE certain versions of GCC, and
>> therefore we resort to stringified symbols here.
>>
>> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
>
> Reviewed-by: Nicolas Pitre <nico@linaro.org>
>

Thanks.

I've been looking at the compiler emitted code, and had to make a couple 
of changes to keep things streamlined...

[...]
>> +#define early_patch_imm8(insn, to, from, sym, offset)			\
>> +	early_patch_stub(PATCH_IMM8,					\
>> +			 /* code */					\
>> +			 "ldr	%0, =" __stringify(sym + offset) "\n"	\
>> +			 "ldr	%0, [%0]\n"				\
>> +			 insn " %0, %1, %0\n",				\
>> +			 /* patch_data */				\
>> +			 ".long " __stringify(sym + offset) "\n"	\
>> +			 insn " %0, %1, %2\n",				\
>> +			 : "=&r" (to)					\
>> +			 : "r" (from), "I" (__IMM8), "m" (sym)		\
>> +			 : "cc")

First, the "m" operand modifier for "sym" forces GCC to emit code to 
load the address of the symbol into a register.  I've replaced this with 
"i" (&(sym) to make that go away.  With this, the emitted code doesn't 
contain any such unexpected nonsense.

Second, marking the "to" operand as early clobber makes the compiler 
generate horrid register moves around the assembly block, even when it 
has registers to spare.  Simply adding a temporary variable does a much 
much better job, especially since this temporary register is used only 
in the patched-out "early" code.

Thanks
-- Cyril.
