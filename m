Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1BDAZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 19:25:55 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60817 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab1BDAZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 19:25:54 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Feb 2011 09:19:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch 5/5] memcg: remove direct page_cgroup-to-page pointer
Message-Id: <20110204091949.e5465acc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1296743166-9412-6-git-send-email-hannes@cmpxchg.org>
References: <1296743166-9412-1-git-send-email-hannes@cmpxchg.org>
	<1296743166-9412-6-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Feb 2011 15:26:06 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> In struct page_cgroup, we have a full word for flags but only a few
> are reserved.  Use the remaining upper bits to encode, depending on
> configuration, the node or the section, to enable page_cgroup-to-page
> lookups without a direct pointer.
> 
> This saves a full word for every page in a system with memory cgroups
> enabled.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

In general,

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thank you. A few questions below.



> ---
>  include/linux/page_cgroup.h |   70 +++++++++++++++++++++++++++---------
>  kernel/bounds.c             |    2 +
>  mm/memcontrol.c             |    6 ++-
>  mm/page_cgroup.c            |   85 +++++++++++++++++++++++++------------------
>  4 files changed, 108 insertions(+), 55 deletions(-)
> 
> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> index 6b63679..05d8618 100644
> --- a/include/linux/page_cgroup.h
> +++ b/include/linux/page_cgroup.h
> @@ -1,8 +1,26 @@
>  #ifndef __LINUX_PAGE_CGROUP_H
>  #define __LINUX_PAGE_CGROUP_H
>  
> +enum {
> +	/* flags for mem_cgroup */
> +	PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
> +	PCG_CACHE, /* charged as cache */
> +	PCG_USED, /* this object is in use. */
> +	PCG_MIGRATION, /* under page migration */
> +	/* flags for mem_cgroup and file and I/O status */
> +	PCG_MOVE_LOCK, /* For race between move_account v.s. following bits */
> +	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
> +	/* No lock in page_cgroup */
> +	PCG_ACCT_LRU, /* page has been accounted for (under lru_lock) */
> +	__NR_PCG_FLAGS,
> +};
> +
> +#ifndef __GENERATING_BOUNDS_H
> +#include <generated/bounds.h>
> +
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
>  #include <linux/bit_spinlock.h>
> +
>  /*
>   * Page Cgroup can be considered as an extended mem_map.
>   * A page_cgroup page is associated with every page descriptor. The
> @@ -13,7 +31,6 @@
>  struct page_cgroup {
>  	unsigned long flags;
>  	struct mem_cgroup *mem_cgroup;
> -	struct page *page;
>  	struct list_head lru;		/* per cgroup LRU list */
>  };
>  
> @@ -32,19 +49,7 @@ static inline void __init page_cgroup_init(void)
>  #endif
>  
>  struct page_cgroup *lookup_page_cgroup(struct page *page);
> -
> -enum {
> -	/* flags for mem_cgroup */
> -	PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
> -	PCG_CACHE, /* charged as cache */
> -	PCG_USED, /* this object is in use. */
> -	PCG_MIGRATION, /* under page migration */
> -	/* flags for mem_cgroup and file and I/O status */
> -	PCG_MOVE_LOCK, /* For race between move_account v.s. following bits */
> -	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
> -	/* No lock in page_cgroup */
> -	PCG_ACCT_LRU, /* page has been accounted for (under lru_lock) */
> -};
> +struct page *lookup_cgroup_page(struct page_cgroup *pc);
>  
>  #define TESTPCGFLAG(uname, lname)			\
>  static inline int PageCgroup##uname(struct page_cgroup *pc)	\
> @@ -117,6 +122,34 @@ static inline void move_unlock_page_cgroup(struct page_cgroup *pc,
>  	local_irq_restore(*flags);
>  }
>  
> +#ifdef CONFIG_SPARSEMEM
> +#define PCG_ARRAYID_SHIFT	SECTIONS_SHIFT
> +#else
> +#define PCG_ARRAYID_SHIFT	NODES_SHIFT
> +#endif
> +
> +#if (PCG_ARRAYID_SHIFT > BITS_PER_LONG - NR_PCG_FLAGS)
> +#error Not enough space left in pc->flags to store page_cgroup array IDs
> +#endif
> +
> +/* pc->flags: ARRAY-ID | FLAGS */
> +
> +#define PCG_ARRAYID_MASK	((1UL << PCG_ARRAYID_SHIFT) - 1)
> +
> +#define PCG_ARRAYID_OFFSET	(sizeof(unsigned long) * 8 - PCG_ARRAYID_SHIFT)
> +
> +static inline void set_page_cgroup_array_id(struct page_cgroup *pc,
> +					    unsigned long id)
> +{
> +	pc->flags &= ~(PCG_ARRAYID_MASK << PCG_ARRAYID_OFFSET);
> +	pc->flags |= (id & PCG_ARRAYID_MASK) << PCG_ARRAYID_OFFSET;
> +}
> +
> +static inline unsigned long page_cgroup_array_id(struct page_cgroup *pc)
> +{
> +	return (pc->flags >> PCG_ARRAYID_OFFSET) & PCG_ARRAYID_MASK;
> +}
> +

If a function for looking up a page from a page_cgroup in inline,
I think these function should be static in page_cgroup.c



>  #else /* CONFIG_CGROUP_MEM_RES_CTLR */
>  struct page_cgroup;
>  
> @@ -137,7 +170,7 @@ static inline void __init page_cgroup_init_flatmem(void)
>  {
>  }
>  
> -#endif
> +#endif /* CONFIG_CGROUP_MEM_RES_CTLR */
>  
>  #include <linux/swap.h>
>  
> @@ -173,5 +206,8 @@ static inline void swap_cgroup_swapoff(int type)
>  	return;
>  }
>  
> -#endif
> -#endif
> +#endif /* CONFIG_CGROUP_MEM_RES_CTLR_SWAP */
> +
> +#endif /* !__GENERATING_BOUNDS_H */
> +
> +#endif /* __LINUX_PAGE_CGROUP_H */
> diff --git a/kernel/bounds.c b/kernel/bounds.c
> index 98a51f2..0c9b862 100644
> --- a/kernel/bounds.c
> +++ b/kernel/bounds.c
> @@ -9,11 +9,13 @@
>  #include <linux/page-flags.h>
>  #include <linux/mmzone.h>
>  #include <linux/kbuild.h>
> +#include <linux/page_cgroup.h>
>  
>  void foo(void)
>  {
>  	/* The enum constants to put into include/generated/bounds.h */
>  	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
>  	DEFINE(MAX_NR_ZONES, __MAX_NR_ZONES);
> +	DEFINE(NR_PCG_FLAGS, __NR_PCG_FLAGS);
>  	/* End of constants */
>  }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 998da06..4e10f46 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1054,7 +1054,8 @@ unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
>  		if (unlikely(!PageCgroupUsed(pc)))
>  			continue;
>  
> -		page = pc->page;
> +		page = lookup_cgroup_page(pc);
> +		VM_BUG_ON(pc != lookup_page_cgroup(page));

If you're afraid of corruption in ->flags bit, checking this in page_cgroup.c
is better. 


Anyway, seems great.

Thanks,
-Kame

