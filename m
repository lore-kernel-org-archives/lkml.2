Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab0FHVff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 17:35:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58392 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab0FHVfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 17:35:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=M2vo+Lsbf08DBRJ9G7U2mW0+OH7vEUo2j37dnrw7GKBV38mNK7HHDauPgEp8IwbVV7
         RRDQsXluC+eMAp0tAt4jc19bxzUVOkRRHG/ZXdesvGawfaddLBUmRdhqgs5Z15B1Tia1
         hCRR7hXSFQeQFPwrPk2sJW1levD5tBQrWua1U=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Soeren Sandmann <sandmann@daimi.au.dk>
Subject: [PATCH v2] x86: Unify dumpstack.h and stacktrace.h
Date: Tue,  8 Jun 2010 23:35:29 +0200
Message-Id: <1276032929-27530-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/include/asm/stacktrace.h and arch/x86/kernel/dumpstack.h
declare headers of objects that deal with the same topic.
Actually most of the files that include stacktrace.h also include
dumpstack.h

Although dumpstack.h seems more reserved for internals of stack
traces, those are quite often needed to define specialized stack
trace operations. And perf event arch headers are going to need
access to such low level operations anyway. So don't continue to
bother with dumpstack.h as it's not anymore about isolated deep
internals.

v2: fix struct stack_frame definition conflict in sysprof

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Soeren Sandmann <sandmann@daimi.au.dk>
---
 arch/x86/include/asm/stacktrace.h |   52 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event.c  |    2 -
 arch/x86/kernel/dumpstack.c       |    1 -
 arch/x86/kernel/dumpstack.h       |   56 -------------------------------------
 arch/x86/kernel/dumpstack_32.c    |    2 -
 arch/x86/kernel/dumpstack_64.c    |    1 -
 arch/x86/kernel/stacktrace.c      |    7 ++--
 kernel/trace/trace_sysprof.c      |    7 ++--
 8 files changed, 60 insertions(+), 68 deletions(-)
 delete mode 100644 arch/x86/kernel/dumpstack.h

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index 4dab78e..a957463 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -1,6 +1,13 @@
+/*
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
+ */
+
 #ifndef _ASM_X86_STACKTRACE_H
 #define _ASM_X86_STACKTRACE_H
 
+#include <linux/uaccess.h>
+
 extern int kstack_depth_to_print;
 
 struct thread_info;
@@ -42,4 +49,49 @@ void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data);
 
+#ifdef CONFIG_X86_32
+#define STACKSLOTS_PER_LINE 8
+#define get_bp(bp) asm("movl %%ebp, %0" : "=r" (bp) :)
+#else
+#define STACKSLOTS_PER_LINE 4
+#define get_bp(bp) asm("movq %%rbp, %0" : "=r" (bp) :)
+#endif
+
+extern void
+show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp, char *log_lvl);
+
+extern void
+show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *sp, unsigned long bp, char *log_lvl);
+
+extern unsigned int code_bytes;
+
+/* The form of the top of the frame on the stack */
+struct stack_frame {
+	struct stack_frame *next_frame;
+	unsigned long return_address;
+};
+
+struct stack_frame_ia32 {
+    u32 next_frame;
+    u32 return_address;
+};
+
+static inline unsigned long rewind_frame_pointer(int n)
+{
+	struct stack_frame *frame;
+
+	get_bp(frame);
+
+#ifdef CONFIG_FRAME_POINTER
+	while (n--) {
+		if (probe_kernel_address(&frame->next_frame, frame))
+			break;
+	}
+#endif
+
+	return (unsigned long)frame;
+}
+
 #endif /* _ASM_X86_STACKTRACE_H */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c775860..9632fb6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1585,8 +1585,6 @@ static const struct stacktrace_ops backtrace_ops = {
 	.walk_stack		= print_context_stack_bp,
 };
 
-#include "../dumpstack.h"
-
 static void
 perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index c89a386..6e8752c 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -18,7 +18,6 @@
 
 #include <asm/stacktrace.h>
 
