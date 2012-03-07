Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab2CGDVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 22:21:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65400 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab2CGDVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 22:21:41 -0500
Date: Tue, 6 Mar 2012 19:21:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 1/2] mm, counters: remove task argument to sync_mm_rss and
 __sync_task_rss_stat
Message-ID: <alpine.DEB.2.00.1203061919260.21806@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sync_mm_rss() can only be used for current to avoid race conditions in
iterating and clearing its per-task counters.  Remove the task argument
for it and its helper function, __sync_task_rss_stat(), to avoid thinking
it can be used safely for anything other than current.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/exec.c          |    2 +-
 include/linux/mm.h |    4 ++--
 kernel/exit.c      |    2 +-
 mm/memory.c        |   18 +++++++++---------
 mm/mmu_context.c   |    2 +-
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -822,7 +822,7 @@ static int exec_mmap(struct mm_struct *mm)
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
 	old_mm = current->mm;
-	sync_mm_rss(tsk, old_mm);
+	sync_mm_rss(old_mm);
 	mm_release(tsk, old_mm);
 
 	if (old_mm) {
diff --git a/include/linux/mm.h b/include/linux/mm.h
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1127,9 +1127,9 @@ static inline void setmax_mm_hiwater_rss(unsigned long *maxrss,
 }
 
 #if defined(SPLIT_RSS_COUNTING)
-void sync_mm_rss(struct task_struct *task, struct mm_struct *mm);
+void sync_mm_rss(struct mm_struct *mm);
 #else
-static inline void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
+static inline void sync_mm_rss(struct mm_struct *mm)
 {
 }
 #endif
diff --git a/kernel/exit.c b/kernel/exit.c
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -953,7 +953,7 @@ void do_exit(long code)
 	acct_update_integrals(tsk);
 	/* sync mm's RSS info before statistics gathering */
 	if (tsk->mm)
-		sync_mm_rss(tsk, tsk->mm);
+		sync_mm_rss(tsk->mm);
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
 		hrtimer_cancel(&tsk->signal->real_timer);
diff --git a/mm/memory.c b/mm/memory.c
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -125,17 +125,17 @@ core_initcall(init_zero_pfn);
 
 #if defined(SPLIT_RSS_COUNTING)
 
-static void __sync_task_rss_stat(struct task_struct *task, struct mm_struct *mm)
+static void __sync_task_rss_stat(struct mm_struct *mm)
 {
 	int i;
 
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
-		if (task->rss_stat.count[i]) {
-			add_mm_counter(mm, i, task->rss_stat.count[i]);
-			task->rss_stat.count[i] = 0;
+		if (current->rss_stat.count[i]) {
+			add_mm_counter(mm, i, current->rss_stat.count[i]);
+			current->rss_stat.count[i] = 0;
 		}
 	}
-	task->rss_stat.events = 0;
+	current->rss_stat.events = 0;
 }
 
 static void add_mm_counter_fast(struct mm_struct *mm, int member, int val)
@@ -157,7 +157,7 @@ static void check_sync_rss_stat(struct task_struct *task)
 	if (unlikely(task != current))
 		return;
 	if (unlikely(task->rss_stat.events++ > TASK_RSS_EVENTS_THRESH))
-		__sync_task_rss_stat(task, task->mm);
+		__sync_task_rss_stat(task->mm);
 }
 
 unsigned long get_mm_counter(struct mm_struct *mm, int member)
@@ -178,9 +178,9 @@ unsigned long get_mm_counter(struct mm_struct *mm, int member)
 	return (unsigned long)val;
 }
 
-void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
+void sync_mm_rss(struct mm_struct *mm)
 {
-	__sync_task_rss_stat(task, mm);
+	__sync_task_rss_stat(mm);
 }
 #else /* SPLIT_RSS_COUNTING */
 
@@ -661,7 +661,7 @@ static inline void add_mm_rss_vec(struct mm_struct *mm, int *rss)
 	int i;
 
 	if (current->mm == mm)
-		sync_mm_rss(current, mm);
+		sync_mm_rss(mm);
 	for (i = 0; i < NR_MM_COUNTERS; i++)
 		if (rss[i])
 			add_mm_counter(mm, i, rss[i]);
diff --git a/mm/mmu_context.c b/mm/mmu_context.c
--- a/mm/mmu_context.c
+++ b/mm/mmu_context.c
@@ -53,7 +53,7 @@ void unuse_mm(struct mm_struct *mm)
 	struct task_struct *tsk = current;
 
 	task_lock(tsk);
-	sync_mm_rss(tsk, mm);
+	sync_mm_rss(mm);
 	tsk->mm = NULL;
 	/* active_mm is still 'mm' */
 	enter_lazy_tlb(mm, tsk);
