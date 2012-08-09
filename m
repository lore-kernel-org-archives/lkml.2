Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810Ab2HIWDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 18:03:52 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60580 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759785Ab2HIWDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 18:03:50 -0400
MIME-Version: 1.0
In-Reply-To: <1344547389-4599-2-git-send-email-jacob.shin@amd.com>
References: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
	<1344547389-4599-2-git-send-email-jacob.shin@amd.com>
Date: Thu, 9 Aug 2012 15:03:49 -0700
X-Google-Sender-Auth: QJlFZi-1Ea5NVbn9erEMg2VKCiY
Message-ID: <CAE9FiQXiSq=5VQ5nNELPjDkj0QRjA=sbKfPwAeVDADteY-vdyw@mail.gmail.com>
Subject: Re: [PATCH 1/5] x86: Only direct map addresses that are marked as E820_RAM
From: Yinghai Lu <yinghai@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 2:23 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> Currently direct mappings are created for [ 0 to max_low_pfn<<PAGE_SHIFT )
> and [ 4GB to max_pfn<<PAGE_SHIFT ), which may include regions that are not
> backed by actual DRAM. This is fine for holes under 4GB which are covered
> by fixed and variable range MTRRs to be UC. However, we run into trouble
> on higher memory addresses which cannot be covered by MTRRs.
>
> This patch iterates through e820 and only direct maps ranges that are
> marked as E820_RAM, and keeps track of those pfn ranges.
>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  arch/x86/include/asm/page_types.h |    9 ++++
>  arch/x86/kernel/setup.c           |   87 +++++++++++++++++++++++++++++++++----
>  2 files changed, 88 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
> index e21fdd1..0b8aa52 100644
> --- a/arch/x86/include/asm/page_types.h
> +++ b/arch/x86/include/asm/page_types.h
> @@ -3,6 +3,7 @@
>
>  #include <linux/const.h>
>  #include <linux/types.h>
> +#include <asm/e820.h>
>
>  /* PAGE_SHIFT determines the page size */
>  #define PAGE_SHIFT     12
> @@ -40,12 +41,20 @@
>  #endif /* CONFIG_X86_64 */
>
>  #ifndef __ASSEMBLY__
> +#include <linux/range.h>
>
>  extern int devmem_is_allowed(unsigned long pagenr);
>
>  extern unsigned long max_low_pfn_mapped;
>  extern unsigned long max_pfn_mapped;
>
> +extern struct range pfn_mapped[E820_X_MAX];
> +extern int nr_pfn_mapped;
> +
> +extern void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn);
> +extern int pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn);
> +extern int pfn_is_mapped(unsigned long pfn);
> +
>  static inline phys_addr_t get_max_mapped(void)
>  {
>         return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index f4b9b80..4f26944 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -115,13 +115,55 @@
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
> +       nr_pfn_mapped = add_range_with_merge(pfn_mapped, E820_X_MAX,
> +                                            nr_pfn_mapped, start_pfn, end_pfn);
> +
> +       if (end_pfn > max_pfn_mapped)
> +               max_pfn_mapped = end_pfn;
> +
> +       if ((end_pfn <= (1UL << (32 - PAGE_SHIFT))) &&
> +           (end_pfn > max_low_pfn_mapped))
> +               max_low_pfn_mapped = end_pfn;
> +}
> +
> +int pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn)
> +{
> +       int i;
> +
> +       for (i = 0; i < nr_pfn_mapped; i++)
> +               if ((start_pfn >= pfn_mapped[i].start) &&
> +                   (end_pfn <= pfn_mapped[i].end))
> +                       break;
> +
> +       return i < nr_pfn_mapped;
> +}
> +
> +int pfn_is_mapped(unsigned long pfn)
> +{
> +       int i;
> +
> +       for (i = 0; i < nr_pfn_mapped; i++)
> +               if ((pfn >= pfn_mapped[i].start) &&
> +                   (pfn <  pfn_mapped[i].end))
> +                       break;
> +
> +       return i < nr_pfn_mapped;
> +}
> +
>  #ifdef CONFIG_DMI
>  RESERVE_BRK(dmi_alloc, 65536);
>  #endif
> @@ -673,6 +715,9 @@ early_param("reservelow", parse_reservelow);
>
>  void __init setup_arch(char **cmdline_p)
>  {
> +       int i;
> +       unsigned long init_pfn, pfn;
> +
>  #ifdef CONFIG_X86_32
>         memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
>         visws_early_detect();
> @@ -913,14 +958,40 @@ void __init setup_arch(char **cmdline_p)
>
>         init_gbpages();
>
> -       /* max_pfn_mapped is updated here */
> -       max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
> -       max_pfn_mapped = max_low_pfn_mapped;
> +       init_pfn = max_pfn_mapped;
> +
> +       memset(pfn_mapped, 0, sizeof(pfn_mapped));
> +       nr_pfn_mapped = 0;
> +
> +       add_pfn_range_mapped(0, max_pfn_mapped);
> +
> +       for (i = 0; i < e820.nr_map; i++) {
> +               struct e820entry *ei = &e820.map[i];
> +               u64 start = ei->addr;
> +               u64 end = ei->addr + ei->size;
> +
> +               if (ei->type != E820_RAM)
> +                       continue;
> +
> +               if (end <= (init_pfn << PAGE_SHIFT))
> +                       continue;
> +
> +               if (start < (init_pfn << PAGE_SHIFT))
> +                       start = init_pfn << PAGE_SHIFT;
> +
> +#ifdef CONFIG_X86_32
> +               if ((start >> PAGE_SHIFT) >= max_low_pfn)
> +                       continue;
> +
> +               if ((end >> PAGE_SHIFT) > max_low_pfn)
> +                       end = max_low_pfn << PAGE_SHIFT;
> +#endif
> +               pfn = init_memory_mapping(start, end);
> +               add_pfn_range_mapped(start >> PAGE_SHIFT, pfn);
> +       }

can you put those line in another function?

setup_arch is way too big now.

Also put tj to CC list, because last time I separate page table for
every node upset him.

Thanks

Yinghai Lu

>
>  #ifdef CONFIG_X86_64
>         if (max_pfn > max_low_pfn) {
> -               max_pfn_mapped = init_memory_mapping(1UL<<32,
> -                                                    max_pfn<<PAGE_SHIFT);
>                 /* can we preseve max_low_pfn ?*/
>                 max_low_pfn = max_pfn;
>         }
> --
> 1.7.9.5
>
>
