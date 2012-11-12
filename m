Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab2KLLvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:51:17 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:51544 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab2KLLvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:51:12 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 42/55] ARC: stacktracing APIs based on dw2 unwinder
Date: Mon, 12 Nov 2012 17:19:00 +0530
Message-ID: <1352720953-24321-12-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/kernel/stacktrace.c |  215 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 213 insertions(+), 2 deletions(-)

diff --git a/arch/arc/kernel/stacktrace.c b/arch/arc/kernel/stacktrace.c
index b9d1646..a63ff84 100644
--- a/arch/arc/kernel/stacktrace.c
+++ b/arch/arc/kernel/stacktrace.c
@@ -1,13 +1,206 @@
 /*
+ *	stacktrace.c : stacktracing APIs needed by rest of kernel
+ *			(wrappers over ARC dwarf based unwinder)
+ *
  * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
+ *
+ *  vineetg: aug 2009
+ *  -Implemented CONFIG_STACKTRACE APIs, primarily save_stack_trace_tsk( )
+ *   for displaying task's kernel mode call stack in /proc/<pid>/stack
+ *  -Iterator based approach to have single copy of unwinding core and APIs
+ *   needing unwinding, implement the logic in iterator regarding:
+ *      = which frame onwards to start capture
+ *      = which frame to stop capturing (wchan)
+ *      = specifics of data structs where trace is saved(CONFIG_STACKTRACE etc)
+ *
+ *  vineetg: March 2009
+ *  -Implemented correct versions of thread_saved_pc() and get_wchan()
+ *
+ *  rajeshwarr: 2008
+ *  -Initial implementation
  */
 
 #include <linux/ptrace.h>
 #include <linux/export.h>
