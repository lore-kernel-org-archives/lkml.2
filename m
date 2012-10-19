Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab2JSWIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:08:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45658 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab2JSWIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:08:23 -0400
From: Mark Einon <mark.einon@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/3] staging: et131x: Remove fbr_lookup.real_physaddr
Date: Fri, 19 Oct 2012 23:08:14 +0100
Message-Id: <1350684496-14384-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbr_lookup.real_physaddr is only being used as a pseudonym for
fbr_lookup.ring_physaddr, so remove it and rename all instances to
ring_physaddr.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 23d166b..3fd8142 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -299,7 +299,6 @@ struct fbr_lookup {
 	dma_addr_t	 ring_physaddr;
 	void		*mem_virtaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
 	dma_addr_t	 mem_physaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
-	u64		 real_physaddr;
 	u64		 offset;
 	u32		 local_full;
 	u32		 num_entries;
@@ -1903,9 +1902,9 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 	/* Set the address and parameters of Free buffer ring 1 (and 0 if
 	 * required) into the 1310's registers
 	 */
-	writel((u32) (rx_local->fbr[0]->real_physaddr >> 32),
+	writel((u32) (rx_local->fbr[0]->ring_physaddr >> 32),
 	       &rx_dma->fbr1_base_hi);
-	writel((u32) rx_local->fbr[0]->real_physaddr, &rx_dma->fbr1_base_lo);
+	writel((u32) rx_local->fbr[0]->ring_physaddr, &rx_dma->fbr1_base_lo);
 	writel(rx_local->fbr[0]->num_entries - 1, &rx_dma->fbr1_num_des);
 	writel(ET_DMA10_WRAP, &rx_dma->fbr1_full_offset);
 
@@ -1927,9 +1926,9 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 		fbr_entry++;
 	}
 
-	writel((u32) (rx_local->fbr[1]->real_physaddr >> 32),
+	writel((u32) (rx_local->fbr[1]->ring_physaddr >> 32),
 	       &rx_dma->fbr0_base_hi);
-	writel((u32) rx_local->fbr[1]->real_physaddr, &rx_dma->fbr0_base_lo);
+	writel((u32) rx_local->fbr[1]->ring_physaddr, &rx_dma->fbr0_base_lo);
 	writel(rx_local->fbr[1]->num_entries - 1, &rx_dma->fbr0_num_des);
 	writel(ET_DMA10_WRAP, &rx_dma->fbr0_full_offset);
 
@@ -2378,18 +2377,9 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 		return -ENOMEM;
 	}
 
-	/* Save physical address
-	 *
-	 * NOTE: dma_alloc_coherent(), used above to alloc DMA regions,
-	 * ALWAYS returns SAC (32-bit) addresses. If DAC (64-bit) addresses
-	 * are ever returned, make sure the high part is retrieved here
-	 * before storing the adjusted address.
-	 */
-	rx_ring->fbr[0]->real_physaddr = rx_ring->fbr[0]->ring_physaddr;
-
 	/* Align Free Buffer Ring 1 on a 4K boundary */
 	et131x_align_allocated_memory(adapter,
-				      &rx_ring->fbr[0]->real_physaddr,
+				      &rx_ring->fbr[0]->ring_physaddr,
 				      &rx_ring->fbr[0]->offset, 0x0FFF);
 
 	rx_ring->fbr[0]->ring_virtaddr =
@@ -2410,18 +2400,9 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 		return -ENOMEM;
 	}
 
-	/* Save physical address
-	 *
-	 * NOTE: dma_alloc_coherent(), used above to alloc DMA regions,
-	 * ALWAYS returns SAC (32-bit) addresses. If DAC (64-bit) addresses
-	 * are ever returned, make sure the high part is retrieved here before
-	 * storing the adjusted address.
-	 */
-	rx_ring->fbr[1]->real_physaddr = rx_ring->fbr[1]->ring_physaddr;
-
 	/* Align Free Buffer Ring 0 on a 4K boundary */
 	et131x_align_allocated_memory(adapter,
-				      &rx_ring->fbr[1]->real_physaddr,
+				      &rx_ring->fbr[1]->ring_physaddr,
 				      &rx_ring->fbr[1]->offset, 0x0FFF);
 
 	rx_ring->fbr[1]->ring_virtaddr =
-- 
1.7.9.5

