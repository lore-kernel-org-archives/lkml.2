Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab0C1A36 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 20:29:58 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44857 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab0C1A35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 20:29:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=S+idlitwnL8N2WhMbeID5k2qOG2KDdem2TYmTcNJmWWdX3roV4H2lGUmH6yRnHBVZ1
         Hqjk2oQ9wmu5PrhrC2AyPaZzCJSuq3UVYY4id6d/+M5UjM2XZ3HoDnZesFX8TU0uwJK0
         v61ToWEjPGNJkA2WyFiN7iPDVcJa+ZcnxYrCA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v3] lockdep: Make lockstats counting per cpu
Date: Sun, 28 Mar 2010 01:29:57 +0100
Message-Id: <1269736197-10958-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Locking statistics are implemented using global atomic variables.
This is usually fine unless some path write them very often.

This is the case for the function and function graph tracers
that disable irqs for each entry saved (except if the function
tracer is in preempt disabled only mode).
And calls to local_irq_save/restore() increment hardirqs_on_events
and hardirqs_off_events stats (or similar stats for redundant
versions).

Incrementing these global vars for each function ends up in too
much cache bouncing if lockstats are enabled.

To solve this, implement the debug_atomic_*() operations using
per cpu vars.

v2: Use per_cpu() instead of get_cpu_var() to fetch the desired
cpu vars on debug_atomic_read()

v3: Store the stats in a structure. No need for local_t as we
are NMI/irq safe.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/lockdep.c           |   15 +--------
 kernel/lockdep_internals.h |   74 +++++++++++++++++++++++++++++++------------
 2 files changed, 54 insertions(+), 35 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 65b5f5b..3434c81 100644
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
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index a2ee95a..ccc18f6 100644
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
+	int	nr_cyclic_checks
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
+	WARN_ON_ONCE(!irq_disabled());				\
+	__cpu_lockdep_stats = &__get_cpu_var(lockdep_stats);	\
+	__cpu_lockdep_stats->ptr++;				\
+}
+
+#define debug_atomic_dec(ptr)			{		\
+	struct lockdep_stats *__cpu_lockdep_stats;		\
+								\
+	WARN_ON_ONCE(!irq_disabled());				\
+	__cpu_lockdep_stats = &__get_cpu_var(lockdep_stats);	\
+	__cpu_lockdep_stats->ptr--;				\
+}
+
+#define debug_atomic_read(ptr)		({				\
+	struct lockdep_stats *__cpu_lockdep_stats;			\
+	unsigned long long __total = 0;					\
+	int __cpu;							\
+	for_each_possible_cpu(__cpu) {					\
+		__cpu_lockdep_stats = &per_cpu(lockdep_stats, cpu);	\
+		__total += __cpu_lockdep_stats->ptr;			\
+	}								\
+	__total;							\
+})
 #else
 # define debug_atomic_inc(ptr)		do { } while (0)
 # define debug_atomic_dec(ptr)		do { } while (0)
-- 
1.6.2.3

