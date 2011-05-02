Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831Ab1EBVhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:37:00 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50351 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757476Ab1EBVg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:36:57 -0400
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
Subject: [PATCH tip/core/rcu 3/7] batman,rcu: convert call_rcu(gw_node_free_rcu) to kfree_rcu
Date: Mon,  2 May 2011 09:13:40 -0700
Message-Id: <1304352824-6563-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110502161321.GA6537@linux.vnet.ibm.com>
References: <20110502161321.GA6537@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RCU callback gw_node_free_rcu() just calls kfree(), so we can use
kfree_rcu() instead of call_rcu().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Marek Lindner <lindner_marek@yahoo.de>
Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Cc: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/gateway_client.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index 3cc4355..150b6ce 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -28,18 +28,10 @@
 #include <linux/udp.h>
 #include <linux/if_vlan.h>
 
-static void gw_node_free_rcu(struct rcu_head *rcu)
-{
-	struct gw_node *gw_node;
-
-	gw_node = container_of(rcu, struct gw_node, rcu);
-	kfree(gw_node);
-}
-
 static void gw_node_free_ref(struct gw_node *gw_node)
 {
 	if (atomic_dec_and_test(&gw_node->refcount))
-		call_rcu(&gw_node->rcu, gw_node_free_rcu);
+		kfree_rcu(gw_node, rcu);
 }
 
 void *gw_get_selected(struct bat_priv *bat_priv)
-- 
1.7.3.2

