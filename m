Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2DCP1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 11:27:03 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:21245 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab2DCP1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 11:27:00 -0400
Message-Id: <201204031527.q33FR04i031747@farm-0027.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 3 Apr 2012 11:13:56 -0400
Subject: [PATCH] marvell sky2 driver: fix so it works without unaligned accesses
To: Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 03 Apr 2012 15:27:00.0347 (UTC) FILETIME=[36B5ACB0:01CD11AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver uses a receive_new() routine that ends up requiring unaligned
accesses in IP header processing.  If the architecture doesn't support
efficient unaligned accesses, just copy all ingress packets to the bounce
buffers instead.

This allows the driver to be used on the Tilera TILEmpower-Gx, since
the tile architecture doesn't currently handle kernel unaligned accesses,
just userspace.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/net/ethernet/marvell/sky2.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 879b0a4..7a15482 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -2490,6 +2490,7 @@ static struct sk_buff *receive_copy(struct sky2_port *sky2,
 	return skb;
 }
 
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 /* Adjust length of skb with fragments to match received data */
 static void skb_put_frags(struct sk_buff *skb, unsigned int hdr_space,
 			  unsigned int length)
@@ -2555,6 +2556,7 @@ nomap:
 nobuf:
 	return NULL;
 }
+#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
 
 /*
  * Receive one packet.
@@ -2598,10 +2600,12 @@ static struct sk_buff *sky2_receive(struct net_device *dev,
 		goto error;
 
 okay:
-	if (length < copybreak)
-		skb = receive_copy(sky2, re, length);
-	else
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	if (length >= copybreak)
 		skb = receive_new(sky2, re, length);
+	else
+#endif
+		skb = receive_copy(sky2, re, length);
 
 	dev->stats.rx_dropped += (skb == NULL);
 
-- 
1.6.5.2

