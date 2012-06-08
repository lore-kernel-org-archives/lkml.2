Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507Ab2FHFHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:07:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43124 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759679Ab2FHFHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:10 -0400
Message-Id: <20120608041844.349426300@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 26/82] ath9k: fix a use-after-free-bug when ath_tx_setup_buffer() fails
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 81357a281dcc454841532c46b30e6f2ba12b73ea upstream.

ath_tx_setup_buffer() can fail if there is no ath_buf left, or if mapping DMA
failed. In this case it frees the skb passed to it.
If ath_tx_setup_buffer is called from ath_tx_form_aggr, the skb is still
linked into the tid buffer list and must be dequeued before being released.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -64,7 +64,8 @@
 static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 					   struct ath_txq *txq,
 					   struct ath_atx_tid *tid,
-					   struct sk_buff *skb);
+					   struct sk_buff *skb,
+					   bool dequeue);
 
 enum {
 	MCS_HT20,
@@ -761,7 +762,7 @@
 		fi = get_frame_info(skb);
 		bf = fi->bf;
 		if (!fi->bf)
-			bf = ath_tx_setup_buffer(sc, txq, tid, skb);
+			bf = ath_tx_setup_buffer(sc, txq, tid, skb, true);
 
 		if (!bf)
 			continue;
@@ -1669,7 +1670,7 @@
 		return;
 	}
 
-	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb, false);
 	if (!bf)
 		return;
 
@@ -1696,7 +1697,7 @@
 
 	bf = fi->bf;
 	if (!bf)
-		bf = ath_tx_setup_buffer(sc, txq, tid, skb);
+		bf = ath_tx_setup_buffer(sc, txq, tid, skb, false);
 
 	if (!bf)
 		return;
@@ -1761,7 +1762,8 @@
 static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 					   struct ath_txq *txq,
 					   struct ath_atx_tid *tid,
-					   struct sk_buff *skb)
+					   struct sk_buff *skb,
+					   bool dequeue)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_frame_info *fi = get_frame_info(skb);
@@ -1802,6 +1804,8 @@
 	return bf;
 
 error:
+	if (dequeue)
+		__skb_unlink(skb, &tid->buf_q);
 	dev_kfree_skb_any(skb);
 	return NULL;
 }
@@ -1833,7 +1837,7 @@
 		 */
 		ath_tx_send_ampdu(sc, tid, skb, txctl);
 	} else {
-		bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+		bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb, false);
 		if (!bf)
 			goto out;
 


