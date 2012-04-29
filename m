Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab2D2GpO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 02:45:14 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:61319 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab2D2GpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 02:45:11 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net, james.l.morris@oracle.com,
        ebiederm@xmission.com, akpm@linux-foundation.org, tglx@linutronix.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 04/14] ftrace,sysctl: remove proc input checks out of sysctl handlers
Date: Sun, 29 Apr 2012 08:45:27 +0200
Message-Id: <1335681937-3715-4-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1335681937-3715-1-git-send-email-levinsasha928@gmail.com>
References: <1335681937-3715-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify sysctl handler by removing user input checks and using the callback
provided by the sysctl table.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 include/linux/ftrace.h     |    8 ++------
 kernel/sysctl.c            |    6 ++++--
 kernel/trace/ftrace.c      |    8 ++------
 kernel/trace/trace_stack.c |    9 ++-------
 4 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 72a6cab..75a3530 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -25,9 +25,7 @@ struct ftrace_hash;
 
 extern int ftrace_enabled;
 extern int
-ftrace_enable_sysctl(struct ctl_table *table, int write,
-		     void __user *buffer, size_t *lenp,
-		     loff_t *ppos);
+ftrace_enable_sysctl(void);
 
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
 
@@ -181,9 +179,7 @@ static inline void ftrace_start(void) { }
 #ifdef CONFIG_STACK_TRACER
 extern int stack_tracer_enabled;
 int
-stack_trace_sysctl(struct ctl_table *table, int write,
-		   void __user *buffer, size_t *lenp,
-		   loff_t *ppos);
+stack_trace_sysctl(void);
 #endif
 
 struct ftrace_func_command {
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index fad9ff6..40be238 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -519,7 +519,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &ftrace_enabled,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= ftrace_enable_sysctl,
+		.proc_handler	= proc_dointvec,
+		.callback	= ftrace_enable_sysctl,
 	},
 #endif
 #ifdef CONFIG_STACK_TRACER
@@ -528,7 +529,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &stack_tracer_enabled,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= stack_trace_sysctl,
+		.callback	= stack_trace_sysctl,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_TRACING
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0fa92f6..70a5ec4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4340,9 +4340,7 @@ int unregister_ftrace_function(struct ftrace_ops *ops)
 EXPORT_SYMBOL_GPL(unregister_ftrace_function);
 
 int
-ftrace_enable_sysctl(struct ctl_table *table, int write,
-		     void __user *buffer, size_t *lenp,
-		     loff_t *ppos)
+ftrace_enable_sysctl(void)
 {
 	int ret = -ENODEV;
 
@@ -4351,9 +4349,7 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 	if (unlikely(ftrace_disabled))
 		goto out;
 
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
-
-	if (ret || !write || (last_ftrace_enabled == !!ftrace_enabled))
+	if (last_ftrace_enabled == !!ftrace_enabled)
 		goto out;
 
 	last_ftrace_enabled = !!ftrace_enabled;
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index d4545f4..3b05ec2 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -329,18 +329,13 @@ static const struct file_operations stack_trace_filter_fops = {
 };
 
 int
-stack_trace_sysctl(struct ctl_table *table, int write,
-		   void __user *buffer, size_t *lenp,
-		   loff_t *ppos)
+stack_trace_sysctl(void)
 {
 	int ret;
 
 	mutex_lock(&stack_sysctl_mutex);
 
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
-
-	if (ret || !write ||
-	    (last_stack_tracer_enabled == !!stack_tracer_enabled))
+	if (last_stack_tracer_enabled == !!stack_tracer_enabled)
 		goto out;
 
 	last_stack_tracer_enabled = !!stack_tracer_enabled;
-- 
1.7.8.5

