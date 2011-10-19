Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1JSXFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:05:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38637 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab1JSXCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:02:54 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: staging: et131x: Fix issues when USE_FBR0 is not defined
Date: Thu, 20 Oct 2011 00:01:02 +0100
Message-Id: <1319065268-2863-12-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319065268-2863-1-git-send-email-mark.einon@gmail.com>
References: <1319065268-2863-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Following on from making rx_ring.fbr use a common structure - reversed
the fbr[] array indicies so that index 1 = FBR0 and index 0 = FBR1,
which allows USE_FBR0 define to work.

* Also fixed up minor issues where indexes into the array were out of
bounds in some places.

* Removed rx_ring.fbr common stuct TODO item from README

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/README   |    1 -
 drivers/staging/et131x/et131x.c |  304 ++++++++++++++++++++-------------------
 2 files changed, 158 insertions(+), 147 deletions(-)

diff --git a/drivers/staging/et131x/README b/drivers/staging/et131x/README
index a7b33dc..1e0fcf4 100644
--- a/drivers/staging/et131x/README
+++ b/drivers/staging/et131x/README
@@ -8,7 +8,6 @@ Note, the powermanagement options were removed from the vendor provided
 driver as they did not build properly at the time.
 
 TODO:
-	- rx_ring.fbr{0, 1} can probably share a common structure
 	- Use of kmem_cache seems a bit unusual
 	- Use dma_alloc_... in place of pci_alloc_...
 	- It's too late stopping the tx queue when there is no room for the current packet. The condition should be detected for the next packet.
diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 0bc3e04..0fbb77d 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -322,10 +322,14 @@ struct fbr_lookup {
 /*
  * struct rx_ring is the sructure representing the adaptor's local
  * reference(s) to the rings
+ *
+ ******************************************************************************
+ * IMPORTANT NOTE :- fbr_lookup *fbr[NUM_FBRS] uses index 0 to refer to FBR1
+ *			and index 1 to refer to FRB0
+ ******************************************************************************
  */
 struct rx_ring {
 	struct fbr_lookup *fbr[NUM_FBRS];
-
 	void *ps_ring_virtaddr;
 	dma_addr_t ps_ring_physaddr;
 	u32 local_psr_full;
@@ -1907,9 +1911,9 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 	/* Alloc memory for the lookup table */
 #ifdef USE_FBR0
-	rx_ring->fbr[0] = kmalloc(sizeof(struct fbr_lookup), GFP_KERNEL);
-#endif
 	rx_ring->fbr[1] = kmalloc(sizeof(struct fbr_lookup), GFP_KERNEL);
+#endif
+	rx_ring->fbr[0] = kmalloc(sizeof(struct fbr_lookup), GFP_KERNEL);
 
 	/* The first thing we will do is configure the sizes of the buffer
 	 * rings. These will change based on jumbo packet support.  Larger
@@ -1931,40 +1935,40 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 	if (adapter->registry_jumbo_packet < 2048) {
 #ifdef USE_FBR0
-		rx_ring->fbr[0]->buffsize = 256;
-		rx_ring->fbr[0]->num_entries = 512;
-#endif
-		rx_ring->fbr[1]->buffsize = 2048;
+		rx_ring->fbr[1]->buffsize = 256;
 		rx_ring->fbr[1]->num_entries = 512;
+#endif
+		rx_ring->fbr[0]->buffsize = 2048;
+		rx_ring->fbr[0]->num_entries = 512;
 	} else if (adapter->registry_jumbo_packet < 4096) {
 #ifdef USE_FBR0
-		rx_ring->fbr[0]->buffsize = 512;
-		rx_ring->fbr[0]->num_entries = 1024;
+		rx_ring->fbr[1]->buffsize = 512;
+		rx_ring->fbr[1]->num_entries = 1024;
 #endif
-		rx_ring->fbr[1]->buffsize = 4096;
-		rx_ring->fbr[1]->num_entries = 512;
+		rx_ring->fbr[0]->buffsize = 4096;
+		rx_ring->fbr[0]->num_entries = 512;
 	} else {
 #ifdef USE_FBR0
-		rx_ring->fbr[0]->buffsize = 1024;
-		rx_ring->fbr[0]->num_entries = 768;
+		rx_ring->fbr[1]->buffsize = 1024;
+		rx_ring->fbr[1]->num_entries = 768;
 #endif
-		rx_ring->fbr[1]->buffsize = 16384;
-		rx_ring->fbr[1]->num_entries = 128;
+		rx_ring->fbr[0]->buffsize = 16384;
+		rx_ring->fbr[0]->num_entries = 128;
 	}
 
 #ifdef USE_FBR0
-	adapter->rx_ring.psr_num_entries = adapter->rx_ring.fbr[0]->num_entries +
-	    adapter->rx_ring.fbr[1]->num_entries;
+	adapter->rx_ring.psr_num_entries = adapter->rx_ring.fbr[1]->num_entries +
+	    adapter->rx_ring.fbr[0]->num_entries;
 #else
-	adapter->rx_ring.psr_num_entries = adapter->rx_ring.fbr[1]->num_entries;
+	adapter->rx_ring.psr_num_entries = adapter->rx_ring.fbr[0]->num_entries;
 #endif
 
 	/* Allocate an area of memory for Free Buffer Ring 1 */
-	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[1]->num_entries) + 0xfff;
-	rx_ring->fbr[1]->ring_virtaddr = pci_alloc_consistent(adapter->pdev,
+	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[0]->num_entries) + 0xfff;
+	rx_ring->fbr[0]->ring_virtaddr = pci_alloc_consistent(adapter->pdev,
 						bufsize,
-						&rx_ring->fbr[1]->ring_physaddr);
-	if (!rx_ring->fbr[1]->ring_virtaddr) {
+						&rx_ring->fbr[0]->ring_physaddr);
+	if (!rx_ring->fbr[0]->ring_virtaddr) {
 		dev_err(&adapter->pdev->dev,
 			  "Cannot alloc memory for Free Buffer Ring 1\n");
 		return -ENOMEM;
@@ -1977,24 +1981,24 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 * are ever returned, make sure the high part is retrieved here
 	 * before storing the adjusted address.
 	 */
-	rx_ring->fbr[1]->real_physaddr = rx_ring->fbr[1]->ring_physaddr;
+	rx_ring->fbr[0]->real_physaddr = rx_ring->fbr[0]->ring_physaddr;
 
 	/* Align Free Buffer Ring 1 on a 4K boundary */
 	et131x_align_allocated_memory(adapter,
-				      &rx_ring->fbr[1]->real_physaddr,
-				      &rx_ring->fbr[1]->offset, 0x0FFF);
+				      &rx_ring->fbr[0]->real_physaddr,
+				      &rx_ring->fbr[0]->offset, 0x0FFF);
 
-	rx_ring->fbr[1]->ring_virtaddr =
-			(void *)((u8 *) rx_ring->fbr[1]->ring_virtaddr +
-			rx_ring->fbr[1]->offset);
+	rx_ring->fbr[0]->ring_virtaddr =
+			(void *)((u8 *) rx_ring->fbr[0]->ring_virtaddr +
+			rx_ring->fbr[0]->offset);
 
 #ifdef USE_FBR0
 	/* Allocate an area of memory for Free Buffer Ring 0 */
-	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[0]->num_entries) + 0xfff;
-	rx_ring->fbr[0]->ring_virtaddr = pci_alloc_consistent(adapter->pdev,
+	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[1]->num_entries) + 0xfff;
+	rx_ring->fbr[1]->ring_virtaddr = pci_alloc_consistent(adapter->pdev,
 						bufsize,
-						&rx_ring->fbr[0]->ring_physaddr);
-	if (!rx_ring->fbr[0]->ring_virtaddr) {
+						&rx_ring->fbr[1]->ring_physaddr);
+	if (!rx_ring->fbr[1]->ring_virtaddr) {
 		dev_err(&adapter->pdev->dev,
 			  "Cannot alloc memory for Free Buffer Ring 0\n");
 		return -ENOMEM;
@@ -2007,18 +2011,18 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 * are ever returned, make sure the high part is retrieved here before
 	 * storing the adjusted address.
 	 */
-	rx_ring->fbr[0]->real_physaddr = rx_ring->fbr[0]->ring_physaddr;
+	rx_ring->fbr[1]->real_physaddr = rx_ring->fbr[1]->ring_physaddr;
 
 	/* Align Free Buffer Ring 0 on a 4K boundary */
 	et131x_align_allocated_memory(adapter,
-				      &rx_ring->fbr[0]->real_physaddr,
-				      &rx_ring->fbr[0]->offset, 0x0FFF);
+				      &rx_ring->fbr[1]->real_physaddr,
+				      &rx_ring->fbr[1]->offset, 0x0FFF);
 
