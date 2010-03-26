Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab0CZBxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:53:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44324 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab0CZBxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:53:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Sv16zTY5cFfouOORUhaXIumn3V5lhpQhcLoV/TWVKPtMgNzUVmDTStdyQ+EjpIYLfL
         qXdReqE+ZJkP3AFDjMQMta0fodIuaPPepyRxgIBH+7eWq8V9XPfs+48vhXRMhmqPA7AZ
         4MXU/gc2Ibn+seNDIWETUqjqWc5QiTrTVm2cQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/7] x86: Unify dumpstack.h and stacktrace.h
Date: Fri, 26 Mar 2010 02:52:38 +0100
Message-Id: <1269568362-13690-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1269568362-13690-1-git-send-regression-fweisbec@gmail.com>
References: <1269568362-13690-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/include/asm/stacktrace.h and arch/x86/kernel/dumpstack.h
declare headers of objects about the same topic.
Actually most of the files that include stacktrace.h also include
dumpstack.h

Although dumpstack.h seems more reserved for internals of stack
traces, those are quite often needed to define specialized stack
trace operations. And perf event arch headers are going to need
access to such low level operations anyway. So don't continue to
bother with dumpstack.h as it's not anymore about isolated deep
internals.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/stacktrace.h |   46 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event.c  |    2 -
 arch/x86/kernel/dumpstack.c       |    1 -
 arch/x86/kernel/dumpstack.h       |   47 -------------------------------------
 arch/x86/kernel/dumpstack_32.c    |    2 -
 arch/x86/kernel/dumpstack_64.c    |    2 -
 arch/x86/kernel/stacktrace.c      |    7 +++--
 7 files changed, 50 insertions(+), 57 deletions(-)
 delete mode 100644 arch/x86/kernel/dumpstack.h

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index 4dab78e..8fb70b7 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -1,3 +1,8 @@
+/*
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
+ */
+
 #ifndef _ASM_X86_STACKTRACE_H
 #define _ASM_X86_STACKTRACE_H
 
@@ -38,8 +43,49 @@ struct stacktrace_ops {
 	walk_stack_t	walk_stack;
 };
 
+struct pt_regs;
+struct task_struct;
+
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
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
+static inline unsigned long rewind_frame_pointer(int n)
+{
+	struct stack_frame *frame;
+
+	get_bp(frame);
+
+#ifdef CONFIG_FRAME_POINTER
+	while (n--)
+		frame = frame->next_frame;
+#endif
+
+	return (unsigned long)frame;
+}
+
 #endif /* _ASM_X86_STACKTRACE_H */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9bc6550..c3f203e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1608,8 +1608,6 @@ static const struct stacktrace_ops backtrace_ops = {
 	.walk_stack		= print_context_stack_bp,
 };
 
-#include "../dumpstack.h"
-
 static void
 perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 6d81755..b5329df 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -18,7 +18,6 @@
 
 #include <asm/stacktrace.h>
 
-#include "dumpstack.h"
 
 int panic_on_unrecovered_nmi;
 int panic_on_io_nmi;
diff --git a/arch/x86/kernel/dumpstack.h b/arch/x86/kernel/dumpstack.h
deleted file mode 100644
index 29e5f7c..0000000
--- a/arch/x86/kernel/dumpstack.h
+++ /dev/null
@@ -1,47 +0,0 @@
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
-static inline unsigned long rewind_frame_pointer(int n)
-{
-	struct stack_frame *frame;
-
-	get_bp(frame);
-
-#ifdef CONFIG_FRAME_POINTER
-	while (n--)
-		frame = frame->next_frame;
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
index 272c9f1..77fc784 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -16,8 +16,6 @@
 
 #include <asm/stacktrace.h>
 
-#include "dumpstack.h"
-
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
-- 
1.6.2.3

