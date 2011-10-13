Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1JMSNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:13:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58321 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1JMSNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:13:31 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/4] staging: et131x: Make rx_ring.fbr{0,1} share a common structure
Date: Thu, 13 Oct 2011 19:11:56 +0100
Message-Id: <1318529518-4922-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318529518-4922-1-git-send-email-mark.einon@gmail.com>
References: <1318529518-4922-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sharing a common structure by moving common structure items into
fbr_lookup.

TODO - Currently will not work if USE_FBR0 = 0 as FBR1 uses fbr[1]
which is removed in this case

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |  293 +++++++++++++++++++--------------------
 1 files changed, 140 insertions(+), 153 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 14f54e4..0bc3e04 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -185,13 +185,7 @@ MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver "
 #define PARM_DMA_CACHE_DEF      0
 
 /* RX defines */
-#define USE_FBR0 true
-
-#ifdef USE_FBR0
-/* #define FBR0_BUFFER_SIZE 256 */
-#endif
-
-/* #define FBR1_BUFFER_SIZE 2048 */
+#define USE_FBR0 1
 
 #define FBR_CHUNKS 32
 
@@ -200,14 +194,16 @@ MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver "
 /* number of RFDs - default and min */
 #ifdef USE_FBR0
 #define RFD_LOW_WATER_MARK	40
-#define NIC_MIN_NUM_RFD		64
 #define NIC_DEFAULT_NUM_RFD	1024
+#define NUM_FBRS		2
 #else
 #define RFD_LOW_WATER_MARK	20
-#define NIC_MIN_NUM_RFD		64
 #define NIC_DEFAULT_NUM_RFD	256
+#define NUM_FBRS		1
 #endif
 
+#define NIC_MIN_NUM_RFD		64
+
 #define NUM_PACKETS_HANDLED	256
 
 #define ALCATEL_BAD_STATUS	0xe47f0000
