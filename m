Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab1KBUcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:32:09 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33376 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab1KBUcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:32:05 -0400
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
Subject: [PATCH RFC tip/core/rcu 12/28] rcu: Detect illegal rcu dereference in extended quiescent state
Date: Wed,  2 Nov 2011 13:30:33 -0700
Message-Id: <1320265849-5744-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-9360-0000-0000-00000045A4EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

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
 include/linux/rcupdate.h |   26 ++++++++++++++++++++++++++
 kernel/rcupdate.c        |    2 ++
 kernel/rcutiny.c         |    1 +
 kernel/rcutree.c         |    1 +
 4 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 8d315b0..bf91fcf 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -228,6 +228,15 @@ static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
 
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
@@ -262,6 +271,8 @@ static inline int rcu_read_lock_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
+	if (rcu_is_cpu_idle())
+		return 0;
 	return lock_is_held(&rcu_lock_map);
 }
 
@@ -285,6 +296,19 @@ extern int rcu_read_lock_bh_held(void);
  *
  * Check debug_lockdep_rcu_enabled() to prevent false positives during boot
  * and while lockdep is disabled.
+ *
+ * Note that if the CPU is in the idle loop from an RCU point of
+ * view (ie: that we are in the section between rcu_idle_enter() and
+ * rcu_idle_exit()) then rcu_read_lock_held() returns false even if the CPU
+ * did an rcu_read_lock().  The reason for this is that RCU ignores CPUs
+ * that are in such a section, considering these as in extended quiescent
+ * state, so such a CPU is effectively never in an RCU read-side critical
+ * section regardless of what RCU primitives it invokes.  This state of
+ * affairs is required --- we need to keep an RCU-free window in idle
+ * where the CPU may possibly enter into low power mode. This way we can
+ * notice an extended quiescent state to other CPUs that started a grace
+ * period. Otherwise we would delay any grace period as long as we run in
+ * the idle task.
  */
 #ifdef CONFIG_PREEMPT_COUNT
 static inline int rcu_read_lock_sched_held(void)
@@ -293,6 +317,8 @@ static inline int rcu_read_lock_sched_held(void)
 
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
+	if (rcu_is_cpu_idle())
+		return 0;
 	if (debug_locks)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
 	return lockdep_opinion || preempt_count() != 0 || irqs_disabled();
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 34a02da..05633da 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -93,6 +93,8 @@ int rcu_read_lock_bh_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
+	if (rcu_is_cpu_idle())
+		return 0;
 	return in_softirq() || irqs_disabled();
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 6b0ace4..089820d 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -158,6 +158,7 @@ int rcu_is_cpu_idle(void)
 {
 	return !rcu_dynticks_nesting;
 }
+EXPORT_SYMBOL(rcu_is_cpu_idle);
 
 #endif /* #ifdef CONFIG_PROVE_RCU */
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index bbcafba..28f8f92 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -567,6 +567,7 @@ int rcu_is_cpu_idle(void)
 	preempt_enable();
 	return ret;
 }
+EXPORT_SYMBOL(rcu_is_cpu_idle);
 
 #endif /* #ifdef CONFIG_PROVE_RCU */
 
-- 
1.7.3.2

