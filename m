Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2DPLZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 07:25:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43746 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab2DPLZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 07:25:33 -0400
Date: Mon, 16 Apr 2012 04:24:31 -0700
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Message-ID: <tip-92d52de4add0e4502aeb063cd45daf314a9c2e1b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paul.mckenney@linaro.org, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org,
        sergey.senozhatsky@gmail.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
Reply-To: paulmck@linux.vnet.ibm.com, mingo@kernel.org, hpa@zytor.com,
        paul.mckenney@linaro.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, sergey.senozhatsky@gmail.com,
        tglx@linutronix.de
In-Reply-To: <20120405222604.GA15713@linux.vnet.ibm.com>
References: <20120405222604.GA15713@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Permit call_rcu() from CPU_DYING notifiers
Git-Commit-ID: 92d52de4add0e4502aeb063cd45daf314a9c2e1b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 16 Apr 2012 04:24:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  92d52de4add0e4502aeb063cd45daf314a9c2e1b
Gitweb:     http://git.kernel.org/tip/92d52de4add0e4502aeb063cd45daf314a9c2e1b
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Thu, 5 Apr 2012 15:26:04 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 16 Apr 2012 11:17:57 +0200

rcu: Permit call_rcu() from CPU_DYING notifiers

As of:

  29494be71afe ("rcu,cleanup: simplify the code when cpu is dying")

RCU adopts callbacks from the dying CPU in its CPU_DYING notifier,
which means that any callbacks posted by later CPU_DYING notifiers
are ignored until the CPU comes back online.

A WARN_ON_ONCE() was added to __call_rcu() by:

  e56014000816 ("rcu: Simplify offline processing")

to check for this condition.  Although this condition did not trigger
(at least as far as I know) during -next testing, it did recently
trigger in mainline:

  https://lkml.org/lkml/2012/4/2/34

This commit therefore causes RCU's CPU_DEAD notifier to adopt
any callbacks that were posted by CPU_DYING notifiers and
removes the WARN_ON_ONCE() from __call_rcu().

A more targeted warning for callback posting from offline CPUs will be
added as a separate commit.

Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@efficios.com
Cc: josh@joshtriplett.org
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: eric.dumazet@gmail.com
Cc: darren@dvhart.com
Cc: fweisbec@gmail.com
Cc: patches@linaro.org
Link: http://lkml.kernel.org/r/20120405222604.GA15713@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/rcutree.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

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