@@ -303,14 +299,24 @@ struct rx_status_block {
 };
 
 /*
- * Structure for look-up table holding free buffer ring pointers
+ * Structure for look-up table holding free buffer ring pointers, addresses
+ * and state.
  */
 struct fbr_lookup {
-	void *virt[MAX_DESC_PER_RING_RX];
-	void *buffer1[MAX_DESC_PER_RING_RX];
-	void *buffer2[MAX_DESC_PER_RING_RX];
-	u32 bus_high[MAX_DESC_PER_RING_RX];
-	u32 bus_low[MAX_DESC_PER_RING_RX];
+	void		*virt[MAX_DESC_PER_RING_RX];
+	void		*buffer1[MAX_DESC_PER_RING_RX];
+	void		*buffer2[MAX_DESC_PER_RING_RX];
+	u32		 bus_high[MAX_DESC_PER_RING_RX];
+	u32		 bus_low[MAX_DESC_PER_RING_RX];
+	void		*ring_virtaddr;
+	dma_addr_t	 ring_physaddr;
+	void		*mem_virtaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
+	dma_addr_t	 mem_physaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
+	uint64_t	 real_physaddr;
+	uint64_t	 offset;
+	u32		 local_full;
+	u32		 num_entries;
+	u32		 buffsize;
 };
 
 /*
@@ -318,27 +324,7 @@ struct fbr_lookup {
  * reference(s) to the rings
  */
 struct rx_ring {
-#ifdef USE_FBR0
-	void *fbr0_ring_virtaddr;
-	dma_addr_t fbr0_ring_physaddr;
-	void *fbr0_mem_virtaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
-	dma_addr_t fbr0_mem_physaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
-	uint64_t fbr0_real_physaddr;
-	uint64_t fbr0_offset;
-	u32 local_fbr0_full;
-	u32 fbr0_num_entries;
-	u32 fbr0_buffsize;
-#endif
-	void *fbr1_ring_virtaddr;
-	dma_addr_t fbr1_ring_physaddr;
-	void *fbr1_mem_virtaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
-	dma_addr_t fbr1_mem_physaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
-	uint64_t fbr1_real_physaddr;
-	uint64_t fbr1_offset;
-	struct fbr_lookup *fbr[2];	/* One per ring */
-	u32 local_fbr1_full;
-	u32 fbr1_num_entries;
-	u32 fbr1_buffsize;
+	struct fbr_lookup *fbr[NUM_FBRS];
 
 	void *ps_ring_virtaddr;
 	dma_addr_t ps_ring_physaddr;
@@ -1945,40 +1931,40 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 	if (adapter->registry_jumbo_packet < 2048) {
 #ifdef USE_FBR0
-		rx_ring->fbr0_buffsize = 256;
-		rx_ring->fbr0_num_entries = 512;
+		rx_ring->fbr[0]->buffsize = 256;
+		rx_ring->fbr[0]->num_entries = 512;
 #endif
-		rx_ring->fbr1_buffsize = 2048;
-		rx_ring->fbr1_num_entries = 512;
+		rx_ring->fbr[1]->buffsize = 2048;
+		rx_ring->fbr[1]->num_entries = 512;
 	} else if (adapter->registry_jumbo_packet < 4096) {
 #ifdef USE_FBR0
-		rx_ring->fbr0_buffsize = 512;
-		rx_ring->fbr0_num_entries = 1024;
+		rx_ring->fbr[0]->buffsize = 512;
+		rx_ring->fbr[0]->num_entries = 1024;
 #endif
-		rx_ring->fbr1_buffsize = 4096;
-		rx_ring->fbr1_num_entries = 512;
+		rx_ring->fbr[1]->buffsize = 4096;
+		rx_ring->fbr[1]->num_entries = 512;
 	} else {
 #ifdef USE_FBR0
-		rx_ring->fbr0_buffsize = 1024;
-		rx_ring->fbr0_num_entries = 768;
+		rx_ring->fbr[0]->buffsize = 1024;
+		rx_ring->fbr[0]->num_entries = 768;
 #endif
-		rx_ring->fbr1_buffsize = 16384;
-		rx_ring->fbr1_num_entries = 128;
+		rx_ring->fbr[1]->buffsize = 16384;
+		rx_ring->fbr[1]->num_entries = 128;
 	}
 
 #ifdef USE_FBR0
-	adapter->rx_ring.psr_num_entries = adapter->rx_ring.fbr0_num_entries +
-	    adapter->rx_ring.fbr1_num_entries;
+	adapter->rx_ring.psr_num_entries = adapter->rx_ring.fbr[0]->num_entries +
+	    adapter->rx_ring.fbr[1]->num_entries;
 #else
-	adapter->rx_ring.psr_num_entries = adapter->rx_ring.fbr1_num_entries;
+	adapter->rx_ring.psr_num_entries = adapter->rx_ring.fbr[1]->num_entries;
 #endif
 
 	/* Allocate an area of memory for Free Buffer Ring 1 */
-	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr1_num_entries) + 0xfff;
-	rx_ring->fbr1_ring_virtaddr = pci_alloc_consistent(adapter->pdev,
+	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[1]->num_entries) + 0xfff;
+	rx_ring->fbr[1]->ring_virtaddr = pci_alloc_consistent(adapter->pdev,
 						bufsize,
-						&rx_ring->fbr1_ring_physaddr);
-	if (!rx_ring->fbr1_ring_virtaddr) {
+						&rx_ring->fbr[1]->ring_physaddr);
+	if (!rx_ring->fbr[1]->ring_virtaddr) {
 		dev_err(&adapter->pdev->dev,
 			  "Cannot alloc memory for Free Buffer Ring 1\n");
 		return -ENOMEM;
@@ -1991,24 +1977,24 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 * are ever returned, make sure the high part is retrieved here
 	 * before storing the adjusted address.
 	 */
-	rx_ring->fbr1_real_physaddr = rx_ring->fbr1_ring_physaddr;
+	rx_ring->fbr[1]->real_physaddr = rx_ring->fbr[1]->ring_physaddr;
 
 	/* Align Free Buffer Ring 1 on a 4K boundary */
 	et131x_align_allocated_memory(adapter,
-				      &rx_ring->fbr1_real_physaddr,
-				      &rx_ring->fbr1_offset, 0x0FFF);
+				      &rx_ring->fbr[1]->real_physaddr,
+				      &rx_ring->fbr[1]->offset, 0x0FFF);
 
-	rx_ring->fbr1_ring_virtaddr =
-			(void *)((u8 *) rx_ring->fbr1_ring_virtaddr +
-			rx_ring->fbr1_offset);
+	rx_ring->fbr[1]->ring_virtaddr =
+			(void *)((u8 *) rx_ring->fbr[1]->ring_virtaddr +
+			rx_ring->fbr[1]->offset);
 
 #ifdef USE_FBR0
 	/* Allocate an area of memory for Free Buffer Ring 0 */
