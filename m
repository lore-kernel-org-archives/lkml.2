Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab1EAN30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:29:26 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53949 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab1EANWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 70/86] net,rcu: convert call_rcu(xt_osf_finger_free_rcu) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:50 -0700
Message-Id: <1304256126-26015-70-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback xt_osf_finger_free_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(xt_osf_finger_free_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/netfilter/xt_osf.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index 4327e10..846f895 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -62,13 +62,6 @@ static const struct nla_policy xt_osf_policy[OSF_ATTR_MAX + 1] = {
 	[OSF_ATTR_FINGER]	= { .len = sizeof(struct xt_osf_user_finger) },
 };
 
-static void xt_osf_finger_free_rcu(struct rcu_head *rcu_head)
-{
-	struct xt_osf_finger *f = container_of(rcu_head, struct xt_osf_finger, rcu_head);
-
-	kfree(f);
-}
-
 static int xt_osf_add_callback(struct sock *ctnl, struct sk_buff *skb,
 			       const struct nlmsghdr *nlh,
 			       const struct nlattr * const osf_attrs[])
@@ -133,7 +126,7 @@ static int xt_osf_remove_callback(struct sock *ctnl, struct sk_buff *skb,
 		 * We are protected by nfnl mutex.
 		 */
 		list_del_rcu(&sf->finger_entry);
-		call_rcu(&sf->rcu_head, xt_osf_finger_free_rcu);
+		kfree_rcu(sf, rcu_head);
 
 		err = 0;
 		break;
@@ -414,7 +407,7 @@ static void __exit xt_osf_fini(void)
 
 		list_for_each_entry_rcu(f, &xt_osf_fingers[i], finger_entry) {
 			list_del_rcu(&f->finger_entry);
-			call_rcu(&f->rcu_head, xt_osf_finger_free_rcu);
+			kfree_rcu(f, rcu_head);
 		}
 	}
 	rcu_read_unlock();
-- 
1.7.3.2

