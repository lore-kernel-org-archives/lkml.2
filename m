Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab2JQHOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 03:14:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38347 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2JQHOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:14:16 -0400
Subject: [PATCH] rcu: restore correct batch limiting
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Oct 2012 09:14:12 +0200
Message-ID: <1350458052.26103.31.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Commit 29c00b4a1d9e27 (rcu: Add event-tracing for RCU callback
invocation) added a regression in rcu_do_batch()

Under stress, RCU is supposed to allow to process all items in queue,
instead of a batch of 10 items (blimit), but an integer overflow makes
the effective limit being 1.

So RCU cannot recover and machine eventually crash because of OOM.

Using long instead of int is not really needed, convert everything
to integers.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Google-Bug-Id: 7362491
CC: stable@vger.kernel.org
---
 kernel/rcutree.c       |    4 ++--
 kernel/rcutree.h       |    4 ++--
 kernel/rcutree_trace.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 74df86b..fc3ebae 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1834,7 +1834,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	rdp->n_cbs_invoked += count;
 
 	/* Reinstate batch limit if we have worked down the excess. */
-	if (rdp->blimit == LONG_MAX && rdp->qlen <= qlowmark)
+	if (rdp->blimit == INT_MAX && rdp->qlen <= qlowmark)
 		rdp->blimit = blimit;
 
 	/* Reset ->qlen_last_fqs_check trigger if enough CBs have drained. */
@@ -2097,7 +2097,7 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 			rcu_start_gp(rsp, nestflag);  /* rlses rnp_root->lock */
 		} else {
 			/* Give the grace period a kick. */
-			rdp->blimit = LONG_MAX;
+			rdp->blimit = INT_MAX;
 			if (rsp->n_force_qs == rdp->n_force_qs_snap &&
 			    *rdp->nxttail[RCU_DONE_TAIL] != head)
 				force_quiescent_state(rsp);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index a240f03..6421173 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -291,11 +291,11 @@ struct rcu_data {
 	unsigned long   n_cbs_adopted;  /* RCU cbs adopted from dying CPU */
 	unsigned long	n_force_qs_snap;
 					/* did other CPU force QS recently? */
-	long		blimit;		/* Upper limit on a processed batch */
+	int		blimit;		/* Upper limit on a processed batch */
 
 	/* 3) dynticks interface. */
+	int		dynticks_snap;	/* Per-GP tracking for dynticks. */
 	struct rcu_dynticks *dynticks;	/* Shared per-CPU dynticks state. */
-	int dynticks_snap;		/* Per-GP tracking for dynticks. */
 
 	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
 	unsigned long dynticks_fqs;	/* Kicked due to dynticks idle. */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 693513b..fde0541 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -113,7 +113,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 					  rdp->cpu)),
 		   per_cpu(rcu_cpu_kthread_loops, rdp->cpu) & 0xffff);
 #endif /* #ifdef CONFIG_RCU_BOOST */
-	seq_printf(m, " b=%ld", rdp->blimit);
+	seq_printf(m, " b=%d", rdp->blimit);
 	seq_printf(m, " ci=%lu co=%lu ca=%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
@@ -173,7 +173,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
 					  rdp->cpu)));
 #endif /* #ifdef CONFIG_RCU_BOOST */
-	seq_printf(m, ",%ld", rdp->blimit);
+	seq_printf(m, ",%d", rdp->blimit);
 	seq_printf(m, ",%lu,%lu,%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }


