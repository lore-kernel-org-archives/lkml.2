Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab3AGIwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 03:52:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33303 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab3AGIwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 03:52:39 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50EA8CA2.7020608@jp.fujitsu.com>
Date: Mon, 07 Jan 2013 17:51:46 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Glauber Costa <glommer@parallels.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 1/2] Add mempressure cgroup
References: <20130104082751.GA22227@lizard.gateway.2wire.net> <1357288152-23625-1-git-send-email-anton.vorontsov@linaro.org>
In-Reply-To: <1357288152-23625-1-git-send-email-anton.vorontsov@linaro.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/01/04 17:29), Anton Vorontsov wrote:
> This commit implements David Rientjes' idea of mempressure cgroup.
> 
> The main characteristics are the same to what I've tried to add to vmevent
> API; internally, it uses Mel Gorman's idea of scanned/reclaimed ratio for
> pressure index calculation. But we don't expose the index to the userland.
> Instead, there are three levels of the pressure:
> 
>   o low (just reclaiming, e.g. caches are draining);
>   o medium (allocation cost becomes high, e.g. swapping);
>   o oom (about to oom very soon).
> 
> The rationale behind exposing levels and not the raw pressure index
> described here: http://lkml.org/lkml/2012/11/16/675
> 
> For a task it is possible to be in both cpusets, memcg and mempressure
> cgroups, so by rearranging the tasks it is possible to watch a specific
> pressure (i.e. caused by cpuset and/or memcg).
> 
> Note that while this adds the cgroups support, the code is well separated
> and eventually we might add a lightweight, non-cgroups API, i.e. vmevent.
> But this is another story.
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

I'm just curious..
 
