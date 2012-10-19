Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406Ab2JSQYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:24:42 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:36924 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2JSQYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:24:40 -0400
X-IronPort-AV: E=Sophos;i="4.80,613,1344211200"; 
   d="scan'208";a="15281208"
Date: Fri, 19 Oct 2012 17:24:14 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/19] x86, mm: setup page table in top-down
In-Reply-To: <1350593430-24470-10-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.02.1210191714330.2689@kaball.uk.xensource.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org> <1350593430-24470-10-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Yinghai Lu wrote:
> Get pgt_buf early from BRK, and use it to map PMD_SIZE from top at first.
> then use mapped pages to map more range below, and keep looping until
> all pages get mapped.
> 
> alloc_low_page will use page from BRK at first, after that buff is used up,
> will use memblock to find and reserve page for page table usage.
> 
> At last we could get rid of calculation and find early pgt related code.
> 
> -v2: update to after fix_xen change,
>      also use MACRO for initial pgt_buf size and add comments with it.
> -v3: skip big reserved range in memblock.reserved near end.
> -v4: don't need fix_xen change now.
> 
> Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

The series is starting to get in good shape!
I tested it on a 2G and an 8G VM and it seems to be working fine.


The most important thing to do now is testing it on different machines
(with and without xen) and writing better commit messages.
We can help you with the testing but you really need to write better
docs.

In particular you should state in clear letters that alloc_low_page is
always going to return a page that is already mapped. You should write
it both in the commit message and in the code as a comment.
This is particularly important because it is going to become part of the
interface between the common x86 code and the other x86 subsystems like
Xen.

Also, it wouldn't hurt to explain the overall design at the beginning of
the series: I shouldn't have to read your code to understand what you
are doing. I should read the description of the patch, understand what
you are doing, then go and check if the code actually does what you say
it does.



