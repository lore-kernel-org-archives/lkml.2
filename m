Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab1HSN31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:29:27 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:58735 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab1HSN3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:24 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732405"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Steve Hodgson <shodgson@solarflare.com>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [PATCH 47/75] sfc: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:19 +0100
Message-ID: <1313760467-8598-47-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Solarflare linux maintainers <linux-net-drivers@solarflare.com>
Cc: Steve Hodgson <shodgson@solarflare.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/sfc/rx.c |    2 +-
 drivers/net/sfc/tx.c |   13 ++++---------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/sfc/rx.c b/drivers/net/sfc/rx.c
index 62e4364..91a6b71 100644
--- a/drivers/net/sfc/rx.c
+++ b/drivers/net/sfc/rx.c
@@ -478,7 +478,7 @@ static void efx_rx_packet_gro(struct efx_channel *channel,
 		if (efx->net_dev->features & NETIF_F_RXHASH)
 			skb->rxhash = efx_rx_buf_hash(eh);
 
-		skb_shinfo(skb)->frags[0].page = page;
+		skb_frag_set_page(skb, 0, page);
 		skb_shinfo(skb)->frags[0].page_offset =
 			efx_rx_buf_offset(efx, rx_buf);
 		skb_shinfo(skb)->frags[0].size = rx_buf->len;
diff --git a/drivers/net/sfc/tx.c b/drivers/net/sfc/tx.c
index 84eb99e..f2467a1 100644
--- a/drivers/net/sfc/tx.c
+++ b/drivers/net/sfc/tx.c
@@ -137,8 +137,6 @@ netdev_tx_t efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 	struct pci_dev *pci_dev = efx->pci_dev;
 	struct efx_tx_buffer *buffer;
 	skb_frag_t *fragment;
-	struct page *page;
-	int page_offset;
 	unsigned int len, unmap_len = 0, fill_level, insert_ptr;
 	dma_addr_t dma_addr, unmap_addr = 0;
 	unsigned int dma_len;
@@ -241,13 +239,11 @@ netdev_tx_t efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 			break;
 		fragment = &skb_shinfo(skb)->frags[i];
 		len = fragment->size;
-		page = fragment->page;
-		page_offset = fragment->page_offset;
 		i++;
 		/* Map for DMA */
 		unmap_single = false;
-		dma_addr = pci_map_page(pci_dev, page, page_offset, len,
-					PCI_DMA_TODEVICE);
+		dma_addr = skb_frag_dma_map(&pci_dev->dev, fragment, 0, len,
+					    PCI_DMA_TODEVICE);
 	}
 
 	/* Transfer ownership of the skb to the final buffer */
@@ -929,9 +925,8 @@ static void tso_start(struct tso_state *st, const struct sk_buff *skb)
 static int tso_get_fragment(struct tso_state *st, struct efx_nic *efx,
 			    skb_frag_t *frag)
 {
-	st->unmap_addr = pci_map_page(efx->pci_dev, frag->page,
-				      frag->page_offset, frag->size,
-				      PCI_DMA_TODEVICE);
+	st->unmap_addr = skb_frag_dma_map(&efx->pci_dev->dev, frag, 0,
+					  frag->size, PCI_DMA_TODEVICE);
 	if (likely(!pci_dma_mapping_error(efx->pci_dev, st->unmap_addr))) {
 		st->unmap_single = false;
 		st->unmap_len = frag->size;
-- 
1.7.2.5

