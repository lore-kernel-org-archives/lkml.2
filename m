Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0HPVq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 17:46:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54946 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab0HPVq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 17:46:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 16 Aug 2010 23:45:54 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/16] drivers/firewire: Use available error codes
To: Julia Lawall <julia@diku.dk>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1008161824210.19313@ask.diku.dk>
Message-ID: <tkrat.def6ac6a673ffb1b@s5r6.in-berlin.de>
References: <Pine.LNX.4.64.1008161824210.19313@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: firewire: net: fix unicast reception RCODE in failure paths

The incoming request hander fwnet_receive_packet() expects subsequent
datagram handling code to return non-zero on errors.  However, almost
none of the failure paths did so.  Fix them all.

(This error reporting is used to send and RCODE_CONFLICT_ERROR to the
sender node in such failure cases.  Two modes of failure exist:  Out of
memory, or firewire-net is unaware of any peer node to which a fragment
or an ARP packet belongs.  However, it is unclear whether a sender can
actually make use of such information.  A Linux peer apparently can't.
Maybe it should all be simplified to void functions.)

Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/net.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

Index: b/drivers/firewire/net.c
===================================================================
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -579,7 +579,7 @@ static int fwnet_finish_incoming_packet(
 		if (!peer) {
 			fw_notify("No peer for ARP packet from %016llx\n",
 				  (unsigned long long)peer_guid);
-			goto failed_proto;
+			goto no_peer;
 		}
 
 		/*
@@ -656,7 +656,7 @@ static int fwnet_finish_incoming_packet(
 
 	return 0;
 
- failed_proto:
+ no_peer:
 	net->stats.rx_errors++;
 	net->stats.rx_dropped++;
 
@@ -664,7 +664,7 @@ static int fwnet_finish_incoming_packet(
 	if (netif_queue_stopped(net))
 		netif_wake_queue(net);
 
-	return 0;
+	return -ENOENT;
 }
 
 static int fwnet_incoming_packet(struct fwnet_device *dev, __be32 *buf, int len,
@@ -701,7 +701,7 @@ static int fwnet_incoming_packet(struct 
 			fw_error("out of memory\n");
 			net->stats.rx_dropped++;
 
-			return -1;
+			return -ENOMEM;
 		}
 		skb_reserve(skb, (net->hard_header_len + 15) & ~15);
 		memcpy(skb_put(skb, len), buf, len);
@@ -726,8 +726,10 @@ static int fwnet_incoming_packet(struct 
 	spin_lock_irqsave(&dev->lock, flags);
 
 	peer = fwnet_peer_find_by_node_id(dev, source_node_id, generation);
-	if (!peer)
-		goto bad_proto;
+	if (!peer) {
+		retval = -ENOENT;
+		goto fail;
+	}
 
 	pd = fwnet_pd_find(peer, datagram_label);
 	if (pd == NULL) {
@@ -741,7 +743,7 @@ static int fwnet_incoming_packet(struct 
 				  dg_size, buf, fg_off, len);
 		if (pd == NULL) {
 			retval = -ENOMEM;
-			goto bad_proto;
+			goto fail;
 		}
 		peer->pdg_size++;
 	} else {
@@ -755,9 +757,9 @@ static int fwnet_incoming_packet(struct 
 			pd = fwnet_pd_new(net, peer, datagram_label,
 					  dg_size, buf, fg_off, len);
 			if (pd == NULL) {
-				retval = -ENOMEM;
 				peer->pdg_size--;
-				goto bad_proto;
+				retval = -ENOMEM;
+				goto fail;
 			}
 		} else {
 			if (!fwnet_pd_update(peer, pd, buf, fg_off, len)) {
@@ -768,7 +770,8 @@ static int fwnet_incoming_packet(struct 
 				 */
 				fwnet_pd_delete(pd);
 				peer->pdg_size--;
-				goto bad_proto;
+				retval = -ENOMEM;
+				goto fail;
 			}
 		}
 	} /* new datagram or add to existing one */
@@ -794,14 +797,13 @@ static int fwnet_incoming_packet(struct 
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	return 0;
-
- bad_proto:
+ fail:
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	if (netif_queue_stopped(net))
 		netif_wake_queue(net);
 
-	return 0;
+	return retval;
 }
 
 static void fwnet_receive_packet(struct fw_card *card, struct fw_request *r,


-- 
Stefan Richter
-=====-==-=- =--- =----
http://arcgraph.de/sr/

