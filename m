Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934327Ab0EUQ4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:56:55 -0400
Received: from kroah.org ([198.145.64.141]:39177 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934221Ab0EUQyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:40 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/38] netlink: Implment netlink_broadcast_filtered
Date: Fri, 21 May 2010 09:54:05 -0700
Message-Id: <1274460848-11377-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

When netlink sockets are used to convey data that is in a namespace
we need a way to select a subset of the listening sockets to deliver
the packet to.  For the network namespace we have been doing this
by only transmitting packets in the correct network namespace.

For data belonging to other namespaces netlink_bradcast_filtered
provides a mechanism that allows us to examine the destination
socket and to decide if we should transmit the specified packet
to it.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/netlink.h  |    4 ++++
 net/netlink/af_netlink.c |   21 +++++++++++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 6eaca5e..59d0669 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -188,6 +188,10 @@ extern int netlink_has_listeners(struct sock *sk, unsigned int group);
 extern int netlink_unicast(struct sock *ssk, struct sk_buff *skb, __u32 pid, int nonblock);
 extern int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, __u32 pid,
 			     __u32 group, gfp_t allocation);
+extern int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
+	__u32 pid, __u32 group, gfp_t allocation,
+	int (*filter)(struct sock *dsk, struct sk_buff *skb, void *data),
+	void *filter_data);
 extern int netlink_set_err(struct sock *ssk, __u32 pid, __u32 group, int code);
 extern int netlink_register_notifier(struct notifier_block *nb);
 extern int netlink_unregister_notifier(struct notifier_block *nb);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 6464a19..a2eb965 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -978,6 +978,8 @@ struct netlink_broadcast_data {
 	int delivered;
 	gfp_t allocation;
 	struct sk_buff *skb, *skb2;
+	int (*tx_filter)(struct sock *dsk, struct sk_buff *skb, void *data);
+	void *tx_data;
 };
 
 static inline int do_one_broadcast(struct sock *sk,
@@ -1020,6 +1022,9 @@ static inline int do_one_broadcast(struct sock *sk,
 		p->failure = 1;
 		if (nlk->flags & NETLINK_BROADCAST_SEND_ERROR)
 			p->delivery_failure = 1;
+	} else if (p->tx_filter && p->tx_filter(sk, p->skb2, p->tx_data)) {
+		kfree_skb(p->skb2);
+		p->skb2 = NULL;
 	} else if (sk_filter(sk, p->skb2)) {
 		kfree_skb(p->skb2);
 		p->skb2 = NULL;
@@ -1038,8 +1043,10 @@ out:
 	return 0;
 }
 
-int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 pid,
-		      u32 group, gfp_t allocation)
+int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb, u32 pid,
+	u32 group, gfp_t allocation,
+	int (*filter)(struct sock *dsk, struct sk_buff *skb, void *data),
+	void *filter_data)
 {
 	struct net *net = sock_net(ssk);
 	struct netlink_broadcast_data info;
@@ -1059,6 +1066,8 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 pid,
 	info.allocation = allocation;
 	info.skb = skb;
 	info.skb2 = NULL;
+	info.tx_filter = filter;
+	info.tx_data = filter_data;
 
 	/* While we sleep in clone, do not allow to change socket list */
 
@@ -1083,6 +1092,14 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 pid,
 	}
 	return -ESRCH;
 }
+EXPORT_SYMBOL(netlink_broadcast_filtered);
+
+int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 pid,
+		      u32 group, gfp_t allocation)
+{
+	return netlink_broadcast_filtered(ssk, skb, pid, group, allocation,
+		NULL, NULL);
+}
 EXPORT_SYMBOL(netlink_broadcast);
 
 struct netlink_set_err_data {
-- 
1.7.0.3

