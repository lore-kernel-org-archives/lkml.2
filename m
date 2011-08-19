Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1HSNtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:49:35 -0400
Received: from smtp.citrix.com ([66.165.176.89]:53307 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865Ab1HSN2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:08 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158217"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 08/75] IB: nes: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:26:40 +0100
Message-ID: <1313760467-8598-8-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Faisal Latif <faisal.latif@intel.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/nes/nes_nic.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 9d7ffeb..0a622e4 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -441,11 +441,11 @@ static int nes_nic_send(struct sk_buff *skb, struct net_device *netdev)
 		nesnic->tx_skb[nesnic->sq_head] = skb;
 		for (skb_fragment_index = 0; skb_fragment_index < skb_shinfo(skb)->nr_frags;
 				skb_fragment_index++) {
-			bus_address = pci_map_page( nesdev->pcidev,
-					skb_shinfo(skb)->frags[skb_fragment_index].page,
-					skb_shinfo(skb)->frags[skb_fragment_index].page_offset,
-					skb_shinfo(skb)->frags[skb_fragment_index].size,
-					PCI_DMA_TODEVICE);
+			skb_frag_t *frag =
+				&skb_shinfo(skb)->frags[skb_fragment_index];
+			bus_address = skb_frag_dma_map(&nesdev->pcidev->dev,
+						       frag, 0, frag->size,
+						       PCI_DMA_TODEVICE);
 			wqe_fragment_length[wqe_fragment_index] =
 					cpu_to_le16(skb_shinfo(skb)->frags[skb_fragment_index].size);
 			set_wqe_64bit_value(nic_sqe->wqe_words, NES_NIC_SQ_WQE_FRAG0_LOW_IDX+(2*wqe_fragment_index),
@@ -561,11 +561,12 @@ tso_sq_no_longer_full:
 			/* Map all the buffers */
 			for (tso_frag_count=0; tso_frag_count < skb_shinfo(skb)->nr_frags;
 					tso_frag_count++) {
-				tso_bus_address[tso_frag_count] = pci_map_page( nesdev->pcidev,
-						skb_shinfo(skb)->frags[tso_frag_count].page,
-						skb_shinfo(skb)->frags[tso_frag_count].page_offset,
-						skb_shinfo(skb)->frags[tso_frag_count].size,
-						PCI_DMA_TODEVICE);
+				skb_frag_t *frag =
+					&skb_shinfo(skb)->frags[tso_frag_count];
+				tso_bus_address[tso_frag_count] =
+					skb_frag_dma_map(&nesdev->pcidev->dev,
+							 frag, 0, frag->size,
+							 PCI_DMA_TODEVICE);
 			}
 
 			tso_frag_index = 0;
-- 
1.7.2.5

