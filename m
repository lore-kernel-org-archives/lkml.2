Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab0IAGsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 02:48:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35528 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab0IAGsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 02:48:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 1 Sep 2010 15:42:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gthelen@google.com, Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
        menage@google.com, "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: [PATCH 2/5] memcg: more use of css ID in memcg.
Message-Id: <20100901154259.5b17bb87.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100901153951.bc82c021.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100901153951.bc82c021.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, memory cgroup has an ID per cgroup and make use of it at
 - hierarchy walk,
 - swap recording.

This patch is for making more use of it. The final purpose is
to replace page_cgroup->mem_cgroup's pointer to an unsigned short.

This patch caches a pointer of memcg in an array. By this, we
don't have to call css_lookup() which requires radix-hash walk.
This saves some amount of memory footprint at lookup memcg via id.

Changelog: 20100901
 - added unregster_memcg_id() and did some clean up.
 - removed ->valid.
 - fixed mem_cgroup_num counter handling.

Changelog: 20100825
 - applied comments.

Changelog: 20100811
 - adjusted onto mmotm-2010-08-11
 - fixed RCU related parts.
 - use attach_id() callback.

Changelog: 20100804
 - fixed description in init/Kconfig

Changelog: 20100730
 - fixed rcu_read_unlock() placement.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 init/Kconfig    |   10 +++++++
 mm/memcontrol.c |   71 ++++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 61 insertions(+), 20 deletions(-)

Index: mmotm-0827/mm/memcontrol.c
===================================================================
--- mmotm-0827.orig/mm/memcontrol.c
+++ mmotm-0827/mm/memcontrol.c
@@ -294,6 +294,33 @@ static bool move_file(void)
 					&mc.to->move_charge_at_immigrate);
 }
 
+/* 0 is unused */
+static atomic_t mem_cgroup_num;
+#define NR_MEMCG_GROUPS (CONFIG_MEM_CGROUP_MAX_GROUPS + 1)
+static struct mem_cgroup *mem_cgroups[NR_MEMCG_GROUPS] __read_mostly;
+
+/* Must be called under rcu_read_lock */
+static struct mem_cgroup *id_to_memcg(unsigned short id)
+{
+	struct mem_cgroup *mem;
+	mem = rcu_dereference_check(mem_cgroups[id], rcu_read_lock_held());
+	return mem;
+}
+
+static void register_memcg_id(struct mem_cgroup *mem)
+{
+	int id = css_id(&mem->css);
+	rcu_assign_pointer(mem_cgroups[id], mem);
+}
+
+static void unregister_memcg_id(struct mem_cgroup *mem)
+{
+	int id = css_id(&mem->css);
+	rcu_assign_pointer(mem_cgroups[id], NULL);
+	/* Wait until all references goes. */
+	synchronize_rcu();
+}
+
 /*
  * Maximum loops in mem_cgroup_hierarchical_reclaim(), used for soft
  * limit reclaim to prevent infinite loops, if they ever occur.
@@ -1847,18 +1874,7 @@ static void mem_cgroup_cancel_charge(str
  * it's concern. (dropping refcnt from swap can be called against removed
  * memcg.)
  */
