Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab2JRRGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:06:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46793 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab2JRRGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:06:51 -0400
Date: Thu, 18 Oct 2012 10:06:37 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-hz6rnixgr665fv0offesjofb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] sched/numa/mm:
  Fix and further simplify fault accounting
Git-Commit-ID: 617fe041711635713ec52ed5f36d6f46f38d83f2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 18 Oct 2012 10:06:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  617fe041711635713ec52ed5f36d6f46f38d83f2
Gitweb:     http://git.kernel.org/tip/617fe041711635713ec52ed5f36d6f46f38d83f2
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sun, 14 Oct 2012 21:30:07 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 15 Oct 2012 14:21:13 +0200

sched/numa/mm: Fix and further simplify fault accounting

The THP alloc failure path did double accounting .. fix this.

While we're at it, merge task_numa_placement() into task_numa_fault()
so that there's only a single call from the fault path.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-hz6rnixgr665fv0offesjofb@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |    5 -----
 kernel/sched/fair.c   |   43 +++++++++++++++++++++----------------------
 mm/huge_memory.c      |    4 ----
 3 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2c3009b..c86db44 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1608,7 +1608,6 @@ static inline int tsk_home_node(struct task_struct *p)
 	return p->node;
 }
 
-extern void task_numa_placement(void);
 extern void task_numa_fault(int node, int pages);
 #else
 static inline int tsk_home_node(struct task_struct *p)
@@ -1616,10 +1615,6 @@ static inline int tsk_home_node(struct task_struct *p)
 	return -1;
 }
 
-static inline void task_numa_placement(void)
-{
-}
-
 static inline void task_numa_fault(int node, int pages)
 {
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df35c8d..530448c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -832,27 +832,9 @@ unsigned int sysctl_sched_numa_task_period_max = 5000*16;
  */
 unsigned int sysctl_sched_numa_settle_count = 2;
 
-/*
- * Got a PROT_NONE fault for a page on @node.
- */
-void task_numa_fault(int node, int pages)
-{
-	struct task_struct *p = current;
-
-	if (unlikely(!p->numa_faults)) {
-		p->numa_faults = kzalloc(sizeof(unsigned long) * nr_node_ids,
-					 GFP_KERNEL);
-		if (!p->numa_faults)
-			return;
-	}
-
-	p->numa_faults[node] += pages;
-}
-
-void task_numa_placement(void)
+static void task_numa_placement(struct task_struct *p)
 {
 	unsigned long faults, max_faults = 0;
-	struct task_struct *p = current;
 	int node, max_node = -1;
 	int seq = ACCESS_ONCE(p->mm->numa_scan_seq);
 
@@ -861,9 +843,6 @@ void task_numa_placement(void)
 
 	p->numa_scan_seq = seq;
 
-	if (unlikely(!p->numa_faults))
-		return;
-
 	for (node = 0; node < nr_node_ids; node++) {
 		faults = p->numa_faults[node];
 
@@ -892,6 +871,26 @@ void task_numa_placement(void)
 }
 
 /*
+ * Got a PROT_NONE fault for a page on @node.
+ */
+void task_numa_fault(int node, int pages)
+{
+	struct task_struct *p = current;
+
+	if (unlikely(!p->numa_faults)) {
+		int size = sizeof(unsigned long) * nr_node_ids;
+
+		p->numa_faults = kzalloc(size, GFP_KERNEL);
+		if (!p->numa_faults)
+			return;
+	}
+
+	task_numa_placement(p);
+
+	p->numa_faults[node] += pages;
+}
+
+/*
  * The expensive part of numa migration is done from task_work context.
  * Triggered from task_tick_numa().
  */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2b65116..5afd0d7 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -800,7 +800,6 @@ fixup:
 unlock:
 	spin_unlock(&mm->page_table_lock);
 	if (page) {
-		task_numa_placement();
 		task_numa_fault(page_to_nid(page), HPAGE_PMD_NR);
 		put_page(page);
 	}
@@ -823,8 +822,6 @@ migrate:
 	}
 	spin_unlock(&mm->page_table_lock);
 
-	task_numa_placement();
-
 	new_page = alloc_pages_node(node,
 	    (GFP_TRANSHUGE | GFP_THISNODE) & ~(__GFP_NO_KSWAPD | __GFP_WAIT),
 	    HPAGE_PMD_ORDER);
@@ -895,7 +892,6 @@ alloc_fail:
 	if (new_page)
 		put_page(new_page);
 
-	task_numa_fault(page_to_nid(page), HPAGE_PMD_NR);
 	unlock_page(page);
 
 	spin_lock(&mm->page_table_lock);
