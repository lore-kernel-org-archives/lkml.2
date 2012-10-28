Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab2J1XuD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:50:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41787 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756300Ab2J1X1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:00 -0400
Message-Id: <20121028231542.256308645@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:53 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "ramesh.nagappa@gmail.com" <ramesh.nagappa@gmail.com>,
        Ramesh Nagappa <ramesh.nagappa@ericsson.com>,
        Shawn Lu <shawn.lu@ericsson.com>,
        Robert Coulson <robert.coulson@ericsson.com>,
        Billie Alsup <billie.alsup@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 017/105] net: Fix skb_under_panic oops in neigh_resolve_output
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "ramesh.nagappa@gmail.com" <ramesh.nagappa@gmail.com>

[ Upstream commit e1f165032c8bade3a6bdf546f8faf61fda4dd01c ]

The retry loop in neigh_resolve_output() and neigh_connected_output()
call dev_hard_header() with out reseting the skb to network_header.
This causes the retry to fail with skb_under_panic. The fix is to
reset the network_header within the retry loop.

Signed-off-by: Ramesh Nagappa <ramesh.nagappa@ericsson.com>
Reviewed-by: Shawn Lu <shawn.lu@ericsson.com>
Reviewed-by: Robert Coulson <robert.coulson@ericsson.com>
Reviewed-by: Billie Alsup <billie.alsup@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/neighbour.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 7aafaed..5b9709f 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1254,8 +1254,6 @@ int neigh_resolve_output(struct neighbour *neigh, struct sk_buff *skb)
 	if (!dst)
 		goto discard;
 
-	__skb_pull(skb, skb_network_offset(skb));
-
 	if (!neigh_event_send(neigh, skb)) {
 		int err;
 		struct net_device *dev = neigh->dev;
@@ -1265,6 +1263,7 @@ int neigh_resolve_output(struct neighbour *neigh, struct sk_buff *skb)
 			neigh_hh_init(neigh, dst);
 
 		do {
+			__skb_pull(skb, skb_network_offset(skb));
 			seq = read_seqbegin(&neigh->ha_lock);
 			err = dev_hard_header(skb, dev, ntohs(skb->protocol),
 					      neigh->ha, NULL, skb->len);
@@ -1295,9 +1294,8 @@ int neigh_connected_output(struct neighbour *neigh, struct sk_buff *skb)
 	unsigned int seq;
 	int err;
 
-	__skb_pull(skb, skb_network_offset(skb));
-
 	do {
+		__skb_pull(skb, skb_network_offset(skb));
 		seq = read_seqbegin(&neigh->ha_lock);
 		err = dev_hard_header(skb, dev, ntohs(skb->protocol),
 				      neigh->ha, NULL, skb->len);


