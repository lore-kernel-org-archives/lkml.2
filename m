Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2HQKGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:06:23 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:42038 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753607Ab2HQKGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:06:18 -0400
Message-ID: <502E1793.9080605@ti.com>
Date: Fri, 17 Aug 2012 15:36:11 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 05/31] arm64: MMU initialisation
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-6-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-6-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012 11:22 PM, Catalin Marinas wrote:
> This patch contains the initialisation of the memory blocks, MMU
> attributes and the memory map. Only five memory types are defined:
> Device nGnRnE (equivalent to Strongly Ordered), Device nGnRE (classic
> Device memory), Device GRE, Normal Non-cacheable and Normal Cacheable.
> Cache policies are supported via the memory attributes register
> (MAIR_EL1) and only affect the Normal Cacheable mappings.
>
> This patch also adds the SPARSEMEM_VMEMMAP initialisation.
>
> Signed-off-by: Will Deacon<will.deacon@arm.com>
> Signed-off-by: Catalin Marinas<catalin.marinas@arm.com>
> ---

Whats the difference between Device nGnRE and Device GRE ?
Sorry, I haven't gone through the specs yet and hence the
question.

>   arch/arm64/include/asm/memblock.h |   21 ++
>   arch/arm64/mm/init.c              |  416 +++++++++++++++++++++++++++++++++++++
>   arch/arm64/mm/mmu.c               |  395 +++++++++++++++++++++++++++++++++++
>   3 files changed, 832 insertions(+), 0 deletions(-)
>   create mode 100644 arch/arm64/include/asm/memblock.h
>   create mode 100644 arch/arm64/mm/init.c
>   create mode 100644 arch/arm64/mm/mmu.c
>
> diff --git a/arch/arm64/include/asm/memblock.h b/arch/arm64/include/asm/memblock.h
> new file mode 100644
> index 0000000..6afeed2
> --- /dev/null
> +++ b/arch/arm64/include/asm/memblock.h
> @@ -0,0 +1,21 @@
> +/*
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see<http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_MEMBLOCK_H
> +#define __ASM_MEMBLOCK_H
> +
> +extern void arm64_memblock_init(void);
> +
> +#endif
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> new file mode 100644
> index 0000000..c87583d
> --- /dev/null
> +++ b/arch/arm64/mm/init.c
> @@ -0,0 +1,416 @@
> +/*
> + * Based on arch/arm/mm/init.c
> + *
> + * Copyright (C) 1995-2005 Russell King
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see<http://www.gnu.org/licenses/>.
> + */
> +
> +#include<linux/kernel.h>
> +#include<linux/export.h>
> +#include<linux/errno.h>
> +#include<linux/swap.h>
> +#include<linux/init.h>
> +#include<linux/bootmem.h>
> +#include<linux/mman.h>
> +#include<linux/nodemask.h>
> +#include<linux/initrd.h>
> +#include<linux/gfp.h>
> +#include<linux/memblock.h>
> +#include<linux/sort.h>
> +#include<linux/of_fdt.h>
> +
> +#include<asm/prom.h>
> +#include<asm/sections.h>
> +#include<asm/setup.h>
> +#include<asm/sizes.h>
> +#include<asm/tlb.h>
> +
> +#include "mm.h"
> +
> +static unsigned long phys_initrd_start __initdata = 0;
> +static unsigned long phys_initrd_size __initdata = 0;
> +
> +phys_addr_t memstart_addr __read_mostly = 0;
> +
> +void __init early_init_dt_setup_initrd_arch(unsigned long start,
> +					    unsigned long end)
> +{
> +	phys_initrd_start = start;
> +	phys_initrd_size = end - start;
> +}
> +
> +static int __init early_initrd(char *p)
> +{
> +	unsigned long start, size;
> +	char *endp;
> +
> +	start = memparse(p,&endp);
> +	if (*endp == ',') {
> +		size = memparse(endp + 1, NULL);
> +
> +		phys_initrd_start = start;
> +		phys_initrd_size = size;
> +	}
> +	return 0;
> +}
> +early_param("initrd", early_initrd);
> +
> +#define MAX_DMA32_PFN ((4UL * 1024 * 1024 * 1024)>>  PAGE_SHIFT)
> +
> +static void __init zone_sizes_init(unsigned long min, unsigned long max)
> +{
> +	unsigned long zone_size[MAX_NR_ZONES];
> +	unsigned long max_dma32 = min;
> +
> +	memset(zone_size, 0, sizeof(zone_size));
> +
> +	zone_size[0] = max - min;
> +#ifdef CONFIG_ZONE_DMA32
> +	/* 4GB maximum for 32-bit only capable devices */
> +	max_dma32 = min(max, MAX_DMA32_PFN);
> +	zone_size[ZONE_DMA32] = max_dma32 - min;
> +#endif
Do you see need of supporting DMA32 on arm64 SOCs ?

[..]

> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> new file mode 100644
> index 0000000..d2dd438
> --- /dev/null
> +++ b/arch/arm64/mm/mmu.c
> @@ -0,0 +1,395 @@
> +/*
> + * Based on arch/arm/mm/mmu.c
> + *
> + * Copyright (C) 1995-2005 Russell King
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see<http://www.gnu.org/licenses/>.
> + */
> +
> +#include<linux/export.h>
> +#include<linux/kernel.h>
> +#include<linux/errno.h>
> +#include<linux/init.h>
> +#include<linux/mman.h>
> +#include<linux/nodemask.h>
> +#include<linux/memblock.h>
> +#include<linux/fs.h>
> +
> +#include<asm/cputype.h>
> +#include<asm/sections.h>
> +#include<asm/setup.h>
> +#include<asm/sizes.h>
> +#include<asm/tlb.h>
> +#include<asm/mmu_context.h>
> +
> +#include "mm.h"
> +
> +/*
> + * Empty_zero_page is a special page that is used for zero-initialized data
> + * and COW.
> + */
> +struct page *empty_zero_page;
> +EXPORT_SYMBOL(empty_zero_page);
> +
> +pgprot_t pgprot_default;
> +EXPORT_SYMBOL(pgprot_default);
> +
> +static pmdval_t prot_sect_kernel;
> +
> +struct cachepolicy {
> +	const char	policy[16];
> +	u64		mair;
> +	u64		tcr;
> +};
> +
> +static struct cachepolicy cache_policies[] __initdata = {
> +	{
> +		.policy		= "uncached",
> +		.mair		= 0x44,			/* inner, outer non-cacheable */
> +		.tcr		= TCR_IRGN_NC | TCR_ORGN_NC,
> +	}, {
> +		.policy		= "writethrough",
> +		.mair		= 0xaa,			/* inner, outer write-through, read-allocate */
> +		.tcr		= TCR_IRGN_WT | TCR_ORGN_WT,
Is WT supported on arm64?
On the recent ARMv7 processors, I think WT wasn't supported.

Regards
Santosh
