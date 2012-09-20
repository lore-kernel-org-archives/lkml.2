Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab2ITStk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:49:40 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43000 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab2ITStb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:49:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 17/23] rcu: Add random PROVE_RCU_DELAY to grace-period initialization
Date: Thu, 20 Sep 2012 11:48:13 -0700
Message-Id: <1348166900-18716-17-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120920184751.GA18657@linux.vnet.ibm.com>
 <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092018-5518-0000-0000-000007CEF52F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Preemption greatly raised the probability of certain types of race
conditions, so this commit adds an anti-heisenbug to greatly increase
the collision cross section, also known as the probability of occurrence.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 25a671c..5cb003d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -52,6 +52,7 @@
 #include <linux/prefetch.h>
 #include <linux/delay.h>
 #include <linux/stop_machine.h>
+#include <linux/random.h>
 
 #include "rcutree.h"
 #include <trace/events/rcu.h>
@@ -1085,6 +1086,10 @@ static int rcu_gp_init(struct rcu_state *rsp)
 					    rnp->level, rnp->grplo,
 					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irq(&rnp->lock);
+#ifdef CONFIG_PROVE_RCU_DELAY
+		if ((random32() % (rcu_num_nodes * 8)) == 0)
+			schedule_timeout_uninterruptible(2);
+#endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
 		cond_resched();
 	}
 
-- 
1.7.8

