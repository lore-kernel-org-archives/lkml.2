Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab2BGAUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:20:36 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33966 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab2BGAUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:20:33 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 7 Feb 2012 09:19:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/6] memcg: simplify move_account() check.
Message-Id: <20120207091906.1fd6eb40.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120206143853.4cd732c4.akpm@linux-foundation.org>
References: <20120206190627.7313ff82.kamezawa.hiroyu@jp.fujitsu.com>
	<20120206190759.76df4784.kamezawa.hiroyu@jp.fujitsu.com>
	<20120206143853.4cd732c4.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Feb 2012 14:38:53 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 6 Feb 2012 19:07:59 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > >From c75cc843ca0cb36de97ab814e59fb4ab7b1ffbd1 Mon Sep 17 00:00:00 2001
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Date: Thu, 2 Feb 2012 10:02:39 +0900
> > Subject: [PATCH 1/6] memcg: simplify move_account() check.
> > 
> > In memcg, for avoiding take-lock-irq-off at accessing page_cgroup,
> > a logic, flag + rcu_read_lock(), is used. This works as following
> > 
> >      CPU-A                     CPU-B
> >                              rcu_read_lock()
> >     set flag
> >                              if(flag is set)
> >                                    take heavy lock
> >                              do job.
> >     synchronize_rcu()        rcu_read_unlock()
> > 
> > In recent discussion, it's argued that using per-cpu value for this
> > flag just complicates the code because 'set flag' is very rare.
> > 
> > This patch changes 'flag' implementation from percpu to atomic_t.
> > This will be much simpler.
> > 
> 
> To me, "RFC" says "might not be ready for merging yet".  You're up to
> v3 - why is it still RFC?  You're still expecting to make significant
> changes?
> 

Yes, I made changes discussed in v2. and need to show how it looks.
I'm sorry that changelog wasn't enough.

> >
> >  }
> > +/*
> > + * memcg->moving_account is used for checking possibility that some thread is
> > + * calling move_account(). When a thread on CPU-A starts moving pages under
> > + * a memcg, other threads sholud check memcg->moving_account under
> 
> "should"
> 

Sure..

> > + * rcu_read_lock(), like this:
> > + *
> > + *         CPU-A                                    CPU-B
> > + *                                              rcu_read_lock()
> > + *         memcg->moving_account+1              if (memcg->mocing_account)
> > + *                                                   take havier locks.
> > + *         syncronize_rcu()                     update something.
> > + *                                              rcu_read_unlock()
> > + *         start move here.
> > + */
> >  
> >  static void mem_cgroup_start_move(struct mem_cgroup *memcg)
> >  {
> > -	int cpu;
> > -
> > -	get_online_cpus();
> > -	spin_lock(&memcg->pcp_counter_lock);
> > -	for_each_online_cpu(cpu)
> > -		per_cpu(memcg->stat->count[MEM_CGROUP_ON_MOVE], cpu) += 1;
> > -	memcg->nocpu_base.count[MEM_CGROUP_ON_MOVE] += 1;
> > -	spin_unlock(&memcg->pcp_counter_lock);
> > -	put_online_cpus();
> > -
> > +	atomic_inc(&memcg->moving_account);
> >  	synchronize_rcu();
> >  }
> >  
> >  static void mem_cgroup_end_move(struct mem_cgroup *memcg)
> >  {
> > -	int cpu;
> > -
> > -	if (!memcg)
> > -		return;
> > -	get_online_cpus();
> > -	spin_lock(&memcg->pcp_counter_lock);
> > -	for_each_online_cpu(cpu)
> > -		per_cpu(memcg->stat->count[MEM_CGROUP_ON_MOVE], cpu) -= 1;
> > -	memcg->nocpu_base.count[MEM_CGROUP_ON_MOVE] -= 1;
> > -	spin_unlock(&memcg->pcp_counter_lock);
> > -	put_online_cpus();
> > +	if (memcg)
> > +		atomic_dec(&memcg->moving_account);
> >  }
> 
> It's strange that end_move handles a NULL memcg but start_move does not.
> 

