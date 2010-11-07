Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab0KGCFn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 22:05:43 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38311 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab0KGCFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 22:05:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH RFC tip/core/rcu 11/12] rcu: fix race condition in synchronize_sched_expedited()
Date: Sat,  6 Nov 2010 19:05:31 -0700
Message-Id: <1289095532-5398-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20101107020507.GA4974@linux.vnet.ibm.com>
References: <20101107020507.GA4974@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new (early 2010) implementation of synchronize_sched_expedited() uses
try_stop_cpu() to force a context switch on every CPU.  It also permits
concurrent calls to synchronize_sched_expedited() to share a single call
to try_stop_cpu() through use of an atomically incremented
synchronize_sched_expedited_count variable.  Unfortunately, this is
subject to failure as follows:

o	Task A invokes synchronize_sched_expedited(), try_stop_cpus()
	succeeds, but Task A is preempted before getting to the atomic
	increment of synchronize_sched_expedited_count.

o	Task B also invokes synchronize_sched_expedited(), with exactly
	the same outcome as Task A.

o	Task C also invokes synchronize_sched_expedited(), again with
	exactly the same outcome as Tasks A and B.

o	Task D also invokes synchronize_sched_expedited(), but only
	gets as far as acquiring the mutex within try_stop_cpus()
	before being preempted, interrupted, or otherwise delayed.

o	Task E also invokes synchronize_sched_expedited(), but only
	gets to the snapshotting of synchronize_sched_expedited_count.

o	Tasks A, B, and C all increment synchronize_sched_expedited_count.

o	Task E fails to get the mutex, so checks the new value
	of synchronize_sched_expedited_count.  It finds that the
	value has increased, so (wrongly) assumes that its work
	has been done, returning despite there having been no
	expedited grace period since it began.

The solution is to have the lowest-numbered CPU atomically increment
the synchronize_sched_expedited_count variable within the
synchronize_sched_expedited_cpu_stop() function, which is under
the protection of the mutex acquired by try_stop_cpus().  However, this
also requires that piggybacking tasks wait for three rather than two
instances of try_stop_cpu(), because we cannot control the order in
which the per-CPU callback function occur.

Cc: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 643c8f6..c22c4ef 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1041,6 +1041,8 @@ static int synchronize_sched_expedited_cpu_stop(void *data)
 	 * robustness against future implementation changes.
 	 */
 	smp_mb(); /* See above comment block. */
+	if (cpumask_first(cpu_online_mask) == smp_processor_id())
+		atomic_inc(&synchronize_sched_expedited_count);
 	return 0;
 }
 
@@ -1053,13 +1055,26 @@ static int synchronize_sched_expedited_cpu_stop(void *data)
  * Note that it is illegal to call this function while holding any
  * lock that is acquired by a CPU-hotplug notifier.  Failing to
  * observe this restriction will result in deadlock.
+ *
+ * The synchronize_sched_expedited_cpu_stop() function is called
+ * in stop-CPU context, but in order to keep overhead down to a dull
+ * roar, we don't force this function to wait for its counterparts
+ * on other CPUs.  One instance of this function will increment the
+ * synchronize_sched_expedited_count variable per call to
+ * try_stop_cpus(), but there is no guarantee what order this instance
+ * will occur in.  The worst case is that it is last on one call
+ * to try_stop_cpus(), and the first on the next call.  This means
+ * that piggybacking requires that synchronize_sched_expedited_count
+ * be incremented by 3: this guarantees that the piggybacking
+ * task has waited through an entire cycle of context switches,
+ * even in the worst case.
  */
 void synchronize_sched_expedited(void)
 {
 	int snap, trycount = 0;
 
 	smp_mb();  /* ensure prior mod happens before capturing snap. */
-	snap = atomic_read(&synchronize_sched_expedited_count) + 1;
+	snap = atomic_read(&synchronize_sched_expedited_count) + 2;
 	get_online_cpus();
 	while (try_stop_cpus(cpu_online_mask,
 			     synchronize_sched_expedited_cpu_stop,
@@ -1077,7 +1092,6 @@ void synchronize_sched_expedited(void)
 		}
 		get_online_cpus();
 	}
-	atomic_inc(&synchronize_sched_expedited_count);
 	smp_mb__after_atomic_inc(); /* ensure post-GP actions seen after GP. */
 	put_online_cpus();
 }
-- 
1.7.0.6

