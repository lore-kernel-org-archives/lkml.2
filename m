Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab0I0J6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:58:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40366 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758362Ab0I0J6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:58:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 27 Sep 2010 18:51:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [RFC][PATCH 1/4] memcg: replace page_cgroup->mem_cgroup to be
 unsigned short
Message-Id: <20100927185123.c7eb2123.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100927184821.f4bf2b2c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100924181302.7d764e0d.kamezawa.hiroyu@jp.fujitsu.com>
	<20100927184821.f4bf2b2c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

replaces page_cgroup->mem_cgroup to be an unsigned short.
And add an ID for blkio cgroup.

More work will be required for reducing sturct page_cgroup size,
but maybe good as 1st step. As far as I tested, css_lookup() is enough fast.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/page_cgroup.h |    3 +
 mm/memcontrol.c             |   86 +++++++++++++++++++++++++++-----------------
 mm/page_cgroup.c            |    2 -
 3 files changed, 57 insertions(+), 34 deletions(-)

Index: mmotm-0922/include/linux/page_cgroup.h
===================================================================
--- mmotm-0922.orig/include/linux/page_cgroup.h
+++ mmotm-0922/include/linux/page_cgroup.h
@@ -12,7 +12,8 @@
  */
 struct page_cgroup {
 	unsigned long flags;
-	struct mem_cgroup *mem_cgroup;
+	unsigned short mem_cgroup;
+	unsigned short blkio_cgroup;
 	struct page *page;
 	struct list_head lru;		/* per cgroup LRU list */
 };
