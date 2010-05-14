Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab0ENCQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:16:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:36557 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab0ENCQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:16:13 -0400
Subject: Re: [PATCH 03/35] lmb: Add ARCH_DISCARD_LMB to put lmb code to
 .init
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1273796396-29649-4-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-4-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 12:14:09 +1000
Message-ID: <1273803249.21352.357.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
> So those lmb bits could be released after kernel is booted up.
> 
> Arch code could define ARCH_DISCARD_LMB in asm/lmb.h,
> __init_lmb will become __init, __initdata_lmb will becom __initdata
> 
> x86 code will use that.

So you do not intend to use lmb after boot ? This will break the debugfs
files unless you also remove those.

Cheers,
Ben.

> -v2: use ARCH_DISCARD_LMB according to Michael Ellerman
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/lmb.h |    8 ++++++++
>  lib/lmb.c           |   46 +++++++++++++++++++++++-----------------------
>  2 files changed, 31 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/lmb.h b/include/linux/lmb.h
> index 2b87641..0b073a3 100644
> --- a/include/linux/lmb.h
> +++ b/include/linux/lmb.h
> @@ -145,6 +145,14 @@ static inline unsigned long lmb_region_pages(const struct lmb_region *reg)
>  	     region++)
>  
> 
> +#ifdef ARCH_DISCARD_LMB
> +#define __init_lmb __init
> +#define __initdata_lmb __initdata
> +#else
> +#define __init_lmb
> +#define __initdata_lmb
> +#endif
> +
>  #endif /* CONFIG_HAVE_LMB */
>  
>  #endif /* __KERNEL__ */
> diff --git a/lib/lmb.c b/lib/lmb.c
> index fddd72c..6d49a17 100644
> --- a/lib/lmb.c
> +++ b/lib/lmb.c
> @@ -20,11 +20,11 @@
>  #include <linux/seq_file.h>
>  #include <linux/lmb.h>
>  
> -struct lmb lmb;
> +struct lmb lmb __initdata_lmb;
>  
> -int lmb_debug;
> -static struct lmb_region lmb_memory_init_regions[INIT_LMB_REGIONS + 1];
> -struct lmb_region lmb_reserved_init_regions[INIT_LMB_REGIONS + 1];
> +int lmb_debug __initdata_lmb;
> +static struct lmb_region lmb_memory_init_regions[INIT_LMB_REGIONS + 1] __initdata_lmb;
> +struct lmb_region lmb_reserved_init_regions[INIT_LMB_REGIONS + 1] __initdata_lmb;
>  
>  /* inline so we don't get a warning when pr_debug is compiled out */
>  static inline const char *lmb_type_name(struct lmb_type *type)
> @@ -41,23 +41,23 @@ static inline const char *lmb_type_name(struct lmb_type *type)
>   * Address comparison utilities
>   */
>  
> -static phys_addr_t lmb_align_down(phys_addr_t addr, phys_addr_t size)
> +static phys_addr_t __init_lmb lmb_align_down(phys_addr_t addr, phys_addr_t size)
>  {
>  	return addr & ~(size - 1);
>  }
>  
> -static phys_addr_t lmb_align_up(phys_addr_t addr, phys_addr_t size)
> +static phys_addr_t __init_lmb lmb_align_up(phys_addr_t addr, phys_addr_t size)
>  {
>  	return (addr + (size - 1)) & ~(size - 1);
>  }
>  
> -static unsigned long lmb_addrs_overlap(phys_addr_t base1, phys_addr_t size1,
> +static unsigned long __init_lmb lmb_addrs_overlap(phys_addr_t base1, phys_addr_t size1,
>  				       phys_addr_t base2, phys_addr_t size2)
>  {
>  	return ((base1 < (base2 + size2)) && (base2 < (base1 + size1)));
>  }
>  
> -static long lmb_addrs_adjacent(phys_addr_t base1, phys_addr_t size1,
> +static long __init_lmb lmb_addrs_adjacent(phys_addr_t base1, phys_addr_t size1,
>  			       phys_addr_t base2, phys_addr_t size2)
>  {
>  	if (base2 == base1 + size1)
> @@ -68,7 +68,7 @@ static long lmb_addrs_adjacent(phys_addr_t base1, phys_addr_t size1,
>  	return 0;
>  }
>  
> -static long lmb_regions_adjacent(struct lmb_type *type,
> +static long __init_lmb lmb_regions_adjacent(struct lmb_type *type,
>  				 unsigned long r1, unsigned long r2)
>  {
>  	phys_addr_t base1 = type->regions[r1].base;
> @@ -79,7 +79,7 @@ static long lmb_regions_adjacent(struct lmb_type *type,
>  	return lmb_addrs_adjacent(base1, size1, base2, size2);
>  }
>  
> -long lmb_overlaps_region(struct lmb_type *type, phys_addr_t base, phys_addr_t size)
> +long __init_lmb lmb_overlaps_region(struct lmb_type *type, phys_addr_t base, phys_addr_t size)
>  {
>  	unsigned long i;
>  
> @@ -155,7 +155,7 @@ static phys_addr_t __init lmb_find_base(phys_addr_t size, phys_addr_t align,
>  	return LMB_ERROR;
>  }
>  
> -static void lmb_remove_region(struct lmb_type *type, unsigned long r)
> +static void __init_lmb lmb_remove_region(struct lmb_type *type, unsigned long r)
>  {
>  	unsigned long i;
>  
> @@ -167,14 +167,14 @@ static void lmb_remove_region(struct lmb_type *type, unsigned long r)
>  }
>  
>  /* Assumption: base addr of region 1 < base addr of region 2 */
> -static void lmb_coalesce_regions(struct lmb_type *type,
> +static void __init_lmb lmb_coalesce_regions(struct lmb_type *type,
>  		unsigned long r1, unsigned long r2)
>  {
>  	type->regions[r1].size += type->regions[r2].size;
>  	lmb_remove_region(type, r2);
>  }
>  
> -static int lmb_double_array(struct lmb_type *type)
> +static int __init_lmb lmb_double_array(struct lmb_type *type)
>  {
>  	struct lmb_region *new_array, *old_array;
>  	phys_addr_t old_size, new_size, addr;
> @@ -240,13 +240,13 @@ static int lmb_double_array(struct lmb_type *type)
>  	return 0;
>  }
>  
> -extern int __weak lmb_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
> +extern int __init_lmb __weak lmb_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
>  					  phys_addr_t addr2, phys_addr_t size2)
>  {
>  	return 1;
>  }
>  
> -long lmb_add_region(struct lmb_type *type, phys_addr_t base, phys_addr_t size)
> +long __init_lmb lmb_add_region(struct lmb_type *type, phys_addr_t base, phys_addr_t size)
>  {
>  	unsigned long coalesced = 0;
>  	long adjacent, i;
> @@ -333,13 +333,13 @@ long lmb_add_region(struct lmb_type *type, phys_addr_t base, phys_addr_t size)
>  	return 0;
>  }
>  
> -long lmb_add(phys_addr_t base, phys_addr_t size)
> +long __init_lmb lmb_add(phys_addr_t base, phys_addr_t size)
>  {
>  	return lmb_add_region(&lmb.memory, base, size);
>  
>  }
>  
> -static long __lmb_remove(struct lmb_type *type, phys_addr_t base, phys_addr_t size)
> +static long __init_lmb __lmb_remove(struct lmb_type *type, phys_addr_t base, phys_addr_t size)
>  {
>  	phys_addr_t rgnbegin, rgnend;
>  	phys_addr_t end = base + size;
> @@ -387,7 +387,7 @@ static long __lmb_remove(struct lmb_type *type, phys_addr_t base, phys_addr_t si
>  	return lmb_add_region(type, end, rgnend - end);
>  }
>  
> -long lmb_remove(phys_addr_t base, phys_addr_t size)
> +long __init_lmb lmb_remove(phys_addr_t base, phys_addr_t size)
>  {
>  	return __lmb_remove(&lmb.memory, base, size);
>  }
> @@ -544,7 +544,7 @@ phys_addr_t __init lmb_phys_mem_size(void)
>  	return lmb.memory_size;
>  }
>  
> -phys_addr_t lmb_end_of_DRAM(void)
> +phys_addr_t __init_lmb lmb_end_of_DRAM(void)
>  {
>  	int idx = lmb.memory.cnt - 1;
>  
> @@ -605,7 +605,7 @@ int __init lmb_is_reserved(phys_addr_t addr)
>  	return 0;
>  }
>  
> -int lmb_is_region_reserved(phys_addr_t base, phys_addr_t size)
> +int __init_lmb lmb_is_region_reserved(phys_addr_t base, phys_addr_t size)
>  {
>  	return lmb_overlaps_region(&lmb.reserved, base, size);
>  }
> @@ -616,7 +616,7 @@ void __init lmb_set_current_limit(phys_addr_t limit)
>  	lmb.current_limit = limit;
>  }
>  
> -static void lmb_dump(struct lmb_type *region, char *name)
> +static void __init_lmb lmb_dump(struct lmb_type *region, char *name)
>  {
>  	unsigned long long base, size;
>  	int i;
> @@ -632,7 +632,7 @@ static void lmb_dump(struct lmb_type *region, char *name)
>  	}
>  }
>  
> -void lmb_dump_all(void)
> +void __init_lmb lmb_dump_all(void)
>  {
>  	if (!lmb_debug)
>  		return;
> @@ -695,7 +695,7 @@ static int __init early_lmb(char *p)
>  }
>  early_param("lmb", early_lmb);
>  
> -#ifdef CONFIG_DEBUG_FS
> +#if defined(CONFIG_DEBUG_FS) && !defined(ARCH_DISCARD_LMB)
>  
>  static int lmb_debug_show(struct seq_file *m, void *private)
>  {


