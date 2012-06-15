Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab2FOVHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:07:32 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43524 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab2FOVH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:07:29 -0400
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
Subject: [PATCH tip/core/rcu 09/15] rcu: Increasing rcu_barrier() concurrency
Date: Fri, 15 Jun 2012 14:06:04 -0700
Message-Id: <1339794370-28119-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061521-9360-0000-0000-000007629D09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The traditional rcu_barrier() implementation has serialized all requests,
regardless of RCU flavor, and also does not coalesce concurrent requests.
In the past, this has been good and sufficient.

However, systems are getting larger and use of rcu_barrier() has been
increasing.  This commit therefore introduces a counter-based scheme
that allows _rcu_barrier() calls for the same flavor of RCU to take
advantage of each others' work.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   27 ++++++++++++++++++++++++++-
 kernel/rcutree.h |    2 ++
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 93358d4..7c299d3 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2291,13 +2291,32 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	unsigned long flags;
 	struct rcu_data *rdp;
 	struct rcu_data rd;
+	unsigned long snap = ACCESS_ONCE(rsp->n_barrier_done);
+	unsigned long snap_done;
 
 	init_rcu_head_on_stack(&rd.barrier_head);
 
 	/* Take mutex to serialize concurrent rcu_barrier() requests. */
 	mutex_lock(&rsp->barrier_mutex);
 
-	smp_mb();  /* Prevent any prior operations from leaking in. */
+	/*
+	 * Ensure tht all prior references, including to ->n_barrier_done,
+	 * are ordered before the _rcu_barrier() machinery.
+	 */
+	smp_mb();  /* See above block comment. */
+
+	/* Recheck ->n_barrier_done to see if others did our work for us. */
+	snap_done = ACCESS_ONCE(rsp->n_barrier_done);
+	if (ULONG_CMP_GE(snap_done, ((snap + 1) & ~0x1) + 2)) {
+		smp_mb();
+		mutex_unlock(&rsp->barrier_mutex);
+		return;
+	}
+
+	/* Increment ->n_barrier_done to avoid duplicate work. */
+	ACCESS_ONCE(rsp->n_barrier_done)++;
+	WARN_ON_ONCE((rsp->n_barrier_done & 0x1) != 1);
+	smp_mb(); /* Order ->n_barrier_done increment with below mechanism. */
 
 	/*
 	 * Initialize the count to one rather than to zero in order to
@@ -2368,6 +2387,12 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	if (atomic_dec_and_test(&rsp->barrier_cpu_count))
 		complete(&rsp->barrier_completion);
 
+	/* Increment ->n_barrier_done to prevent duplicate work. */
+	smp_mb(); /* Keep increment after above mechanism. */
+	ACCESS_ONCE(rsp->n_barrier_done)++;
+	WARN_ON_ONCE((rsp->n_barrier_done & 0x1) != 0);
+	smp_mb(); /* Keep increment before caller's subsequent code. */
+
 	/* Wait for all rcu_barrier_callback() callbacks to be invoked. */
 	wait_for_completion(&rsp->barrier_completion);
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index d9ac82f..a294f7f 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -389,6 +389,8 @@ struct rcu_state {
 	struct mutex barrier_mutex;		/* Guards barrier fields. */
 	atomic_t barrier_cpu_count;		/* # CPUs waiting on. */
 	struct completion barrier_completion;	/* Wake at barrier end. */
+	unsigned long n_barrier_done;		/* ++ at start and end of */
+						/*  _rcu_barrier(). */
 	raw_spinlock_t fqslock;			/* Only one task forcing */
 						/*  quiescent states. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
-- 
1.7.8

