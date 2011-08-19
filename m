Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab1HSQf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:35:58 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41458 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354Ab1HSQfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:35:55 -0400
Date: Fri, 19 Aug 2011 09:35:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, stable@kernel.org
Subject: [PATCH RFC tip/core/urgent] rcu: Avoid having just-onlined CPU
 resched itself when RCU is idle
Message-ID: <20110819163547.GA5182@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUs set rdp->qs_pending when coming online to resolve races with
grace-period start.  However, this means that if RCU is idle, the
just-onlined CPU might needlessly send itself resched IPIs.  Adjust the
online-CPU initialization to avoid this, and also to correctly cause
the CPU to respond to the current grace period if needed.

This patch is believed to fix or otherwise suppress problems in
https://bugzilla.redhat.com/show_bug.cgi?id=726877, however, the
relationship is not apparent to this patch's author.  That said, it is
hard to argue with test results.

This will be available from -rcu as soon as kernel.org's mirrors update:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent

Reported-by: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Reported-by: Michal Jaegermann <michal@harddata.com>
Reported-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Josh Boyer <jwboyer@redhat.com>

 rcutree.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ba06207..39cc360 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1865,8 +1865,6 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 
 	/* Set up local state, ensuring consistent view of global state. */
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
-	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
 	rdp->beenonline = 1;	 /* We have now been online. */
 	rdp->preemptible = preemptible;
 	rdp->qlen_last_fqs_check = 0;
@@ -1891,8 +1889,15 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 		rnp->qsmaskinit |= mask;
 		mask = rnp->grpmask;
 		if (rnp == rdp->mynode) {
-			rdp->gpnum = rnp->completed; /* if GP in progress... */
+			/*
+			 * If there is a grace period in progress, we will
+			 * set up to wait for it next time we run the
+			 * RCU core code.
+			 */
+			rdp->gpnum = rnp->completed;
 			rdp->completed = rnp->completed;
+			rdp->passed_quiesc = 0;
+			rdp->qs_pending = 0;
 			rdp->passed_quiesc_completed = rnp->completed - 1;
 		}
 		raw_spin_unlock(&rnp->lock); /* irqs already disabled. */