>  
>  		if (unlikely(!PageLRU(page)))
>  			continue;
> @@ -3296,7 +3297,8 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *mem,
>  		}
>  		spin_unlock_irqrestore(&zone->lru_lock, flags);
>  
> -		page = pc->page;
> +		page = lookup_cgroup_page(pc);
> +		VM_BUG_ON(pc != lookup_page_cgroup(page));
>  
>  		ret = mem_cgroup_move_parent(page, pc, mem, GFP_KERNEL);
>  		if (ret == -ENOMEM)
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 59a3cd4..e5f38e8 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -11,12 +11,11 @@
>  #include <linux/swapops.h>
>  #include <linux/kmemleak.h>
>  
> -static void __meminit
> -__init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
> +static void __meminit init_page_cgroup(struct page_cgroup *pc, unsigned long id)
>  {
>  	pc->flags = 0;
> +	set_page_cgroup_array_id(pc, id);
>  	pc->mem_cgroup = NULL;
> -	pc->page = pfn_to_page(pfn);
>  	INIT_LIST_HEAD(&pc->lru);
>  }
>  static unsigned long total_usage;
> @@ -43,6 +42,16 @@ struct page_cgroup *lookup_page_cgroup(struct page *page)
>  	return base + offset;
>  }
>  
> +struct page *lookup_cgroup_page(struct page_cgroup *pc)
> +{
> +	unsigned long pfn;
> +	pg_data_t *pgdat;
> +
> +	pgdat = NODE_DATA(page_cgroup_array_id(pc));
> +	pfn = pc - pgdat->node_page_cgroup + pgdat->node_start_pfn;
> +	return pfn_to_page(pfn);
> +}
> +
>  static int __init alloc_node_page_cgroup(int nid)
>  {
>  	struct page_cgroup *base, *pc;
> @@ -63,7 +72,7 @@ static int __init alloc_node_page_cgroup(int nid)
>  		return -ENOMEM;
>  	for (index = 0; index < nr_pages; index++) {
>  		pc = base + index;
> -		__init_page_cgroup(pc, start_pfn + index);
> +		init_page_cgroup(pc, nid);
>  	}
>  	NODE_DATA(nid)->node_page_cgroup = base;
>  	total_usage += table_size;
> @@ -105,46 +114,50 @@ struct page_cgroup *lookup_page_cgroup(struct page *page)
>  	return section->page_cgroup + pfn;
>  }
>  
> +struct page *lookup_cgroup_page(struct page_cgroup *pc)
> +{
> +	struct mem_section *section;
> +	unsigned long nr;
> +
> +	nr = page_cgroup_array_id(pc);
> +	section = __nr_to_section(nr);
> +	return pfn_to_page(pc - section->page_cgroup);
> +}
> +
>  /* __alloc_bootmem...() is protected by !slab_available() */
>  static int __init_refok init_section_page_cgroup(unsigned long pfn)
>  {
> -	struct mem_section *section = __pfn_to_section(pfn);
>  	struct page_cgroup *base, *pc;
> +	struct mem_section *section;
>  	unsigned long table_size;
> +	unsigned long nr;
>  	int nid, index;
>  
> -	if (!section->page_cgroup) {
> -		nid = page_to_nid(pfn_to_page(pfn));
> -		table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
> -		VM_BUG_ON(!slab_is_available());
> -		if (node_state(nid, N_HIGH_MEMORY)) {
> -			base = kmalloc_node(table_size,
> -				GFP_KERNEL | __GFP_NOWARN, nid);
> -			if (!base)
> -				base = vmalloc_node(table_size, nid);
> -		} else {
> -			base = kmalloc(table_size, GFP_KERNEL | __GFP_NOWARN);
> -			if (!base)
> -				base = vmalloc(table_size);
> -		}
> -		/*
> -		 * The value stored in section->page_cgroup is (base - pfn)
> -		 * and it does not point to the memory block allocated above,
> -		 * causing kmemleak false positives.
> -		 */
> -		kmemleak_not_leak(base);
> +	nr = pfn_to_section_nr(pfn);
> +	section = __nr_to_section(nr);
> +
> +	if (section->page_cgroup)
> +		return 0;
> +
> +	nid = page_to_nid(pfn_to_page(pfn));
> +	table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
> +	VM_BUG_ON(!slab_is_available());
> +	if (node_state(nid, N_HIGH_MEMORY)) {
> +		base = kmalloc_node(table_size,
> +				    GFP_KERNEL | __GFP_NOWARN, nid);
> +		if (!base)
> +			base = vmalloc_node(table_size, nid);
>  	} else {
> -		/*
> - 		 * We don't have to allocate page_cgroup again, but
> -		 * address of memmap may be changed. So, we have to initialize
> -		 * again.
> -		 */
> -		base = section->page_cgroup + pfn;
> -		table_size = 0;
> -		/* check address of memmap is changed or not. */
> -		if (base->page == pfn_to_page(pfn))
> -			return 0;
> +		base = kmalloc(table_size, GFP_KERNEL | __GFP_NOWARN);
> +		if (!base)
> +			base = vmalloc(table_size);
>  	}
> +	/*
> +	 * The value stored in section->page_cgroup is (base - pfn)
> +	 * and it does not point to the memory block allocated above,
> +	 * causing kmemleak false positives.
> +	 */
> +	kmemleak_not_leak(base);
>  
>  	if (!base) {
>  		printk(KERN_ERR "page cgroup allocation failure\n");
> @@ -153,7 +166,7 @@ static int __init_refok init_section_page_cgroup(unsigned long pfn)
>  
>  	for (index = 0; index < PAGES_PER_SECTION; index++) {
>  		pc = base + index;
> -		__init_page_cgroup(pc, pfn + index);
> +		init_page_cgroup(pc, nr);
>  	}
>  
>  	section->page_cgroup = base - pfn;
> -- 
> 1.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

