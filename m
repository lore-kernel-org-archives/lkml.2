Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934657Ab0EEAhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:37:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34755 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934266Ab0EEAhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:37:02 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>, <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue,  4 May 2010 17:36:46 -0700
Message-Id: <1273019809-16472-3-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1fx3hk6gw.fsf@fess.ebiederm.org>
References: <m1fx3hk6gw.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: gregkh@suse.de, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, eric.dumazet@gmail.com, bcrl@lhnet.ca, serue@us.ibm.com, netdev@vger.kernel.org, davem@davemloft.net, ebiederm@xmission.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 3/6] netlink: Implment netlink_broadcast_filtered
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
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
---
 include/linux/netlink.h  |    4 ++++
 net/netlink/af_netlink.c |   21 +++++++++++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index fde27c0..4f7bf4b 100644
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
 extern void netlink_set_err(struct sock *ssk, __u32 pid, __u32 group, int code);
 extern int netlink_register_notifier(struct notifier_block *nb);
 extern int netlink_unregister_notifier(struct notifier_block *nb);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 320d042..4f16d68 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -975,6 +975,8 @@ struct netlink_broadcast_data {
 	int delivered;
 	gfp_t allocation;
 	struct sk_buff *skb, *skb2;
+	int (*tx_filter)(struct sock *dsk, struct sk_buff *skb, void *data);
+	void *tx_data;
 };
 
 static inline int do_one_broadcast(struct sock *sk,
@@ -1017,6 +1019,9 @@ static inline int do_one_broadcast(struct sock *sk,
 		p->failure = 1;
 		if (nlk->flags & NETLINK_BROADCAST_SEND_ERROR)
 			p->delivery_failure = 1;
+	} else if (p->tx_filter && p->tx_filter(sk, p->skb2, p->tx_data)) {
+		kfree_skb(p->skb2);
+		p->skb2 = NULL;
 	} else if (sk_filter(sk, p->skb2)) {
 		kfree_skb(p->skb2);
 		p->skb2 = NULL;
@@ -1035,8 +1040,10 @@ out:
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
@@ -1056,6 +1063,8 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 pid,
 	info.allocation = allocation;
 	info.skb = skb;
 	info.skb2 = NULL;
+	info.tx_filter = filter;
+	info.tx_data = filter_data;
 
 	/* While we sleep in clone, do not allow to change socket list */
 
@@ -1080,6 +1089,14 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 pid,
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
1.6.5.2.143.g8cc62

