Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab0FIKQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:16:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:36255 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757507Ab0FIKQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:16:01 -0400
Date: Wed, 9 Jun 2010 10:15:31 GMT
From: tip-bot for Eric B Munson <ebmunson@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       anton@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       rostedt@goodmis.org, ebmunson@us.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, acme@redhat.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       efault@gmx.de, fweisbec@gmail.com, ebmunson@us.ibm.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1274193049-25997-1-git-send-email-ebmunson@us.ibm.com>
References: <1274193049-25997-1-git-send-email-ebmunson@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Add non-exec mmap() tracking
Message-ID: <tip-3af9e859281bda7eb7c20b51879cf43aa788ac2e@git.kernel.org>
Git-Commit-ID: 3af9e859281bda7eb7c20b51879cf43aa788ac2e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:15:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3af9e859281bda7eb7c20b51879cf43aa788ac2e
Gitweb:     http://git.kernel.org/tip/3af9e859281bda7eb7c20b51879cf43aa788ac2e
Author:     Eric B Munson <ebmunson@us.ibm.com>
AuthorDate: Tue, 18 May 2010 15:30:49 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 11:12:34 +0200

perf: Add non-exec mmap() tracking

Add the capacility to track data mmap()s. This can be used together
with PERF_SAMPLE_ADDR for data profiling.

Signed-off-by: Anton Blanchard <anton@samba.org>
[Updated code for stable perf ABI]
Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1274193049-25997-1-git-send-email-ebmunson@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/exec.c                   |    1 +
 include/linux/perf_event.h  |   12 +++---------
 kernel/perf_event.c         |   34 +++++++++++++++++++++++-----------
 mm/mmap.c                   |    6 +++++-
 tools/perf/builtin-record.c |    4 +++-
 5 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index e19de6a..97d91a0 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -653,6 +653,7 @@ int setup_arg_pages(struct linux_binprm *bprm,
 	else
 		stack_base = vma->vm_start - stack_expand;
 #endif
+	current->mm->start_stack = bprm->p;
 	ret = expand_stack(vma, stack_base);
 	if (ret)
 		ret = -EFAULT;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c691a0b..36efad9 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -214,8 +214,9 @@ struct perf_event_attr {
 				 *  See also PERF_RECORD_MISC_EXACT_IP
 				 */
 				precise_ip     :  2, /* skid constraint       */
+				mmap_data      :  1, /* non-exec mmap data    */
 
-				__reserved_1   : 47;
+				__reserved_1   : 46;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -962,14 +963,7 @@ perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
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
 extern struct perf_guest_info_callbacks *perf_guest_cbs;
 extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b39bec3..227ed9c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1891,7 +1891,7 @@ static void free_event(struct perf_event *event)
 
 	if (!event->parent) {
 		atomic_dec(&nr_events);
-		if (event->attr.mmap)
+		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
 			atomic_dec(&nr_comm_events);
@@ -3491,7 +3491,7 @@ perf_event_read_event(struct perf_event *event,
 /*
  * task tracking -- fork/exit
  *
- * enabled by: attr.comm | attr.mmap | attr.task
+ * enabled by: attr.comm | attr.mmap | attr.mmap_data | attr.task
  */
 
 struct perf_task_event {
@@ -3541,7 +3541,8 @@ static int perf_event_task_match(struct perf_event *event)
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
 		return 0;
 
-	if (event->attr.comm || event->attr.mmap || event->attr.task)
+	if (event->attr.comm || event->attr.mmap ||
+	    event->attr.mmap_data || event->attr.task)
 		return 1;
 
 	return 0;
@@ -3766,7 +3767,8 @@ static void perf_event_mmap_output(struct perf_event *event,
 }
 
 static int perf_event_mmap_match(struct perf_event *event,
-				   struct perf_mmap_event *mmap_event)
+				   struct perf_mmap_event *mmap_event,
+				   int executable)
 {
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
@@ -3774,19 +3776,21 @@ static int perf_event_mmap_match(struct perf_event *event,
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
 		return 0;
 
-	if (event->attr.mmap)
+	if ((!executable && event->attr.mmap_data) ||
+	    (executable && event->attr.mmap))
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
@@ -3830,6 +3834,14 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
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
@@ -3846,17 +3858,17 @@ got_name:
 
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
 
@@ -4911,7 +4923,7 @@ done:
 
 	if (!event->parent) {
 		atomic_inc(&nr_events);
-		if (event->attr.mmap)
+		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_inc(&nr_mmap_events);
 		if (event->attr.comm)
 			atomic_inc(&nr_comm_events);
diff --git a/mm/mmap.c b/mm/mmap.c
index 456ec6f..e38e910 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1734,8 +1734,10 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 		grow = (address - vma->vm_end) >> PAGE_SHIFT;
 
 		error = acct_stack_growth(vma, size, grow);
-		if (!error)
+		if (!error) {
 			vma->vm_end = address;
+			perf_event_mmap(vma);
+		}
 	}
 	anon_vma_unlock(vma);
 	return error;
@@ -1781,6 +1783,7 @@ static int expand_downwards(struct vm_area_struct *vma,
 		if (!error) {
 			vma->vm_start = address;
 			vma->vm_pgoff -= grow;
+			perf_event_mmap(vma);
 		}
 	}
 	anon_vma_unlock(vma);
@@ -2208,6 +2211,7 @@ unsigned long do_brk(unsigned long addr, unsigned long len)
 	vma->vm_page_prot = vm_get_page_prot(flags);
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 out:
+	perf_event_mmap(vma);
 	mm->total_vm += len >> PAGE_SHIFT;
 	if (flags & VM_LOCKED) {
 		if (!mlock_vma_pages_range(vma, addr, addr + len))
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5e5c640..39c7247 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -268,8 +268,10 @@ static void create_counter(int counter, int cpu)
 	if (inherit_stat)
 		attr->inherit_stat = 1;
 
-	if (sample_address)
+	if (sample_address) {
 		attr->sample_type	|= PERF_SAMPLE_ADDR;
+		attr->mmap_data = track;
+	}
 
 	if (call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
