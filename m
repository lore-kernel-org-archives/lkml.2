Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab2H3STM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:19:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49126 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2H3STI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:19:08 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 20/23] rcu: Remove callback acceleration from grace-period initialization
Date: Thu, 30 Aug 2012 11:18:35 -0700
Message-Id: <1346350718-30937-20-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083018-7282-0000-0000-00000C74E2DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Before grace-period initialization was moved to a kthread, the CPU
invoking this code would have at least one callback that needed
a grace period, often a newly registered callback.  However, moving
grace-period initialization means that the CPU with the callback
that was requesting a grace period is not necessarily the CPU that
is initializing the grace period, so this acceleration is less
valuable.  Because it also adds to the complexity of reasoning about
correctness, this commit removes it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 86903df..44609c3 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1055,25 +1055,6 @@ static int rcu_gp_init(struct rcu_state *rsp)
 	rsp->gpnum++;
 	trace_rcu_grace_period(rsp->name, rsp->gpnum, "start");
 	record_gp_stall_check_time(rsp);
-
-	/*
-	 * Because this CPU just now started the new grace period, we
-	 * know that all of its callbacks will be covered by this upcoming
-	 * grace period, even the ones that were registered arbitrarily
-	 * recently.    Therefore, advance all RCU_NEXT_TAIL callbacks
-	 * to RCU_NEXT_READY_TAIL.  When the CPU later recognizes the
-	 * start of the new grace period, it will advance all callbacks
-	 * one position, which will cause all of its current outstanding
-	 * callbacks to be handled by the newly started grace period.
-	 *
-	 * Other CPUs cannot be sure exactly when the grace period started.
-	 * Therefore, their recently registered callbacks must pass through
-	 * an additional RCU_NEXT_READY stage, so that they will be handled
-	 * by the next RCU grace period.
-	 */
-	rdp = __this_cpu_ptr(rsp->rda);
-	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
-
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/* Exclude any concurrent CPU-hotplug operations. */
-- 
1.7.8

