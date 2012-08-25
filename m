Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab2HYART (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 20:17:19 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:14047
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756868Ab2HYARQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 20:17:16 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1202hzz8275bhz2dh668h839h944hd25hd2bhf0ah107ah1155h)
X-WSS-ID: 0M9ABGI-02-BJ1-02
X-M-MSG: 
Date: Fri, 24 Aug 2012 19:17:05 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: X86-ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/5] x86: Only direct map addresses that are marked as
 E820_RAM
Message-ID: <20120825001705.GA10812@jshin-Toonie>
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com>
 <1345852516-3125-4-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1345852516-3125-4-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 06:55:14PM -0500, Jacob Shin wrote:
> Currently direct mappings are created for [ 0 to max_low_pfn<<PAGE_SHIFT )
> and [ 4GB to max_pfn<<PAGE_SHIFT ), which may include regions that are not
> backed by actual DRAM. This is fine for holes under 4GB which are covered
> by fixed and variable range MTRRs to be UC. However, we run into trouble
> on higher memory addresses which cannot be covered by MTRRs.
> 
> Our system with 1TB of RAM has an e820 that looks like this:
> 
>  BIOS-e820: [mem 0x0000000000000000-0x00000000000983ff] usable
>  BIOS-e820: [mem 0x0000000000098400-0x000000000009ffff] reserved
>  BIOS-e820: [mem 0x00000000000d0000-0x00000000000fffff] reserved
>  BIOS-e820: [mem 0x0000000000100000-0x00000000c7ebffff] usable
>  BIOS-e820: [mem 0x00000000c7ec0000-0x00000000c7ed7fff] ACPI data
>  BIOS-e820: [mem 0x00000000c7ed8000-0x00000000c7ed9fff] ACPI NVS
>  BIOS-e820: [mem 0x00000000c7eda000-0x00000000c7ffffff] reserved
>  BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
>  BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
>  BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
>  BIOS-e820: [mem 0x0000000100000000-0x000000e037ffffff] usable
>  BIOS-e820: [mem 0x000000e038000000-0x000000fcffffffff] reserved
>  BIOS-e820: [mem 0x0000010000000000-0x0000011ffeffffff] usable
> 
> and so direct mappings are created for huge memory hole between
> 0x000000e038000000 to 0x0000010000000000. Even though the kernel never
> generates memory accesses in that region, since the page tables mark
> them incorrectly as being WB, our (AMD) processor ends up causing a MCE
> while doing some memory bookkeeping/optimizations around that area.
> 
> This patch iterates through e820 and only direct maps ranges that are
> marked as E820_RAM, and keeps track of those pfn ranges. Depending on
> the alignment of E820 ranges, this may possibly result in using smaller
> size (i.e. 4K instead of 2M or 1G) page tables.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  arch/x86/include/asm/page_types.h |    9 +++
>  arch/x86/kernel/setup.c           |  125 +++++++++++++++++++++++++++++--------
>  arch/x86/mm/init.c                |    2 +
>  arch/x86/mm/init_64.c             |    6 +-
>  4 files changed, 112 insertions(+), 30 deletions(-)

> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 751e020..4217fb4 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -115,13 +115,46 @@
>  #include <asm/prom.h>
>  
>  /*
> - * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
> - * The direct mapping extends to max_pfn_mapped, so that we can directly access
> - * apertures, ACPI and other tables without having to play with fixmaps.
> + * max_low_pfn_mapped: highest direct mapped pfn under 4GB
> + * max_pfn_mapped:     highest direct mapped pfn over 4GB
> + *
> + * The direct mapping only covers E820_RAM regions, so the ranges and gaps are
> + * represented by pfn_mapped
>   */
>  unsigned long max_low_pfn_mapped;
>  unsigned long max_pfn_mapped;
>  
> +struct range pfn_mapped[E820_X_MAX];
> +int nr_pfn_mapped;
> +
> +void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
> +{
> +	nr_pfn_mapped = add_range_with_merge(pfn_mapped, E820_X_MAX,
> +					     nr_pfn_mapped, start_pfn, end_pfn);
> +
> +	max_pfn_mapped = max(max_pfn_mapped, end_pfn);
> +
> +	if (end_pfn <= (1UL << (32 - PAGE_SHIFT)))
> +		max_low_pfn_mapped = max(max_low_pfn_mapped, end_pfn);
> +}
> +
> +bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_pfn_mapped; i++)
> +		if ((start_pfn >= pfn_mapped[i].start) &&
> +		    (end_pfn <= pfn_mapped[i].end))
> +			return true;
> +
> +	return false;
> +}
> +
> +bool pfn_is_mapped(unsigned long pfn)
> +{
> +	return pfn_range_is_mapped(pfn, pfn + 1);
> +}
> +
>  #ifdef CONFIG_DMI
>  RESERVE_BRK(dmi_alloc, 65536);
>  #endif
> @@ -296,6 +329,68 @@ static void __init cleanup_highmap(void)
>  }
>  #endif
>  
> +/*
> + * Iterate through E820 memory map and create direct mappings for only E820_RAM
> + * regions. We cannot simply create direct mappings for all pfns from
> + * [0 to max_low_pfn) and [4GB to max_pfn) because of possible memory holes in
> + * high addresses that cannot be marked as UC by fixed/variable range MTRRs.
> + * Depending on the alignment of E820 ranges, this may possibly result in using
> + * smaller size (i.e. 4K instead of 2M or 1G) page tables.
> + */
> +static void __init init_memory(void)
> +{
> +	int i;
> +
> +	init_gbpages();
> +
> +	/* Enable PSE if available */
> +	if (cpu_has_pse)
> +		set_in_cr4(X86_CR4_PSE);
> +
> +	/* Enable PGE if available */
> +	if (cpu_has_pge) {
> +		set_in_cr4(X86_CR4_PGE);
> +		__supported_pte_mask |= _PAGE_GLOBAL;
> +	}
> +
> +	for (i = 0; i < e820.nr_map; i++) {
> +		struct e820entry *ei = &e820.map[i];
> +		u64 start = ei->addr;
> +		u64 end = ei->addr + ei->size;
> +
> +		/* we only map E820_RAM */
> +		if (ei->type != E820_RAM)
> +			continue;
> +
> +		if (end <= ISA_END_ADDRESS)
> +			continue;
> +
> +		if (start <= ISA_END_ADDRESS)
> +			start = 0;
> +#ifdef CONFIG_X86_32
> +		/* on 32 bit, we only map up to max_low_pfn */
> +		if ((start >> PAGE_SHIFT) >= max_low_pfn)
> +			continue;
> +
> +		if ((end >> PAGE_SHIFT) > max_low_pfn)
> +			end = max_low_pfn << PAGE_SHIFT;
> +#endif
> +		/* the ISA range is always mapped regardless of holes */
> +		if (!pfn_range_is_mapped(0, ISA_END_ADDRESS << PAGE_SHIFT) &&

Darn, there is a typo here, should be '>>' not '<<', so sorry about that,
I'll resend in the bit .. my local testing didn't catch that because '<<'
caused the value to be 0.

> +		    start != 0)
> +			init_memory_mapping(0, ISA_END_ADDRESS);
> +
> +		init_memory_mapping(start, end);
> +	}
> +
> +#ifdef CONFIG_X86_64
> +	if (max_pfn > max_low_pfn) {
> +		/* can we preseve max_low_pfn ?*/
> +		max_low_pfn = max_pfn;
> +	}
> +#endif
> +}
> +
>  static void __init reserve_brk(void)
>  {
>  	if (_brk_end > _brk_start)
> @@ -911,30 +1006,8 @@ void __init setup_arch(char **cmdline_p)
>  
>  	setup_real_mode();
>  
> -	init_gbpages();
> -
> -	/* Enable PSE if available */
> -	if (cpu_has_pse)
> -		set_in_cr4(X86_CR4_PSE);
> +	init_memory();
>  
> -	/* Enable PGE if available */
> -	if (cpu_has_pge) {
> -		set_in_cr4(X86_CR4_PGE);
> -		__supported_pte_mask |= _PAGE_GLOBAL;
> -	}
> -
> -	/* max_pfn_mapped is updated here */
> -	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
> -	max_pfn_mapped = max_low_pfn_mapped;
> -
> -#ifdef CONFIG_X86_64
> -	if (max_pfn > max_low_pfn) {
> -		max_pfn_mapped = init_memory_mapping(1UL<<32,
> -						     max_pfn<<PAGE_SHIFT);
> -		/* can we preseve max_low_pfn ?*/
> -		max_low_pfn = max_pfn;
> -	}
> -#endif
>  	memblock.current_limit = get_max_mapped();
>  	dma_contiguous_reserve(0);
>  

