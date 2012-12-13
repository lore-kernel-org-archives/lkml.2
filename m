Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab2LMOLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:11:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44853 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065Ab2LMOLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:11:41 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ramesh Nagappa <ramesh.nagappa@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 176/241] net: Fix skb_under_panic oops in neigh_resolve_output
Date: Thu, 13 Dec 2012 11:59:01 -0200
Message-Id: <1355407206-17100-177-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "ramesh.nagappa@gmail.com" <ramesh.nagappa@gmail.com>

commit e1f165032c8bade3a6bdf546f8faf61fda4dd01c upstream.

The retry loop in neigh_resolve_output() and neigh_connected_output()
call dev_hard_header() with out reseting the skb to network_header.
This causes the retry to fail with skb_under_panic. The fix is to
reset the network_header within the retry loop.

Signed-off-by: Ramesh Nagappa <ramesh.nagappa@ericsson.com>
Reviewed-by: Shawn Lu <shawn.lu@ericsson.com>
Reviewed-by: Robert Coulson <robert.coulson@ericsson.com>
Reviewed-by: Billie Alsup <billie.alsup@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/core/neighbour.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index d81d026..5c2dac3 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1286,8 +1286,6 @@ int neigh_resolve_output(struct neighbour *neigh, struct sk_buff *skb)
 	if (!dst)
 		goto discard;
 
-	__skb_pull(skb, skb_network_offset(skb));
-
 	if (!neigh_event_send(neigh, skb)) {
 		int err;
 		struct net_device *dev = neigh->dev;
@@ -1297,6 +1295,7 @@ int neigh_resolve_output(struct neighbour *neigh, struct sk_buff *skb)
 			neigh_hh_init(neigh, dst);
 
 		do {
+			__skb_pull(skb, skb_network_offset(skb));
 			seq = read_seqbegin(&neigh->ha_lock);
 			err = dev_hard_header(skb, dev, ntohs(skb->protocol),
 					      neigh->ha, NULL, skb->len);
@@ -1327,9 +1326,8 @@ int neigh_connected_output(struct neighbour *neigh, struct sk_buff *skb)
 	unsigned int seq;
 	int err;
 
-	__skb_pull(skb, skb_network_offset(skb));
-
 	do {
+		__skb_pull(skb, skb_network_offset(skb));
 		seq = read_seqbegin(&neigh->ha_lock);
 		err = dev_hard_header(skb, dev, ntohs(skb->protocol),
 				      neigh->ha, NULL, skb->len);
-- 
1.7.9.5

