Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0L1DVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 22:21:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:60954 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab0L1DVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 22:21:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,237,1291622400"; 
   d="scan'208";a="691226865"
Subject: Re: [PATCH] ACPI: use ioremap_cache()
From: Shaohua Li <shaohua.li@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Jack Steiner <steiner@sgi.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "tony.luck@gmail.com" <tony.luck@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gbeshers@sgi.com" <gbeshers@sgi.com>
In-Reply-To: <alpine.LFD.2.00.1012170307080.20940@x980>
References: <20101214220932.GA1206@sgi.com>
	 <alpine.LFD.2.00.1012141903210.25387@x980> <20101215024136.GB19601@sgi.com>
	 <alpine.LFD.2.00.1012142302110.4878@x980> <20101215164635.GA27373@sgi.com>
	 <alpine.LFD.2.00.1012151536510.21167@x980>
	 <alpine.LFD.2.00.1012162149370.20940@x980>
	 <alpine.LFD.2.00.1012170307080.20940@x980>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 11:21:00 +0800
Message-ID: <1293506460.10593.43.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 16:08 +0800, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> Although the temporary boot-time ACPI table mappings
> were set up with CPU caching enabled, the permanent table
> mappings and AML run-time region memory accesses were
> set up with ioremap(), which on x86 is a synonym for
> ioremap_nocache().
> 
> Changing this to ioremap_cache() improves performance as
> seen when accessing the tables via acpidump,
> or /sys/firmware/acpi/tables.  It should also improve
> AML run-time performance.
> 
> No change on ia64.
> 
> Reported-by: Jack Steiner <steiner@sgi.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  arch/ia64/include/asm/io.h |    5 +++++
>  drivers/acpi/osl.c         |    6 +++---
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
> index cc8335e..009a7e0 100644
> --- a/arch/ia64/include/asm/io.h
> +++ b/arch/ia64/include/asm/io.h
> @@ -426,6 +426,11 @@ extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size)
>  extern void iounmap (volatile void __iomem *addr);
>  extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size);
>  extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
> +static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
> +{
> +	return ioremap(unsigned long phys_addr, unsigned long size);
> +}
> +
>  
>  /*
>   * String version of IO memory access ops:
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 966fedd..85eba53 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -324,7 +324,7 @@ acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
>  
>  	pg_off = round_down(phys, PAGE_SIZE);
>  	pg_sz = round_up(phys + size, PAGE_SIZE) - pg_off;
> -	virt = ioremap(pg_off, pg_sz);
> +	virt = ioremap_cache(pg_off, pg_sz);
>  	if (!virt) {
>  		kfree(map);
>  		return NULL;
> @@ -646,7 +646,7 @@ acpi_os_read_memory(acpi_physical_address phys_addr, u32 * value, u32 width)
>  	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
>  	rcu_read_unlock();
>  	if (!virt_addr) {
> -		virt_addr = ioremap(phys_addr, size);
> +		virt_addr = ioremap_cache(phys_addr, size);
>  		unmap = 1;
>  	}
>  	if (!value)
> @@ -682,7 +682,7 @@ acpi_os_write_memory(acpi_physical_address phys_addr, u32 value, u32 width)
>  	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
>  	rcu_read_unlock();
>  	if (!virt_addr) {
> -		virt_addr = ioremap(phys_addr, size);
> +		virt_addr = ioremap_cache(phys_addr, size);
>  		unmap = 1;
>  	}
blindly map the range as cache is not ok. for example:
    OperationRegion (RCRB, SystemMemory, 0xFED1C000, 0x4000)
    Field (RCRB, DWordAcc, Lock, Preserve)
    {
        Offset (0x1000),
        Offset (0x3000),
        Offset (0x3404),
        HPAS,   2,
            ,   5,
        HPAE,   1,
        Offset (0x3418),
            ,   1,
        PATD,   1,
        SATD,   1,
        SMBD,   1,
        HDAD,   1,
        A97D,   1,
        Offset (0x341A),
        RP1D,   1,
        RP2D,   1,
        RP3D,   1,
        RP4D,   1,
        RP5D,   1,
        RP6D,   1
    }
RCRB is a memory mapped io. In ICH, it's chipset configuration
registers. this range can't be cached.
I thought we should add a check like
if page is E820_RAM or E820_ACPI then
	cached_map
else
	uncached_map
we have page_is_ram() API which just checks E820_RAM, I thought we can
add a new API to check E820_ACPI.

Thanks,
Shaohua