> ---
>   Documentation/cgroups/mempressure.txt |  50 ++++++
>   include/linux/cgroup_subsys.h         |   6 +
>   include/linux/vmstat.h                |  11 ++
>   init/Kconfig                          |  12 ++
>   mm/Makefile                           |   1 +
>   mm/mempressure.c                      | 330 ++++++++++++++++++++++++++++++++++
>   mm/vmscan.c                           |   4 +
>   7 files changed, 414 insertions(+)
>   create mode 100644 Documentation/cgroups/mempressure.txt
>   create mode 100644 mm/mempressure.c
> 
> diff --git a/Documentation/cgroups/mempressure.txt b/Documentation/cgroups/mempressure.txt
> new file mode 100644
> index 0000000..dbc0aca
> --- /dev/null
> +++ b/Documentation/cgroups/mempressure.txt
> @@ -0,0 +1,50 @@
> +  Memory pressure cgroup
> +~~~~~~~~~~~~~~~~~~~~~~~~~~
> +  Before using the mempressure cgroup, make sure you have it mounted:
> +
> +   # cd /sys/fs/cgroup/
> +   # mkdir mempressure
> +   # mount -t cgroup cgroup ./mempressure -o mempressure
> +
> +  It is possible to combine cgroups, for example you can mount memory
> +  (memcg) and mempressure cgroups together:
> +
> +   # mount -t cgroup cgroup ./mempressure -o memory,mempressure
> +
> +  That way the reported pressure will honour memory cgroup limits. The
> +  same goes for cpusets.
> +
> +  After the hierarchy is mounted, you can use the following API:
> +
> +  /sys/fs/cgroup/.../mempressure.level
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +  To maintain the interactivity/memory allocation cost, one can use the
> +  pressure level notifications, and the levels are defined like this:
> +
> +  The "low" level means that the system is reclaiming memory for new
> +  allocations. Monitoring reclaiming activity might be useful for
> +  maintaining overall system's cache level. Upon notification, the program
> +  (typically "Activity Manager") might analyze vmstat and act in advance
> +  (i.e. prematurely shutdown unimportant services).
> +
> +  The "medium" level means that the system is experiencing medium memory
> +  pressure, there is some mild swapping activity. Upon this event
> +  applications may decide to free any resources that can be easily
> +  reconstructed or re-read from a disk.
> +
> +  The "oom" level means that the system is actively thrashing, it is about
> +  to out of memory (OOM) or even the in-kernel OOM killer is on its way to
> +  trigger. Applications should do whatever they can to help the system.
> +
> +  Event control:
> +    Is used to setup an eventfd with a level threshold. The argument to
> +    the event control specifies the level threshold.
> +  Read:
> +    Reads mempory presure levels: low, medium or oom.
> +  Write:
> +    Not implemented.
> +  Test:
> +    To set up a notification:
> +
> +    # cgroup_event_listener ./mempressure.level low
> +    ("low", "medium", "oom" are permitted.)
> diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
> index f204a7a..b9802e2 100644
> --- a/include/linux/cgroup_subsys.h
> +++ b/include/linux/cgroup_subsys.h
> @@ -37,6 +37,12 @@ SUBSYS(mem_cgroup)
>   
>   /* */
>   
> +#if IS_SUBSYS_ENABLED(CONFIG_CGROUP_MEMPRESSURE)
> +SUBSYS(mpc_cgroup)
> +#endif
> +
> +/* */
> +
>   #if IS_SUBSYS_ENABLED(CONFIG_CGROUP_DEVICE)
>   SUBSYS(devices)
>   #endif
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index a13291f..c1a66c7 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -10,6 +10,17 @@
>   
>   extern int sysctl_stat_interval;
>   
> +struct mem_cgroup;
> +#ifdef CONFIG_CGROUP_MEMPRESSURE
> +extern void vmpressure(struct mem_cgroup *memcg,
> +		       ulong scanned, ulong reclaimed);
> +extern void vmpressure_prio(struct mem_cgroup *memcg, int prio);
> +#else
> +static inline void vmpressure(struct mem_cgroup *memcg,
> +			      ulong scanned, ulong reclaimed) {}
> +static inline void vmpressure_prio(struct mem_cgroup *memcg, int prio) {}
> +#endif
> +
>   #ifdef CONFIG_VM_EVENT_COUNTERS
>   /*
>    * Light weight per cpu counter implementation.
> diff --git a/init/Kconfig b/init/Kconfig
> index 7d30240..d526249 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -891,6 +891,18 @@ config MEMCG_KMEM
>   	  the kmem extension can use it to guarantee that no group of processes
>   	  will ever exhaust kernel resources alone.
>   
> +config CGROUP_MEMPRESSURE
> +	bool "Memory pressure monitor for Control Groups"
> +	help
> +	  The memory pressure monitor cgroup provides a facility for
> +	  userland programs so that they could easily assist the kernel
> +	  with the memory management. So far the API provides simple,
> +	  levels-based memory pressure notifications.
> +
> +	  For more information see Documentation/cgroups/mempressure.txt
> +
> +	  If unsure, say N.
> +
>   config CGROUP_HUGETLB
>   	bool "HugeTLB Resource Controller for Control Groups"
>   	depends on RESOURCE_COUNTERS && HUGETLB_PAGE && EXPERIMENTAL
> diff --git a/mm/Makefile b/mm/Makefile
> index 3a46287..e69bbda 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -51,6 +51,7 @@ obj-$(CONFIG_MIGRATION) += migrate.o
>   obj-$(CONFIG_QUICKLIST) += quicklist.o
>   obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o
>   obj-$(CONFIG_MEMCG) += memcontrol.o page_cgroup.o
> +obj-$(CONFIG_CGROUP_MEMPRESSURE) += mempressure.o
>   obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
>   obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
>   obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
> diff --git a/mm/mempressure.c b/mm/mempressure.c
> new file mode 100644
> index 0000000..ea312bb
> --- /dev/null
> +++ b/mm/mempressure.c
> @@ -0,0 +1,330 @@
> +/*
> + * Linux VM pressure
> + *
> + * Copyright 2012 Linaro Ltd.
> + *		  Anton Vorontsov <anton.vorontsov@linaro.org>
> + *
> + * Based on ideas from Andrew Morton, David Rientjes, KOSAKI Motohiro,
> + * Leonid Moiseichuk, Mel Gorman, Minchan Kim and Pekka Enberg.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + */
> +
> +#include <linux/cgroup.h>
> +#include <linux/fs.h>
> +#include <linux/sched.h>
> +#include <linux/mm.h>
> +#include <linux/vmstat.h>
> +#include <linux/eventfd.h>
> +#include <linux/swap.h>
> +#include <linux/printk.h>
> +
> +static void mpc_vmpressure(struct mem_cgroup *memcg, ulong s, ulong r);
> +
> +/*
> + * Generic VM Pressure routines (no cgroups or any other API details)
> + */
> +
> +/*
> + * The window size is the number of scanned pages before we try to analyze
> + * the scanned/reclaimed ratio (or difference).
> + *
> + * It is used as a rate-limit tunable for the "low" level notification,
> + * and for averaging medium/oom levels. Using small window sizes can cause
> + * lot of false positives, but too big window size will delay the
> + * notifications.
> + */
> +static const uint vmpressure_win = SWAP_CLUSTER_MAX * 16;
> +static const uint vmpressure_level_med = 60;
> +static const uint vmpressure_level_oom = 99;
> +static const uint vmpressure_level_oom_prio = 4;
> +

Hmm... isn't this window size too small ?
If vmscan cannot find a reclaimable page while scanning 2M of pages in a zone,
oom notify will be returned. Right ?

Thanks,
-Kame

