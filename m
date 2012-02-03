Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab2BCOT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:19:57 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52413 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab2BCOT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:19:56 -0500
MIME-Version: 1.0
In-Reply-To: <1328271538-14502-9-git-send-email-m.szyprowski@samsung.com>
References: <1328271538-14502-1-git-send-email-m.szyprowski@samsung.com>
	<1328271538-14502-9-git-send-email-m.szyprowski@samsung.com>
Date: Fri, 3 Feb 2012 22:19:54 +0800
Message-ID: <CAJd=RBByc_wLEJTK66J4eY03CWnCoCRiwAeEYjXCZ5xEZhp3ag@mail.gmail.com>
Subject: Re: [PATCH 08/15] mm: mmzone: MIGRATE_CMA migration type added
From: Hillf Danton <dhillf@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Marek

On Fri, Feb 3, 2012 at 8:18 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>
> The MIGRATE_CMA migration type has two main characteristics:
> (i) only movable pages can be allocated from MIGRATE_CMA
> pageblocks and (ii) page allocator will never change migration
> type of MIGRATE_CMA pageblocks.
>
> This guarantees (to some degree) that page in a MIGRATE_CMA page
> block can always be migrated somewhere else (unless there's no
> memory left in the system).
>
> It is designed to be used for allocating big chunks (eg. 10MiB)
> of physically contiguous memory.  Once driver requests
> contiguous memory, pages from MIGRATE_CMA pageblocks may be
> migrated away to create a contiguous block.
>
> To minimise number of migrations, MIGRATE_CMA migration type
> is the last type tried when page allocator falls back to other
> migration types then requested.
>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Tested-by: Rob Clark <rob.clark@linaro.org>
> Tested-by: Ohad Ben-Cohen <ohad@wizery.com>
> Tested-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> ---
>  include/linux/gfp.h    |    3 ++
>  include/linux/mmzone.h |   38 +++++++++++++++++++----
>  mm/Kconfig             |    2 +-
>  mm/compaction.c        |   11 +++++--
>  mm/page_alloc.c        |   78 ++++++++++++++++++++++++++++++++++++++----------
>  mm/vmstat.c            |    3 ++
>  6 files changed, 108 insertions(+), 27 deletions(-)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 052a5b6..78d32a7 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -397,6 +397,9 @@ static inline bool pm_suspended_storage(void)
>  extern int alloc_contig_range(unsigned long start, unsigned long end);
>  extern void free_contig_range(unsigned long pfn, unsigned nr_pages);
>
> +/* CMA stuff */
> +extern void init_cma_reserved_pageblock(struct page *page);
> +
>  #endif
>
>  #endif /* __LINUX_GFP_H */
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 650ba2f..82f4fa5 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -35,13 +35,37 @@
>  */
>  #define PAGE_ALLOC_COSTLY_ORDER 3
>
> -#define MIGRATE_UNMOVABLE     0
> -#define MIGRATE_RECLAIMABLE   1
> -#define MIGRATE_MOVABLE       2
> -#define MIGRATE_PCPTYPES      3 /* the number of types on the pcp lists */
> -#define MIGRATE_RESERVE       3
> -#define MIGRATE_ISOLATE       4 /* can't allocate from here */
> -#define MIGRATE_TYPES         5
> +enum {
> +       MIGRATE_UNMOVABLE,
> +       MIGRATE_RECLAIMABLE,
> +       MIGRATE_MOVABLE,
> +       MIGRATE_PCPTYPES,       /* the number of types on the pcp lists */
> +       MIGRATE_RESERVE = MIGRATE_PCPTYPES,
> +#ifdef CONFIG_CMA
> +       /*
> +        * MIGRATE_CMA migration type is designed to mimic the way
> +        * ZONE_MOVABLE works.  Only movable pages can be allocated
> +        * from MIGRATE_CMA pageblocks and page allocator never
> +        * implicitly change migration type of MIGRATE_CMA pageblock.
> +        *
> +        * The way to use it is to change migratetype of a range of
> +        * pageblocks to MIGRATE_CMA which can be done by
> +        * __free_pageblock_cma() function.  What is important though
> +        * is that a range of pageblocks must be aligned to
> +        * MAX_ORDER_NR_PAGES should biggest page be bigger then
> +        * a single pageblock.
> +        */
> +       MIGRATE_CMA,
> +#endif
> +       MIGRATE_ISOLATE,        /* can't allocate from here */
> +       MIGRATE_TYPES
> +};
> +
> +#ifdef CONFIG_CMA
> +#  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
> +#else
> +#  define is_migrate_cma(migratetype) false
> +#endif
>
>  #define for_each_migratetype_order(order, type) \
>        for (order = 0; order < MAX_ORDER; order++) \
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e338407..3922002 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -198,7 +198,7 @@ config COMPACTION
>  config MIGRATION
>        bool "Page migration"
>        def_bool y
> -       depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE || COMPACTION
> +       depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE || COMPACTION || CMA
>        help
>          Allows the migration of the physical location of pages of processes
>          while the virtual addresses are not changed. This is useful in
> diff --git a/mm/compaction.c b/mm/compaction.c
> index d5174c4..a6e7c64 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -45,6 +45,11 @@ static void map_pages(struct list_head *list)
>        }
>  }
>
> +static inline bool migrate_async_suitable(int migratetype)

Just nitpick, since the helper is not directly related to what async means,
how about migrate_suitable(int migrate_type) ?

> +{
> +       return is_migrate_cma(migratetype) || migratetype == MIGRATE_MOVABLE;
> +}
> +
>  /*
>  * Isolate free pages onto a private freelist. Caller must hold zone->lock.
>  * If @strict is true, will abort returning 0 on any invalid PFNs or non-free
> @@ -277,7 +282,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>                 */
>                pageblock_nr = low_pfn >> pageblock_order;
>                if (!cc->sync && last_pageblock_nr != pageblock_nr &&
> -                               get_pageblock_migratetype(page) != MIGRATE_MOVABLE) {
> +                   migrate_async_suitable(get_pageblock_migratetype(page))) {

Here compaction looks corrupted if CMA not enabled, Mel?

btw, Kame-san is not Cced correctly 8;/

Hillf
