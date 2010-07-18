Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab0GRLx1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 07:53:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36128 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab0GRLx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 07:53:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xUsGBIjmmoeQst8KpW/RWKFLTD+CnajwGb9DJl81gyVX63tgzvcRhyRSiDwTcCxSIf
         lOdsJIb8cxZnOOTDk74vpgert1PHYZycBBs9FGsKpBx5gyfGRYsusYXIIzaTXaO9w/yB
         d7+xzjot3cvbCC4vD1j/vCn9vP+3bCmIDJzvQ=
MIME-Version: 1.0
In-Reply-To: <1279448311-29788-1-git-send-email-minchan.kim@gmail.com>
References: <1279448311-29788-1-git-send-email-minchan.kim@gmail.com>
Date: Sun, 18 Jul 2010 20:53:25 +0900
X-Google-Sender-Auth: __66AIt05jsqa8JLlLtZECqOqXI
Message-ID: <AANLkTilQf-43GMAIDa-MKmcB2afdVgkERMg0b5mhIbhE@mail.gmail.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v2
From: Kyungmin Park <kmpark@infradead.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

Please see the OneDRAM spec. it's OneDRAM memory usage.
Actually memory size is 80MiB + 16MiB at AP side and it's used 80MiB
for dedicated AP.
The shared 16MiB used between AP and CP. So we also use the 16MiB.

Thank you,
Kyungmin Park

