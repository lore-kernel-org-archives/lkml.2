Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab0EGKqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 06:46:36 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44600 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab0EGKqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 06:46:34 -0400
From: Eric B Munson <ebmunson@us.ibm.com>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, acme@redhat.com, arjan@linux.intel.com,
       anton@samba.org, riel@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Eric B Munson <ebmunson@us.ibm.com>
Subject: [PATCH] Split executable and non-executable mmap tracking
Date: Fri,  7 May 2010 10:05:35 +0100
Message-Id: <1273223135-22695-1-git-send-email-ebmunson@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits tracking of executable and non-executable mmaps.
Executable mmaps are tracked normally and non-executable are
tracked when --data is used.

Signed-off-by: Anton Blanchard <anton@samba.org>

Updated code for stable perf ABI
Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
---
 fs/exec.c                   |    1 +
 include/linux/perf_event.h  |   12 +++---------
 kernel/perf_event.c         |   34 +++++++++++++++++++++++++---------
 mm/mmap.c                   |    2 ++
 tools/perf/builtin-record.c |    6 ++++--
 tools/perf/builtin-top.c    |    2 +-
 6 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 49cdaa1..5ad4f69 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -648,6 +648,7 @@ int setup_arg_pages(struct linux_binprm *bprm,
 	else
 		stack_base = vma->vm_start - stack_expand;
 #endif
+	current->mm->start_stack = bprm->p;
 	ret = expand_stack(vma, stack_base);
 	if (ret)
 		ret = -EFAULT;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c8e3754..b8f59cc 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -197,6 +197,7 @@ struct perf_event_attr {
 				exclude_hv     :  1, /* ditto hypervisor      */
 				exclude_idle   :  1, /* don't count when idle */
 				mmap           :  1, /* include mmap data     */
+				mmap_exec      :  1, /* include exec mmap data*/
 				comm	       :  1, /* include comm data     */
 				freq           :  1, /* use freq, not period  */
 				inherit_stat   :  1, /* per task counts       */
@@ -204,7 +205,7 @@ struct perf_event_attr {
 				task           :  1, /* trace fork/exit       */
 				watermark      :  1, /* wakeup_watermark      */
 
-				__reserved_1   : 49;
+				__reserved_1   : 48;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -894,14 +895,7 @@ perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 	}
 }
 
-extern void __perf_event_mmap(struct vm_area_struct *vma);
-
-static inline void perf_event_mmap(struct vm_area_struct *vma)
-{
-	if (vma->vm_flags & VM_EXEC)
-		__perf_event_mmap(vma);
-}
-
+extern void perf_event_mmap(struct vm_area_struct *vma);
 extern void perf_event_comm(struct task_struct *tsk);
 extern void perf_event_fork(struct task_struct *tsk);
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 3d1552d..b3f49e6 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1832,6 +1832,8 @@ static void free_event(struct perf_event *event)
 
 	if (!event->parent) {
 		atomic_dec(&nr_events);
+		if (event->attr.mmap_exec)
+			atomic_dec(&nr_mmap_events);
 		if (event->attr.mmap)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
@@ -3354,7 +3356,7 @@ perf_event_read_event(struct perf_event *event,
 /*
  * task tracking -- fork/exit
  *
- * enabled by: attr.comm | attr.mmap | attr.task
+ * enabled by: attr.comm | attr.mmap | attr.mmap_exec | attr.task
  */
 
 struct perf_task_event {
@@ -3414,7 +3416,8 @@ static int perf_event_task_match(struct perf_event *event)
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
 		return 0;
 
-	if (event->attr.comm || event->attr.mmap || event->attr.task)
+	if (event->attr.comm || event->attr.mmap ||
+	    event->attr.mmap_exec || event->attr.task)
 		return 1;
 
 	return 0;
@@ -3639,7 +3642,8 @@ static void perf_event_mmap_output(struct perf_event *event,
 }
 
 static int perf_event_mmap_match(struct perf_event *event,
-				   struct perf_mmap_event *mmap_event)
+				   struct perf_mmap_event *mmap_event,
+				   int executable)
 {
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
@@ -3647,19 +3651,21 @@ static int perf_event_mmap_match(struct perf_event *event,
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
 		return 0;
 
-	if (event->attr.mmap)
+	if ((executable && event->attr.mmap_exec) ||
+	    (!executable && event->attr.mmap))
 		return 1;
 
 	return 0;
 }
 
 static void perf_event_mmap_ctx(struct perf_event_context *ctx,
-				  struct perf_mmap_event *mmap_event)
+				  struct perf_mmap_event *mmap_event,
+				  int executable)
 {
 	struct perf_event *event;
 
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
-		if (perf_event_mmap_match(event, mmap_event))
+		if (perf_event_mmap_match(event, mmap_event, executable))
 			perf_event_mmap_output(event, mmap_event);
 	}
 }
@@ -3703,6 +3709,14 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 		if (!vma->vm_mm) {
 			name = strncpy(tmp, "[vdso]", sizeof(tmp));
 			goto got_name;
+		} else if (vma->vm_start <= vma->vm_mm->start_brk &&
+				vma->vm_end >= vma->vm_mm->brk) {
+			name = strncpy(tmp, "[heap]", sizeof(tmp));
+			goto got_name;
+		} else if (vma->vm_start <= vma->vm_mm->start_stack &&
+				vma->vm_end >= vma->vm_mm->start_stack) {
+			name = strncpy(tmp, "[stack]", sizeof(tmp));
+			goto got_name;
 		}
 
 		name = strncpy(tmp, "//anon", sizeof(tmp));
@@ -3719,17 +3733,17 @@ got_name:
 
 	rcu_read_lock();
 	cpuctx = &get_cpu_var(perf_cpu_context);
-	perf_event_mmap_ctx(&cpuctx->ctx, mmap_event);
+	perf_event_mmap_ctx(&cpuctx->ctx, mmap_event, vma->vm_flags & VM_EXEC);
 	ctx = rcu_dereference(current->perf_event_ctxp);
 	if (ctx)
-		perf_event_mmap_ctx(ctx, mmap_event);
+		perf_event_mmap_ctx(ctx, mmap_event, vma->vm_flags & VM_EXEC);
 	put_cpu_var(perf_cpu_context);
 	rcu_read_unlock();
 
 	kfree(buf);
 }
 
-void __perf_event_mmap(struct vm_area_struct *vma)
+void perf_event_mmap(struct vm_area_struct *vma)
 {
 	struct perf_mmap_event mmap_event;
 
@@ -4641,6 +4655,8 @@ done:
 		atomic_inc(&nr_events);
 		if (event->attr.mmap)
 			atomic_inc(&nr_mmap_events);
+		if (event->attr.mmap_exec)
+			atomic_inc(&nr_mmap_events);
 		if (event->attr.comm)
 			atomic_inc(&nr_comm_events);
 		if (event->attr.task)
diff --git a/mm/mmap.c b/mm/mmap.c
index 456ec6f..6ceee1d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1781,6 +1781,7 @@ static int expand_downwards(struct vm_area_struct *vma,
 		if (!error) {
 			vma->vm_start = address;
 			vma->vm_pgoff -= grow;
+			perf_event_mmap(vma);
 		}
 	}
 	anon_vma_unlock(vma);
@@ -2208,6 +2209,7 @@ unsigned long do_brk(unsigned long addr, unsigned long len)
 	vma->vm_page_prot = vm_get_page_prot(flags);
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 out:
+	perf_event_mmap(vma);
 	mm->total_vm += len >> PAGE_SHIFT;
 	if (flags & VM_LOCKED) {
 		if (!mlock_vma_pages_range(vma, addr, addr + len))
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3b8b638..ff0b351 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -260,8 +260,10 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	if (inherit_stat)
 		attr->inherit_stat = 1;
 
-	if (sample_address)
+	if (sample_address) {
 		attr->sample_type	|= PERF_SAMPLE_ADDR;
+		attr->mmap = track;
+	}
 
 	if (call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
@@ -272,7 +274,7 @@ static void create_counter(int counter, int cpu, pid_t pid)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
-	attr->mmap		= track;
+	attr->mmap_exec		= track;
 	attr->comm		= track;
 	attr->inherit		= inherit;
 	attr->disabled		= 1;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 1f52932..2cddcb5 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1142,7 +1142,7 @@ static void start_counter(int i, int counter)
 	}
 
 	attr->inherit		= (cpu < 0) && inherit;
-	attr->mmap		= 1;
+	attr->mmap_exec		= 1;
 
 try_again:
 	fd[i][counter] = sys_perf_event_open(attr, target_pid, cpu, group_fd, 0);
-- 
1.7.0.4

