Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562Ab1EAN34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:29:56 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38972 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757253Ab1EANWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:36 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 64/86] net,rcu: convert call_rcu(__nf_ct_ext_free_rcu) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:44 -0700
Message-Id: <1304256126-26015-64-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback __nf_ct_ext_free_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(__nf_ct_ext_free_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/netfilter/nf_conntrack_extend.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 80a23ed..05ecdc2 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -68,12 +68,6 @@ nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
 	return (void *)(*ext) + off;
 }
 
-static void __nf_ct_ext_free_rcu(struct rcu_head *head)
-{
-	struct nf_ct_ext *ext = container_of(head, struct nf_ct_ext, rcu);
-	kfree(ext);
-}
-
 void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 {
 	struct nf_ct_ext *old, *new;
@@ -114,7 +108,7 @@ void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 					(void *)old + old->offset[i]);
 			rcu_read_unlock();
 		}
-		call_rcu(&old->rcu, __nf_ct_ext_free_rcu);
+		kfree_rcu(old, rcu);
 		ct->ext = new;
 	}
 
-- 
1.7.3.2

