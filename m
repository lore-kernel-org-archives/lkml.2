Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab2FOUNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:13:39 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:34136 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab2FOUNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:13:33 -0400
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
Subject: [PATCH tip/core/rcu 03/14] rcu: Add ACCESS_ONCE() to ->qlen accesses
Date: Fri, 15 Jun 2012 13:13:04 -0700
Message-Id: <1339791195-26389-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061520-7282-0000-0000-000009F3A8B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The _rcu_barrier() function accesses other CPUs' rcu_data structure's
->qlen field without benefit of locking.  This commit therefore adds
the required ACCESS_ONCE() wrappers around accesses and updates that
need it.

ACCESS_ONCE() is not needed when a CPU accesses its own ->qlen, or
in code that cannot run while _rcu_barrier() is sampling ->qlen fields.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d938671..cdc101e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1349,7 +1349,7 @@ rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
 		rsp->qlen += rdp->qlen;
 		rdp->n_cbs_orphaned += rdp->qlen;
 		rdp->qlen_lazy = 0;
-		rdp->qlen = 0;
+		ACCESS_ONCE(rdp->qlen) = 0;
 	}
 
 	/*
@@ -1597,7 +1597,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 	smp_mb(); /* List handling before counting for rcu_barrier(). */
 	rdp->qlen_lazy -= count_lazy;
-	rdp->qlen -= count;
+	ACCESS_ONCE(rdp->qlen) -= count;
 	rdp->n_cbs_invoked += count;
 
 	/* Reinstate batch limit if we have worked down the excess. */
@@ -1886,7 +1886,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	rdp = this_cpu_ptr(rsp->rda);
 
 	/* Add the callback to our list. */
-	rdp->qlen++;
+	ACCESS_ONCE(rdp->qlen)++;
 	if (lazy)
 		rdp->qlen_lazy++;
 	else
@@ -2420,7 +2420,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
 	init_callback_list(rdp);
 	rdp->qlen_lazy = 0;
-	rdp->qlen = 0;
+	ACCESS_ONCE(rdp->qlen) = 0;
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
 	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_EXIT_IDLE);
 	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
-- 
1.7.8

