Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab0C3X1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:27:49 -0400
Received: from kroah.org ([198.145.64.141]:46794 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756959Ab0C3XWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:22:00 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:51 2010
Message-Id: <20100330224851.138052328@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Pablo Neira Ayuso <pablo@netfilter.org>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [139/156] netfilter: ctnetlink: fix reliable event delivery if message building fails
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 37b7ef7203240b3aba577bb1ff6765fe15225976 ]

This patch fixes a bug that allows to lose events when reliable
event delivery mode is used, ie. if NETLINK_BROADCAST_SEND_ERROR
and NETLINK_RECV_NO_ENOBUFS socket options are set.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/netfilter/nfnetlink.h  |    2 +-
 net/netfilter/nf_conntrack_netlink.c |    3 ++-
 net/netfilter/nfnetlink.c            |    4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -76,7 +76,7 @@ extern int nfnetlink_subsys_unregister(c
 extern int nfnetlink_has_listeners(unsigned int group);
 extern int nfnetlink_send(struct sk_buff *skb, u32 pid, unsigned group, 
 			  int echo, gfp_t flags);
-extern void nfnetlink_set_err(u32 pid, u32 group, int error);
+extern int nfnetlink_set_err(u32 pid, u32 group, int error);
 extern int nfnetlink_unicast(struct sk_buff *skb, u_int32_t pid, int flags);
 
 extern void nfnl_lock(void);
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -571,7 +571,8 @@ nla_put_failure:
 nlmsg_failure:
 	kfree_skb(skb);
 errout:
-	nfnetlink_set_err(0, group, -ENOBUFS);
+	if (nfnetlink_set_err(0, group, -ENOBUFS) > 0)
+		return -ENOBUFS;
 	return 0;
 }
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -114,9 +114,9 @@ int nfnetlink_send(struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(nfnetlink_send);
 
-void nfnetlink_set_err(u32 pid, u32 group, int error)
+int nfnetlink_set_err(u32 pid, u32 group, int error)
 {
-	netlink_set_err(nfnl, pid, group, error);
+	return netlink_set_err(nfnl, pid, group, error);
 }
 EXPORT_SYMBOL_GPL(nfnetlink_set_err);
 


