Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab1FJKHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 06:07:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34671 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab1FJKGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 06:06:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 10 Jun 2011 18:59:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Ying Han <yinghan@google.com>
Subject: Re: [BUGFIX][PATCH v3] memcg: fix behavior of per cpu charge cache
 draining.
Message-Id: <20110610185952.a07b968f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110610090802.GB4110@tiehlicka.suse.cz>
References: <20110609093045.1f969d30.kamezawa.hiroyu@jp.fujitsu.com>
	<20110610081218.GC4832@tiehlicka.suse.cz>
	<20110610173958.d9ab901c.kamezawa.hiroyu@jp.fujitsu.com>
	<20110610090802.GB4110@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011 11:08:02 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Fri 10-06-11 17:39:58, KAMEZAWA Hiroyuki wrote:
> > On Fri, 10 Jun 2011 10:12:19 +0200
> > Michal Hocko <mhocko@suse.cz> wrote:
> > 
> > > On Thu 09-06-11 09:30:45, KAMEZAWA Hiroyuki wrote:
> [...]
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index bd9052a..3baddcb 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > [...]
> > > >  static struct mem_cgroup_per_zone *
> > > >  mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
> > > > @@ -1670,8 +1670,6 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
> > > >  		victim = mem_cgroup_select_victim(root_mem);
> > > >  		if (victim == root_mem) {
> > > >  			loop++;
> > > > -			if (loop >= 1)
> > > > -				drain_all_stock_async();
> > > >  			if (loop >= 2) {
> > > >  				/*
> > > >  				 * If we have not been able to reclaim
> > > > @@ -1723,6 +1721,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
> > > >  				return total;
> > > >  		} else if (mem_cgroup_margin(root_mem))
> > > >  			return total;
> > > > +		drain_all_stock_async(root_mem);
> > > >  	}
> > > >  	return total;
> > > >  }
> > > 
> > > I still think that we pointlessly reclaim even though we could have a
> > > lot of pages pre-charged in the cache (the more CPUs we have the more
> > > significant this might be).
> > 
> > The more CPUs, the more scan cost for each per-cpu memory, which makes
> > cache-miss.
> > 
> > I know placement of drain_all_stock_async() is not big problem on my host,
> > which has 2socket/8core cpus. But, assuming 1000+ cpu host, 
> 
> Hmm, it really depends what you want to optimize for. Reclaim path is
> already slow path and cache misses, while not good, are not the most
> significant issue, I guess.
> What I would see as a much bigger problem is that there might be a lot
> of memory pre-charged at those per-cpu caches. Falling into a reclaim
> costs us much more IMO and we can evict something that could be useful
> for no good reason.
> 

It's waste of time to talk this kind of things without the numbers.

ok, I don't change the caller's logic. Discuss this when someone gets
number of LARGE smp box. Updated one is attached. Tested on my host
without problem and it seems kworker run is much reduced on my test
with "cat"

When I run "cat 1Gfile > /dev/null" under 300M limit memcg,

[Before]
13767 kamezawa  20   0 98.6m  424  416 D 10.0  0.0   0:00.61 cat
   58 root      20   0     0    0    0 S  0.6  0.0   0:00.09 kworker/2:1
   60 root      20   0     0    0    0 S  0.6  0.0   0:00.08 kworker/4:1
    4 root      20   0     0    0    0 S  0.3  0.0   0:00.02 kworker/0:0
   57 root      20   0     0    0    0 S  0.3  0.0   0:00.05 kworker/1:1
   61 root      20   0     0    0    0 S  0.3  0.0   0:00.05 kworker/5:1
   62 root      20   0     0    0    0 S  0.3  0.0   0:00.05 kworker/6:1
   63 root      20   0     0    0    0 S  0.3  0.0   0:00.05 kworker/7:1

[After]
 2676 root      20   0 98.6m  416  416 D  9.3  0.0   0:00.87 cat
 2626 kamezawa  20   0 15192 1312  920 R  0.3  0.0   0:00.28 top
    1 root      20   0 19384 1496 1204 S  0.0  0.0   0:00.66 init
    2 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kthreadd
    3 root      20   0     0    0    0 S  0.0  0.0   0:00.00 ksoftirqd/0
    4 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kworker/0:0



> > "when you hit limit, you'll see 1000*128bytes cache miss and need to
> > call test_and_set for 1000+ cpus in bad case." doesn't seem much win.
> > 
> > If we implement "call-drain-only-nearby-cpus", I think we can call it before
> > calling try_to_free_mem_cgroup_pages(). I'll add it to my TO-DO-LIST.
> 
> It would just consider cpus at the same node?
> 
just on the same socket. anyway, keep-margin-in-background will be final
help for large SMP.


please test/ack if ok.
==
>From 57b8a5e9270dd2806da21c51708f0dfab6919f4f Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 18:16:47 +0900
Subject: [PATCH v4] memcg: fix behavior of per cpu charge cache draining.

 For performance, memory cgroup caches some "charge" from res_counter
 into per cpu cache. This works well but because it's cache,
 it needs to be flushed in some cases. Typical cases are
         1. when someone hit limit.
         2. when rmdir() is called and need to charges to be 0.

But "1" has problem.

Recently, with large SMP machines, we see many kworker runs because
of flushing memcg's cache. Bad things in implementation are
that even if a cpu contains a cache for memcg not related to
a memcg which hits limit, drain code is called.

This patch does
	A) check percpu cache contains a useful data or not.
plus
	B) check asynchronous percpu draining doesn't run.
and
	C) don't call local cpu callback.

When I run "cat 1Gfile > /dev/null" under 300M limit memcg,

[Before]
13767 kamezawa  20   0 98.6m  424  416 D 10.0  0.0   0:00.61 cat
   58 root      20   0     0    0    0 S  0.6  0.0   0:00.09 kworker/2:1
   60 root      20   0     0    0    0 S  0.6  0.0   0:00.08 kworker/4:1
    4 root      20   0     0    0    0 S  0.3  0.0   0:00.02 kworker/0:0
   57 root      20   0     0    0    0 S  0.3  0.0   0:00.05 kworker/1:1
   61 root      20   0     0    0    0 S  0.3  0.0   0:00.05 kworker/5:1
   62 root      20   0     0    0    0 S  0.3  0.0   0:00.05 kworker/6:1
   63 root      20   0     0    0    0 S  0.3  0.0   0:00.05 kworker/7:1

[After]
 2676 root      20   0 98.6m  416  416 D  9.3  0.0   0:00.87 cat
 2626 kamezawa  20   0 15192 1312  920 R  0.3  0.0   0:00.28 top
    1 root      20   0 19384 1496 1204 S  0.0  0.0   0:00.66 init
    2 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kthreadd
    3 root      20   0     0    0    0 S  0.0  0.0   0:00.00 ksoftirqd/0
    4 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kworker/0:0

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Changelog:
 - don't call callback on local cpu.
 - don't change calling condition of async drain.
 - fixed typo.
 - fixed rcu_read_lock() and add strict mutal execution between
   asynchronous and synchronous flushing. It's requred for validness
   of cached pointer.
 - add root_mem->use_hierarchy check.
---
 mm/memcontrol.c |   58 +++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bd9052a..75713cb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -359,7 +359,7 @@ enum charge_type {
 static void mem_cgroup_get(struct mem_cgroup *mem);
 static void mem_cgroup_put(struct mem_cgroup *mem);
 static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
-static void drain_all_stock_async(void);
+static void drain_all_stock_async(struct mem_cgroup *mem);
 
 static struct mem_cgroup_per_zone *
 mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
@@ -1670,8 +1670,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 		victim = mem_cgroup_select_victim(root_mem);
 		if (victim == root_mem) {
 			loop++;
-			if (loop >= 1)
-				drain_all_stock_async();
+			drain_all_stock_async(root_mem);
 			if (loop >= 2) {
 				/*
 				 * If we have not been able to reclaim
@@ -1934,9 +1933,12 @@ struct memcg_stock_pcp {
 	struct mem_cgroup *cached; /* this never be root cgroup */
 	unsigned int nr_pages;
 	struct work_struct work;
+	unsigned long flags;
+#define ASYNC_FLUSHING	(0)
 };
 static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
-static atomic_t memcg_drain_count;
+/* mutex for draining percpu charge for avoid too much kworker works. */
+DEFINE_MUTEX(percpu_charge_mutex);
 
 /*
  * Try to consume stocked charge on this cpu. If success, one page is consumed
@@ -1984,6 +1986,7 @@ static void drain_local_stock(struct work_struct *dummy)
 {
 	struct memcg_stock_pcp *stock = &__get_cpu_var(memcg_stock);
 	drain_stock(stock);
+	clear_bit(ASYNC_FLUSHING, &stock->flags);
 }
 
 /*
@@ -2006,38 +2009,55 @@ static void refill_stock(struct mem_cgroup *mem, unsigned int nr_pages)
  * Tries to drain stocked charges in other cpus. This function is asynchronous
  * and just put a work per cpu for draining localy on each cpu. Caller can
  * expects some charges will be back to res_counter later but cannot wait for
- * it.
+ * it. This runs only when per-cpu stock contains information of memcg which
+ * is under specified root_mem and no other flush runs.
  */
-static void drain_all_stock_async(void)
+static void drain_all_stock_async(struct mem_cgroup *root_mem)
 {
 	int cpu;
-	/* This function is for scheduling "drain" in asynchronous way.
-	 * The result of "drain" is not directly handled by callers. Then,
-	 * if someone is calling drain, we don't have to call drain more.
-	 * Anyway, WORK_STRUCT_PENDING check in queue_work_on() will catch if
-	 * there is a race. We just do loose check here.
+
+	/*
+	 * If synchronous flushing (which flushes all cpus's cache) runs,
+	 * or some other kworker runs already. avoid more calls.
 	 */
-	if (atomic_read(&memcg_drain_count))
+	if (!mutex_trylock(&percpu_charge_mutex))
 		return;
-	/* Notify other cpus that system-wide "drain" is running */
-	atomic_inc(&memcg_drain_count);
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
-		schedule_work_on(cpu, &stock->work);
+		struct mem_cgroup *mem;
+		bool do_flush;
+
+		/* we can be preempted..but..we don't need precise check. */
+		if (cpu == raw_smp_processor_id())
+			continue;
+		/*
+		 * This stock->cached is cleared before mem cgroup is destroyed.
+		 * And we have mutex. So it's safe to access stock->cached.
+		 */
+
+		mem = stock->cached;
+		if (!mem)
+			continue;
+		rcu_read_lock();
+		do_flush = ((mem == root_mem) ||
+			(root_mem->use_hierarchy &&
+		     	 css_is_ancestor(&mem->css, &root_mem->css)));
+		rcu_read_unlock();
+		if (do_flush && !test_and_set_bit(ASYNC_FLUSHING, &stock->flags))
+			schedule_work_on(cpu, &stock->work);
 	}
  	put_online_cpus();
-	atomic_dec(&memcg_drain_count);
-	/* We don't wait for flush_work */
+	mutex_unlock(&percpu_charge_mutex);
 }
 
 /* This is a synchronous drain interface. */
 static void drain_all_stock_sync(void)
 {
 	/* called when force_empty is called */
-	atomic_inc(&memcg_drain_count);
+	mutex_lock(&percpu_charge_mutex);
 	schedule_on_each_cpu(drain_local_stock);
-	atomic_dec(&memcg_drain_count);
+	mutex_unlock(&percpu_charge_mutex);
 }
 
 /*
-- 
1.7.4.1


