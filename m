Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab1ABHkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:40:18 -0500
Received: from mail.windriver.com ([147.11.1.11]:36669 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab1ABHYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:51 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 196/260] net: Fix IPv6 PMTU disc. w/ asymmetric routes
Date: Sun,  2 Jan 2011 02:18:12 -0500
Message-Id: <1293952756-15010-197-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jan 2011 07:23:45.0291 (UTC) FILETIME=[FD877DB0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

commit ae878ae280bea286ff2b1e1cb6e609dd8cb4501d upstream.

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv6/route.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 40f6f13..4f4b21d 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1561,14 +1561,13 @@ out:
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
 
@@ -1636,6 +1635,27 @@ out:
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
-- 
1.7.3.3

