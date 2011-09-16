Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab1IPGJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:09:40 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:42285 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1IPGJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:09:39 -0400
Date: Fri, 16 Sep 2011 16:09:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@google.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Johannes Weiner <jweiner@redhat.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20110916160928.ca9a16909abdf625f7e7cd0e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/memcontrol.c between commit 185efc0f9a1f ("memcg: Revert "memcg: add
memory.vmscan_stat"") from Linus' tree and commit 970f23b7f013 ("The
memcg code sometimes uses "struct mem_cgroup *mem" and sometimes uses")
from the akpm tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/memcontrol.c
index 1364b5e,e47a504..0000000
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@@ -202,9 -202,53 +202,9 @@@ struct mem_cgroup_eventfd_list 
  	struct eventfd_ctx *eventfd;
  };
  
- static void mem_cgroup_threshold(struct mem_cgroup *mem);
- static void mem_cgroup_oom_notify(struct mem_cgroup *mem);
+ static void mem_cgroup_threshold(struct mem_cgroup *memcg);
+ static void mem_cgroup_oom_notify(struct mem_cgroup *memcg);
  
 -enum {
 -	SCAN_BY_LIMIT,
 -	SCAN_BY_SYSTEM,
 -	NR_SCAN_CONTEXT,
 -	SCAN_BY_SHRINK,	/* not recorded now */
 -};
 -
 -enum {
 -	SCAN,
 -	SCAN_ANON,
 -	SCAN_FILE,
 -	ROTATE,
 -	ROTATE_ANON,
 -	ROTATE_FILE,
 -	FREED,
 -	FREED_ANON,
 -	FREED_FILE,
 -	ELAPSED,
 -	NR_SCANSTATS,
 -};
 -
 -struct scanstat {
 -	spinlock_t	lock;
 -	unsigned long	stats[NR_SCAN_CONTEXT][NR_SCANSTATS];
 -	unsigned long	rootstats[NR_SCAN_CONTEXT][NR_SCANSTATS];
 -};
 -
 -const char *scanstat_string[NR_SCANSTATS] = {
 -	"scanned_pages",
 -	"scanned_anon_pages",
 -	"scanned_file_pages",
 -	"rotated_pages",
 -	"rotated_anon_pages",
 -	"rotated_file_pages",
 -	"freed_pages",
 -	"freed_anon_pages",
 -	"freed_file_pages",
 -	"elapsed_ns",
 -};
 -#define SCANSTAT_WORD_LIMIT	"_by_limit"
 -#define SCANSTAT_WORD_SYSTEM	"_by_system"
 -#define SCANSTAT_WORD_HIERARCHY	"_under_hierarchy"
 -
 -
  /*
   * The memory controller data structure. The memory controller controls both
   * page cache and RSS per cgroup. We would eventually like to provide
@@@ -1659,18 -1745,28 +1662,18 @@@ static int mem_cgroup_hierarchical_recl
  	bool noswap = reclaim_options & MEM_CGROUP_RECLAIM_NOSWAP;
  	bool shrink = reclaim_options & MEM_CGROUP_RECLAIM_SHRINK;
  	bool check_soft = reclaim_options & MEM_CGROUP_RECLAIM_SOFT;
 -	struct memcg_scanrecord rec;
  	unsigned long excess;
 -	unsigned long scanned;
 +	unsigned long nr_scanned;
  
- 	excess = res_counter_soft_limit_excess(&root_mem->res) >> PAGE_SHIFT;
+ 	excess = res_counter_soft_limit_excess(&root_memcg->res) >> PAGE_SHIFT;
  
  	/* If memsw_is_minimum==1, swap-out is of-no-use. */
- 	if (!check_soft && !shrink && root_mem->memsw_is_minimum)
+ 	if (!check_soft && !shrink && root_memcg->memsw_is_minimum)
  		noswap = true;
  
 -	if (shrink)
 -		rec.context = SCAN_BY_SHRINK;
 -	else if (check_soft)
 -		rec.context = SCAN_BY_SYSTEM;
 -	else
 -		rec.context = SCAN_BY_LIMIT;
 -
 -	rec.root = root_memcg;
 -
  	while (1) {
- 		victim = mem_cgroup_select_victim(root_mem);
- 		if (victim == root_mem) {
+ 		victim = mem_cgroup_select_victim(root_memcg);
+ 		if (victim == root_memcg) {
  			loop++;
  			/*
  			 * We are not draining per cpu cached charges during
@@@ -3753,15 -3858,19 +3756,15 @@@ try_to_free
  	lru_add_drain_all();
  	/* try to free all pages in this cgroup */
  	shrink = 1;
- 	while (nr_retries && mem->res.usage > 0) {
+ 	while (nr_retries && memcg->res.usage > 0) {
 -		struct memcg_scanrecord rec;
  		int progress;
  
  		if (signal_pending(current)) {
  			ret = -EINTR;
  			goto out;
  		}
- 		progress = try_to_free_mem_cgroup_pages(mem, GFP_KERNEL,
- 						false);
 -		rec.context = SCAN_BY_SHRINK;
 -		rec.mem = memcg;
 -		rec.root = memcg;
+ 		progress = try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL,
+ 						false, &rec);
  		if (!progress) {
  			nr_retries--;
  			/* maybe some writeback is necessary */
@@@ -4926,21 -5091,22 +4929,21 @@@ mem_cgroup_create(struct cgroup_subsys 
  		 */
  		mem_cgroup_get(parent);
  	} else {
- 		res_counter_init(&mem->res, NULL);
- 		res_counter_init(&mem->memsw, NULL);
+ 		res_counter_init(&memcg->res, NULL);
+ 		res_counter_init(&memcg->memsw, NULL);
  	}
- 	mem->last_scanned_child = 0;
- 	mem->last_scanned_node = MAX_NUMNODES;
- 	INIT_LIST_HEAD(&mem->oom_notify);
+ 	memcg->last_scanned_child = 0;
+ 	memcg->last_scanned_node = MAX_NUMNODES;
+ 	INIT_LIST_HEAD(&memcg->oom_notify);
  
  	if (parent)
- 		mem->swappiness = mem_cgroup_swappiness(parent);
- 	atomic_set(&mem->refcnt, 1);
- 	mem->move_charge_at_immigrate = 0;
- 	mutex_init(&mem->thresholds_lock);
- 	return &mem->css;
+ 		memcg->swappiness = mem_cgroup_swappiness(parent);
+ 	atomic_set(&memcg->refcnt, 1);
+ 	memcg->move_charge_at_immigrate = 0;
+ 	mutex_init(&memcg->thresholds_lock);
 -	spin_lock_init(&memcg->scanstat.lock);
+ 	return &memcg->css;
  free_out:
- 	__mem_cgroup_free(mem);
+ 	__mem_cgroup_free(memcg);
  	root_mem_cgroup = NULL;
  	return ERR_PTR(error);
  }
