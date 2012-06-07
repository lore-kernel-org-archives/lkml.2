Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab2FGXqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 19:46:50 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:55915 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab2FGXqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:46:48 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Justin Teravest <teravest@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 2/2] tracing: Cleanup unnecessary function declarations
Date: Thu,  7 Jun 2012 16:46:25 -0700
Message-Id: <1339112785-21806-2-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1339112785-21806-1-git-send-email-vnagarnaik@google.com>
References: <1339112785-21806-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions defined in include/trace/syscalls.h are not used directly
since struct ftrace_event_class was introduced. Remove them from the
header file and rearrange the ftrace_event_class declarations in
trace_syscalls.c.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 include/trace/syscall.h       |   21 --------------
 kernel/trace/trace_syscalls.c |   61 +++++++++++++++++++---------------------
 2 files changed, 29 insertions(+), 53 deletions(-)

diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 0c95796..84bc419 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -31,25 +31,4 @@ struct syscall_metadata {
 	struct ftrace_event_call *exit_event;
 };
 
-#ifdef CONFIG_FTRACE_SYSCALLS
-extern unsigned long arch_syscall_addr(int nr);
-extern int init_syscall_trace(struct ftrace_event_call *call);
-
-extern int reg_event_syscall_enter(struct ftrace_event_call *call);
-extern void unreg_event_syscall_enter(struct ftrace_event_call *call);
-extern int reg_event_syscall_exit(struct ftrace_event_call *call);
-extern void unreg_event_syscall_exit(struct ftrace_event_call *call);
-enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags,
-				      struct trace_event *event);
-enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags,
-				     struct trace_event *event);
-#endif
-
-#ifdef CONFIG_PERF_EVENTS
-int perf_sysenter_enable(struct ftrace_event_call *call);
-void perf_sysenter_disable(struct ftrace_event_call *call);
-int perf_sysexit_enable(struct ftrace_event_call *call);
-void perf_sysexit_disable(struct ftrace_event_call *call);
-#endif
-
 #endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 96fc733..72a5222 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -21,9 +21,6 @@ static int syscall_enter_register(struct ftrace_event_call *event,
 static int syscall_exit_register(struct ftrace_event_call *event,
 				 enum trace_reg type, void *data);
 
-static int syscall_enter_define_fields(struct ftrace_event_call *call);
-static int syscall_exit_define_fields(struct ftrace_event_call *call);
-
 static struct list_head *
 syscall_get_enter_fields(struct ftrace_event_call *call)
 {
@@ -32,30 +29,6 @@ syscall_get_enter_fields(struct ftrace_event_call *call)
 	return &entry->enter_fields;
 }
 
-struct trace_event_functions enter_syscall_print_funcs = {
-	.trace		= print_syscall_enter,
-};
-
-struct trace_event_functions exit_syscall_print_funcs = {
-	.trace		= print_syscall_exit,
-};
-
-struct ftrace_event_class event_class_syscall_enter = {
-	.system		= "syscalls",
-	.reg		= syscall_enter_register,
-	.define_fields	= syscall_enter_define_fields,
-	.get_fields	= syscall_get_enter_fields,
-	.raw_init	= init_syscall_trace,
-};
-
-struct ftrace_event_class event_class_syscall_exit = {
-	.system		= "syscalls",
-	.reg		= syscall_exit_register,
-	.define_fields	= syscall_exit_define_fields,
-	.fields		= LIST_HEAD_INIT(event_class_syscall_exit.fields),
-	.raw_init	= init_syscall_trace,
-};
-
 extern struct syscall_metadata *__start_syscalls_metadata[];
 extern struct syscall_metadata *__stop_syscalls_metadata[];
 
@@ -432,7 +405,7 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
 	mutex_unlock(&syscall_trace_lock);
 }
 
-int init_syscall_trace(struct ftrace_event_call *call)
+static int init_syscall_trace(struct ftrace_event_call *call)
 {
 	int id;
 	int num;
@@ -457,6 +430,30 @@ int init_syscall_trace(struct ftrace_event_call *call)
 	return id;
 }
 
+struct trace_event_functions enter_syscall_print_funcs = {
+	.trace		= print_syscall_enter,
+};
+
+struct trace_event_functions exit_syscall_print_funcs = {
+	.trace		= print_syscall_exit,
+};
+
+struct ftrace_event_class event_class_syscall_enter = {
+	.system		= "syscalls",
+	.reg		= syscall_enter_register,
+	.define_fields	= syscall_enter_define_fields,
+	.get_fields	= syscall_get_enter_fields,
+	.raw_init	= init_syscall_trace,
+};
+
+struct ftrace_event_class event_class_syscall_exit = {
+	.system		= "syscalls",
+	.reg		= syscall_exit_register,
+	.define_fields	= syscall_exit_define_fields,
+	.fields		= LIST_HEAD_INIT(event_class_syscall_exit.fields),
+	.raw_init	= init_syscall_trace,
+};
+
 unsigned long __init __weak arch_syscall_addr(int nr)
 {
 	return (unsigned long)sys_call_table[nr];
@@ -535,7 +532,7 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
 }
 
-int perf_sysenter_enable(struct ftrace_event_call *call)
+static int perf_sysenter_enable(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
@@ -556,7 +553,7 @@ int perf_sysenter_enable(struct ftrace_event_call *call)
 	return ret;
 }
 
-void perf_sysenter_disable(struct ftrace_event_call *call)
+static void perf_sysenter_disable(struct ftrace_event_call *call)
 {
 	int num;
 
@@ -611,7 +608,7 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
 }
 
-int perf_sysexit_enable(struct ftrace_event_call *call)
+static int perf_sysexit_enable(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
@@ -632,7 +629,7 @@ int perf_sysexit_enable(struct ftrace_event_call *call)
 	return ret;
 }
 
-void perf_sysexit_disable(struct ftrace_event_call *call)
+static void perf_sysexit_disable(struct ftrace_event_call *call)
 {
 	int num;
 
-- 
1.7.7.3

