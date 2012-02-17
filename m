Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab2BQJ2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:28:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56223 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2BQJ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:28:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 17 Feb 2012 18:26:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>
Subject: [PATCH 3/6] memcg: remove PCG_MOVE_LOCK flag from page_cgroup
Message-Id: <20120217182651.c12bfc5e.kamezawa.hiroyu@jp.fujitsu.com>
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

>From 62a96c625be0c30fc5828d88685b6873ed254060 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 2 Feb 2012 11:49:59 +0900
Subject: [PATCH 3/6] memcg: remove PCG_MOVE_LOCK flag from page_cgroup.

PCG_MOVE_LOCK is used for bit spinlock to avoid race between overwriting
pc->mem_cgroup and page statistics accounting per memcg.
This lock helps to avoid the race but the race is very rare because moving
tasks between cgroup is not a usual job.
So, it seems using 1bit per page is too costly.

This patch changes this lock as per-memcg spinlock and removes PCG_MOVE_LOCK.

If smaller lock is required, we'll be able to add some hashes but
I'd like to start from this.

Changelog:
  - fixed to pass memcg as an argument rather than page_cgroup.
    and renamed from move_lock_page_cgroup() to move_lock_mem_cgroup()

Acked-by: Greg Thelen <gthelen@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/page_cgroup.h |   19 -------------------
 mm/memcontrol.c             |   42 ++++++++++++++++++++++++++++++++----------
 2 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index 1060292..7a3af74 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -7,7 +7,6 @@ enum {
 	PCG_USED, /* this object is in use. */
 	PCG_MIGRATION, /* under page migration */
 	/* flags for mem_cgroup and file and I/O status */
-	PCG_MOVE_LOCK, /* For race between move_account v.s. following bits */
 	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
 	__NR_PCG_FLAGS,
 };
@@ -89,24 +88,6 @@ static inline void unlock_page_cgroup(struct page_cgroup *pc)
 	bit_spin_unlock(PCG_LOCK, &pc->flags);
 }
 
-static inline void move_lock_page_cgroup(struct page_cgroup *pc,
-	unsigned long *flags)
-{
-	/*
-	 * We know updates to pc->flags of page cache's stats are from both of
-	 * usual context or IRQ context. Disable IRQ to avoid deadlock.
-	 */
-	local_irq_save(*flags);
-	bit_spin_lock(PCG_MOVE_LOCK, &pc->flags);
-}
-
-static inline void move_unlock_page_cgroup(struct page_cgroup *pc,
-	unsigned long *flags)
-{
-	bit_spin_unlock(PCG_MOVE_LOCK, &pc->flags);
-	local_irq_restore(*flags);
-}
-
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct page_cgroup;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9c94389..7065028 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -280,6 +280,8 @@ struct mem_cgroup {
 	 * set > 0 if pages under this cgroup are moving to other cgroup.
 	 */
 	atomic_t	moving_account;
+	/* taken only while moving_account > 0 */
+	spinlock_t	move_lock;
 	/*
 	 * percpu counter.
 	 */
@@ -1343,6 +1345,24 @@ static bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
 	return false;
 }
 
+/*
+ * Take this lock when
+ * - a code tries to modify page's memcg while it's USED.
+ * - a code tries to modify page state accounting in a memcg.
+ * see mem_cgroup_stealed(), too.
+ */
+static void move_lock_mem_cgroup(struct mem_cgroup *memcg,
+				  unsigned long *flags)
+{
+	spin_lock_irqsave(&memcg->move_lock, *flags);
+}
+
+static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
+				unsigned long *flags)
+{
+	spin_unlock_irqrestore(&memcg->move_lock, *flags);
+}
+
 /**
  * mem_cgroup_print_oom_info: Called from OOM with tasklist_lock held in read mode.
  * @memcg: The memory cgroup that went over limit
@@ -1867,7 +1887,7 @@ void mem_cgroup_update_page_stat(struct page *page,
 
 	if (mem_cgroup_disabled())
 		return;
-
+again:
 	rcu_read_lock();
 	memcg = pc->mem_cgroup;
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
@@ -1875,11 +1895,13 @@ void mem_cgroup_update_page_stat(struct page *page,
 	/* pc->mem_cgroup is unstable ? */
 	if (unlikely(mem_cgroup_stealed(memcg))) {
 		/* take a lock against to access pc->mem_cgroup */
-		move_lock_page_cgroup(pc, &flags);
+		move_lock_mem_cgroup(memcg, &flags);
+		if (memcg != pc->mem_cgroup || !PageCgroupUsed(pc)) {
+			move_unlock_mem_cgroup(memcg, &flags);
+			rcu_read_unlock();
+			goto again;
+		}
 		need_unlock = true;
-		memcg = pc->mem_cgroup;
-		if (!memcg || !PageCgroupUsed(pc))
-			goto out;
 	}
 
 	switch (idx) {
@@ -1898,7 +1920,7 @@ void mem_cgroup_update_page_stat(struct page *page,
 
 out:
 	if (unlikely(need_unlock))
-		move_unlock_page_cgroup(pc, &flags);
+		move_unlock_mem_cgroup(memcg, &flags);
 	rcu_read_unlock();
 }
 
@@ -2440,8 +2462,7 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
-#define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MOVE_LOCK) |\
-			(1 << PCG_MIGRATION))
+#define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MIGRATION))
 /*
  * Because tail pages are not marked as "used", set it. We're under
  * zone->lru_lock, 'splitting on pmd' and compound_lock.
@@ -2512,7 +2533,7 @@ static int mem_cgroup_move_account(struct page *page,
 	if (!PageCgroupUsed(pc) || pc->mem_cgroup != from)
 		goto unlock;
 
-	move_lock_page_cgroup(pc, &flags);
+	move_lock_mem_cgroup(from, &flags);
 
 	if (PageCgroupFileMapped(pc)) {
 		/* Update mapped_file data for mem_cgroup */
@@ -2536,7 +2557,7 @@ static int mem_cgroup_move_account(struct page *page,
 	 * guaranteed that "to" is never removed. So, we don't check rmdir
 	 * status here.
 	 */
-	move_unlock_page_cgroup(pc, &flags);
+	move_unlock_mem_cgroup(from, &flags);
 	ret = 0;
 unlock:
 	unlock_page_cgroup(pc);
@@ -4928,6 +4949,7 @@ mem_cgroup_create(struct cgroup *cont)
 	atomic_set(&memcg->refcnt, 1);
 	memcg->move_charge_at_immigrate = 0;
 	mutex_init(&memcg->thresholds_lock);
+	spin_lock_init(&memcg->move_lock);
 	return &memcg->css;
 free_out:
 	__mem_cgroup_free(memcg);
-- 
1.7.4.1


