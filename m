Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1FHTSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:18:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36203 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab1FHTSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:18:32 -0400
Message-ID: <4DEFCAE0.6050700@kernel.org>
Date: Wed, 08 Jun 2011 12:17:52 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jim Bos <jim876@xs4all.nl>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com> <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com> <4CE1968D.3050706@xs4all.nl> <4DE8DC16.6030308@xs4all.nl> <20110603133351.GA25130@srcf.ucam.org> <4DE8EF13.9030609@xs4all.nl> <BANLkTinWj1LvQLverPTUm9rKEx=+HZUpDA@mail.gmail.com> <4DECFC1C.10801@xs4all.nl> <4DED0394.2090000@gmail.com> <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org> <4DED8752.5070005@kernel.org> <4DEDEA73.7010900@gmail.com> <4DEE17F9.6020503@gmail.com> <4DEEA548.5020405@kernel.org> <4DEFA6E3.6090809@xs4all.nl>
In-Reply-To: <4DEFA6E3.6090809@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DEFCAEF.00D0,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 09:44 AM, Jim Bos wrote:
> On 06/08/2011 12:25 AM, Yinghai Lu wrote:
>> On 06/07/2011 05:22 AM, Maarten Lankhorst wrote:
>>> It seems the error still occurs when calling free_bootmem_late
>>> even if I only reserve blocks that haven't been reserved yet.
>>
>> please check this one.
>>
>> ---
>>  arch/x86/platform/efi/efi.c |    2 +-
>>  include/linux/mm.h          |    2 ++
>>  mm/page_alloc.c             |   32 ++++++++++++++++++++++++++++++++
>>  3 files changed, 35 insertions(+), 1 deletion(-)
>>
>> Index: linux-2.6/arch/x86/platform/efi/efi.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/platform/efi/efi.c
>> +++ linux-2.6/arch/x86/platform/efi/efi.c
>> @@ -368,7 +368,7 @@ static void __init efi_free_boot_service
>>  		    md->type != EFI_BOOT_SERVICES_DATA)
>>  			continue;
>>  
>> -		free_bootmem_late(start, size);
>> +		free_bootmem_late_with_active_regions(start, size);
>>  	}
>>  }
>>  
>> Index: linux-2.6/include/linux/mm.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/mm.h
>> +++ linux-2.6/include/linux/mm.h
>> @@ -1322,6 +1322,8 @@ extern void get_pfn_range_for_nid(unsign
>>  extern unsigned long find_min_pfn_with_active_regions(void);
>>  extern void free_bootmem_with_active_regions(int nid,
>>  						unsigned long max_low_pfn);
>> +void free_bootmem_late_with_active_regions(unsigned long addr,
>> +						unsigned long size);
>>  int add_from_early_node_map(struct range *range, int az,
>>  				   int nr_range, int nid);
>>  u64 __init find_memory_core_early(int nid, u64 size, u64 align,
>> Index: linux-2.6/mm/page_alloc.c
>> ===================================================================
>> --- linux-2.6.orig/mm/page_alloc.c
>> +++ linux-2.6/mm/page_alloc.c
>> @@ -3828,6 +3828,38 @@ void __init free_bootmem_with_active_reg
>>  	}
>>  }
>>  
>> +/**
>> + * free_bootmem_late_with_active_regions - Call free_bootmem_late for each active range
>> + * @addr: starting address of the range
>> + * @size: size of the range in bytes
>> + *
>> + * this function make sure on active regions only
>> + */
>> +void __init free_bootmem_late_with_active_regions(unsigned long addr,
>> +						unsigned long size)
>> +{
>> +	int i;
>> +	int nid = MAX_NUMNODES;
>> +	unsigned long start_pfn = PFN_UP(addr);
>> +	unsigned long end_pfn = PFN_DOWN(addr + size);
>> +
>> +	if (start_pfn >= end_pfn)
>> +		return;
>> +
>> +	for_each_active_range_index_in_nid(i, nid) {
>> +		unsigned long common_start, common_end;
>> +
>> +		common_start = max(start_pfn, early_node_map[i].start_pfn);
>> +		common_end = min(end_pfn, early_node_map[i].end_pfn);
>> +
>> +		if (common_start >= common_end)
>> +			continue;
>> +
>> +		free_bootmem_late(common_start << PAGE_SHIFT,
>> +				  (common_end - common_start) << PAGE_SHIFT);
>> +	}
>> +}
>> +
>>  #ifdef CONFIG_HAVE_MEMBLOCK
>>  /*
>>   * Basic iterator support. Return the last range of PFNs for a node
>>
> 
> I applied this on top of 3.0-rc1 (with offsets), kernels boots but see
> now in dmesg output a new 'BUG: Bad page state in process swapper
> pfn:01800' see attached dmesg output.

that is 24M...

also looks like boot services will overlapped with kernel and ramdisk...

we will reserve boot service again, and later if free boot service range, will free up some kernel or ramdisk range.

[    0.000000] EFI: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
[    0.000000] EFI: mem01: type=7, attr=0xf, range=[0x0000000000008000-0x0000000000075000) (0MB)
[    0.000000] EFI: mem02: type=2, attr=0xf, range=[0x0000000000075000-0x0000000000077000) (0MB)
[    0.000000] EFI: mem03: type=4, attr=0xf, range=[0x0000000000077000-0x0000000000078000) (0MB)
[    0.000000] EFI: mem04: type=3, attr=0xf, range=[0x0000000000078000-0x00000000000a0000) (0MB)
[    0.000000] EFI: mem05: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] EFI: mem06: type=2, attr=0xf, range=[0x0000000001000000-0x0000000001100000) (1MB)
[    0.000000] EFI: mem07: type=4, attr=0xf, range=[0x0000000001100000-0x000000000133a000) (2MB)
[    0.000000] EFI: mem08: type=3, attr=0xf, range=[0x000000000133a000-0x000000000133e000) (0MB)
[    0.000000] EFI: mem09: type=4, attr=0xf, range=[0x000000000133e000-0x0000000001342000) (0MB)
[    0.000000] EFI: mem10: type=3, attr=0xf, range=[0x0000000001342000-0x0000000001345000) (0MB)
[    0.000000] EFI: mem11: type=4, attr=0xf, range=[0x0000000001345000-0x000000000135b000) (0MB)
[    0.000000] EFI: mem12: type=3, attr=0xf, range=[0x000000000135b000-0x000000000135d000) (0MB)
[    0.000000] EFI: mem13: type=4, attr=0xf, range=[0x000000000135d000-0x00000000013c5000) (0MB)
[    0.000000] EFI: mem14: type=3, attr=0xf, range=[0x00000000013c5000-0x00000000013c7000) (0MB)
[    0.000000] EFI: mem15: type=4, attr=0xf, range=[0x00000000013c7000-0x00000000013ca000) (0MB)
[    0.000000] EFI: mem16: type=3, attr=0xf, range=[0x00000000013ca000-0x00000000013d2000) (0MB)
[    0.000000] EFI: mem17: type=4, attr=0xf, range=[0x00000000013d2000-0x00000000013d3000) (0MB)
[    0.000000] EFI: mem18: type=3, attr=0xf, range=[0x00000000013d3000-0x00000000013d4000) (0MB)
[    0.000000] EFI: mem19: type=4, attr=0xf, range=[0x00000000013d4000-0x00000000013d8000) (0MB)
[    0.000000] EFI: mem20: type=3, attr=0xf, range=[0x00000000013d8000-0x00000000013da000) (0MB)
[    0.000000] EFI: mem21: type=4, attr=0xf, range=[0x00000000013da000-0x00000000013dc000) (0MB)
[    0.000000] EFI: mem22: type=3, attr=0xf, range=[0x00000000013dc000-0x00000000013de000) (0MB)
[    0.000000] EFI: mem23: type=4, attr=0xf, range=[0x00000000013de000-0x00000000013df000) (0MB)
[    0.000000] EFI: mem24: type=3, attr=0xf, range=[0x00000000013df000-0x00000000013e0000) (0MB)
[    0.000000] EFI: mem25: type=4, attr=0xf, range=[0x00000000013e0000-0x0000000002334000) (15MB)

we need to revert patch from mjg.

>From 916f676f8dc016103f983c7ec54c18ecdbb6e349 Mon Sep 17 00:00:00 2001
From: Matthew Garrett <mjg@redhat.com>
Date: Wed, 25 May 2011 09:53:13 -0400
Subject: [PATCH] x86, efi: Retain boot service code until after switching to
 virtual mode


Thanks

Yinghai
