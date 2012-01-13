Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414Ab2AMP47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:56:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:1497 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932584Ab2AMPzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:55:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95530497"
From: Alex Shi <alex.shi@intel.com>
To: linux-kernel@vger.kernel.org, cl@gentwo.org, eric.dumazet@gmail.com,
        tglx@linutronix.de, avi@redhat.com, akpm@linux-foundation.org,
        davem@davemloft.net, kaber@trash.net, a.p.zijlstra@chello.nl,
        ying.huang@intel.com, konrad.wilk@oracle.com, hpa@zytor.com,
        jeremy@goop.org
Subject: [PATCH v2 1/5] net: use this_cpu_xxx replace percpu_xxx funcs
Date: Fri, 13 Jan 2012 23:53:34 +0800
Message-Id: <1326470018-22342-2-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1326470018-22342-1-git-send-email-alex.shi@intel.com>
References: <1326470018-22342-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_xxx funcs are duplicated with this_cpu_xxx funcs, so replace them
for further code clean up.

And in preempt safe scenario, __this_cpu_xxx funcs has a bit better
performance since __this_cpu_xxx has no redundant preempt_disable()

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
---
 net/netfilter/xt_TEE.c |   12 ++++++------
 net/socket.c           |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 3aae66f..f81eba4 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -87,7 +87,7 @@ tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct xt_tee_tginfo *info = par->targinfo;
 	struct iphdr *iph;
 
-	if (percpu_read(tee_active))
+	if (__this_cpu_read(tee_active))
 		return XT_CONTINUE;
 	/*
 	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE for
@@ -124,9 +124,9 @@ tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	ip_send_check(iph);
 
 	if (tee_tg_route4(skb, info)) {
-		percpu_write(tee_active, true);
+		__this_cpu_write(tee_active, true);
 		ip_local_out(skb);
-		percpu_write(tee_active, false);
+		__this_cpu_write(tee_active, false);
 	} else {
 		kfree_skb(skb);
 	}
@@ -167,7 +167,7 @@ tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tee_tginfo *info = par->targinfo;
 
-	if (percpu_read(tee_active))
+	if (__this_cpu_read(tee_active))
 		return XT_CONTINUE;
 	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (skb == NULL)
@@ -185,9 +185,9 @@ tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 		--iph->hop_limit;
 	}
 	if (tee_tg_route6(skb, info)) {
-		percpu_write(tee_active, true);
+		__this_cpu_write(tee_active, true);
 		ip6_local_out(skb);
-		percpu_write(tee_active, false);
+		__this_cpu_write(tee_active, false);
 	} else {
 		kfree_skb(skb);
 	}
diff --git a/net/socket.c b/net/socket.c
index 28a96af..784d93a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -479,7 +479,7 @@ static struct socket *sock_alloc(void)
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
 
-	percpu_add(sockets_in_use, 1);
+	this_cpu_add(sockets_in_use, 1);
 	return sock;
 }
 
@@ -522,7 +522,7 @@ void sock_release(struct socket *sock)
 	if (rcu_dereference_protected(sock->wq, 1)->fasync_list)
 		printk(KERN_ERR "sock_release: fasync list not empty!\n");
 
-	percpu_sub(sockets_in_use, 1);
+	this_cpu_sub(sockets_in_use, 1);
 	if (!sock->file) {
 		iput(SOCK_INODE(sock));
 		return;
-- 
1.6.3.3

