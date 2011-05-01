Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760518Ab1EANbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:31:35 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60582 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046Ab1EANWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 50/86] net,rcu: convert call_rcu(ip_mc_list_reclaim) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:30 -0700
Message-Id: <1304256126-26015-50-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback ip_mc_list_reclaim() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(ip_mc_list_reclaim).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/ipv4/igmp.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 1fd3d9c..f22f30e 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -149,17 +149,11 @@ static void ip_mc_clear_src(struct ip_mc_list *pmc);
 static int ip_mc_add_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 			 int sfcount, __be32 *psfsrc, int delta);
 
-
-static void ip_mc_list_reclaim(struct rcu_head *head)
-{
-	kfree(container_of(head, struct ip_mc_list, rcu));
-}
-
 static void ip_ma_put(struct ip_mc_list *im)
 {
 	if (atomic_dec_and_test(&im->refcnt)) {
 		in_dev_put(im->interface);
-		call_rcu(&im->rcu, ip_mc_list_reclaim);
+		kfree_rcu(im, rcu);
 	}
 }
 
-- 
1.7.3.2

