Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2BQJ3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:29:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49809 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab2BQJ3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:29:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 17 Feb 2012 18:27:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>
Subject: [PATCH 4/6] memcg: use new logic for page stat accounting.
Message-Id: <20120217182743.2d5f629e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120217182426.86aebfde.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120217182426.86aebfde.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5bf592d432e4552db74e94a575afcd83aa652a9d Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 2 Feb 2012 11:49:59 +0900
Subject: [PATCH 4/6] memcg: use new logic for page stat accounting.

Now, page-stat-per-memcg is recorded into per page_cgroup flag by
duplicating page's status into the flag. The reason is that memcg
has a feature to move a page from a group to another group and we
have race between "move" and "page stat accounting",

Under current logic, assume CPU-A and CPU-B. CPU-A does "move"
and CPU-B does "page stat accounting".

When CPU-A goes 1st,

            CPU-A                           CPU-B
                                    update "struct page" info.
    move_lock_mem_cgroup(memcg)
    see pc->flags
    copy page stat to new group
    overwrite pc->mem_cgroup.
    move_unlock_mem_cgroup(memcg)
                                    move_lock_mem_cgroup(mem)
                                    set pc->flags
                                    update page stat accounting
                                    move_unlock_mem_cgroup(mem)

stat accounting is guarded by move_lock_mem_cgroup() and "move"
logic (CPU-A) doesn't see changes in "struct page" information.

But it's costly to have the same information both in 'struct page' and
'struct page_cgroup'. And, there is a potential problem.

For example, assume we have PG_dirty accounting in memcg.
PG_..is a flag for struct page.
PCG_ is a flag for struct page_cgroup.
(This is just an example. The same problem can be found in any
 kind of page stat accounting.)

	  CPU-A                               CPU-B
      TestSet PG_dirty
      (delay)                        TestClear PG_dirty
                                     if (TestClear(PCG_dirty))
                                          memcg->nr_dirty--
      if (TestSet(PCG_dirty))
          memcg->nr_dirty++

Here, memcg->nr_dirty = +1, this is wrong.
This race was reported by  Greg Thelen <gthelen@google.com>.
Now, only FILE_MAPPED is supported but fortunately, it's serialized by
page table lock and this is not real bug, _now_,

If this potential problem is caused by having duplicated information in
struct page and struct page_cgroup, we may be able to fix this by using
original 'struct page' information.
But we'll have a problem in "move account"

Assume we use only PG_dirty.

         CPU-A                   CPU-B
    TestSet PG_dirty
    (delay)                    move_lock_mem_cgroup()
                               if (PageDirty(page))
                                      new_memcg->nr_dirty++
                               pc->mem_cgroup = new_memcg;
                               move_unlock_mem_cgroup()
    move_lock_mem_cgroup()
    memcg = pc->mem_cgroup
    new_memcg->nr_dirty++

accounting information may be double-counted. This was original
reason to have PCG_xxx flags but it seems PCG_xxx has another problem.

I think we need a bigger lock as

     move_lock_mem_cgroup(page)
     TestSetPageDirty(page)
     update page stats (without any checks)
     move_unlock_mem_cgroup(page)

This fixes both of problems and we don't have to duplicate page flag
into page_cgroup. Please note: move_lock_mem_cgroup() is held
only when there are possibility of "account move" under the system.
So, in most path, status update will go without atomic locks.

This patch introduce mem_cgroup_begin_update_page_stat() and
mem_cgroup_end_update_page_stat() both should be called at modifying
'struct page' information if memcg takes care of it. as

     mem_cgroup_begin_update_page_stat()
     modify page information
     mem_cgroup_update_page_stat()
     => never check any 'struct page' info, just update counters.
     mem_cgroup_end_update_page_stat().

This patch is slow because we need to call begin_update_page_stat()/
end_update_page_stat() regardless of accounted will be changed or not.
A following patch adds an easy optimization and reduces the cost.

Changes since v4
 - removed unused argument *lock
 - added more comments.
Changes since v3
 - fixed typos

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |   35 ++++++++++++++++++++++++
 mm/memcontrol.c            |   64 ++++++++++++++++++++++++++++++-------------
 mm/rmap.c                  |   15 +++++++++-
 3 files changed, 92 insertions(+), 22 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bf4e1f4..75b6307 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -141,6 +141,31 @@ static inline bool mem_cgroup_disabled(void)
 	return false;
 }
 
+void __mem_cgroup_begin_update_page_stat(struct page *page,
+					bool *lock, unsigned long *flags);
+
+static inline void mem_cgroup_begin_update_page_stat(struct page *page,
+					bool *lock, unsigned long *flags)
+{
+	if (mem_cgroup_disabled())
+		return;
+	rcu_read_lock();
+	*lock = false;
+	return __mem_cgroup_begin_update_page_stat(page, lock, flags);
+}
+
+void __mem_cgroup_end_update_page_stat(struct page *page,
+				unsigned long *flags);
+static inline void mem_cgroup_end_update_page_stat(struct page *page,
+					bool *lock, unsigned long *flags)
+{
+	if (mem_cgroup_disabled())
+		return;
+	if (*lock)
+		__mem_cgroup_end_update_page_stat(page, flags);
+	rcu_read_unlock();
+}
+
 void mem_cgroup_update_page_stat(struct page *page,
 				 enum mem_cgroup_page_stat_item idx,
 				 int val);
@@ -356,6 +381,16 @@ mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 {
 }
 
+static inline void mem_cgroup_begin_update_page_stat(struct page *page,
+					bool *lock, unsigned long *flags)
+{
+}
+
+static inline void mem_cgroup_end_update_page_stat(struct page *page,
+					bool *lock, unsigned long *flags)
+{
+}
+
 static inline void mem_cgroup_inc_page_stat(struct page *page,
 					    enum mem_cgroup_page_stat_item idx)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7065028..86bdde0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1877,32 +1877,61 @@ bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask)
  * If there is, we take a lock.
  */
 
+void __mem_cgroup_begin_update_page_stat(struct page *page,
+				bool *lock, unsigned long *flags)
+{
+	struct mem_cgroup *memcg;
+	struct page_cgroup *pc;
+
+	pc = lookup_page_cgroup(page);
+again:
+	memcg = pc->mem_cgroup;
+	if (unlikely(!memcg || !PageCgroupUsed(pc)))
+		return;
+	/*
+	 * If this memory cgroup is not under account moving, we don't
+	 * need to take move_lock_page_cgroup(). Because we already hold
+	 * rcu_read_lock(), any calls to move_account will be delayed until
+	 * rcu_read_unlock() if mem_cgroup_stealed() == true.
+	 */
+	if (!mem_cgroup_stealed(memcg))
+		return;
+
+	move_lock_mem_cgroup(memcg, flags);
+	if (memcg != pc->mem_cgroup || !PageCgroupUsed(pc)) {
+		move_unlock_mem_cgroup(memcg, flags);
+		goto again;
+	}
+	*lock = true;
+}
+
+void __mem_cgroup_end_update_page_stat(struct page *page,
+				unsigned long *flags)
+{
+	struct page_cgroup *pc = lookup_page_cgroup(page);
+
+	/*
+	 * It's guaranteed that pc->mem_cgroup never changes while
+	 * lock is held because a routine modifies pc->mem_cgroup
+	 * should take move_lock_page_cgroup().
+	 */
+	move_unlock_mem_cgroup(pc->mem_cgroup, flags);
+}
+
+
 void mem_cgroup_update_page_stat(struct page *page,
 				 enum mem_cgroup_page_stat_item idx, int val)
 {
 	struct mem_cgroup *memcg;
 	struct page_cgroup *pc = lookup_page_cgroup(page);
-	bool need_unlock = false;
 	unsigned long uninitialized_var(flags);
 
 	if (mem_cgroup_disabled())
 		return;
-again:
-	rcu_read_lock();
+
 	memcg = pc->mem_cgroup;
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
-		goto out;
-	/* pc->mem_cgroup is unstable ? */
-	if (unlikely(mem_cgroup_stealed(memcg))) {
-		/* take a lock against to access pc->mem_cgroup */
-		move_lock_mem_cgroup(memcg, &flags);
-		if (memcg != pc->mem_cgroup || !PageCgroupUsed(pc)) {
-			move_unlock_mem_cgroup(memcg, &flags);
-			rcu_read_unlock();
-			goto again;
-		}
-		need_unlock = true;
-	}
+		return;
 
 	switch (idx) {
 	case MEMCG_NR_FILE_MAPPED:
@@ -1917,11 +1946,6 @@ again:
 	}
 
 	this_cpu_add(memcg->stat->count[idx], val);
-
-out:
-	if (unlikely(need_unlock))
-		move_unlock_mem_cgroup(memcg, &flags);
-	rcu_read_unlock();
 }
 
 /*
diff --git a/mm/rmap.c b/mm/rmap.c
index aa547d4..dd193db 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1150,10 +1150,15 @@ void page_add_new_anon_rmap(struct page *page,
  */
 void page_add_file_rmap(struct page *page)
 {
+	bool locked;
+	unsigned long flags;
+
+	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
 	if (atomic_inc_and_test(&page->_mapcount)) {
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
 		mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_MAPPED);
 	}
+	mem_cgroup_end_update_page_stat(page, &locked, &flags);
 }
 
 /**
@@ -1164,9 +1169,13 @@ void page_add_file_rmap(struct page *page)
  */
 void page_remove_rmap(struct page *page)
 {
+	bool locked;
+	unsigned long flags;
+
+	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
 	/* page still mapped by someone else? */
 	if (!atomic_add_negative(-1, &page->_mapcount))
-		return;
+		goto out;
 
 	/*
 	 * Now that the last pte has gone, s390 must transfer dirty
@@ -1183,7 +1192,7 @@ void page_remove_rmap(struct page *page)
 	 * and not charged by memcg for now.
 	 */
 	if (unlikely(PageHuge(page)))
-		return;
+		goto out;
 	if (PageAnon(page)) {
 		mem_cgroup_uncharge_page(page);
 		if (!PageTransHuge(page))
@@ -1204,6 +1213,8 @@ void page_remove_rmap(struct page *page)
 	 * Leaving it set also helps swapoff to reinstate ptes
 	 * faster for those pages still in swapcache.
 	 */
+out:
+	mem_cgroup_end_update_page_stat(page, &locked, &flags);
 }
 
 /*
-- 
1.7.4.1


