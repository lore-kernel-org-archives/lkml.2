Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab0LCNjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 08:39:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50735 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab0LCNjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 08:39:06 -0500
Date: Fri, 3 Dec 2010 14:39:03 +0100
From: Holger Eitzenberger <holger@eitzenberger.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: ctnetlink loop
Message-ID: <20101203133903.GG13225@mail.eitzenberger.org>
Mail-Followup-To: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Provags-ID: V02:K0:WyXh7Uk24QKKweYUvXbGUbIfeSJiLWw7gCuZOjWmu3b
 A6SOA/x6oaHvwXkEsiJ+elFJf2JTTJgXd9crB0lO5tqVw4VS81
 /1ne9WCGVhb4MZVR8Xyx6icmDRYa5JvMh8XBBi5eJN9omwW3yY
 PRZmqg1m3cl/RnWIM0PWzXCczblLZ8idQvLz2fz6VUcMWvrqKy
 huCBCPrvIB+BxMHFlWg3FFZwO1oDG0g0a8LouOEQ4I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I see a problem with how ctnetlink GET requests are being
processed in the kernel (2.6.32.24) under high load.

Initially I saw this problem on a large performance testing
system when getting HTTP proxy performance numbers, but lately
there have been two reports on large customers boxes (both
many-core with 10G NICs).

The sympton is Netlink looping around nfnetlink_rcv_msg(),
which is just because netlink_unicast() came back with -EAGAIN
when trying to write the newly created Netlink skb to the SK
receive buffer in ctnetlink_get_conntrack().  In this case a
(possibly) infinit loop is entered.  Mostly infinit in fact in
case the userland party trying to receive those messages may
be stuck in the sendmsg() call, being unable to read anything
if being single threaded.

I tried to reproduce several times, a few times the loop
disappeared and the box proceeded normally after some time.
I have no explanation for this.

The attached patch tries to solve it by simple not trying
again to netlink_unicast() the reply skb and just fail with
-ENOBUFS.  The reasoning is that at the point a Netlink overrun
is observed it seems counter intuitive to insist on sending
one more Netlink message.

I checked for possible side effects to other Netlink requests,
please check.

The patch applies to net-next-2.6.

Feedback appreciated.

 /holger


--AhhlLboLdkugWU4S
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="nfnl-fix.diff"

nfnetlink: avoid unbound loop on busy Netlink socket

I see a problem with how ctnetlink GET requests are being
processed in the kernel (2.6.32.24) under high load.

The sympton is Netlink looping around nfnetlink_rcv_msg(), which
is just because netlink_unicast() came back with EAGAIN when
trying to write the newly created Netlink skb to the SK receive
buffer in ctnetlink_get_conntrack().  In this case a (possibly)
infinit loop is entered.  Mostly infinit I think in case the
userland party trying to receive those messages may be stuck in
the sendmsg() call, being unable to read anything if being single
threaded.

I tried to reproduce several times, a few times the loop
disappeared and the box proceeded normally after some minutes.
I have no explanation for this.

The attached patch tries to solve it by simple not trying again
to netlink_unicast() the reply skb and just fail with -ENOBUFS.
The reasoning is that at the point a Netlink overrun is detected
it seems counter intuitive to insist on sending one more Netlink
message.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: net-next-2.6/net/netfilter/nfnetlink.c
===================================================================
--- net-next-2.6.orig/net/netfilter/nfnetlink.c	2010-12-03 14:33:32.000000000 +0100
+++ net-next-2.6/net/netfilter/nfnetlink.c	2010-12-03 14:34:21.000000000 +0100
@@ -138,7 +138,6 @@
 		return 0;
 
 	type = nlh->nlmsg_type;
-replay:
 	ss = nfnetlink_get_subsys(type);
 	if (!ss) {
 #ifdef CONFIG_MODULES
@@ -169,7 +168,7 @@
 
 		err = nc->call(net->nfnl, skb, nlh, (const struct nlattr **)cda);
 		if (err == -EAGAIN)
-			goto replay;
+			err = -ENOBUFS;
 		return err;
 	}
 }

--AhhlLboLdkugWU4S--
