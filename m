Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1FNSL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:11:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61893 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1FNSLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:11:24 -0400
Message-ID: <4DF7A41F.6080606@kernel.org>
Date: Tue, 14 Jun 2011 11:10:39 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] x86, efi: Do not reserve boot services regions within
 reserved areas
References: <4DF78A22.8060405@gmail.com>
In-Reply-To: <4DF78A22.8060405@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DF7A448.0140,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2011 09:19 AM, Maarten Lankhorst wrote:
> Commit 916f676f8dc started reserving boot service code since some systems
> require you to keep that code around until SetVirtualAddressMap is called.
> 
> However, in some cases those areas will overlap with reserved regions.
> The proper medium-term fix is to fix the bootloader to prevent the
> conflicts from occurring by moving the kernel to a better position,
> but the kernel should check for this possibility, and only reserve regions
> which can be reserved.
> 
> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> 
> ---
> 
> V2: Removed some printks and a unrelated change
> 
> diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
> index 19ae14b..0cd3800 100644
> --- a/arch/x86/include/asm/memblock.h
> +++ b/arch/x86/include/asm/memblock.h
> @@ -4,7 +4,6 @@
>  #define ARCH_DISCARD_MEMBLOCK
>  
>  u64 memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align);
> -void memblock_x86_to_bootmem(u64 start, u64 end);
>  
>  void memblock_x86_reserve_range(u64 start, u64 end, char *name);
>  void memblock_x86_free_range(u64 start, u64 end);
> @@ -19,5 +18,6 @@ u64 memblock_x86_hole_size(u64 start, u64 end);
>  u64 memblock_x86_find_in_range_node(int nid, u64 start, u64 end, u64 size, u64 align);
>  u64 memblock_x86_free_memory_in_range(u64 addr, u64 limit);
>  u64 memblock_x86_memory_in_range(u64 addr, u64 limit);
> +bool memblock_x86_check_reserved_size(u64 *addrp, u64 *sizep, u64 align);
>  
>  #endif
> diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
> index aa11693..992da5e 100644
> --- a/arch/x86/mm/memblock.c
> +++ b/arch/x86/mm/memblock.c
> @@ -8,7 +8,7 @@
>  #include <linux/range.h>
>  
>  /* Check for already reserved areas */
> -static bool __init check_with_memblock_reserved_size(u64 *addrp, u64 *sizep, u64 align)
> +bool __init memblock_x86_check_reserved_size(u64 *addrp, u64 *sizep, u64 align)
>  {
>  	struct memblock_region *r;
>  	u64 addr = *addrp, last;
> @@ -59,7 +59,7 @@ u64 __init memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align)
>  		if (addr >= ei_last)
>  			continue;
>  		*sizep = ei_last - addr;
> -		while (check_with_memblock_reserved_size(&addr, sizep, align))
> +		while (memblock_x86_check_reserved_size(&addr, sizep, align))
>  			;
>  
>  		if (*sizep)
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 0d3a4fa..b8afde4 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -310,14 +310,30 @@ void __init efi_reserve_boot_services(void)
>  
>  	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
>  		efi_memory_desc_t *md = p;
> -		unsigned long long start = md->phys_addr;
> -		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
> +		u64 start = md->phys_addr;
> +		u64 size = md->num_pages << EFI_PAGE_SHIFT;
>  
>  		if (md->type != EFI_BOOT_SERVICES_CODE &&
>  		    md->type != EFI_BOOT_SERVICES_DATA)
>  			continue;
> -
> -		memblock_x86_reserve_range(start, start + size, "EFI Boot");
> +		/* Only reserve where possible:
> +		 * - Not within any already allocated areas
> +		 * - Not over any memory area (really needed, if above?)
> +		 * - Not within any part of the kernel
> +		 * - Not the bios reserved area
> +		*/
> +		if ((start+size >= virt_to_phys(_text)
> +				&& start <= virt_to_phys(_end)) ||
> +			!e820_all_mapped(start, start+size, E820_RAM) ||
> +			memblock_x86_check_reserved_size(&start, &size,
> +							1<<EFI_PAGE_SHIFT)) {
> +			/* Could not reserve, skip it */
> +			md->num_pages = 0;
> +			memblock_dbg(PFX "Could not reserve boot area "
> +				"[0x%llx-0x%llx)\n", start, start+size);

how about partial overlapping?

> +		} else
> +			memblock_x86_reserve_range(start, start+size,
> +							"EFI Boot");
>  	}
>  }
>  
> @@ -334,6 +350,10 @@ static void __init efi_free_boot_services(void)
>  		    md->type != EFI_BOOT_SERVICES_DATA)
>  			continue;
>  
> +		/* Could not reserve boot area */
> +		if (!size)
> +			continue;
> +
>  		free_bootmem_late(start, size);
>  	}
>  }
> 

