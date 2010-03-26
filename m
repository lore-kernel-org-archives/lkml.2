Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0CZCWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 22:22:25 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:64124 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab0CZCWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 22:22:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fNWZnbv0h0sbMRmuYWN9JFqwyfcUPDzkr+kBhuPEzfnIN6orQ0HqKxIq3J1XguZM4x
         q29W2godOIF5S+pT+farlrrXNVlU47QjxzJcO10KaR/uaZyKwTwoefTXlSSyCQ9ubdyx
         mWnzMOHYqSzV9/sfPNK2Ce6FoLmq7NtyPXvbg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] lockdep: Make lockstats counting per cpu
Date: Fri, 26 Mar 2010 03:22:22 +0100
Message-Id: <1269570142-13965-1-git-send-regression-fweisbec@gmail.com>
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
per cpu vars. We can't use irqsafe per cpu counters for that as
these stats might be also written from NMI path, and irqsafe per
cpu counters are not NMI safe, but local_t operations are.

This version then uses local_t based per cpu counters.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/lockdep.c           |   28 ++++++++--------
 kernel/lockdep_internals.h |   71 +++++++++++++++++++++++++++++++-------------
 2 files changed, 64 insertions(+), 35 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 65b5f5b..55e60a0 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -430,20 +430,20 @@ static struct stack_trace lockdep_init_trace = {
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
+DEFINE_PER_CPU(local_t, chain_lookup_hits);
+DEFINE_PER_CPU(local_t, chain_lookup_misses);
+DEFINE_PER_CPU(local_t, hardirqs_on_events);
+DEFINE_PER_CPU(local_t, hardirqs_off_events);
+DEFINE_PER_CPU(local_t, redundant_hardirqs_on);
+DEFINE_PER_CPU(local_t, redundant_hardirqs_off);
+DEFINE_PER_CPU(local_t, softirqs_on_events);
+DEFINE_PER_CPU(local_t, softirqs_off_events);
+DEFINE_PER_CPU(local_t, redundant_softirqs_on);
+DEFINE_PER_CPU(local_t, redundant_softirqs_off);
+DEFINE_PER_CPU(local_t, nr_unused_locks);
+DEFINE_PER_CPU(local_t, nr_cyclic_checks);
+DEFINE_PER_CPU(local_t, nr_find_usage_forwards_checks);
+DEFINE_PER_CPU(local_t, nr_find_usage_backwards_checks);
 #endif
 
 /*
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index a2ee95a..c4c54ee 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -110,29 +110,58 @@ lockdep_count_backward_deps(struct lock_class *class)
 #endif
 
 #ifdef CONFIG_DEBUG_LOCKDEP
+
+#include <asm/local.h>
+/*
+ * Various lockdep statistics.
+ * We want them per cpu as they are often accessed in fast path
+ * and we want to avoid too much cache bouncing.
+ * We can't use irqsafe per cpu counters as those are not NMI safe, as
+ * opposite to local_t.
+ */
+DECLARE_PER_CPU(local_t, chain_lookup_hits);
+DECLARE_PER_CPU(local_t, chain_lookup_misses);
+DECLARE_PER_CPU(local_t, hardirqs_on_events);
+DECLARE_PER_CPU(local_t, hardirqs_off_events);
+DECLARE_PER_CPU(local_t, redundant_hardirqs_on);
+DECLARE_PER_CPU(local_t, redundant_hardirqs_off);
+DECLARE_PER_CPU(local_t, softirqs_on_events);
+DECLARE_PER_CPU(local_t, softirqs_off_events);
+DECLARE_PER_CPU(local_t, redundant_softirqs_on);
+DECLARE_PER_CPU(local_t, redundant_softirqs_off);
+DECLARE_PER_CPU(local_t, nr_unused_locks);
+DECLARE_PER_CPU(local_t, nr_cyclic_checks);
+DECLARE_PER_CPU(local_t, nr_cyclic_check_recursions);
+DECLARE_PER_CPU(local_t, nr_find_usage_forwards_checks);
+DECLARE_PER_CPU(local_t, nr_find_usage_forwards_recursions);
+DECLARE_PER_CPU(local_t, nr_find_usage_backwards_checks);
+DECLARE_PER_CPU(local_t, nr_find_usage_backwards_recursions);
+
+# define debug_atomic_inc(ptr)			{	\
+	WARN_ON_ONCE(!irq_disabled());			\
+	local_t *__ptr = &__get_cpu_var(ptr);		\
+	local_inc(__ptr);				\
+}
+
+# define debug_atomic_dec(ptr)			{	\
+	WARN_ON_ONCE(!irq_disabled());			\
+	local_t *__ptr = &__get_cpu_var(ptr);		\
+	local_dec(__ptr);				\
+}
+
 /*
- * Various lockdep statistics:
+ * It's fine to use local_read from other cpus. Read is racy anyway,
+ * but it's guaranteed high and low parts are read atomically.
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
+# define debug_atomic_read(ptr)		({		\
+	unsigned long long __total = 0;			\
+	int __cpu;					\
+	for_each_possible_cpu(__cpu) {			\
+		local_t *__ptr = &__get_cpu_var(ptr);	\
+		__total += local_read(__ptr);		\
+	}						\
+	__total;					\
+})
 #else
 # define debug_atomic_inc(ptr)		do { } while (0)
 # define debug_atomic_dec(ptr)		do { } while (0)
-- 
1.6.2.3

