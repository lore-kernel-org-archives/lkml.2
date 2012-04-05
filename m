Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab2DEW0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:26:15 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44142 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab2DEW0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:26:14 -0400
Date: Thu, 5 Apr 2012 15:26:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, sergey.senozhatsky@gmail.com
Subject: [PATCH tip/urgent] rcu: Permit call_rcu() from CPU_DYING notifiers
Message-ID: <20120405222604.GA15713@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040522-1976-0000-0000-00000C1D2101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit 29494be7, RCU adopts callbacks from the dying CPU in its
CPU_DYING notifier, which means that any callbacks posted by later
CPU_DYING notifiers are ignored until the CPU comes back online.
A WARN_ON_ONCE() was added to __call_rcu() by commit e5601400 to check
for this condition.  Although this condition did not trigger (at least
as far as know) during -next testing, it did recently trigger in mainline
(https://lkml.org/lkml/2012/4/2/34).

This commit therefore causes RCU's CPU_DEAD notifier to adopt any
callbacks that were posted by CPU_DYING notifiers and removes the
WARN_ON_ONCE() from __call_rcu().  A more targeted warning for callback
posting from offline CPUs will be added as a separate commit.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

 rcutree.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 1050d6d..4c927e6 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1406,11 +1406,41 @@ static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
 static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
+	int i;
 	unsigned long mask;
 	int need_report = 0;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;  /* Outgoing CPU's rnp. */
 
+	/* If a CPU_DYING notifier has enqueued callbacks, adopt them. */
+	if (rdp->nxtlist != NULL) {
+		struct rcu_data *receive_rdp;
+
+		local_irq_save(flags);
+		receive_rdp = per_cpu_ptr(rsp->rda, smp_processor_id());
+
+		/* Adjust the counts. */
+		receive_rdp->qlen_lazy += rdp->qlen_lazy;
+		receive_rdp->qlen += rdp->qlen;
+		rdp->qlen_lazy = 0;
+		rdp->qlen = 0;
+
+		/*
+		 * Adopt all callbacks.  The outgoing CPU was in no shape
+		 * to advance them, so make them all go through a full
+		 * grace period.
+		 */
+		*receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
+		receive_rdp->nxttail[RCU_NEXT_TAIL] =
+			rdp->nxttail[RCU_NEXT_TAIL];
+		local_irq_restore(flags);
+
+		/* Initialize the outgoing CPU's callback list. */
+		rdp->nxtlist = NULL;
+		for (i = 0; i < RCU_NEXT_SIZE; i++)
+			rdp->nxttail[i] = &rdp->nxtlist;
+	}
+
 	/* Adjust any no-longer-needed kthreads. */
 	rcu_stop_cpu_kthread(cpu);
 	rcu_node_kthread_setaffinity(rnp, -1);
@@ -1820,7 +1850,6 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	 * a quiescent state betweentimes.
 	 */
 	local_irq_save(flags);
-	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
 	rdp = this_cpu_ptr(rsp->rda);
 
 	/* Add the callback to our list. */

