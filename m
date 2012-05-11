Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab2EKIBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:01:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:6295 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756863Ab2EKIBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:01:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="139414087"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, tj@kernel.org,
        cl@linux-foundation.org, tony.luck@intel.com, bp@amd64.org,
        davem@davemloft.net
Cc: akpm@linux-foundation.org, ebiederm@xmission.com, sfr@canb.auug.org.au,
        alex.shi@intel.com, luto@mit.edu, glommer@parallels.com,
        fernando@oss.ntt.co.jp, vapier@gentoo.org, eric.dumazet@gmail.com,
        dzickus@redhat.com, dhowells@redhat.com, cbouatmailru@gmail.com,
        fenghua.yu@intel.com, jkosina@suse.cz, ext-phil.2.carmody@nokia.com,
        dan.carpenter@oracle.com, len.brown@intel.com, fweisbec@gmail.com,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org, anton@samba.org,
        kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] net: replace percpu_xxx funcs with this_cpu_xxx or __this_cpu_xxx
Date: Fri, 11 May 2012 16:00:13 +0800
Message-Id: <1336723215-16660-2-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336723215-16660-1-git-send-email-alex.shi@intel.com>
References: <1336723215-16660-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_xxx funcs are duplicated with this_cpu_xxx funcs, so replace
them for further code clean up.

And in preempt safe scenario, __this_cpu_xxx funcs may has a bit
better performance since __this_cpu_xxx has no redundant
preempt_enable/preempt_disable on some architectures.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 net/netfilter/xt_TEE.c |   12 ++++++------
 net/socket.c           |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 4d50579..ee2e5bc 100644
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
@@ -168,7 +168,7 @@ tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tee_tginfo *info = par->targinfo;
 
-	if (percpu_read(tee_active))
+	if (__this_cpu_read(tee_active))
 		return XT_CONTINUE;
 	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (skb == NULL)
@@ -186,9 +186,9 @@ tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
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
index 851edcd..08e873a 100644
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
1.7.5.4