-	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr0_num_entries) + 0xfff;
-	rx_ring->fbr0_ring_virtaddr = pci_alloc_consistent(adapter->pdev,
+	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[0]->num_entries) + 0xfff;
+	rx_ring->fbr[0]->ring_virtaddr = pci_alloc_consistent(adapter->pdev,
 						bufsize,
-						&rx_ring->fbr0_ring_physaddr);
-	if (!rx_ring->fbr0_ring_virtaddr) {
+						&rx_ring->fbr[0]->ring_physaddr);
+	if (!rx_ring->fbr[0]->ring_virtaddr) {
 		dev_err(&adapter->pdev->dev,
 			  "Cannot alloc memory for Free Buffer Ring 0\n");
 		return -ENOMEM;
@@ -2021,18 +2007,18 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 * are ever returned, make sure the high part is retrieved here before
 	 * storing the adjusted address.
 	 */
-	rx_ring->fbr0_real_physaddr = rx_ring->fbr0_ring_physaddr;
+	rx_ring->fbr[0]->real_physaddr = rx_ring->fbr[0]->ring_physaddr;
 
 	/* Align Free Buffer Ring 0 on a 4K boundary */
 	et131x_align_allocated_memory(adapter,
-				      &rx_ring->fbr0_real_physaddr,
-				      &rx_ring->fbr0_offset, 0x0FFF);
+				      &rx_ring->fbr[0]->real_physaddr,
+				      &rx_ring->fbr[0]->offset, 0x0FFF);
 
-	rx_ring->fbr0_ring_virtaddr =
-				(void *)((u8 *) rx_ring->fbr0_ring_virtaddr +
-				rx_ring->fbr0_offset);
+	rx_ring->fbr[0]->ring_virtaddr =
+			(void *)((u8 *) rx_ring->fbr[0]->ring_virtaddr +
+			rx_ring->fbr[0]->offset);
 #endif
