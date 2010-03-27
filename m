Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab0C0Phc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 11:37:32 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43291 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab0C0Phb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 11:37:31 -0400
Message-Id: <20100327153618.821249363@efficios.com>
References: <20100327153233.993367557@efficios.com>
User-Agent: quilt/0.46-1
Date: Sat, 27 Mar 2010 11:32:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com
Subject: [patch 1/6] commit 501fdb3aeeb2444f86d289a4a044cf7c8fbc17df Author: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> Date: Sat Mar 27 10:52:11 2010 -0400
Content-Disposition: inline; filename=revert-net-remove-init-rcu-head-usage.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat, 27 Mar 2010 15:36:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Revert "net: remove INIT_RCU_HEAD() usage"
    
    This reverts commit dc4c2c31053ba5bf685d273cd62ecca406dddb2d.
    
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

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index f8c8749..b8e9d3a 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -296,6 +296,7 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 
 		new_stat->dev = dev;
 		new_stat->last_rx = jiffies;
+		INIT_RCU_HEAD(&new_stat->rcu);
 		spin_lock(&trace_state_lock);
 		list_add_rcu(&new_stat->list, &hw_stats_list);
 		spin_unlock(&trace_state_lock);
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index b1eea81..51eb389 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -363,6 +363,7 @@ ipip6_tunnel_add_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a, int chg)
 		goto out;
 	}
 
+	INIT_RCU_HEAD(&p->rcu_head);
 	p->next = t->prl;
 	p->addr = a->addr;
 	p->flags = a->flags;
diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index fa85a7d..ddce21e 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -161,6 +161,7 @@ alloc_spi:
 	if (!x6spi)
 		goto out;
 
+	INIT_RCU_HEAD(&x6spi->rcu_head);
 	memcpy(&x6spi->addr, saddr, sizeof(x6spi->addr));
 	x6spi->spi = spi;
 	atomic_set(&x6spi->refcnt, 1);
diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
index 0bfeaab..c5d9f97 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -315,6 +315,7 @@ int netlbl_domhsh_add(struct netlbl_dom_map *entry,
 		entry_old = netlbl_domhsh_search_def(entry->domain);
 	if (entry_old == NULL) {
 		entry->valid = 1;
+		INIT_RCU_HEAD(&entry->rcu);
 
 		if (entry->domain != NULL) {
 			u32 bkt = netlbl_domhsh_hash(entry->domain);
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 852d9d7..98ed22e 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -327,6 +327,7 @@ static int netlbl_unlhsh_add_addr4(struct netlbl_unlhsh_iface *iface,
 	entry->list.addr = addr->s_addr & mask->s_addr;
 	entry->list.mask = mask->s_addr;
 	entry->list.valid = 1;
+	INIT_RCU_HEAD(&entry->rcu);
 	entry->secid = secid;
 
 	spin_lock(&netlbl_unlhsh_lock);
@@ -372,6 +373,7 @@ static int netlbl_unlhsh_add_addr6(struct netlbl_unlhsh_iface *iface,
 	entry->list.addr.s6_addr32[3] &= mask->s6_addr32[3];
 	ipv6_addr_copy(&entry->list.mask, mask);
 	entry->list.valid = 1;
+	INIT_RCU_HEAD(&entry->rcu);
 	entry->secid = secid;
 
 	spin_lock(&netlbl_unlhsh_lock);
@@ -408,6 +410,7 @@ static struct netlbl_unlhsh_iface *netlbl_unlhsh_add_iface(int ifindex)
 	INIT_LIST_HEAD(&iface->addr4_list);
 	INIT_LIST_HEAD(&iface->addr6_list);
 	iface->valid = 1;
+	INIT_RCU_HEAD(&iface->rcu);
 
 	spin_lock(&netlbl_unlhsh_lock);
 	if (ifindex > 0) {
diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index bef1337..13a6fba 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -186,6 +186,7 @@ int sctp_add_bind_addr(struct sctp_bind_addr *bp, union sctp_addr *new,
 	addr->valid = 1;
 
 	INIT_LIST_HEAD(&addr->list);
+	INIT_RCU_HEAD(&addr->rcu);
 
 	/* We always hold a socket lock when calling this function,
 	 * and that acts as a writer synchronizing lock.
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 1d7ac70..cc50fbe 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -381,6 +381,7 @@ static void sctp_v6_copy_addrlist(struct list_head *addrlist,
 			addr->a.v6.sin6_scope_id = dev->ifindex;
 			addr->valid = 1;
 			INIT_LIST_HEAD(&addr->list);
+			INIT_RCU_HEAD(&addr->rcu);
 			list_add_tail(&addr->list, addrlist);
 		}
 	}
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index e771690..9687177 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -188,6 +188,7 @@ static void sctp_v4_copy_addrlist(struct list_head *addrlist,
 			addr->a.v4.sin_addr.s_addr = ifa->ifa_local;
 			addr->valid = 1;
 			INIT_LIST_HEAD(&addr->list);
+			INIT_RCU_HEAD(&addr->rcu);
 			list_add_tail(&addr->list, addrlist);
 		}
 	}

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
