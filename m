Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1EYS1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:27:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38522 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab1EYS1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:27:47 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=Of4wFFCBLeMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=z4tt_EgH6Pnk7Uv_TQEA:9 a=rqb_jCNwn1IwhDZjZ2sA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [RFC][PATCH] ftrace: Add internal recursive checks
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Witold Baryluk <baryluk@smp.if.uj.edu.pl>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 25 May 2011 14:27:43 -0400
Message-ID: <1306348063.1465.116.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Witold reported a reboot caused by the selftests of the dynamic function
tracer. He sent me a config and I used ktest to do a config_bisect on it
(as my config did not cause the crash). It pointed out that the problem
config was CONFIG_PROVE_RCU.

What happened was that if multiple callbacks are attached to the
function tracer, we iterate a list of callbacks. Because the list is
managed by synchronize_sched() and preempt_disable, the access to the
pointers uses rcu_dereference_raw().

When PROVE_RCU is enabled, the rcu_dereference_raw() calls some
debugging functions, which happen to be traced. The tracing of the debug
function would then call rcu_dereference_raw() which would then call the
debug function and then... well you get the idea.

I first wrote two different patches to solve this bug.

1) add a __rcu_dereference_raw() that would not do any checks.
2) add notrace to the offending debug functions.

Both of these patches worked.

Talking with Paul McKenney on IRC, he suggested to add recursion
detection instead. This seemed to be a better solution, so I decided to
implement it. As the task_struct already has a trace_recursion to detect
recursion in the ring buffer, and that has a very small number it
allows, I decided to use that same variable to add flags that can detect
the recursion inside the infrastructure of the function tracer.

I plan to change it so that the task struct bit can be checked in
mcount, but as that requires changes to all archs, I will hold that off
to the next merge window.

Reported-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Not-yet-signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 885c4f2..54484e0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1514,8 +1514,20 @@ struct task_struct {
 #ifdef CONFIG_TRACING
 	/* state flags for use by tracers */
 	unsigned long trace;
-	/* bitmask of trace recursion */
+	/* bitmask and counter of trace recursion */
 	unsigned long trace_recursion;
+
+	/* Only current can touch these values */
+#define trace_recursion_inc() (current)->trace_recursion++
+#define trace_recursion_dec() (current)->trace_recursion--
+	/* Ring buffer has the 10 LSB bits to count */
+#define trace_recursion_buffer() ((current)->trace_recursion & 0x3ff)
+#define TRACE_INTERNAL_BIT		(1<<11)
+#define TRACE_GLOBAL_BIT		(1<<12)
+#define trace_recursion_set(bit)	(current)->trace_recursion |= (bit)
+#define trace_recursion_clear(bit)	(current)->trace_recursion &= ~(bit)
+#define trace_recursion_test(bit)	((current)->trace_recursion & (bit))
+
 #endif /* CONFIG_TRACING */
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR /* memcg uses this to do batch job */
 	struct memcg_batch_info {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d017c2c..33b00d8 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -109,12 +109,18 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip);
 static void ftrace_global_list_func(unsigned long ip,
 				    unsigned long parent_ip)
 {
-	struct ftrace_ops *op = rcu_dereference_raw(ftrace_global_list); /*see above*/
+	struct ftrace_ops *op;
+
+	if (unlikely(trace_recursion_test(TRACE_GLOBAL_BIT)))
+		return;
 
+	trace_recursion_set(TRACE_GLOBAL_BIT);
+	op = rcu_dereference_raw(ftrace_global_list); /*see above*/
 	while (op != &ftrace_list_end) {
 		op->func(ip, parent_ip);
 		op = rcu_dereference_raw(op->next); /*see above*/
 	};
+	trace_recursion_clear(TRACE_GLOBAL_BIT);
 }
 
 static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip)
@@ -3484,6 +3490,10 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
 {
 	struct ftrace_ops *op;
 
+	if (unlikely(trace_recursion_test(TRACE_INTERNAL_BIT)))
+		return;
+
+	trace_recursion_set(TRACE_INTERNAL_BIT);
 	/*
 	 * Some of the ops may be dynamically allocated,
 	 * they must be freed after a synchronize_sched().
@@ -3496,6 +3506,7 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
 		op = rcu_dereference_raw(op->next);
 	};
 	preempt_enable_notrace();
+	trace_recursion_clear(TRACE_INTERNAL_BIT);
 }
 
 static void clear_ftrace_swapper(void)
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 0ef7b4b..b0c7aa4 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2216,7 +2216,7 @@ static noinline void trace_recursive_fail(void)
 
 	printk_once(KERN_WARNING "Tracing recursion: depth[%ld]:"
 		    "HC[%lu]:SC[%lu]:NMI[%lu]\n",
-		    current->trace_recursion,
+		    trace_recursion_buffer(),
 		    hardirq_count() >> HARDIRQ_SHIFT,
 		    softirq_count() >> SOFTIRQ_SHIFT,
 		    in_nmi());
@@ -2226,9 +2226,9 @@ static noinline void trace_recursive_fail(void)
 
 static inline int trace_recursive_lock(void)
 {
-	current->trace_recursion++;
+	trace_recursion_inc();
 
-	if (likely(current->trace_recursion < TRACE_RECURSIVE_DEPTH))
+	if (likely(trace_recursion_buffer() < TRACE_RECURSIVE_DEPTH))
 		return 0;
 
 	trace_recursive_fail();
@@ -2238,9 +2238,9 @@ static inline int trace_recursive_lock(void)
 
 static inline void trace_recursive_unlock(void)
 {
-	WARN_ON_ONCE(!current->trace_recursion);
+	WARN_ON_ONCE(!trace_recursion_buffer());
 
-	current->trace_recursion--;
+	trace_recursion_dec();
 }
 
 #else


