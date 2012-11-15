Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768263Ab2KOPdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:33:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10749 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423672Ab2KOPdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:33:37 -0500
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=BBeOcqLgTa8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=BzedUO3QcyYA:10 a=20KFwNOVAAAA:8 a=MkUdZa0Ew_x9cn3kJH8A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=NWVoK91CQyQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121115153335.488351635@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 15 Nov 2012 10:30:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 6/8][RFC] tracing: Avoid unnecessary multiple recursion checks
References: <20121115153036.550942394@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Avoid-unnecessary-multiple-recursion-checks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When function tracing occurs, the following steps are made:
  If arch does not support a ftrace feature:
   call internal function (uses INTERNAL bits) which calls...
  If callback is registered to the "global" list, the list
   function is called and recursion checks the GLOBAL bits.
   then this function calls...
  The function callback, which can use the FTRACE bits to
   check for recursion.

Now if the arch does not suppport a feature, and it calls
the global list function which calls the ftrace callback
all three of these steps will do a recursion protection.
There's no reason to do one if the previous caller already
did. The recursion that we are protecting against will
go through the same steps again.

To prevent the multiple recursion checks, if a recursion
bit is set that is higher than the MAX bit of the current
check, then we know that the check was made by the previous
caller, and we can skip the current check.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   40 +++++--------------
 kernel/trace/trace.h  |  106 ++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 110 insertions(+), 36 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index fbf25e7..d1ceaf4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -158,25 +158,15 @@ ftrace_global_list_func(unsigned long ip, unsigned long parent_ip,
 {
 	int bit;
 
-	if (in_interrupt()) {
-		if (in_nmi())
-			bit = TRACE_GLOBAL_NMI_BIT;
-
-		else if (in_irq())
-			bit = TRACE_GLOBAL_IRQ_BIT;
-		else
-			bit = TRACE_GLOBAL_SIRQ_BIT;
-	} else
-		bit = TRACE_GLOBAL_BIT;
-
-	if (unlikely(trace_recursion_test(bit)))
+	bit = trace_test_and_set_recursion(TRACE_GLOBAL_START, TRACE_GLOBAL_MAX);
+	if (bit < 0)
 		return;
 
-	trace_recursion_set(bit);
 	do_for_each_ftrace_op(op, ftrace_global_list) {
 		op->func(ip, parent_ip, op, regs);
 	} while_for_each_ftrace_op(op);
-	trace_recursion_clear(bit);
+
+	trace_clear_recursion(bit);
 }
 
 static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip,
@@ -4145,26 +4135,14 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 		       struct ftrace_ops *ignored, struct pt_regs *regs)
 {
 	struct ftrace_ops *op;
-	unsigned int bit;
+	int bit;
 
 	if (function_trace_stop)
 		return;
 
-	if (in_interrupt()) {
-		if (in_nmi())
-			bit = TRACE_INTERNAL_NMI_BIT;
-
-		else if (in_irq())
-			bit = TRACE_INTERNAL_IRQ_BIT;
-		else
-			bit = TRACE_INTERNAL_SIRQ_BIT;
-	} else
-		bit = TRACE_INTERNAL_BIT;
-
-	if (unlikely(trace_recursion_test(bit)))
-			return;
-
-	trace_recursion_set(bit);
+	bit = trace_test_and_set_recursion(TRACE_LIST_START, TRACE_LIST_MAX);
+	if (bit < 0)
+		return;
 
 	/*
 	 * Some of the ops may be dynamically allocated,
@@ -4176,7 +4154,7 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 			op->func(ip, parent_ip, op, regs);
 	} while_for_each_ftrace_op(op);
 	preempt_enable_notrace();
-	trace_recursion_clear(bit);
+	trace_clear_recursion(bit);
 }
 
 /*
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 5a095d6..c203a51 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -297,18 +297,49 @@ struct tracer {
 /* Ring buffer has the 10 LSB bits to count */
 #define trace_recursion_buffer() ((current)->trace_recursion & 0x3ff)
 
-/* for function tracing recursion */
+/*
+ * For function tracing recursion:
+ *  The order of these bits are important.
+ *
+ *  When function tracing occurs, the following steps are made:
+ *   If arch does not support a ftrace feature:
+ *    call internal function (uses INTERNAL bits) which calls...
+ *   If callback is registered to the "global" list, the list
+ *    function is called and recursion checks the GLOBAL bits.
+ *    then this function calls...
+ *   The function callback, which can use the FTRACE bits to
+ *    check for recursion.
+ *
+ * Now if the arch does not suppport a feature, and it calls
+ * the global list function which calls the ftrace callback
+ * all three of these steps will do a recursion protection.
+ * There's no reason to do one if the previous caller already
+ * did. The recursion that we are protecting against will
+ * go through the same steps again.
+ *
+ * To prevent the multiple recursion checks, if a recursion
+ * bit is set that is higher than the MAX bit of the current
+ * check, then we know that the check was made by the previous
+ * caller, and we can skip the current check.
+ */
 enum {
-	TRACE_INTERNAL_BIT = 11,
-	TRACE_INTERNAL_NMI_BIT,
-	TRACE_INTERNAL_IRQ_BIT,
-	TRACE_INTERNAL_SIRQ_BIT,
+	TRACE_FTRACE_BIT = 11,
+	TRACE_FTRACE_NMI_BIT,
+	TRACE_FTRACE_IRQ_BIT,
+	TRACE_FTRACE_SIRQ_BIT,
 
+	/* GLOBAL_BITs must be greater than FTRACE_BITs */
 	TRACE_GLOBAL_BIT,
 	TRACE_GLOBAL_NMI_BIT,
 	TRACE_GLOBAL_IRQ_BIT,
 	TRACE_GLOBAL_SIRQ_BIT,
 
+	/* INTERNAL_BITs must be greater than GLOBAL_BITs */
+	TRACE_INTERNAL_BIT,
+	TRACE_INTERNAL_NMI_BIT,
+	TRACE_INTERNAL_IRQ_BIT,
+	TRACE_INTERNAL_SIRQ_BIT,
+
 	TRACE_CONTROL_BIT,
 
 /*
@@ -325,6 +356,71 @@ enum {
 #define trace_recursion_clear(bit)	do { (current)->trace_recursion &= ~(1<<(bit)); } while (0)
 #define trace_recursion_test(bit)	((current)->trace_recursion & (1<<(bit)))
 
+#define TRACE_CONTEXT_BITS	4
+
+#define TRACE_FTRACE_START	TRACE_FTRACE_BIT
+#define TRACE_FTRACE_MAX	((1 << (TRACE_FTRACE_START + TRACE_CONTEXT_BITS)) - 1)
+
+#define TRACE_GLOBAL_START	TRACE_GLOBAL_BIT
+#define TRACE_GLOBAL_MAX	((1 << (TRACE_GLOBAL_START + TRACE_CONTEXT_BITS)) - 1)
+
+#define TRACE_LIST_START	TRACE_INTERNAL_BIT
+#define TRACE_LIST_MAX		((1 << (TRACE_LIST_START + TRACE_CONTEXT_BITS)) - 1)
+
+#define TRACE_CONTEXT_MASK	TRACE_LIST_MAX
+
+static __always_inline int trace_get_context_bit(void)
+{
+	int bit;
+
+	if (in_interrupt()) {
+		if (in_nmi())
+			bit = 0;
+
+		else if (in_irq())
+			bit = 1;
+		else
+			bit = 2;
+	} else
+		bit = 3;
+
+	return bit;
+}
+
+static __always_inline int trace_test_and_set_recursion(int start, int max)
+{
+	unsigned int val = current->trace_recursion;
+	int bit;
+
+	/* A previous recursion check was made */
+	if ((val & TRACE_CONTEXT_MASK) > max)
+		return 0;
+
+	bit = trace_get_context_bit() + start;
+	if (unlikely(val & (1 << bit)))
+		return -1;
+
+	val |= 1 << bit;
+	current->trace_recursion = val;
+	barrier();
+
+	return bit;
+}
+
+static __always_inline void trace_clear_recursion(int bit)
+{
+	unsigned int val = current->trace_recursion;
+
+	if (!bit)
+		return;
+
+	bit = 1 << bit;
+	val &= ~bit;
+
+	barrier();
+	current->trace_recursion = val;
+}
+
 #define TRACE_PIPE_ALL_CPU	-1
 
 static inline struct ring_buffer_iter *
-- 
1.7.10.4


