Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab2KLVQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:16:39 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:44231 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab2KLVQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:16:37 -0500
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/2] staging: et131x: Remove unnecessary DMA address alignment code
Date: Mon, 12 Nov 2012 21:16:29 +0000
Message-Id: <1352754989-15603-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352754989-15603-1-git-send-email-mark.einon@gmail.com>
References: <1352754989-15603-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Documentation/DMA-API-HOWTO.txt on dma_alloc_coherent():

"The cpu return address and the DMA bus master address are both
guaranteed to be aligned to the smallest PAGE_SIZE order which
is greater than or equal to the requested size."

There are several places in the et131x.c code where these addresses are
aligned to a 4k boundary after a call to dma_alloc_coherent(),
needlessly.

Remove these alignment offset calculations, and the
et131x_align_allocated_memory() call which is only used for 4k
alignments.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   72 +++------------------------------------
 1 file changed, 5 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 4f68646..5f15a2e 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -290,7 +290,6 @@ struct fbr_lookup {
 	dma_addr_t	 ring_physaddr;
 	void		*mem_virtaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
 	dma_addr_t	 mem_physaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
-	dma_addr_t	 offset;
 	u32		 local_full;
 	u32		 num_entries;
 	dma_addr_t	 buffsize;
@@ -2227,32 +2226,6 @@ static inline u32 bump_free_buff_ring(u32 *free_buff_ring, u32 limit)
 }
 
 /**
- * et131x_align_allocated_memory - Align allocated memory on a given boundary
- * @adapter: pointer to our adapter structure
- * @phys_addr: pointer to Physical address
- * @offset: pointer to the offset variable
- * @mask: correct mask
- */
-static void et131x_align_allocated_memory(struct et131x_adapter *adapter,
-					  dma_addr_t *phys_addr,
-					  dma_addr_t *offset,
-					  u64 mask)
-{
-	u64 new_addr = *phys_addr & ~mask;
-
-	*offset = 0;
-
-	if (new_addr != *phys_addr) {
-		/* Move to next aligned block */
-		new_addr += mask + 1;
-		/* Return offset for adjusting virt addr */
-		*offset = new_addr - *phys_addr;
-		/* Return new physical address */
-		*phys_addr = new_addr;
-	}
-}
-
-/**
  * et131x_rx_dma_memory_alloc
  * @adapter: pointer to our private adapter structure
  *
@@ -2268,7 +2241,6 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	u32 bufsize;
 	u32 pktstat_ringsize;
 	u32 fbr_chunksize;
-	u32 fbr_align;
 	struct rx_ring *rx_ring;
 
 	/* Setup some convenience pointers */
@@ -2331,29 +2303,13 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			   "Cannot alloc memory for Free Buffer Ring %d\n", id);
 			return -ENOMEM;
 		}
-
-		/* Align Free Buffer Ring on a 4K boundary */
-		et131x_align_allocated_memory(adapter,
-					     &rx_ring->fbr[id]->ring_physaddr,
-					     &rx_ring->fbr[id]->offset, 0x0FFF);
-
-		rx_ring->fbr[id]->ring_virtaddr =
-			(void *)((u8 *) rx_ring->fbr[id]->ring_virtaddr +
-			rx_ring->fbr[id]->offset);
 	}
 
 	for (id = 0; id < NUM_FBRS; id++) {
-		if (id == 0 && rx_ring->fbr[id]->buffsize > 4096)
-				fbr_align = 4096;
-		else
-				fbr_align = rx_ring->fbr[id]->buffsize;
-
-		fbr_chunksize = (FBR_CHUNKS *
-				 rx_ring->fbr[id]->buffsize) + fbr_align - 1;
+		fbr_chunksize = (FBR_CHUNKS * rx_ring->fbr[id]->buffsize);
 
 		for (i = 0; i < (rx_ring->fbr[id]->num_entries / FBR_CHUNKS); i++) {
 			dma_addr_t fbr_tmp_physaddr;
-			dma_addr_t fbr_offset;
 
 			/* This code allocates an area of memory big enough for
 			 * N free buffers + (buffer_size - 1) so that the
@@ -2376,11 +2332,6 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			/* See NOTE in "Save Physical Address" comment above */
 			fbr_tmp_physaddr = rx_ring->fbr[id]->mem_physaddrs[i];
 
-			et131x_align_allocated_memory(adapter,
-						      &fbr_tmp_physaddr,
-						      &fbr_offset,
-						      (fbr_align - 1));
-
 			for (j = 0; j < FBR_CHUNKS; j++) {
 				u32 index = (i * FBR_CHUNKS) + j;
 
@@ -2389,7 +2340,7 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 				 */
 				rx_ring->fbr[id]->virt[index] =
 				  (u8 *) rx_ring->fbr[id]->mem_virtaddrs[i] +
-				  (j * rx_ring->fbr[id]->buffsize) + fbr_offset;
+				  (j * rx_ring->fbr[id]->buffsize);
 
 				/* now store the physical address in the
 				 * descriptor so the device can access it
@@ -2499,16 +2450,8 @@ static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 				(rx_ring->fbr[id]->num_entries / FBR_CHUNKS);
 			     index++) {
 				if (rx_ring->fbr[id]->mem_virtaddrs[index]) {
-					u32 fbr_align;
 
-					if (rx_ring->fbr[id]->buffsize > 4096)
-						fbr_align = 4096;
-					else
-						fbr_align = rx_ring->fbr[id]->buffsize;
-
-					bufsize =
-					    (rx_ring->fbr[id]->buffsize * FBR_CHUNKS) +
-					    fbr_align - 1;
+					bufsize = (rx_ring->fbr[id]->buffsize * FBR_CHUNKS);
 
 					dma_free_coherent(&adapter->pdev->dev,
 						bufsize,
@@ -2519,10 +2462,6 @@ static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 				}
 			}
 
-			/* Now the FIFO itself */
-			rx_ring->fbr[id]->ring_virtaddr = (void *)((u8 *)
-			    rx_ring->fbr[id]->ring_virtaddr - rx_ring->fbr[id]->offset);
-
 			bufsize =
 			    (sizeof(struct fbr_desc) * rx_ring->fbr[id]->num_entries) +
 										0xfff;
@@ -2967,7 +2906,7 @@ static int et131x_tx_dma_memory_alloc(struct et131x_adapter *adapter)
 	/* Allocate enough memory for the Tx descriptor ring, and allocate
 	 * some extra so that the ring can be aligned on a 4k boundary.
 	 */
-	desc_size = (sizeof(struct tx_desc) * NUM_DESC_PER_RING_TX) + 4096 - 1;
+	desc_size = (sizeof(struct tx_desc) * NUM_DESC_PER_RING_TX);
 	tx_ring->tx_desc_ring =
 	    (struct tx_desc *) dma_alloc_coherent(&adapter->pdev->dev,
 						  desc_size,
@@ -3011,8 +2950,7 @@ static void et131x_tx_dma_memory_free(struct et131x_adapter *adapter)
 
 	if (adapter->tx_ring.tx_desc_ring) {
 		/* Free memory relating to Tx rings here */
-		desc_size = (sizeof(struct tx_desc) * NUM_DESC_PER_RING_TX)
-								+ 4096 - 1;
+		desc_size = (sizeof(struct tx_desc) * NUM_DESC_PER_RING_TX);
 		dma_free_coherent(&adapter->pdev->dev,
 				    desc_size,
 				    adapter->tx_ring.tx_desc_ring,
-- 
1.7.9.5

