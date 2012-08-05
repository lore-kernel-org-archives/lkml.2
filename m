Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab2HEOED (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 10:04:03 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40733 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2HEOEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 10:04:01 -0400
Message-ID: <501E7D41.8070303@ti.com>
Date: Sun, 5 Aug 2012 10:03:45 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>, <linux@arm.linux.org.uk>,
        <will.deacon@arm.com>
Subject: Re: [PATCH 02/22] ARM: use late patch framework for phys-virt patching
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-3-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1208040138560.5231@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1208040138560.5231@xanadu.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On 8/4/2012 2:15 AM, Nicolas Pitre wrote:
> On Tue, 31 Jul 2012, Cyril Chemparathy wrote:
>
>> This patch replaces the original physical offset patching implementation
>> with one that uses the newly added patching framework.  In the process, we now
>> unconditionally initialize the __pv_phys_offset and __pv_offset globals in the
>> head.S code.
>
> Why unconditionally initializing those?  There is no reason for that.
>

We could keep this conditional on LPAE, but do you see any specific need 
for keeping it conditional?

>> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
>
> Comments below.
>
>> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
>> index 835898e..d165896 100644
>> --- a/arch/arm/kernel/head.S
>> +++ b/arch/arm/kernel/head.S
> [...]
>>   	.data
>>   	.globl	__pv_phys_offset
>>   	.type	__pv_phys_offset, %object
>>   __pv_phys_offset:
>>   	.long	0
>>   	.size	__pv_phys_offset, . - __pv_phys_offset
>> +
>> +	.globl	__pv_offset
>> +	.type	__pv_offset, %object
>>   __pv_offset:
>>   	.long	0
>> -#endif
>> +	.size	__pv_offset, . - __pv_offset
>
> Please move those to C code.  They aren't of much use in this file
> anymore.  This will allow you to use pphys_addr_t for them as well in
> your subsequent patch. And more importantly get rid of that ugly
> pv_offset_high that you introduced iin another patch.
>

Moving it to C-code caused problems because these get filled in prior to 
BSS being cleared.

We could potentially have this initialized in C with a mystery dummy 
value to prevent it from landing in BSS.  Would that be acceptable?

>> diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
>> index df5e897..39f8fce 100644
>> --- a/arch/arm/kernel/module.c
>> +++ b/arch/arm/kernel/module.c
>> @@ -317,11 +317,6 @@ int module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
>>   					         maps[i].txt_sec->sh_addr,
>>   					         maps[i].txt_sec->sh_size);
>>   #endif
>> -#ifdef CONFIG_ARM_PATCH_PHYS_VIRT
>> -	s = find_mod_section(hdr, sechdrs, ".pv_table");
>> -	if (s)
>> -		fixup_pv_table((void *)s->sh_addr, s->sh_size);
>> -#endif
>>   	s = find_mod_section(hdr, sechdrs, ".patch.table");
>>   	if (s)
>>   		patch_kernel((void *)s->sh_addr, s->sh_size);
>
> The patch_kernel code and its invokation should still be conditional on
> CONFIG_ARM_PATCH_PHYS_VIRT.  This ability may still be configured out
> irrespective of the implementation used.
>

Maybe CONFIG_ARM_PATCH_PHYS_VIRT is not quite appropriate if this is 
used to patch up other things in addition to phys-virt stuff?

I could have this dependent on CONFIG_ARM_INIT_PATCH (or whatever 
nomenclature we chose for this) and have CONFIG_ARM_PATCH_PHYS_VIRT 
depend on it.

>> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
>> index bacb275..13731e3 100644
>> --- a/arch/arm/kernel/vmlinux.lds.S
>> +++ b/arch/arm/kernel/vmlinux.lds.S
>> @@ -162,11 +162,6 @@ SECTIONS
>>   		__smpalt_end = .;
>>   	}
>>   #endif
>> -	.init.pv_table : {
>> -		__pv_table_begin = .;
>> -		*(.pv_table)
>> -		__pv_table_end = .;
>> -	}
>>   	.init.patch_table : {
>>   		__patch_table_begin = .;
>>   		*(.patch.table)
>
> Since you're changing the module ABI,it is important to also modify the
> module vermagic string in asm/module.h to prevent the loading of
> incompatible kernel modules.
>

Absolutely.  Thanks.

>
> Nicolas
>

-- 
Thanks
- Cyril
