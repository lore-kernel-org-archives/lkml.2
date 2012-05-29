Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab2E2Ms4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:48:56 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:57997 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab2E2Msx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:48:53 -0400
X-AuditID: b753bd60-9f483ba000000655-53-4fc4c5b345e8
X-AuditID: b753bd60-9f483ba000000655-53-4fc4c5b345e8
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC PATCH -tip  1/9] ftrace: Add pt_regs acceptable trace callback
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 29 May 2012 21:48:58 +0900
Message-ID: <20120529124857.9191.5868.stgit@localhost.localdomain>
In-Reply-To: <20120529124833.9191.23007.stgit@localhost.localdomain>
References: <20120529124833.9191.23007.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new callback interface regs_func to ftrace_ops
which is an anonymous union to share the pointer
with func member. So, current ftrace user doesn't
need to change their callbacks.
This callback must be used with FTRACE_OPS_FL_SAVE_REGS.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---

 include/linux/ftrace.h |   21 ++++++++++++++++++++-
 kernel/trace/ftrace.c  |   44 +++++++++++++++++++++++++++++++-------------
 2 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 55e6d63..11abe4e 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -10,6 +10,8 @@
 #include <linux/kallsyms.h>
 #include <linux/linkage.h>
 #include <linux/bitops.h>
+#include <linux/module.h>
+#include <linux/ptrace.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
 #include <linux/types.h>
@@ -18,6 +20,14 @@
 
 #include <asm/ftrace.h>
 
+/*
+ * If the arch supports saving the regs to the ftrace_ops
+ * then it should set this to 1.
+ */
+#ifndef ARCH_SUPPORTS_FTRACE_SAVE_REGS
+#define ARCH_SUPPORTS_FTRACE_SAVE_REGS 0
+#endif
+
 struct module;
 struct ftrace_hash;
 
@@ -30,6 +40,8 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 		     loff_t *ppos);
 
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
+typedef void (*ftrace_regs_func_t)(unsigned long ip, unsigned long parent_ip,
+				   struct pt_regs *regs);
 
 /*
  * FTRACE_OPS_FL_* bits denote the state of ftrace_ops struct and are
@@ -45,16 +57,22 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
  *           could be controled by following calls:
  *             ftrace_function_local_enable
  *             ftrace_function_local_disable
+ * SAVE_REGS - set manualy by ftrace_ops user to denote the ftrace_ops
+ *             requests to pass pt_regs to callback.
  */
 enum {
 	FTRACE_OPS_FL_ENABLED		= 1 << 0,
 	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
 	FTRACE_OPS_FL_DYNAMIC		= 1 << 2,
 	FTRACE_OPS_FL_CONTROL		= 1 << 3,
+	FTRACE_OPS_FL_SAVE_REGS		= 1 << 4,
 };
 
 struct ftrace_ops {
-	ftrace_func_t			func;
+	union {
+		ftrace_func_t			func;
+		ftrace_regs_func_t		regs_func;
+	};
 	struct ftrace_ops		*next;
 	unsigned long			flags;
 	int __percpu			*disabled;
@@ -164,6 +182,7 @@ static inline int ftrace_function_local_disabled(struct ftrace_ops *ops)
 }
 
 extern void ftrace_stub(unsigned long a0, unsigned long a1);
+#define ftrace_regs_stub	(ftrace_regs_func_t)(ftrace_stub)
 
 #else /* !CONFIG_FUNCTION_TRACER */
 /*
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a008663..357b15b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -101,7 +101,9 @@ static struct ftrace_ops global_ops;
 static struct ftrace_ops control_ops;
 
 static void
-ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip);
+ftrace_ops_list_regs_func(unsigned long ip, unsigned long parent_ip,
+			  struct pt_regs *regs);
+#define ftrace_ops_list_func (ftrace_func_t)(ftrace_ops_list_regs_func)
 
 /*
  * Traverse the ftrace_global_list, invoking all entries.  The reason that we
@@ -112,8 +114,9 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip);
  *
  * Silly Alpha and silly pointer-speculation compiler optimizations!
  */
