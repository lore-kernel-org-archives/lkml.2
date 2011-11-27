Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1K0SEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 13:04:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab1K0SEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 13:04:49 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/9] ftrace: Add enable/disable ftrace_ops control interface
Date: Sun, 27 Nov 2011 19:04:29 +0100
Message-Id: <1322417074-5834-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a way to temporarily enable/disable ftrace_ops.

When there is a ftrace_ops with FTRACE_OPS_FL_CONTROL flag
registered, the ftrace_ops_list_func processing function
is used as ftrace function in order to have all registered
ftrace_ops under control.

Also using jump label not to introduce overhead to current
ftrace_ops_list_func processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/ftrace.h |   12 ++++++++++++
 kernel/trace/ftrace.c  |   39 +++++++++++++++++++++++++++++----------
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 26eafce..28b59f1 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -35,12 +35,14 @@ enum {
 	FTRACE_OPS_FL_ENABLED		= 1 << 0,
 	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
 	FTRACE_OPS_FL_DYNAMIC		= 1 << 2,
+	FTRACE_OPS_FL_CONTROL		= 1 << 3,
 };
 
 struct ftrace_ops {
 	ftrace_func_t			func;
 	struct ftrace_ops		*next;
 	unsigned long			flags;
+	atomic_t			disabled;
 #ifdef CONFIG_DYNAMIC_FTRACE
 	struct ftrace_hash		*notrace_hash;
 	struct ftrace_hash		*filter_hash;
@@ -97,6 +99,16 @@ int register_ftrace_function(struct ftrace_ops *ops);
 int unregister_ftrace_function(struct ftrace_ops *ops);
 void clear_ftrace_function(void);
 
+static inline void enable_ftrace_function(struct ftrace_ops *ops)
+{
+	atomic_dec(&ops->disabled);
+}
+
+static inline void disable_ftrace_function(struct ftrace_ops *ops)
+{
+	atomic_inc(&ops->disabled);
+}
+
 extern void ftrace_stub(unsigned long a0, unsigned long a1);
 
 #else /* !CONFIG_FUNCTION_TRACER */
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0ca0c0d..e5a9498 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -30,6 +30,7 @@
 #include <linux/list.h>
 #include <linux/hash.h>
 #include <linux/rcupdate.h>
+#include <linux/jump_label.h>
 
 #include <trace/events/sched.h>
 
@@ -94,6 +95,8 @@ ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
 static struct ftrace_ops global_ops;
 
+static struct jump_label_key ftrace_ops_control;
+
 static void
 ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip);
 
@@ -196,17 +199,21 @@ static void update_ftrace_function(void)
 
 	update_global_ops();
 
-	/*
-	 * If we are at the end of the list and this ops is
-	 * not dynamic, then have the mcount trampoline call
-	 * the function directly
-	 */
-	if (ftrace_ops_list == &ftrace_list_end ||
-	    (ftrace_ops_list->next == &ftrace_list_end &&
-	     !(ftrace_ops_list->flags & FTRACE_OPS_FL_DYNAMIC)))
-		func = ftrace_ops_list->func;
-	else
+	if (jump_label_enabled(&ftrace_ops_control))
 		func = ftrace_ops_list_func;
+	else {
+		/*
+		 * If we are at the end of the list and this ops is
+		 * not dynamic, then have the mcount trampoline call
+		 * the function directly
+		 */
+		if (ftrace_ops_list == &ftrace_list_end ||
+		    (ftrace_ops_list->next == &ftrace_list_end &&
+		     !(ftrace_ops_list->flags & FTRACE_OPS_FL_DYNAMIC)))
+			func = ftrace_ops_list->func;
+		else
+			func = ftrace_ops_list_func;
+	}
 
 #ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	ftrace_trace_function = func;
@@ -280,6 +287,9 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	} else
 		add_ftrace_ops(&ftrace_ops_list, ops);
 
+	if (ops->flags & FTRACE_OPS_FL_CONTROL)
+		jump_label_inc(&ftrace_ops_control);
+
 	if (ftrace_enabled)
 		update_ftrace_function();
 
@@ -311,6 +321,9 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	if (ret < 0)
 		return ret;
 
+	if (ops->flags & FTRACE_OPS_FL_CONTROL)
+		jump_label_dec(&ftrace_ops_control);
+
 	if (ftrace_enabled)
 		update_ftrace_function();
 
@@ -3577,8 +3590,14 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
 	preempt_disable_notrace();
 	op = rcu_dereference_raw(ftrace_ops_list);
 	while (op != &ftrace_list_end) {
+		if (static_branch(&ftrace_ops_control))
+			if ((op->flags & FTRACE_OPS_FL_CONTROL) &&
+			    atomic_read(&op->disabled))
+				goto next;
+
 		if (ftrace_ops_test(op, ip))
 			op->func(ip, parent_ip);
+ next:
 		op = rcu_dereference_raw(op->next);
 	};
 	preempt_enable_notrace();
-- 
1.7.1

