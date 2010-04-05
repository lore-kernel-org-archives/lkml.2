Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab0DESgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 14:36:12 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59795 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643Ab0DESep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 14:34:45 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 03/10] rcu: move some code from macro to function
Date: Mon,  5 Apr 2010 11:34:25 -0700
Message-Id: <1270492472-23222-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100405183403.GA23075@linux.vnet.ibm.com>
References: <20100405183403.GA23075@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Shrink the RCU_INIT_FLAVOR() macro by moving all but the initialization
of the ->rda[] array to rcu_init_one().  The call to rcu_init_one()
can then be moved to the end of the RCU_INIT_FLAVOR() macro, which is
required because rcu_boot_init_percpu_data(), which is now called from
rcu_init_one(), depends on the initialization of the ->rda[] array.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6042fb8..86bb949 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1859,6 +1859,14 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 			INIT_LIST_HEAD(&rnp->blocked_tasks[3]);
 		}
 	}
+
+	rnp = rsp->level[NUM_RCU_LVLS - 1];
+	for_each_possible_cpu(i) {
+		if (i > rnp->grphi)
+			rnp++;
+		rsp->rda[i]->mynode = rnp;
+		rcu_boot_init_percpu_data(i, rsp);
+	}
 }
 
 /*
@@ -1869,19 +1877,11 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 #define RCU_INIT_FLAVOR(rsp, rcu_data) \
 do { \
 	int i; \
-	int j; \
-	struct rcu_node *rnp; \
 	\
-	rcu_init_one(rsp); \
-	rnp = (rsp)->level[NUM_RCU_LVLS - 1]; \
-	j = 0; \
 	for_each_possible_cpu(i) { \
-		if (i > rnp[j].grphi) \
-			j++; \
-		per_cpu(rcu_data, i).mynode = &rnp[j]; \
 		(rsp)->rda[i] = &per_cpu(rcu_data, i); \
-		rcu_boot_init_percpu_data(i, rsp); \
 	} \
+	rcu_init_one(rsp); \
 } while (0)
 
 void __init rcu_init(void)
-- 
1.7.0

