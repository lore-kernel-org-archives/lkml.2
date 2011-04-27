Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693Ab1D0RW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:22:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52373 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759671Ab1D0RW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:22:56 -0400
Message-ID: <4DB850D1.30203@kernel.org>
Date: Wed, 27 Apr 2011 10:22:25 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, efi: Only print warning when desc_size is smaller
 than defined one.
References: <4DB74A50.3080804@kernel.org> <20110427123935.1aacd8b9@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110427123935.1aacd8b9@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DB850DE.0069,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 04:39 AM, Matt Fleming wrote:
> On Tue, 26 Apr 2011 15:42:24 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>>
>> One system get warning:
>> 	Kernel-defined memdesc doesn't match the one from EFI!
>>
>> UEFI spec allows GetMemoryMap() return bigger desc_size and desc_ver for future
>> extension.
>> And desc_size is already used to get offset of next memory entry.
>>
>> Only need to check if desc_size is smaller than defined struct.
>>
>> Also print the size in warning if it happens.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/platform/efi/efi.c |    5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6/arch/x86/platform/efi/efi.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/platform/efi/efi.c
>> +++ linux-2.6/arch/x86/platform/efi/efi.c
>> @@ -448,9 +448,10 @@ void __init efi_init(void)
>>  		printk(KERN_ERR "Could not map the EFI memory map!\n");
>>  	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
>>  
>> -	if (memmap.desc_size != sizeof(efi_memory_desc_t))
>> +	if (memmap.desc_size < sizeof(efi_memory_desc_t))
>>  		printk(KERN_WARNING
>> -		  "Kernel-defined memdesc doesn't match the one from EFI!\n");
>> +		  "Kernel-defined memdesc size is bigger than the one from EFI! %ld > %ld\n",
>> +			 sizeof(efi_memory_desc_t), memmap.desc_size);
> 
> Does it make sense for this to just be a warning? If
> sizeof(efi_memory_desec_t) > sizeof(memmap.desc_size) aren't we going
> to run into some pretty serious problems when we start accessing
> memory descriptors?
> 
> Would it not make more sense for this to be a BUG_ON()? In the unlikely
> event that the kernel's efi_memory_desc_t is too large I really don't
> see how we can recover from that.

Using WARNING is ok here.

1. bootloader aka grub.efi will convert efi memmap to e820 memmap and pass it in boot params.
   and current grub.efi does not compare desc_size and struct size.
2. kernel efi.c will only need to use desc_size when
   a. do_add_efi_memmap when "add_efi_memmap" is appended. it will add more entries in case bootloader miss some.
   b. for print_efi_memmap() debug purpose.

So if that efi_memmap is broken, those code can not be reached.

other case: if efi_memmap is broken or bootloader does not convert it properly. user could specify mem= or memmap= to pass info to boot.
if they can boot, print_efi_memmap could print out the messed up memmap for them.
if you change to BUG_ON, they can not boot anymore.

Thanks

Yinghai Lu
