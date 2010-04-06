Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab0DFIcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 04:32:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:39335 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab0DFIc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 04:32:29 -0400
Date: Tue, 6 Apr 2010 08:32:04 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1270505417-8144-1-git-send-regression-fweisbec@gmail.com>
References: <1270505417-8144-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockstat: Make lockstat counting per cpu
Message-ID: <tip-bd6d29c25bb1a24a4c160ec5de43e0004e01f72b@git.kernel.org>
Git-Commit-ID: bd6d29c25bb1a24a4c160ec5de43e0004e01f72b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Apr 2010 08:32:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd6d29c25bb1a24a4c160ec5de43e0004e01f72b
Gitweb:     http://git.kernel.org/tip/bd6d29c25bb1a24a4c160ec5de43e0004e01f72b
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 6 Apr 2010 00:10:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Apr 2010 00:15:37 +0200

lockstat: Make lockstat counting per cpu

Locking statistics are implemented using global atomic
variables. This is usually fine unless some path write them very
often.

This is the case for the function and function graph tracers
that disable irqs for each entry saved (except if the function
tracer is in preempt disabled only mode).
And calls to local_irq_save/restore() increment
hardirqs_on_events and hardirqs_off_events stats (or similar
stats for redundant versions).

Incrementing these global vars for each function ends up in too
much cache bouncing if lockstats are enabled.

To solve this, implement the debug_atomic_*() operations using
per cpu vars.

 -v2: Use per_cpu() instead of get_cpu_var() to fetch the desired
      cpu vars on debug_atomic_read()

 -v3: Store the stats in a structure. No need for local_t as we
      are NMI/irq safe.

 -v4: Fix tons of build errors. I thought I had tested it but I
      probably forgot to select the relevant config.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1270505417-8144-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/lockdep.c           |   47 ++++++++++------------------
 kernel/lockdep_internals.h |   74 +++++++++++++++++++++++++++++++------------
 kernel/lockdep_proc.c      |   58 +++++++++++++++++-----------------
 3 files changed, 99 insertions(+), 80 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 0c30d04..069af02 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -430,20 +430,7 @@ static struct stack_trace lockdep_init_trace = {
 /*
  * Various lockdep statistics:
  */
-atomic_t chain_lookup_hits;
-atomic_t chain_lookup_misses;
-atomic_t hardirqs_on_events;
-atomic_t hardirqs_off_events;
-atomic_t redundant_hardirqs_on;
-atomic_t redundant_hardirqs_off;
-atomic_t softirqs_on_events;
-atomic_t softirqs_off_events;
-atomic_t redundant_softirqs_on;
-atomic_t redundant_softirqs_off;
-atomic_t nr_unused_locks;
-atomic_t nr_cyclic_checks;
-atomic_t nr_find_usage_forwards_checks;
-atomic_t nr_find_usage_backwards_checks;
+DEFINE_PER_CPU(struct lockdep_stats, lockdep_stats);
 #endif
 
 /*
@@ -758,7 +745,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 		return NULL;
 	}
 	class = lock_classes + nr_lock_classes++;
-	debug_atomic_inc(&nr_unused_locks);
+	debug_atomic_inc(nr_unused_locks);
 	class->key = key;
 	class->name = lock->name;
 	class->subclass = subclass;
@@ -1215,7 +1202,7 @@ check_noncircular(struct lock_list *root, struct lock_class *target,
 {
 	int result;
 
-	debug_atomic_inc(&nr_cyclic_checks);
+	debug_atomic_inc(nr_cyclic_checks);
 
 	result = __bfs_forwards(root, target, class_equal, target_entry);
 
@@ -1252,7 +1239,7 @@ find_usage_forwards(struct lock_list *root, enum lock_usage_bit bit,
 {
 	int result;
 
-	debug_atomic_inc(&nr_find_usage_forwards_checks);
+	debug_atomic_inc(nr_find_usage_forwards_checks);
 
 	result = __bfs_forwards(root, (void *)bit, usage_match, target_entry);
 
@@ -1275,7 +1262,7 @@ find_usage_backwards(struct lock_list *root, enum lock_usage_bit bit,
 {
 	int result;
 
-	debug_atomic_inc(&nr_find_usage_backwards_checks);
+	debug_atomic_inc(nr_find_usage_backwards_checks);
 
 	result = __bfs_backwards(root, (void *)bit, usage_match, target_entry);
 
@@ -1835,7 +1822,7 @@ static inline int lookup_chain_cache(struct task_struct *curr,
 	list_for_each_entry(chain, hash_head, entry) {
 		if (chain->chain_key == chain_key) {
 cache_hit:
-			debug_atomic_inc(&chain_lookup_hits);
+			debug_atomic_inc(chain_lookup_hits);
 			if (very_verbose(class))
 				printk("\nhash chain already cached, key: "
 					"%016Lx tail class: [%p] %s\n",
@@ -1900,7 +1887,7 @@ cache_hit:
 		chain_hlocks[chain->base + j] = class - lock_classes;
 	}
 	list_add_tail_rcu(&chain->entry, hash_head);
-	debug_atomic_inc(&chain_lookup_misses);
+	debug_atomic_inc(chain_lookup_misses);
 	inc_chains();
 
 	return 1;
@@ -2321,7 +2308,7 @@ void trace_hardirqs_on_caller(unsigned long ip)
 		return;
 
 	if (unlikely(curr->hardirqs_enabled)) {
-		debug_atomic_inc(&redundant_hardirqs_on);
+		debug_atomic_inc(redundant_hardirqs_on);
 		return;
 	}
 	/* we'll do an OFF -> ON transition: */
@@ -2348,7 +2335,7 @@ void trace_hardirqs_on_caller(unsigned long ip)
 
 	curr->hardirq_enable_ip = ip;
 	curr->hardirq_enable_event = ++curr->irq_events;
-	debug_atomic_inc(&hardirqs_on_events);
+	debug_atomic_inc(hardirqs_on_events);
 }
 EXPORT_SYMBOL(trace_hardirqs_on_caller);
 
