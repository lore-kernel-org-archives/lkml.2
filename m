Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab1EBVgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:36:52 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56835 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab1EBVgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:36:51 -0400
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
Subject: [PATCH tip/core/rcu 5/7] batman,rcu: convert call_rcu(softif_neigh_free_rcu) to kfree_rcu
Date: Mon,  2 May 2011 09:13:42 -0700
Message-Id: <1304352824-6563-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110502161321.GA6537@linux.vnet.ibm.com>
References: <20110502161321.GA6537@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RCU callback softif_neigh_free_rcu() just calls kfree(), so we can
use kfree_rcu() instead of call_rcu().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Marek Lindner <lindner_marek@yahoo.de>
Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Cc: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/soft-interface.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 824e1f6..04efe02 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -76,18 +76,10 @@ int my_skb_head_push(struct sk_buff *skb, unsigned int len)
 	return 0;
 }
 
-static void softif_neigh_free_rcu(struct rcu_head *rcu)
-{
-	struct softif_neigh *softif_neigh;
-
-	softif_neigh = container_of(rcu, struct softif_neigh, rcu);
-	kfree(softif_neigh);
-}
-
 static void softif_neigh_free_ref(struct softif_neigh *softif_neigh)
 {
 	if (atomic_dec_and_test(&softif_neigh->refcount))
-		call_rcu(&softif_neigh->rcu, softif_neigh_free_rcu);
+		kfree_rcu(softif_neigh, rcu);
 }
 
 void softif_neigh_purge(struct bat_priv *bat_priv)
-- 
1.7.3.2