-static void ftrace_global_list_func(unsigned long ip,
-				    unsigned long parent_ip)
+static void
+ftrace_global_list_regs_func(unsigned long ip, unsigned long parent_ip,
+			     struct pt_regs *regs)
 {
 	struct ftrace_ops *op;
 
@@ -123,19 +126,24 @@ static void ftrace_global_list_func(unsigned long ip,
 	trace_recursion_set(TRACE_GLOBAL_BIT);
 	op = rcu_dereference_raw(ftrace_global_list); /*see above*/
 	while (op != &ftrace_list_end) {
-		op->func(ip, parent_ip);
+		op->regs_func(ip, parent_ip, regs);
 		op = rcu_dereference_raw(op->next); /*see above*/
 	};
 	trace_recursion_clear(TRACE_GLOBAL_BIT);
 }
+#define ftrace_global_list_func (ftrace_func_t)(ftrace_global_list_regs_func)
 
-static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip)
+static void ftrace_pid_regs_func(unsigned long ip, unsigned long parent_ip,
+				 struct pt_regs *regs)
 {
+	ftrace_regs_func_t func = (ftrace_regs_func_t)ftrace_pid_function;
+
 	if (!test_tsk_trace_trace(current))
 		return;
 
-	ftrace_pid_function(ip, parent_ip);
+	func(ip, parent_ip, regs);
 }
+#define ftrace_pid_func (ftrace_func_t)(ftrace_pid_regs_func)
 
 static void set_ftrace_pid_function(ftrace_func_t func)
 {
@@ -328,6 +336,10 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	if (!core_kernel_data((unsigned long)ops))
 		ops->flags |= FTRACE_OPS_FL_DYNAMIC;
 
+	if ((ops->flags & FTRACE_OPS_FL_SAVE_REGS) &&
+	    !ARCH_SUPPORTS_FTRACE_SAVE_REGS)
+			return -ENOSYS;
+
 	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
 		add_ftrace_list_ops(&ftrace_global_list, &global_ops, ops);
 		ops->flags |= FTRACE_OPS_FL_ENABLED;
@@ -1042,9 +1054,10 @@ static const struct ftrace_hash empty_hash = {
 #define EMPTY_HASH	((struct ftrace_hash *)&empty_hash)
 
 static struct ftrace_ops global_ops = {
-	.func			= ftrace_stub,
+	.regs_func		= ftrace_regs_stub,
 	.notrace_hash		= EMPTY_HASH,
 	.filter_hash		= EMPTY_HASH,
+	.flags			= FTRACE_OPS_FL_SAVE_REGS,
 };
 
 static DEFINE_MUTEX(ftrace_regex_lock);
@@ -3911,7 +3924,8 @@ void __init ftrace_init(void)
 #else
 
 static struct ftrace_ops global_ops = {
-	.func			= ftrace_stub,
+	.regs_func		= ftrace_regs_stub,
+	.flags			= FTRACE_OPS_FL_SAVE_REGS,
 };
 
 static int __init ftrace_nodyn_init(void)
@@ -3942,7 +3956,8 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 static void
-ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip)
+ftrace_ops_control_regs_func(unsigned long ip, unsigned long parent_ip,
+			     struct pt_regs *regs)
 {
 	struct ftrace_ops *op;
 
@@ -3959,7 +3974,7 @@ ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip)
 	while (op != &ftrace_list_end) {
 		if (!ftrace_function_local_disabled(op) &&
 		    ftrace_ops_test(op, ip))
-			op->func(ip, parent_ip);
+			op->regs_func(ip, parent_ip, regs);
 
 		op = rcu_dereference_raw(op->next);
 	};
@@ -3968,11 +3983,13 @@ ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip)
 }
 
 static struct ftrace_ops control_ops = {
-	.func = ftrace_ops_control_func,
+	.regs_func	= ftrace_ops_control_regs_func,
+	.flags		= FTRACE_OPS_FL_SAVE_REGS,
 };
 
 static void
-ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
+ftrace_ops_list_regs_func(unsigned long ip, unsigned long parent_ip,
+			  struct pt_regs *regs)
 {
 	struct ftrace_ops *op;
 
@@ -3988,7 +4005,8 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
 	op = rcu_dereference_raw(ftrace_ops_list);
 	while (op != &ftrace_list_end) {
 		if (ftrace_ops_test(op, ip))
-			op->func(ip, parent_ip);
+			/* regs will be ignored if op->func is set */
+			op->regs_func(ip, parent_ip, regs);
 		op = rcu_dereference_raw(op->next);
 	};
 	preempt_enable_notrace();

