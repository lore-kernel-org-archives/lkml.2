Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab1E0BVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:21:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53419 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab1E0BVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:21:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 27 May 2011 10:14:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ying Han <yinghan@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH v3 10/10] memcg : reclaim statistics
Message-Id: <20110527101446.73f2499a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTim+hj4Y5wUhB+BHoSOsXdaMYeKqbA@mail.gmail.com>
References: <20110526141047.dc828124.kamezawa.hiroyu@jp.fujitsu.com>
	<20110526143631.adc2c911.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTim+hj4Y5wUhB+BHoSOsXdaMYeKqbA@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011 18:17:04 -0700
Ying Han <yinghan@google.com> wrote:

> Hi Kame:
> 
> I applied the patch on top of mmotm-2011-05-12-15-52. After boot up, i
> keep getting the following crash by reading the
> /dev/cgroup/memory/memory.reclaim_stat
> 
> [  200.776366] Kernel panic - not syncing: Fatal exception
> [  200.781591] Pid: 7535, comm: cat Tainted: G      D W   2.6.39-mcg-DEV #130
> [  200.788463] Call Trace:
> [  200.790916]  [<ffffffff81405a75>] panic+0x91/0x194
> [  200.797096]  [<ffffffff81408ac8>] oops_end+0xae/0xbe
> [  200.803450]  [<ffffffff810398d3>] die+0x5a/0x63
> [  200.809366]  [<ffffffff81408561>] do_trap+0x121/0x130
> [  200.814427]  [<ffffffff81037fe6>] do_divide_error+0x90/0x99
> [#1] SMP
> [  200.821395]  [<ffffffff81112bcb>] ? mem_cgroup_reclaim_stat_read+0x28/0xf0
> [  200.829624]  [<ffffffff81104509>] ? page_add_new_anon_rmap+0x7e/0x90
> [  200.837372]  [<ffffffff810fb7f8>] ? handle_pte_fault+0x28a/0x775
> [  200.844773]  [<ffffffff8140f0f5>] divide_error+0x15/0x20
> [  200.851471]  [<ffffffff81112bcb>] ? mem_cgroup_reclaim_stat_read+0x28/0xf0
> [  200.859729]  [<ffffffff810a4a01>] cgroup_seqfile_show+0x38/0x46
> [  200.867036]  [<ffffffff810a4d72>] ? cgroup_lock+0x17/0x17
> [  200.872444]  [<ffffffff81133f2c>] seq_read+0x182/0x361
> [  200.878984]  [<ffffffff8111a0c4>] vfs_read+0xab/0x107
> [  200.885403]  [<ffffffff8111a1e0>] sys_read+0x4a/0x6e
> [  200.891764]  [<ffffffff8140f469>] sysenter_dispatch+0x7/0x27
> 
> I will debug it, but like to post here in case i missed some patches in between.
> 

It must be mem->scanned is 0 and
     mem->reclaimed * 100 /mem->scanned cause error.

It must be mem->reclaimed * 100 / (mem->scanned +1).

I'll fix. thank you for reporting.

Thanks,
-Kame


> --Ying
> 
> On Wed, May 25, 2011 at 10:36 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > This patch adds a file memory.reclaim_stat.
> >
> > This file shows following.
> > ==
> > recent_scan_success_ratio  12 # recent reclaim/scan ratio.
> > limit_scan_pages 671          # scan caused by hitting limit.
> > limit_freed_pages 538         # freed pages by limit_scan
> > limit_elapsed_ns 518555076    # elapsed time in LRU scanning by limit.
> > soft_scan_pages 0             # scan caused by softlimit.
> > soft_freed_pages 0            # freed pages by soft_scan.
> > soft_elapsed_ns 0             # elapsed time in LRU scanning by softlimit.
> > margin_scan_pages 16744221    # scan caused by auto-keep-margin
> > margin_freed_pages 565943     # freed pages by auto-keep-margin.
> > margin_elapsed_ns 5545388791  # elapsed time in LRU scanning by auto-keep-margin
> >
> > This patch adds a new file rather than adding more stats to memory.stat. By it,
> > this support "reset" accounting by
> >
> >  # echo 0 > .../memory.reclaim_stat
> >
> > This is good for debug and tuning.
> >
> > TODO:
> >  - add Documentaion.
> >
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  mm/memcontrol.c |   87 ++++++++++++++++++++++++++++++++++++++++++++++++++------
> >  1 file changed, 79 insertions(+), 8 deletions(-)
> >
> > Index: memcg_async/mm/memcontrol.c
> > ===================================================================
> > --- memcg_async.orig/mm/memcontrol.c
> > +++ memcg_async/mm/memcontrol.c
> > @@ -216,6 +216,13 @@ static void mem_cgroup_update_margin_to_
> >  static void mem_cgroup_may_async_reclaim(struct mem_cgroup *mem);
> >  static void mem_cgroup_reflesh_scan_ratio(struct mem_cgroup *mem);
> >
> > +enum scan_type {
> > +       LIMIT_SCAN,     /* scan memory because memcg hits limit */
> > +       SOFT_SCAN,      /* scan memory because of soft limit */
> > +       MARGIN_SCAN,    /* scan memory for making margin to limit */
> > +       NR_SCAN_TYPES,
> > +};
> > +
> >  /*
> >  * The memory controller data structure. The memory controller controls both
> >  * page cache and RSS per cgroup. We would eventually like to provide
> > @@ -300,6 +307,13 @@ struct mem_cgroup {
> >        unsigned long   scanned;
> >        unsigned long   reclaimed;
> >        unsigned long   next_scanratio_update;
> > +       /* For statistics */
> > +       struct {
> > +               unsigned long nr_scanned_pages;
> > +               unsigned long nr_reclaimed_pages;
> > +               unsigned long elapsed_ns;
> > +       } scan_stat[NR_SCAN_TYPES];
> > +
> >        /*
> >         * percpu counter.
> >         */
> > @@ -1426,7 +1440,9 @@ unsigned int mem_cgroup_swappiness(struc
> >
> >  static void __mem_cgroup_update_scan_ratio(struct mem_cgroup *mem,
> >                                unsigned long scanned,
> > -                               unsigned long reclaimed)
> > +                               unsigned long reclaimed,
> > +                               unsigned long elapsed,
> > +                               enum scan_type type)
> >  {
> >        unsigned long limit;
> >
> > @@ -1439,6 +1455,9 @@ static void __mem_cgroup_update_scan_rat
> >                mem->scanned /= 2;
> >                mem->reclaimed /= 2;
> >        }
> > +       mem->scan_stat[type].nr_scanned_pages += scanned;
> > +       mem->scan_stat[type].nr_reclaimed_pages += reclaimed;
> > +       mem->scan_stat[type].elapsed_ns += elapsed;
> >        spin_unlock(&mem->scan_stat_lock);
> >  }
> >
> > @@ -1448,6 +1467,8 @@ static void __mem_cgroup_update_scan_rat
> >  * @root : root memcg of hierarchy walk.
> >  * @scanned : scanned pages
> >  * @reclaimed: reclaimed pages.
> > + * @elapsed: used time for memory reclaim
> > + * @type : scan type as LIMIT_SCAN, SOFT_SCAN, MARGIN_SCAN.
> >  *
> >  * record scan/reclaim ratio to the memcg both to a child and it's root
> >  * mem cgroup, which is a reclaim target. This value is used for
> > @@ -1457,11 +1478,14 @@ static void __mem_cgroup_update_scan_rat
> >  static void mem_cgroup_update_scan_ratio(struct mem_cgroup *mem,
> >                                  struct mem_cgroup *root,
> >                                unsigned long scanned,
> > -                               unsigned long reclaimed)
> > +                               unsigned long reclaimed,
> > +                               unsigned long elapsed,
> > +                               int type)
> >  {
> > -       __mem_cgroup_update_scan_ratio(mem, scanned, reclaimed);
> > +       __mem_cgroup_update_scan_ratio(mem, scanned, reclaimed, elapsed, type);
> >        if (mem != root)
> > -               __mem_cgroup_update_scan_ratio(root, scanned, reclaimed);
> > +               __mem_cgroup_update_scan_ratio(root, scanned, reclaimed,
> > +                                       elapsed, type);
> >
> >  }
> >
> > @@ -1906,6 +1930,7 @@ static int mem_cgroup_hierarchical_recla
> >        bool is_kswapd = false;
> >        unsigned long excess;
> >        unsigned long nr_scanned;
> > +       unsigned long start, end, elapsed;
> >
> >        excess = res_counter_soft_limit_excess(&root_mem->res) >> PAGE_SHIFT;
> >
> > @@ -1947,18 +1972,24 @@ static int mem_cgroup_hierarchical_recla
> >                }
> >                /* we use swappiness of local cgroup */
> >                if (check_soft) {
> > +                       start = sched_clock();
> >                        ret = mem_cgroup_shrink_node_zone(victim, gfp_mask,
> >                                noswap, zone, &nr_scanned);
> > +                       end = sched_clock();
> > +                       elapsed = end - start;
> >                        *total_scanned += nr_scanned;
> >                        mem_cgroup_soft_steal(victim, is_kswapd, ret);
> >                        mem_cgroup_soft_scan(victim, is_kswapd, nr_scanned);
> >                        mem_cgroup_update_scan_ratio(victim,
> > -                                       root_mem, nr_scanned, ret);
> > +                               root_mem, nr_scanned, ret, elapsed, SOFT_SCAN);
> >                } else {
> > +                       start = sched_clock();
> >                        ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
> >                                        noswap, &nr_scanned);
> > +                       end = sched_clock();
> > +                       elapsed = end - start;
> >                        mem_cgroup_update_scan_ratio(victim,
> > -                                       root_mem, nr_scanned, ret);
> > +                               root_mem, nr_scanned, ret, elapsed, LIMIT_SCAN);
> >                }
> >                css_put(&victim->css);
> >                /*
> > @@ -4003,7 +4034,7 @@ static void mem_cgroup_async_shrink_work
> >        struct delayed_work *dw = to_delayed_work(work);
> >        struct mem_cgroup *mem, *victim;
> >        long nr_to_reclaim;
> > -       unsigned long nr_scanned, nr_reclaimed;
> > +       unsigned long nr_scanned, nr_reclaimed, start, end;
> >        int delay = 0;
> >
> >        mem = container_of(dw, struct mem_cgroup, async_work);
> > @@ -4022,9 +4053,12 @@ static void mem_cgroup_async_shrink_work
> >        if (!victim)
> >                goto finish_scan;
> >
> > +       start = sched_clock();
> >        nr_reclaimed = mem_cgroup_shrink_rate_limited(victim, nr_to_reclaim,
> >                                        &nr_scanned);
> > -       mem_cgroup_update_scan_ratio(victim, mem, nr_scanned, nr_reclaimed);
> > +       end = sched_clock();
> > +       mem_cgroup_update_scan_ratio(victim, mem, nr_scanned, nr_reclaimed,
> > +                       end - start, MARGIN_SCAN);
> >        css_put(&victim->css);
> >
> >        /* If margin is enough big, stop */
> > @@ -4680,6 +4714,38 @@ static int mem_control_stat_show(struct
> >        return 0;
> >  }
> >
> > +static int mem_cgroup_reclaim_stat_read(struct cgroup *cont, struct cftype *cft,
> > +                                struct cgroup_map_cb *cb)
> > +{
> > +       struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
> > +       u64 val;
> > +       int i; /* for indexing scan_stat[] */
> > +
> > +       val = mem->reclaimed * 100 / mem->scanned;
> > +       cb->fill(cb, "recent_scan_success_ratio", val);
> > +       i  = LIMIT_SCAN;
> > +       cb->fill(cb, "limit_scan_pages", mem->scan_stat[i].nr_scanned_pages);
> > +       cb->fill(cb, "limit_freed_pages", mem->scan_stat[i].nr_reclaimed_pages);
> > +       cb->fill(cb, "limit_elapsed_ns", mem->scan_stat[i].elapsed_ns);
> > +       i = SOFT_SCAN;
> > +       cb->fill(cb, "soft_scan_pages", mem->scan_stat[i].nr_scanned_pages);
> > +       cb->fill(cb, "soft_freed_pages", mem->scan_stat[i].nr_reclaimed_pages);
> > +       cb->fill(cb, "soft_elapsed_ns", mem->scan_stat[i].elapsed_ns);
> > +       i = MARGIN_SCAN;
> > +       cb->fill(cb, "margin_scan_pages", mem->scan_stat[i].nr_scanned_pages);
> > +       cb->fill(cb, "margin_freed_pages", mem->scan_stat[i].nr_reclaimed_pages);
> > +       cb->fill(cb, "margin_elapsed_ns", mem->scan_stat[i].elapsed_ns);
> > +       return 0;
> > +}
> > +
> > +static int mem_cgroup_reclaim_stat_reset(struct cgroup *cgrp, unsigned int event)
> > +{
> > +       struct mem_cgroup *mem = mem_cgroup_from_cont(cgrp);
> > +       memset(mem->scan_stat, 0, sizeof(mem->scan_stat));
> > +       return 0;
> > +}
> > +
> > +
> >  /*
> >  * User flags for async_control is a subset of mem->async_flags. But
> >  * this needs to be defined independently to hide implemation details.
> > @@ -5163,6 +5229,11 @@ static struct cftype mem_cgroup_files[]
> >                .open = mem_control_numa_stat_open,
> >        },
> >  #endif
> > +       {
> > +               .name = "reclaim_stat",
> > +               .read_map = mem_cgroup_reclaim_stat_read,
> > +               .trigger = mem_cgroup_reclaim_stat_reset,
> > +       }
> >  };
> >
> >  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

