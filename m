Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726Ab1EANeu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:34:50 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54871 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417Ab1EANWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 41/86] net,rcu: convert call_rcu(listeners_free_rcu) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:21 -0700
Message-Id: <1304256126-26015-41-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback listeners_free_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(listeners_free_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/netlink/af_netlink.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index c8f35b5..5fe4f3b 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1566,12 +1566,6 @@ netlink_kernel_release(struct sock *sk)
 }
 EXPORT_SYMBOL(netlink_kernel_release);
 
-
-static void listeners_free_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct listeners, rcu));
-}
-
 int __netlink_change_ngroups(struct sock *sk, unsigned int groups)
 {
 	struct listeners *new, *old;
@@ -1588,7 +1582,7 @@ int __netlink_change_ngroups(struct sock *sk, unsigned int groups)
 		memcpy(new->masks, old->masks, NLGRPSZ(tbl->groups));
 		rcu_assign_pointer(tbl->listeners, new);
 
-		call_rcu(&old->rcu, listeners_free_rcu);
+		kfree_rcu(old, rcu);
 	}
 	tbl->groups = groups;
 
-- 
1.7.3.2

