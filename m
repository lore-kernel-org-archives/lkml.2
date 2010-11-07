Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab0KGVkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:40:18 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45112 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0KGVkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:40:16 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 7 Nov 2010 22:40:03 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/4] firewire: net: fix memory leaks
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <tkrat.036c5d10fb83f85d@s5r6.in-berlin.de>
Message-ID: <tkrat.d3b1585b222c0bb6@s5r6.in-berlin.de>
References: <tkrat.036c5d10fb83f85d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a) fwnet_transmit_packet_done used to poison ptask->pt_link by list_del.
If fwnet_send_packet checked later whether it was responsible to clean
up (in the border case that the TX soft IRQ was outpaced by the AT-req
tasklet on another CPU), it missed this because ptask->pt_link was no
longer shown as empty.

b) If fwnet_write_complete got an rcode other than RCODE_COMPLETE, we
missed to free the skb and ptask entirely.

Also, count stats.tx_dropped and stats.tx_errors when rcode != 0.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/net.c |   35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

Index: b/drivers/firewire/net.c
===================================================================
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -917,9 +917,10 @@ static void fwnet_transmit_packet_done(s
 
 	/* Check whether we or the networking TX soft-IRQ is last user. */
 	free = (ptask->outstanding_pkts == 0 && !list_empty(&ptask->pt_link));
+	if (free)
+		list_del(&ptask->pt_link);
 
 	if (ptask->outstanding_pkts == 0) {
-		list_del(&ptask->pt_link);
 		dev->netdev->stats.tx_packets++;
 		dev->netdev->stats.tx_bytes += skb->len;
 	}
@@ -974,6 +975,31 @@ static void fwnet_transmit_packet_done(s
 		fwnet_free_ptask(ptask);
 }
 
+static void fwnet_transmit_packet_failed(struct fwnet_packet_task *ptask)
+{
+	struct fwnet_device *dev = ptask->dev;
+	unsigned long flags;
+	bool free;
+
+	spin_lock_irqsave(&dev->lock, flags);
+
+	/* One fragment failed; don't try to send remaining fragments. */
+	ptask->outstanding_pkts = 0;
+
+	/* Check whether we or the networking TX soft-IRQ is last user. */
+	free = !list_empty(&ptask->pt_link);
+	if (free)
+		list_del(&ptask->pt_link);
+
+	dev->netdev->stats.tx_dropped++;
+	dev->netdev->stats.tx_errors++;
+
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	if (free)
+		fwnet_free_ptask(ptask);
+}
+
 static void fwnet_write_complete(struct fw_card *card, int rcode,
 				 void *payload, size_t length, void *data)
 {
@@ -981,11 +1007,12 @@ static void fwnet_write_complete(struct 
 
 	ptask = data;
 
-	if (rcode == RCODE_COMPLETE)
+	if (rcode == RCODE_COMPLETE) {
 		fwnet_transmit_packet_done(ptask);
-	else
+	} else {
 		fw_error("fwnet_write_complete: failed: %x\n", rcode);
-		/* ??? error recovery */
+		fwnet_transmit_packet_failed(ptask);
+	}
 }
 
 static int fwnet_send_packet(struct fwnet_packet_task *ptask)

-- 
Stefan Richter
-=====-==-=- =-== --===
http://arcgraph.de/sr/

