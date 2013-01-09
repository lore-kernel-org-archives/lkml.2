Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095Ab3AIUxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:53:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:43807 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934013Ab3AIUlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:41:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Woodhouse <David.Woodhouse@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 103/123] solos-pci: fix double-free of TX skb in DMA mode
Date: Wed,  9 Jan 2013 12:35:42 -0800
Message-Id: <20130109201511.741780661@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

commit cae49ede00ec3d0cda290b03fee55b72b49efc11 upstream.

We weren't clearing card->tx_skb[port] when processing the TX done interrupt.
If there wasn't another skb ready to transmit immediately, this led to a
double-free because we'd free it *again* next time we did have a packet to
send.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/atm/solos-pci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -967,10 +967,11 @@ static uint32_t fpga_tx(struct solos_car
 	for (port = 0; tx_pending; tx_pending >>= 1, port++) {
 		if (tx_pending & 1) {
 			struct sk_buff *oldskb = card->tx_skb[port];
-			if (oldskb)
+			if (oldskb) {
 				pci_unmap_single(card->dev, SKB_CB(oldskb)->dma_addr,
 						 oldskb->len, PCI_DMA_TODEVICE);
-
+				card->tx_skb[port] = NULL;
+			}
 			spin_lock(&card->tx_queue_lock);
 			skb = skb_dequeue(&card->tx_queue[port]);
 			if (!skb)


