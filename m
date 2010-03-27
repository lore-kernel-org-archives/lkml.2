Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0C0PhI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 11:37:08 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43247 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab0C0PhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 11:37:06 -0400
Message-Id: <20100327153619.331014310@efficios.com>
References: <20100327153233.993367557@efficios.com>
User-Agent: quilt/0.46-1
Date: Sat, 27 Mar 2010 11:32:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com
Subject: [patch 3/6] commit 418b6f2c2ddba7c91d1186b68618092910260c32 Author: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> Date: Sat Mar 27 11:05:38 2010 -0400
Content-Disposition: inline; filename=revert-net-dont-use-init-rcu-head.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat, 27 Mar 2010 15:36:19 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Revert "net: don't use INIT_RCU_HEAD"
    
    This reverts commit 93adcc80f3288f1827baf6f821af818f6eeef7f9.
    
    Conflicts (resolved):
    
    	net/core/net_namespace.c
    
    If we ever want to be able to properly detect double rcu_head activation, we
    need to separate the initialization from call_rcu().
    
    Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
    CC: akpm@linux-foundation.org
    CC: mingo@elte.hu
    CC: laijs@cn.fujitsu.com
    CC: dipankar@in.ibm.com
    CC: josh@joshtriplett.org
    CC: dvhltc@us.ibm.com
    CC: niv@us.ibm.com
    CC: tglx@linutronix.de
    CC: peterz@infradead.org
    CC: rostedt@goodmis.org
    CC: Valdis.Kletnieks@vt.edu
    CC: dhowells@redhat.com
    CC: eric.dumazet@gmail.com
    CC: Alexey Dobriyan <adobriyan@gmail.com>

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 6cee643..99d6ac9 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1346,6 +1346,7 @@ struct neigh_parms *neigh_parms_alloc(struct net_device *dev,
 	if (p) {
 		p->tbl		  = tbl;
 		atomic_set(&p->refcnt, 1);
+		INIT_RCU_HEAD(&p->rcu_head);
 		p->reachable_time =
 				neigh_rand_reach_time(p->base_reachable_time);
 
@@ -1413,6 +1414,7 @@ void neigh_table_init_no_netlink(struct neigh_table *tbl)
 
 	write_pnet(&tbl->parms.net, &init_net);
 	atomic_set(&tbl->parms.refcnt, 1);
+	INIT_RCU_HEAD(&tbl->parms.rcu_head);
 	tbl->parms.reachable_time =
 			  neigh_rand_reach_time(tbl->parms.base_reachable_time);
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index bd8c471..cad70c6 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -124,8 +124,10 @@ static struct net_generic *net_alloc_generic(void)
 		INITIAL_NET_GEN_PTRS * sizeof(void *);
 
 	ng = kzalloc(generic_size, GFP_KERNEL);
-	if (ng)
+	if (ng) {
 		ng->len = INITIAL_NET_GEN_PTRS;
+		INIT_RCU_HEAD(&ng->rcu);
+	}
 
 	return ng;
 }
@@ -563,6 +565,7 @@ int net_assign_generic(struct net *net, int id, void *data)
 	 */
 
 	ng->len = id;
+	INIT_RCU_HEAD(&ng->rcu);
 	memcpy(&ng->ptr, &old_ng->ptr, old_ng->len * sizeof(void*));
 
 	rcu_assign_pointer(net->gen, ng);
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 1e029dc..231972b 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -502,6 +502,7 @@ int cipso_v4_doi_add(struct cipso_v4_doi *doi_def,
 	}
 
 	atomic_set(&doi_def->refcount, 1);
+	INIT_RCU_HEAD(&doi_def->rcu);
 
 	spin_lock(&cipso_v4_doi_list_lock);
 	if (cipso_v4_doi_search(doi_def->doi) != NULL) {
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 51ca946..3088271 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -112,7 +112,13 @@ static inline void devinet_sysctl_unregister(struct in_device *idev)
 
 static struct in_ifaddr *inet_alloc_ifa(void)
 {
-	return kzalloc(sizeof(struct in_ifaddr), GFP_KERNEL);
+	struct in_ifaddr *ifa = kzalloc(sizeof(*ifa), GFP_KERNEL);
+
+	if (ifa) {
+		INIT_RCU_HEAD(&ifa->rcu_head);
+	}
+
+	return ifa;
 }
 
 static void inet_rcu_free_ifa(struct rcu_head *head)
@@ -155,6 +161,7 @@ static struct in_device *inetdev_init(struct net_device *dev)
 	in_dev = kzalloc(sizeof(*in_dev), GFP_KERNEL);
 	if (!in_dev)
 		goto out;
+	INIT_RCU_HEAD(&in_dev->rcu_head);
 	memcpy(&in_dev->cnf, dev_net(dev)->ipv4.devconf_dflt,
 			sizeof(in_dev->cnf));
 	in_dev->cnf.sysctl = NULL;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 54fd68c..ba42180 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1434,6 +1434,7 @@ void ip_rt_redirect(__be32 old_gw, __be32 daddr, __be32 new_gw,
 
 				/* Copy all the information. */
 				*rt = *rth;
+				INIT_RCU_HEAD(&rt->u.dst.rcu_head);
 				rt->u.dst.__use		= 1;
 				atomic_set(&rt->u.dst.__refcnt, 1);
 				rt->u.dst.child		= NULL;

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
