Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab1IGGXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:23:22 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46715 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866Ab1IGGWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:22:19 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 36/55] rcu: Prevent early boot set_need_resched() from __rcu_pending()
Date: Tue,  6 Sep 2011 11:00:30 -0700
Message-Id: <1315332049-2604-36-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

There isn't a whole lot of point in poking the scheduler before there
are other tasks to switch to.  This commit therefore adds a check
for rcu_scheduler_fully_active in __rcu_pending() to suppress any
pre-scheduler calls to set_need_resched().  The downside of this approach
is additional runtime overhead in a reasonably hot code path.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a07bf55..0051dbf 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1707,7 +1707,8 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	check_cpu_stall(rsp, rdp);
 
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
-	if (rdp->qs_pending && !rdp->passed_quiesce) {
+	if (rcu_scheduler_fully_active &&
+	    rdp->qs_pending && !rdp->passed_quiesce) {
 
 		/*
 		 * If force_quiescent_state() coming soon and this CPU
-- 
1.7.3.2