-	rx_ring->fbr[0]->ring_virtaddr =
-			(void *)((u8 *) rx_ring->fbr[0]->ring_virtaddr +
-			rx_ring->fbr[0]->offset);
+	rx_ring->fbr[1]->ring_virtaddr =
+			(void *)((u8 *) rx_ring->fbr[1]->ring_virtaddr +
+			rx_ring->fbr[1]->offset);
 #endif
-	for (i = 0; i < (rx_ring->fbr[1]->num_entries / FBR_CHUNKS); i++) {
+	for (i = 0; i < (rx_ring->fbr[0]->num_entries / FBR_CHUNKS); i++) {
 		u64 fbr1_offset;
 		u64 fbr1_tmp_physaddr;
 		u32 fbr1_align;
@@ -2030,25 +2034,25 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 		 * the size of FBR0.  By allocating N buffers at once, we
 		 * reduce this overhead.
 		 */
-		if (rx_ring->fbr[1]->buffsize > 4096)
+		if (rx_ring->fbr[0]->buffsize > 4096)
 			fbr1_align = 4096;
 		else
-			fbr1_align = rx_ring->fbr[1]->buffsize;
+			fbr1_align = rx_ring->fbr[0]->buffsize;
 
 		fbr_chunksize =
-		    (FBR_CHUNKS * rx_ring->fbr[1]->buffsize) + fbr1_align - 1;
-		rx_ring->fbr[1]->mem_virtaddrs[i] =
+		    (FBR_CHUNKS * rx_ring->fbr[0]->buffsize) + fbr1_align - 1;
+		rx_ring->fbr[0]->mem_virtaddrs[i] =
 		    pci_alloc_consistent(adapter->pdev, fbr_chunksize,
-					 &rx_ring->fbr[1]->mem_physaddrs[i]);
+					 &rx_ring->fbr[0]->mem_physaddrs[i]);
 
-		if (!rx_ring->fbr[1]->mem_virtaddrs[i]) {
+		if (!rx_ring->fbr[0]->mem_virtaddrs[i]) {
 			dev_err(&adapter->pdev->dev,
 				"Could not alloc memory\n");
 			return -ENOMEM;
 		}
 
 		/* See NOTE in "Save Physical Address" comment above */
-		fbr1_tmp_physaddr = rx_ring->fbr[1]->mem_physaddrs[i];
+		fbr1_tmp_physaddr = rx_ring->fbr[0]->mem_physaddrs[i];
 
 		et131x_align_allocated_memory(adapter,
 					      &fbr1_tmp_physaddr,
@@ -2060,71 +2064,71 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			/* Save the Virtual address of this index for quick
 			 * access later
 			 */
-			rx_ring->fbr[1]->virt[index] =
-			    (u8 *) rx_ring->fbr[1]->mem_virtaddrs[i] +
-			    (j * rx_ring->fbr[1]->buffsize) + fbr1_offset;
+			rx_ring->fbr[0]->virt[index] =
+			    (u8 *) rx_ring->fbr[0]->mem_virtaddrs[i] +
+			    (j * rx_ring->fbr[0]->buffsize) + fbr1_offset;
 
 			/* now store the physical address in the descriptor
 			 * so the device can access it
 			 */
-			rx_ring->fbr[1]->bus_high[index] =
+			rx_ring->fbr[0]->bus_high[index] =
 			    (u32) (fbr1_tmp_physaddr >> 32);
-			rx_ring->fbr[1]->bus_low[index] =
+			rx_ring->fbr[0]->bus_low[index] =
 			    (u32) fbr1_tmp_physaddr;
 
-			fbr1_tmp_physaddr += rx_ring->fbr[1]->buffsize;
+			fbr1_tmp_physaddr += rx_ring->fbr[0]->buffsize;
 
-			rx_ring->fbr[1]->buffer1[index] =
-			    rx_ring->fbr[1]->virt[index];
-			rx_ring->fbr[1]->buffer2[index] =
-			    rx_ring->fbr[1]->virt[index] - 4;
+			rx_ring->fbr[0]->buffer1[index] =
+			    rx_ring->fbr[0]->virt[index];
+			rx_ring->fbr[0]->buffer2[index] =
+			    rx_ring->fbr[0]->virt[index] - 4;
 		}
 	}
 
 #ifdef USE_FBR0
 	/* Same for FBR0 (if in use) */
-	for (i = 0; i < (rx_ring->fbr[0]->num_entries / FBR_CHUNKS); i++) {
+	for (i = 0; i < (rx_ring->fbr[1]->num_entries / FBR_CHUNKS); i++) {
 		u64 fbr0_offset;
 		u64 fbr0_tmp_physaddr;
 
 		fbr_chunksize =
-		    ((FBR_CHUNKS + 1) * rx_ring->fbr[0]->buffsize) - 1;
-		rx_ring->fbr[0]->mem_virtaddrs[i] =
+		    ((FBR_CHUNKS + 1) * rx_ring->fbr[1]->buffsize) - 1;
+		rx_ring->fbr[1]->mem_virtaddrs[i] =
 		    pci_alloc_consistent(adapter->pdev, fbr_chunksize,
-					 &rx_ring->fbr[0]->mem_physaddrs[i]);
+					 &rx_ring->fbr[1]->mem_physaddrs[i]);
 
-		if (!rx_ring->fbr[0]->mem_virtaddrs[i]) {
+		if (!rx_ring->fbr[1]->mem_virtaddrs[i]) {
 			dev_err(&adapter->pdev->dev,
 				"Could not alloc memory\n");
 			return -ENOMEM;
 		}
 
 		/* See NOTE in "Save Physical Address" comment above */
-		fbr0_tmp_physaddr = rx_ring->fbr[0]->mem_physaddrs[i];
+		fbr0_tmp_physaddr = rx_ring->fbr[1]->mem_physaddrs[i];
 
 		et131x_align_allocated_memory(adapter,
 					      &fbr0_tmp_physaddr,
 					      &fbr0_offset,
-					      rx_ring->fbr[0]->buffsize - 1);
+					      rx_ring->fbr[1]->buffsize - 1);
 
 		for (j = 0; j < FBR_CHUNKS; j++) {
 			u32 index = (i * FBR_CHUNKS) + j;
 
-			rx_ring->fbr[0]->virt[index] =
-			    (u8 *) rx_ring->fbr[0]->mem_virtaddrs[i] +
-			    (j * rx_ring->fbr[0]->buffsize) + fbr0_offset;
+			rx_ring->fbr[1]->virt[index] =
+			    (u8 *) rx_ring->fbr[1]->mem_virtaddrs[i] +
+			    (j * rx_ring->fbr[1]->buffsize) + fbr0_offset;
 
-			rx_ring->fbr[0]->bus_high[index] =
+			rx_ring->fbr[1]->bus_high[index] =
 			    (u32) (fbr0_tmp_physaddr >> 32);
-			rx_ring->fbr[0]->bus_low[index] =
+			rx_ring->fbr[1]->bus_low[index] =
 			    (u32) fbr0_tmp_physaddr;
 
-			fbr0_tmp_physaddr += rx_ring->fbr[0]->buffsize;
+			fbr0_tmp_physaddr += rx_ring->fbr[1]->buffsize;
 
-			rx_ring->fbr[0]->buffer1[index] =
-			    rx_ring->fbr[0]->virt[index];
-			rx_ring->fbr[0]->buffer2[index] =
-			    rx_ring->fbr[0]->virt[index] - 4;
+			rx_ring->fbr[1]->buffer1[index] =
+			    rx_ring->fbr[1]->virt[index];
+			rx_ring->fbr[1]->buffer2[index] =
+			    rx_ring->fbr[1]->virt[index] - 4;
 		}
 	}
 #endif
@@ -2214,78 +2218,78 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 	}
 
 	/* Free Free Buffer Ring 1 */
