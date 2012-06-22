Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151Ab2FVPZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:25:53 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:54987 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013Ab2FVPZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:25:49 -0400
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
Subject: [PATCH tip/core/rcu 09/22] rcu: Move rcu_barrier_mutex to rcu_state structure
Date: Fri, 22 Jun 2012 08:17:08 -0700
Message-Id: <1340378241-6458-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622151655.GA6249@linux.vnet.ibm.com>
 <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-7408-0000-0000-0000061D482A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

In order to allow each RCU flavor to concurrently execute its
rcu_barrier() function, it is necessary to move the relevant
state to the rcu_state structure.  This commit therefore moves the
rcu_barrier_mutex global variable to a new ->barrier_mutex field
in the rcu_state structure.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    9 +++------
 kernel/rcutree.h |    1 +
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5e087f9..ac6e0c2 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -71,6 +71,7 @@ static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
 	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&sname##_state.onofflock), \
 	.orphan_nxttail = &sname##_state.orphan_nxtlist, \
 	.orphan_donetail = &sname##_state.orphan_donelist, \
+	.barrier_mutex = __MUTEX_INITIALIZER(sname##_state.barrier_mutex), \
 	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&sname##_state.fqslock), \
 	.n_force_qs = 0, \
 	.n_force_qs_ngp = 0, \
@@ -155,10 +156,6 @@ static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
 unsigned long rcutorture_testseq;
 unsigned long rcutorture_vernum;
 
-/* State information for rcu_barrier() and friends. */
-
-static DEFINE_MUTEX(rcu_barrier_mutex);
-
 /*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
  * permit this function to be invoked without holding the root rcu_node
@@ -2300,7 +2297,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	init_rcu_head_on_stack(&rd.barrier_head);
 
 	/* Take mutex to serialize concurrent rcu_barrier() requests. */
-	mutex_lock(&rcu_barrier_mutex);
+	mutex_lock(&rsp->barrier_mutex);
 
 	smp_mb();  /* Prevent any prior operations from leaking in. */
 
@@ -2377,7 +2374,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	wait_for_completion(&rsp->barrier_completion);
 
 	/* Other rcu_barrier() invocations can now safely proceed. */
-	mutex_unlock(&rcu_barrier_mutex);
+	mutex_unlock(&rsp->barrier_mutex);
 
 	destroy_rcu_head_on_stack(&rd.barrier_head);
 }
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 56fb8d4..d9ac82f 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -386,6 +386,7 @@ struct rcu_state {
 	struct task_struct *rcu_barrier_in_progress;
 						/* Task doing rcu_barrier(), */
 						/*  or NULL if no barrier. */
+	struct mutex barrier_mutex;		/* Guards barrier fields. */
 	atomic_t barrier_cpu_count;		/* # CPUs waiting on. */
 	struct completion barrier_completion;	/* Wake at barrier end. */
 	raw_spinlock_t fqslock;			/* Only one task forcing */
-- 
1.7.8

