Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab1EANYD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:24:03 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39032 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758413Ab1EANW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:57 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 13/86] rcu: add callback-queue information to rcudata output
Date: Sun,  1 May 2011 06:20:53 -0700
Message-Id: <1304256126-26015-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

This commit adds an indication of the state of the callback queue using
a string of four characters following the "ql=" integer queue length.
The first character is "N" if there are callbacks that have been
queued that are not yet ready to be handled by the next grace period, or
"." otherwise.  The second character is "R" if there are callbacks queued
that are ready to be handled by the next grace period, or "." otherwise.
The third character is "W" if there are callbacks waiting for the current
grace period, or "." otherwise.  Finally, the fourth character is "D"
if there are callbacks that have been handled by a prior grace period
and are waiting to be invoked, or ".".

Note that callbacks that are in the process of being invoked are
not shown.  These callbacks would have been removed from the rcu_data
structure's list by rcu_do_batch() prior to being executed.  (These
callbacks are also not reflected in the "ql=" total, FWIW.)

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index ead5736..afd262f 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -64,7 +64,16 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, " ql=%ld b=%ld", rdp->qlen, rdp->blimit);
+	seq_printf(m, " ql=%ld qs=%c%c%c%c b=%ld",
+		   rdp->qlen,
+		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
+			rdp->nxttail[RCU_NEXT_TAIL]],
+		   ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
+			rdp->nxttail[RCU_NEXT_READY_TAIL]],
+		   ".W"[rdp->nxttail[RCU_DONE_TAIL] !=
+			rdp->nxttail[RCU_WAIT_TAIL]],
+		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]],
+		   rdp->blimit);
 	seq_printf(m, " ci=%lu co=%lu ca=%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
@@ -121,7 +130,15 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, ",%ld,%ld", rdp->qlen, rdp->blimit);
+	seq_printf(m, ",%ld,\"%c%c%c%c\",%ld", rdp->qlen,
+		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
+			rdp->nxttail[RCU_NEXT_TAIL]],
+		   ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
+			rdp->nxttail[RCU_NEXT_READY_TAIL]],
+		   ".W"[rdp->nxttail[RCU_DONE_TAIL] !=
+			rdp->nxttail[RCU_WAIT_TAIL]],
+		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]],
+		   rdp->blimit);
 	seq_printf(m, ",%lu,%lu,%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
-- 
1.7.3.2

