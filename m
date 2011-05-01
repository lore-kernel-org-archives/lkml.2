Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502Ab1EAN3x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:29:53 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38975 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757266Ab1EANWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:36 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 60/86] security,rcu: convert call_rcu(sel_netif_free) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:40 -0700
Message-Id: <1304256126-26015-60-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback sel_netif_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(sel_netif_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 security/selinux/netif.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/security/selinux/netif.c b/security/selinux/netif.c
index d6095d6..58cc481 100644
--- a/security/selinux/netif.c
+++ b/security/selinux/netif.c
@@ -104,22 +104,6 @@ static int sel_netif_insert(struct sel_netif *netif)
 }
 
 /**
- * sel_netif_free - Frees an interface entry
- * @p: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table interface entry can be
- * released safely.
- *
- */
-static void sel_netif_free(struct rcu_head *p)
-{
-	struct sel_netif *netif = container_of(p, struct sel_netif, rcu_head);
-	kfree(netif);
-}
-
-/**
  * sel_netif_destroy - Remove an interface record from the table
  * @netif: the existing interface record
  *
@@ -131,7 +115,7 @@ static void sel_netif_destroy(struct sel_netif *netif)
 {
 	list_del_rcu(&netif->list);
 	sel_netif_total--;
-	call_rcu(&netif->rcu_head, sel_netif_free);
+	kfree_rcu(netif, rcu_head);
 }
 
 /**
-- 
1.7.3.2

