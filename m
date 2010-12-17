Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab0LQU5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:57:10 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33717 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab0LQUzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:55:10 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 13/20] rcu: increase synchronize_sched_expedited() batching
Date: Fri, 17 Dec 2010 12:54:44 -0800
Message-Id: <1292619291-2468-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20101217205433.GA10199@linux.vnet.ibm.com>
References: <20101217205433.GA10199@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

The fix in commit #6a0cc49 requires more than three concurrent instances
of synchronize_sched_expedited() before batching is possible.  This
patch uses a ticket-counter-like approach that is also not unrelated to
Lai Jiangshan's Ring RCU to allow sharing of expedited grace periods even
when there are only two concurrent instances of synchronize_sched_expedited().

This commit builds on Tejun's original posting, which may be found at
http://lkml.org/lkml/2010/11/9/204, adding memory barriers, avoiding
overflow of signed integers (other than via atomic_t), and fixing the
detection of batching.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    2 +
 kernel/rcutree_plugin.h  |   82 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 64 insertions(+), 20 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 49e8e16..af56148 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -47,6 +47,8 @@
 extern int rcutorture_runnable; /* for sysctl */
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
+#define UINT_CMP_GE(a, b)	(UINT_MAX / 2 >= (a) - (b))
+#define UINT_CMP_LT(a, b)	(UINT_MAX / 2 < (a) - (b))
 #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
 #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c22c4ef..a363871 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1025,7 +1025,8 @@ EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
 
 #else /* #ifndef CONFIG_SMP */
 
-static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
+static atomic_t sync_sched_expedited_started = ATOMIC_INIT(0);
+static atomic_t sync_sched_expedited_done = ATOMIC_INIT(0);
 
 static int synchronize_sched_expedited_cpu_stop(void *data)
 {
@@ -1041,8 +1042,6 @@ static int synchronize_sched_expedited_cpu_stop(void *data)
 	 * robustness against future implementation changes.
 	 */
 	smp_mb(); /* See above comment block. */
-	if (cpumask_first(cpu_online_mask) == smp_processor_id())
-		atomic_inc(&synchronize_sched_expedited_count);
 	return 0;
 }
 
@@ -1056,43 +1055,86 @@ static int synchronize_sched_expedited_cpu_stop(void *data)
  * lock that is acquired by a CPU-hotplug notifier.  Failing to
  * observe this restriction will result in deadlock.
  *
- * The synchronize_sched_expedited_cpu_stop() function is called
- * in stop-CPU context, but in order to keep overhead down to a dull
- * roar, we don't force this function to wait for its counterparts
- * on other CPUs.  One instance of this function will increment the
- * synchronize_sched_expedited_count variable per call to
- * try_stop_cpus(), but there is no guarantee what order this instance
- * will occur in.  The worst case is that it is last on one call
- * to try_stop_cpus(), and the first on the next call.  This means
- * that piggybacking requires that synchronize_sched_expedited_count
- * be incremented by 3: this guarantees that the piggybacking
- * task has waited through an entire cycle of context switches,
- * even in the worst case.
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
  */
 void synchronize_sched_expedited(void)
 {
-	int snap, trycount = 0;
+	int firstsnap, s, snap, trycount = 0;
 
-	smp_mb();  /* ensure prior mod happens before capturing snap. */
-	snap = atomic_read(&synchronize_sched_expedited_count) + 2;
+	/* Note that atomic_inc_return() implies full memory barrier. */
+	firstsnap = snap = atomic_inc_return(&sync_sched_expedited_started);
 	get_online_cpus();
+
+	/*
+	 * Each pass through the following loop attempts to force a
+	 * context switch on each CPU.
+	 */
 	while (try_stop_cpus(cpu_online_mask,
 			     synchronize_sched_expedited_cpu_stop,
 			     NULL) == -EAGAIN) {
 		put_online_cpus();
+
+		/* No joy, try again later.  Or just synchronize_sched(). */
 		if (trycount++ < 10)
 			udelay(trycount * num_online_cpus());
 		else {
 			synchronize_sched();
 			return;
 		}
-		if (atomic_read(&synchronize_sched_expedited_count) - snap > 0) {
+
+		/* Check to see if someone else did our work for us. */
+		s = atomic_read(&sync_sched_expedited_done);
+		if (UINT_CMP_GE((unsigned)s, (unsigned)firstsnap)) {
 			smp_mb(); /* ensure test happens before caller kfree */
 			return;
 		}
+
+		/*
+		 * Refetching sync_sched_expedited_started allows later
+		 * callers to piggyback on our grace period.  We subtract
+		 * 1 to get the same token that the last incrementer got.
+		 * We retry after they started, so our grace period works
+		 * for them, and they started after our first try, so their
+		 * grace period works for us.
+		 */
 		get_online_cpus();
+		snap = atomic_read(&sync_sched_expedited_started) - 1;
+		smp_mb(); /* ensure read is before try_stop_cpus(). */
 	}
-	smp_mb__after_atomic_inc(); /* ensure post-GP actions seen after GP. */
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
 	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
-- 
1.7.3.2

