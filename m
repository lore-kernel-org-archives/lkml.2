Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211Ab2FVP0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:26:21 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55439 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196Ab2FVP0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:26:17 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/22] rcu: Move rcu_barrier_completion to rcu_state structure
Date: Fri, 22 Jun 2012 08:17:07 -0700
Message-Id: <1340378241-6458-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622151655.GA6249@linux.vnet.ibm.com>
 <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-7606-0000-0000-00000160F05D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

In order to allow each RCU flavor to concurrently execute its
rcu_barrier() function, it is necessary to move the relevant
state to the rcu_state structure.  This commit therefore moves the
rcu_barrier_completion global variable to a new ->barrier_completion
field in the rcu_state structure.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |    9 ++++-----
 kernel/rcutree.h |    1 +
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 592c43f..5e087f9 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -158,7 +158,6 @@ unsigned long rcutorture_vernum;
 /* State information for rcu_barrier() and friends. */
 
 static DEFINE_MUTEX(rcu_barrier_mutex);
-static struct completion rcu_barrier_completion;
 
 /*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
@@ -2272,7 +2271,7 @@ static void rcu_barrier_callback(struct rcu_head *rhp)
 	struct rcu_state *rsp = rdp->rsp;
 
 	if (atomic_dec_and_test(&rsp->barrier_cpu_count))
-		complete(&rcu_barrier_completion);
+		complete(&rsp->barrier_completion);
 }
 
 /*
@@ -2322,7 +2321,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	 * 6.	Both rcu_barrier_callback() callbacks are invoked, awakening
 	 *	us -- but before CPU 1's orphaned callbacks are invoked!!!
 	 */
-	init_completion(&rcu_barrier_completion);
+	init_completion(&rsp->barrier_completion);
 	atomic_set(&rsp->barrier_cpu_count, 1);
 	raw_spin_lock_irqsave(&rsp->onofflock, flags);
 	rsp->rcu_barrier_in_progress = current;
@@ -2372,10 +2371,10 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	 * CPU, and thus each counted, remove the initial count.
 	 */
 	if (atomic_dec_and_test(&rsp->barrier_cpu_count))
-		complete(&rcu_barrier_completion);
+		complete(&rsp->barrier_completion);
 
 	/* Wait for all rcu_barrier_callback() callbacks to be invoked. */
-	wait_for_completion(&rcu_barrier_completion);
+	wait_for_completion(&rsp->barrier_completion);
 
 	/* Other rcu_barrier() invocations can now safely proceed. */
 	mutex_unlock(&rcu_barrier_mutex);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index e7d29b7..56fb8d4 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -387,6 +387,7 @@ struct rcu_state {
 						/* Task doing rcu_barrier(), */
 						/*  or NULL if no barrier. */
 	atomic_t barrier_cpu_count;		/* # CPUs waiting on. */
+	struct completion barrier_completion;	/* Wake at barrier end. */
 	raw_spinlock_t fqslock;			/* Only one task forcing */
 						/*  quiescent states. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
-- 
1.7.8