-	if (rx_ring->fbr[1]->ring_virtaddr) {
+	if (rx_ring->fbr[0]->ring_virtaddr) {
 		/* First the packet memory */
 		for (index = 0; index <
-		     (rx_ring->fbr[1]->num_entries / FBR_CHUNKS); index++) {
-			if (rx_ring->fbr[1]->mem_virtaddrs[index]) {
+		     (rx_ring->fbr[0]->num_entries / FBR_CHUNKS); index++) {
+			if (rx_ring->fbr[0]->mem_virtaddrs[index]) {
 				u32 fbr1_align;
 
-				if (rx_ring->fbr[1]->buffsize > 4096)
+				if (rx_ring->fbr[0]->buffsize > 4096)
 					fbr1_align = 4096;
 				else
-					fbr1_align = rx_ring->fbr[1]->buffsize;
+					fbr1_align = rx_ring->fbr[0]->buffsize;
 
 				bufsize =
-				    (rx_ring->fbr[1]->buffsize * FBR_CHUNKS) +
+				    (rx_ring->fbr[0]->buffsize * FBR_CHUNKS) +
 				    fbr1_align - 1;
 
 				pci_free_consistent(adapter->pdev,
 					bufsize,
-					rx_ring->fbr[1]->mem_virtaddrs[index],
-					rx_ring->fbr[1]->mem_physaddrs[index]);
+					rx_ring->fbr[0]->mem_virtaddrs[index],
+					rx_ring->fbr[0]->mem_physaddrs[index]);
 
-				rx_ring->fbr[1]->mem_virtaddrs[index] = NULL;
+				rx_ring->fbr[0]->mem_virtaddrs[index] = NULL;
 			}
 		}
 
 		/* Now the FIFO itself */
-		rx_ring->fbr[1]->ring_virtaddr = (void *)((u8 *)
-			rx_ring->fbr[1]->ring_virtaddr - rx_ring->fbr[1]->offset);
+		rx_ring->fbr[0]->ring_virtaddr = (void *)((u8 *)
+			rx_ring->fbr[0]->ring_virtaddr - rx_ring->fbr[0]->offset);
 
-		bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[1]->num_entries)
+		bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[0]->num_entries)
 							    + 0xfff;
 
 		pci_free_consistent(adapter->pdev, bufsize,
-				    rx_ring->fbr[1]->ring_virtaddr,
-				    rx_ring->fbr[1]->ring_physaddr);
+				    rx_ring->fbr[0]->ring_virtaddr,
+				    rx_ring->fbr[0]->ring_physaddr);
 
