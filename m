Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab2BATnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:43:47 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55039 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236Ab2BATnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:43:45 -0500
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
Subject: [PATCH RFC tip/core/rcu 35/41] rcu: Move synchronize_sched_expedited() to rcutree.c
Date: Wed,  1 Feb 2012 11:41:53 -0800
Message-Id: <1328125319-5205-35-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-5806-0000-0000-000011F300EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Now that TREE_RCU and TREE_PREEMPT_RCU no longer do anything different
for the single-CPU case, there is no need for multiple definitions of
synchronize_sched_expedited().  It is no longer in any sense a plug-in,
so move it from kernel/rcutree_plugin.h to kernel/rcutree.c.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |  117 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcutree_plugin.h |  116 ----------------------------------------------
 2 files changed, 117 insertions(+), 116 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 243ceb1..632b1c3 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -50,6 +50,8 @@
 #include <linux/wait.h>
 #include <linux/kthread.h>
 #include <linux/prefetch.h>
+#include <linux/delay.h>
+#include <linux/stop_machine.h>
 
 #include "rcutree.h"
 #include <trace/events/rcu.h>
@@ -1919,6 +1921,121 @@ void synchronize_rcu_bh(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
+static atomic_t sync_sched_expedited_started = ATOMIC_INIT(0);
+static atomic_t sync_sched_expedited_done = ATOMIC_INIT(0);
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
+ *
+ * This implementation can be thought of as an application of ticket
+ * locking to RCU, with sync_sched_expedited_started and
+ * sync_sched_expedited_done taking on the roles of the halves
+ * of the ticket-lock word.  Each task atomically increments
+ * sync_sched_expedited_started upon entry, snapshotting the old value,
+ * then attempts to stop all the CPUs.  If this succeeds, then each
+ * CPU will have executed a context switch, resulting in an RCU-sched
+ * grace period.  We are then done, so we use atomic_cmpxchg() to
+ * update sync_sched_expedited_done to match our snapshot -- but
+ * only if someone else has not already advanced past our snapshot.
+ *
+ * On the other hand, if try_stop_cpus() fails, we check the value
+ * of sync_sched_expedited_done.  If it has advanced past our
+ * initial snapshot, then someone else must have forced a grace period
+ * some time after we took our snapshot.  In this case, our work is
+ * done for us, and we can simply return.  Otherwise, we try again,
+ * but keep our initial snapshot for purposes of checking for someone
+ * doing our work for us.
+ *
+ * If we fail too many times in a row, we fall back to synchronize_sched().
+ */
+void synchronize_sched_expedited(void)
+{
+	int firstsnap, s, snap, trycount = 0;
+
+	/* Note that atomic_inc_return() implies full memory barrier. */
+	firstsnap = snap = atomic_inc_return(&sync_sched_expedited_started);
+	get_online_cpus();
+	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
+
+	/*
+	 * Each pass through the following loop attempts to force a
+	 * context switch on each CPU.
+	 */
+	while (try_stop_cpus(cpu_online_mask,
+			     synchronize_sched_expedited_cpu_stop,
+			     NULL) == -EAGAIN) {
+		put_online_cpus();
+
+		/* No joy, try again later.  Or just synchronize_sched(). */
+		if (trycount++ < 10)
+			udelay(trycount * num_online_cpus());
+		else {
+			synchronize_sched();
+			return;
+		}
+
+		/* Check to see if someone else did our work for us. */
+		s = atomic_read(&sync_sched_expedited_done);
+		if (UINT_CMP_GE((unsigned)s, (unsigned)firstsnap)) {
+			smp_mb(); /* ensure test happens before caller kfree */
+			return;
+		}
+
+		/*
+		 * Refetching sync_sched_expedited_started allows later
+		 * callers to piggyback on our grace period.  We subtract
+		 * 1 to get the same token that the last incrementer got.
+		 * We retry after they started, so our grace period works
+		 * for them, and they started after our first try, so their
+		 * grace period works for us.
+		 */
+		get_online_cpus();
+		snap = atomic_read(&sync_sched_expedited_started);
+		smp_mb(); /* ensure read is before try_stop_cpus(). */
+	}
+
+	/*
+	 * Everyone up to our most recent fetch is covered by our grace
+	 * period.  Update the counter, but only if our work is still
+	 * relevant -- which it won't be if someone who started later
+	 * than we did beat us to the punch.
+	 */
+	do {
+		s = atomic_read(&sync_sched_expedited_done);
+		if (UINT_CMP_GE((unsigned)s, (unsigned)snap)) {
+			smp_mb(); /* ensure test happens before caller kfree */
+			break;
+		}
+	} while (atomic_cmpxchg(&sync_sched_expedited_done, s, snap) != s);
+
+	put_online_cpus();
+}
+EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
+
 /*
  * Check to see if there is any immediate RCU-related work to be done
  * by the current CPU, for the specified type of RCU, returning 1 if so.
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 255ef887..9706a12 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -25,7 +25,6 @@
  */
 
 #include <linux/delay.h>
-#include <linux/stop_machine.h>
 
 #define RCU_KTHREAD_PRIO 1
 
@@ -1887,121 +1886,6 @@ static void __cpuinit rcu_prepare_kthreads(int cpu)
 
 #endif /* #else #ifdef CONFIG_RCU_BOOST */
 
-static atomic_t sync_sched_expedited_started = ATOMIC_INIT(0);
-static atomic_t sync_sched_expedited_done = ATOMIC_INIT(0);
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
- *
- * This implementation can be thought of as an application of ticket
- * locking to RCU, with sync_sched_expedited_started and
- * sync_sched_expedited_done taking on the roles of the halves
- * of the ticket-lock word.  Each task atomically increments
- * sync_sched_expedited_started upon entry, snapshotting the old value,
- * then attempts to stop all the CPUs.  If this succeeds, then each
- * CPU will have executed a context switch, resulting in an RCU-sched
- * grace period.  We are then done, so we use atomic_cmpxchg() to
- * update sync_sched_expedited_done to match our snapshot -- but
- * only if someone else has not already advanced past our snapshot.
- *
- * On the other hand, if try_stop_cpus() fails, we check the value
- * of sync_sched_expedited_done.  If it has advanced past our
- * initial snapshot, then someone else must have forced a grace period
- * some time after we took our snapshot.  In this case, our work is
- * done for us, and we can simply return.  Otherwise, we try again,
- * but keep our initial snapshot for purposes of checking for someone
- * doing our work for us.
- *
- * If we fail too many times in a row, we fall back to synchronize_sched().
- */
-void synchronize_sched_expedited(void)
-{
-	int firstsnap, s, snap, trycount = 0;
-
-	/* Note that atomic_inc_return() implies full memory barrier. */
-	firstsnap = snap = atomic_inc_return(&sync_sched_expedited_started);
-	get_online_cpus();
-	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
-
-	/*
-	 * Each pass through the following loop attempts to force a
-	 * context switch on each CPU.
-	 */
-	while (try_stop_cpus(cpu_online_mask,
-			     synchronize_sched_expedited_cpu_stop,
-			     NULL) == -EAGAIN) {
-		put_online_cpus();
-
-		/* No joy, try again later.  Or just synchronize_sched(). */
-		if (trycount++ < 10)
-			udelay(trycount * num_online_cpus());
-		else {
-			synchronize_sched();
-			return;
-		}
-
-		/* Check to see if someone else did our work for us. */
-		s = atomic_read(&sync_sched_expedited_done);
-		if (UINT_CMP_GE((unsigned)s, (unsigned)firstsnap)) {
-			smp_mb(); /* ensure test happens before caller kfree */
-			return;
-		}
-
-		/*
-		 * Refetching sync_sched_expedited_started allows later
-		 * callers to piggyback on our grace period.  We subtract
-		 * 1 to get the same token that the last incrementer got.
-		 * We retry after they started, so our grace period works
-		 * for them, and they started after our first try, so their
-		 * grace period works for us.
-		 */
-		get_online_cpus();
-		snap = atomic_read(&sync_sched_expedited_started);
-		smp_mb(); /* ensure read is before try_stop_cpus(). */
-	}
-
-	/*
-	 * Everyone up to our most recent fetch is covered by our grace
-	 * period.  Update the counter, but only if our work is still
-	 * relevant -- which it won't be if someone who started later
-	 * than we did beat us to the punch.
-	 */
-	do {
-		s = atomic_read(&sync_sched_expedited_done);
-		if (UINT_CMP_GE((unsigned)s, (unsigned)snap)) {
-			smp_mb(); /* ensure test happens before caller kfree */
-			break;
-		}
-	} while (atomic_cmpxchg(&sync_sched_expedited_done, s, snap) != s);
-
-	put_online_cpus();
-}
-EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
-
 #if !defined(CONFIG_RCU_FAST_NO_HZ)
 
 /*
-- 
1.7.8

