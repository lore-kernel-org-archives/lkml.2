Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648Ab1EANeB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:34:01 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53911 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643Ab1EANWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 40/86] net,rcu: convert call_rcu(inet6_ifa_finish_destroy_rcu) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:20 -0700
Message-Id: <1304256126-26015-40-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback inet6_ifa_finish_destroy_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(inet6_ifa_finish_destroy_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/ipv6/addrconf.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 85787e3..b3e50ee 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -529,12 +529,6 @@ static int addrconf_fixup_forwarding(struct ctl_table *table, int *p, int old)
 }
 #endif
 
-static void inet6_ifa_finish_destroy_rcu(struct rcu_head *head)
-{
-	struct inet6_ifaddr *ifp = container_of(head, struct inet6_ifaddr, rcu);
-	kfree(ifp);
-}
-
 /* Nobody refers to this ifaddr, destroy it */
 void inet6_ifa_finish_destroy(struct inet6_ifaddr *ifp)
 {
@@ -555,7 +549,7 @@ void inet6_ifa_finish_destroy(struct inet6_ifaddr *ifp)
 	}
 	dst_release(&ifp->rt->dst);
 
-	call_rcu(&ifp->rcu, inet6_ifa_finish_destroy_rcu);
+	kfree_rcu(ifp, rcu);
 }
 
 static void
-- 
1.7.3.2

