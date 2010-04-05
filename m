Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab0DESfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 14:35:11 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44060 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab0DESel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 14:34:41 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 01/10] rcu: substitute set_need_resched for sending resched IPIs
Date: Mon,  5 Apr 2010 11:34:23 -0700
Message-Id: <1270492472-23222-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100405183403.GA23075@linux.vnet.ibm.com>
References: <20100405183403.GA23075@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a check to __rcu_pending() that does a local
set_need_resched() if the current CPU is holding up the current grace
period and if force_quiescent_state() will be called soon.  The goal is
to reduce the probability that force_quiescent_state() will need to do
smp_send_reschedule(), which sends an IPI and is therefore more expensive
on most architectures.

Signed-off-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3ec8160..e54c123 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1499,6 +1499,16 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
 	if (rdp->qs_pending) {
+
+		/*
+		 * If force_quiescent_state() coming soon and this CPU
+		 * needs a quiescent state, and this is either RCU-sched
+		 * or RCU-bh, force a local reschedule.
+		 */
+		if (!rdp->preemptable &&
+		    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs) - 1,
+				 jiffies))
+			set_need_resched();
 		rdp->n_rp_qs_pending++;
 		return 1;
 	}
-- 
1.7.0

