Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab0C0Phj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 11:37:39 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43313 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621Ab0C0Phh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 11:37:37 -0400
Message-Id: <20100327153619.071289237@efficios.com>
References: <20100327153233.993367557@efficios.com>
User-Agent: quilt/0.46-1
Date: Sat, 27 Mar 2010 11:32:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com
Subject: [patch 2/6] commit afd066d60b77e28651bb8323fc8cfcedacc5cbf8 Author: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> Date: Sat Mar 27 10:53:30 2010 -0400
Content-Disposition: inline; filename=revert-netfilter-dont-use-init-rcu-head.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat, 27 Mar 2010 15:36:19 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Revert "netfilter: don't use INIT_RCU_HEAD()"
    
    This reverts commit ca1c2e2da9637c131436bf6d6ae41b58f5353afe.
    
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

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index acb29cc..d9f8a22 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -239,6 +239,7 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 
 	new->master = me;
 	atomic_set(&new->use, 1);
+	INIT_RCU_HEAD(&new->rcu);
 	return new;
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index fdc8fb4..fef95be 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -59,6 +59,7 @@ nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
 	if (!*ext)
 		return NULL;
 
+	INIT_RCU_HEAD(&(*ext)->rcu);
 	(*ext)->offset[id] = off;
 	(*ext)->len = len;
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 7ba4abc..90cf36d 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -112,6 +112,7 @@ instance_create(u_int16_t queue_num, int pid)
 	inst->copy_mode = NFQNL_COPY_NONE;
 	spin_lock_init(&inst->lock);
 	INIT_LIST_HEAD(&inst->queue_list);
+	INIT_RCU_HEAD(&inst->rcu);
 
 	if (!try_module_get(THIS_MODULE)) {
 		err = -EAGAIN;

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
