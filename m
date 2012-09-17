Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2IQBJn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:09:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33736 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060Ab2IQAun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:43 -0400
Message-Id: <20120917003636.020007232@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:36 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 071/135] netlink: fix possible spoofing from non-root processes
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 20e1db19db5d6b9e4e83021595eab0dc8f107bef ]

Non-root user-space processes can send Netlink messages to other
processes that are well-known for being subscribed to Netlink
asynchronous notifications. This allows ilegitimate non-root
process to send forged messages to Netlink subscribers.

The userspace process usually verifies the legitimate origin in
two ways:

a) Socket credentials. If UID != 0, then the message comes from
   some ilegitimate process and the message needs to be dropped.

b) Netlink portID. In general, portID == 0 means that the origin
   of the messages comes from the kernel. Thus, discarding any
   message not coming from the kernel.

However, ctnetlink sets the portID in event messages that has
been triggered by some user-space process, eg. conntrack utility.
So other processes subscribed to ctnetlink events, eg. conntrackd,
know that the event was triggered by some user-space action.

Neither of the two ways to discard ilegitimate messages coming
from non-root processes can help for ctnetlink.

This patch adds capability validation in case that dst_pid is set
in netlink_sendmsg(). This approach is aggressive since existing
applications using any Netlink bus to deliver messages between
two user-space processes will break. Note that the exception is
NETLINK_USERSOCK, since it is reserved for netlink-to-netlink
userspace communication.

Still, if anyone wants that his Netlink bus allows netlink-to-netlink
userspace, then they can set NL_NONROOT_SEND. However, by default,
I don't think it makes sense to allow to use NETLINK_ROUTE to
communicate two processes that are sending no matter what information
that is not related to link/neighbouring/routing. They should be using
NETLINK_USERSOCK instead for that.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/netlink/af_netlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 1af8542..38b78b9 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1344,7 +1344,8 @@ static int netlink_sendmsg(struct kiocb *kiocb, struct socket *sock,
 		dst_pid = addr->nl_pid;
 		dst_group = ffs(addr->nl_groups);
 		err =  -EPERM;
-		if (dst_group && !netlink_capable(sock, NL_NONROOT_SEND))
+		if ((dst_group || dst_pid) &&
+		    !netlink_capable(sock, NL_NONROOT_SEND))
 			goto out;
 	} else {
 		dst_pid = nlk->dst_pid;
@@ -2103,6 +2104,7 @@ static void __init netlink_add_usersock_entry(void)
 	rcu_assign_pointer(nl_table[NETLINK_USERSOCK].listeners, listeners);
 	nl_table[NETLINK_USERSOCK].module = THIS_MODULE;
 	nl_table[NETLINK_USERSOCK].registered = 1;
+	nl_table[NETLINK_USERSOCK].nl_nonroot = NL_NONROOT_SEND;
 
 	netlink_table_ungrab();
 }


