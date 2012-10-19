Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab2JSWI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:08:27 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45658 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933087Ab2JSWIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:08:24 -0400
From: Mark Einon <mark.einon@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/3] staging: et131x: Use upper_32_bits() instead of '>> 32'
Date: Fri, 19 Oct 2012 23:08:15 +0100
Message-Id: <1350684496-14384-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350684496-14384-1-git-send-email-mark.einon@gmail.com>
References: <1350684496-14384-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a previous comment by Alan Cox:
	'>> 32 of a 32bit value is undefined in C. The compiler is free
	to do what it likes with this...'

Change all uses of '>> 32' to use upper_32_bits() and use
the corresponding lower_32_bits() to match.

Also remove an incorrect comment about dma alloc always returning 32bit
addresses.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   55 ++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 3fd8142..32f909a 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -1859,25 +1859,17 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 	/* Halt RXDMA to perform the reconfigure.  */
 	et131x_rx_dma_disable(adapter);
 
-	/* Load the completion writeback physical address
-	 *
-	 * NOTE : dma_alloc_coherent(), used above to alloc DMA regions,
-	 * ALWAYS returns SAC (32-bit) addresses. If DAC (64-bit) addresses
-	 * are ever returned, make sure the high part is retrieved here
-	 * before storing the adjusted address.
-	 */
-	writel((u32) ((u64)rx_local->rx_status_bus >> 32),
-	       &rx_dma->dma_wb_base_hi);
-	writel((u32) rx_local->rx_status_bus, &rx_dma->dma_wb_base_lo);
+	/* Load the completion writeback physical address */
+	writel(upper_32_bits(rx_local->rx_status_bus), &rx_dma->dma_wb_base_hi);
+	writel(lower_32_bits(rx_local->rx_status_bus), &rx_dma->dma_wb_base_lo);
 
 	memset(rx_local->rx_status_block, 0, sizeof(struct rx_status_block));
 
 	/* Set the address and parameters of the packet status ring into the
 	 * 1310's registers
 	 */
-	writel((u32) ((u64)rx_local->ps_ring_physaddr >> 32),
-	       &rx_dma->psr_base_hi);
-	writel((u32) rx_local->ps_ring_physaddr, &rx_dma->psr_base_lo);
+	writel(upper_32_bits(rx_local->ps_ring_physaddr), &rx_dma->psr_base_hi);
+	writel(lower_32_bits(rx_local->ps_ring_physaddr), &rx_dma->psr_base_lo);
 	writel(rx_local->psr_num_entries - 1, &rx_dma->psr_num_des);
 	writel(0, &rx_dma->psr_full_offset);
 
@@ -1902,9 +1894,10 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 	/* Set the address and parameters of Free buffer ring 1 (and 0 if
 	 * required) into the 1310's registers
 	 */
-	writel((u32) (rx_local->fbr[0]->ring_physaddr >> 32),
+	writel(upper_32_bits(rx_local->fbr[0]->ring_physaddr),
 	       &rx_dma->fbr1_base_hi);
-	writel((u32) rx_local->fbr[0]->ring_physaddr, &rx_dma->fbr1_base_lo);
+	writel(lower_32_bits(rx_local->fbr[0]->ring_physaddr),
+	       &rx_dma->fbr1_base_lo);
 	writel(rx_local->fbr[0]->num_entries - 1, &rx_dma->fbr1_num_des);
 	writel(ET_DMA10_WRAP, &rx_dma->fbr1_full_offset);
 
@@ -1926,9 +1919,10 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 		fbr_entry++;
 	}
 
-	writel((u32) (rx_local->fbr[1]->ring_physaddr >> 32),
+	writel(upper_32_bits(rx_local->fbr[1]->ring_physaddr),
 	       &rx_dma->fbr0_base_hi);
-	writel((u32) rx_local->fbr[1]->ring_physaddr, &rx_dma->fbr0_base_lo);
+	writel(lower_32_bits(rx_local->fbr[1]->ring_physaddr),
+	       &rx_dma->fbr0_base_lo);
 	writel(rx_local->fbr[1]->num_entries - 1, &rx_dma->fbr0_num_des);
 	writel(ET_DMA10_WRAP, &rx_dma->fbr0_full_offset);
 
@@ -1970,18 +1964,19 @@ static void et131x_config_tx_dma_regs(struct et131x_adapter *adapter)
 	struct txdma_regs __iomem *txdma = &adapter->regs->txdma;
 
 	/* Load the hardware with the start of the transmit descriptor ring. */
-	writel((u32) ((u64)adapter->tx_ring.tx_desc_ring_pa >> 32),
+	writel(upper_32_bits(adapter->tx_ring.tx_desc_ring_pa),
 	       &txdma->pr_base_hi);
-	writel((u32) adapter->tx_ring.tx_desc_ring_pa,
+	writel(lower_32_bits(adapter->tx_ring.tx_desc_ring_pa),
 	       &txdma->pr_base_lo);
 
 	/* Initialise the transmit DMA engine */
 	writel(NUM_DESC_PER_RING_TX - 1, &txdma->pr_num_des);
 
 	/* Load the completion writeback physical address */
-	writel((u32)((u64)adapter->tx_ring.tx_status_pa >> 32),
-						&txdma->dma_wb_base_hi);
-	writel((u32)adapter->tx_ring.tx_status_pa, &txdma->dma_wb_base_lo);
+	writel(upper_32_bits(adapter->tx_ring.tx_status_pa),
+	       &txdma->dma_wb_base_hi);
+	writel(lower_32_bits(adapter->tx_ring.tx_status_pa),
+	       &txdma->dma_wb_base_lo);
 
 	*adapter->tx_ring.tx_status = 0;
 
@@ -2460,16 +2455,16 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			 * so the device can access it
 			 */
 			rx_ring->fbr[0]->bus_high[index] =
-			    (u32) (fbr1_tmp_physaddr >> 32);
+					upper_32_bits(fbr1_tmp_physaddr);
 			rx_ring->fbr[0]->bus_low[index] =
-			    (u32) fbr1_tmp_physaddr;
+					lower_32_bits(fbr1_tmp_physaddr);
 
 			fbr1_tmp_physaddr += rx_ring->fbr[0]->buffsize;
 
 			rx_ring->fbr[0]->buffer1[index] =
-			    rx_ring->fbr[0]->virt[index];
+					rx_ring->fbr[0]->virt[index];
 			rx_ring->fbr[0]->buffer2[index] =
-			    rx_ring->fbr[0]->virt[index] - 4;
+					rx_ring->fbr[0]->virt[index] - 4;
 		}
 	}
 
@@ -2508,16 +2503,16 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			    (j * rx_ring->fbr[1]->buffsize) + fbr0_offset;
 
 			rx_ring->fbr[1]->bus_high[index] =
-			    (u32) (fbr0_tmp_physaddr >> 32);
+					upper_32_bits(fbr0_tmp_physaddr);
 			rx_ring->fbr[1]->bus_low[index] =
-			    (u32) fbr0_tmp_physaddr;
+					lower_32_bits(fbr0_tmp_physaddr);
 
 			fbr0_tmp_physaddr += rx_ring->fbr[1]->buffsize;
 
 			rx_ring->fbr[1]->buffer1[index] =
-			    rx_ring->fbr[1]->virt[index];
+					rx_ring->fbr[1]->virt[index];
 			rx_ring->fbr[1]->buffer2[index] =
-			    rx_ring->fbr[1]->virt[index] - 4;
+					rx_ring->fbr[1]->virt[index] - 4;
 		}
 	}
 #endif
-- 
1.7.9.5

