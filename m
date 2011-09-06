Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab1IGG1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:27:42 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37772 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597Ab1IGGU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:57 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 30/55] rcu: Eliminate in_irq() checks in rcu_enter_nohz()
Date: Tue,  6 Sep 2011 11:00:24 -0700
Message-Id: <1315332049-2604-30-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
x-cbid: 11090706-6078-0000-0000-000000711820
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The in_irq() check in rcu_enter_nohz() is redundant because if we really
are in an interrupt, the attempt to re-enter dyntick-idle mode will invoke
rcu_needs_cpu() in any case, which will force the check for RCU callbacks.
So this commit removes the check along with the set_need_resched().

Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7e2f297..0c6c30d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -373,13 +373,6 @@ void rcu_enter_nohz(void)
 	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 	local_irq_restore(flags);
-
-	/* If the interrupt queued a callback, get out of dyntick mode. */
-	if (in_irq() &&
-	    (__get_cpu_var(rcu_sched_data).nxtlist ||
-	     __get_cpu_var(rcu_bh_data).nxtlist ||
-	     rcu_preempt_needs_cpu(smp_processor_id())))
-		set_need_resched();
 }
 
 /*
-- 
1.7.3.2