-#include "dumpstack.h"
 
 int panic_on_unrecovered_nmi;
 int panic_on_io_nmi;
diff --git a/arch/x86/kernel/dumpstack.h b/arch/x86/kernel/dumpstack.h
deleted file mode 100644
index e1a93be..0000000
--- a/arch/x86/kernel/dumpstack.h
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- *  Copyright (C) 1991, 1992  Linus Torvalds
- *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
- */
-
-#ifndef DUMPSTACK_H
-#define DUMPSTACK_H
-
-#ifdef CONFIG_X86_32
-#define STACKSLOTS_PER_LINE 8
-#define get_bp(bp) asm("movl %%ebp, %0" : "=r" (bp) :)
-#else
-#define STACKSLOTS_PER_LINE 4
-#define get_bp(bp) asm("movq %%rbp, %0" : "=r" (bp) :)
-#endif
-
-#include <linux/uaccess.h>
-
-extern void
-show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp, char *log_lvl);
-
-extern void
-show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *sp, unsigned long bp, char *log_lvl);
-
-extern unsigned int code_bytes;
-
-/* The form of the top of the frame on the stack */
-struct stack_frame {
-	struct stack_frame *next_frame;
-	unsigned long return_address;
-};
-
-struct stack_frame_ia32 {
-    u32 next_frame;
-    u32 return_address;
-};
-
-static inline unsigned long rewind_frame_pointer(int n)
-{
-	struct stack_frame *frame;
-
-	get_bp(frame);
-
-#ifdef CONFIG_FRAME_POINTER
-	while (n--) {
-		if (probe_kernel_address(&frame->next_frame, frame))
-			break;
-	}
-#endif
-
-	return (unsigned long)frame;
-}
-
-#endif /* DUMPSTACK_H */
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 11540a1..0f6376f 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -16,8 +16,6 @@
 
 #include <asm/stacktrace.h>
 
-#include "dumpstack.h"
-
 
 void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp,
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 272c9f1..57a21f1 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -16,7 +16,6 @@
 
 #include <asm/stacktrace.h>
 
-#include "dumpstack.h"
 
 #define N_EXCEPTION_STACKS_END \
 		(N_EXCEPTION_STACKS + DEBUG_STKSZ/EXCEPTION_STKSZ - 2)
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 922eefb..ea54d02 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -96,12 +96,13 @@ EXPORT_SYMBOL_GPL(save_stack_trace_tsk);
 
 /* Userspace stacktrace - based on kernel/trace/trace_sysprof.c */
 
-struct stack_frame {
+struct stack_frame_user {
 	const void __user	*next_fp;
 	unsigned long		ret_addr;
 };
 
-static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
+static int
+copy_stack_frame(const void __user *fp, struct stack_frame_user *frame)
 {
 	int ret;
 
@@ -126,7 +127,7 @@ static inline void __save_stack_trace_user(struct stack_trace *trace)
 		trace->entries[trace->nr_entries++] = regs->ip;
 
 	while (trace->nr_entries < trace->max_entries) {
-		struct stack_frame frame;
+		struct stack_frame_user frame;
 
 		frame.next_fp = NULL;
 		frame.ret_addr = 0;
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index a7974a5..c080956 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -33,12 +33,13 @@ static DEFINE_MUTEX(sample_timer_lock);
  */
 static DEFINE_PER_CPU(struct hrtimer, stack_trace_hrtimer);
 
-struct stack_frame {
+struct stack_frame_user {
 	const void __user	*next_fp;
 	unsigned long		return_address;
 };
 
-static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
+static int
+copy_stack_frame(const void __user *fp, struct stack_frame_user *frame)
 {
 	int ret;
 
@@ -125,7 +126,7 @@ trace_kernel(struct pt_regs *regs, struct trace_array *tr,
 static void timer_notify(struct pt_regs *regs, int cpu)
 {
 	struct trace_array_cpu *data;
-	struct stack_frame frame;
+	struct stack_frame_user frame;
 	struct trace_array *tr;
 	const void __user *fp;
 	int is_user;
-- 
1.6.2.3

