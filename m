Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab0KGCGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 22:06:20 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36915 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab0KGCFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 22:05:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 08/12] rcu,cleanup: move synchronize_sched_expedited() out of sched.c
Date: Sat,  6 Nov 2010 19:05:28 -0700
Message-Id: <1289095532-5398-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20101107020507.GA4974@linux.vnet.ibm.com>
References: <20101107020507.GA4974@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The first version of synchronize_sched_expedited() used the migration
code in the scheduler, and was therefore implemented in kernel/sched.c.
However, the more recent version of this code no longer uses the
migration code, so this commit moves it to the main RCU source files.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    1 -
 include/linux/rcutiny.h  |    5 +++
 include/linux/rcutree.h  |    1 +
 kernel/rcutree_plugin.h  |   71 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched.c           |   69 --------------------------------------------
 5 files changed, 77 insertions(+), 70 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 7142ee3..49e8e16 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -66,7 +66,6 @@ extern void call_rcu_sched(struct rcu_head *head,
 extern void synchronize_sched(void);
 extern void rcu_barrier_bh(void);
 extern void rcu_barrier_sched(void);
-extern void synchronize_sched_expedited(void);
 extern int sched_expedited_torture_stats(char *page);
 
 static inline void __rcu_read_lock_bh(void)
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index ea025a6..30ebd7c 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -60,6 +60,11 @@ static inline void synchronize_rcu_bh_expedited(void)
 	synchronize_sched();
 }
 
+static inline void synchronize_sched_expedited(void)
+{
+	synchronize_sched();
+}
+
 #ifdef CONFIG_TINY_RCU
 
 static inline void rcu_preempt_note_context_switch(void)
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index c0e9683..3a93348 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -48,6 +48,7 @@ static inline void exit_rcu(void)
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 extern void synchronize_rcu_bh(void);
+extern void synchronize_sched_expedited(void);
 extern void synchronize_rcu_expedited(void);
 
 static inline void synchronize_rcu_bh_expedited(void)
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 71a4147..21df7f3 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -25,6 +25,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/stop_machine.h>
 
 /*
  * Check the RCU kernel configuration parameters and print informative
@@ -1014,6 +1015,76 @@ static void __init __rcu_init_preempt(void)
 
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
+#ifndef CONFIG_SMP
+
+void synchronize_sched_expedited(void)
+{
+	cond_resched();
+}
+EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
+
+#else /* #ifndef CONFIG_SMP */
+
+static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
+
+static int synchronize_sched_expedited_cpu_stop(void *data)
+{
+	/*
+	 * There must be a full memory barrier on each affected CPU
+	 * between the time that try_stop_cpus() is called and the
+	 * time that it returns.
+	 *
+	 * In the current initial implementation of cpu_stop, the
+	 * above condition is already met when the control reaches
+	 * this point and the following smp_mb() is not strictly
+	 * necessary.  Do smp_mb() anyway for documentation and
+	 * robustness against future implementation changes.
+	 */
+	smp_mb(); /* See above comment block. */
+	return 0;
+}
+
+/*
+ * Wait for an rcu-sched grace period to elapse, but use "big hammer"
+ * approach to force grace period to end quickly.  This consumes
+ * significant time on all CPUs, and is thus not recommended for
+ * any sort of common-case code.
+ *
+ * Note that it is illegal to call this function while holding any
+ * lock that is acquired by a CPU-hotplug notifier.  Failing to
+ * observe this restriction will result in deadlock.
+ */
+void synchronize_sched_expedited(void)
+{
+	int snap, trycount = 0;
+
+	smp_mb();  /* ensure prior mod happens before capturing snap. */
+	snap = atomic_read(&synchronize_sched_expedited_count) + 1;
+	get_online_cpus();
+	while (try_stop_cpus(cpu_online_mask,
+			     synchronize_sched_expedited_cpu_stop,
+			     NULL) == -EAGAIN) {
+		put_online_cpus();
+		if (trycount++ < 10)
+			udelay(trycount * num_online_cpus());
+		else {
+			synchronize_sched();
+			return;
+		}
+		if (atomic_read(&synchronize_sched_expedited_count) - snap > 0) {
+			smp_mb(); /* ensure test happens before caller kfree */
+			return;
+		}
+		get_online_cpus();
+	}
+	atomic_inc(&synchronize_sched_expedited_count);
+	smp_mb__after_atomic_inc(); /* ensure post-GP actions seen after GP. */
+	put_online_cpus();
+}
+EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
+
+#endif /* #else #ifndef CONFIG_SMP */
+
 #if !defined(CONFIG_RCU_FAST_NO_HZ)
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index ae8f75a..d1e8889 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9131,72 +9131,3 @@ struct cgroup_subsys cpuacct_subsys = {
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
 
-#ifndef CONFIG_SMP
-
-void synchronize_sched_expedited(void)
-{
-	barrier();
-}
-EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
-
-#else /* #ifndef CONFIG_SMP */
-
-static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
-
-static int synchronize_sched_expedited_cpu_stop(void *data)
-{
-	/*
-	 * There must be a full memory barrier on each affected CPU
-	 * between the time that try_stop_cpus() is called and the
-	 * time that it returns.
-	 *
-	 * In the current initial implementation of cpu_stop, the
-	 * above condition is already met when the control reaches
-	 * this point and the following smp_mb() is not strictly
-	 * necessary.  Do smp_mb() anyway for documentation and
-	 * robustness against future implementation changes.
-	 */
-	smp_mb(); /* See above comment block. */
-	return 0;
-}
-
-/*
- * Wait for an rcu-sched grace period to elapse, but use "big hammer"
- * approach to force grace period to end quickly.  This consumes
- * significant time on all CPUs, and is thus not recommended for
- * any sort of common-case code.
- *
- * Note that it is illegal to call this function while holding any
- * lock that is acquired by a CPU-hotplug notifier.  Failing to
- * observe this restriction will result in deadlock.
- */
-void synchronize_sched_expedited(void)
-{
-	int snap, trycount = 0;
-
-	smp_mb();  /* ensure prior mod happens before capturing snap. */
-	snap = atomic_read(&synchronize_sched_expedited_count) + 1;
-	get_online_cpus();
-	while (try_stop_cpus(cpu_online_mask,
-			     synchronize_sched_expedited_cpu_stop,
-			     NULL) == -EAGAIN) {
-		put_online_cpus();
-		if (trycount++ < 10)
-			udelay(trycount * num_online_cpus());
-		else {
-			synchronize_sched();
-			return;
-		}
-		if (atomic_read(&synchronize_sched_expedited_count) - snap > 0) {
-			smp_mb(); /* ensure test happens before caller kfree */
-			return;
-		}
-		get_online_cpus();
-	}
-	atomic_inc(&synchronize_sched_expedited_count);
-	smp_mb__after_atomic_inc(); /* ensure post-GP actions seen after GP. */
-	put_online_cpus();
-}
-EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
-
-#endif /* #else #ifndef CONFIG_SMP */
-- 
1.7.0.6

