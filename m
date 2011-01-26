Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab1AZXMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 18:12:06 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62687 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab1AZXME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 18:12:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DL0hqqAqO6JyBhJeLseR2tPXAVTyLt4g9KNgebVxxEyIjiUfddfVgO4xJ8kTp8qC+0
         3ArQI16GPYs8WooUeurxWQkqmBHmZpCTi0KL/MB27i8ZXXOgW1+ELXHw1Z9/w1gcjnKc
         fDOt3/mtYB3nOkgwi6SMxV50MCGR1TwHumRl0=
MIME-Version: 1.0
In-Reply-To: <20110125051015.13762.13429.stgit@localhost6.localdomain6>
References: <20110125051003.13762.35120.stgit@localhost6.localdomain6>
	<20110125051015.13762.13429.stgit@localhost6.localdomain6>
Date: Thu, 27 Jan 2011 08:12:02 +0900
Message-ID: <AANLkTikHLw0Qg+odOB-bDtBSB-5UbTJ5ZOM-ZAdMqXgh@mail.gmail.com>
Subject: Re: [PATCH 3/3] Provide control over unmapped pages (v4)
From: Minchan Kim <minchan.kim@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir,

On Tue, Jan 25, 2011 at 2:10 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> Changelog v4
> 1. Add max_unmapped_ratio and use that as the upper limit
> to check when to shrink the unmapped page cache (Christoph
> Lameter)
>
> Changelog v2
> 1. Use a config option to enable the code (Andrew Morton)
> 2. Explain the magic tunables in the code or at-least attempt
>   to explain them (General comment)
> 3. Hint uses of the boot parameter with unlikely (Andrew Morton)
> 4. Use better names (balanced is not a good naming convention)
>
> Provide control using zone_reclaim() and a boot parameter. The
> code reuses functionality from zone_reclaim() to isolate unmapped
> pages and reclaim them as a priority, ahead of other mapped pages.
> A new sysctl for max_unmapped_ratio is provided and set to 16,
> indicating 16% of the total zone pages are unmapped, we start
> shrinking unmapped page cache.
>
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
>  Documentation/kernel-parameters.txt |    8 +++
>  include/linux/mmzone.h              |    5 ++
>  include/linux/swap.h                |   23 ++++++++-
>  init/Kconfig                        |   12 +++++
>  kernel/sysctl.c                     |   11 ++++
>  mm/page_alloc.c                     |   25 ++++++++++
>  mm/vmscan.c                         |   87 +++++++++++++++++++++++++++++++++++
>  7 files changed, 166 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index fee5f57..65a4ee6 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2500,6 +2500,14 @@ and is between 256 and 4096 characters. It is defined in the file
>                        [X86]
>                        Set unknown_nmi_panic=1 early on boot.
>
> +       unmapped_page_control
> +                       [KNL] Available if CONFIG_UNMAPPED_PAGECACHE_CONTROL
> +                       is enabled. It controls the amount of unmapped memory
> +                       that is present in the system. This boot option plus
> +                       vm.min_unmapped_ratio (sysctl) provide granular control
> +                       over how much unmapped page cache can exist in the system
> +                       before kswapd starts reclaiming unmapped page cache pages.
> +
>        usbcore.autosuspend=
>                        [USB] The autosuspend time delay (in seconds) used
>                        for newly-detected USB devices (default 2).  This
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 2485acc..18f0f09 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -306,7 +306,10 @@ struct zone {
>        /*
>         * zone reclaim becomes active if more unmapped pages exist.
>         */
> +#if defined(CONFIG_UNMAPPED_PAGE_CONTROL) || defined(CONFIG_NUMA)
>        unsigned long           min_unmapped_pages;
> +       unsigned long           max_unmapped_pages;
> +#endif
>  #ifdef CONFIG_NUMA
>        int node;
>        unsigned long           min_slab_pages;
> @@ -773,6 +776,8 @@ int percpu_pagelist_fraction_sysctl_handler(struct ctl_table *, int,
>                                        void __user *, size_t *, loff_t *);
>  int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *, int,
>                        void __user *, size_t *, loff_t *);
> +int sysctl_max_unmapped_ratio_sysctl_handler(struct ctl_table *, int,
> +                       void __user *, size_t *, loff_t *);
>  int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *, int,
>                        void __user *, size_t *, loff_t *);
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 7b75626..ae62a03 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -255,19 +255,34 @@ extern int vm_swappiness;
>  extern int remove_mapping(struct address_space *mapping, struct page *page);
>  extern long vm_total_pages;
>
> +#if defined(CONFIG_UNMAPPED_PAGECACHE_CONTROL) || defined(CONFIG_NUMA)
>  extern int sysctl_min_unmapped_ratio;
> +extern int sysctl_max_unmapped_ratio;
> +
>  extern int zone_reclaim(struct zone *, gfp_t, unsigned int);
> -#ifdef CONFIG_NUMA
> -extern int zone_reclaim_mode;
> -extern int sysctl_min_slab_ratio;
>  #else
> -#define zone_reclaim_mode 0
>  static inline int zone_reclaim(struct zone *z, gfp_t mask, unsigned int order)
>  {
>        return 0;
>  }
>  #endif
>
> +#if defined(CONFIG_UNMAPPED_PAGECACHE_CONTROL)
> +extern bool should_reclaim_unmapped_pages(struct zone *zone);
> +#else
> +static inline bool should_reclaim_unmapped_pages(struct zone *zone)
> +{
> +       return false;
> +}
> +#endif
> +
> +#ifdef CONFIG_NUMA
> +extern int zone_reclaim_mode;
> +extern int sysctl_min_slab_ratio;
> +#else
> +#define zone_reclaim_mode 0
> +#endif
> +
>  extern int page_evictable(struct page *page, struct vm_area_struct *vma);
>  extern void scan_mapping_unevictable_pages(struct address_space *);
>
> diff --git a/init/Kconfig b/init/Kconfig
> index 4f6cdbf..2dfbc09 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -828,6 +828,18 @@ config SCHED_AUTOGROUP
>  config MM_OWNER
>        bool
>
> +config UNMAPPED_PAGECACHE_CONTROL
> +       bool "Provide control over unmapped page cache"
> +       default n
> +       help
> +         This option adds support for controlling unmapped page cache
> +         via a boot parameter (unmapped_page_control). The boot parameter
> +         with sysctl (vm.min_unmapped_ratio) control the total number
> +         of unmapped pages in the system. This feature is useful if
> +         you want to limit the amount of unmapped page cache or want
> +         to reduce page cache duplication in a virtualized environment.
> +         If unsure say 'N'
> +
>  config SYSFS_DEPRECATED
>        bool "enable deprecated sysfs features to support old userspace tools"
>        depends on SYSFS
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 12e8f26..63dbba6 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1224,6 +1224,7 @@ static struct ctl_table vm_table[] = {
>                .extra1         = &zero,
>        },
>  #endif
> +#if defined(CONFIG_UNMAPPED_PAGE_CONTROL) || defined(CONFIG_NUMA)
>        {
>                .procname       = "min_unmapped_ratio",
>                .data           = &sysctl_min_unmapped_ratio,
> @@ -1233,6 +1234,16 @@ static struct ctl_table vm_table[] = {
>                .extra1         = &zero,
>                .extra2         = &one_hundred,
>        },
> +       {
> +               .procname       = "max_unmapped_ratio",
> +               .data           = &sysctl_max_unmapped_ratio,
> +               .maxlen         = sizeof(sysctl_max_unmapped_ratio),
> +               .mode           = 0644,
> +               .proc_handler   = sysctl_max_unmapped_ratio_sysctl_handler,
> +               .extra1         = &zero,
> +               .extra2         = &one_hundred,
> +       },
> +#endif
>  #ifdef CONFIG_NUMA
>        {
>                .procname       = "zone_reclaim_mode",
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 7b56473..2ac8549 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1660,6 +1660,9 @@ zonelist_scan:
>                        unsigned long mark;
>                        int ret;
>
> +                       if (should_reclaim_unmapped_pages(zone))
> +                               wakeup_kswapd(zone, order, classzone_idx);
> +

Do we really need the check in fastpath?
There are lost of caller of alloc_pages.
Many of them are not related to mapped pages.
Could we move the check into add_to_page_cache_locked?

>                        mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
>                        if (zone_watermark_ok(zone, order, mark,
>                                    classzone_idx, alloc_flags))
> @@ -4167,8 +4170,12 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
>
>                zone->spanned_pages = size;
>                zone->present_pages = realsize;
> +#if defined(CONFIG_UNMAPPED_PAGE_CONTROL) || defined(CONFIG_NUMA)
>                zone->min_unmapped_pages = (realsize*sysctl_min_unmapped_ratio)
>                                                / 100;
> +               zone->max_unmapped_pages = (realsize*sysctl_max_unmapped_ratio)
> +                                               / 100;
> +#endif
>  #ifdef CONFIG_NUMA
>                zone->node = nid;
>                zone->min_slab_pages = (realsize * sysctl_min_slab_ratio) / 100;
> @@ -5084,6 +5091,7 @@ int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
>        return 0;
>  }
>
> +#if defined(CONFIG_UNMAPPED_PAGE_CONTROL) || defined(CONFIG_NUMA)
>  int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
>        void __user *buffer, size_t *length, loff_t *ppos)
>  {
> @@ -5100,6 +5108,23 @@ int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
>        return 0;
>  }
>
> +int sysctl_max_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
> +       void __user *buffer, size_t *length, loff_t *ppos)
> +{
> +       struct zone *zone;
> +       int rc;
> +
> +       rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
> +       if (rc)
> +               return rc;
> +
> +       for_each_zone(zone)
> +               zone->max_unmapped_pages = (zone->present_pages *
> +                               sysctl_max_unmapped_ratio) / 100;
> +       return 0;
> +}
> +#endif
> +
>  #ifdef CONFIG_NUMA
>  int sysctl_min_slab_ratio_sysctl_handler(ctl_table *table, int write,
>        void __user *buffer, size_t *length, loff_t *ppos)
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 02cc82e..6377411 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -159,6 +159,29 @@ static DECLARE_RWSEM(shrinker_rwsem);
>  #define scanning_global_lru(sc)        (1)
>  #endif
>
> +#if defined(CONFIG_UNMAPPED_PAGECACHE_CONTROL)
> +static unsigned long reclaim_unmapped_pages(int priority, struct zone *zone,
> +                                               struct scan_control *sc);
> +static int unmapped_page_control __read_mostly;
> +
> +static int __init unmapped_page_control_parm(char *str)
> +{
> +       unmapped_page_control = 1;
> +       /*
> +        * XXX: Should we tweak swappiness here?
> +        */
> +       return 1;
> +}
> +__setup("unmapped_page_control", unmapped_page_control_parm);
> +
> +#else /* !CONFIG_UNMAPPED_PAGECACHE_CONTROL */
> +static inline unsigned long reclaim_unmapped_pages(int priority,
> +                               struct zone *zone, struct scan_control *sc)
> +{
> +       return 0;
> +}
> +#endif
> +
>  static struct zone_reclaim_stat *get_reclaim_stat(struct zone *zone,
>                                                  struct scan_control *sc)
>  {
> @@ -2359,6 +2382,12 @@ loop_again:
>                                shrink_active_list(SWAP_CLUSTER_MAX, zone,
>                                                        &sc, priority, 0);
>
> +                       /*
> +                        * We do unmapped page reclaim once here and once
> +                        * below, so that we don't lose out
> +                        */
> +                       reclaim_unmapped_pages(priority, zone, &sc);
> +
>                        if (!zone_watermark_ok_safe(zone, order,
>                                        high_wmark_pages(zone), 0, 0)) {
>                                end_zone = i;
> @@ -2396,6 +2425,11 @@ loop_again:
>                                continue;
>
>                        sc.nr_scanned = 0;
> +                       /*
> +                        * Reclaim unmapped pages upfront, this should be
> +                        * really cheap
> +                        */
> +                       reclaim_unmapped_pages(priority, zone, &sc);

Why should we do by two phase?
It's not a direct reclaim path. I mean it doesn't need to reclaim tighly
If we can't reclaim enough, next allocation would wake up kswapd again
and kswapd try it again.

And I have a concern. I already pointed out.
If memory pressure is heavy and unmappd_pages is more than our
threshold, this can move inactive's tail pages which are mapped into
heads by reclaim_unmapped_pages. It can make confusing LRU order so
working set can be evicted.

zone_reclaim is used by only NUMA until now but you are opening it in the world.
I think it would be a good feature in embedded system, too.
I hope we care of working set eviction problem.

-- 
Kind regards,
Minchan Kim
