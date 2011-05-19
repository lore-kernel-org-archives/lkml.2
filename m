Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab1ESCNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:13:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48926 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261Ab1ESCM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:12:59 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=vhdKIqpQuCYA:10 a=n0Q0lEMb9IYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=YuP4eykecyYApwGTTjgA:9 a=3iS-E_L6_sCu-NWzvKAA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=DmKOUiZJvmik9T3l:21 a=64k_nwP_7JuGMWKo:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110519021257.168165585@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 22:12:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 11/13] ftrace: Allow dynamically allocated function tracers
References: <20110519021151.600991800@goodmis.org>
Content-Disposition: inline; filename=0011-ftrace-Allow-dynamically-allocated-function-tracers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Now that functions may be selected individually, it only makes sense
that we should allow dynamically allocated trace structures to
be traced. This will allow perf to allocate a ftrace_ops structure
at runtime and use it to pick and choose which functions that
structure will trace.

Note, a dynamically allocated ftrace_ops will always be called
indirectly instead of being called directly from the mcount in
entry.S. This is because there's no safe way to prevent mcount
from being preempted before calling the function, unless we
modify every entry.S to do so (not likely). Thus, dynamically allocated
functions will now be called by the ftrace_ops_list_func() that
loops through the ops that are allocated if there are more than
one op allocated at a time. This loop is protected with a
preempt_disable.

To determine if an ftrace_ops structure is allocated or not, a new
util function was added to the kernel/extable.c called
core_kernel_data(), which returns 1 if the address is between
_sdata and _edata.

Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    1 +
 include/linux/kernel.h |    1 +
 kernel/extable.c       |    8 ++++++++
 kernel/trace/ftrace.c  |   37 ++++++++++++++++++++++++++++++-------
 4 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 4609c0e..caba694 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -34,6 +34,7 @@ struct ftrace_hash;
 enum {
 	FTRACE_OPS_FL_ENABLED		= 1 << 0,
 	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
+	FTRACE_OPS_FL_DYNAMIC		= 1 << 2,
 };
 
 struct ftrace_ops {
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 00cec4d..f37ba71 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -283,6 +283,7 @@ extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
 
 extern int core_kernel_text(unsigned long addr);
+extern int core_kernel_data(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
diff --git a/kernel/extable.c b/kernel/extable.c
index 7f8f263..c2d625f 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -72,6 +72,14 @@ int core_kernel_text(unsigned long addr)
 	return 0;
 }
 
+int core_kernel_data(unsigned long addr)
+{
+	if (addr >= (unsigned long)_sdata &&
+	    addr < (unsigned long)_edata)
+		return 1;
+	return 0;
+}
+
 int __kernel_text_address(unsigned long addr)
 {
 	if (core_kernel_text(addr))
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6c7e1df..5b3ee04 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -189,8 +189,14 @@ static void update_ftrace_function(void)
 
 	update_global_ops();
 
+	/*
+	 * If we are at the end of the list and this ops is
+	 * not dynamic, then have the mcount trampoline call
+	 * the function directly
+	 */
 	if (ftrace_ops_list == &ftrace_list_end ||
-	    ftrace_ops_list->next == &ftrace_list_end)
+	    (ftrace_ops_list->next == &ftrace_list_end &&
+	     !(ftrace_ops_list->flags & FTRACE_OPS_FL_DYNAMIC)))
 		func = ftrace_ops_list->func;
 	else
 		func = ftrace_ops_list_func;
@@ -250,6 +256,9 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	if (WARN_ON(ops->flags & FTRACE_OPS_FL_ENABLED))
 		return -EBUSY;
 
+	if (!core_kernel_data((unsigned long)ops))
+		ops->flags |= FTRACE_OPS_FL_DYNAMIC;
+
 	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
 		int first = ftrace_global_list == &ftrace_list_end;
 		add_ftrace_ops(&ftrace_global_list, ops);
@@ -293,6 +302,13 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	if (ftrace_enabled)
 		update_ftrace_function();
 
+	/*
+	 * Dynamic ops may be freed, we must make sure that all
+	 * callers are done before leaving this function.
+	 */
+	if (ops->flags & FTRACE_OPS_FL_DYNAMIC)
+		synchronize_sched();
+
 	return 0;
 }
 
@@ -1225,6 +1241,9 @@ ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
  * the filter_hash does not exist or is empty,
  *  AND
  * the ip is not in the ops->notrace_hash.
+ *
+ * This needs to be called with preemption disabled as
+ * the hashes are freed with call_rcu_sched().
  */
 static int
 ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
@@ -1233,9 +1252,6 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
 	struct ftrace_hash *notrace_hash;
 	int ret;
 
-	/* The hashes are freed with call_rcu_sched() */
-	preempt_disable_notrace();
-
 	filter_hash = rcu_dereference_raw(ops->filter_hash);
 	notrace_hash = rcu_dereference_raw(ops->notrace_hash);
 
@@ -1246,7 +1262,6 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
 		ret = 1;
 	else
 		ret = 0;
-	preempt_enable_notrace();
 
 	return ret;
 }
@@ -3425,14 +3440,20 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
 static void
 ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
 {
-	/* see comment above ftrace_global_list_func */
-	struct ftrace_ops *op = rcu_dereference_raw(ftrace_ops_list);
+	struct ftrace_ops *op;
 
+	/*
+	 * Some of the ops may be dynamically allocated,
+	 * they must be freed after a synchronize_sched().
+	 */
+	preempt_disable_notrace();
+	op = rcu_dereference_raw(ftrace_ops_list);
 	while (op != &ftrace_list_end) {
 		if (ftrace_ops_test(op, ip))
 			op->func(ip, parent_ip);
 		op = rcu_dereference_raw(op->next);
 	};
+	preempt_enable_notrace();
 }
 
 static void clear_ftrace_swapper(void)
@@ -3743,6 +3764,7 @@ int register_ftrace_function(struct ftrace_ops *ops)
 	mutex_unlock(&ftrace_lock);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_ftrace_function);
 
 /**
  * unregister_ftrace_function - unregister a function for profiling.
@@ -3762,6 +3784,7 @@ int unregister_ftrace_function(struct ftrace_ops *ops)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(unregister_ftrace_function);
 
 int
 ftrace_enable_sysctl(struct ctl_table *table, int write,
-- 
1.7.4.4


