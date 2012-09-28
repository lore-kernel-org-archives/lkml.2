Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab2I1IGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:06:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38176 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923Ab2I1IFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:05:39 -0400
Date: Fri, 28 Sep 2012 01:05:23 -0700
From: tip-bot for Rik van Riel <riel@redhat.com>
Message-ID: <tip-7eaffe9d688041a66acac719aa7eaec23fb1f437@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, riel@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <20120726135425.48820aae@cuia.bos.redhat.com>
References: <20120726135425.48820aae@cuia.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm, numa: Retry failed page migrations
Git-Commit-ID: 7eaffe9d688041a66acac719aa7eaec23fb1f437
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 01:05:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7eaffe9d688041a66acac719aa7eaec23fb1f437
Gitweb:     http://git.kernel.org/tip/7eaffe9d688041a66acac719aa7eaec23fb1f437
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Thu, 26 Jul 2012 13:54:25 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Sep 2012 19:18:06 +0200

mm, numa: Retry failed page migrations

Keep track of how many NUMA page migrations succeeded and
failed (in a way that wants retrying later) per process.

If a lot of the page migrations of a process fail, unmap the
process pages some point later, so the migration can be tried
again at the next fault.

Signed-off-by: Rik van Riel <riel@redhat.com>
[ Fwd ported several times as the code changed, added some wrappers
  to aid compilability for certain CONFIG variants.
  Also need to note that the lack of atomics means we can go all funny
  but since its decaying stats it should recover eventually. If it
  goes funny too often we could look at improving this. ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20120726135425.48820aae@cuia.bos.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mm_types.h |   16 ++++++++++++++++
 kernel/sched/core.c      |    2 ++
 kernel/sched/fair.c      |   16 ++++++++++++++--
 mm/memory.c              |   12 +++++++++---
 4 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index e7fb4bc..ffb3b2d 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -412,10 +412,26 @@ struct mm_struct {
 #ifdef CONFIG_SCHED_NUMA
 	unsigned int  numa_big;
 	unsigned long numa_next_scan;
+	unsigned int  numa_migrate_success;
+	unsigned int  numa_migrate_failed;
 #endif
 	struct uprobes_state uprobes_state;
 };
 
+#ifdef CONFIG_SCHED_NUMA
+static __always_inline void mm_inc_numa_migrate(struct mm_struct *mm, bool success)
+{
+	if (success)
+		mm->numa_migrate_success++;
+	else
+		mm->numa_migrate_failed++;
+}
+#else
+static inline void mm_inc_numa_migrate(struct mm_struct *mm, bool success)
+{
+}
+#endif /* CONFNIG_SCHED_NUMA */
+
 static inline bool mm_numa_big(struct mm_struct *mm)
 {
 #ifdef CONFIG_SCHED_NUMA
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6668b0d..c631a02 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1538,6 +1538,8 @@ static void __sched_fork(struct task_struct *p)
 	if (p->mm && atomic_read(&p->mm->mm_users) == 1) {
 		p->mm->numa_big = 0;
 		p->mm->numa_next_scan = jiffies;
+		p->mm->numa_migrate_success = 0;
+		p->mm->numa_migrate_failed = 0;
 	}
 
 	p->node = -1;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 76a0920..248492a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -861,6 +861,12 @@ static bool task_numa_big(struct task_struct *p)
 	return runtime > walltime * max(1, weight / 2);
 }
 
+static bool had_many_migrate_failures(struct task_struct *p)
+{
+	/* More than 1/4 of the attempted NUMA page migrations failed. */
+	return p->mm->numa_migrate_failed * 3 > p->mm->numa_migrate_success;
+}
+
 static inline bool need_numa_migration(struct task_struct *p)
 {
 	/*
@@ -927,7 +933,13 @@ void task_numa_work(struct callback_head *work)
 	if (cmpxchg(&p->mm->numa_next_scan, migrate, next_scan) != migrate)
 		return;
 
-	big = p->mm->numa_big = task_numa_big(p);
+	if (!big) {
+		/* Age the numa migrate statistics. */
+		p->mm->numa_migrate_failed /= 2;
+		p->mm->numa_migrate_success /= 2;
+
+		big = p->mm->numa_big = task_numa_big(p);
+	}
 
 	if (need_migration) {
 		if (big)
@@ -936,7 +948,7 @@ void task_numa_work(struct callback_head *work)
 			sched_setnode_process(p, p->node_curr);
 	}
 
-	if (big || need_migration)
+	if (big || need_migration || had_many_migrate_failures(p))
 		lazy_migrate_process(p->mm);
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index f10b4e2..ab5c170 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3446,15 +3446,21 @@ static bool pte_prot_none(struct vm_area_struct *vma, pte_t pte)
 static void do_prot_none_numa(struct mm_struct *mm, struct vm_area_struct *vma,
 			      unsigned long address, struct page *page)
 {
-	int node;
+	int node, ret;
 
 	/*
 	 * For NUMA systems we use the special PROT_NONE maps to drive
 	 * lazy page migration, see MPOL_MF_LAZY and related.
 	 */
 	node = mpol_misplaced(page, vma, address, mm_numa_big(mm));
-	if (node != -1)
-		migrate_misplaced_page(mm, page, node);
+	if (node != -1) {
+		ret = migrate_misplaced_page(mm, page, node);
+		if (!ret)
+			mm_inc_numa_migrate(mm, true);
+		else if (ret == -ENOMEM || ret == -EBUSY)
+			mm_inc_numa_migrate(mm, false);
+	} else
+		mm_inc_numa_migrate(mm, true);
 }
 #else
 static void do_prot_none_numa(struct mm_struct *mm, struct vm_area_struct *vma,