Ah, the reason was that mem_cgroup_end_move() can called in mem_cgroup_clear_mc().
This mem_cgroup_clear_mc() can call mem_cgroup_end_move(NULL)...
Then, this function has NULL check in callee side.
I'll add comments.


> >  /*
> >   * 2 routines for checking "mem" is under move_account() or not.
> > @@ -1298,7 +1297,7 @@ static void mem_cgroup_end_move(struct mem_cgroup *memcg)
> >  static bool mem_cgroup_stealed(struct mem_cgroup *memcg)
> >  {
> >  	VM_BUG_ON(!rcu_read_lock_held());
> > -	return this_cpu_read(memcg->stat->count[MEM_CGROUP_ON_MOVE]) > 0;
> > +	return atomic_read(&memcg->moving_account);
> >  }
> 
> So a bool-returning function can return something > 1?
> 
> I don't know what the compiler would make of that.  Presumably "if (b)"
> will work OK, but will "if (b1 == b2)"?
> 

        if (!mem_cgroup_stealed(memcg))
ffffffff8116e278:       85 c0                   test   %eax,%eax
ffffffff8116e27a:       74 1f                   je     ffffffff8116e29b <__mem_cgroup_begin_update_page_stat+0x7b>
                return;
ffffffff8116e29b:       5b                      pop    %rbx
ffffffff8116e29c:       41 5c                   pop    %r12
ffffffff8116e29e:       41 5d                   pop    %r13
ffffffff8116e2a0:       41 5e                   pop    %r14
ffffffff8116e2a2:       c9                      leaveq
ffffffff8116e2a3:       c3                      retq

Maybe works as expected but... I'll rewrite..how about this ?.

>From 3cefc03a4da41843ea2439f1c0ca630c64e8cf87 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 2 Feb 2012 10:02:39 +0900
Subject: [PATCH] memcg: simplify move_account() check.

In memcg, for avoiding take-lock-irq-off at accessing page_cgroup,
a logic, flag + rcu_read_lock(), is used. This works as following

     CPU-A                     CPU-B
                             rcu_read_lock()
    set flag
                             if(flag is set)
                                   take heavy lock
                             do job.
    synchronize_rcu()        rcu_read_unlock()

In recent discussion, it's argued that using per-cpu value for this
flag just complicates the code because 'set flag' is very rare.

This patch changes 'flag' implementation from percpu to atomic_t.
This will be much simpler.

Changelog: v4
 - fixed many typos.
 - check return variables should be bool
 - add comments.
Changelog: v3
 - this is a new patch since v3.

 memcontrol.c |   65 ++++++++++++++++++++++-------------------------------------
 1 file changed, 25 insertions(+), 40 deletions(-)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   70 +++++++++++++++++++++++-------------------------------
 1 files changed, 30 insertions(+), 40 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ab315ab..0359175 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -89,7 +89,6 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
 	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
-	MEM_CGROUP_ON_MOVE,	/* someone is moving account between groups */
 	MEM_CGROUP_STAT_NSTATS,
 };
 
@@ -278,6 +277,10 @@ struct mem_cgroup {
 	 */
 	unsigned long 	move_charge_at_immigrate;
 	/*
+	 * set > 0 if pages under this cgroup are moving to other cgroup.
+	 */
+	atomic_t	moving_account;
+	/*
 	 * percpu counter.
 	 */
 	struct mem_cgroup_stat_cpu *stat;
@@ -1253,36 +1256,37 @@ int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 
 	return memcg->swappiness;
 }
