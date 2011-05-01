Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667Ab1EANcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:32:48 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44610 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725Ab1EANWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 49/86] net,rcu: convert call_rcu(__gen_kill_estimator) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:29 -0700
Message-Id: <1304256126-26015-49-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback __gen_kill_estimator() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(__gen_kill_estimator).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/core/gen_estimator.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 7c23733..43b03dd 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -249,13 +249,6 @@ int gen_new_estimator(struct gnet_stats_basic_packed *bstats,
 }
 EXPORT_SYMBOL(gen_new_estimator);
 
-static void __gen_kill_estimator(struct rcu_head *head)
-{
-	struct gen_estimator *e = container_of(head,
-					struct gen_estimator, e_rcu);
-	kfree(e);
-}
-
 /**
  * gen_kill_estimator - remove a rate estimator
  * @bstats: basic statistics
@@ -279,7 +272,7 @@ void gen_kill_estimator(struct gnet_stats_basic_packed *bstats,
 		write_unlock(&est_lock);
 
 		list_del_rcu(&e->list);
-		call_rcu(&e->e_rcu, __gen_kill_estimator);
+		kfree_rcu(e, e_rcu);
 	}
 	spin_unlock_bh(&est_tree_lock);
 }
-- 
1.7.3.2