-static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
-{
-	struct cgroup_subsys_state *css;
 
-	/* ID 0 is unused ID */
-	if (!id)
-		return NULL;
-	css = css_lookup(&mem_cgroup_subsys, id);
-	if (!css)
-		return NULL;
-	return container_of(css, struct mem_cgroup, css);
-}
 
 struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 {
@@ -1879,7 +1895,7 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 		ent.val = page_private(page);
 		id = lookup_swap_cgroup(ent);
 		rcu_read_lock();
-		mem = mem_cgroup_lookup(id);
+		mem = id_to_memcg(id);
 		if (mem && !css_tryget(&mem->css))
 			mem = NULL;
 		rcu_read_unlock();
@@ -2231,7 +2247,7 @@ __mem_cgroup_commit_charge_swapin(struct
 
 		id = swap_cgroup_record(ent, 0);
 		rcu_read_lock();
-		memcg = mem_cgroup_lookup(id);
+		memcg = id_to_memcg(id);
 		if (memcg) {
 			/*
 			 * This recorded memcg can be obsolete one. So, avoid
@@ -2240,9 +2256,10 @@ __mem_cgroup_commit_charge_swapin(struct
 			if (!mem_cgroup_is_root(memcg))
 				res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
 			mem_cgroup_swap_statistics(memcg, false);
+			rcu_read_unlock();
 			mem_cgroup_put(memcg);
-		}
-		rcu_read_unlock();
+		} else
+			rcu_read_unlock();
 	}
 	/*
 	 * At swapin, we may charge account against cgroup which has no tasks.
@@ -2495,7 +2512,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
 
 	id = swap_cgroup_record(ent, 0);
 	rcu_read_lock();
-	memcg = mem_cgroup_lookup(id);
+	memcg = id_to_memcg(id);
 	if (memcg) {
 		/*
 		 * We uncharge this because swap is freed.
@@ -2504,9 +2521,10 @@ void mem_cgroup_uncharge_swap(swp_entry_
 		if (!mem_cgroup_is_root(memcg))
 			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
 		mem_cgroup_swap_statistics(memcg, false);
+		rcu_read_unlock();
 		mem_cgroup_put(memcg);
-	}
-	rcu_read_unlock();
+	} else
+		rcu_read_unlock();
 }
 
 /**
@@ -4010,6 +4028,9 @@ static struct mem_cgroup *mem_cgroup_all
 	struct mem_cgroup *mem;
 	int size = sizeof(struct mem_cgroup);
 
+	if (atomic_read(&mem_cgroup_num) == NR_MEMCG_GROUPS)
+		return NULL;
+
 	/* Can be very big if MAX_NUMNODES is very big */
 	if (size < PAGE_SIZE)
 		mem = kmalloc(size, GFP_KERNEL);
@@ -4028,6 +4049,8 @@ static struct mem_cgroup *mem_cgroup_all
 			vfree(mem);
 		mem = NULL;
 	}
+	if (mem)
+		atomic_inc(&mem_cgroup_num);
 	return mem;
 }
 
@@ -4049,6 +4072,7 @@ static void __mem_cgroup_free(struct mem
 	mem_cgroup_remove_from_trees(mem);
 	free_css_id(&mem_cgroup_subsys, &mem->css);
 
+	atomic_dec(&mem_cgroup_num);
 	for_each_node_state(node, N_POSSIBLE)
 		free_mem_cgroup_per_zone_info(mem, node);
 
@@ -4059,6 +4083,12 @@ static void __mem_cgroup_free(struct mem
 		vfree(mem);
 }
 
+static void mem_cgroup_free(struct mem_cgroup *mem)
+{
+	unregister_memcg_id(mem);
+	__mem_cgroup_free(mem);
+}
+
 static void mem_cgroup_get(struct mem_cgroup *mem)
 {
 	atomic_inc(&mem->refcnt);
@@ -4068,7 +4098,7 @@ static void __mem_cgroup_put(struct mem_
 {
 	if (atomic_sub_and_test(count, &mem->refcnt)) {
 		struct mem_cgroup *parent = parent_mem_cgroup(mem);
-		__mem_cgroup_free(mem);
+		mem_cgroup_free(mem);
 		if (parent)
 			mem_cgroup_put(parent);
 	}
@@ -4189,9 +4219,10 @@ mem_cgroup_create(struct cgroup_subsys *
 	atomic_set(&mem->refcnt, 1);
 	mem->move_charge_at_immigrate = 0;
 	mutex_init(&mem->thresholds_lock);
+	register_memcg_id(mem);
 	return &mem->css;
 free_out:
-	__mem_cgroup_free(mem);
+	mem_cgroup_free(mem);
 	root_mem_cgroup = NULL;
 	return ERR_PTR(error);
 }
Index: mmotm-0827/init/Kconfig
===================================================================
--- mmotm-0827.orig/init/Kconfig
+++ mmotm-0827/init/Kconfig
@@ -612,6 +612,16 @@ config CGROUP_MEM_RES_CTLR_SWAP
 	  Now, memory usage of swap_cgroup is 2 bytes per entry. If swap page
 	  size is 4096bytes, 512k per 1Gbytes of swap.
 
+config MEM_CGROUP_MAX_GROUPS
+	int "Maximum number of memory cgroups on a system"
+	range 1 65535
+	default 8192 if 64BIT
+	default 2048 if 32BIT
+	help
+	  Memory cgroup has limitation of the number of groups created.
+	  Please select your favorite value. The more you allow, the more
+	  memory(a pointer per group) will be consumed.
+
 menuconfig CGROUP_SCHED
 	bool "Group CPU scheduler"
 	depends on EXPERIMENTAL && CGROUPS