+/*
+ * memcg->moving_account is used for checking possibility that some thread is
+ * calling move_account(). When a thread on CPU-A starts moving pages under
+ * a memcg, other threads should check memcg->moving_account under
+ * rcu_read_lock(), like this:
+ *
+ *         CPU-A                                    CPU-B
+ *                                              rcu_read_lock()
+ *         memcg->moving_account+1              if (memcg->mocing_account)
+ *                                                   take heavy locks.
+ *         synchronize_rcu()                    update something.
+ *                                              rcu_read_unlock()
+ *         start move here.
+ */
 
 static void mem_cgroup_start_move(struct mem_cgroup *memcg)
 {
-	int cpu;
-
-	get_online_cpus();
-	spin_lock(&memcg->pcp_counter_lock);
-	for_each_online_cpu(cpu)
-		per_cpu(memcg->stat->count[MEM_CGROUP_ON_MOVE], cpu) += 1;
-	memcg->nocpu_base.count[MEM_CGROUP_ON_MOVE] += 1;
-	spin_unlock(&memcg->pcp_counter_lock);
-	put_online_cpus();
-
+	atomic_inc(&memcg->moving_account);
 	synchronize_rcu();
 }
 
 static void mem_cgroup_end_move(struct mem_cgroup *memcg)
 {
-	int cpu;
-
-	if (!memcg)
-		return;
-	get_online_cpus();
-	spin_lock(&memcg->pcp_counter_lock);
-	for_each_online_cpu(cpu)
-		per_cpu(memcg->stat->count[MEM_CGROUP_ON_MOVE], cpu) -= 1;
-	memcg->nocpu_base.count[MEM_CGROUP_ON_MOVE] -= 1;
-	spin_unlock(&memcg->pcp_counter_lock);
-	put_online_cpus();
+	/*
+	 * Now, mem_cgroup_clear_mc() may call this function with NULL.
+	 * We check NULL in callee rather than caller.
+	 */
+	if (memcg)
+		atomic_dec(&memcg->moving_account);
 }
+
 /*
  * 2 routines for checking "mem" is under move_account() or not.
  *
@@ -1298,7 +1302,7 @@ static void mem_cgroup_end_move(struct mem_cgroup *memcg)
 static bool mem_cgroup_stealed(struct mem_cgroup *memcg)
 {
 	VM_BUG_ON(!rcu_read_lock_held());
-	return this_cpu_read(memcg->stat->count[MEM_CGROUP_ON_MOVE]) > 0;
+	return atomic_read(&memcg->moving_account) > 0;
 }
 
 static bool mem_cgroup_under_move(struct mem_cgroup *memcg)
@@ -1849,8 +1853,8 @@ bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask)
  * by flags.
  *
  * Considering "move", this is an only case we see a race. To make the race
- * small, we check MEM_CGROUP_ON_MOVE percpu value and detect there are
- * possibility of race condition. If there is, we take a lock.
+ * small, we check mm->moving_account and detect there are possibility of race
+ * If there is, we take a lock.
  */
 
 void mem_cgroup_update_page_stat(struct page *page,
@@ -2068,17 +2072,6 @@ static void mem_cgroup_drain_pcp_counter(struct mem_cgroup *memcg, int cpu)
 		per_cpu(memcg->stat->events[i], cpu) = 0;
 		memcg->nocpu_base.events[i] += x;
 	}
-	/* need to clear ON_MOVE value, works as a kind of lock. */
-	per_cpu(memcg->stat->count[MEM_CGROUP_ON_MOVE], cpu) = 0;
-	spin_unlock(&memcg->pcp_counter_lock);
-}
-
-static void synchronize_mem_cgroup_on_move(struct mem_cgroup *memcg, int cpu)
-{
-	int idx = MEM_CGROUP_ON_MOVE;
-
-	spin_lock(&memcg->pcp_counter_lock);
-	per_cpu(memcg->stat->count[idx], cpu) = memcg->nocpu_base.count[idx];
 	spin_unlock(&memcg->pcp_counter_lock);
 }
 
@@ -2090,11 +2083,8 @@ static int __cpuinit memcg_cpu_hotplug_callback(struct notifier_block *nb,
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *iter;
 
-	if ((action == CPU_ONLINE)) {
-		for_each_mem_cgroup(iter)
-			synchronize_mem_cgroup_on_move(iter, cpu);
+	if ((action == CPU_ONLINE))
 		return NOTIFY_OK;
-	}
 
 	if ((action != CPU_DEAD) || action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
-- 
1.7.4.1















