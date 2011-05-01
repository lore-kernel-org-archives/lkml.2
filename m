Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782Ab1EANex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:34:53 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44983 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756400Ab1EANWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 38/86] net,rcu: convert call_rcu(tcf_police_free_rcu) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:18 -0700
Message-Id: <1304256126-26015-38-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

[PATCH 05/17] net,rcu: convert call_rcu(tcf_police_free_rcu) to kfree_rcu()

The rcu callback tcf_police_free_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(tcf_police_free_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/sched/act_police.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 8a16307..d6bcd64 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -96,11 +96,6 @@ nla_put_failure:
 	goto done;
 }
 
-static void tcf_police_free_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct tcf_police, tcf_rcu));
-}
-
 static void tcf_police_destroy(struct tcf_police *p)
 {
 	unsigned int h = tcf_hash(p->tcf_index, POL_TAB_MASK);
@@ -121,7 +116,7 @@ static void tcf_police_destroy(struct tcf_police *p)
 			 * gen_estimator est_timer() might access p->tcf_lock
 			 * or bstats, wait a RCU grace period before freeing p
 			 */
-			call_rcu(&p->tcf_rcu, tcf_police_free_rcu);
+			kfree_rcu(p, tcf_rcu);
 			return;
 		}
 	}
-- 
1.7.3.2

