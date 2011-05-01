Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab1EANaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:30:17 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44622 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757091Ab1EANWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 47/86] net,rcu: convert call_rcu(fc_rport_free_rcu) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:27 -0700
Message-Id: <1304256126-26015-47-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback fc_rport_free_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(fc_rport_free_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/ipv4/fib_semantics.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 641a5a2..33e2c35 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -141,18 +141,8 @@ const struct fib_prop fib_props[RTN_MAX + 1] = {
 	},
 };
 
-
 /* Release a nexthop info record */
 
-static void free_fib_info_rcu(struct rcu_head *head)
-{
-	struct fib_info *fi = container_of(head, struct fib_info, rcu);
-
-	if (fi->fib_metrics != (u32 *) dst_default_metrics)
-		kfree(fi->fib_metrics);
-	kfree(fi);
-}
-
 void free_fib_info(struct fib_info *fi)
 {
 	if (fi->fib_dead == 0) {
@@ -166,7 +156,7 @@ void free_fib_info(struct fib_info *fi)
 	} endfor_nexthops(fi);
 	fib_info_cnt--;
 	release_net(fi->fib_net);
-	call_rcu(&fi->rcu, free_fib_info_rcu);
+	kfree_rcu(fi, rcu);
 }
 
 void fib_release_info(struct fib_info *fi)
-- 
1.7.3.2

