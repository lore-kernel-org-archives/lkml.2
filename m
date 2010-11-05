Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab0KESHC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 14:07:02 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58038 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab0KESHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:07:00 -0400
Message-ID: <4CD447B4.70301@kernel.org>
Date: Fri, 05 Nov 2010 11:06:44 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101013 SUSE/3.0.9 Thunderbird/3.0.9
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: your patch "x86/PCI: host mmconfig detect clean up"
References: <4CD15538020000780002060B@vpn.id2.novell.com> <4CD3160D.7010902@kernel.org> <4CD3E5CB0200007800020B4E@vpn.id2.novell.com>
In-Reply-To: <4CD3E5CB0200007800020B4E@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2010 03:08 AM, Jan Beulich wrote:
>>>> On 04.11.10 at 21:22, Yinghai Lu <yinghai@kernel.org> wrote:
>> Subject: [PATCH] x86/pci: Add mmconf range into e820 for when it is from MSR 
>> with amd faml0h
>>
>> for AMD Fam10h, it we read mmconf from MSR early, we should just trust it
>> because we check it and correct it already.
>>
>> so add it to e820
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/kernel/mmconf-fam10h_64.c |   40 +++++++++++++++++++++----------------
>>  1 file changed, 23 insertions(+), 17 deletions(-)
>>
>> Index: linux-2.6/arch/x86/kernel/mmconf-fam10h_64.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/mmconf-fam10h_64.c
>> +++ linux-2.6/arch/x86/kernel/mmconf-fam10h_64.c
>> @@ -16,6 +16,7 @@
>>  #include <asm/acpi.h>
>>  #include <asm/mmconfig.h>
>>  #include <asm/pci_x86.h>
>> +#include <asm/e820.h>
>>  
>>  struct pci_hostbridge_probe {
>>  	u32 bus;
>> @@ -27,23 +28,26 @@ struct pci_hostbridge_probe {
>>  static u64 __cpuinitdata fam10h_pci_mmconf_base;
>>  static int __cpuinitdata fam10h_pci_mmconf_base_status;
>>  
>> +/* only on BSP */
>> +static void __init_refok e820_add_mmconf_range(int busnbits)
>> +{
>> +	u64 end;
>> +
>> +	end = fam10h_pci_mmconf_base + (1ULL<<(busnbits + 20)) - 1;
>> +	if (!e820_all_mapped(fam10h_pci_mmconf_base, end+1, E820_RESERVED)) {
>> +		printk(KERN_DEBUG "Fam 10h mmconf [%llx, %llx]\n",
>> +				 fam10h_pci_mmconf_base, end);
>> +		e820_add_region(fam10h_pci_mmconf_base, 1ULL<<(busnbits + 20),
>> +				 E820_RESERVED);
>> +		sanitize_e820_map();
> 
> This needs parameters passed, at least up to .37-rc1.

yes, that is in another e820 cleanup series.... it is delayed for a while because of memblock for x86.

> 
> But it's pointless anyway - eventual overlaps won't matter
> anymore since memory got passed to the page allocator
> already. Consequently you really need to make sure there's
> no overlap *before* assigning the region, or (given that the
> range is being placed above TOM2 anyway), you may simply
> ignore the potential for overlaps here.

yes. we trust reading from TOM2 and MMIO split between HT chain register more.

> 
>> +	}
>> +}
>> +
>>  static struct pci_hostbridge_probe pci_probes[] __cpuinitdata = {
>>  	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
>>  	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
>>  };
>>  
>> -static int __cpuinit cmp_range(const void *x1, const void *x2)
>> -{
>> -	const struct range *r1 = x1;
>> -	const struct range *r2 = x2;
>> -	int start1, start2;
>> -
>> -	start1 = r1->start >> 32;
>> -	start2 = r2->start >> 32;
>> -
>> -	return start1 - start2;
>> -}
>> -
> 
> This (and related changes further down) doesn't seem to be
> related to addressing the problem at hand.
> 
>> @@ -191,10 +195,12 @@ void __cpuinit fam10h_check_enable_mmcfg
>>  		/* only trust the one handle 256 buses, if acpi=off */
>>  		if (!acpi_pci_disabled || busnbits >= 8) {
>>  			u64 base;
>> -			base = val & (0xffffULL << 32);
>> +			base = val & (FAM10H_MMIO_CONF_BASE_MASK <<
>> +					FAM10H_MMIO_CONF_BASE_SHIFT);
> 
> 
> Neither is this. I sent a fix for this (and other problems in this file)
> yesterday, and I'm afraid there's another problem here yielding
> the variant you propose incorrect: FAM10H_MMIO_CONF_BASE_MASK
> is being defined as 0xfffffff, thus shifting it by 20 bits will produce
> 0xfffffffffff00000 (sign extended from 0xfff00000) instead of the
> expected 0xfffffff00000. This is also affecting the other two uses of
> this constant (though I admit that it is only a theoretical problem as
> the upper bits are defined as read-as-zero). I'll soon send a fix for
> this and some other problem I found in this code just now.

yes.
FAM10H_MMIO_CONF_BASE_MASK should have ULL

Thanks

	Yinghai
