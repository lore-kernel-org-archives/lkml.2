Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab1EANXF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:23:05 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38469 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758381Ab1EANW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 52/86] net,rcu: convert call_rcu(ip_mc_socklist_reclaim) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:32 -0700
Message-Id: <1304256126-26015-52-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback ip_mc_socklist_reclaim() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(ip_mc_socklist_reclaim).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/ipv4/igmp.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 85a6e5d..8f62d66 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1850,14 +1850,6 @@ static int ip_mc_leave_src(struct sock *sk, struct ip_mc_socklist *iml,
 	return err;
 }
 
-
-static void ip_mc_socklist_reclaim(struct rcu_head *rp)
-{
-	kfree(container_of(rp, struct ip_mc_socklist, rcu));
-	/* sk_omem_alloc should have been decreased by the caller*/
-}
-
-
 /*
  *	Ask a socket to leave a group.
  */
@@ -1897,7 +1889,7 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 		rtnl_unlock();
 		/* decrease mem now to avoid the memleak warning */
 		atomic_sub(sizeof(*iml), &sk->sk_omem_alloc);
-		call_rcu(&iml->rcu, ip_mc_socklist_reclaim);
+		kfree_rcu(iml, rcu);
 		return 0;
 	}
 	if (!in_dev)
@@ -2312,7 +2304,7 @@ void ip_mc_drop_socket(struct sock *sk)
 			ip_mc_dec_group(in_dev, iml->multi.imr_multiaddr.s_addr);
 		/* decrease mem now to avoid the memleak warning */
 		atomic_sub(sizeof(*iml), &sk->sk_omem_alloc);
-		call_rcu(&iml->rcu, ip_mc_socklist_reclaim);
+		kfree_rcu(iml, rcu);
 	}
 	rtnl_unlock();
 }
-- 
1.7.3.2

