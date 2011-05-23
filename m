Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab1EWR0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:26:30 -0400
Received: from smtp-out.google.com ([74.125.121.67]:2329 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab1EWR02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:26:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ylfcNTqxav9CLiVy403n2FTBNTpg5txx4b9cu8u0dV1U4Z5WFTCCPyUrS56TjTMuEF
         yKf80eSSVs67mK2jJWOg==
MIME-Version: 1.0
In-Reply-To: <20110520124312.5928aa92.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110520123749.d54b32fa.kamezawa.hiroyu@jp.fujitsu.com>
	<20110520124312.5928aa92.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 23 May 2011 10:26:22 -0700
Message-ID: <BANLkTi=7-xgUetav9s5fvZ8e+U986Y4Z7w@mail.gmail.com>
Subject: Re: [PATCH 0/8] memcg: clean up, export swapiness
From: Ying Han <yinghan@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        hannes@cmpxchg.org, Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kame:

Is this patch part of the "memcg async reclaim v2" patchset? I am
trying to do some tests on top of that, but having hard time finding
the [PATCH 3/8] and [PATCH 5/8].

--Ying

On Thu, May 19, 2011 at 8:43 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> From: Ying Han <yinghan@google.com>
> change mem_cgroup's swappiness interface.
>
> Now, memcg's swappiness interface is defined as 'static' and
> the value is passed as an argument to try_to_free_xxxx...
>
> This patch adds an function mem_cgroup_swappiness() and export it,
> reduce arguments. This interface will be used in async reclaim, later.
>
> I think an function is better than passing arguments because it's
> clearer where the swappiness comes from to scan_control.
>
> Signed-off-by: Ying Han <yinghan@google.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/memcontrol.h |    1 +
>  include/linux/swap.h       |    4 +---
>  mm/memcontrol.c            |   14 ++++++--------
>  mm/vmscan.c                |    9 ++++-----
>  4 files changed, 12 insertions(+), 16 deletions(-)
>
> Index: mmotm-May11/include/linux/memcontrol.h
> ===================================================================
> --- mmotm-May11.orig/include/linux/memcontrol.h
> +++ mmotm-May11/include/linux/memcontrol.h
> @@ -112,6 +112,7 @@ unsigned long
>  mem_cgroup_zone_reclaimable_pages(struct mem_cgroup *memcg, int nid, int zid);
>  bool mem_cgroup_test_reclaimable(struct mem_cgroup *memcg);
>  int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
> +unsigned int mem_cgroup_swappiness(struct mem_cgroup *memcg);
>  unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
>                                       struct zone *zone,
>                                       enum lru_list lru);
> Index: mmotm-May11/mm/memcontrol.c
> ===================================================================
> --- mmotm-May11.orig/mm/memcontrol.c
> +++ mmotm-May11/mm/memcontrol.c
> @@ -1285,7 +1285,7 @@ static unsigned long mem_cgroup_margin(s
>        return margin >> PAGE_SHIFT;
>  }
>
> -static unsigned int get_swappiness(struct mem_cgroup *memcg)
> +unsigned int mem_cgroup_swappiness(struct mem_cgroup *memcg)
>  {
>        struct cgroup *cgrp = memcg->css.cgroup;
>
> @@ -1687,14 +1687,13 @@ static int mem_cgroup_hierarchical_recla
>                /* we use swappiness of local cgroup */
>                if (check_soft) {
>                        ret = mem_cgroup_shrink_node_zone(victim, gfp_mask,
> -                               noswap, get_swappiness(victim), zone,
> -                               &nr_scanned);
> +                               noswap, zone, &nr_scanned);
>                        *total_scanned += nr_scanned;
>                        mem_cgroup_soft_steal(victim, is_kswapd, ret);
>                        mem_cgroup_soft_scan(victim, is_kswapd, nr_scanned);
>                } else
>                        ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
> -                                               noswap, get_swappiness(victim));
> +                                       noswap);
>                css_put(&victim->css);
>                /*
>                 * At shrinking usage, we can't check we should stop here or
> @@ -3717,8 +3716,7 @@ try_to_free:
>                        ret = -EINTR;
>                        goto out;
>                }
> -               progress = try_to_free_mem_cgroup_pages(mem, GFP_KERNEL,
> -                                               false, get_swappiness(mem));
> +               progress = try_to_free_mem_cgroup_pages(mem, GFP_KERNEL, false);
>                if (!progress) {
>                        nr_retries--;
>                        /* maybe some writeback is necessary */
> @@ -4150,7 +4148,7 @@ static u64 mem_cgroup_swappiness_read(st
>  {
>        struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
>
> -       return get_swappiness(memcg);
> +       return mem_cgroup_swappiness(memcg);
>  }
>
>  static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
> @@ -4836,7 +4834,7 @@ mem_cgroup_create(struct cgroup_subsys *
>        INIT_LIST_HEAD(&mem->oom_notify);
>
>        if (parent)
> -               mem->swappiness = get_swappiness(parent);
> +               mem->swappiness = mem_cgroup_swappiness(parent);
>        atomic_set(&mem->refcnt, 1);
>        mem->move_charge_at_immigrate = 0;
>        mutex_init(&mem->thresholds_lock);
> Index: mmotm-May11/include/linux/swap.h
> ===================================================================
> --- mmotm-May11.orig/include/linux/swap.h
> +++ mmotm-May11/include/linux/swap.h
> @@ -252,11 +252,9 @@ static inline void lru_cache_add_file(st
>  extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>                                        gfp_t gfp_mask, nodemask_t *mask);
>  extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
> -                                                 gfp_t gfp_mask, bool noswap,
> -                                                 unsigned int swappiness);
> +                                                 gfp_t gfp_mask, bool noswap);
>  extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
>                                                gfp_t gfp_mask, bool noswap,
> -                                               unsigned int swappiness,
>                                                struct zone *zone,
>                                                unsigned long *nr_scanned);
>  extern int __isolate_lru_page(struct page *page, int mode, int file);
> Index: mmotm-May11/mm/vmscan.c
> ===================================================================
> --- mmotm-May11.orig/mm/vmscan.c
> +++ mmotm-May11/mm/vmscan.c
> @@ -2178,7 +2178,6 @@ unsigned long try_to_free_pages(struct z
>
>  unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
>                                                gfp_t gfp_mask, bool noswap,
> -                                               unsigned int swappiness,
>                                                struct zone *zone,
>                                                unsigned long *nr_scanned)
>  {
> @@ -2188,7 +2187,6 @@ unsigned long mem_cgroup_shrink_node_zon
>                .may_writepage = !laptop_mode,
>                .may_unmap = 1,
>                .may_swap = !noswap,
> -               .swappiness = swappiness,
>                .order = 0,
>                .mem_cgroup = mem,
>        };
> @@ -2196,6 +2194,8 @@ unsigned long mem_cgroup_shrink_node_zon
>        sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
>                        (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
>
> +       sc.swappiness = mem_cgroup_swappiness(mem);
> +
>        trace_mm_vmscan_memcg_softlimit_reclaim_begin(0,
>                                                      sc.may_writepage,
>                                                      sc.gfp_mask);
> @@ -2217,8 +2217,7 @@ unsigned long mem_cgroup_shrink_node_zon
>
>  unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
>                                           gfp_t gfp_mask,
> -                                          bool noswap,
> -                                          unsigned int swappiness)
> +                                          bool noswap)
>  {
>        struct zonelist *zonelist;
>        unsigned long nr_reclaimed;
> @@ -2228,7 +2227,6 @@ unsigned long try_to_free_mem_cgroup_pag
>                .may_unmap = 1,
>                .may_swap = !noswap,
>                .nr_to_reclaim = SWAP_CLUSTER_MAX,
> -               .swappiness = swappiness,
>                .order = 0,
>                .mem_cgroup = mem_cont,
>                .nodemask = NULL, /* we don't care the placement */
> @@ -2245,6 +2243,7 @@ unsigned long try_to_free_mem_cgroup_pag
>         * scan does not need to be the current node.
>         */
>        nid = mem_cgroup_select_victim_node(mem_cont);
> +       sc.swappiness = mem_cgroup_swappiness(mem_cont);
>
>        zonelist = NODE_DATA(nid)->node_zonelists;
>
>
>
