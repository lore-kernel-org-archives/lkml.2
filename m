Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242Ab2FVPh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:37:56 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57740 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab2FVPhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:37:54 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 13/17] rcu: Split RCU core processing out of __call_rcu()
Date: Fri, 22 Jun 2012 08:35:08 -0700
Message-Id: <1340379312-6684-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622153501.GA6626@linux.vnet.ibm.com>
 <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-5518-0000-0000-0000056D6C19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The __call_rcu() function is a bit overweight, so this commit splits
it into actual enqueuing of and accounting for the callback (__call_rcu())
and associated RCU-core processing (__call_rcu_core()).

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |   90 +++++++++++++++++++++++++++++------------------------
 1 files changed, 49 insertions(+), 41 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 9419ebf..ce175b6 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1858,45 +1858,12 @@ static void invoke_rcu_core(void)
 	raise_softirq(RCU_SOFTIRQ);
 }
 
-static void
-__call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
-	   struct rcu_state *rsp, bool lazy)
+/*
+ * Handle any core-RCU processing required by a call_rcu() invocation.
+ */
+static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
+			    struct rcu_head *head, unsigned long flags)
 {
-	unsigned long flags;
-	struct rcu_data *rdp;
-
-	WARN_ON_ONCE((unsigned long)head & 0x3); /* Misaligned rcu_head! */
-	debug_rcu_head_queue(head);
-	head->func = func;
-	head->next = NULL;
-
-	smp_mb(); /* Ensure RCU update seen before callback registry. */
-
-	/*
-	 * Opportunistically note grace-period endings and beginnings.
-	 * Note that we might see a beginning right after we see an
-	 * end, but never vice versa, since this CPU has to pass through
-	 * a quiescent state betweentimes.
-	 */
-	local_irq_save(flags);
-	rdp = this_cpu_ptr(rsp->rda);
-
-	/* Add the callback to our list. */
-	ACCESS_ONCE(rdp->qlen)++;
-	if (lazy)
-		rdp->qlen_lazy++;
-	else
-		rcu_idle_count_callbacks_posted();
-	smp_mb();  /* Count before adding callback for rcu_barrier(). */
-	*rdp->nxttail[RCU_NEXT_TAIL] = head;
-	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
-
-	if (__is_kfree_rcu_offset((unsigned long)func))
-		trace_rcu_kfree_callback(rsp->name, head, (unsigned long)func,
-					 rdp->qlen_lazy, rdp->qlen);
-	else
-		trace_rcu_callback(rsp->name, head, rdp->qlen_lazy, rdp->qlen);
-
 	/*
 	 * If called from an extended quiescent state, invoke the RCU
 	 * core in order to force a re-evaluation of RCU's idleness.
@@ -1905,10 +1872,8 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 		invoke_rcu_core();
 
 	/* If interrupts were disabled or CPU offline, don't invoke RCU core. */
-	if (irqs_disabled_flags(flags) || cpu_is_offline(smp_processor_id())) {
-		local_irq_restore(flags);
+	if (irqs_disabled_flags(flags) || cpu_is_offline(smp_processor_id()))
 		return;
-	}
 
 	/*
 	 * Force the grace period if too many callbacks or too long waiting.
@@ -1941,6 +1906,49 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 		}
 	} else if (ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs), jiffies))
 		force_quiescent_state(rsp, 1);
+}
+
+static void
+__call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
+	   struct rcu_state *rsp, bool lazy)
+{
+	unsigned long flags;
+	struct rcu_data *rdp;
+
+	WARN_ON_ONCE((unsigned long)head & 0x3); /* Misaligned rcu_head! */
+	debug_rcu_head_queue(head);
+	head->func = func;
+	head->next = NULL;
+
+	smp_mb(); /* Ensure RCU update seen before callback registry. */
+
+	/*
+	 * Opportunistically note grace-period endings and beginnings.
+	 * Note that we might see a beginning right after we see an
+	 * end, but never vice versa, since this CPU has to pass through
+	 * a quiescent state betweentimes.
+	 */
+	local_irq_save(flags);
+	rdp = this_cpu_ptr(rsp->rda);
+
+	/* Add the callback to our list. */
+	ACCESS_ONCE(rdp->qlen)++;
+	if (lazy)
+		rdp->qlen_lazy++;
+	else
+		rcu_idle_count_callbacks_posted();
+	smp_mb();  /* Count before adding callback for rcu_barrier(). */
+	*rdp->nxttail[RCU_NEXT_TAIL] = head;
+	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
+
+	if (__is_kfree_rcu_offset((unsigned long)func))
+		trace_rcu_kfree_callback(rsp->name, head, (unsigned long)func,
+					 rdp->qlen_lazy, rdp->qlen);
+	else
+		trace_rcu_callback(rsp->name, head, rdp->qlen_lazy, rdp->qlen);
+
+	/* Go handle any RCU core processing required. */
+	__call_rcu_core(rsp, rdp, head, flags);
 	local_irq_restore(flags);
 }
 
-- 
1.7.8

