Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1HSNg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:36:58 -0400
Received: from smtp.citrix.com ([66.165.176.89]:37564 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab1HSN30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:26 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158320"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [PATCH 49/75] sky2: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:21 +0100
Message-ID: <1313760467-8598-49-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/sky2.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 57339da..2951762 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -1226,10 +1226,9 @@ static int sky2_rx_map_skb(struct pci_dev *pdev, struct rx_ring_info *re,
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
-		re->frag_addr[i] = pci_map_page(pdev, frag->page,
-						frag->page_offset,
-						frag->size,
-						PCI_DMA_FROMDEVICE);
+		re->frag_addr[i] = skb_frag_dma_map(&pdev->dev, frag, 0,
+						    frag->size,
+						    PCI_DMA_FROMDEVICE);
 
 		if (pci_dma_mapping_error(pdev, re->frag_addr[i]))
 			goto map_page_error;
@@ -1910,8 +1909,8 @@ static netdev_tx_t sky2_xmit_frame(struct sk_buff *skb,
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
-		mapping = pci_map_page(hw->pdev, frag->page, frag->page_offset,
-				       frag->size, PCI_DMA_TODEVICE);
+		mapping = skb_frag_dma_map(&hw->pdev->dev, frag, 0,
+					   frag->size, PCI_DMA_TODEVICE);
 
 		if (pci_dma_mapping_error(hw->pdev, mapping))
 			goto mapping_unwind;
@@ -2449,7 +2448,7 @@ static void skb_put_frags(struct sk_buff *skb, unsigned int hdr_space,
 
 		if (length == 0) {
 			/* don't need this page */
-			__free_page(frag->page);
+			__skb_frag_unref(frag);
 			--skb_shinfo(skb)->nr_frags;
 		} else {
 			size = min(length, (unsigned) PAGE_SIZE);
-- 
1.7.2.5

