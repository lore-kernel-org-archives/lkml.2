Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab1E0MtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:49:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:52056 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab1E0MtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:49:20 -0400
Date: Fri, 27 May 2011 12:48:56 GMT
From: tip-bot for Steven Rostedt <rostedt@goodmis.org>
Message-ID: <tip-b1cff0ad1062621ae63cb6c5dc4165191fe2e9f1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        rostedt@goodmis.org, baryluk@smp.if.uj.edu.pl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        rostedt@goodmis.org, baryluk@smp.if.uj.edu.pl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1306348063.1465.116.camel@gandalf.stny.rr.com>
References: <1306348063.1465.116.camel@gandalf.stny.rr.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] ftrace: Add internal recursive checks
Git-Commit-ID: b1cff0ad1062621ae63cb6c5dc4165191fe2e9f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 May 2011 12:48:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1cff0ad1062621ae63cb6c5dc4165191fe2e9f1
Gitweb:     http://git.kernel.org/tip/b1cff0ad1062621ae63cb6c5dc4165191fe2e9f1
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Wed, 25 May 2011 14:27:43 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 25 May 2011 22:13:49 -0400

ftrace: Add internal recursive checks

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

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1306348063.1465.116.camel@gandalf.stny.rr.com
Reported-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/sched.h      |    2 +-
 kernel/trace/ftrace.c      |   13 ++++++++++++-
 kernel/trace/ring_buffer.c |   10 +++++-----
 kernel/trace/trace.h       |   15 +++++++++++++++
 4 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d8b2d0b..7b78d9c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1513,7 +1513,7 @@ struct task_struct {
 #ifdef CONFIG_TRACING
 	/* state flags for use by tracers */
 	unsigned long trace;
-	/* bitmask of trace recursion */
+	/* bitmask and counter of trace recursion */
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR /* memcg uses this to do batch job */
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 25949b3..1ee417f 100644
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
@@ -3490,6 +3496,10 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
 {
 	struct ftrace_ops *op;
 
+	if (unlikely(trace_recursion_test(TRACE_INTERNAL_BIT)))
+		return;
+
+	trace_recursion_set(TRACE_INTERNAL_BIT);
 	/*
 	 * Some of the ops may be dynamically allocated,
 	 * they must be freed after a synchronize_sched().
@@ -3502,6 +3512,7 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
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
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6b69c4b..229f859 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -784,4 +784,19 @@ extern const char *__stop___trace_bprintk_fmt[];
 	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
 #include "trace_entries.h"
 
+/* Only current can touch trace_recursion */
+#define trace_recursion_inc() do { (current)->trace_recursion++; } while (0)
+#define trace_recursion_dec() do { (current)->trace_recursion--; } while (0)
+
+/* Ring buffer has the 10 LSB bits to count */
+#define trace_recursion_buffer() ((current)->trace_recursion & 0x3ff)
+
+/* for function tracing recursion */
+#define TRACE_INTERNAL_BIT		(1<<11)
+#define TRACE_GLOBAL_BIT		(1<<12)
+
+#define trace_recursion_set(bit)	do { (current)->trace_recursion |= (bit); } while (0)
+#define trace_recursion_clear(bit)	do { (current)->trace_recursion &= ~(bit); } while (0)
+#define trace_recursion_test(bit)	((current)->trace_recursion & (bit))
+
 #endif /* _LINUX_KERNEL_TRACE_H */