-	for (i = 0; i < (rx_ring->fbr1_num_entries / FBR_CHUNKS); i++) {
+	for (i = 0; i < (rx_ring->fbr[1]->num_entries / FBR_CHUNKS); i++) {
 		u64 fbr1_offset;
 		u64 fbr1_tmp_physaddr;
 		u32 fbr1_align;
@@ -2044,25 +2030,25 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 		 * the size of FBR0.  By allocating N buffers at once, we
 		 * reduce this overhead.
 		 */
-		if (rx_ring->fbr1_buffsize > 4096)
+		if (rx_ring->fbr[1]->buffsize > 4096)
 			fbr1_align = 4096;
 		else
-			fbr1_align = rx_ring->fbr1_buffsize;
+			fbr1_align = rx_ring->fbr[1]->buffsize;
 
 		fbr_chunksize =
-		    (FBR_CHUNKS * rx_ring->fbr1_buffsize) + fbr1_align - 1;
-		rx_ring->fbr1_mem_virtaddrs[i] =
+		    (FBR_CHUNKS * rx_ring->fbr[1]->buffsize) + fbr1_align - 1;
+		rx_ring->fbr[1]->mem_virtaddrs[i] =
 		    pci_alloc_consistent(adapter->pdev, fbr_chunksize,
-					 &rx_ring->fbr1_mem_physaddrs[i]);
+					 &rx_ring->fbr[1]->mem_physaddrs[i]);
 
-		if (!rx_ring->fbr1_mem_virtaddrs[i]) {
+		if (!rx_ring->fbr[1]->mem_virtaddrs[i]) {
 			dev_err(&adapter->pdev->dev,
 				"Could not alloc memory\n");
 			return -ENOMEM;
 		}
 
 		/* See NOTE in "Save Physical Address" comment above */
-		fbr1_tmp_physaddr = rx_ring->fbr1_mem_physaddrs[i];
+		fbr1_tmp_physaddr = rx_ring->fbr[1]->mem_physaddrs[i];
 
 		et131x_align_allocated_memory(adapter,
 					      &fbr1_tmp_physaddr,
@@ -2075,8 +2061,8 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			 * access later
 			 */
 			rx_ring->fbr[1]->virt[index] =
-			    (u8 *) rx_ring->fbr1_mem_virtaddrs[i] +
-			    (j * rx_ring->fbr1_buffsize) + fbr1_offset;
+			    (u8 *) rx_ring->fbr[1]->mem_virtaddrs[i] +
+			    (j * rx_ring->fbr[1]->buffsize) + fbr1_offset;
 
 			/* now store the physical address in the descriptor
 			 * so the device can access it
@@ -2086,7 +2072,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			rx_ring->fbr[1]->bus_low[index] =
 			    (u32) fbr1_tmp_physaddr;
 
-			fbr1_tmp_physaddr += rx_ring->fbr1_buffsize;
+			fbr1_tmp_physaddr += rx_ring->fbr[1]->buffsize;
 
 			rx_ring->fbr[1]->buffer1[index] =
 			    rx_ring->fbr[1]->virt[index];
@@ -2097,43 +2083,43 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 #ifdef USE_FBR0
 	/* Same for FBR0 (if in use) */
-	for (i = 0; i < (rx_ring->fbr0_num_entries / FBR_CHUNKS); i++) {
+	for (i = 0; i < (rx_ring->fbr[0]->num_entries / FBR_CHUNKS); i++) {
 		u64 fbr0_offset;
 		u64 fbr0_tmp_physaddr;
 
 		fbr_chunksize =
-		    ((FBR_CHUNKS + 1) * rx_ring->fbr0_buffsize) - 1;
-		rx_ring->fbr0_mem_virtaddrs[i] =
+		    ((FBR_CHUNKS + 1) * rx_ring->fbr[0]->buffsize) - 1;
+		rx_ring->fbr[0]->mem_virtaddrs[i] =
 		    pci_alloc_consistent(adapter->pdev, fbr_chunksize,
-					 &rx_ring->fbr0_mem_physaddrs[i]);
+					 &rx_ring->fbr[0]->mem_physaddrs[i]);
 
-		if (!rx_ring->fbr0_mem_virtaddrs[i]) {
+		if (!rx_ring->fbr[0]->mem_virtaddrs[i]) {
 			dev_err(&adapter->pdev->dev,
 				"Could not alloc memory\n");
 			return -ENOMEM;
 		}
 
 		/* See NOTE in "Save Physical Address" comment above */
-		fbr0_tmp_physaddr = rx_ring->fbr0_mem_physaddrs[i];
+		fbr0_tmp_physaddr = rx_ring->fbr[0]->mem_physaddrs[i];
 
 		et131x_align_allocated_memory(adapter,
 					      &fbr0_tmp_physaddr,
 					      &fbr0_offset,
-					      rx_ring->fbr0_buffsize - 1);
+					      rx_ring->fbr[0]->buffsize - 1);
 
 		for (j = 0; j < FBR_CHUNKS; j++) {
 			u32 index = (i * FBR_CHUNKS) + j;
 
 			rx_ring->fbr[0]->virt[index] =
-			    (u8 *) rx_ring->fbr0_mem_virtaddrs[i] +
-			    (j * rx_ring->fbr0_buffsize) + fbr0_offset;
+			    (u8 *) rx_ring->fbr[0]->mem_virtaddrs[i] +
+			    (j * rx_ring->fbr[0]->buffsize) + fbr0_offset;
 
 			rx_ring->fbr[0]->bus_high[index] =
 			    (u32) (fbr0_tmp_physaddr >> 32);
 			rx_ring->fbr[0]->bus_low[index] =
 			    (u32) fbr0_tmp_physaddr;
 
-			fbr0_tmp_physaddr += rx_ring->fbr0_buffsize;
+			fbr0_tmp_physaddr += rx_ring->fbr[0]->buffsize;
 
 			rx_ring->fbr[0]->buffer1[index] =
 			    rx_ring->fbr[0]->virt[index];
@@ -2228,78 +2214,78 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 	}
 
 	/* Free Free Buffer Ring 1 */
-	if (rx_ring->fbr1_ring_virtaddr) {
+	if (rx_ring->fbr[1]->ring_virtaddr) {
 		/* First the packet memory */
 		for (index = 0; index <
-		     (rx_ring->fbr1_num_entries / FBR_CHUNKS); index++) {
-			if (rx_ring->fbr1_mem_virtaddrs[index]) {
+		     (rx_ring->fbr[1]->num_entries / FBR_CHUNKS); index++) {
+			if (rx_ring->fbr[1]->mem_virtaddrs[index]) {
 				u32 fbr1_align;
 
-				if (rx_ring->fbr1_buffsize > 4096)
+				if (rx_ring->fbr[1]->buffsize > 4096)
 					fbr1_align = 4096;
 				else
-					fbr1_align = rx_ring->fbr1_buffsize;
+					fbr1_align = rx_ring->fbr[1]->buffsize;
 
 				bufsize =
-				    (rx_ring->fbr1_buffsize * FBR_CHUNKS) +
+				    (rx_ring->fbr[1]->buffsize * FBR_CHUNKS) +
 				    fbr1_align - 1;
 
 				pci_free_consistent(adapter->pdev,
 					bufsize,
-					rx_ring->fbr1_mem_virtaddrs[index],
-					rx_ring->fbr1_mem_physaddrs[index]);
+					rx_ring->fbr[1]->mem_virtaddrs[index],
+					rx_ring->fbr[1]->mem_physaddrs[index]);
 
-				rx_ring->fbr1_mem_virtaddrs[index] = NULL;
+				rx_ring->fbr[1]->mem_virtaddrs[index] = NULL;
 			}
 		}
 
 		/* Now the FIFO itself */
-		rx_ring->fbr1_ring_virtaddr = (void *)((u8 *)
-			rx_ring->fbr1_ring_virtaddr - rx_ring->fbr1_offset);
+		rx_ring->fbr[1]->ring_virtaddr = (void *)((u8 *)
+			rx_ring->fbr[1]->ring_virtaddr - rx_ring->fbr[1]->offset);
 
-		bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr1_num_entries)
+		bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[1]->num_entries)
 							    + 0xfff;
 
 		pci_free_consistent(adapter->pdev, bufsize,
-				    rx_ring->fbr1_ring_virtaddr,
-				    rx_ring->fbr1_ring_physaddr);
+				    rx_ring->fbr[1]->ring_virtaddr,
+				    rx_ring->fbr[1]->ring_physaddr);
 
-		rx_ring->fbr1_ring_virtaddr = NULL;
+		rx_ring->fbr[1]->ring_virtaddr = NULL;
 	}
 
 #ifdef USE_FBR0
 	/* Now the same for Free Buffer Ring 0 */
-	if (rx_ring->fbr0_ring_virtaddr) {
+	if (rx_ring->fbr[0]->ring_virtaddr) {
 		/* First the packet memory */
 		for (index = 0; index <
-		     (rx_ring->fbr0_num_entries / FBR_CHUNKS); index++) {
-			if (rx_ring->fbr0_mem_virtaddrs[index]) {
+		     (rx_ring->fbr[0]->num_entries / FBR_CHUNKS); index++) {
+			if (rx_ring->fbr[0]->mem_virtaddrs[index]) {
 				bufsize =
-				    (rx_ring->fbr0_buffsize *
+				    (rx_ring->fbr[0]->buffsize *
 				     (FBR_CHUNKS + 1)) - 1;
 
 				pci_free_consistent(adapter->pdev,
 					bufsize,
-					rx_ring->fbr0_mem_virtaddrs[index],
-					rx_ring->fbr0_mem_physaddrs[index]);
+					rx_ring->fbr[0]->mem_virtaddrs[index],
+					rx_ring->fbr[0]->mem_physaddrs[index]);
 
-				rx_ring->fbr0_mem_virtaddrs[index] = NULL;
+				rx_ring->fbr[0]->mem_virtaddrs[index] = NULL;
 			}
 		}
 
 		/* Now the FIFO itself */
-		rx_ring->fbr0_ring_virtaddr = (void *)((u8 *)
-			rx_ring->fbr0_ring_virtaddr - rx_ring->fbr0_offset);
+		rx_ring->fbr[0]->ring_virtaddr = (void *)((u8 *)
+			rx_ring->fbr[0]->ring_virtaddr - rx_ring->fbr[0]->offset);
 
-		bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr0_num_entries)
+		bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[0]->num_entries)
 							    + 0xfff;
 
 		pci_free_consistent(adapter->pdev,
 				    bufsize,
-				    rx_ring->fbr0_ring_virtaddr,
-				    rx_ring->fbr0_ring_physaddr);
+				    rx_ring->fbr[0]->ring_virtaddr,
+				    rx_ring->fbr[0]->ring_physaddr);
 
-		rx_ring->fbr0_ring_virtaddr = NULL;
+		rx_ring->fbr[0]->ring_virtaddr = NULL;
 	}
 #endif
 
@@ -2445,8 +2431,8 @@ void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 	rx_local->local_psr_full = 0;
 
 	/* Now's the best time to initialize FBR1 contents */
-	fbr_entry = (struct fbr_desc *) rx_local->fbr1_ring_virtaddr;
-	for (entry = 0; entry < rx_local->fbr1_num_entries; entry++) {
+	fbr_entry = (struct fbr_desc *) rx_local->fbr[1]->ring_virtaddr;
+	for (entry = 0; entry < rx_local->fbr[1]->num_entries; entry++) {
 		fbr_entry->addr_hi = rx_local->fbr[1]->bus_high[entry];
 		fbr_entry->addr_lo = rx_local->fbr[1]->bus_low[entry];
 		fbr_entry->word2 = entry;
@@ -2456,42 +2442,42 @@ void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 	/* Set the address and parameters of Free buffer ring 1 (and 0 if
 	 * required) into the 1310's registers
 	 */
-	writel((u32) (rx_local->fbr1_real_physaddr >> 32),
+	writel((u32) (rx_local->fbr[1]->real_physaddr >> 32),
 	       &rx_dma->fbr1_base_hi);
-	writel((u32) rx_local->fbr1_real_physaddr, &rx_dma->fbr1_base_lo);
-	writel(rx_local->fbr1_num_entries - 1, &rx_dma->fbr1_num_des);
+	writel((u32) rx_local->fbr[1]->real_physaddr, &rx_dma->fbr1_base_lo);
+	writel(rx_local->fbr[1]->num_entries - 1, &rx_dma->fbr1_num_des);
 	writel(ET_DMA10_WRAP, &rx_dma->fbr1_full_offset);
 
 	/* This variable tracks the free buffer ring 1 full position, so it
 	 * has to match the above.
 	 */
-	rx_local->local_fbr1_full = ET_DMA10_WRAP;
+	rx_local->fbr[1]->local_full = ET_DMA10_WRAP;
 	writel(
-	    ((rx_local->fbr1_num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
+	    ((rx_local->fbr[1]->num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
 	    &rx_dma->fbr1_min_des);
 
 #ifdef USE_FBR0
 	/* Now's the best time to initialize FBR0 contents */
-	fbr_entry = (struct fbr_desc *) rx_local->fbr0_ring_virtaddr;
-	for (entry = 0; entry < rx_local->fbr0_num_entries; entry++) {
+	fbr_entry = (struct fbr_desc *) rx_local->fbr[0]->ring_virtaddr;
+	for (entry = 0; entry < rx_local->fbr[0]->num_entries; entry++) {
 		fbr_entry->addr_hi = rx_local->fbr[0]->bus_high[entry];
 		fbr_entry->addr_lo = rx_local->fbr[0]->bus_low[entry];
 		fbr_entry->word2 = entry;
 		fbr_entry++;
 	}
 
-	writel((u32) (rx_local->fbr0_real_physaddr >> 32),
+	writel((u32) (rx_local->fbr[0]->real_physaddr >> 32),
 	       &rx_dma->fbr0_base_hi);
-	writel((u32) rx_local->fbr0_real_physaddr, &rx_dma->fbr0_base_lo);
-	writel(rx_local->fbr0_num_entries - 1, &rx_dma->fbr0_num_des);
+	writel((u32) rx_local->fbr[0]->real_physaddr, &rx_dma->fbr0_base_lo);
+	writel(rx_local->fbr[0]->num_entries - 1, &rx_dma->fbr0_num_des);
 	writel(ET_DMA10_WRAP, &rx_dma->fbr0_full_offset);
 
 	/* This variable tracks the free buffer ring 0 full position, so it
 	 * has to match the above.
 	 */
-	rx_local->local_fbr0_full = ET_DMA10_WRAP;
+	rx_local->fbr[0]->local_full = ET_DMA10_WRAP;
 	writel(
-	    ((rx_local->fbr0_num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
+	    ((rx_local->fbr[0]->num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
 	    &rx_dma->fbr0_min_des);
 #endif
 
@@ -2550,15 +2536,15 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 	 */
 	if (
 #ifdef USE_FBR0
-	    (ring_index == 0 && buff_index < rx_local->fbr0_num_entries) ||
+	    (ring_index == 0 && buff_index < rx_local->fbr[0]->num_entries) ||
 #endif
-	    (ring_index == 1 && buff_index < rx_local->fbr1_num_entries)) {
+	    (ring_index == 1 && buff_index < rx_local->fbr[1]->num_entries)) {
 		spin_lock_irqsave(&adapter->fbr_lock, flags);
 
 		if (ring_index == 1) {
 			struct fbr_desc *next =
-			    (struct fbr_desc *) (rx_local->fbr1_ring_virtaddr) +
-					 INDEX10(rx_local->local_fbr1_full);
+			    (struct fbr_desc *) (rx_local->fbr[1]->ring_virtaddr) +
+					 INDEX10(rx_local->fbr[1]->local_full);
 
 			/* Handle the Free Buffer Ring advancement here. Write
 			 * the PA / Buffer Index for the returned buffer into
@@ -2568,15 +2554,15 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 			next->addr_lo = rx_local->fbr[1]->bus_low[buff_index];
 			next->word2 = buff_index;
 
-			writel(bump_free_buff_ring(&rx_local->local_fbr1_full,
-				rx_local->fbr1_num_entries - 1),
+			writel(bump_free_buff_ring(&rx_local->fbr[1]->local_full,
+				rx_local->fbr[1]->num_entries - 1),
 				&rx_dma->fbr1_full_offset);
 		}
 #ifdef USE_FBR0
 		else {
 			struct fbr_desc *next = (struct fbr_desc *)
-				rx_local->fbr0_ring_virtaddr +
-					INDEX10(rx_local->local_fbr0_full);
+				rx_local->fbr[0]->ring_virtaddr +
+				    INDEX10(rx_local->fbr[0]->local_full);
 
 			/* Handle the Free Buffer Ring advancement here. Write
 			 * the PA / Buffer Index for the returned buffer into
@@ -2586,8 +2572,9 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 			next->addr_lo = rx_local->fbr[0]->bus_low[buff_index];
 			next->word2 = buff_index;
 
-			writel(bump_free_buff_ring(&rx_local->local_fbr0_full,
-					rx_local->fbr0_num_entries - 1),
+			writel(bump_free_buff_ring(
+					&rx_local->fbr[0]->local_full,
+					rx_local->fbr[0]->num_entries - 1),
 			       &rx_dma->fbr0_full_offset);
 		}
 #endif
@@ -2637,19 +2624,19 @@ void et131x_rx_dma_enable(struct et131x_adapter *adapter)
 	/* Setup the receive dma configuration register for normal operation */
 	u32 csr =  0x2000;	/* FBR1 enable */
 
-	if (adapter->rx_ring.fbr1_buffsize == 4096)
+	if (adapter->rx_ring.fbr[1]->buffsize == 4096)
 		csr |= 0x0800;
-	else if (adapter->rx_ring.fbr1_buffsize == 8192)
+	else if (adapter->rx_ring.fbr[1]->buffsize == 8192)
 		csr |= 0x1000;
-	else if (adapter->rx_ring.fbr1_buffsize == 16384)
+	else if (adapter->rx_ring.fbr[1]->buffsize == 16384)
 		csr |= 0x1800;
 #ifdef USE_FBR0
 	csr |= 0x0400;		/* FBR0 enable */
-	if (adapter->rx_ring.fbr0_buffsize == 256)
+	if (adapter->rx_ring.fbr[0]->buffsize == 256)
 		csr |= 0x0100;
-	else if (adapter->rx_ring.fbr0_buffsize == 512)
+	else if (adapter->rx_ring.fbr[0]->buffsize == 512)
 		csr |= 0x0200;
-	else if (adapter->rx_ring.fbr0_buffsize == 1024)
+	else if (adapter->rx_ring.fbr[0]->buffsize == 1024)
 		csr |= 0x0300;
 #endif
 	writel(csr, &adapter->regs->rxdma.csr);
@@ -2750,11 +2737,11 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 #ifdef USE_FBR0
 	if (ring_index > 1 ||
 		(ring_index == 0 &&
-		buff_index > rx_local->fbr0_num_entries - 1) ||
+		buff_index > rx_local->fbr[0]->num_entries - 1) ||
 		(ring_index == 1 &&
-		buff_index > rx_local->fbr1_num_entries - 1))
+		buff_index > rx_local->fbr[1]->num_entries - 1))
 #else
-	if (ring_index != 1 || buff_index > rx_local->fbr1_num_entries - 1)
+	if (ring_index != 1 || buff_index > rx_local->fbr[1]->num_entries - 1)
 #endif
 	{
 		/* Illegal buffer or ring index cannot be used by S/W*/
-- 
1.7.6.4

