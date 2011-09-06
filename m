Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1IGGYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:24:52 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38192 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab1IGGVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:03 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH tip/core/rcu 49/55] rcu: Detect illegal rcu dereference in extended quiescent state
Date: Tue,  6 Sep 2011 11:00:43 -0700
Message-Id: <1315332049-2604-49-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Report that none of the rcu read lock maps are held while in an RCU
extended quiescent state (in this case, the RCU extended quiescent state
is dyntick-idle mode). This helps detect any use of rcu_dereference()
and friends from within dyntick-idle mode.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   36 ++++++++++++++++++++++++++++++++++++
 kernel/rcupdate.c        |   17 ++++++++++++++++-
 kernel/rcutiny.c         |   14 ++++++++++++++
 kernel/rcutree.c         |   16 ++++++++++++++++
 4 files changed, 82 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 8d7efc8..7d8fa7c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -231,6 +231,14 @@ static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
 }
 #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
+
+#if defined(CONFIG_PROVE_RCU) && defined(CONFIG_NO_HZ)
+extern bool rcu_check_extended_qs(void);
+#else
+static inline bool rcu_check_extended_qs(void) { return false; }
+#endif
+
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 #define PROVE_RCU(a) a
@@ -264,11 +272,25 @@ extern int debug_lockdep_rcu_enabled(void);
  *
  * Checks debug_lockdep_rcu_enabled() to prevent false positives during boot
  * and while lockdep is disabled.
+ *
+ * Note that if the CPU is in an extended quiescent state, for example,
+ * if the CPU is in dyntick-idle mode, then rcu_read_lock_held() returns
+ * false even if the CPU did an rcu_read_lock().  The reason for this is
+ * that RCU ignores CPUs that are in extended quiescent states, so such
+ * a CPU is effectively never in an RCU read-side critical section
+ * regardless of what RCU primitives it invokes.  This state of affairs
+ * is required -- RCU would otherwise need to periodically wake up
+ * dyntick-idle CPUs, which would defeat the whole purpose of dyntick-idle
+ * mode.
  */
 static inline int rcu_read_lock_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
+
+	if (rcu_check_extended_qs())
+		return 0;
+
 	return lock_is_held(&rcu_lock_map);
 }
 
@@ -292,6 +314,16 @@ extern int rcu_read_lock_bh_held(void);
  *
  * Check debug_lockdep_rcu_enabled() to prevent false positives during boot
  * and while lockdep is disabled.
+ *
+ * Note that if the CPU is in an extended quiescent state, for example,
+ * if the CPU is in dyntick-idle mode, then rcu_read_lock_held() returns
+ * false even if the CPU did an rcu_read_lock().  The reason for this is
+ * that RCU ignores CPUs that are in extended quiescent states, so such
+ * a CPU is effectively never in an RCU read-side critical section
+ * regardless of what RCU primitives it invokes.  This state of affairs
+ * is required -- RCU would otherwise need to periodically wake up
+ * dyntick-idle CPUs, which would defeat the whole purpose of dyntick-idle
+ * mode.
  */
 #ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
@@ -300,6 +332,10 @@ static inline int rcu_read_lock_sched_held(void)
 
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
+
+	if (rcu_check_extended_qs())
+		return 0;
+
 	if (debug_locks)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
 	return lockdep_opinion || preempt_count() != 0 || irqs_disabled();
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 5031caf..e4d8a98 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -87,12 +87,27 @@ EXPORT_SYMBOL_GPL(debug_lockdep_rcu_enabled);
  * that require that they be called within an RCU read-side critical
  * section.
  *
- * Check debug_lockdep_rcu_enabled() to prevent false positives during boot.
+ * Check debug_lockdep_rcu_enabled() to prevent false positives during boot
+ * and while lockdep is disabled.
+ *
+ * Note that if the CPU is in an extended quiescent state, for example,
+ * if the CPU is in dyntick-idle mode, then rcu_read_lock_held() returns
+ * false even if the CPU did an rcu_read_lock().  The reason for this is
+ * that RCU ignores CPUs that are in extended quiescent states, so such
+ * a CPU is effectively never in an RCU read-side critical section
+ * regardless of what RCU primitives it invokes.  This state of affairs
+ * is required -- RCU would otherwise need to periodically wake up
+ * dyntick-idle CPUs, which would defeat the whole purpose of dyntick-idle
+ * mode.
  */
 int rcu_read_lock_bh_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
+
+	if (rcu_check_extended_qs())
+		return 0;
+
 	return in_softirq() || irqs_disabled();
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index da775c8..9e493b9 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -78,6 +78,20 @@ void rcu_exit_nohz(void)
 	rcu_dynticks_nesting++;
 }
 
+
+#ifdef CONFIG_PROVE_RCU
+
+bool rcu_check_extended_qs(void)
+{
+	if (!rcu_dynticks_nesting)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(rcu_check_extended_qs);
+
+#endif
+
 #endif /* #ifdef CONFIG_NO_HZ */
 
 /*
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f0a9432..c9b4adf 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -465,6 +465,22 @@ void rcu_irq_exit(void)
 	rcu_enter_nohz();
 }
 
+#ifdef CONFIG_PROVE_RCU
+
+bool rcu_check_extended_qs(void)
+{
+	struct rcu_dynticks *rdtp;
+
+	rdtp = &per_cpu(rcu_dynticks, raw_smp_processor_id());
+	if (atomic_read(&rdtp->dynticks) & 0x1)
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(rcu_check_extended_qs);
+
+#endif /* CONFIG_PROVE_RCU */
+
 #ifdef CONFIG_SMP
 
 /*
-- 
1.7.3.2

