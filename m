Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab0KJL4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 06:56:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab0KJL4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 06:56:30 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, andi@firstfloor.org,
        lwoodman@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/2] tracing,mm - add kernel pagefault tracepoint for x86 & x86_64
Date: Wed, 10 Nov 2010 12:56:11 +0100
Message-Id: <1289390172-9730-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1289390172-9730-1-git-send-email-jolsa@redhat.com>
References: <1289390172-9730-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a tracepoint to trace kernel pagefault event.

When analyzing a vmcore resulting from a kernel failure, we
_often_ hypothesize that "there should have a pagefault event
just before this instruction" or similar.  Sometimes it means
that there should have a small delay between instructions that
extends a critical session and exposed a missing lock.  Since
there have been no evidence of kernel pagefault, it is quite
difficult to adopt the hypothesis.

If we can trace the kernel pagefault event, it will help narrow
the possible cause of failure and will accelerate the
investigation a lot.


Signed-off-by: Larry Woodman <lwoodman@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/mm/fault.c         |   32 +++++++++++++++++++++-----------
 include/trace/events/kmem.h |   22 ++++++++++++++++++++++
 2 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 7d90ceb..f776c45 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -12,6 +12,7 @@
 #include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
 #include <linux/perf_event.h>		/* perf_sw_event		*/
 #include <linux/hugetlb.h>		/* hstate_index_to_shift	*/
+#include <trace/events/kmem.h>
 
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
@@ -944,17 +945,10 @@ static int fault_in_kernel_space(unsigned long address)
 	return address >= TASK_SIZE_MAX;
 }
 
-/*
- * This routine handles page faults.  It determines the address,
- * and the problem, and then passes it off to one of the appropriate
- * routines.
- */
-dotraplinkage void __kprobes
-do_page_fault(struct pt_regs *regs, unsigned long error_code)
+static inline void __do_page_fault(struct pt_regs *regs, unsigned long address, unsigned long error_code)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
-	unsigned long address;
 	struct mm_struct *mm;
 	int fault;
 	int write = error_code & PF_WRITE;
@@ -964,9 +958,6 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	tsk = current;
 	mm = tsk->mm;
 
-	/* Get the faulting address: */
-	address = read_cr2();
-
 	/*
 	 * Detect and handle instructions that would cause a page fault for
 	 * both a tracked kernel page and a userspace page.
@@ -1158,3 +1149,22 @@ good_area:
 
 	up_read(&mm->mmap_sem);
 }
+
+/*
+ * This routine handles page faults.  It determines the address,
+ * and the problem, and then passes it off to one of the appropriate
+ * routines.
+ */
+dotraplinkage void __kprobes
+do_page_fault(struct pt_regs *regs, unsigned long error_code)
+{
+	unsigned long address;
+
+	/* Get the faulting address: */
+	address = read_cr2();
+
+	__do_page_fault(regs, address, error_code);
+
+	if (!user_mode(regs))
+		trace_mm_kernel_pagefault(current, address, regs);
+}
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index a9c87ad..f14535b 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -302,6 +302,28 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 		__entry->alloc_migratetype == __entry->fallback_migratetype)
 );
 
+TRACE_EVENT(mm_kernel_pagefault,
+
+	TP_PROTO(struct task_struct *task, unsigned long address, struct pt_regs *regs),
+
+	TP_ARGS(task, address, regs),
+
+	TP_STRUCT__entry(
+		__field(struct task_struct *, task)
+		__field(unsigned long, address)
+		__field(struct pt_regs *, regs)
+	),
+
+	TP_fast_assign(
+		__entry->task = task;
+		__entry->address = address;
+		__entry->regs = regs;
+	),
+
+	TP_printk("task=%lx, address=%lx, regs=%lx",
+		(unsigned long)__entry->task, (unsigned long)__entry->address,
+			__entry->regs)
+	);
 #endif /* _TRACE_KMEM_H */
 
 /* This part must be outside protection */
-- 
1.7.1

