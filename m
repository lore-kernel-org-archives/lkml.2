Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022Ab0DHSG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:06:27 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:58989 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932896Ab0DHSG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:06:26 -0400
Message-ID: <4BBE1A6A.60500@oracle.com>
Date: Thu, 08 Apr 2010 11:03:22 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Liang Li <liang.li@windriver.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Yinghai <yinghai.lu@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
       wangchen@cn.fujitsu.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: + x86-fix-handling-of-the-reservetop-boot-option.patch added
 to -mm tree
References: <201004072200.o37M0d19009878@imap1.linux-foundation.org> <4BBD1AA3.4000204@oracle.com> <20100408010558.GA4053@localhost> <4BBD2DD4.1060101@oracle.com> <20100408015353.GB4053@localhost> <4BBD5BEF.3000406@oracle.com> <20100408045945.GB26543@localhost> <4BBD7E52.80507@oracle.com> <20100408085814.GD26543@localhost> <4BBE0E61.5070401@goop.org>
In-Reply-To: <4BBE0E61.5070401@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BBE1AF5.00E5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 10:12 AM, Jeremy Fitzhardinge wrote:
> On 04/08/2010 01:58 AM, Liang Li wrote:
>>>     
>> When linux as vmi/xen/lguest guest OS, kernel call reserve_top_address
>> before start_kernel. It is far before the start_kernel hence far before
>> setup_arch->early_ioremap_init. So it is unsafe to place
>> fixup_early_ioremap inside reserve_top_address. So I think the patch
>> should be:
>>   
> 
> Yes indeed.  That looks better.
> 
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 

good.

Liang please resubmit with clear version changelog.

like

-v2: ...
-v3: move fixup_early_ioremap out of reserve_top_address..

Yinghai

> Thanks,
>     J
> 
>> From 7cefa9a80c4434f2941a7072d39b1f1ffc08a40f Mon Sep 17 00:00:00 2001
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
>>  arch/x86/mm/pgtable_32.c  |    1 +
>>  3 files changed, 17 insertions(+), 0 deletions(-)
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
>> diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
>> index 1a8faf0..26eadaa 100644
>> --- a/arch/x86/mm/pgtable_32.c
>> +++ b/arch/x86/mm/pgtable_32.c
>> @@ -128,6 +128,7 @@ static int __init parse_reservetop(char *arg)
>>  
>>  	address = memparse(arg, &arg);
>>  	reserve_top_address(address);
>> +	fixup_early_ioremap();
>>  	return 0;
>>  }
>>  early_param("reservetop", parse_reservetop);
>>   
> 

