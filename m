Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1JPMIK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 08:08:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34002 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab1JPMHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 08:07:42 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 3/4] staging: et131x: Convert rest of pci memory management to dma api
Date: Sun, 16 Oct 2011 13:06:14 +0100
Message-Id: <1318766775-2517-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318766775-2517-1-git-send-email-mark.einon@gmail.com>
References: <1318766775-2517-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced pci map/unmap and set_mask calls with their dma equivalents.
Also updated comments to reflect this.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   56 +++++++++++++++++++-------------------
 1 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 993f93a..1c11dfd 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -1976,7 +1976,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 	/* Save physical address
 	 *
-	 * NOTE: pci_alloc_consistent(), used above to alloc DMA regions,
+	 * NOTE: dma_alloc_coherent(), used above to alloc DMA regions,
 	 * ALWAYS returns SAC (32-bit) addresses. If DAC (64-bit) addresses
 	 * are ever returned, make sure the high part is retrieved here
 	 * before storing the adjusted address.
@@ -2007,7 +2007,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 	/* Save physical address
 	 *
-	 * NOTE: pci_alloc_consistent(), used above to alloc DMA regions,
+	 * NOTE: dma_alloc_coherent(), used above to alloc DMA regions,
 	 * ALWAYS returns SAC (32-bit) addresses. If DAC (64-bit) addresses
 	 * are ever returned, make sure the high part is retrieved here before
 	 * storing the adjusted address.
@@ -2152,7 +2152,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	    (unsigned long) rx_ring->ps_ring_physaddr);
 
 	/*
-	 * NOTE : pci_alloc_consistent(), used above to alloc DMA regions,
+	 * NOTE : dma_alloc_coherent(), used above to alloc DMA regions,
 	 * ALWAYS returns SAC (32-bit) addresses. If DAC (64-bit) addresses
 	 * are ever returned, make sure the high part is retrieved here before
 	 * storing the adjusted address.
@@ -2172,7 +2172,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	printk(KERN_INFO "PRS %lx\n", (unsigned long)rx_ring->rx_status_bus);
 
 	/* Recv
-	 * pci_pool_create initializes a lookaside list. After successful
+	 * kmem_cache_create initializes a lookaside list. After successful
 	 * creation, nonpaged fixed-size blocks can be allocated from and
 	 * freed to the lookaside list.
 	 * RFDs will be allocated from this pool.
@@ -2408,7 +2408,7 @@ void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 
 	/* Load the completion writeback physical address
 	 *
-	 * NOTE : pci_alloc_consistent(), used above to alloc DMA regions,
+	 * NOTE : dma_alloc_coherent(), used above to alloc DMA regions,
 	 * ALWAYS returns SAC (32-bit) addresses. If DAC (64-bit) addresses
 	 * are ever returned, make sure the high part is retrieved here
 	 * before storing the adjusted address.
@@ -3005,7 +3005,7 @@ int et131x_tx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 	/* Save physical address
 	 *
-	 * NOTE: pci_alloc_consistent(), used above to alloc DMA regions,
+	 * NOTE: dma_alloc_coherent(), used above to alloc DMA regions,
 	 * ALWAYS returns SAC (32-bit) addresses. If DAC (64-bit) addresses
 	 * are ever returned, make sure the high part is retrieved here before
 	 * storing the adjusted address.
@@ -3202,59 +3202,59 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 					skb->len - skb->data_len;
 
 				/* NOTE: Here, the dma_addr_t returned from
-				 * pci_map_single() is implicitly cast as a
+				 * dma_map_single() is implicitly cast as a
 				 * u32. Although dma_addr_t can be
 				 * 64-bit, the address returned by
-				 * pci_map_single() is always 32-bit
+				 * dma_map_single() is always 32-bit
 				 * addressable (as defined by the pci/dma
 				 * subsystem)
 				 */
 				desc[frag++].addr_lo =