>  arch/x86/include/asm/page_types.h |    1 +
>  arch/x86/include/asm/pgtable.h    |    1 +
>  arch/x86/kernel/setup.c           |    3 +
>  arch/x86/mm/init.c                |  207 ++++++++++--------------------------
>  arch/x86/mm/init_32.c             |   17 +++-
>  arch/x86/mm/init_64.c             |   17 +++-
>  6 files changed, 91 insertions(+), 155 deletions(-)
> 
> diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
> index 54c9787..9f6f3e6 100644
> --- a/arch/x86/include/asm/page_types.h
> +++ b/arch/x86/include/asm/page_types.h
> @@ -45,6 +45,7 @@ extern int devmem_is_allowed(unsigned long pagenr);
> 
>  extern unsigned long max_low_pfn_mapped;
>  extern unsigned long max_pfn_mapped;
> +extern unsigned long min_pfn_mapped;
> 
>  static inline phys_addr_t get_max_mapped(void)
>  {
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index dd1a888..6991a3e 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -603,6 +603,7 @@ static inline int pgd_none(pgd_t pgd)
> 
>  extern int direct_gbpages;
>  void init_mem_mapping(void);
> +void early_alloc_pgt_buf(void);
> 
>  /* local pte updates need not use xchg for locking */
>  static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index e72e4c6..73cb7ba 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -124,6 +124,7 @@
>   */
>  unsigned long max_low_pfn_mapped;
>  unsigned long max_pfn_mapped;
> +unsigned long min_pfn_mapped;
> 
>  #ifdef CONFIG_DMI
>  RESERVE_BRK(dmi_alloc, 65536);
> @@ -897,6 +898,8 @@ void __init setup_arch(char **cmdline_p)
> 
>         reserve_ibft_region();
> 
> +       early_alloc_pgt_buf();
> +
>         /*
>          * Need to conclude brk, before memblock_x86_fill()
>          *  it could use memblock_find_in_range, could overlap with
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index dbb2916..9ff29c1 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -21,6 +21,21 @@ unsigned long __initdata pgt_buf_start;
>  unsigned long __meminitdata pgt_buf_end;
>  unsigned long __meminitdata pgt_buf_top;
> 
> +/* need 4 4k for initial PMD_SIZE, 4k for 0-ISA_END_ADDRESS */
> +#define INIT_PGT_BUF_SIZE      (5 * PAGE_SIZE)
> +RESERVE_BRK(early_pgt_alloc, INIT_PGT_BUF_SIZE);
> +void  __init early_alloc_pgt_buf(void)
> +{
> +       unsigned long tables = INIT_PGT_BUF_SIZE;
> +       phys_addr_t base;
> +
> +       base = __pa(extend_brk(tables, PAGE_SIZE));
> +
> +       pgt_buf_start = base >> PAGE_SHIFT;
> +       pgt_buf_end = pgt_buf_start;
> +       pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
> +}
> +
>  int after_bootmem;
> 
>  int direct_gbpages
> @@ -228,105 +243,6 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
>         return nr_range;
>  }
> 
> -static unsigned long __init calculate_table_space_size(unsigned long start,
> -                                         unsigned long end)
> -{
> -       unsigned long puds = 0, pmds = 0, ptes = 0, tables;
> -       struct map_range mr[NR_RANGE_MR];
> -       int nr_range, i;
> -
> -       pr_info("calculate_table_space_size: [mem %#010lx-%#010lx]\n",
> -              start, end - 1);
> -
> -       memset(mr, 0, sizeof(mr));
> -       nr_range = 0;
> -       nr_range = split_mem_range(mr, nr_range, start, end);
> -
> -       for (i = 0; i < nr_range; i++) {
> -               unsigned long range, extra;
> -
> -               range = mr[i].end - mr[i].start;
> -               puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
> -
> -               if (mr[i].page_size_mask & (1 << PG_LEVEL_1G)) {
> -                       extra = range - ((range >> PUD_SHIFT) << PUD_SHIFT);
> -                       pmds += (extra + PMD_SIZE - 1) >> PMD_SHIFT;
> -               } else
> -                       pmds += (range + PMD_SIZE - 1) >> PMD_SHIFT;
> -
> -               if (mr[i].page_size_mask & (1 << PG_LEVEL_2M)) {
> -                       extra = range - ((range >> PMD_SHIFT) << PMD_SHIFT);
> -#ifdef CONFIG_X86_32
> -                       extra += PMD_SIZE;
> -#endif
> -                       /* The first 2/4M doesn't use large pages. */
> -                       if (mr[i].start < PMD_SIZE)
> -                               extra += PMD_SIZE - mr[i].start;
> -
> -                       ptes += (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
> -               } else
> -                       ptes += (range + PAGE_SIZE - 1) >> PAGE_SHIFT;
> -       }
> -
> -       tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
> -       tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
> -       tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
> -
> -#ifdef CONFIG_X86_32
> -       /* for fixmap */
> -       tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
> -#endif
> -
> -       return tables;
> -}
> -
> -static unsigned long __init calculate_all_table_space_size(void)
> -{
> -       unsigned long start_pfn, end_pfn;
> -       unsigned long tables;
> -       int i;
> -
> -       /* the ISA range is always mapped regardless of memory holes */
> -       tables = calculate_table_space_size(0, ISA_END_ADDRESS);
> -
> -       for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
> -               u64 start = start_pfn << PAGE_SHIFT;
> -               u64 end = end_pfn << PAGE_SHIFT;
> -
> -               if (end <= ISA_END_ADDRESS)
> -                       continue;
> -
> -               if (start < ISA_END_ADDRESS)
> -                       start = ISA_END_ADDRESS;
> -#ifdef CONFIG_X86_32
> -               /* on 32 bit, we only map up to max_low_pfn */
> -               if ((start >> PAGE_SHIFT) >= max_low_pfn)
> -                       continue;
> -
> -               if ((end >> PAGE_SHIFT) > max_low_pfn)
> -                       end = max_low_pfn << PAGE_SHIFT;
> -#endif
> -               tables += calculate_table_space_size(start, end);
> -       }
> -
> -       return tables;
> -}
> -
> -static void __init find_early_table_space(unsigned long start,
> -                                         unsigned long good_end,
> -                                         unsigned long tables)
> -{
> -       phys_addr_t base;
> -
> -       base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
> -       if (!base)
> -               panic("Cannot find space for the kernel page tables");
> -
> -       pgt_buf_start = base >> PAGE_SHIFT;
> -       pgt_buf_end = pgt_buf_start;
> -       pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
> -}
> -
>  static struct range pfn_mapped[E820_X_MAX];
>  static int nr_pfn_mapped;
> 
> @@ -391,17 +307,14 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  }
> 
>  /*
> - * Iterate through E820 memory map and create direct mappings for only E820_RAM
> - * regions. We cannot simply create direct mappings for all pfns from
> - * [0 to max_low_pfn) and [4GB to max_pfn) because of possible memory holes in
> - * high addresses that cannot be marked as UC by fixed/variable range MTRRs.
> - * Depending on the alignment of E820 ranges, this may possibly result in using
> - * smaller size (i.e. 4K instead of 2M or 1G) page tables.
> + * this one could take range with hole in it
>   */
> -static void __init init_range_memory_mapping(unsigned long range_start,
> +static unsigned long __init init_range_memory_mapping(
> +                                          unsigned long range_start,
>                                            unsigned long range_end)
>  {
>         unsigned long start_pfn, end_pfn;
> +       unsigned long mapped_ram_size = 0;
>         int i;
> 
>         for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
> @@ -421,71 +334,67 @@ static void __init init_range_memory_mapping(unsigned long range_start,
>                         end = range_end;
> 
>                 init_memory_mapping(start, end);
> +
> +               mapped_ram_size += end - start;
>         }
> +
> +       return mapped_ram_size;
>  }
> 
>  void __init init_mem_mapping(void)
>  {
> -       unsigned long tables, good_end, end;
> +       unsigned long end, real_end, start, last_start;
> +       unsigned long step_size;
> +       unsigned long addr;
> +       unsigned long mapped_ram_size = 0;
> +       unsigned long new_mapped_ram_size;
> 
>         probe_page_size_mask();
> 
> -       /*
> -        * Find space for the kernel direct mapping tables.
> -        *
> -        * Later we should allocate these tables in the local node of the
> -        * memory mapped. Unfortunately this is done currently before the
> -        * nodes are discovered.
> -        */
>  #ifdef CONFIG_X86_64
>         end = max_pfn << PAGE_SHIFT;
> -       good_end = end;
>  #else
>         end = max_low_pfn << PAGE_SHIFT;
> -       good_end = max_pfn_mapped << PAGE_SHIFT;
>  #endif
> -       tables = calculate_all_table_space_size();
> -       find_early_table_space(0, good_end, tables);
> -       printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx] prealloc\n",
> -               end - 1, pgt_buf_start << PAGE_SHIFT,
> -               (pgt_buf_top << PAGE_SHIFT) - 1);
> 
> -       max_pfn_mapped = 0; /* will get exact value next */
>         /* the ISA range is always mapped regardless of memory holes */
>         init_memory_mapping(0, ISA_END_ADDRESS);
> -       init_range_memory_mapping(ISA_END_ADDRESS, end);
> +
> +       /* xen has big range in reserved near end of ram, skip it at first */
> +       addr = memblock_find_in_range(ISA_END_ADDRESS, end, PMD_SIZE,
> +                        PAGE_SIZE);
> +       real_end = addr + PMD_SIZE;
> +
> +       /* step_size need to be small so pgt_buf from BRK could cover it */
> +       step_size = PMD_SIZE;
> +       max_pfn_mapped = 0; /* will get exact value next */
> +       min_pfn_mapped = real_end >> PAGE_SHIFT;
> +       last_start = start = real_end;
> +       while (last_start > ISA_END_ADDRESS) {
> +               if (last_start > step_size) {
> +                       start = round_down(last_start - 1, step_size);
> +                       if (start < ISA_END_ADDRESS)
> +                               start = ISA_END_ADDRESS;
> +               } else
> +                       start = ISA_END_ADDRESS;
> +               new_mapped_ram_size = init_range_memory_mapping(start,
> +                                                       last_start);
> +               last_start = start;
> +               min_pfn_mapped = last_start >> PAGE_SHIFT;
> +               if (new_mapped_ram_size > mapped_ram_size)
> +                       step_size <<= 5;
> +               mapped_ram_size += new_mapped_ram_size;
> +       }
> +
> +       if (real_end < end)
> +               init_range_memory_mapping(real_end, end);
> +
>  #ifdef CONFIG_X86_64
>         if (max_pfn > max_low_pfn) {
>                 /* can we preseve max_low_pfn ?*/
>                 max_low_pfn = max_pfn;
>         }
>  #endif
> -       /*
> -        * Reserve the kernel pagetable pages we used (pgt_buf_start -
> -        * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
> -        * so that they can be reused for other purposes.
> -        *
> -        * On native it just means calling memblock_reserve, on Xen it also
> -        * means marking RW the pagetable pages that we allocated before
> -        * but that haven't been used.
> -        *
> -        * In fact on xen we mark RO the whole range pgt_buf_start -
> -        * pgt_buf_top, because we have to make sure that when
> -        * init_memory_mapping reaches the pagetable pages area, it maps
> -        * RO all the pagetable pages, including the ones that are beyond
> -        * pgt_buf_end at that time.
> -        */
> -       if (pgt_buf_end > pgt_buf_start) {
> -               printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx] final\n",
> -                       end - 1, pgt_buf_start << PAGE_SHIFT,
> -                       (pgt_buf_end << PAGE_SHIFT) - 1);
> -               x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
> -                               PFN_PHYS(pgt_buf_end));
> -       }
> -
> -       /* stop the wrong using */
> -       pgt_buf_top = 0;
> -
>         early_memtest(0, max_pfn_mapped << PAGE_SHIFT);
>  }
> 
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 27f7fc6..7bb1106 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -61,11 +61,22 @@ bool __read_mostly __vmalloc_start_set = false;
> 
>  static __init void *alloc_low_page(void)
>  {
> -       unsigned long pfn = pgt_buf_end++;
> +       unsigned long pfn;
>         void *adr;
> 
> -       if (pfn >= pgt_buf_top)
> -               panic("alloc_low_page: ran out of memory");
> +       if ((pgt_buf_end + 1) >= pgt_buf_top) {
> +               unsigned long ret;
> +               if (min_pfn_mapped >= max_pfn_mapped)
> +                       panic("alloc_low_page: ran out of memory");
> +               ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
> +                                       max_pfn_mapped << PAGE_SHIFT,
> +                                       PAGE_SIZE, PAGE_SIZE);
> +               if (!ret)
> +                       panic("alloc_low_page: can not alloc memory");
> +               memblock_reserve(ret, PAGE_SIZE);
> +               pfn = ret >> PAGE_SHIFT;
> +       } else
> +               pfn = pgt_buf_end++;
> 
>         adr = __va(pfn * PAGE_SIZE);
>         clear_page(adr);
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 4898e80..7dfa69b 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -316,7 +316,7 @@ void __init cleanup_highmap(void)
> 
>  static __ref void *alloc_low_page(unsigned long *phys)
>  {
> -       unsigned long pfn = pgt_buf_end++;
> +       unsigned long pfn;
>         void *adr;
> 
>         if (after_bootmem) {
> @@ -326,8 +326,19 @@ static __ref void *alloc_low_page(unsigned long *phys)
>                 return adr;
>         }
> 
> -       if (pfn >= pgt_buf_top)
> -               panic("alloc_low_page: ran out of memory");
> +       if ((pgt_buf_end + 1) >= pgt_buf_top) {
> +               unsigned long ret;
> +               if (min_pfn_mapped >= max_pfn_mapped)
> +                       panic("alloc_low_page: ran out of memory");
> +               ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
> +                                       max_pfn_mapped << PAGE_SHIFT,
> +                                       PAGE_SIZE, PAGE_SIZE);
> +               if (!ret)
> +                       panic("alloc_low_page: can not alloc memory");
> +               memblock_reserve(ret, PAGE_SIZE);
> +               pfn = ret >> PAGE_SHIFT;
> +       } else
> +               pfn = pgt_buf_end++;
> 
>         adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
>         clear_page(adr);
> --
> 1.7.7
> 
