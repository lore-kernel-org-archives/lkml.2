Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627Ab1EANcp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:32:45 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49874 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769Ab1EANWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 56/86] net,rcu: convert call_rcu(ipv6_mc_socklist_reclaim) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:36 -0700
Message-Id: <1304256126-26015-56-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback ipv6_mc_socklist_reclaim() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(ipv6_mc_socklist_reclaim).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/ipv6/mcast.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 76b8937..f2d98ca 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -201,10 +201,6 @@ int ipv6_sock_mc_join(struct sock *sk, int ifindex, const struct in6_addr *addr)
 	return 0;
 }
 
-static void ipv6_mc_socklist_reclaim(struct rcu_head *head)
-{
-	kfree(container_of(head, struct ipv6_mc_socklist, rcu));
-}
 /*
  *	socket leave on multicast group
  */
@@ -239,7 +235,7 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 				(void) ip6_mc_leave_src(sk, mc_lst, NULL);
 			rcu_read_unlock();
 			atomic_sub(sizeof(*mc_lst), &sk->sk_omem_alloc);
-			call_rcu(&mc_lst->rcu, ipv6_mc_socklist_reclaim);
+			kfree_rcu(mc_lst, rcu);
 			return 0;
 		}
 	}
@@ -307,7 +303,7 @@ void ipv6_sock_mc_close(struct sock *sk)
 		rcu_read_unlock();
 
 		atomic_sub(sizeof(*mc_lst), &sk->sk_omem_alloc);
-		call_rcu(&mc_lst->rcu, ipv6_mc_socklist_reclaim);
+		kfree_rcu(mc_lst, rcu);
 
 		spin_lock(&ipv6_sk_mc_lock);
 	}
-- 
1.7.3.2