@@ -2380,9 +2367,9 @@ void trace_hardirqs_off_caller(unsigned long ip)
 		curr->hardirqs_enabled = 0;
 		curr->hardirq_disable_ip = ip;
 		curr->hardirq_disable_event = ++curr->irq_events;
-		debug_atomic_inc(&hardirqs_off_events);
+		debug_atomic_inc(hardirqs_off_events);
 	} else
-		debug_atomic_inc(&redundant_hardirqs_off);
+		debug_atomic_inc(redundant_hardirqs_off);
 }
 EXPORT_SYMBOL(trace_hardirqs_off_caller);
 
@@ -2406,7 +2393,7 @@ void trace_softirqs_on(unsigned long ip)
 		return;
 
 	if (curr->softirqs_enabled) {
-		debug_atomic_inc(&redundant_softirqs_on);
+		debug_atomic_inc(redundant_softirqs_on);
 		return;
 	}
 
@@ -2416,7 +2403,7 @@ void trace_softirqs_on(unsigned long ip)
 	curr->softirqs_enabled = 1;
 	curr->softirq_enable_ip = ip;
 	curr->softirq_enable_event = ++curr->irq_events;
-	debug_atomic_inc(&softirqs_on_events);
+	debug_atomic_inc(softirqs_on_events);
 	/*
 	 * We are going to turn softirqs on, so set the
 	 * usage bit for all held locks, if hardirqs are
@@ -2446,10 +2433,10 @@ void trace_softirqs_off(unsigned long ip)
 		curr->softirqs_enabled = 0;
 		curr->softirq_disable_ip = ip;
 		curr->softirq_disable_event = ++curr->irq_events;
-		debug_atomic_inc(&softirqs_off_events);
+		debug_atomic_inc(softirqs_off_events);
 		DEBUG_LOCKS_WARN_ON(!softirq_count());
 	} else
-		debug_atomic_inc(&redundant_softirqs_off);
+		debug_atomic_inc(redundant_softirqs_off);
 }
 
 static void __lockdep_trace_alloc(gfp_t gfp_mask, unsigned long flags)
@@ -2654,7 +2641,7 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 			return 0;
 		break;
 	case LOCK_USED:
-		debug_atomic_dec(&nr_unused_locks);
+		debug_atomic_dec(nr_unused_locks);
 		break;
 	default:
 		if (!debug_locks_off_graph_unlock())
@@ -2760,7 +2747,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		if (!class)
 			return 0;
 	}
-	debug_atomic_inc((atomic_t *)&class->ops);
+	atomic_inc((atomic_t *)&class->ops);
 	if (very_verbose(class)) {
 		printk("\nacquire class [%p] %s", class->key, class->name);
 		if (class->name_version > 1)
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index a2ee95a..8d7d4b6 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -110,29 +110,61 @@ lockdep_count_backward_deps(struct lock_class *class)
 #endif
 
 #ifdef CONFIG_DEBUG_LOCKDEP
+
+#include <asm/local.h>
 /*
- * Various lockdep statistics:
+ * Various lockdep statistics.
+ * We want them per cpu as they are often accessed in fast path
+ * and we want to avoid too much cache bouncing.
  */