-		rx_ring->fbr[1]->ring_virtaddr = NULL;
+		rx_ring->fbr[0]->ring_virtaddr = NULL;
 	}
 
 #ifdef USE_FBR0
 	/* Now the same for Free Buffer Ring 0 */
-	if (rx_ring->fbr[0]->ring_virtaddr) {
+	if (rx_ring->fbr[1]->ring_virtaddr) {
 		/* First the packet memory */
 		for (index = 0; index <
-		     (rx_ring->fbr[0]->num_entries / FBR_CHUNKS); index++) {
-			if (rx_ring->fbr[0]->mem_virtaddrs[index]) {
+		     (rx_ring->fbr[1]->num_entries / FBR_CHUNKS); index++) {
+			if (rx_ring->fbr[1]->mem_virtaddrs[index]) {
 				bufsize =
-				    (rx_ring->fbr[0]->buffsize *
+				    (rx_ring->fbr[1]->buffsize *
 				     (FBR_CHUNKS + 1)) - 1;
 
 				pci_free_consistent(adapter->pdev,
 					bufsize,
-					rx_ring->fbr[0]->mem_virtaddrs[index],
-					rx_ring->fbr[0]->mem_physaddrs[index]);
+					rx_ring->fbr[1]->mem_virtaddrs[index],
+					rx_ring->fbr[1]->mem_physaddrs[index]);
 
-				rx_ring->fbr[0]->mem_virtaddrs[index] = NULL;
+				rx_ring->fbr[1]->mem_virtaddrs[index] = NULL;
 			}
 		}
 
 		/* Now the FIFO itself */
-		rx_ring->fbr[0]->ring_virtaddr = (void *)((u8 *)
-			rx_ring->fbr[0]->ring_virtaddr - rx_ring->fbr[0]->offset);
+		rx_ring->fbr[1]->ring_virtaddr = (void *)((u8 *)
+			rx_ring->fbr[1]->ring_virtaddr - rx_ring->fbr[1]->offset);
 
-		bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[0]->num_entries)
+		bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[1]->num_entries)
 							    + 0xfff;
 
 		pci_free_consistent(adapter->pdev,
 				    bufsize,
-				    rx_ring->fbr[0]->ring_virtaddr,
-				    rx_ring->fbr[0]->ring_physaddr);
+				    rx_ring->fbr[1]->ring_virtaddr,
+				    rx_ring->fbr[1]->ring_physaddr);
 