Index: mmotm-0922/mm/memcontrol.c
===================================================================
--- mmotm-0922.orig/mm/memcontrol.c
+++ mmotm-0922/mm/memcontrol.c
@@ -352,6 +352,40 @@ static void mem_cgroup_put(struct mem_cg
 static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
 static void drain_all_stock_async(void);
 
+/*
+ * A helper function to get mem_cgroup from ID. must be called under
+ * rcu_read_lock(). The caller must check css_is_removed() or some if
+ * it's concern. (dropping refcnt from swap can be called against removed
+ * memcg.)
+ */
+static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
+{
+	struct cgroup_subsys_state *css;
+
+	/* ID 0 is unused ID */
+	if (!id)
+		return NULL;
+	if (id == 1)
+		return root_mem_cgroup;
+	css = css_lookup(&mem_cgroup_subsys, id);
+	if (!css)
+		return NULL;
+	return container_of(css, struct mem_cgroup, css);
+}
+
+/*
+ * If the ID is from pc->mem_cgroup, the mem_cgroup refered by ID must be
+ * exist as "valid" cgroup. It's guaranteed. You can use this easy function.
+ */
+static struct memcg_lookup(unsigned short id)
+{
+	struct mem_cgroup *mem;
+
+	rcu_read_lock();
+	mem = mem_cgroup_lookup(id);
+	rcu_read_unlock();
+	return mem;
+}
 
 static struct mem_cgroup_per_zone *
 mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
@@ -367,7 +401,7 @@ struct cgroup_subsys_state *mem_cgroup_c
 static struct mem_cgroup_per_zone *
 page_cgroup_zoneinfo(struct page_cgroup *pc)
 {
-	struct mem_cgroup *mem = pc->mem_cgroup;
+	struct mem_cgroup *mem = memcg_lookup(pc->mem_cgroup);
 	int nid = page_cgroup_nid(pc);
 	int zid = page_cgroup_zid(pc);
 
@@ -778,6 +812,11 @@ static inline bool mem_cgroup_is_root(st
 	return (mem == root_mem_cgroup);
 }
 
+static inline bool mem_cgroup_id_is_root(unsigned short id)
+{
+	return (id == 1);
+}
+
 /*
  * Following LRU functions are allowed to be used without PCG_LOCK.
  * Operations are called by routine of global LRU independently from memcg.
@@ -810,7 +849,7 @@ void mem_cgroup_del_lru_list(struct page
 	 */
 	mz = page_cgroup_zoneinfo(pc);
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
-	if (mem_cgroup_is_root(pc->mem_cgroup))
+	if (mem_cgroup_id_is_root(pc->mem_cgroup))
 		return;
 	VM_BUG_ON(list_empty(&pc->lru));
 	list_del_init(&pc->lru);
@@ -837,7 +876,7 @@ void mem_cgroup_rotate_lru_list(struct p
 	 */
 	smp_rmb();
 	/* unused or root page is not rotated. */
-	if (!PageCgroupUsed(pc) || mem_cgroup_is_root(pc->mem_cgroup))
+	if (!PageCgroupUsed(pc) || mem_cgroup_id_is_root(pc->mem_cgroup))
 		return;
 	mz = page_cgroup_zoneinfo(pc);
 	list_move(&pc->lru, &mz->lists[lru]);
@@ -863,7 +902,7 @@ void mem_cgroup_add_lru_list(struct page
 	mz = page_cgroup_zoneinfo(pc);
 	MEM_CGROUP_ZSTAT(mz, lru) += 1;
 	SetPageCgroupAcctLRU(pc);
-	if (mem_cgroup_is_root(pc->mem_cgroup))
+	if (mem_cgroup_id_is_root(pc->mem_cgroup))
 		return;
 	list_add(&pc->lru, &mz->lists[lru]);
 }
@@ -1603,7 +1642,7 @@ static void mem_cgroup_update_file_stat(
 		return;
 
 	rcu_read_lock();
-	mem = pc->mem_cgroup;
+	mem = memcg_lookup(pc->mem_cgroup);
 	if (unlikely(!mem || !PageCgroupUsed(pc)))
 		goto out;
 	/* pc->mem_cgroup is unstable ? */
@@ -1611,7 +1650,7 @@ static void mem_cgroup_update_file_stat(
 		/* take a lock against to access pc->mem_cgroup */
 		lock_page_cgroup(pc);
 		need_unlock = true;
-		mem = pc->mem_cgroup;
+		mem = memcg_lookup(pc->mem_cgroup);
 		if (!mem || !PageCgroupUsed(pc))
 			goto out;
 	}
@@ -2030,24 +2069,6 @@ static void mem_cgroup_cancel_charge(str
 	__mem_cgroup_cancel_charge(mem, 1);
 }
 
-/*
- * A helper function to get mem_cgroup from ID. must be called under
- * rcu_read_lock(). The caller must check css_is_removed() or some if
- * it's concern. (dropping refcnt from swap can be called against removed
- * memcg.)
- */
-static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
-{
-	struct cgroup_subsys_state *css;
-
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
@@ -2061,7 +2082,7 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 	pc = lookup_page_cgroup(page);
 	lock_page_cgroup(pc);
 	if (PageCgroupUsed(pc)) {
-		mem = pc->mem_cgroup;
+		mem = memcg_lookup(pc->mem_cgroup);
 		if (mem && !css_tryget(&mem->css))
 			mem = NULL;
 	} else if (PageSwapCache(page)) {
@@ -2097,7 +2118,7 @@ static void __mem_cgroup_commit_charge(s
 		return;
 	}
 
-	pc->mem_cgroup = mem;
+	pc->mem_cgroup = css_id(&mem->css);
 	/*
 	 * We access a page_cgroup asynchronously without lock_page_cgroup().
 	 * Especially when a page_cgroup is taken from a page, pc->mem_cgroup
@@ -2155,7 +2176,7 @@ static void __mem_cgroup_move_account(st
 	VM_BUG_ON(PageLRU(pc->page));
 	VM_BUG_ON(!PageCgroupLocked(pc));
 	VM_BUG_ON(!PageCgroupUsed(pc));
-	VM_BUG_ON(pc->mem_cgroup != from);
+	VM_BUG_ON(pc->mem_cgroup != css_id(&from->css));
 
 	if (PageCgroupFileMapped(pc)) {
 		/* Update mapped_file data for mem_cgroup */
@@ -2170,7 +2191,7 @@ static void __mem_cgroup_move_account(st
 		mem_cgroup_cancel_charge(from);
 
 	/* caller should have done css_get */
-	pc->mem_cgroup = to;
+	pc->mem_cgroup = css_id(&to->css);
 	mem_cgroup_charge_statistics(to, pc, true);
 	/*
 	 * We charges against "to" which may not have any tasks. Then, "to"
@@ -2190,7 +2211,7 @@ static int mem_cgroup_move_account(struc
 {
 	int ret = -EINVAL;
 	lock_page_cgroup(pc);
-	if (PageCgroupUsed(pc) && pc->mem_cgroup == from) {
+	if (PageCgroupUsed(pc) && pc->mem_cgroup == css_id(&from->css)) {
 		__mem_cgroup_move_account(pc, from, to, uncharge);
 		ret = 0;
 	}
@@ -2529,7 +2550,7 @@ __mem_cgroup_uncharge_common(struct page
 
 	lock_page_cgroup(pc);
 
-	mem = pc->mem_cgroup;
+	mem = memcg_lookup(pc->mem_cgroup);
 
 	if (!PageCgroupUsed(pc))
 		goto unlock_out;
@@ -2774,7 +2795,7 @@ int mem_cgroup_prepare_migration(struct 
 	pc = lookup_page_cgroup(page);
 	lock_page_cgroup(pc);
 	if (PageCgroupUsed(pc)) {
-		mem = pc->mem_cgroup;
+		mem = memcg_lookup(pc->mem_cgroup);
 		css_get(&mem->css);
 		/*
 		 * At migrating an anonymous page, its mapcount goes down
@@ -4585,7 +4606,8 @@ static int is_target_pte_for_mc(struct v
 		 * mem_cgroup_move_account() checks the pc is valid or not under
 		 * the lock.
 		 */
-		if (PageCgroupUsed(pc) && pc->mem_cgroup == mc.from) {
+		if (PageCgroupUsed(pc) &&
+			pc->mem_cgroup == css_id(&mc.from->css)) {
 			ret = MC_TARGET_PAGE;
 			if (target)
 				target->page = page;
Index: mmotm-0922/mm/page_cgroup.c
===================================================================
--- mmotm-0922.orig/mm/page_cgroup.c
+++ mmotm-0922/mm/page_cgroup.c
@@ -15,7 +15,7 @@ static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
 {
 	pc->flags = 0;
-	pc->mem_cgroup = NULL;
+	pc->mem_cgroup = 0;
 	pc->page = pfn_to_page(pfn);
 	INIT_LIST_HEAD(&pc->lru);
 }

