Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759762Ab2FGEoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:44:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759618Ab2FGERE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:17:04 -0400
Message-Id: <20120607040339.302952908@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:03:56 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 20/82] ath9k: fix a use-after-free-bug when ath_tx_setup_buffer() fails
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 81357a281dcc454841532c46b30e6f2ba12b73ea upstream.

ath_tx_setup_buffer() can fail if there is no ath_buf left, or if mapping DMA
failed. In this case it frees the skb passed to it.
If ath_tx_setup_buffer is called from ath_tx_form_aggr, the skb is still
linked into the tid buffer list and must be dequeued before being released.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/xmit.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -64,7 +64,8 @@ static void ath_tx_update_baw(struct ath
 static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 					   struct ath_txq *txq,
 					   struct ath_atx_tid *tid,
-					   struct sk_buff *skb);
+					   struct sk_buff *skb,
+					   bool dequeue);
 
 enum {
 	MCS_HT20,
@@ -811,7 +812,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_
 		fi = get_frame_info(skb);
 		bf = fi->bf;
 		if (!fi->bf)
-			bf = ath_tx_setup_buffer(sc, txq, tid, skb);
+			bf = ath_tx_setup_buffer(sc, txq, tid, skb, true);
 
 		if (!bf)
 			continue;
@@ -1726,7 +1727,7 @@ static void ath_tx_send_ampdu(struct ath
 		return;
 	}
 
-	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb, false);
 	if (!bf)
 		return;
 
@@ -1753,7 +1754,7 @@ static void ath_tx_send_normal(struct at
 
 	bf = fi->bf;
 	if (!bf)
-		bf = ath_tx_setup_buffer(sc, txq, tid, skb);
+		bf = ath_tx_setup_buffer(sc, txq, tid, skb, false);
 
 	if (!bf)
 		return;
@@ -1814,7 +1815,8 @@ u8 ath_txchainmask_reduction(struct ath_
 static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 					   struct ath_txq *txq,
 					   struct ath_atx_tid *tid,
-					   struct sk_buff *skb)
+					   struct sk_buff *skb,
+					   bool dequeue)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_frame_info *fi = get_frame_info(skb);
@@ -1863,6 +1865,8 @@ static struct ath_buf *ath_tx_setup_buff
 	return bf;
 
 error:
+	if (dequeue)
+		__skb_unlink(skb, &tid->buf_q);
 	dev_kfree_skb_any(skb);
 	return NULL;
 }
@@ -1893,7 +1897,7 @@ static void ath_tx_start_dma(struct ath_
 		 */
 		ath_tx_send_ampdu(sc, tid, skb, txctl);
 	} else {
-		bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+		bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb, false);
 		if (!bf)
 			return;
 