-				    pci_map_single(adapter->pdev,
+				    dma_map_single(&adapter->pdev->dev,
 						   skb->data,
 						   skb->len -
 						   skb->data_len,
-						   PCI_DMA_TODEVICE);
+						   DMA_TO_DEVICE);
 			} else {
 				desc[frag].addr_hi = 0;
 				desc[frag].len_vlan =
 				    (skb->len - skb->data_len) / 2;
 
 				/* NOTE: Here, the dma_addr_t returned from
-				 * pci_map_single() is implicitly cast as a
+				 * dma_map_single() is implicitly cast as a
 				 * u32. Although dma_addr_t can be
 				 * 64-bit, the address returned by
-				 * pci_map_single() is always 32-bit
+				 * dma_map_single() is always 32-bit
 				 * addressable (as defined by the pci/dma
 				 * subsystem)
 				 */
 				desc[frag++].addr_lo =
-				    pci_map_single(adapter->pdev,
+				    dma_map_single(&adapter->pdev->dev,
 						   skb->data,
 						   ((skb->len -
 						     skb->data_len) / 2),
-						   PCI_DMA_TODEVICE);
+						   DMA_TO_DEVICE);
 				desc[frag].addr_hi = 0;
 
 				desc[frag].len_vlan =
 				    (skb->len - skb->data_len) / 2;
 
 				/* NOTE: Here, the dma_addr_t returned from
-				 * pci_map_single() is implicitly cast as a
+				 * dma_map_single() is implicitly cast as a
 				 * u32. Although dma_addr_t can be
 				 * 64-bit, the address returned by
-				 * pci_map_single() is always 32-bit
+				 * dma_map_single() is always 32-bit
 				 * addressable (as defined by the pci/dma
 				 * subsystem)
 				 */
 				desc[frag++].addr_lo =
-				    pci_map_single(adapter->pdev,
+				    dma_map_single(&adapter->pdev->dev,
 						   skb->data +
 						   ((skb->len -
 						     skb->data_len) / 2),
 						   ((skb->len -
 						     skb->data_len) / 2),
-						   PCI_DMA_TODEVICE);
+						   DMA_TO_DEVICE);
 			}
 		} else {
 			desc[frag].addr_hi = 0;
@@ -3262,17 +3262,17 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 					frags[i - 1].size;
 
 			/* NOTE: Here, the dma_addr_t returned from
-			 * pci_map_page() is implicitly cast as a u32.
+			 * dma_map_page() is implicitly cast as a u32.
 			 * Although dma_addr_t can be 64-bit, the address
-			 * returned by pci_map_page() is always 32-bit
+			 * returned by dma_map_page() is always 32-bit
 			 * addressable (as defined by the pci/dma subsystem)
 			 */
 			desc[frag++].addr_lo =
-			    pci_map_page(adapter->pdev,
+			    dma_map_page(&adapter->pdev->dev,
 					 frags[i - 1].page,
 					 frags[i - 1].page_offset,
 					 frags[i - 1].size,
-					 PCI_DMA_TODEVICE);
+					 DMA_TO_DEVICE);
 		}
 	}
 
@@ -3522,9 +3522,9 @@ static inline void free_send_packet(struct et131x_adapter *adapter,
 				    (adapter->tx_ring.tx_desc_ring +
 						INDEX10(tcb->index_start));
 
-			pci_unmap_single(adapter->pdev,
+			dma_unmap_single(&adapter->pdev->dev,
 					 desc->addr_lo,
-					 desc->len_vlan, PCI_DMA_TODEVICE);
+					 desc->len_vlan, DMA_TO_DEVICE);
 
 			add_10bit(&tcb->index_start, 1);
 			if (INDEX10(tcb->index_start) >=
@@ -4428,15 +4428,15 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	}
 
 	/* Check the DMA addressing support of this device */
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
-		result = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
+		result = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
 		if (result) {
 			dev_err(&pdev->dev,
 			  "Unable to obtain 64 bit DMA for consistent allocations\n");
 			goto err_release_res;
 		}
-	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
-		result = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+	} else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
+		result = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (result) {
 			dev_err(&pdev->dev,
 			  "Unable to obtain 32 bit DMA for consistent allocations\n");
-- 
1.7.6.4

