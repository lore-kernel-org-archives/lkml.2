Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab2JUMxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 08:53:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48802 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2JUMxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 08:53:38 -0400
Date: Sun, 21 Oct 2012 05:53:11 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-wt5b48o2226ec63784i58s3j@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, riel@redhat.com,
        akpm@linux-foundation.org, aarcange@redhat.com, tglx@linutronix.de
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        aarcange@redhat.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] sched, numa, mm: Implement constant,
  per task Working Set Sampling (WSS) rate
Git-Commit-ID: 3d049f8a5398d0050ab9978b3ac67402f337390f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 21 Oct 2012 05:53:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d049f8a5398d0050ab9978b3ac67402f337390f
Gitweb:     http://git.kernel.org/tip/3d049f8a5398d0050ab9978b3ac67402f337390f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sun, 14 Oct 2012 16:59:13 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 21 Oct 2012 14:40:27 +0200

sched, numa, mm: Implement constant, per task Working Set Sampling (WSS) rate

Previously, to probe the working set of a task, we'd use
a very simple and crude method: mark all of its address
space PROT_NONE.

That method has various (obvious) disadvantages:

 - it samples the working set at dissimilar rates,
   giving some tasks a sampling quality advantage
   over others.

 - creates performance problems for tasks with very
   large working sets

 - over-samples processes with large address spaces but
   which only very rarely execute

Improve that method by keeping a rotating offset into the
address space that marks the current position of the scan,
and advance it by a constant rate (in a CPU cycles execution
proportional manner). If the offset reaches the last mapped
address of the mm then it then it starts over at the first
address.

The per-task nature of the working set sampling functionality
in this tree allows such constant rate, per task,
execution-weight proportional sampling of the working set,
with an adaptive sampling interval/frequency that goes from
once per 100 msecs up to just once per 1.6 seconds.
The current sampling volume is 256 MB per interval.

As tasks mature and converge their working set, so does the
sampling rate slow down to just a trickle, 256 MB per 1.6
seconds of CPU time executed.

This, beyond being adaptive, also rate-limits rarely
executing systems and does not over-sample on overloaded
systems.

[ In AutoNUMA speak, this patch deals with the effective sampling
  rate of the 'hinting page fault'. AutoNUMA's scanning is
  currently rate-limited, but it is also fundamentally
  single-threaded, executing in the knuma_scand kernel thread,
  so the limit in AutoNUMA is global and does not scale up with
  the number of CPUs, nor does it scan tasks in an execution
  proportional manner.

  So the idea of rate-limiting the scanning was first implemented
  in the AutoNUMA tree via a global rate limit. This patch goes
  beyond that by implementing an execution rate proportional
  working set sampling rate that is not implemented via a single
  global scanning daemon. ]

Based-on-idea-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Link: http://lkml.kernel.org/n/tip-wt5b48o2226ec63784i58s3j@git.kernel.org
[ Wrote changelog and fixed bug. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mempolicy.h |    2 --
 include/linux/mm.h        |    6 ++++++
 include/linux/mm_types.h  |    1 +
 include/linux/sched.h     |    1 +
 kernel/sched/fair.c       |   44 ++++++++++++++++++++++++++++++++++++++++----
 kernel/sysctl.c           |    7 +++++++
 mm/mempolicy.c            |   24 ------------------------
 7 files changed, 55 insertions(+), 30 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index a5bf9d6..d6b1ea1 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -199,8 +199,6 @@ static inline int vma_migratable(struct vm_area_struct *vma)
 
 extern int mpol_misplaced(struct page *, struct vm_area_struct *, unsigned long);
 
-extern void lazy_migrate_process(struct mm_struct *mm);
-
 #else /* CONFIG_NUMA */
 
 struct mempolicy {};
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 423464b..64ccf29 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1581,6 +1581,12 @@ static inline pgprot_t vma_prot_none(struct vm_area_struct *vma)
 	return pgprot_modify(vma->vm_page_prot, vm_get_page_prot(vmflags));
 }
 
