Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab2JFFKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 01:10:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63595 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab2JFFKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 01:10:35 -0400
From: ramesh.nagappa@gmail.com
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, edumazet@google.com, ebiederm@xmission.com,
        xemul@parallels.com, linux-kernel@vger.kernel.org,
        Ramesh Nagappa <ramesh.nagappa@ericsson.com>
Subject: [PATCH V2] net: Fix skb_under_panic oops in neigh_resolve_output
Date: Fri,  5 Oct 2012 22:10:15 -0700
Message-Id: <1349500215-22765-1-git-send-email-ramesh.nagappa@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The retry loop in neigh_resolve_output() and neigh_connected_output()
call dev_hard_header() with out reseting the skb to network_header.
This causes the retry to fail with skb_under_panic. The fix is to
reset the network_header within the retry loop.

Signed-off-by: Ramesh Nagappa <ramesh.nagappa@ericsson.com>
Reviewed-by: Shawn Lu <shawn.lu@ericsson.com>
Reviewed-by: Robert Coulson <robert.coulson@ericsson.com>
Reviewed-by: Billie Alsup <billie.alsup@ericsson.com>
---
 net/core/neighbour.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 117afaf..058bb1e 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1301,8 +1301,6 @@ int neigh_resolve_output(struct neighbour *neigh, struct sk_buff *skb)
 	if (!dst)
 		goto discard;
 
-	__skb_pull(skb, skb_network_offset(skb));
-
 	if (!neigh_event_send(neigh, skb)) {
 		int err;
 		struct net_device *dev = neigh->dev;
@@ -1312,6 +1310,7 @@ int neigh_resolve_output(struct neighbour *neigh, struct sk_buff *skb)
 			neigh_hh_init(neigh, dst);
 
 		do {
+			__skb_pull(skb, skb_network_offset(skb));
 			seq = read_seqbegin(&neigh->ha_lock);
 			err = dev_hard_header(skb, dev, ntohs(skb->protocol),
 					      neigh->ha, NULL, skb->len);
@@ -1342,9 +1341,8 @@ int neigh_connected_output(struct neighbour *neigh, struct sk_buff *skb)
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
1.7.11.4

