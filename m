Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945946Ab2I1V3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:29:33 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61998 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964873Ab2I1U2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:28:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sergei Poselenov <sposelenov@emcraft.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 131/218] rt2800usb: Added rx packet length validity check
Date: Fri, 28 Sep 2012 13:15:48 -0700
Message-Id: <20120928201516.481667489@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800usb.c |   10 +++++++++-
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -667,8 +667,16 @@ static void rt2800usb_fill_rxdone(struct
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
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -628,7 +628,7 @@ void rt2x00lib_rxdone(struct queue_entry
 	 */
 	if (unlikely(rxdesc.size == 0 ||
 		     rxdesc.size > entry->queue->data_size)) {
-		WARNING(rt2x00dev, "Wrong frame size %d max %d.\n",
+		ERROR(rt2x00dev, "Wrong frame size %d max %d.\n",
 			rxdesc.size, entry->queue->data_size);
 		dev_kfree_skb(entry->skb);
 		goto renew_skb;


