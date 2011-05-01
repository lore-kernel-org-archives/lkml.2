Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab1EANWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:22:42 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44574 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287Ab1EANWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 37/86] net,rcu: convert call_rcu(tcf_common_free_rcu) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:17 -0700
Message-Id: <1304256126-26015-37-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback tcf_common_free_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(tcf_common_free_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/sched/act_api.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 14b42f4..a606025 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -26,11 +26,6 @@
 #include <net/act_api.h>
 #include <net/netlink.h>
 
-static void tcf_common_free_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct tcf_common, tcfc_rcu));
-}
-
 void tcf_hash_destroy(struct tcf_common *p, struct tcf_hashinfo *hinfo)
 {
 	unsigned int h = tcf_hash(p->tcfc_index, hinfo->hmask);
@@ -47,7 +42,7 @@ void tcf_hash_destroy(struct tcf_common *p, struct tcf_hashinfo *hinfo)
 			 * gen_estimator est_timer() might access p->tcfc_lock
 			 * or bstats, wait a RCU grace period before freeing p
 			 */
-			call_rcu(&p->tcfc_rcu, tcf_common_free_rcu);
+			kfree_rcu(p, tcfc_rcu);
 			return;
 		}
 	}
-- 
1.7.3.2

