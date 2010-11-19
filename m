Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab0KSWDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:03:50 -0500
Received: from kroah.org ([198.145.64.141]:45319 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757586Ab0KSV65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:57 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:43 2010
Message-Id: <20101119215643.917694582@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [63/82] net: Fix IPv6 PMTU disc. w/ asymmetric routes
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Maciej Żenczykowski <maze@google.com>

[ Upstream commit ae878ae280bea286ff2b1e1cb6e609dd8cb4501d ]

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/route.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1559,14 +1559,13 @@ out:
  *	i.e. Path MTU discovery
  */
 
-void rt6_pmtu_discovery(struct in6_addr *daddr, struct in6_addr *saddr,
-			struct net_device *dev, u32 pmtu)
+static void rt6_do_pmtu_disc(struct in6_addr *daddr, struct in6_addr *saddr,
+			     struct net *net, u32 pmtu, int ifindex)
 {
 	struct rt6_info *rt, *nrt;
-	struct net *net = dev_net(dev);
 	int allfrag = 0;
 
-	rt = rt6_lookup(net, daddr, saddr, dev->ifindex, 0);
+	rt = rt6_lookup(net, daddr, saddr, ifindex, 0);
 	if (rt == NULL)
 		return;
 
@@ -1634,6 +1633,27 @@ out:
 	dst_release(&rt->u.dst);
 }
 
+void rt6_pmtu_discovery(struct in6_addr *daddr, struct in6_addr *saddr,
+			struct net_device *dev, u32 pmtu)
+{
+	struct net *net = dev_net(dev);
+
+	/*
+	 * RFC 1981 states that a node "MUST reduce the size of the packets it
+	 * is sending along the path" that caused the Packet Too Big message.
+	 * Since it's not possible in the general case to determine which
+	 * interface was used to send the original packet, we update the MTU
+	 * on the interface that will be used to send future packets. We also
+	 * update the MTU on the interface that received the Packet Too Big in
+	 * case the original packet was forced out that interface with
+	 * SO_BINDTODEVICE or similar. This is the next best thing to the
+	 * correct behaviour, which would be to update the MTU on all
+	 * interfaces.
+	 */
+	rt6_do_pmtu_disc(daddr, saddr, net, pmtu, 0);
+	rt6_do_pmtu_disc(daddr, saddr, net, pmtu, dev->ifindex);
+}
+
 /*
  *	Misc support functions
  */


