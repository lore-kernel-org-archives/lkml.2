Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab1FHTdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:33:37 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50945 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab1FHTah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>
Subject: [PATCH tip/core/rcu 20/28] security,rcu: Convert call_rcu(sel_netnode_free) to kfree_rcu()
Date: Wed,  8 Jun 2011 12:29:59 -0700
Message-Id: <1307561407-13809-20-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110608192943.GA13211@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback sel_netnode_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(sel_netnode_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@parisplace.org>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 security/selinux/netnode.c |   20 ++------------------
 1 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
index 65ebfe9..692b857 100644
--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -69,22 +69,6 @@ static DEFINE_SPINLOCK(sel_netnode_lock);
 static struct sel_netnode_bkt sel_netnode_hash[SEL_NETNODE_HASH_SIZE];
 
 /**
- * sel_netnode_free - Frees a node entry
- * @p: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table node entry can be
- * released safely.
- *
- */
-static void sel_netnode_free(struct rcu_head *p)
-{
-	struct sel_netnode *node = container_of(p, struct sel_netnode, rcu);
-	kfree(node);
-}
-
-/**
  * sel_netnode_hashfn_ipv4 - IPv4 hashing function for the node table
  * @addr: IPv4 address
  *
@@ -192,7 +176,7 @@ static void sel_netnode_insert(struct sel_netnode *node)
 			rcu_dereference(sel_netnode_hash[idx].list.prev),
 			struct sel_netnode, list);
 		list_del_rcu(&tail->list);
-		call_rcu(&tail->rcu, sel_netnode_free);
+		kfree_rcu(tail, rcu);
 	} else
 		sel_netnode_hash[idx].size++;
 }
@@ -305,7 +289,7 @@ static void sel_netnode_flush(void)
 		list_for_each_entry_safe(node, node_tmp,
 					 &sel_netnode_hash[idx].list, list) {
 				list_del_rcu(&node->list);
-				call_rcu(&node->rcu, sel_netnode_free);
+				kfree_rcu(node, rcu);
 		}
 		sel_netnode_hash[idx].size = 0;
 	}
-- 
1.7.3.2

