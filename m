Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab0EJGSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 02:18:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:54352 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab0EJGSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 02:18:21 -0400
Subject: Re: [PATCH 17/22] lmb: Add ARCH_DISCARD_LMB to put lmb code to
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
In-Reply-To: <1273331860-14325-18-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
	 <1273331860-14325-18-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 16:16:32 +1000
Message-ID: <1273472192.23699.34.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-08 at 08:17 -0700, Yinghai Lu wrote:
> So those lmb bits could be released after kernel is booted up.
> 
> Arch code could define ARCH_DISCARD_LMB in asm/lmb.h, __init_lmb will become __init, __initdata_lmb will becom __initdata
> 
> x86 code will use that.
> 
> -v2: use ARCH_DISCARD_LMB according to Michael Ellerman

So first, you don't define ARCH_DISCARD_LMB on any arch, so they will
all use __init_lmb, but thta isnt defined by this patch afaik, so you
have just broken everything no ?

Also, why do you want that precisely ? bootmem is __init so that's fine
to discard. We also already don't discard the lmb arrays. So what are
you trying to achieve ?

Cheers,
Ben.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/lmb.h |    8 +++++++
>  mm/lmb.c            |   54 ++++++++++++++++++++++++++++++--------------------
>  2 files changed, 40 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/lmb.h b/include/linux/lmb.h
> index 47b9d7f..e486572 100644
> --- a/include/linux/lmb.h
> +++ b/include/linux/lmb.h
> @@ -107,6 +107,14 @@ u64 lmb_memory_size(u64 addr, u64 limit);
>  
>  #include <asm/lmb.h>
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
> diff --git a/mm/lmb.c b/mm/lmb.c
> index db2264d..c2c6bff 100644
> --- a/mm/lmb.c
> +++ b/mm/lmb.c
> @@ -21,11 +21,11 @@
>  
>  #define LMB_ALLOC_ANYWHERE	0
>  
> -struct lmb lmb;
> -static struct lmb_property lmb_memory_region[MAX_LMB_REGIONS];
> -static struct lmb_property lmb_reserved_region[MAX_LMB_REGIONS];
> +struct lmb lmb __initdata_lmb;
> +static struct lmb_property lmb_memory_region[MAX_LMB_REGIONS] __initdata_lmb;
> +static struct lmb_property lmb_reserved_region[MAX_LMB_REGIONS] __initdata_lmb;
>  
> -static int lmb_debug;
> +static int lmb_debug __initdata_lmb;
>  
>  static int __init early_lmb(char *p)
>  {
> @@ -35,7 +35,7 @@ static int __init early_lmb(char *p)
>  }
>  early_param("lmb", early_lmb);
>  
> -static void lmb_dump(struct lmb_region *region, char *name)
> +static void __init_lmb lmb_dump(struct lmb_region *region, char *name)
>  {
>  	unsigned long long base, size;
>  	int i;
> @@ -51,7 +51,7 @@ static void lmb_dump(struct lmb_region *region, char *name)
>  	}
>  }
>  
> -void lmb_dump_all(void)
> +void __init_lmb lmb_dump_all(void)
>  {
>  	if (!lmb_debug)
>  		return;
> @@ -64,13 +64,13 @@ void lmb_dump_all(void)
>  	lmb_dump(&lmb.reserved, "reserved");
>  }
>  
> -static unsigned long lmb_addrs_overlap(u64 base1, u64 size1, u64 base2,
> +static unsigned long __init_lmb lmb_addrs_overlap(u64 base1, u64 size1, u64 base2,
>  					u64 size2)
>  {
>  	return ((base1 < (base2 + size2)) && (base2 < (base1 + size1)));
>  }
>  
> -static long lmb_addrs_adjacent(u64 base1, u64 size1, u64 base2, u64 size2)
> +static long __init_lmb lmb_addrs_adjacent(u64 base1, u64 size1, u64 base2, u64 size2)
>  {
>  	if (base2 == base1 + size1)
>  		return 1;
> @@ -80,7 +80,7 @@ static long lmb_addrs_adjacent(u64 base1, u64 size1, u64 base2, u64 size2)
>  	return 0;
>  }
>  
> -static long lmb_regions_adjacent(struct lmb_region *rgn,
> +static long __init_lmb lmb_regions_adjacent(struct lmb_region *rgn,
>  		unsigned long r1, unsigned long r2)
>  {
>  	u64 base1 = rgn->region[r1].base;
> @@ -91,7 +91,7 @@ static long lmb_regions_adjacent(struct lmb_region *rgn,
>  	return lmb_addrs_adjacent(base1, size1, base2, size2);
>  }
>  
> -static void lmb_remove_region(struct lmb_region *rgn, unsigned long r)
> +static void __init_lmb lmb_remove_region(struct lmb_region *rgn, unsigned long r)
>  {
>  	unsigned long i;
>  
> @@ -103,7 +103,7 @@ static void lmb_remove_region(struct lmb_region *rgn, unsigned long r)
>  }
>  
>  /* Assumption: base addr of region 1 < base addr of region 2 */
> -static void lmb_coalesce_regions(struct lmb_region *rgn,
> +static void __init_lmb lmb_coalesce_regions(struct lmb_region *rgn,
>  		unsigned long r1, unsigned long r2)
>  {
>  	rgn->region[r1].size += rgn->region[r2].size;
> @@ -140,7 +140,7 @@ void __init lmb_analyze(void)
>  		lmb.memory.size += lmb.memory.region[i].size;
>  }
>  
> -static long lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
> +static long __init_lmb lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
>  {
>  	unsigned long coalesced = 0;
>  	long adjacent, i;
> @@ -204,7 +204,7 @@ static long lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
>  	return 0;
>  }
>  
> -long lmb_add(u64 base, u64 size)
> +long __init_lmb lmb_add(u64 base, u64 size)
>  {
>  	struct lmb_region *_rgn = &lmb.memory;
>  
> @@ -216,7 +216,7 @@ long lmb_add(u64 base, u64 size)
>  
>  }
>  
> -static long __lmb_remove(struct lmb_region *rgn, u64 base, u64 size)
> +static long __init_lmb __lmb_remove(struct lmb_region *rgn, u64 base, u64 size)
>  {
>  	u64 rgnbegin, rgnend;
>  	u64 end = base + size;
> @@ -264,7 +264,7 @@ static long __lmb_remove(struct lmb_region *rgn, u64 base, u64 size)
>  	return lmb_add_region(rgn, end, rgnend - end);
>  }
>  
> -long lmb_remove(u64 base, u64 size)
> +long __init_lmb lmb_remove(u64 base, u64 size)
>  {
>  	return __lmb_remove(&lmb.memory, base, size);
>  }
> @@ -283,7 +283,7 @@ long __init lmb_reserve(u64 base, u64 size)
>  	return lmb_add_region(_rgn, base, size);
>  }
>  
> -long lmb_overlaps_region(struct lmb_region *rgn, u64 base, u64 size)
> +long __init_lmb lmb_overlaps_region(struct lmb_region *rgn, u64 base, u64 size)
>  {
>  	unsigned long i;
>  
> @@ -297,12 +297,12 @@ long lmb_overlaps_region(struct lmb_region *rgn, u64 base, u64 size)
>  	return (i < rgn->cnt) ? i : -1;
>  }
>  
> -static u64 lmb_align_down(u64 addr, u64 size)
> +static u64 __init_lmb lmb_align_down(u64 addr, u64 size)
>  {
>  	return addr & ~(size - 1);
>  }
>  
> -static u64 lmb_align_up(u64 addr, u64 size)
> +static u64 __init_lmb lmb_align_up(u64 addr, u64 size)
>  {
>  	return (addr + (size - 1)) & ~(size - 1);
>  }
> @@ -462,7 +462,7 @@ u64 __init lmb_phys_mem_size(void)
>  	return lmb.memory.size;
>  }
>  
> -u64 lmb_end_of_DRAM(void)
> +u64 __init_lmb lmb_end_of_DRAM(void)
>  {
>  	int idx = lmb.memory.cnt - 1;
>  
> @@ -526,7 +526,7 @@ int __init lmb_is_reserved(u64 addr)
>  	return 0;
>  }
>  
> -int lmb_is_region_reserved(u64 base, u64 size)
> +int __init_lmb lmb_is_region_reserved(u64 base, u64 size)
>  {
>  	return lmb_overlaps_region(&lmb.reserved, base, size);
>  }
> @@ -535,7 +535,7 @@ int lmb_is_region_reserved(u64 base, u64 size)
>   * Given a <base, len>, find which memory regions belong to this range.
>   * Adjust the request and return a contiguous chunk.
>   */
> -int lmb_find(struct lmb_property *res)
> +int __init_lmb lmb_find(struct lmb_property *res)
>  {
>  	int i;
>  	u64 rstart, rend;
> @@ -689,10 +689,11 @@ static void __init subtract_lmb_reserved(struct range *range, int az)
>  	int i, count;
>  	u64 final_start, final_end;
>  
> +#ifdef ARCH_DISCARD_LMB
>  	/* Take out region array itself at first*/
>  	if (lmb.reserved.region != lmb_reserved_region)
>  		lmb_free(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.nr_regions);
> -
> +#endif
>  	count  = lmb.reserved.cnt;
>  
>  	if (lmb_debug)
> @@ -708,9 +709,11 @@ static void __init subtract_lmb_reserved(struct range *range, int az)
>  			continue;
>  		subtract_range(range, az, final_start, final_end);
>  	}
> +#ifdef ARCH_DISCARD_LMB
>  	/* Put region array back ? */
>  	if (lmb.reserved.region != lmb_reserved_region)
>  		lmb_reserve(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.nr_regions);
> +#endif
>  }
>  
>  int __init get_free_all_memory_range(struct range **rangep, int nodeid)
> @@ -735,6 +738,7 @@ int __init get_free_all_memory_range(struct range **rangep, int nodeid)
>  	subtract_lmb_reserved(range, count);
>  	nr_range = clean_sort_range(range, count);
>  
> +#ifdef ARCH_DISCARD_LMB
>  	/* Need to clear it ? */
>  	if (nodeid == MAX_NUMNODES) {
>  		memset(&lmb.reserved.region[0], 0, sizeof(struct lmb_property) * lmb.reserved.nr_regions);
> @@ -742,6 +746,7 @@ int __init get_free_all_memory_range(struct range **rangep, int nodeid)
>  		lmb.reserved.nr_regions = 0;
>  		lmb.reserved.cnt = 0;
>  	}
> +#endif
>  
>  	*rangep = range;
>  	return nr_range;
> @@ -752,9 +757,11 @@ void __init lmb_to_bootmem(u64 start, u64 end)
>  	int i, count;
>  	u64 final_start, final_end;
>  
> +#ifdef ARCH_DISCARD_LMB
>  	/* Take out region array itself */
>  	if (lmb.reserved.region != lmb_reserved_region)
>  		lmb_free(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.nr_regions);
> +#endif
>  
>  	count  = lmb.reserved.cnt;
>  	if (lmb_debug)
> @@ -774,11 +781,14 @@ void __init lmb_to_bootmem(u64 start, u64 end)
>  			pr_cont(" ==> [%010llx - %010llx]\n", final_start, final_end);
>  		reserve_bootmem_generic(final_start, final_end - final_start, BOOTMEM_DEFAULT);
>  	}
> +
> +#ifdef ARCH_DISCARD_LMB
>  	/* Clear them to avoid misusing ? */
>  	memset(&lmb.reserved.region[0], 0, sizeof(struct lmb_property) * lmb.reserved.nr_regions);
>  	lmb.reserved.region = NULL;
>  	lmb.reserved.nr_regions = 0;
>  	lmb.reserved.cnt = 0;
> +#endif
>  }
>  #endif
>  


