Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab2BATnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:43:33 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54408 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131Ab2BATnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:43:25 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 34/41] rcu: Check for illegal use of RCU from offlined CPUs
Date: Wed,  1 Feb 2012 11:41:52 -0800
Message-Id: <1328125319-5205-34-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-5806-0000-0000-000011F2FE81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Although it is legal to use RCU during early boot, it is anything
but legal to use RCU at runtime from an offlined CPU.  After all, RCU
explicitly ignores offlined CPUs.  This commit therefore adds checks
for runtime use of RCU from offlined CPUs.

These checks are not perfect, in particular, they can be subverted
through use of things like rcu_dereference_raw().  Note that it is not
possible to put checks in rcu_read_lock() and friends due to the fact
that these primitives are used in code that might be used under either
RCU or lock-based protection, which means that checking rcu_read_lock()
gets you fat piles of false positives.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   19 +++++++++++++++++++
 include/linux/srcu.h     |   11 +++++++----
 kernel/rcupdate.c        |    5 +++++
 kernel/rcutree.c         |   29 +++++++++++++++++++++++++++++
 kernel/rcutree_plugin.h  |    1 +
 5 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index f409529..146d37d 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -226,6 +226,15 @@ static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
 }
 #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
+#if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU)
+bool rcu_lockdep_current_cpu_online(void);
+#else /* #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU) */
+static inline bool rcu_lockdep_current_cpu_online(void)
+{
+	return 1;
+}
+#endif /* #else #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU) */
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 #ifdef CONFIG_PROVE_RCU
@@ -270,6 +279,9 @@ extern int debug_lockdep_rcu_enabled(void);
  * occur in the same context, for example, it is illegal to invoke
  * rcu_read_unlock() in process context if the matching rcu_read_lock()
  * was invoked from within an irq handler.
+ *
+ * Note that rcu_read_lock() is disallowed if the CPU is either idle or
+ * offline from an RCU perspective, so check for those as well.
  */
 static inline int rcu_read_lock_held(void)
 {
@@ -277,6 +289,8 @@ static inline int rcu_read_lock_held(void)
 		return 1;
 	if (rcu_is_cpu_idle())
 		return 0;
+	if (!rcu_lockdep_current_cpu_online())
+		return 0;
 	return lock_is_held(&rcu_lock_map);
 }
 
@@ -313,6 +327,9 @@ extern int rcu_read_lock_bh_held(void);
  * notice an extended quiescent state to other CPUs that started a grace
  * period. Otherwise we would delay any grace period as long as we run in
  * the idle task.
+ *
+ * Similarly, we avoid claiming an SRCU read lock held if the current
+ * CPU is offline.
  */
 #ifdef CONFIG_PREEMPT_COUNT
 static inline int rcu_read_lock_sched_held(void)
@@ -323,6 +340,8 @@ static inline int rcu_read_lock_sched_held(void)
 		return 1;
 	if (rcu_is_cpu_idle())
 		return 0;
+	if (!rcu_lockdep_current_cpu_online())
+		return 0;
 	if (debug_locks)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
 	return lockdep_opinion || preempt_count() != 0 || irqs_disabled();
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index e1b0059..9a32372 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -99,15 +99,18 @@ long srcu_batches_completed(struct srcu_struct *sp);
  * power mode. This way we can notice an extended quiescent state to
  * other CPUs that started a grace period. Otherwise we would delay any
  * grace period as long as we run in the idle task.
+ *
+ * Similarly, we avoid claiming an SRCU read lock held if the current
+ * CPU is offline.
  */
 static inline int srcu_read_lock_held(struct srcu_struct *sp)
 {
-	if (rcu_is_cpu_idle())
-		return 0;
-
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
-
+	if (rcu_is_cpu_idle())
+		return 0;
+	if (!rcu_lockdep_current_cpu_online())
+		return 0;
 	return lock_is_held(&sp->dep_map);
 }
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 2bc4e13..a86f174 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -88,6 +88,9 @@ EXPORT_SYMBOL_GPL(debug_lockdep_rcu_enabled);
  * section.
  *
  * Check debug_lockdep_rcu_enabled() to prevent false positives during boot.
+ *
+ * Note that rcu_read_lock() is disallowed if the CPU is either idle or
+ * offline from an RCU perspective, so check for those as well.
  */
 int rcu_read_lock_bh_held(void)
 {
@@ -95,6 +98,8 @@ int rcu_read_lock_bh_held(void)
 		return 1;
 	if (rcu_is_cpu_idle())
 		return 0;
+	if (!rcu_lockdep_current_cpu_online())
+		return 0;
 	return in_softirq() || irqs_disabled();
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d2c770b..243ceb1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -594,6 +594,35 @@ int rcu_is_cpu_idle(void)
 }
 EXPORT_SYMBOL(rcu_is_cpu_idle);
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Is the current CPU online?  Disable preemption to avoid false positives
+ * that could otherwise happen due to the current CPU number being sampled,
+ * this task being preempted, its old CPU being taken offline, resuming
+ * on some other CPU, then determining that its old CPU is now offline.
+ * It is OK to use RCU on an offline processor during initial boot, hence
+ * the check for rcu_scheduler_fully_active.
+ *
+ * Disable checking if in an NMI handler because we cannot safely report
+ * errors from NMI handlers anyway.
+ */
+bool rcu_lockdep_current_cpu_online(void)
+{
+	bool ret;
+
+	if (in_nmi())
+		return 1;
+	preempt_disable();
+	ret = cpu_online(smp_processor_id()) ||
+	      !rcu_scheduler_fully_active;
+	preempt_enable();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rcu_lockdep_current_cpu_online);
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
 #endif /* #ifdef CONFIG_PROVE_RCU */
 
 /**
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index a56fa20..255ef887 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1945,6 +1945,7 @@ void synchronize_sched_expedited(void)
 	/* Note that atomic_inc_return() implies full memory barrier. */
 	firstsnap = snap = atomic_inc_return(&sync_sched_expedited_started);
 	get_online_cpus();
+	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
 
 	/*
 	 * Each pass through the following loop attempts to force a
-- 
1.7.8