On Sun, Jul 18, 2010 at 7:18 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
> Kukjin reported oops happen while he change min_free_kbytes
> http://www.spinics.net/lists/arm-kernel/msg92894.html
> It happen by memory map on sparsemem.
>
> The system has a memory map following as.
>     section 0             section 1              section 2
> 0x20000000-0x25000000, 0x40000000-0x50000000, 0x50000000-0x58000000
> SECTION_SIZE_BITS 28(256M)
>
> It means section 0 is an incompletely filled section.
> Nontheless, current pfn_valid of sparsemem checks pfn loosely.
> It checks only mem_section's validation but ARM can free mem_map on hole
> to save memory space. So in above case, pfn on 0x25000000 can pass pfn_valid's
> validation check. It's not what we want.
>
> We can match section size to smallest valid size.(ex, above case, 16M)
> But Russell doesn't like it due to mem_section's memory overhead with different
> configuration(ex, 512K section).
>
> I tried to add valid pfn range in mem_section but everyone doesn't like it
> due to size overhead. This patch is suggested by KAMEZAWA-san.
> I just fixed compile error and change some naming.
>
> This patch registers address of mem_section to memmap itself's page struct's
> pg->private field. This means the page is used for memmap of the section.
> Otherwise, the page is used for other purpose and memmap has a hole.
>
> This patch is based on mmotm-2010-07-01-12-19.
>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Reported-by: Kukjin Kim <kgene.kim@samsung.com>
> ---
>  arch/arm/mm/init.c     |    9 ++++++++-
>  include/linux/mmzone.h |   21 ++++++++++++++++++++-
>  mm/Kconfig             |    5 +++++
>  mm/sparse.c            |   41 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 74 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index cfe4c5e..4586f40 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -234,6 +234,11 @@ static void __init arm_bootmem_free(struct meminfo *mi)
>        arch_adjust_zones(zone_size, zhole_size);
>
>        free_area_init_node(0, zone_size, min, zhole_size);
> +
> +       for_each_bank(i, mi) {
> +               mark_memmap_hole(bank_pfn_start(&mi->bank[i]),
> +                               bank_pfn_end(&mi->bank[i]), true);
> +       }
>  }
>
>  #ifndef CONFIG_SPARSEMEM
> @@ -386,8 +391,10 @@ free_memmap(unsigned long start_pfn, unsigned long end_pfn)
>         * If there are free pages between these,
>         * free the section of the memmap array.
>         */
> -       if (pg < pgend)
> +       if (pg < pgend) {
> +               mark_memmap_hole(pg >> PAGE_SHIFT, pgend >> PAGE_SHIFT, false);
>                free_bootmem(pg, pgend - pg);
> +       }
>  }
>
>  /*
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 9ed9c45..2ed9728 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -15,6 +15,7 @@
>  #include <linux/seqlock.h>
>  #include <linux/nodemask.h>
>  #include <linux/pageblock-flags.h>
> +#include <linux/mm_types.h>
>  #include <generated/bounds.h>
>  #include <asm/atomic.h>
>  #include <asm/page.h>
> @@ -1047,11 +1048,29 @@ static inline struct mem_section *__pfn_to_section(unsigned long pfn)
>        return __nr_to_section(pfn_to_section_nr(pfn));
>  }
>
> +void mark_memmap_hole(unsigned long start, unsigned long end, bool valid);
> +
> +#ifdef CONFIG_SPARSEMEM_HAS_HOLE
> +static inline int page_valid(struct mem_section *ms, unsigned long pfn)
> +{
> +       struct page *page = pfn_to_page(pfn);
> +       struct page *__pg = virt_to_page(page);
> +       return __pg->private == (unsigned long)ms;
> +}
> +#else
> +static inline int page_valid(struct mem_section *ms, unsigned long pfn)
> +{
> +       return 1;
> +}
> +#endif
> +
>  static inline int pfn_valid(unsigned long pfn)
>  {
> +       struct mem_section *ms;
>        if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
>                return 0;
> -       return valid_section(__nr_to_section(pfn_to_section_nr(pfn)));
> +       ms = __nr_to_section(pfn_to_section_nr(pfn));
> +       return valid_section(ms) && page_valid(ms, pfn);
>  }
>
>  static inline int pfn_present(unsigned long pfn)
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 527136b..959ac1d 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -128,6 +128,11 @@ config SPARSEMEM_VMEMMAP
>         pfn_to_page and page_to_pfn operations.  This is the most
>         efficient option when sufficient kernel resources are available.
>
> +config SPARSEMEM_HAS_HOLE
> +       bool "allow holes in sparsemem's memmap"
> +       depends on ARM && SPARSEMEM && !SPARSEMEM_VMEMMAP
> +       default n
> +
>  # eventually, we can have this option just 'select SPARSEMEM'
>  config MEMORY_HOTPLUG
>        bool "Allow for memory hot-add"
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 95ac219..76d5012 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -615,6 +615,47 @@ void __init sparse_init(void)
>        free_bootmem(__pa(usemap_map), size);
>  }
>
> +#ifdef CONFIG_SPARSEMEM_HAS_HOLE
> +/*
> + * Fill memmap's pg->private with a pointer to mem_section.
> + * pfn_valid() will check this later. (see include/linux/mmzone.h)
> + * Evenry arch should call
> + *     mark_memmap_hole(start, end, true) # for all allocated mem_map
> + *     and, after that,
> + *     mark_memmap_hole(start, end, false) # for all holes in mem_map.
> + * please see usage in ARM.
> + */
> +void mark_memmap_hole(unsigned long start, unsigned long end, bool valid)
> +{
> +       struct mem_section *ms;
> +       unsigned long pos, next;
> +       struct page *pg;
> +       void *memmap, *mapend;
> +
> +       for (pos = start; pos < end; pos = next) {
> +               next = (pos + PAGES_PER_SECTION) & PAGE_SECTION_MASK;
> +               ms = __pfn_to_section(pos);
> +               if (!valid_section(ms))
> +                       continue;
> +
> +               for (memmap = (void*)pfn_to_page(pos),
> +                       /* The last page in section */
> +                       mapend = pfn_to_page(next-1);
> +                       memmap < mapend; memmap += PAGE_SIZE) {
> +                       pg = virt_to_page(memmap);
> +                       if (valid)
> +                               pg->private = (unsigned long)ms;
> +                       else
> +                               pg->private = 0;
> +               }
> +       }
> +}
> +#else
> +void mark_memmap_hole(unsigned long start, unsigned long end, bool valid)
> +{
> +}
> +#endif
> +
>  #ifdef CONFIG_MEMORY_HOTPLUG
>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
>  static inline struct page *kmalloc_section_memmap(unsigned long pnum, int nid,
> --
> 1.7.0.5
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
