Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab1FOFaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 01:30:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:57013 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab1FOFaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 01:30:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gLa5fT0UWdCxMPBNcDMj5e40vIEoaflhDSK+8fLxbZrBaHfCUqUADf7HkhjzIl3uCj
         iStOBbOjdE4LoxNNOdqQ==
MIME-Version: 1.0
In-Reply-To: <20110615104935.ccefc6b5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110613120054.3336e997.kamezawa.hiroyu@jp.fujitsu.com>
	<20110613121648.3d28afcd.kamezawa.hiroyu@jp.fujitsu.com>
	<20110615104935.ccefc6b5.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 14 Jun 2011 22:30:15 -0700
Message-ID: <BANLkTi=FBROyRiM1tZbJGMY2Esmtc=-BSQ@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH v6] memcg: fix percpu cached charge draining frequency
From: Ying Han <yinghan@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 6:49 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> This is a repleacement for
> memcg-fix-percpu-cached-charge-draining-frequency.patch
> +
> memcg-fix-percpu-cached-charge-draining-frequency-fix.patch
>
>
> Changelog:
>  - removed unnecessary rcu_read_lock()
>  - removed a fix for softlimit case (move to another independent patch)
>  - make mutex static.
>  - applied comment updates from Andrew Morton.
>
> A patch for softlimit will follow this.
>
> ==
> From f3f41b827d70142858ba8b370510a82d608870d0 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Wed, 15 Jun 2011 10:39:57 +0900
> Subject: [PATCH 5/6] memcg: fix behavior of per cpu charge cache draining.
>
>  For performance, memory cgroup caches some "charge" from res_counter
>  into per cpu cache. This works well but because it's cache,
>  it needs to be flushed in some cases. Typical cases are
>         1. when someone hit limit.
>         2. when rmdir() is called and need to charges to be 0.
>
> But "1" has problem.
>
> Recently, with large SMP machines, we see many kworker runs because
> of flushing memcg's cache. Bad things in implementation are
> that even if a cpu contains a cache for memcg not related to
> a memcg which hits limit, drain code is called.
>
> This patch does
>        A) check percpu cache contains a useful data or not.
>        B) check other asynchronous percpu draining doesn't run.
>        C) don't call local cpu callback.
>
> (*)This patch avoid changing the calling condition with hard-limit.
>
> When I run "cat 1Gfile > /dev/null" under 300M limit memcg,
>
> [Before]
> 13767 kamezawa  20   0 98.6m  424  416 D 10.0  0.0   0:00.61 cat
>   58 root      20   0     0    0    0 S  0.6  0.0   0:00.09 kworker/2:1
>   60 root      20   0     0    0    0 S  0.6  0.0   0:00.08 kworker/4:1
>    4 root      20   0     0    0    0 S  0.3  0.0   0:00.02 kworker/0:0
>   57 root      20   0     0    0    0 S  0.3  0.0   0:00.05 kworker/1:1
>   61 root      20   0     0    0    0 S  0.3  0.0   0:00.05 kworker/5:1
>   62 root      20   0     0    0    0 S  0.3  0.0   0:00.05 kworker/6:1
>   63 root      20   0     0    0    0 S  0.3  0.0   0:00.05 kworker/7:1
>
> [After]
>  2676 root      20   0 98.6m  416  416 D  9.3  0.0   0:00.87 cat
>  2626 kamezawa  20   0 15192 1312  920 R  0.3  0.0   0:00.28 top
>    1 root      20   0 19384 1496 1204 S  0.0  0.0   0:00.66 init
>    2 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kthreadd
>    3 root      20   0     0    0    0 S  0.0  0.0   0:00.00 ksoftirqd/0
>    4 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kworker/0:0
>
> Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Changelog:
>  - removed unnecessary rcu_read_lock()
>  - removed a fix for softlimit case (move to another independent patch)
>  - make mutex static.
>  - applied comment updates from Andrew Morton.
> ---
>  mm/memcontrol.c |   54 ++++++++++++++++++++++++++++++++++++++----------------
>  1 files changed, 38 insertions(+), 16 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 915c3f3..8fb29de 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -359,7 +359,7 @@ enum charge_type {
>  static void mem_cgroup_get(struct mem_cgroup *mem);
>  static void mem_cgroup_put(struct mem_cgroup *mem);
>  static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
> -static void drain_all_stock_async(void);
> +static void drain_all_stock_async(struct mem_cgroup *mem);
>
>  static struct mem_cgroup_per_zone *
>  mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
> @@ -1671,7 +1671,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
>                if (victim == root_mem) {
>                        loop++;
>                        if (loop >= 1)
> -                               drain_all_stock_async();
> +                               drain_all_stock_async(root_mem);
>                        if (loop >= 2) {
>                                /*
>                                 * If we have not been able to reclaim
> @@ -1934,9 +1934,11 @@ struct memcg_stock_pcp {
>        struct mem_cgroup *cached; /* this never be root cgroup */
>        unsigned int nr_pages;
>        struct work_struct work;
> +       unsigned long flags;
> +#define FLUSHING_CACHED_CHARGE (0)
>  };
>  static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
> -static atomic_t memcg_drain_count;
> +static DEFINE_MUTEX(percpu_charge_mutex);
>
>  /*
>  * Try to consume stocked charge on this cpu. If success, one page is consumed
> @@ -1984,6 +1986,7 @@ static void drain_local_stock(struct work_struct *dummy)
>  {
>        struct memcg_stock_pcp *stock = &__get_cpu_var(memcg_stock);
>        drain_stock(stock);
> +       clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
>  }
>
>  /*
> @@ -2008,26 +2011,45 @@ static void refill_stock(struct mem_cgroup *mem, unsigned int nr_pages)
>  * expects some charges will be back to res_counter later but cannot wait for
>  * it.
>  */
> -static void drain_all_stock_async(void)
> +static void drain_all_stock_async(struct mem_cgroup *root_mem)
>  {
> -       int cpu;
> -       /* This function is for scheduling "drain" in asynchronous way.
> -        * The result of "drain" is not directly handled by callers. Then,
> -        * if someone is calling drain, we don't have to call drain more.
> -        * Anyway, WORK_STRUCT_PENDING check in queue_work_on() will catch if
> -        * there is a race. We just do loose check here.
> +       int cpu, curcpu;
> +       /*
> +        * If someone calls draining, avoid adding more kworker runs.
>         */
> -       if (atomic_read(&memcg_drain_count))
> +       if (!mutex_trylock(&percpu_charge_mutex))
>                return;
>        /* Notify other cpus that system-wide "drain" is running */
> -       atomic_inc(&memcg_drain_count);
>        get_online_cpus();
> +       /*
> +        * Get a hint for avoiding draining charges on the current cpu,
> +        * which must be exhausted by our charging.  It is not required that
> +        * this be a precise check, so we use raw_smp_processor_id() instead of
> +        * getcpu()/putcpu().
> +        */
> +       curcpu = raw_smp_processor_id();
>        for_each_online_cpu(cpu) {
>                struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
> -               schedule_work_on(cpu, &stock->work);
> +               struct mem_cgroup *mem;
> +
> +               if (cpu == curcpu)
> +                       continue;
> +
> +               mem = stock->cached;
> +               if (!mem)
> +                       continue;
> +               if (mem != root_mem) {
> +                       if (!root_mem->use_hierarchy)
> +                               continue;
> +                       /* check whether "mem" is under tree of "root_mem" */
> +                       if (!css_is_ancestor(&mem->css, &root_mem->css))
> +                               continue;
> +               }
> +               if (!test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
> +                       schedule_work_on(cpu, &stock->work);
>        }
>        put_online_cpus();
> -       atomic_dec(&memcg_drain_count);
> +       mutex_unlock(&percpu_charge_mutex);
>        /* We don't wait for flush_work */
>  }
>
> @@ -2035,9 +2057,9 @@ static void drain_all_stock_async(void)
>  static void drain_all_stock_sync(void)
>  {
>        /* called when force_empty is called */
> -       atomic_inc(&memcg_drain_count);
> +       mutex_lock(&percpu_charge_mutex);
>        schedule_on_each_cpu(drain_local_stock);
> -       atomic_dec(&memcg_drain_count);
> +       mutex_unlock(&percpu_charge_mutex);
>  }
>
>  /*
> --
> 1.7.4.1
>
>
>

Tested-by: Ying Han <yinghan@google.com>


--Ying
