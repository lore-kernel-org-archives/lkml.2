Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933839Ab2J3QzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:55:11 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49357 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934108Ab2J3QzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:55:03 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 6/7] rcu: Move synchronize_sched_expedited() state to rcu_state
Date: Tue, 30 Oct 2012 09:54:35 -0700
Message-Id: <1351616076-25617-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616076-25617-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030165415.GA25438@linux.vnet.ibm.com>
 <1351616076-25617-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-2876-0000-0000-00000181911C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Tracing (debugfs) of expedited RCU primitives is required, which in turn
requires that the relevant data be located where the tracing code can find
it, not in its current static global variables in kernel/rcutree.c.
This commit therefore moves sync_sched_expedited_started and
sync_sched_expedited_done to the rcu_state structure, as fields
->expedited_start and ->expedited_done, respectively.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   20 +++++++++-----------
 kernel/rcutree.h |    3 +++
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6789055..3c72e5e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2249,9 +2249,6 @@ void synchronize_rcu_bh(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
-static atomic_long_t sync_sched_expedited_started = ATOMIC_LONG_INIT(0);
-static atomic_long_t sync_sched_expedited_done = ATOMIC_LONG_INIT(0);
-
 static int synchronize_sched_expedited_cpu_stop(void *data)
 {
 	/*
@@ -2310,6 +2307,7 @@ void synchronize_sched_expedited(void)
 {
 	long firstsnap, s, snap;
 	int trycount = 0;
+	struct rcu_state *rsp = &rcu_sched_state;
 
 	/*
 	 * If we are in danger of counter wrap, just do synchronize_sched().
@@ -2319,8 +2317,8 @@ void synchronize_sched_expedited(void)
 	 * counter wrap on a 32-bit system.  Quite a few more CPUs would of
 	 * course be required on a 64-bit system.
 	 */
-	if (ULONG_CMP_GE((ulong)atomic_read(&sync_sched_expedited_started),
-			 (ulong)atomic_read(&sync_sched_expedited_done) +
+	if (ULONG_CMP_GE((ulong)atomic_long_read(&rsp->expedited_start),
+			 (ulong)atomic_long_read(&rsp->expedited_done) +
 			 ULONG_MAX / 8)) {
 		synchronize_sched();
 		return;
@@ -2330,7 +2328,7 @@ void synchronize_sched_expedited(void)
 	 * Take a ticket.  Note that atomic_inc_return() implies a
 	 * full memory barrier.
 	 */
-	snap = atomic_long_inc_return(&sync_sched_expedited_started);
+	snap = atomic_long_inc_return(&rsp->expedited_start);
 	firstsnap = snap;
 	get_online_cpus();
 	WARN_ON_ONCE(cpu_is_offline(raw_smp_processor_id()));
@@ -2345,7 +2343,7 @@ void synchronize_sched_expedited(void)
 		put_online_cpus();
 
 		/* Check to see if someone else did our work for us. */
-		s = atomic_long_read(&sync_sched_expedited_done);
+		s = atomic_long_read(&rsp->expedited_done);
 		if (ULONG_CMP_GE((ulong)s, (ulong)firstsnap)) {
 			smp_mb(); /* ensure test happens before caller kfree */
 			return;
@@ -2360,7 +2358,7 @@ void synchronize_sched_expedited(void)
 		}
 
 		/* Recheck to see if someone else did our work for us. */
-		s = atomic_long_read(&sync_sched_expedited_done);
+		s = atomic_long_read(&rsp->expedited_done);
 		if (ULONG_CMP_GE((ulong)s, (ulong)firstsnap)) {
 			smp_mb(); /* ensure test happens before caller kfree */
 			return;
@@ -2374,7 +2372,7 @@ void synchronize_sched_expedited(void)
 		 * period works for us.
 		 */
 		get_online_cpus();
-		snap = atomic_long_read(&sync_sched_expedited_started);
+		snap = atomic_long_read(&rsp->expedited_start);
 		smp_mb(); /* ensure read is before try_stop_cpus(). */
 	}
 
@@ -2385,12 +2383,12 @@ void synchronize_sched_expedited(void)
 	 * than we did already did their update.
 	 */
 	do {
-		s = atomic_long_read(&sync_sched_expedited_done);
+		s = atomic_long_read(&rsp->expedited_done);
 		if (ULONG_CMP_GE((ulong)s, (ulong)snap)) {
 			smp_mb(); /* ensure test happens before caller kfree */
 			break;
 		}
-	} while (atomic_long_cmpxchg(&sync_sched_expedited_done, s, snap) != s);
+	} while (atomic_long_cmpxchg(&rsp->expedited_done, s, snap) != s);
 
 	put_online_cpus();
 }
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index a7c945d..88f3d9d 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -404,6 +404,9 @@ struct rcu_state {
 						/*  _rcu_barrier(). */
 	/* End of fields guarded by barrier_mutex. */
 
+	atomic_long_t expedited_start;		/* Starting ticket. */
+	atomic_long_t expedited_done;		/* Done ticket. */
+
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
 						/*  force_quiescent_state(). */
 	unsigned long n_force_qs;		/* Number of calls to */
-- 
1.7.8

