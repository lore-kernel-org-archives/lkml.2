Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab1EANWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:22:48 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53886 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756306Ab1EANWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 32/86] rcu: prevent call_rcu() from diving into rcu core if irqs disabled
Date: Sun,  1 May 2011 06:21:12 -0700
Message-Id: <1304256126-26015-32-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit marks a first step towards making call_rcu() have
real-time behavior.  If irqs are disabled, don't dive into the
RCU core.  Later on, this new early exit will wake up the
per-CPU kthread, which first must be modified to handle the
cases involving callback storms.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 963b4b1..a6fc20d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1839,6 +1839,13 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	/* Add the callback to our list. */
 	*rdp->nxttail[RCU_NEXT_TAIL] = head;
 	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
+	rdp->qlen++;
+
+	/* If interrupts were disabled, don't dive into RCU core. */
+	if (irqs_disabled_flags(flags)) {
+		local_irq_restore(flags);
+		return;
+	}
 
 	/*
 	 * Force the grace period if too many callbacks or too long waiting.
@@ -1847,7 +1854,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	 * invoking force_quiescent_state() if the newly enqueued callback
 	 * is the only one waiting for a grace period to complete.
 	 */
-	if (unlikely(++rdp->qlen > rdp->qlen_last_fqs_check + qhimark)) {
+	if (unlikely(rdp->qlen > rdp->qlen_last_fqs_check + qhimark)) {
 
 		/* Are we ignoring a completed grace period? */
 		rcu_process_gp_end(rsp, rdp);
-- 
1.7.3.2

