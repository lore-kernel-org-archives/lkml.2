Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0JOIRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 04:17:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55711 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab0JOIRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 04:17:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 15 Oct 2010 17:12:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Greg Thelen <gthelen@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [RFC][PATCH 2/2] memcg: new lock for mutual execution of
 account_move and file stats
Message-Id: <20101015171225.70d4ca8f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101015170627.e5033fa4.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101015170627.e5033fa4.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

When we try to enhance page's status update to support other flags,
one of problem is updating status from IRQ context.

Now, mem_cgroup_update_file_stat() takes lock_page_cgroup() to avoid
race with _account move_. IOW, there are no races with charge/uncharge
in nature. Considering an update from IRQ context, it seems better
to disable IRQ at lock_page_cgroup() to avoid deadlock.

But lock_page_cgroup() is used too widerly and adding IRQ disable
there makes the performance bad. To avoid the big hammer, this patch
adds a new lock for update_stat().

This lock is for mutual execustion of updating stat and accout moving.
This adds a new lock to move_account..so, this makes move_account slow.
But considering trade-off, I think it's acceptable.

A score of moving 8GB anon pages, 8cpu Xeon(3.1GHz) is here.

[before patch] (mmotm + optimization patch (#1 in this series)
[root@bluextal kamezawa]# time echo 2257 > /cgroup/B/tasks

real    0m0.694s
user    0m0.000s
sys     0m0.683s

[After patch]
[root@bluextal kamezawa]# time echo 2238 > /cgroup/B/tasks

real    0m0.741s
user    0m0.000s
sys     0m0.730s

This moves 8Gbytes == 2048k pages. But no bad effects to codes
other than "move".

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/page_cgroup.h |   29 +++++++++++++++++++++++++++++
 mm/memcontrol.c             |   11 +++++++++--
 2 files changed, 38 insertions(+), 2 deletions(-)

Index: mmotm-1013/include/linux/page_cgroup.h
===================================================================
--- mmotm-1013.orig/include/linux/page_cgroup.h
+++ mmotm-1013/include/linux/page_cgroup.h
@@ -36,6 +36,7 @@ struct page_cgroup *lookup_page_cgroup(s
 enum {
 	/* flags for mem_cgroup */
 	PCG_LOCK,  /* page cgroup is locked */
+	PCG_LOCK_STATS, /* page cgroup's stat accounting flags are locked */
 	PCG_CACHE, /* charged as cache */
 	PCG_USED, /* this object is in use. */
 	PCG_ACCT_LRU, /* page has been accounted for */
@@ -104,6 +105,34 @@ static inline void unlock_page_cgroup(st
 	bit_spin_unlock(PCG_LOCK, &pc->flags);
 }
 
+/*
+ * Because page's status can be updated in IRQ context(PG_writeback)
+ * we disable IRQ at updating page's stat.
+ */
+static inline void lock_page_cgroup_stat(struct page_cgroup *pc,
+	unsigned long *flags)
+{
+	local_irq_save(*flags);
+	bit_spin_lock(PCG_LOCK_STATS, &pc->flags);
+}
+
+static inline void __lock_page_cgroup_stat(struct page_cgroup *pc)
+{
+	bit_spin_lock(PCG_LOCK_STATS, &pc->flags);
+}
+
+static inline void unlock_page_cgroup_stat(struct page_cgroup *pc,
+	unsigned long *flags)
+{
+	bit_spin_unlock(PCG_LOCK_STATS, &pc->flags);
+	local_irq_restore(*flags);
+}
+
+static inline void __unlock_page_cgroup_stat(struct page_cgroup *pc)
+{
+	bit_spin_unlock(PCG_LOCK_STATS, &pc->flags);
+}
+
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct page_cgroup;
 
Index: mmotm-1013/mm/memcontrol.c
===================================================================
--- mmotm-1013.orig/mm/memcontrol.c
+++ mmotm-1013/mm/memcontrol.c
@@ -1596,6 +1596,7 @@ static void mem_cgroup_update_file_stat(
 	struct mem_cgroup *mem;
 	struct page_cgroup *pc = lookup_page_cgroup(page);
 	bool need_unlock = false;
+	unsigned long flags = 0;
 
 	if (unlikely(!pc))
 		return;
@@ -1607,7 +1608,7 @@ static void mem_cgroup_update_file_stat(
 	/* pc->mem_cgroup is unstable ? */
 	if (unlikely(mem_cgroup_stealed(mem))) {
 		/* take a lock against to access pc->mem_cgroup */
-		lock_page_cgroup(pc);
+		lock_page_cgroup_stat(pc, &flags);
 		need_unlock = true;
 		mem = pc->mem_cgroup;
 		if (!mem || !PageCgroupUsed(pc))
@@ -1629,7 +1630,7 @@ static void mem_cgroup_update_file_stat(
 
 out:
 	if (unlikely(need_unlock))
-		unlock_page_cgroup(pc);
+		unlock_page_cgroup_stat(pc, &flags);
 	rcu_read_unlock();
 	return;
 }
@@ -2187,12 +2188,18 @@ static int mem_cgroup_move_account(struc
 		struct mem_cgroup *from, struct mem_cgroup *to, bool uncharge)
 {
 	int ret = -EINVAL;
+
+	/* Avoiding dead-lock with page stat updates via irq context */
+	local_irq_disable();
 	lock_page_cgroup(pc);
 	if (PageCgroupUsed(pc) && pc->mem_cgroup == from) {
+		__lock_page_cgroup_stat(pc);
 		__mem_cgroup_move_account(pc, from, to, uncharge);
+		__unlock_page_cgroup_stat(pc);
 		ret = 0;
 	}
 	unlock_page_cgroup(pc);
+	local_irq_enable();
 	/*
 	 * check events
 	 */

