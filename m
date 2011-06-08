Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1FHTa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:30:58 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50981 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682Ab1FHTaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:46 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Patrick McHardy <kaber@trash.net>
Subject: [PATCH tip/core/rcu 27/28] net,rcu: Convert call_rcu(xt_rateest_free_rcu) to kfree_rcu()
Date: Wed,  8 Jun 2011 12:30:06 -0700
Message-Id: <1307561407-13809-27-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110608192943.GA13211@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RCU callback xt_rateest_free_rcu() just calls kfree(), so we can
use kfree_rcu() instead of call_rcu().  This also allows us to dispense
with an rcu_barrier() call, speeding up unloading of this module.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Patrick McHardy <kaber@trash.net>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 net/netfilter/xt_RATEEST.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index de079abd..f264032 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -60,11 +60,6 @@ struct xt_rateest *xt_rateest_lookup(const char *name)
 }
 EXPORT_SYMBOL_GPL(xt_rateest_lookup);
 
-static void xt_rateest_free_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct xt_rateest, rcu));
-}
-
 void xt_rateest_put(struct xt_rateest *est)
 {
 	mutex_lock(&xt_rateest_mutex);
@@ -75,7 +70,7 @@ void xt_rateest_put(struct xt_rateest *est)
 		 * gen_estimator est_timer() might access est->lock or bstats,
 		 * wait a RCU grace period before freeing 'est'
 		 */
-		call_rcu(&est->rcu, xt_rateest_free_rcu);
+		kfree_rcu(est, rcu);
 	}
 	mutex_unlock(&xt_rateest_mutex);
 }
@@ -188,7 +183,6 @@ static int __init xt_rateest_tg_init(void)
 static void __exit xt_rateest_tg_fini(void)
 {
 	xt_unregister_target(&xt_rateest_tg_reg);
-	rcu_barrier(); /* Wait for completion of call_rcu()'s (xt_rateest_free_rcu) */
 }
 
 
-- 
1.7.3.2

