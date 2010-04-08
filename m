Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab0DHRKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:10:52 -0400
Received: from claw.goop.org ([74.207.240.146]:51108 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833Ab0DHRKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:10:51 -0400
Message-ID: <4BBE0E18.8050903@goop.org>
Date: Thu, 08 Apr 2010 10:10:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Yinghai <yinghai.lu@oracle.com>
CC: Liang Li <liang.li@windriver.com>, Rusty Russell <rusty@rustcorp.com.au>,
       akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
       tglx@linutronix.de, wangchen@cn.fujitsu.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: + x86-fix-handling-of-the-reservetop-boot-option.patch added
 to -mm tree
References: <201004072200.o37M0d19009878@imap1.linux-foundation.org> <4BBD1AA3.4000204@oracle.com> <20100408010558.GA4053@localhost> <4BBD2DD4.1060101@oracle.com> <20100408015353.GB4053@localhost> <4BBD5BEF.3000406@oracle.com> <20100408045945.GB26543@localhost> <4BBD7E52.80507@oracle.com>
In-Reply-To: <4BBD7E52.80507@oracle.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 11:57 PM, Yinghai wrote:
> On 04/07/2010 09:59 PM, Liang Li wrote:
>   
>> On Wed, Apr 07, 2010 at 09:30:39PM -0700, Yinghai wrote:
>>     
>>> On 04/07/2010 06:53 PM, Liang Li wrote:
>>>       
>>>> Does this similar modification like this is more preferred?
>>>>
>>>> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
>>>> index a1dcfa3..30a3e97 100644
>>>> --- a/arch/x86/include/asm/io.h
>>>> +++ b/arch/x86/include/asm/io.h
>>>> @@ -347,6 +347,7 @@ extern void __iomem *early_ioremap(resource_size_t phys_addr,
>>>>  extern void __iomem *early_memremap(resource_size_t phys_addr,
>>>>  				    unsigned long size);
>>>>  extern void early_iounmap(void __iomem *addr, unsigned long size);
>>>> +extern void fixup_early_ioremap(void);
>>>>  
>>>>  #define IO_SPACE_LIMIT 0xffff
>>>>  
>>>> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
>>>> index ea82ef0..fe06296 100644
>>>> --- a/arch/x86/mm/ioremap.c
>>>> +++ b/arch/x86/mm/ioremap.c
>>>> @@ -448,6 +448,23 @@ static inline void __init early_clear_fixmap(enum fixed_addresses idx)
>>>>  static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
>>>>  static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
>>>>  
>>>> +void __init fixup_early_ioremap(void)
>>>> +{
>>>> +	int i;
>>>> +	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
>>>> +		if (prev_map[i])
>>>> +			break;
>>>> +	}
>>>> +
>>>> +	if (i == FIX_BTMAPS_SLOTS)
>>>>         
>>> <
>>>       
>>>> +		WARN_ON(1);
>>>>         
>>> BUG_ON()
>>>       
>>>> +
>>>> +	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
>>>> +		slot_virt[i] = __fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS * i);
>>>> +
>>>>         
>>> need to clear the old PMD, and set new PMD.
>>>
>>> so you can clear old PMD and call early_ioremap_init() in fixup_early_ioremap()
>>>       
>> Call early_ioremap_init will do the update PMD work. So the preferred
>> patch would be:
>> ---------------
>> From 61fe7a116cbbf6eef98a49b88ed5861ed9ebd32d Mon Sep 17 00:00:00 2001
>> From: Liang Li <liang.li@windriver.com>
>> Date: Mon, 22 Mar 2010 18:38:14 +0800
>> Subject: [PATCH] x86: let 'reservetop' functioning right
>>
>> When specify 'reservetop=0xbadc0de' kernel parameter, the kernel will
>> stop booting due to a early_ioremap bug that relate to commit 8827247ff.
>>
>> The root cause of boot failure problem is the value of 'slot_virt[i]'
>> was initialized in setup_arch->early_ioremap_init. But later in
>> setup_arch, the function 'parse_early_param' will modify 'FIXADDR_TOP'
>> when 'reservetop=0xbadc0de' being specified.
>>
>> When reservetop being handled then FIXADDR_TOP get adjusted, Hence check
>> prev_map then re-initialize slot_virt and PMD based on new FIXADDR_TOP.
>>
>> Signed-off-by: Liang Li <liang.li@windriver.com>
>> Cc: Wang Chen <wangchen@cn.fujitsu.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>  arch/x86/include/asm/io.h |    1 +
>>  arch/x86/mm/ioremap.c     |   15 +++++++++++++++
>>  arch/x86/mm/pgtable.c     |    2 ++
>>  3 files changed, 18 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
>> index a1dcfa3..30a3e97 100644
>> --- a/arch/x86/include/asm/io.h
>> +++ b/arch/x86/include/asm/io.h
>> @@ -347,6 +347,7 @@ extern void __iomem *early_ioremap(resource_size_t phys_addr,
>>  extern void __iomem *early_memremap(resource_size_t phys_addr,
>>  				    unsigned long size);
>>  extern void early_iounmap(void __iomem *addr, unsigned long size);
>> +extern void fixup_early_ioremap(void);
>>  
>>  #define IO_SPACE_LIMIT 0xffff
>>  
>> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
>> index 5eb1ba7..e4ab706 100644
>> --- a/arch/x86/mm/ioremap.c
>> +++ b/arch/x86/mm/ioremap.c
>> @@ -448,6 +448,21 @@ static inline void __init early_clear_fixmap(enum fixed_addresses idx)
>>  static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
>>  static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
>>  
>> +void __init fixup_early_ioremap(void)
>> +{
>> +	int i;
>> +	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
>> +		if (prev_map[i])
>> +			break;
>> +	}
>> +
>> +	if (i < FIX_BTMAPS_SLOTS)
>> +		BUG_ON(1);
>> +
>> +	early_ioremap_init();
>> +	return;
>> +}
>> +
>>  static int __init check_early_ioremap_leak(void)
>>  {
>>  	int count = 0;
>> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
>> index 5c4ee42..ea4d54c 100644
>> --- a/arch/x86/mm/pgtable.c
>> +++ b/arch/x86/mm/pgtable.c
>> @@ -4,6 +4,7 @@
>>  #include <asm/pgtable.h>
>>  #include <asm/tlb.h>
>>  #include <asm/fixmap.h>
>> +#include <asm/io.h>
>>  
>>  #define PGALLOC_GFP GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO
>>  
>> @@ -351,6 +352,7 @@ void __init reserve_top_address(unsigned long reserve)
>>  	printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
>>  	       (int)-reserve);
>>  	__FIXADDR_TOP = -reserve - PAGE_SIZE;
>> +	fixup_early_ioremap();
>>  #endif
>>  }
>>  
>> -----------
>> Acceptable?
>>
>>     
> good to me.
>
> may need to ask xen/lguest/vmi related to check that too.
>
> arch/x86/kernel/vmi_32.c:       reserve_top_address(-vmi_rom->virtual_top);
> arch/x86/lguest/boot.c: reserve_top_address(lguest_data.reserve_mem);
> arch/x86/mm/pgtable_32.c:       reserve_top_address(address);
> arch/x86/xen/mmu.c:     reserve_top_address(-top);
>   

This looks troublesome for us.  We're calling reserve_top_address() very
early - before start_kernel - to make sure the address space for the
hypervisor has been reserved.  Calling fixup_early_ioremap() will
probably fail horribly.

Can you make it so that it only calls fixup_early_ioremap() if ioremap
init has already happened?

Also, do we actually need reservetop= any more.  It looks like Zach
added it for VMI, but VMI has been deprecated.  Are there any other use
cases?

Thanks,
     J