-		rx_ring->fbr[0]->ring_virtaddr = NULL;
+		rx_ring->fbr[1]->ring_virtaddr = NULL;
 	}
 #endif
 
@@ -2322,10 +2326,10 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 
 	/* Free the FBR Lookup Table */
 #ifdef USE_FBR0
-	kfree(rx_ring->fbr[0]);
+	kfree(rx_ring->fbr[1]);
 #endif
 
-	kfree(rx_ring->fbr[1]);
+	kfree(rx_ring->fbr[0]);
 
 	/* Reset Counters */
 	rx_ring->num_ready_recv = 0;
@@ -2431,10 +2435,10 @@ void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 	rx_local->local_psr_full = 0;
 
 	/* Now's the best time to initialize FBR1 contents */
-	fbr_entry = (struct fbr_desc *) rx_local->fbr[1]->ring_virtaddr;
-	for (entry = 0; entry < rx_local->fbr[1]->num_entries; entry++) {
-		fbr_entry->addr_hi = rx_local->fbr[1]->bus_high[entry];
-		fbr_entry->addr_lo = rx_local->fbr[1]->bus_low[entry];
+	fbr_entry = (struct fbr_desc *) rx_local->fbr[0]->ring_virtaddr;
+	for (entry = 0; entry < rx_local->fbr[0]->num_entries; entry++) {
+		fbr_entry->addr_hi = rx_local->fbr[0]->bus_high[entry];
+		fbr_entry->addr_lo = rx_local->fbr[0]->bus_low[entry];
 		fbr_entry->word2 = entry;
 		fbr_entry++;
 	}
@@ -2442,42 +2446,42 @@ void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 	/* Set the address and parameters of Free buffer ring 1 (and 0 if
 	 * required) into the 1310's registers
 	 */
-	writel((u32) (rx_local->fbr[1]->real_physaddr >> 32),
+	writel((u32) (rx_local->fbr[0]->real_physaddr >> 32),
 	       &rx_dma->fbr1_base_hi);
-	writel((u32) rx_local->fbr[1]->real_physaddr, &rx_dma->fbr1_base_lo);
-	writel(rx_local->fbr[1]->num_entries - 1, &rx_dma->fbr1_num_des);
+	writel((u32) rx_local->fbr[0]->real_physaddr, &rx_dma->fbr1_base_lo);
+	writel(rx_local->fbr[0]->num_entries - 1, &rx_dma->fbr1_num_des);
 	writel(ET_DMA10_WRAP, &rx_dma->fbr1_full_offset);
 
 	/* This variable tracks the free buffer ring 1 full position, so it
 	 * has to match the above.
 	 */
-	rx_local->fbr[1]->local_full = ET_DMA10_WRAP;
+	rx_local->fbr[0]->local_full = ET_DMA10_WRAP;
 	writel(
-	    ((rx_local->fbr[1]->num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
+	    ((rx_local->fbr[0]->num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
 	    &rx_dma->fbr1_min_des);
 
 #ifdef USE_FBR0
 	/* Now's the best time to initialize FBR0 contents */
-	fbr_entry = (struct fbr_desc *) rx_local->fbr[0]->ring_virtaddr;
-	for (entry = 0; entry < rx_local->fbr[0]->num_entries; entry++) {
-		fbr_entry->addr_hi = rx_local->fbr[0]->bus_high[entry];
-		fbr_entry->addr_lo = rx_local->fbr[0]->bus_low[entry];
+	fbr_entry = (struct fbr_desc *) rx_local->fbr[1]->ring_virtaddr;
+	for (entry = 0; entry < rx_local->fbr[1]->num_entries; entry++) {
+		fbr_entry->addr_hi = rx_local->fbr[1]->bus_high[entry];
+		fbr_entry->addr_lo = rx_local->fbr[1]->bus_low[entry];
 		fbr_entry->word2 = entry;
 		fbr_entry++;
 	}
 
-	writel((u32) (rx_local->fbr[0]->real_physaddr >> 32),
+	writel((u32) (rx_local->fbr[1]->real_physaddr >> 32),
 	       &rx_dma->fbr0_base_hi);
-	writel((u32) rx_local->fbr[0]->real_physaddr, &rx_dma->fbr0_base_lo);
-	writel(rx_local->fbr[0]->num_entries - 1, &rx_dma->fbr0_num_des);
+	writel((u32) rx_local->fbr[1]->real_physaddr, &rx_dma->fbr0_base_lo);
+	writel(rx_local->fbr[1]->num_entries - 1, &rx_dma->fbr0_num_des);
 	writel(ET_DMA10_WRAP, &rx_dma->fbr0_full_offset);
 
 	/* This variable tracks the free buffer ring 0 full position, so it
 	 * has to match the above.
 	 */
-	rx_local->fbr[0]->local_full = ET_DMA10_WRAP;
+	rx_local->fbr[1]->local_full = ET_DMA10_WRAP;
 	writel(
-	    ((rx_local->fbr[0]->num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
+	    ((rx_local->fbr[1]->num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
 	    &rx_dma->fbr0_min_des);
 #endif
 
@@ -2536,45 +2540,45 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 	 */
 	if (
 #ifdef USE_FBR0
-	    (ring_index == 0 && buff_index < rx_local->fbr[0]->num_entries) ||
+	    (ring_index == 0 && buff_index < rx_local->fbr[1]->num_entries) ||
 #endif
-	    (ring_index == 1 && buff_index < rx_local->fbr[1]->num_entries)) {
+	    (ring_index == 1 && buff_index < rx_local->fbr[0]->num_entries)) {
 		spin_lock_irqsave(&adapter->fbr_lock, flags);
 
 		if (ring_index == 1) {
 			struct fbr_desc *next =
-			    (struct fbr_desc *) (rx_local->fbr[1]->ring_virtaddr) +
-					 INDEX10(rx_local->fbr[1]->local_full);
+			    (struct fbr_desc *) (rx_local->fbr[0]->ring_virtaddr) +
+					 INDEX10(rx_local->fbr[0]->local_full);
 
 			/* Handle the Free Buffer Ring advancement here. Write
 			 * the PA / Buffer Index for the returned buffer into
 			 * the oldest (next to be freed)FBR entry
 			 */
-			next->addr_hi = rx_local->fbr[1]->bus_high[buff_index];
-			next->addr_lo = rx_local->fbr[1]->bus_low[buff_index];
+			next->addr_hi = rx_local->fbr[0]->bus_high[buff_index];
+			next->addr_lo = rx_local->fbr[0]->bus_low[buff_index];
 			next->word2 = buff_index;
 
-			writel(bump_free_buff_ring(&rx_local->fbr[1]->local_full,
-				rx_local->fbr[1]->num_entries - 1),
+			writel(bump_free_buff_ring(&rx_local->fbr[0]->local_full,
+				rx_local->fbr[0]->num_entries - 1),
 				&rx_dma->fbr1_full_offset);
 		}
 #ifdef USE_FBR0
 		else {
 			struct fbr_desc *next = (struct fbr_desc *)
-				rx_local->fbr[0]->ring_virtaddr +
-				    INDEX10(rx_local->fbr[0]->local_full);
+				rx_local->fbr[1]->ring_virtaddr +
+				    INDEX10(rx_local->fbr[1]->local_full);
 
 			/* Handle the Free Buffer Ring advancement here. Write
 			 * the PA / Buffer Index for the returned buffer into
 			 * the oldest (next to be freed) FBR entry
 			 */
-			next->addr_hi = rx_local->fbr[0]->bus_high[buff_index];
-			next->addr_lo = rx_local->fbr[0]->bus_low[buff_index];
+			next->addr_hi = rx_local->fbr[1]->bus_high[buff_index];
+			next->addr_lo = rx_local->fbr[1]->bus_low[buff_index];
 			next->word2 = buff_index;
 
 			writel(bump_free_buff_ring(
-					&rx_local->fbr[0]->local_full,
-					rx_local->fbr[0]->num_entries - 1),
+					&rx_local->fbr[1]->local_full,
+					rx_local->fbr[1]->num_entries - 1),
 			       &rx_dma->fbr0_full_offset);
 		}
 #endif
@@ -2624,19 +2628,19 @@ void et131x_rx_dma_enable(struct et131x_adapter *adapter)
 	/* Setup the receive dma configuration register for normal operation */
 	u32 csr =  0x2000;	/* FBR1 enable */
 
-	if (adapter->rx_ring.fbr[1]->buffsize == 4096)
+	if (adapter->rx_ring.fbr[0]->buffsize == 4096)
 		csr |= 0x0800;
-	else if (adapter->rx_ring.fbr[1]->buffsize == 8192)
+	else if (adapter->rx_ring.fbr[0]->buffsize == 8192)
 		csr |= 0x1000;
-	else if (adapter->rx_ring.fbr[1]->buffsize == 16384)
+	else if (adapter->rx_ring.fbr[0]->buffsize == 16384)
 		csr |= 0x1800;
 #ifdef USE_FBR0
 	csr |= 0x0400;		/* FBR0 enable */
-	if (adapter->rx_ring.fbr[0]->buffsize == 256)
+	if (adapter->rx_ring.fbr[1]->buffsize == 256)
 		csr |= 0x0100;
-	else if (adapter->rx_ring.fbr[0]->buffsize == 512)
+	else if (adapter->rx_ring.fbr[1]->buffsize == 512)
 		csr |= 0x0200;
-	else if (adapter->rx_ring.fbr[0]->buffsize == 1024)
+	else if (adapter->rx_ring.fbr[1]->buffsize == 1024)
 		csr |= 0x0300;
 #endif
 	writel(csr, &adapter->regs->rxdma.csr);
@@ -2737,11 +2741,11 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 #ifdef USE_FBR0
 	if (ring_index > 1 ||
 		(ring_index == 0 &&
-		buff_index > rx_local->fbr[0]->num_entries - 1) ||
+		buff_index > rx_local->fbr[1]->num_entries - 1) ||
 		(ring_index == 1 &&
-		buff_index > rx_local->fbr[1]->num_entries - 1))
+		buff_index > rx_local->fbr[0]->num_entries - 1))
 #else
-	if (ring_index != 1 || buff_index > rx_local->fbr[1]->num_entries - 1)
+	if (ring_index != 1 || buff_index > rx_local->fbr[0]->num_entries - 1)
 #endif
 	{
 		/* Illegal buffer or ring index cannot be used by S/W*/
@@ -2800,7 +2804,11 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 					ET131X_PACKET_TYPE_PROMISCUOUS)
 			    && !(adapter->packet_filter &
 					ET131X_PACKET_TYPE_ALL_MULTICAST)) {
-				buf = rx_local->fbr[ring_index]->
+				/*
+				 * Note - ring_index for fbr[] array is reversed
+				 * 1 for FBR0 etc
+				 */
+				buf = rx_local->fbr[(ring_index == 0 ? 1 : 0)]->
 						virt[buff_index];
 
 				/* Loop through our list to see if the
@@ -2865,8 +2873,12 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 
 		adapter->net_stats.rx_bytes += rfd->len;
 
+		/*
+		 * Note - ring_index for fbr[] array is reversed,
+		 * 1 for FBR0 etc
+		 */
 		memcpy(skb_put(skb, rfd->len),
-		       rx_local->fbr[ring_index]->virt[buff_index],
+		       rx_local->fbr[(ring_index == 0 ? 1 : 0)]->virt[buff_index],
 		       rfd->len);
 
 		skb->dev = adapter->netdev;
-- 
1.7.6.4

