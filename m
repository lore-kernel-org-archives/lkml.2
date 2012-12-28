Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab2L1TSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:18:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55200 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754677Ab2L1TSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:08 -0500
Message-Id: <20121228190356.401020217@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Woodhouse <dwmw2@infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 125/173] solos-pci: fix double-free of TX skb in DMA mode
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

commit cae49ede00ec3d0cda290b03fee55b72b49efc11 upstream.

We weren't clearing card->tx_skb[port] when processing the TX done interrupt.
If there wasn't another skb ready to transmit immediately, this led to a
double-free because we'd free it *again* next time we did have a packet to
send.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/atm/solos-pci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index 6619a8a..c909b7b 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -945,10 +945,11 @@ static uint32_t fpga_tx(struct solos_card *card)
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


