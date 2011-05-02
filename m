Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab1EBVl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:41:59 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49189 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756919Ab1EBVgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:36:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH tip/core/rcu 4/7] batman,rcu: convert call_rcu(neigh_node_free_rcu) to kfree()
Date: Mon,  2 May 2011 09:13:41 -0700
Message-Id: <1304352824-6563-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110502161321.GA6537@linux.vnet.ibm.com>
References: <20110502161321.GA6537@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RCU callback neigh_node_free_rcu() just calls kfree(), so we can use
kfree_rcu() instead of call_rcu().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Marek Lindner <lindner_marek@yahoo.de>
Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Cc: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/originator.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index 0b91330..ed23a589 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -56,18 +56,10 @@ err:
 	return 0;
 }
 
-static void neigh_node_free_rcu(struct rcu_head *rcu)
-{
-	struct neigh_node *neigh_node;
-
-	neigh_node = container_of(rcu, struct neigh_node, rcu);
-	kfree(neigh_node);
-}
-
 void neigh_node_free_ref(struct neigh_node *neigh_node)
 {
 	if (atomic_dec_and_test(&neigh_node->refcount))
-		call_rcu(&neigh_node->rcu, neigh_node_free_rcu);
+		kfree_rcu(neigh_node, rcu);
 }
 
 struct neigh_node *create_neighbor(struct orig_node *orig_node,
-- 
1.7.3.2

