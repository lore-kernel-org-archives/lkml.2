Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594Ab1EAN1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:27:33 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60594 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757303Ab1EANWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 61/86] net,rcu: convert call_rcu(netlbl_unlhsh_free_addr4) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:41 -0700
Message-Id: <1304256126-26015-61-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback netlbl_unlhsh_free_addr4() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(netlbl_unlhsh_free_addr4).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/netlabel/netlabel_unlabeled.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index e2b0a68..4e5ad90 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -153,24 +153,6 @@ static const struct nla_policy netlbl_unlabel_genl_policy[NLBL_UNLABEL_A_MAX + 1
  * Unlabeled Connection Hash Table Functions
  */
 
-/**
- * netlbl_unlhsh_free_addr4 - Frees an IPv4 address entry from the hash table
- * @entry: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table address entry can be
- * released safely.
- *
- */
-static void netlbl_unlhsh_free_addr4(struct rcu_head *entry)
-{
-	struct netlbl_unlhsh_addr4 *ptr;
-
-	ptr = container_of(entry, struct netlbl_unlhsh_addr4, rcu);
-	kfree(ptr);
-}
-
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 /**
  * netlbl_unlhsh_free_addr6 - Frees an IPv6 address entry from the hash table
@@ -568,7 +550,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 	if (entry == NULL)
 		return -ENOENT;
 
-	call_rcu(&entry->rcu, netlbl_unlhsh_free_addr4);
+	kfree_rcu(entry, rcu);
 	return 0;
 }
 
-- 
1.7.3.2

