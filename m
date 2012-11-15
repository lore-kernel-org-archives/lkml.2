Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768283Ab2KOPfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:35:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25955 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423669Ab2KOPdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:33:37 -0500
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Y39-H8YWJCMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=GY31fDRxNSIA:10 a=20KFwNOVAAAA:8 a=Zs1o9KcDAAAA:20 a=UuaRXJyG3pFBOS-sCpAA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=NWVoK91CQyQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121115153335.023275470@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 15 Nov 2012 10:30:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/8][RFC] ftrace: Optimize the function tracer list loop
References: <20121115153036.550942394@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Optimize-the-function-tracer-list-loop.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There is lots of places that perform:

       op = rcu_dereference_raw(ftrace_control_list);
       while (op != &ftrace_list_end) {

Add a helper macro to do this, and also optimize for a single
entity. That is, gcc will optimize a loop for either no iterations
or more than one iteration. But usually only a single callback
is registered to the function tracer, thus the optimized case
should be a single pass. to do this we now do:

	op = rcu_dereference_raw(list);
	do {
		[...]
	} while (likely(op = rcu_dereference_raw((op)->next)) &&
	       unlikely((op) != &ftrace_list_end));

An op is always registered (ftrace_list_end when no callbacks is
registered), thus when a single callback is registered, the link
list looks like:

 top => callback => ftrace_list_end => NULL.

The likely(op = op->next) still must be performed due to the race
of removing the callback, where the first op assignment could
equal ftrace_list_end. In that case, the op->next would be NULL.
But this is unlikely (only happens in a race condition when
removing the callback).

But it is very likely that the next op would be ftrace_list_end,
unless more than one callback has been registered. This tells
gcc what the most common case is and makes the fast path with
the least amount of branches.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   48 ++++++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 67e886e..cd6cd3c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -111,6 +111,26 @@ static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip);
 #define ftrace_ops_list_func ((ftrace_func_t)ftrace_ops_no_ops)
 #endif
 
+/*
+ * Traverse the ftrace_global_list, invoking all entries.  The reason that we
+ * can use rcu_dereference_raw() is that elements removed from this list
+ * are simply leaked, so there is no need to interact with a grace-period
+ * mechanism.  The rcu_dereference_raw() calls are needed to handle
+ * concurrent insertions into the ftrace_global_list.
+ *
+ * Silly Alpha and silly pointer-speculation compiler optimizations!
+ */
+#define do_for_each_ftrace_op(op, list)			\
+	op = rcu_dereference_raw(list);			\
+	do
+
+/*
+ * Optimized for just a single item in the list (as that is the normal case).
+ */
+#define while_for_each_ftrace_op(op)				\
+	while (likely(op = rcu_dereference_raw((op)->next)) &&	\
+	       unlikely((op) != &ftrace_list_end))
+
 /**
  * ftrace_nr_registered_ops - return number of ops registered
  *
@@ -132,15 +152,6 @@ int ftrace_nr_registered_ops(void)
 	return cnt;
 }
 
-/*
- * Traverse the ftrace_global_list, invoking all entries.  The reason that we
- * can use rcu_dereference_raw() is that elements removed from this list
- * are simply leaked, so there is no need to interact with a grace-period
- * mechanism.  The rcu_dereference_raw() calls are needed to handle
- * concurrent insertions into the ftrace_global_list.
- *
- * Silly Alpha and silly pointer-speculation compiler optimizations!
- */
 static void
 ftrace_global_list_func(unsigned long ip, unsigned long parent_ip,
 			struct ftrace_ops *op, struct pt_regs *regs)
@@ -149,11 +160,9 @@ ftrace_global_list_func(unsigned long ip, unsigned long parent_ip,
 		return;
 
 	trace_recursion_set(TRACE_GLOBAL_BIT);
-	op = rcu_dereference_raw(ftrace_global_list); /*see above*/
-	while (op != &ftrace_list_end) {
+	do_for_each_ftrace_op(op, ftrace_global_list) {
 		op->func(ip, parent_ip, op, regs);
-		op = rcu_dereference_raw(op->next); /*see above*/
-	};
+	} while_for_each_ftrace_op(op);
 	trace_recursion_clear(TRACE_GLOBAL_BIT);
 }
 
@@ -4104,14 +4113,11 @@ ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip,
 	 */
 	preempt_disable_notrace();
 	trace_recursion_set(TRACE_CONTROL_BIT);
-	op = rcu_dereference_raw(ftrace_control_list);
-	while (op != &ftrace_list_end) {
+	do_for_each_ftrace_op(op, ftrace_control_list) {
 		if (!ftrace_function_local_disabled(op) &&
 		    ftrace_ops_test(op, ip))
 			op->func(ip, parent_ip, op, regs);
-
-		op = rcu_dereference_raw(op->next);
-	};
+	} while_for_each_ftrace_op(op);
 	trace_recursion_clear(TRACE_CONTROL_BIT);
 	preempt_enable_notrace();
 }
@@ -4139,12 +4145,10 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 	 * they must be freed after a synchronize_sched().
 	 */
 	preempt_disable_notrace();
-	op = rcu_dereference_raw(ftrace_ops_list);
-	while (op != &ftrace_list_end) {
+	do_for_each_ftrace_op(op, ftrace_ops_list) {
 		if (ftrace_ops_test(op, ip))
 			op->func(ip, parent_ip, op, regs);
-		op = rcu_dereference_raw(op->next);
-	};
+	} while_for_each_ftrace_op(op);
 	preempt_enable_notrace();
 	trace_recursion_clear(TRACE_INTERNAL_BIT);
 }
-- 
1.7.10.4


