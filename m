Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab2IQBOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:14:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33677 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630Ab2IQAu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:28 -0400
Message-Id: <20120917003640.476447677@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sergei Poselenov <sposelenov@emcraft.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 103/135] rt2800usb: Added rx packet length validity check
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Poselenov <sposelenov@emcraft.com>

commit efd5d6b03bd9c9e0df646c56fb5f4f3e25e5c1ac upstream.

On our system (ARM Cortex-M3 SOC running linux-2.6.33)
frequent crashes were observed in the rt2800usb module
because of the invalid length of the received packet (3392,
46920...). This patch adds the sanity check on the packet
legth. Also, changed WARNING to ERROR in rt2x00lib_rxdone()
so that the bad packet condition would be noticed.

The fix was tested on the latest compat-wireless-3.5.1-1-snpc.

Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   10 +++++++++-
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 52a32b5..6b4226b 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -667,8 +667,16 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 	skb_pull(entry->skb, RXINFO_DESC_SIZE);
 
 	/*
-	 * FIXME: we need to check for rx_pkt_len validity
+	 * Check for rx_pkt_len validity. Return if invalid, leaving
+	 * rxdesc->size zeroed out by the upper level.
 	 */
+	if (unlikely(rx_pkt_len == 0 ||
+			rx_pkt_len > entry->queue->data_size)) {
+		ERROR(entry->queue->rt2x00dev,
+			"Bad frame size %d, forcing to 0\n", rx_pkt_len);
+		return;
+	}
+
 	rxd = (__le32 *)(entry->skb->data + rx_pkt_len);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index a6b88bd..3f07e36 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -629,7 +629,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp)
 	 */
 	if (unlikely(rxdesc.size == 0 ||
 		     rxdesc.size > entry->queue->data_size)) {
-		WARNING(rt2x00dev, "Wrong frame size %d max %d.\n",
+		ERROR(rt2x00dev, "Wrong frame size %d max %d.\n",
 			rxdesc.size, entry->queue->data_size);
 		dev_kfree_skb(entry->skb);
 		goto renew_skb;


