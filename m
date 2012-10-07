Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab2JGXqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:46:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38175 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752803Ab2JGXWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:01 -0400
Message-Id: <20121007225847.843328486@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 08 Oct 2012 00:00:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 095/108] net: small bug on rxhash calculation
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chema Gonzalez <chema@google.com>

[ Upstream commit 6862234238e84648c305526af2edd98badcad1e0 ]

In the current rxhash calculation function, while the
sorting of the ports/addrs is coherent (you get the
same rxhash for packets sharing the same 4-tuple, in
both directions), ports and addrs are sorted
independently. This implies packets from a connection
between the same addresses but crossed ports hash to
the same rxhash.

For example, traffic between A=S:l and B=L:s is hashed
(in both directions) from {L, S, {s, l}}. The same
rxhash is obtained for packets between C=S:s and D=L:l.

This patch ensures that you either swap both addrs and ports,
or you swap none. Traffic between A and B, and traffic
between C and D, get their rxhash from different sources
({L, S, {l, s}} for A<->B, and {L, S, {s, l}} for C<->D)

The patch is co-written with Eric Dumazet <edumazet@google.com>

Signed-off-by: Chema Gonzalez <chema@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/dev.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 832ba6d..a4a0c5a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2686,16 +2686,17 @@ ipv6:
 		nhoff += poff;
 		if (pskb_may_pull(skb, nhoff + 4)) {
 			ports.v32 = * (__force u32 *) (skb->data + nhoff);
-			if (ports.v16[1] < ports.v16[0])
-				swap(ports.v16[0], ports.v16[1]);
 			skb->l4_rxhash = 1;
 		}
 	}
 
 	/* get a consistent hash (same value on both flow directions) */
-	if (addr2 < addr1)
+	if (addr2 < addr1 ||
+	    (addr2 == addr1 &&
+	     ports.v16[1] < ports.v16[0])) {
 		swap(addr1, addr2);
-
+		swap(ports.v16[0], ports.v16[1]);
+	}
 	hash = jhash_3words(addr1, addr2, ports.v32, hashrnd);
 	if (!hash)
 		hash = 1;


