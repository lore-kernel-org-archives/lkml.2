Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946034Ab2I1VLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:11:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49493 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759529Ab2I1Uko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:40:44 -0400
X-Sasl-enc: VbEJrHsHGDLS5CGjs2bpz+UpraLq49y1VSl55DutZcXa 1348864843
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 020/127] netlink: fix possible spoofing from non-root processes
Date: Fri, 28 Sep 2012 13:33:13 -0700
Message-Id: <20120928203048.182179289@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/af_netlink.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1345,7 +1345,8 @@ static int netlink_sendmsg(struct kiocb
 		dst_pid = addr->nl_pid;
 		dst_group = ffs(addr->nl_groups);
 		err =  -EPERM;
-		if (dst_group && !netlink_capable(sock, NL_NONROOT_SEND))
+		if ((dst_group || dst_pid) &&
+		    !netlink_capable(sock, NL_NONROOT_SEND))
 			goto out;
 	} else {
 		dst_pid = nlk->dst_pid;
@@ -2098,6 +2099,7 @@ static void __init netlink_add_usersock_
 	rcu_assign_pointer(nl_table[NETLINK_USERSOCK].listeners, listeners);
 	nl_table[NETLINK_USERSOCK].module = THIS_MODULE;
 	nl_table[NETLINK_USERSOCK].registered = 1;
+	nl_table[NETLINK_USERSOCK].nl_nonroot = NL_NONROOT_SEND;
 
 	netlink_table_ungrab();
 }


