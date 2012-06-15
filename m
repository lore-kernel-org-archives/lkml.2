Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab2FOUNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:13:51 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59970 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab2FOUNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:13:48 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 13/14] rcu: Split RCU core processing out of __call_rcu()
Date: Fri, 15 Jun 2012 13:13:14 -0700
Message-Id: <1339791195-26389-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061520-3270-0000-0000-000007370B0B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The __call_rcu() function is a bit overweight, so this commit splits
it into actual enqueuing of and accounting for the callback (__call_rcu())
and associated RCU-core processing (__call_rcu_core()).

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 9419ebf..6940a81 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1858,9 +1858,11 @@ static void invoke_rcu_core(void)
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
 	unsigned long flags;
 	struct rcu_data *rdp;
@@ -1905,10 +1907,8 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 		invoke_rcu_core();
 
 	/* If interrupts were disabled or CPU offline, don't invoke RCU core. */
-	if (irqs_disabled_flags(flags) || cpu_is_offline(smp_processor_id())) {
-		local_irq_restore(flags);
+	if (irqs_disabled_flags(flags) || cpu_is_offline(smp_processor_id()))
 		return;
-	}
 
 	/*
 	 * Force the grace period if too many callbacks or too long waiting.
@@ -1941,6 +1941,49 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
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

