Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273Ab1CXRuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:50:18 -0400
Received: from flusers.ccur.com ([173.221.59.2]:49935 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756616Ab1CXRs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:48:57 -0400
Date: Thu, 24 Mar 2011 13:48:00 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/24] jrcu: collapse per-cpu .which's to rcu_which
Message-ID: <20110324174800.GA18869@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: collapse per-cpu ->which's into a single rcu_which.

The expected eventual advantages for independent queue
switching never materialized, so simplify.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -103,11 +103,15 @@ static inline void rcu_list_join(struct 
 	}
 }
 
+/*
+ * selects, in ->cblist[] below, which is the current callback list and which
+ * is the previous.
+ */
+static u8 rcu_which ____cacheline_aligned_in_smp;
 
 struct rcu_data {
 	u8 wait;		/* goes false when this cpu consents to
 				 * the retirement of the current batch */
-	u8 which;		/* selects the current callback list */
 	struct rcu_list cblist[2]; /* current & previous callback lists */
 } ____cacheline_aligned_in_smp;
 
@@ -245,7 +249,7 @@ void call_rcu(struct rcu_head *cb, void 
 	smp_rmb();
 
 	rd = &rcu_data[rcu_cpu()];
-	which = ACCESS_ONCE(rd->which) & 1;
+	which = ACCESS_ONCE(rcu_which);
 	cblist = &rd->cblist[which];
 
 	/* The following is not NMI-safe, therefore call_rcu()
@@ -258,39 +262,6 @@ void call_rcu(struct rcu_head *cb, void 
 EXPORT_SYMBOL_GPL(call_rcu);
 
 /*
- * For a given cpu, push the previous batch of callbacks onto a (global)
- * pending list, then make the current batch the previous.  A new, empty
- * current batch exists after this operation.
- *
- * Locklessly tolerates changes being made by call_rcu() to the current
- * batch, locklessly tolerates the current batch becoming the previous
- * batch, and locklessly tolerates a new, empty current batch becoming
- * available.  Requires that the previous batch be quiescent by the time
- * rcu_end_batch is invoked.
- */
-static void rcu_end_batch(struct rcu_data *rd, struct rcu_list *pending)
-{
-	int prev;
-	struct rcu_list *plist;	/* some cpus' previous list */
-
-	prev = (ACCESS_ONCE(rd->which) & 1) ^ 1;
-	plist = &rd->cblist[prev];
-
-	/* Chain previous batch of callbacks, if any, to the pending list */
-	if (plist->head) {
-		rcu_list_join(pending, plist);
-		rcu_list_init(plist);
-		smp_wmb();
-	}
-	/*
-	 * Swap current and previous lists.  Other cpus must not see this
-	 * out-of-order w.r.t. the just-completed plist init, hence the above
-	 * smp_wmb().
-	 */
-	rd->which++;
-}
-
-/*
  * Invoke all callbacks on the passed-in list.
  */
 static void rcu_invoke_callbacks(struct rcu_list *pending)
@@ -321,7 +292,8 @@ static void rcu_invoke_callbacks(struct 
 static void __rcu_delimit_batches(struct rcu_list *pending)
 {
 	struct rcu_data *rd;
-	int cpu, eob;
+	struct rcu_list *plist;
+	int cpu, eob, prev;
 	u64 rcu_now;
 
 	/* If an NMI occured then the previous batch may not yet be
@@ -374,15 +346,39 @@ static void __rcu_delimit_batches(struct
 
 	/*
 	 * End the current RCU batch and start a new one.
+	 *
+	 * This is a two-step operation: move every cpu's previous list
+	 * to the global pending list, then tell every cpu to swap its
+	 * current and pending lists (ie, toggle rcu_which).
+	 *
+	 * We tolerate the cpus taking a bit of time noticing this swap;
+	 * we expect them to continue to put callbacks on the old current
+	 * list (which is now the previous list) for a while.  That time,
+	 * however, cannot exceed one RCU_HZ period.
 	 */
+	prev = ACCESS_ONCE(rcu_which) ^ 1;
+
 	for_each_present_cpu(cpu) {
 		rd = &rcu_data[cpu];
-		rcu_end_batch(rd, pending);
+		plist = &rd->cblist[prev];
+		/* Chain previous batch of callbacks, if any, to the pending list */
+		if (plist->head) {
+			rcu_list_join(pending, plist);
+			rcu_list_init(plist);
+		}
 		if (cpu_online(cpu)) /* wins race with offlining every time */
 			rd->wait = preempt_count_cpu(cpu) > idle_cpu(cpu);
 		else
 			rd->wait = 0;
 	}
+
+	/*
+	 * Swap current and previous lists.  The other cpus must not see this
+	 * out-of-order w.r.t. the above emptying of each cpu's previous list,
+	 * hence the smp_wmb.
+	 */
+	smp_wmb();
+	rcu_which = prev;
 	rcu_stats.nbatches++;
 }
 
@@ -548,7 +544,7 @@ late_initcall(jrcud_start);
 
 static int rcu_debugfs_show(struct seq_file *m, void *unused)
 {
-	int cpu, q, s[2], msecs;
+	int cpu, q, msecs;
 
 	raw_local_irq_disable();
 	msecs = div_s64(sched_clock() - rcu_timestamp, NSEC_PER_MSEC);
@@ -576,31 +572,26 @@ static int rcu_debugfs_show(struct seq_f
 		seq_printf(m, "%4d ", cpu);
 	seq_printf(m, "  CPU\n");
 
-	s[1] = s[0] = 0;
 	for_each_online_cpu(cpu) {
 		struct rcu_data *rd = &rcu_data[cpu];
-		int w = ACCESS_ONCE(rd->which) & 1;
-		seq_printf(m, "%c%c%c%d ",
-			'-',
+		seq_printf(m, "--%c%c ",
 			idle_cpu(cpu) ? 'I' : '-',
-			rd->wait ? 'W' : '-',
-			w);
-		s[w]++;
+			rd->wait ? 'W' : '-');
 	}
 	seq_printf(m, "  FLAGS\n");
 
 	for (q = 0; q < 2; q++) {
+		int w = ACCESS_ONCE(rcu_which);
 		for_each_online_cpu(cpu) {
 			struct rcu_data *rd = &rcu_data[cpu];
 			struct rcu_list *l = &rd->cblist[q];
 			seq_printf(m, "%4d ", l->count);
 		}
-		seq_printf(m, "  Q%d%c\n", q, " *"[s[q] > s[q^1]]);
+		seq_printf(m, "  Q%d%c\n", q, " *"[q == w]);
 	}
 	seq_printf(m, "\nFLAGS:\n");
-	seq_printf(m, "  I - cpu idle, 0|1 - Q0 or Q1 is current Q, other is previous Q,\n");
-	seq_printf(m, "  W - cpu does not permit current batch to end (waiting),\n");
-	seq_printf(m, "  * - marks the Q that is current for most CPUs.\n");
+	seq_printf(m, "  I - cpu idle, W - cpu waiting for end-of-batch,\n");
+	seq_printf(m, "  * - the current Q, other is the previous Q.\n");
 
 	return 0;
 }
