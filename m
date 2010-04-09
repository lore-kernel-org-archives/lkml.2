Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab0DIXB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 19:01:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33620
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756523Ab0DIXBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 19:01:40 -0400
Date: Fri, 09 Apr 2010 16:01:43 -0700 (PDT)
Message-Id: <20100409.160143.201915197.davem@davemloft.net>
To: peterz@infradead.org
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: [PATCH 4/4] tracing: Use local_irq_{save,restore}_nmi() in tracers.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 kernel/trace/ftrace.c                |    8 ++++----
 kernel/trace/trace_functions.c       |    8 ++++----
 kernel/trace/trace_functions_graph.c |    8 ++++----
 kernel/trace/trace_sched_wakeup.c    |    4 ++--
 kernel/trace/trace_stack.c           |    4 ++--
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2404b59..6be1e33 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -613,7 +613,7 @@ function_profile_call(unsigned long ip, unsigned long parent_ip)
 	if (!ftrace_profile_enabled)
 		return;
 
-	local_irq_save(flags);
+	local_irq_save_nmi(flags);
 
 	stat = &__get_cpu_var(ftrace_profile_stats);
 	if (!stat->hash || !ftrace_profile_enabled)
@@ -628,7 +628,7 @@ function_profile_call(unsigned long ip, unsigned long parent_ip)
 
 	rec->counter++;
  out:
-	local_irq_restore(flags);
+	local_irq_restore_nmi(flags);
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -645,7 +645,7 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
 	struct ftrace_profile *rec;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	local_irq_save_nmi(flags);
 	stat = &__get_cpu_var(ftrace_profile_stats);
 	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;
@@ -672,7 +672,7 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
 		rec->time += calltime;
 
  out:
-	local_irq_restore(flags);
+	local_irq_restore_nmi(flags);
 }
 
 static int register_ftrace_profiler(void)
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index b3f3776..cac3f8d 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -91,7 +91,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 	 * Need to use raw, since this must be called before the
 	 * recursive protection is performed.
 	 */
-	local_irq_save(flags);
+	local_irq_save_nmi(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
@@ -102,7 +102,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 	}
 
 	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
+	local_irq_restore_nmi(flags);
 }
 
 static void
@@ -122,7 +122,7 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
 	 * Need to use raw, since this must be called before the
 	 * recursive protection is performed.
 	 */
-	local_irq_save(flags);
+	local_irq_save_nmi(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
@@ -142,7 +142,7 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
 	}
 
 	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
+	local_irq_restore_nmi(flags);
 }
 
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 9aed1a5..84f92ef 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -221,7 +221,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	if (!(trace->depth || ftrace_graph_addr(trace->func)))
 		return 0;
 
-	local_irq_save(flags);
+	local_irq_save_nmi(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
@@ -233,7 +233,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	}
 
 	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
+	local_irq_restore_nmi(flags);
 
 	return ret;
 }
@@ -278,7 +278,7 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
 	int cpu;
 	int pc;
 
-	local_irq_save(flags);
+	local_irq_save_nmi(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
@@ -287,7 +287,7 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
 		__trace_graph_return(tr, trace, flags, pc);
 	}
 	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
+	local_irq_restore_nmi(flags);
 }
 
 void set_graph_array(struct trace_array *tr)
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 0271742..891d3a0 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -65,11 +65,11 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
 	if (unlikely(disabled != 1))
 		goto out;
 
-	local_irq_save(flags);
+	local_irq_save_nmi(flags);
 
 	trace_function(tr, ip, parent_ip, flags, pc);
 
-	local_irq_restore(flags);
+	local_irq_restore_nmi(flags);
 
  out:
 	atomic_dec(&data->disabled);
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index f4bc9b2..14fa61c 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -53,7 +53,7 @@ static inline void check_stack(void)
 	if (!object_is_on_stack(&this_size))
 		return;
 
-	local_irq_save(flags);
+	local_irq_save_nmi(flags);
 	arch_spin_lock(&max_stack_lock);
 
 	/* a race could have already updated it */
@@ -104,7 +104,7 @@ static inline void check_stack(void)
 
  out:
 	arch_spin_unlock(&max_stack_lock);
-	local_irq_restore(flags);
+	local_irq_restore_nmi(flags);
 }
 
 static void
-- 
1.7.0.4