+#include <linux/stacktrace.h>
+#include <linux/kallsyms.h>
+#include <asm/arcregs.h>
+#include <asm/unwind.h>
+#include <asm/switch_to.h>
+
+/*-------------------------------------------------------------------------
+ *              Unwinder Iterator
+ *-------------------------------------------------------------------------
+ */
+
+#ifdef CONFIG_ARC_DW2_UNWIND
+
+static void seed_unwind_frame_info(struct task_struct *tsk,
+				   struct pt_regs *regs,
+				   struct unwind_frame_info *frame_info)
+{
+	if (tsk == NULL && regs == NULL) {
+		unsigned long fp, sp, blink, ret;
+		frame_info->task = current;
+
+		__asm__ __volatile__(
+			"mov %0,r27\n\t"
+			"mov %1,r28\n\t"
+			"mov %2,r31\n\t"
+			"mov %3,r63\n\t"
+			: "=r"(fp), "=r"(sp), "=r"(blink), "=r"(ret)
+		);
+
+		frame_info->regs.r27 = fp;
+		frame_info->regs.r28 = sp;
+		frame_info->regs.r31 = blink;
+		frame_info->regs.r63 = ret;
+		frame_info->call_frame = 0;
+	} else if (regs == NULL) {
+
+		frame_info->task = tsk;
+
+		frame_info->regs.r27 = KSTK_FP(tsk);
+		frame_info->regs.r28 = KSTK_ESP(tsk);
+		frame_info->regs.r31 = KSTK_BLINK(tsk);
+		frame_info->regs.r63 = (unsigned int)__switch_to;
+
+		/* In the prologue of __switch_to, first FP is saved on stack
+		 * and then SP is copied to FP. Dwarf assumes cfa as FP based
+		 * but we didn't save FP. The value retrieved above is FP's
+		 * state in previous frame.
+		 * As a work around for this, we unwind from __switch_to start
+		 * and adjust SP accordingly. The other limitation is that
+		 * __switch_to macro is dwarf rules are not generated for inline
+		 * assembly code
+		 */
+		frame_info->regs.r27 = 0;
+		frame_info->regs.r28 += 64;
+		frame_info->call_frame = 0;
+
+	} else {
+		frame_info->task = tsk;
+
+		frame_info->regs.r27 = regs->fp;
+		frame_info->regs.r28 = regs->sp;
+		frame_info->regs.r31 = regs->blink;
+		frame_info->regs.r63 = regs->ret;
+		frame_info->call_frame = 0;
+	}
+}
+
+#endif
+
+static noinline unsigned int
+arc_unwind_core(struct task_struct *tsk, struct pt_regs *regs,
+		int (*consumer_fn) (unsigned int, void *), void *arg)
+{
+#ifdef CONFIG_ARC_DW2_UNWIND
+	int ret = 0;
+	unsigned int address;
+	struct unwind_frame_info frame_info;
+
+	seed_unwind_frame_info(tsk, regs, &frame_info);
+
+	while (1) {
+		address = UNW_PC(&frame_info);
+
+		if (address && __kernel_text_address(address)) {
+			if (consumer_fn(address, arg) == -1)
+				break;
+		}
+
+		ret = arc_unwind(&frame_info);
+
+		if (ret == 0) {
+			frame_info.regs.r63 = frame_info.regs.r31;
+			continue;
+		} else {
+			break;
+		}
+	}
+
+	return address;		/* return the last address it saw */
+#else
+	/* On ARC, only Dward based unwinder works. fp based backtracing is
+	 * not possible (-fno-omit-frame-pointer) because of the way function
+	 * prelogue is setup (callee regs saved and then fp set and not other
+	 * way around
+	 */
+	pr_warn("CONFIG_ARC_DW2_UNWIND needs to be enabled\n");
+	return 0;
+
+#endif
+}
+
+/*-------------------------------------------------------------------------
+ * callbacks called by unwinder iterator to implement kernel APIs
+ *
+ * The callback can return -1 to force the iterator to stop, which by default
+ * keeps going till the bottom-most frame.
+ *-------------------------------------------------------------------------
+ */
+
+/* Call-back which plugs into unwinding core to dump the stack in
+ * case of panic/OOPs/BUG etc
+ */
+static int __print_sym(unsigned int address, void *unused)
+{
+	__print_symbol("  %s\n", address);
+	return 0;
+}
+
+#ifdef CONFIG_STACKTRACE
+
+/* Call-back which plugs into unwinding core to capture the
+ * traces needed by kernel on /proc/<pid>/stack
+ */
+static int __collect_all(unsigned int address, void *arg)
+{
+	struct stack_trace *trace = arg;
+
+	if (trace->skip > 0)
+		trace->skip--;
+	else
+		trace->entries[trace->nr_entries++] = address;
+
+	if (trace->nr_entries >= trace->max_entries)
+		return -1;
+
+	return 0;
+}
+
+static int __collect_all_but_sched(unsigned int address, void *arg)
+{
+	struct stack_trace *trace = arg;
+
+	if (in_sched_functions(address))
+		return 0;
+
+	if (trace->skip > 0)
+		trace->skip--;
+	else
+		trace->entries[trace->nr_entries++] = address;
+
+	if (trace->nr_entries >= trace->max_entries)
+		return -1;
+
+	return 0;
+}
+
+#endif
+
+static int __get_first_nonsched(unsigned int address, void *unused)
+{
+	if (in_sched_functions(address))
+		return 0;
+
+	return -1;
+}
 
 /*-------------------------------------------------------------------------
  *              APIs expected by various kernel sub-systems
@@ -16,7 +209,8 @@
 
 noinline void show_stacktrace(struct task_struct *tsk, struct pt_regs *regs)
 {
-	pr_info("\nStack Trace: NOT Available\n");
+	pr_info("\nStack Trace:\n");
+	arc_unwind_core(tsk, regs, __print_sym, NULL);
 }
 EXPORT_SYMBOL(show_stacktrace);
 
@@ -39,5 +233,22 @@ EXPORT_SYMBOL(dump_stack);
  */
 unsigned int get_wchan(struct task_struct *tsk)
 {
-	return 0;
+	return arc_unwind_core(tsk, NULL, __get_first_nonsched, NULL);
+}
+
+#ifdef CONFIG_STACKTRACE
+
+/*
+ * API required by CONFIG_STACKTRACE, CONFIG_LATENCYTOP.
+ * A typical use is when /proc/<pid>/stack is queried by userland
+ */
+void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
+{
+	arc_unwind_core(tsk, NULL, __collect_all_but_sched, trace);
+}
+
+void save_stack_trace(struct stack_trace *trace)
+{
+	arc_unwind_core(current, NULL, __collect_all, trace);
 }
+#endif
-- 
1.7.4.1