-extern atomic_t chain_lookup_hits;
-extern atomic_t chain_lookup_misses;
-extern atomic_t hardirqs_on_events;
-extern atomic_t hardirqs_off_events;
-extern atomic_t redundant_hardirqs_on;
-extern atomic_t redundant_hardirqs_off;
-extern atomic_t softirqs_on_events;
-extern atomic_t softirqs_off_events;
-extern atomic_t redundant_softirqs_on;
-extern atomic_t redundant_softirqs_off;
-extern atomic_t nr_unused_locks;
-extern atomic_t nr_cyclic_checks;
-extern atomic_t nr_cyclic_check_recursions;
-extern atomic_t nr_find_usage_forwards_checks;
-extern atomic_t nr_find_usage_forwards_recursions;
-extern atomic_t nr_find_usage_backwards_checks;
-extern atomic_t nr_find_usage_backwards_recursions;
-# define debug_atomic_inc(ptr)		atomic_inc(ptr)
-# define debug_atomic_dec(ptr)		atomic_dec(ptr)
-# define debug_atomic_read(ptr)		atomic_read(ptr)
+struct lockdep_stats {
+	int	chain_lookup_hits;
+	int	chain_lookup_misses;
+	int	hardirqs_on_events;
+	int	hardirqs_off_events;
+	int	redundant_hardirqs_on;
+	int	redundant_hardirqs_off;
+	int	softirqs_on_events;
+	int	softirqs_off_events;
+	int	redundant_softirqs_on;
+	int	redundant_softirqs_off;
+	int	nr_unused_locks;
+	int	nr_cyclic_checks;
+	int	nr_cyclic_check_recursions;
+	int	nr_find_usage_forwards_checks;
+	int	nr_find_usage_forwards_recursions;
+	int	nr_find_usage_backwards_checks;
+	int	nr_find_usage_backwards_recursions;
+};
+
+DECLARE_PER_CPU(struct lockdep_stats, lockdep_stats);
+
+#define debug_atomic_inc(ptr)			{		\
+	struct lockdep_stats *__cpu_lockdep_stats;		\
+								\
+	WARN_ON_ONCE(!irqs_disabled());				\
+	__cpu_lockdep_stats = &__get_cpu_var(lockdep_stats);	\
+	__cpu_lockdep_stats->ptr++;				\
+}
+
+#define debug_atomic_dec(ptr)			{		\
+	struct lockdep_stats *__cpu_lockdep_stats;		\
+								\
+	WARN_ON_ONCE(!irqs_disabled());				\
+	__cpu_lockdep_stats = &__get_cpu_var(lockdep_stats);	\
+	__cpu_lockdep_stats->ptr--;				\
+}
+
+#define debug_atomic_read(ptr)		({				\
+	struct lockdep_stats *__cpu_lockdep_stats;			\
+	unsigned long long __total = 0;					\
+	int __cpu;							\
+	for_each_possible_cpu(__cpu) {					\
+		__cpu_lockdep_stats = &per_cpu(lockdep_stats, __cpu);	\
+		__total += __cpu_lockdep_stats->ptr;			\
+	}								\
+	__total;							\
+})
 #else
 # define debug_atomic_inc(ptr)		do { } while (0)
 # define debug_atomic_dec(ptr)		do { } while (0)
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index d4aba4f..59b76c8 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -184,34 +184,34 @@ static const struct file_operations proc_lockdep_chains_operations = {
 static void lockdep_stats_debug_show(struct seq_file *m)
 {
 #ifdef CONFIG_DEBUG_LOCKDEP
-	unsigned int hi1 = debug_atomic_read(&hardirqs_on_events),
-		     hi2 = debug_atomic_read(&hardirqs_off_events),
-		     hr1 = debug_atomic_read(&redundant_hardirqs_on),
-		     hr2 = debug_atomic_read(&redundant_hardirqs_off),
-		     si1 = debug_atomic_read(&softirqs_on_events),
-		     si2 = debug_atomic_read(&softirqs_off_events),
-		     sr1 = debug_atomic_read(&redundant_softirqs_on),
-		     sr2 = debug_atomic_read(&redundant_softirqs_off);
-
-	seq_printf(m, " chain lookup misses:           %11u\n",
-		debug_atomic_read(&chain_lookup_misses));
-	seq_printf(m, " chain lookup hits:             %11u\n",
-		debug_atomic_read(&chain_lookup_hits));
-	seq_printf(m, " cyclic checks:                 %11u\n",
-		debug_atomic_read(&nr_cyclic_checks));
-	seq_printf(m, " find-mask forwards checks:     %11u\n",
-		debug_atomic_read(&nr_find_usage_forwards_checks));
-	seq_printf(m, " find-mask backwards checks:    %11u\n",
-		debug_atomic_read(&nr_find_usage_backwards_checks));
-
-	seq_printf(m, " hardirq on events:             %11u\n", hi1);
-	seq_printf(m, " hardirq off events:            %11u\n", hi2);
-	seq_printf(m, " redundant hardirq ons:         %11u\n", hr1);
-	seq_printf(m, " redundant hardirq offs:        %11u\n", hr2);
-	seq_printf(m, " softirq on events:             %11u\n", si1);
-	seq_printf(m, " softirq off events:            %11u\n", si2);
-	seq_printf(m, " redundant softirq ons:         %11u\n", sr1);
-	seq_printf(m, " redundant softirq offs:        %11u\n", sr2);
+	unsigned long long hi1 = debug_atomic_read(hardirqs_on_events),
+			   hi2 = debug_atomic_read(hardirqs_off_events),
+			   hr1 = debug_atomic_read(redundant_hardirqs_on),
+			   hr2 = debug_atomic_read(redundant_hardirqs_off),
+			   si1 = debug_atomic_read(softirqs_on_events),
+			   si2 = debug_atomic_read(softirqs_off_events),
+			   sr1 = debug_atomic_read(redundant_softirqs_on),
+			   sr2 = debug_atomic_read(redundant_softirqs_off);
+
+	seq_printf(m, " chain lookup misses:           %11llu\n",
+		debug_atomic_read(chain_lookup_misses));
+	seq_printf(m, " chain lookup hits:             %11llu\n",
+		debug_atomic_read(chain_lookup_hits));
+	seq_printf(m, " cyclic checks:                 %11llu\n",
+		debug_atomic_read(nr_cyclic_checks));
+	seq_printf(m, " find-mask forwards checks:     %11llu\n",
+		debug_atomic_read(nr_find_usage_forwards_checks));
+	seq_printf(m, " find-mask backwards checks:    %11llu\n",
+		debug_atomic_read(nr_find_usage_backwards_checks));
+
+	seq_printf(m, " hardirq on events:             %11llu\n", hi1);
+	seq_printf(m, " hardirq off events:            %11llu\n", hi2);
+	seq_printf(m, " redundant hardirq ons:         %11llu\n", hr1);
+	seq_printf(m, " redundant hardirq offs:        %11llu\n", hr2);
+	seq_printf(m, " softirq on events:             %11llu\n", si1);
+	seq_printf(m, " softirq off events:            %11llu\n", si2);
+	seq_printf(m, " redundant softirq ons:         %11llu\n", sr1);
+	seq_printf(m, " redundant softirq offs:        %11llu\n", sr2);
 #endif
 }
 
@@ -263,7 +263,7 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 #endif
 	}
 #ifdef CONFIG_DEBUG_LOCKDEP
-	DEBUG_LOCKS_WARN_ON(debug_atomic_read(&nr_unused_locks) != nr_unused);
+	DEBUG_LOCKS_WARN_ON(debug_atomic_read(nr_unused_locks) != nr_unused);
 #endif
 	seq_printf(m, " lock-classes:                  %11lu [max: %lu]\n",
 			nr_lock_classes, MAX_LOCKDEP_KEYS);
