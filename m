Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab1BPATk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:19:40 -0500
Received: from kroah.org ([198.145.64.141]:38871 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756887Ab1BPATc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:30 2011
Message-Id: <20110216001430.831062463@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sujith Manoharan <Sujith.Manoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [057/272] ath9k_htc: Handle pending URBs properly
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

commit ff8f59b5bbdf1527235b8c88d859c7d23691324f upstream.

When doing a channel change, the pending URBs have to be killed
properly on calling htc_stop().

This fixes the probe response timeout seen when sending UDP traffic at
a high rate and running background scan at the same time.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   40 +++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/hif_usb.h |    1 
 2 files changed, 37 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -144,16 +144,36 @@ static void hif_usb_tx_cb(struct urb *ur
 	case -ENODEV:
 	case -ESHUTDOWN:
 		/*
-		 * The URB has been killed, free the SKBs
-		 * and return.
+		 * The URB has been killed, free the SKBs.
 		 */
 		ath9k_skb_queue_purge(hif_dev, &tx_buf->skb_queue);
-		return;
+
+		/*
+		 * If the URBs are being flushed, no need to add this
+		 * URB to the free list.
+		 */
+		spin_lock(&hif_dev->tx.tx_lock);
+		if (hif_dev->tx.flags & HIF_USB_TX_FLUSH) {
+			spin_unlock(&hif_dev->tx.tx_lock);
+			return;
+		}
+		spin_unlock(&hif_dev->tx.tx_lock);
+
+		/*
+		 * In the stop() case, this URB has to be added to
+		 * the free list.
+		 */
+		goto add_free;
 	default:
 		break;
 	}
 
-	/* Check if TX has been stopped */
+	/*
+	 * Check if TX has been stopped, this is needed because
+	 * this CB could have been invoked just after the TX lock
+	 * was released in hif_stop() and kill_urb() hasn't been
+	 * called yet.
+	 */
 	spin_lock(&hif_dev->tx.tx_lock);
 	if (hif_dev->tx.flags & HIF_USB_TX_STOP) {
 		spin_unlock(&hif_dev->tx.tx_lock);
@@ -305,6 +325,7 @@ static void hif_usb_start(void *hif_hand
 static void hif_usb_stop(void *hif_handle, u8 pipe_id)
 {
 	struct hif_device_usb *hif_dev = (struct hif_device_usb *)hif_handle;
+	struct tx_buf *tx_buf = NULL, *tx_buf_tmp = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
@@ -312,6 +333,12 @@ static void hif_usb_stop(void *hif_handl
 	hif_dev->tx.tx_skb_cnt = 0;
 	hif_dev->tx.flags |= HIF_USB_TX_STOP;
 	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
+
+	/* The pending URBs have to be canceled. */
+	list_for_each_entry_safe(tx_buf, tx_buf_tmp,
+				 &hif_dev->tx.tx_pending, list) {
+		usb_kill_urb(tx_buf->urb);
+	}
 }
 
 static int hif_usb_send(void *hif_handle, u8 pipe_id, struct sk_buff *skb,
@@ -578,6 +605,7 @@ free:
 static void ath9k_hif_usb_dealloc_tx_urbs(struct hif_device_usb *hif_dev)
 {
 	struct tx_buf *tx_buf = NULL, *tx_buf_tmp = NULL;
+	unsigned long flags;
 
 	list_for_each_entry_safe(tx_buf, tx_buf_tmp,
 				 &hif_dev->tx.tx_buf, list) {
@@ -588,6 +616,10 @@ static void ath9k_hif_usb_dealloc_tx_urb
 		kfree(tx_buf);
 	}
 
+	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
+	hif_dev->tx.flags |= HIF_USB_TX_FLUSH;
+	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
+
 	list_for_each_entry_safe(tx_buf, tx_buf_tmp,
 				 &hif_dev->tx.tx_pending, list) {
 		usb_kill_urb(tx_buf->urb);
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -62,6 +62,7 @@ struct tx_buf {
 };
 
 #define HIF_USB_TX_STOP  BIT(0)
+#define HIF_USB_TX_FLUSH BIT(1)
 
 struct hif_usb_tx {
 	u8 flags;


