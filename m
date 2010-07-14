Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab0GNHuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 03:50:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46637 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab0GNHuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 03:50:46 -0400
Date: Wed, 14 Jul 2010 16:50:25 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [RFC] Tight check of pfn_valid on sparsemem
In-reply-to: <20100714092301.69e7e628.kamezawa.hiroyu@jp.fujitsu.com>
To: "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Minchan Kim'" <minchan.kim@gmail.com>
Cc: "'Dave Hansen'" <dave@linux.vnet.ibm.com>,
        "'Johannes Weiner'" <hannes@cmpxchg.org>, linux@arm.linux.org.uk,
        "'Yinghai Lu'" <yinghai@kernel.org>,
        "'H. Peter Anvin'" <hpa@zytor.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Shaohua Li'" <shaohua.li@intel.com>,
        "'Yakui Zhao'" <yakui.zhao@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, arm-kernel@lists.infradead.org,
        "'Mel Gorman'" <mel@csn.ul.ie>
Message-id: <000e01cb2329$3d8c5770$b8a50650$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acsi62u2Lyw0fe1cT2u5zvkt64draQABwSHA
References: <20100712155348.GA2815@barrios-desktop>
 <20100713093006.GB14504@cmpxchg.org> <20100713154335.GB2815@barrios-desktop>
 <1279038933.10995.9.camel@nimitz> <20100713164423.GC2815@barrios-desktop>
 <20100714092301.69e7e628.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> 
> On Wed, 14 Jul 2010 01:44:23 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > > If you _really_ can't make the section size smaller, and the vast
> > > majority of the sections are fully populated, you could hack something
> > > in.  We could, for instance, have a global list that's mostly readonly
> > > which tells you which sections need to be have their sizes closely
> > > inspected.  That would work OK if, for instance, you only needed to
> > > check a couple of memory sections in the system.  It'll start to suck
if
> > > you made the lists very long.
> >
> > Thanks for advise. As I say, I hope Russell accept 16M section.
> >
Hi,

Thanks for your inputs.
> 
> It seems what I needed was good sleep....
> How about this if 16M section is not acceptable ?
> 
> == NOT TESTED AT ALL, EVEN NOT COMPILED ==

Yeah...

Couldn't build with s5pv210_defconfig when used mmotm tree,
And couldn't apply your patch against latest mainline 35-rc5.

Could you please remake your patch against mainline 35-rc5?
Or...please let me know how I can test on my board(smdkv210).

> 
> register address of mem_section to memmap itself's page struct's
pg->private
> field.
> This means the page is used for memmap of the section.
> Otherwise, the page is used for other purpose and memmap has a hole.
> 
> ---
>  arch/arm/mm/init.c     |   11 ++++++++++-
>  include/linux/mmzone.h |   19 ++++++++++++++++++-
>  mm/sparse.c            |   37
> +++++++++++++++++++++++++++++++++++++
>  3 files changed, 65 insertions(+), 2 deletions(-)
> 
> Index: mmotm-2.6.35-0701/include/linux/mmzone.h
> =============================================================
> ======
> --- mmotm-2.6.35-0701.orig/include/linux/mmzone.h
> +++ mmotm-2.6.35-0701/include/linux/mmzone.h
> @@ -1047,11 +1047,28 @@ static inline struct mem_section *__pfn_
>  	return __nr_to_section(pfn_to_section_nr(pfn));
>  }
> 
> +#ifdef CONFIG_SPARSEMEM_HAS_PIT
> +void mark_memmap_pit(unsigned long start, unsigned long end, bool valid);
> +static inline int page_valid(struct mem_section *ms, unsigned long pfn)
> +{
> +	struct page *page = pfn_to_page(pfn);
> +	struct page *__pg = virt_to_page(page);
> +	return __pg->private == ms;
> +}
> +#else
> +static inline int page_valid(struct mem_section *ms, unsigned long pfn)
> +{
> +	return 1;
> +}
> +#endif
> +
>  static inline int pfn_valid(unsigned long pfn)
>  {
> +	struct mem_section *ms;
>  	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
>  		return 0;
> -	return valid_section(__nr_to_section(pfn_to_section_nr(pfn)));
> +	ms = __nr_to_section(pfn_to_section_nr(pfn));
> +	return valid_section(ms) && page_valid(ms, pfn);
>  }
> 
>  static inline int pfn_present(unsigned long pfn)
> Index: mmotm-2.6.35-0701/mm/sparse.c
> =============================================================
> ======
> --- mmotm-2.6.35-0701.orig/mm/sparse.c
> +++ mmotm-2.6.35-0701/mm/sparse.c
> @@ -615,6 +615,43 @@ void __init sparse_init(void)
>  	free_bootmem(__pa(usemap_map), size);
>  }
> 
> +#ifdef CONFIT_SPARSEMEM_HAS_PIT
> +/*
> + * Fill memmap's pg->private with a pointer to mem_section.
> + * pfn_valid() will check this later. (see include/linux/mmzone.h)
> + * The caller should call
> + * 	mark_memmap_pit(start, end, true) # for all allocated mem_map
> + * 	and, after that,
> + * 	mark_memmap_pit(start, end, false) # for all pits in mem_map.
> + * please see usage in ARM.
> + */
> +void mark_memmap_pit(unsigned long start, unsigned long end, bool valid)
> +{
> +	struct mem_section *ms;
> +	unsigned long pos, next;
> +	struct page *pg;
> +	void *memmap, *end;
> +	unsigned long mapsize = sizeof(struct page) * PAGES_PER_SECTION;
> +
> +	for (pos = start;
> +	     pos < end; pos = next) {
> +		next = (pos + PAGES_PER_SECTION) &
> PAGE_SECTION_MASK;
> +		ms = __pfn_to_section(pos);
> +		if (!valid_section(ms))
> +			continue;
> +		for (memmap = pfn_to_page(pfn), end = pfn_to_page(next-1);
> +		     memmap != end + 1;
> +		     memmap += PAGE_SIZE) {
> +			pg = virt_to_page(memmap);
> +			if (valid)
> +				pg->private = ms;
> +			else
> +				pg->private = NULL;
> +		}
> +	}
> +}
> +#endif
> +
>  #ifdef CONFIG_MEMORY_HOTPLUG
>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
>  static inline struct page *kmalloc_section_memmap(unsigned long pnum, int
nid,
> Index: mmotm-2.6.35-0701/arch/arm/mm/init.c
> =============================================================
> ======
> --- mmotm-2.6.35-0701.orig/arch/arm/mm/init.c
> +++ mmotm-2.6.35-0701/arch/arm/mm/init.c
> @@ -234,6 +234,13 @@ static void __init arm_bootmem_free(stru
>  	arch_adjust_zones(zone_size, zhole_size);
> 
>  	free_area_init_node(0, zone_size, min, zhole_size);
> +
> +#ifdef CONFIG_SPARSEMEM
> +	for_each_bank(i, mi) {
> +		mark_memmap_pit(bank_start_pfn(mi->bank[i]),
> +				bank_end_pfn(mi->bank[i]), true);
> +	}
> +#endif
>  }
> 
>  #ifndef CONFIG_SPARSEMEM
> @@ -386,8 +393,10 @@ free_memmap(unsigned long start_pfn, uns
>  	 * If there are free pages between these,
>  	 * free the section of the memmap array.
>  	 */
> -	if (pg < pgend)
> +	if (pg < pgend) {
> +		mark_memap_pit(pg >> PAGE_SHIFT, pgend >> PAGE_SHIFT,
> false);
>  		free_bootmem(pg, pgend - pg);
> +	}
>  }
> 
>  /*



Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

