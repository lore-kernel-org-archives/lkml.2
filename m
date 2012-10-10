Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab2JJXCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:02:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52478 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757164Ab2JJXCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:02:02 -0400
X-Sasl-enc: RzN3dIL3H87PkUqp5rnkNbgO3Ui5OxodauRPjVEXb8FZ 1349910121
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 036/122] ipv6: del unreachable route when an addr is deleted on lo
Date: Thu, 11 Oct 2012 07:53:22 +0900
Message-Id: <20121010225344.645263127@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 64c6d08e6490fb18cea09bb03686c149946bd818 ]

When an address is added on loopback (ip -6 a a 2002::1/128 dev lo), two routes
are added:
 - one in the local table:
    local 2002::1 via :: dev lo  proto none  metric 0
 - one the in main table (for the prefix):
    unreachable 2002::1 dev lo  proto kernel  metric 256  error -101

When the address is deleted, the route inserted in the main table remains
because we use rt6_lookup(), which returns NULL when dst->error is set, which
is the case here! Thus, it is better to use ip6_route_lookup() to avoid this
kind of filter.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -788,10 +788,16 @@ static void ipv6_del_addr(struct inet6_i
 		struct in6_addr prefix;
 		struct rt6_info *rt;
 		struct net *net = dev_net(ifp->idev->dev);
+		struct flowi6 fl6 = {};
+
 		ipv6_addr_prefix(&prefix, &ifp->addr, ifp->prefix_len);
-		rt = rt6_lookup(net, &prefix, NULL, ifp->idev->dev->ifindex, 1);
+		fl6.flowi6_oif = ifp->idev->dev->ifindex;
+		fl6.daddr = prefix;
+		rt = (struct rt6_info *)ip6_route_lookup(net, &fl6,
+							 RT6_LOOKUP_F_IFACE);
 
-		if (rt && addrconf_is_prefix_route(rt)) {
+		if (rt != net->ipv6.ip6_null_entry &&
+		    addrconf_is_prefix_route(rt)) {
 			if (onlink == 0) {
 				ip6_del_rt(rt);
 				rt = NULL;


