Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab1EANgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:36:53 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38354 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835Ab1EANW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:28 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 43/86] net,rcu: convert call_rcu(ha_rcu_free) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:23 -0700
Message-Id: <1304256126-26015-43-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback ha_rcu_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(ha_rcu_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/core/dev_addr_lists.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 7b39f3e..e2e6693 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -68,14 +68,6 @@ static int __hw_addr_add(struct netdev_hw_addr_list *list, unsigned char *addr,
 	return __hw_addr_add_ex(list, addr, addr_len, addr_type, false);
 }
 
-static void ha_rcu_free(struct rcu_head *head)
-{
-	struct netdev_hw_addr *ha;
-
-	ha = container_of(head, struct netdev_hw_addr, rcu_head);
-	kfree(ha);
-}
-
 static int __hw_addr_del_ex(struct netdev_hw_addr_list *list,
 			    unsigned char *addr, int addr_len,
 			    unsigned char addr_type, bool global)
@@ -94,7 +86,7 @@ static int __hw_addr_del_ex(struct netdev_hw_addr_list *list,
 			if (--ha->refcount)
 				return 0;
 			list_del_rcu(&ha->list);
-			call_rcu(&ha->rcu_head, ha_rcu_free);
+			kfree_rcu(ha, rcu_head);
 			list->count--;
 			return 0;
 		}
@@ -197,7 +189,7 @@ void __hw_addr_flush(struct netdev_hw_addr_list *list)
 
 	list_for_each_entry_safe(ha, tmp, &list->list, list) {
 		list_del_rcu(&ha->list);
-		call_rcu(&ha->rcu_head, ha_rcu_free);
+		kfree_rcu(ha, rcu_head);
 	}
 	list->count = 0;
 }
-- 
1.7.3.2

