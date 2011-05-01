Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639Ab1EANbk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:31:40 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45012 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756981Ab1EANWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 51/86] net,rcu: convert call_rcu(ip_sf_socklist_reclaim) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:31 -0700
Message-Id: <1304256126-26015-51-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback ip_sf_socklist_reclaim() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(ip_sf_socklist_reclaim).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/ipv4/igmp.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index f22f30e..85a6e5d 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1830,12 +1830,6 @@ done:
 }
 EXPORT_SYMBOL(ip_mc_join_group);
 
-static void ip_sf_socklist_reclaim(struct rcu_head *rp)
-{
-	kfree(container_of(rp, struct ip_sf_socklist, rcu));
-	/* sk_omem_alloc should have been decreased by the caller*/
-}
-
 static int ip_mc_leave_src(struct sock *sk, struct ip_mc_socklist *iml,
 			   struct in_device *in_dev)
 {
@@ -1852,7 +1846,7 @@ static int ip_mc_leave_src(struct sock *sk, struct ip_mc_socklist *iml,
 	rcu_assign_pointer(iml->sflist, NULL);
 	/* decrease mem now to avoid the memleak warning */
 	atomic_sub(IP_SFLSIZE(psf->sl_max), &sk->sk_omem_alloc);
-	call_rcu(&psf->rcu, ip_sf_socklist_reclaim);
+	kfree_rcu(psf, rcu);
 	return err;
 }
 
@@ -2020,7 +2014,7 @@ int ip_mc_source(int add, int omode, struct sock *sk, struct
 				newpsl->sl_addr[i] = psl->sl_addr[i];
 			/* decrease mem now to avoid the memleak warning */
 			atomic_sub(IP_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
-			call_rcu(&psl->rcu, ip_sf_socklist_reclaim);
+			kfree_rcu(psl, rcu);
 		}
 		rcu_assign_pointer(pmc->sflist, newpsl);
 		psl = newpsl;
@@ -2121,7 +2115,7 @@ int ip_mc_msfilter(struct sock *sk, struct ip_msfilter *msf, int ifindex)
 			psl->sl_count, psl->sl_addr, 0);
 		/* decrease mem now to avoid the memleak warning */
 		atomic_sub(IP_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
-		call_rcu(&psl->rcu, ip_sf_socklist_reclaim);
+		kfree_rcu(psl, rcu);
 	} else
 		(void) ip_mc_del_src(in_dev, &msf->imsf_multiaddr, pmc->sfmode,
 			0, NULL, 0);
-- 
1.7.3.2