+static inline void
+change_prot_none(struct vm_area_struct *vma, unsigned long start, unsigned long end)
+{
+	change_protection(vma, start, end, vma_prot_none(vma), 0);
+}
+
 struct vm_area_struct *find_extend_vma(struct mm_struct *, unsigned long addr);
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index bef4c5e..01c1d04 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -405,6 +405,7 @@ struct mm_struct {
 #endif
 #ifdef CONFIG_SCHED_NUMA
 	unsigned long numa_next_scan;
+	unsigned long numa_scan_offset;
 	int numa_scan_seq;
 #endif
 	struct uprobes_state uprobes_state;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9e726f0..63c011e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2022,6 +2022,7 @@ extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
 
 extern unsigned int sysctl_sched_numa_task_period_min;
 extern unsigned int sysctl_sched_numa_task_period_max;
+extern unsigned int sysctl_sched_numa_scan_size;
 extern unsigned int sysctl_sched_numa_settle_count;
 
 #ifdef CONFIG_SCHED_DEBUG
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a66a1b6..9f7406e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -827,8 +827,9 @@ static void account_numa_dequeue(struct rq *rq, struct task_struct *p)
 /*
  * numa task sample period in ms: 5s
  */
-unsigned int sysctl_sched_numa_task_period_min = 5000;
-unsigned int sysctl_sched_numa_task_period_max = 5000*16;
+unsigned int sysctl_sched_numa_task_period_min = 100;
+unsigned int sysctl_sched_numa_task_period_max = 100*16;
+unsigned int sysctl_sched_numa_scan_size = 256;   /* MB */
 
 /*
  * Wait for the 2-sample stuff to settle before migrating again
@@ -902,6 +903,9 @@ void task_numa_work(struct callback_head *work)
 	unsigned long migrate, next_scan, now = jiffies;
 	struct task_struct *p = current;
 	struct mm_struct *mm = p->mm;
+	struct vm_area_struct *vma;
+	unsigned long offset, end;
+	long length;
 
 	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
 
@@ -928,8 +932,40 @@ void task_numa_work(struct callback_head *work)
 	if (cmpxchg(&mm->numa_next_scan, migrate, next_scan) != migrate)
 		return;
 
-	ACCESS_ONCE(mm->numa_scan_seq)++;
-	lazy_migrate_process(mm);
+
+	offset = mm->numa_scan_offset;
+	length = sysctl_sched_numa_scan_size;
+	length <<= 20;
+
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, offset);
+again:
+	if (!vma) {
+		ACCESS_ONCE(mm->numa_scan_seq)++;
+		offset = 0;
+		vma = mm->mmap;
+	}
+	while (vma && !vma_migratable(vma)) {
+		vma = vma->vm_next;
+		if (!vma)
+			goto again;
+	}
+
+	offset = max(offset, vma->vm_start);
+	end = min(ALIGN(offset + length, HPAGE_SIZE), vma->vm_end);
+	length -= end - offset;
+
+	change_prot_none(vma, offset, end);
+
+	offset = end;
+
+	if (length > 0) {
+		vma = vma->vm_next;
+		goto again;
+	}
+	mm->numa_scan_offset = offset;
+	up_read(&mm->mmap_sem);
+
 }
 
 /*
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 14a1949..0f0cb60 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -365,6 +365,13 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "sched_numa_scan_size_mb",
+		.data		= &sysctl_sched_numa_scan_size,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
 		.procname	= "sched_numa_settle_count",
 		.data		= &sysctl_sched_numa_settle_count,
 		.maxlen		= sizeof(unsigned int),
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index f0e3b28..d998810 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -581,12 +581,6 @@ static inline int check_pgd_range(struct vm_area_struct *vma,
 	return 0;
 }
 
-static void
-change_prot_none(struct vm_area_struct *vma, unsigned long start, unsigned long end)
-{
-	change_protection(vma, start, end, vma_prot_none(vma), 0);
-}
-
 /*
  * Check if all pages in a range are on a set of nodes.
  * If pagelist != NULL then isolate pages from the LRU and
@@ -1259,24 +1253,6 @@ static long do_mbind(unsigned long start, unsigned long len,
 	return err;
 }
 
-static void lazy_migrate_vma(struct vm_area_struct *vma)
-{
-	if (!vma_migratable(vma))
-		return;
-
-	change_prot_none(vma, vma->vm_start, vma->vm_end);
-}
-
-void lazy_migrate_process(struct mm_struct *mm)
-{
-	struct vm_area_struct *vma;
-
-	down_read(&mm->mmap_sem);
-	for (vma = mm->mmap; vma; vma = vma->vm_next)
-		lazy_migrate_vma(vma);
-	up_read(&mm->mmap_sem);
-}
-
 /*
  * User space interface with variable sized bitmaps for nodelists.
  */
