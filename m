Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab1JGQWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:22:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50139 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab1JGQWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:22:24 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 01/11] rcu: Detect illegal rcu dereference in extended quiescent state
Date: Fri,  7 Oct 2011 18:22:00 +0200
Message-Id: <1318004530-705-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318004530-705-1-git-send-email-fweisbec@gmail.com>
References: <1318004530-705-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report that none of the rcu read lock maps are held while in an RCU
extended quiescent state (the section between rcu_idle_enter()
and rcu_idle_exit()). This helps detect any use of rcu_dereference()
and friends from within the section in idle where RCU is not allowed.

This way we can guarantee an extended quiescent window where the CPU
can be put in dyntick idle mode or can simply aoid to be part of any
global grace period completion while in the idle loop.

Uses of RCU from such mode are totally ignored by RCU, hence the
importance of these checks.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   29 +++++++++++++++++++++++++++++
 kernel/rcupdate.c        |    4 ++++
 kernel/rcutiny.c         |    1 +
 kernel/rcutree.c         |   19 ++++++++++++++++---
 4 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index a90a850..2f8e0a4 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -218,6 +218,15 @@ static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
+#ifdef CONFIG_PROVE_RCU
+extern int rcu_is_cpu_idle(void);
+#else /* !CONFIG_PROVE_RCU */
+static inline int rcu_is_cpu_idle(void)
+{
+	return 0;
+}
+#endif /* else !CONFIG_PROVE_RCU */
+
 extern struct lockdep_map rcu_lock_map;
 # define rcu_read_acquire() \
 		lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
@@ -252,6 +261,10 @@ static inline int rcu_read_lock_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
+
+	if (rcu_is_cpu_idle())
+		return 0;
+
 	return lock_is_held(&rcu_lock_map);
 }
 
@@ -275,6 +288,18 @@ extern int rcu_read_lock_bh_held(void);
  *
  * Check debug_lockdep_rcu_enabled() to prevent false positives during boot
  * and while lockdep is disabled.
+ *
+ * Note that if the CPU is in the idle loop from an RCU point of view
+ * (ie: that we are in the section between rcu_idle_enter() and rcu_idle_exit())
+ * then rcu_read_lock_held() returns false even if the CPU did an rcu_read_lock().
+ * The reason for this is that RCU ignores CPUs that are in such a section,
+ * considering these as in extended quiescent state, so such a CPU is effectively
+ * never in an RCU read-side critical section regardless of what RCU primitives it
+ * invokes.  This state of affairs is required --- we need to keep an RCU-free
+ * window in idle where the CPU may possibly enter into low power mode. This way
+ * we can notice an extended quiescent state to other CPUs that started a grace
+ * period. Otherwise we would delay any grace period as long as we run in the
+ * idle task.
  */
 #ifdef CONFIG_PREEMPT_COUNT
 static inline int rcu_read_lock_sched_held(void)
@@ -283,6 +308,10 @@ static inline int rcu_read_lock_sched_held(void)
 
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
+
+	if (rcu_is_cpu_idle())
+		return 0;
+
 	if (debug_locks)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
 	return lockdep_opinion || preempt_count() != 0 || irqs_disabled();
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index ca0d23b..d348e3a 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -93,6 +93,10 @@ int rcu_read_lock_bh_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
+
+	if (rcu_is_cpu_idle())
+		return 0;
+
 	return in_softirq() || irqs_disabled();
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 124bd38..1f75d53 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -83,6 +83,7 @@ int rcu_is_cpu_idle(void)
 {
 	return !rcu_dynticks_nesting;
 }
+EXPORT_SYMBOL(rcu_is_cpu_idle);
 
 #endif /* #ifdef CONFIG_PROVE_RCU */
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6279479..ed6371c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -444,13 +444,26 @@ void rcu_nmi_exit(void)
  * rcu_is_cpu_idle - see if RCU thinks that the current CPU is idle
  *
  * If the current CPU is in its idle loop and is neither in an interrupt
- * or NMI handler, return true.  The caller must have at least disabled
- * preemption.
+ * or NMI handler, return true.
  */
 int rcu_is_cpu_idle(void)
 {
-	return (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
+	/*
+	 * Disable preemption so that we can call it outside the idle task.
+	 * This way we can check if we missed a call to rcu_idle_exit() before
+	 * exiting idle.
+	 */
+	struct rcu_dynticks *rdtp = &get_cpu_var(rcu_dynticks);
+	int idle = 0;
+
+	if ((atomic_read(&rdtp->dynticks) & 0x1) == 0)
+		idle = 1;
+
+	put_cpu_var(rcu_dynticks);
+
+	return idle;
 }
+EXPORT_SYMBOL(rcu_is_cpu_idle);
 
 #endif /* #ifdef CONFIG_PROVE_RCU */
 
-- 
1.7.5.4

