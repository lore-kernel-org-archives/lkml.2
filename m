Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab2AJS3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:29:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab2AJS26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:28:58 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com
Cc: linux-kernel@vger.kernel.org, winget@google.com, namhyung@gmail.com,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 8/9] stacktrace: implement save_stack_trace_quick()
Date: Tue, 10 Jan 2012 10:28:25 -0800
Message-Id: <1326220106-5765-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1326220106-5765-1-git-send-email-tj@kernel.org>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement save_stack_trace_quick() which only considers the usual
contexts (ie. thread and irq) and doesn't handle links between
different contexts - if %current is in irq context, only backtrace in
the irq stack is considered.

This is subset of dump_trace() done in much simpler way.  It's
intended to be used in hot paths where the overhead of dump_trace()
can be too heavy.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/stacktrace.h |    2 +
 arch/x86/kernel/stacktrace.c      |   40 +++++++++++++++++++++++++++++++++++++
 include/linux/stacktrace.h        |    6 +++++
 kernel/stacktrace.c               |    6 +++++
 4 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index 70bbe39..06bbdfc 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -50,9 +50,11 @@ void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
 #ifdef CONFIG_X86_32
 #define STACKSLOTS_PER_LINE 8
 #define get_bp(bp) asm("movl %%ebp, %0" : "=r" (bp) :)
+#define get_irq_stack_end()	0
 #else
 #define STACKSLOTS_PER_LINE 4
 #define get_bp(bp) asm("movq %%rbp, %0" : "=r" (bp) :)
+#define get_irq_stack_end()	(unsigned long)this_cpu_read(irq_stack_ptr)
 #endif
 
 #ifdef CONFIG_FRAME_POINTER
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index fdd0c64..f53ec547 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -81,6 +81,46 @@ void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 }
 EXPORT_SYMBOL_GPL(save_stack_trace_tsk);
 
+#ifdef CONFIG_FRAME_POINTER
+void save_stack_trace_quick(struct stack_trace *trace)
+{
+	const unsigned long stk_sz = THREAD_SIZE - sizeof(struct stack_frame);
+	unsigned long tstk = (unsigned long)current_thread_info();
+	unsigned long istk = get_irq_stack_end();
+	unsigned long last_bp = 0;
+	unsigned long bp, stk;
+
+	get_bp(bp);
+
+	if (bp > tstk && bp <= tstk + stk_sz)
+		stk = tstk;
+	else if (istk && (bp > istk && bp <= stk_sz))
+		stk = istk;
+	else
+		goto out;
+
+	while (bp > last_bp && bp <= stk + stk_sz) {
+		struct stack_frame *frame = (struct stack_frame *)bp;
+		unsigned long ret_addr = frame->return_address;
+
+		if (!trace->skip) {
+			if (trace->nr_entries >= trace->max_entries)
+				return;
+			trace->entries[trace->nr_entries++] = ret_addr;
+		} else {
+			trace->skip--;
+		}
+
+		last_bp = bp;
+		bp = (unsigned long)frame->next_frame;
+	}
+out:
+	if (trace->nr_entries < trace->max_entries)
+		trace->entries[trace->nr_entries++] = ULONG_MAX;
+}
+EXPORT_SYMBOL_GPL(save_stack_trace_quick);
+#endif
+
 /* Userspace stacktrace - based on kernel/trace/trace_sysprof.c */
 
 struct stack_frame_user {
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index 115b570..d5b16c4 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -19,6 +19,12 @@ extern void save_stack_trace_regs(struct pt_regs *regs,
 extern void save_stack_trace_tsk(struct task_struct *tsk,
 				struct stack_trace *trace);
 
+/*
+ * Saves only trace from the current context.  Doesn't handle exception
+ * stacks or verify text address.
+ */
+extern void save_stack_trace_quick(struct stack_trace *trace);
+
 extern void print_stack_trace(struct stack_trace *trace, int spaces);
 
 #ifdef CONFIG_USER_STACKTRACE_SUPPORT
diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index 00fe55c..4760949 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -31,6 +31,12 @@ EXPORT_SYMBOL_GPL(print_stack_trace);
  * (whenever this facility is utilized - for example by procfs):
  */
 __weak void
+save_stack_trace_quick(struct stack_trace *trace)
+{
+	WARN_ONCE(1, KERN_INFO "save_stack_trace_quick() not implemented yet.\n");
+}
+
+__weak void
 save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
 	WARN_ONCE(1, KERN_INFO "save_stack_trace_tsk() not implemented yet.\n");
-- 
1.7.3.1

