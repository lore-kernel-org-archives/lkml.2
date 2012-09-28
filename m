Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032081Ab2I1V4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:56:42 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:37576 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031968Ab2I1UWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:22:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 024/218] netlink: fix possible spoofing from non-root processes
Date: Fri, 28 Sep 2012 13:14:01 -0700
Message-Id: <20120928201504.135991932@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
---
 net/netlink/af_netlink.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1340,7 +1340,8 @@ static int netlink_sendmsg(struct kiocb
 		dst_pid = addr->nl_pid;
 		dst_group = ffs(addr->nl_groups);
 		err =  -EPERM;
-		if (dst_group && !netlink_capable(sock, NL_NONROOT_SEND))
+		if ((dst_group || dst_pid) &&
+		    !netlink_capable(sock, NL_NONROOT_SEND))
 			goto out;
 	} else {
 		dst_pid = nlk->dst_pid;
@@ -2115,6 +2116,7 @@ static void __init netlink_add_usersock_
 	rcu_assign_pointer(nl_table[NETLINK_USERSOCK].listeners, listeners);
 	nl_table[NETLINK_USERSOCK].module = THIS_MODULE;
 	nl_table[NETLINK_USERSOCK].registered = 1;
+	nl_table[NETLINK_USERSOCK].nl_nonroot = NL_NONROOT_SEND;
 
 	netlink_table_ungrab();
 }


