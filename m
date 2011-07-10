Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab1GJPhs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 11:37:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33989 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab1GJPga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 11:36:30 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 07/10] staging: et131x: Converting et1310_rx.h variable names from CamelCase
Date: Sun, 10 Jul 2011 16:35:32 +0100
Message-Id: <1310312135-28407-8-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
References: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on an ET-131x device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_rx.c  |  338 ++++++++++++++++++-----------------
 drivers/staging/et131x/et1310_rx.h  |   62 ++++----
 drivers/staging/et131x/et131x_isr.c |    2 +-
 3 files changed, 205 insertions(+), 197 deletions(-)

diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index 926ea66..694bb02 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -151,40 +151,40 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 	if (adapter->RegistryJumboPacket < 2048) {
 #ifdef USE_FBR0
-		rx_ring->Fbr0BufferSize = 256;
-		rx_ring->Fbr0NumEntries = 512;
+		rx_ring->fbr0_buffsize = 256;
+		rx_ring->fbr0_num_entries = 512;
 #endif
-		rx_ring->Fbr1BufferSize = 2048;
-		rx_ring->Fbr1NumEntries = 512;
+		rx_ring->fbr1_buffsize = 2048;
+		rx_ring->fbr1_num_entries = 512;
 	} else if (adapter->RegistryJumboPacket < 4096) {
 #ifdef USE_FBR0
-		rx_ring->Fbr0BufferSize = 512;
-		rx_ring->Fbr0NumEntries = 1024;
+		rx_ring->fbr0_buffsize = 512;
+		rx_ring->fbr0_num_entries = 1024;
 #endif
-		rx_ring->Fbr1BufferSize = 4096;
-		rx_ring->Fbr1NumEntries = 512;
+		rx_ring->fbr1_buffsize = 4096;
+		rx_ring->fbr1_num_entries = 512;
 	} else {
 #ifdef USE_FBR0
-		rx_ring->Fbr0BufferSize = 1024;
-		rx_ring->Fbr0NumEntries = 768;
+		rx_ring->fbr0_buffsize = 1024;
+		rx_ring->fbr0_num_entries = 768;
 #endif
-		rx_ring->Fbr1BufferSize = 16384;
-		rx_ring->Fbr1NumEntries = 128;
+		rx_ring->fbr1_buffsize = 16384;
+		rx_ring->fbr1_num_entries = 128;
 	}
 
 #ifdef USE_FBR0
-	adapter->rx_ring.PsrNumEntries = adapter->rx_ring.Fbr0NumEntries +
-	    adapter->rx_ring.Fbr1NumEntries;
+	adapter->rx_ring.psr_num_entries = adapter->rx_ring.fbr0_num_entries +
+	    adapter->rx_ring.fbr1_num_entries;
 #else
-	adapter->rx_ring.PsrNumEntries = adapter->rx_ring.Fbr1NumEntries;
+	adapter->rx_ring.psr_num_entries = adapter->rx_ring.fbr1_num_entries;
 #endif
 
 	/* Allocate an area of memory for Free Buffer Ring 1 */
-	bufsize = (sizeof(struct fbr_desc) * rx_ring->Fbr1NumEntries) + 0xfff;
-	rx_ring->pFbr1RingVa = pci_alloc_consistent(adapter->pdev,
-						    bufsize,
-						    &rx_ring->pFbr1RingPa);
-	if (!rx_ring->pFbr1RingVa) {
+	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr1_num_entries) + 0xfff;
+	rx_ring->fbr1_ring_virtaddr = pci_alloc_consistent(adapter->pdev,
+						bufsize,
+						&rx_ring->fbr1_ring_physaddr);
+	if (!rx_ring->fbr1_ring_virtaddr) {
 		dev_err(&adapter->pdev->dev,
 			  "Cannot alloc memory for Free Buffer Ring 1\n");
 		return -ENOMEM;
@@ -197,23 +197,24 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 * are ever returned, make sure the high part is retrieved here
 	 * before storing the adjusted address.
 	 */
-	rx_ring->Fbr1Realpa = rx_ring->pFbr1RingPa;
+	rx_ring->fbr1_real_physaddr = rx_ring->fbr1_ring_physaddr;
 
 	/* Align Free Buffer Ring 1 on a 4K boundary */
 	et131x_align_allocated_memory(adapter,
-				      &rx_ring->Fbr1Realpa,
-				      &rx_ring->Fbr1offset, 0x0FFF);
+				      &rx_ring->fbr1_real_physaddr,
+				      &rx_ring->fbr1_offset, 0x0FFF);
 
-	rx_ring->pFbr1RingVa = (void *)((u8 *) rx_ring->pFbr1RingVa +
-					rx_ring->Fbr1offset);
+	rx_ring->fbr1_ring_virtaddr =
+			(void *)((u8 *) rx_ring->fbr1_ring_virtaddr +
+			rx_ring->fbr1_offset);
 
 #ifdef USE_FBR0
 	/* Allocate an area of memory for Free Buffer Ring 0 */
-	bufsize = (sizeof(struct fbr_desc) * rx_ring->Fbr0NumEntries) + 0xfff;
-	rx_ring->pFbr0RingVa = pci_alloc_consistent(adapter->pdev,
-						    bufsize,
-						    &rx_ring->pFbr0RingPa);
-	if (!rx_ring->pFbr0RingVa) {
+	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr0_num_entries) + 0xfff;
+	rx_ring->fbr0_ring_virtaddr = pci_alloc_consistent(adapter->pdev,
+						bufsize,
+						&rx_ring->fbr0_ring_physaddr);
+	if (!rx_ring->fbr0_ring_virtaddr) {
 		dev_err(&adapter->pdev->dev,
 			  "Cannot alloc memory for Free Buffer Ring 0\n");
 		return -ENOMEM;
@@ -226,19 +227,18 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 * are ever returned, make sure the high part is retrieved here before
 	 * storing the adjusted address.
 	 */
-	rx_ring->Fbr0Realpa = rx_ring->pFbr0RingPa;
+	rx_ring->fbr0_real_physaddr = rx_ring->fbr0_ring_physaddr;
 
 	/* Align Free Buffer Ring 0 on a 4K boundary */
 	et131x_align_allocated_memory(adapter,
-				      &rx_ring->Fbr0Realpa,
-				      &rx_ring->Fbr0offset, 0x0FFF);
+				      &rx_ring->fbr0_real_physaddr,
+				      &rx_ring->fbr0_offset, 0x0FFF);
 
-	rx_ring->pFbr0RingVa = (void *)((u8 *) rx_ring->pFbr0RingVa +
-					rx_ring->Fbr0offset);
+	rx_ring->fbr0_ring_virtaddr =
+				(void *)((u8 *) rx_ring->fbr0_ring_virtaddr +
+				rx_ring->fbr0_offset);
 #endif
-
-	for (i = 0; i < (rx_ring->Fbr1NumEntries / FBR_CHUNKS);
-	     i++) {
+	for (i = 0; i < (rx_ring->fbr1_num_entries / FBR_CHUNKS); i++) {
 		u64 fbr1_offset;
 		u64 fbr1_tmp_physaddr;
 		u32 fbr1_align;
@@ -250,25 +250,25 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 		 * the size of FBR0.  By allocating N buffers at once, we
 		 * reduce this overhead.
 		 */
-		if (rx_ring->Fbr1BufferSize > 4096)
+		if (rx_ring->fbr1_buffsize > 4096)
 			fbr1_align = 4096;
 		else
-			fbr1_align = rx_ring->Fbr1BufferSize;
+			fbr1_align = rx_ring->fbr1_buffsize;
 
 		fbr_chunksize =
-		    (FBR_CHUNKS * rx_ring->Fbr1BufferSize) + fbr1_align - 1;
-		rx_ring->Fbr1MemVa[i] =
+		    (FBR_CHUNKS * rx_ring->fbr1_buffsize) + fbr1_align - 1;
+		rx_ring->fbr1_mem_virtaddrs[i] =
 		    pci_alloc_consistent(adapter->pdev, fbr_chunksize,
-					 &rx_ring->Fbr1MemPa[i]);
+					 &rx_ring->fbr1_mem_physaddrs[i]);
 
-		if (!rx_ring->Fbr1MemVa[i]) {
+		if (!rx_ring->fbr1_mem_virtaddrs[i]) {
 			dev_err(&adapter->pdev->dev,
 				"Could not alloc memory\n");
 			return -ENOMEM;
 		}
 
 		/* See NOTE in "Save Physical Address" comment above */
-		fbr1_tmp_physaddr = rx_ring->Fbr1MemPa[i];
+		fbr1_tmp_physaddr = rx_ring->fbr1_mem_physaddrs[i];
 
 		et131x_align_allocated_memory(adapter,
 					      &fbr1_tmp_physaddr,
@@ -281,8 +281,8 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			 * access later
 			 */
 			rx_ring->fbr[1]->virt[index] =
-			    (u8 *) rx_ring->Fbr1MemVa[i] +
-			    (j * rx_ring->Fbr1BufferSize) + fbr1_offset;
+			    (u8 *) rx_ring->fbr1_mem_virtaddrs[i] +
+			    (j * rx_ring->fbr1_buffsize) + fbr1_offset;
 
 			/* now store the physical address in the descriptor
 			 * so the device can access it
@@ -292,7 +292,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			rx_ring->fbr[1]->bus_low[index] =
 			    (u32) fbr1_tmp_physaddr;
 
-			fbr1_tmp_physaddr += rx_ring->Fbr1BufferSize;
+			fbr1_tmp_physaddr += rx_ring->fbr1_buffsize;
 
 			rx_ring->fbr[1]->buffer1[index] =
 			    rx_ring->fbr[1]->virt[index];
@@ -303,44 +303,43 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 #ifdef USE_FBR0
 	/* Same for FBR0 (if in use) */
-	for (i = 0; i < (rx_ring->Fbr0NumEntries / FBR_CHUNKS);
-	     i++) {
+	for (i = 0; i < (rx_ring->fbr0_num_entries / FBR_CHUNKS); i++) {
 		u64 fbr0_offset;
 		u64 fbr0_tmp_physaddr;
 
 		fbr_chunksize =
-		    ((FBR_CHUNKS + 1) * rx_ring->Fbr0BufferSize) - 1;
-		rx_ring->Fbr0MemVa[i] =
+		    ((FBR_CHUNKS + 1) * rx_ring->fbr0_buffsize) - 1;
+		rx_ring->fbr0_mem_virtaddrs[i] =
 		    pci_alloc_consistent(adapter->pdev, fbr_chunksize,
-					 &rx_ring->Fbr0MemPa[i]);
+					 &rx_ring->fbr0_mem_physaddrs[i]);
 
-		if (!rx_ring->Fbr0MemVa[i]) {
+		if (!rx_ring->fbr0_mem_virtaddrs[i]) {
 			dev_err(&adapter->pdev->dev,
 				"Could not alloc memory\n");
 			return -ENOMEM;
 		}
 
 		/* See NOTE in "Save Physical Address" comment above */
-		fbr0_tmp_physaddr = rx_ring->Fbr0MemPa[i];
+		fbr0_tmp_physaddr = rx_ring->fbr0_mem_physaddrs[i];
 
 		et131x_align_allocated_memory(adapter,
 					      &fbr0_tmp_physaddr,
 					      &fbr0_offset,
-					      rx_ring->Fbr0BufferSize - 1);
+					      rx_ring->fbr0_buffsize - 1);
 
 		for (j = 0; j < FBR_CHUNKS; j++) {
 			u32 index = (i * FBR_CHUNKS) + j;
 
 			rx_ring->fbr[0]->virt[index] =
-			    (u8 *) rx_ring->Fbr0MemVa[i] +
-			    (j * rx_ring->Fbr0BufferSize) + fbr0_offset;
+			    (u8 *) rx_ring->fbr0_mem_virtaddrs[i] +
+			    (j * rx_ring->fbr0_buffsize) + fbr0_offset;
 
 			rx_ring->fbr[0]->bus_high[index] =
 			    (u32) (fbr0_tmp_physaddr >> 32);
 			rx_ring->fbr[0]->bus_low[index] =
 			    (u32) fbr0_tmp_physaddr;
 
-			fbr0_tmp_physaddr += rx_ring->Fbr0BufferSize;
+			fbr0_tmp_physaddr += rx_ring->fbr0_buffsize;
 
 			rx_ring->fbr[0]->buffer1[index] =
 			    rx_ring->fbr[0]->virt[index];
@@ -352,19 +351,19 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 	/* Allocate an area of memory for FIFO of Packet Status ring entries */
 	pktstat_ringsize =
-	    sizeof(struct pkt_stat_desc) * adapter->rx_ring.PsrNumEntries;
+	    sizeof(struct pkt_stat_desc) * adapter->rx_ring.psr_num_entries;
 
-	rx_ring->pPSRingVa = pci_alloc_consistent(adapter->pdev,
+	rx_ring->ps_ring_virtaddr = pci_alloc_consistent(adapter->pdev,
 						  pktstat_ringsize,
-						  &rx_ring->pPSRingPa);
+						  &rx_ring->ps_ring_physaddr);
 
-	if (!rx_ring->pPSRingVa) {
+	if (!rx_ring->ps_ring_virtaddr) {
 		dev_err(&adapter->pdev->dev,
 			  "Cannot alloc memory for Packet Status Ring\n");
 		return -ENOMEM;
 	}
 	printk(KERN_INFO "Packet Status Ring %lx\n",
-	    (unsigned long) rx_ring->pPSRingPa);
+	    (unsigned long) rx_ring->ps_ring_physaddr);
 
 	/*
 	 * NOTE : pci_alloc_consistent(), used above to alloc DMA regions,
@@ -382,7 +381,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			  "Cannot alloc memory for Status Block\n");
 		return -ENOMEM;
 	}
-	rx_ring->NumRfd = NIC_DEFAULT_NUM_RFD;
+	rx_ring->num_rfd = NIC_DEFAULT_NUM_RFD;
 	printk(KERN_INFO "PRS %lx\n", (unsigned long)rx_ring->rx_status_bus);
 
 	/* Recv
@@ -391,7 +390,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 * freed to the lookaside list.
 	 * RFDs will be allocated from this pool.
 	 */
-	rx_ring->RecvLookaside = kmem_cache_create(adapter->netdev->name,
+	rx_ring->recv_lookaside = kmem_cache_create(adapter->netdev->name,
 						   sizeof(struct rfd),
 						   0,
 						   SLAB_CACHE_DMA |
@@ -403,7 +402,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	/* The RFDs are going to be put on lists later on, so initialize the
 	 * lists now.
 	 */
-	INIT_LIST_HEAD(&rx_ring->RecvList);
+	INIT_LIST_HEAD(&rx_ring->recv_list);
 	return 0;
 }
 
@@ -423,100 +422,104 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 	rx_ring = &adapter->rx_ring;
 
 	/* Free RFDs and associated packet descriptors */
-	WARN_ON(rx_ring->nReadyRecv != rx_ring->NumRfd);
+	WARN_ON(rx_ring->num_ready_recv != rx_ring->num_rfd);
 
-	while (!list_empty(&rx_ring->RecvList)) {
-		rfd = (struct rfd *) list_entry(rx_ring->RecvList.next,
+	while (!list_empty(&rx_ring->recv_list)) {
+		rfd = (struct rfd *) list_entry(rx_ring->recv_list.next,
 				struct rfd, list_node);
 
 		list_del(&rfd->list_node);
 		rfd->skb = NULL;
-		kmem_cache_free(adapter->rx_ring.RecvLookaside, rfd);
+		kmem_cache_free(adapter->rx_ring.recv_lookaside, rfd);
 	}
 
 	/* Free Free Buffer Ring 1 */
-	if (rx_ring->pFbr1RingVa) {
+	if (rx_ring->fbr1_ring_virtaddr) {
 		/* First the packet memory */
 		for (index = 0; index <
-		     (rx_ring->Fbr1NumEntries / FBR_CHUNKS); index++) {
-			if (rx_ring->Fbr1MemVa[index]) {
+		     (rx_ring->fbr1_num_entries / FBR_CHUNKS); index++) {
+			if (rx_ring->fbr1_mem_virtaddrs[index]) {
 				u32 fbr1_align;
 
-				if (rx_ring->Fbr1BufferSize > 4096)
+				if (rx_ring->fbr1_buffsize > 4096)
 					fbr1_align = 4096;
 				else
-					fbr1_align = rx_ring->Fbr1BufferSize;
+					fbr1_align = rx_ring->fbr1_buffsize;
 
 				bufsize =
-				    (rx_ring->Fbr1BufferSize * FBR_CHUNKS) +
+				    (rx_ring->fbr1_buffsize * FBR_CHUNKS) +
 				    fbr1_align - 1;
 
 				pci_free_consistent(adapter->pdev,
-						    bufsize,
-						    rx_ring->Fbr1MemVa[index],
-						    rx_ring->Fbr1MemPa[index]);
+					bufsize,
+					rx_ring->fbr1_mem_virtaddrs[index],
+					rx_ring->fbr1_mem_physaddrs[index]);
 
-				rx_ring->Fbr1MemVa[index] = NULL;
+				rx_ring->fbr1_mem_virtaddrs[index] = NULL;
 			}
 		}
 
 		/* Now the FIFO itself */
-		rx_ring->pFbr1RingVa = (void *)((u8 *)
-				rx_ring->pFbr1RingVa - rx_ring->Fbr1offset);
+		rx_ring->fbr1_ring_virtaddr = (void *)((u8 *)
+			rx_ring->fbr1_ring_virtaddr - rx_ring->fbr1_offset);
 
-		bufsize = (sizeof(struct fbr_desc) * rx_ring->Fbr1NumEntries)
+		bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr1_num_entries)
 							    + 0xfff;
 
 		pci_free_consistent(adapter->pdev, bufsize,
-				rx_ring->pFbr1RingVa, rx_ring->pFbr1RingPa);
+				    rx_ring->fbr1_ring_virtaddr,
+				    rx_ring->fbr1_ring_physaddr);
 
-		rx_ring->pFbr1RingVa = NULL;
+		rx_ring->fbr1_ring_virtaddr = NULL;
 	}
 
 #ifdef USE_FBR0
 	/* Now the same for Free Buffer Ring 0 */
-	if (rx_ring->pFbr0RingVa) {
+	if (rx_ring->fbr0_ring_virtaddr) {
 		/* First the packet memory */
 		for (index = 0; index <
-		     (rx_ring->Fbr0NumEntries / FBR_CHUNKS); index++) {
-			if (rx_ring->Fbr0MemVa[index]) {
+		     (rx_ring->fbr0_num_entries / FBR_CHUNKS); index++) {
+			if (rx_ring->fbr0_mem_virtaddrs[index]) {
 				bufsize =
-				    (rx_ring->Fbr0BufferSize *
+				    (rx_ring->fbr0_buffsize *
 				     (FBR_CHUNKS + 1)) - 1;
 
 				pci_free_consistent(adapter->pdev,
-						    bufsize,
-						    rx_ring->Fbr0MemVa[index],
-						    rx_ring->Fbr0MemPa[index]);
+					bufsize,
+					rx_ring->fbr0_mem_virtaddrs[index],
+					rx_ring->fbr0_mem_physaddrs[index]);
 
-				rx_ring->Fbr0MemVa[index] = NULL;
+				rx_ring->fbr0_mem_virtaddrs[index] = NULL;
 			}
 		}
 
 		/* Now the FIFO itself */
-		rx_ring->pFbr0RingVa = (void *)((u8 *)
-				rx_ring->pFbr0RingVa - rx_ring->Fbr0offset);
+		rx_ring->fbr0_ring_virtaddr = (void *)((u8 *)
+			rx_ring->fbr0_ring_virtaddr - rx_ring->fbr0_offset);
 
-		bufsize = (sizeof(struct fbr_desc) * rx_ring->Fbr0NumEntries)
+		bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr0_num_entries)
 							    + 0xfff;
 
 		pci_free_consistent(adapter->pdev,
 				    bufsize,
-				    rx_ring->pFbr0RingVa, rx_ring->pFbr0RingPa);
+				    rx_ring->fbr0_ring_virtaddr,
+				    rx_ring->fbr0_ring_physaddr);
 
-		rx_ring->pFbr0RingVa = NULL;
+		rx_ring->fbr0_ring_virtaddr = NULL;
 	}
 #endif
 
 	/* Free Packet Status Ring */
-	if (rx_ring->pPSRingVa) {
+	if (rx_ring->ps_ring_virtaddr) {
 		pktstat_ringsize =
-		  sizeof(struct pkt_stat_desc) * adapter->rx_ring.PsrNumEntries;
+		    sizeof(struct pkt_stat_desc) *
+		    adapter->rx_ring.psr_num_entries;
 
 		pci_free_consistent(adapter->pdev, pktstat_ringsize,
-				    rx_ring->pPSRingVa, rx_ring->pPSRingPa);
+				    rx_ring->ps_ring_virtaddr,
+				    rx_ring->ps_ring_physaddr);
 
-		rx_ring->pPSRingVa = NULL;
+		rx_ring->ps_ring_virtaddr = NULL;
 	}
 
 	/* Free area of memory for the writeback of status information */
@@ -533,7 +536,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 
 	/* Destroy the lookaside (RFD) pool */
 	if (adapter->flags & fMP_ADAPTER_RECV_LOOKASIDE) {
-		kmem_cache_destroy(rx_ring->RecvLookaside);
+		kmem_cache_destroy(rx_ring->recv_lookaside);
 		adapter->flags &= ~fMP_ADAPTER_RECV_LOOKASIDE;
 	}
 
@@ -545,7 +548,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 	kfree(rx_ring->fbr[1]);
 
 	/* Reset Counters */
-	rx_ring->nReadyRecv = 0;
+	rx_ring->num_ready_recv = 0;
 }
 
 /**
@@ -566,8 +569,8 @@ int et131x_init_recv(struct et131x_adapter *adapter)
 	rx_ring = &adapter->rx_ring;
 
 	/* Setup each RFD */
-	for (rfdct = 0; rfdct < rx_ring->NumRfd; rfdct++) {
-		rfd = kmem_cache_alloc(rx_ring->RecvLookaside,
+	for (rfdct = 0; rfdct < rx_ring->num_rfd; rfdct++) {
+		rfd = kmem_cache_alloc(rx_ring->recv_lookaside,
 						     GFP_ATOMIC | GFP_DMA);
 
 		if (!rfd) {
@@ -579,21 +582,21 @@ int et131x_init_recv(struct et131x_adapter *adapter)
 
 		rfd->skb = NULL;
 
-		/* Add this RFD to the RecvList */
-		list_add_tail(&rfd->list_node, &rx_ring->RecvList);
+		/* Add this RFD to the recv_list */
+		list_add_tail(&rfd->list_node, &rx_ring->recv_list);
 
 		/* Increment both the available RFD's, and the total RFD's. */
-		rx_ring->nReadyRecv++;
+		rx_ring->num_ready_recv++;
 		numrfd++;
 	}
 
 	if (numrfd > NIC_MIN_NUM_RFD)
 		status = 0;
 
-	rx_ring->NumRfd = numrfd;
+	rx_ring->num_rfd = numrfd;
 
 	if (status != 0) {
-		kmem_cache_free(rx_ring->RecvLookaside, rfd);
+		kmem_cache_free(rx_ring->recv_lookaside, rfd);
 		dev_err(&adapter->pdev->dev,
 			  "Allocation problems in et131x_init_recv\n");
 	}
@@ -632,10 +635,10 @@ void et131x_config_rx_dma_regs(struct et131x_adapter *etdev)
 	/* Set the address and parameters of the packet status ring into the
 	 * 1310's registers
 	 */
-	writel((u32) ((u64)rx_local->pPSRingPa >> 32),
+	writel((u32) ((u64)rx_local->ps_ring_physaddr >> 32),
 	       &rx_dma->psr_base_hi);
-	writel((u32) rx_local->pPSRingPa, &rx_dma->psr_base_lo);
-	writel(rx_local->PsrNumEntries - 1, &rx_dma->psr_num_des);
+	writel((u32) rx_local->ps_ring_physaddr, &rx_dma->psr_base_lo);
+	writel(rx_local->psr_num_entries - 1, &rx_dma->psr_num_des);
 	writel(0, &rx_dma->psr_full_offset);
 
 	psr_num_des = readl(&rx_dma->psr_num_des) & 0xFFF;
@@ -648,8 +651,8 @@ void et131x_config_rx_dma_regs(struct et131x_adapter *etdev)
 	rx_local->local_psr_full = 0;
 
 	/* Now's the best time to initialize FBR1 contents */
-	fbr_entry = (struct fbr_desc *) rx_local->pFbr1RingVa;
-	for (entry = 0; entry < rx_local->Fbr1NumEntries; entry++) {
+	fbr_entry = (struct fbr_desc *) rx_local->fbr1_ring_virtaddr;
+	for (entry = 0; entry < rx_local->fbr1_num_entries; entry++) {
 		fbr_entry->addr_hi = rx_local->fbr[1]->bus_high[entry];
 		fbr_entry->addr_lo = rx_local->fbr[1]->bus_low[entry];
 		fbr_entry->word2 = entry;
@@ -659,39 +662,43 @@ void et131x_config_rx_dma_regs(struct et131x_adapter *etdev)
 	/* Set the address and parameters of Free buffer ring 1 (and 0 if
 	 * required) into the 1310's registers
 	 */
-	writel((u32) (rx_local->Fbr1Realpa >> 32), &rx_dma->fbr1_base_hi);
-	writel((u32) rx_local->Fbr1Realpa, &rx_dma->fbr1_base_lo);
-	writel(rx_local->Fbr1NumEntries - 1, &rx_dma->fbr1_num_des);
+	writel((u32) (rx_local->fbr1_real_physaddr >> 32),
+	       &rx_dma->fbr1_base_hi);
+	writel((u32) rx_local->fbr1_real_physaddr, &rx_dma->fbr1_base_lo);
+	writel(rx_local->fbr1_num_entries - 1, &rx_dma->fbr1_num_des);
 	writel(ET_DMA10_WRAP, &rx_dma->fbr1_full_offset);
 
 	/* This variable tracks the free buffer ring 1 full position, so it
 	 * has to match the above.
 	 */
-	rx_local->local_Fbr1_full = ET_DMA10_WRAP;
-	writel(((rx_local->Fbr1NumEntries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
-	       &rx_dma->fbr1_min_des);
+	rx_local->local_fbr1_full = ET_DMA10_WRAP;
+	writel(
+	    ((rx_local->fbr1_num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
+	    &rx_dma->fbr1_min_des);
 
 #ifdef USE_FBR0
 	/* Now's the best time to initialize FBR0 contents */
-	fbr_entry = (struct fbr_desc *) rx_local->pFbr0RingVa;
-	for (entry = 0; entry < rx_local->Fbr0NumEntries; entry++) {
+	fbr_entry = (struct fbr_desc *) rx_local->fbr0_ring_virtaddr;
+	for (entry = 0; entry < rx_local->fbr0_num_entries; entry++) {
 		fbr_entry->addr_hi = rx_local->fbr[0]->bus_high[entry];
 		fbr_entry->addr_lo = rx_local->fbr[0]->bus_low[entry];
 		fbr_entry->word2 = entry;
 		fbr_entry++;
 	}
 
-	writel((u32) (rx_local->Fbr0Realpa >> 32), &rx_dma->fbr0_base_hi);
-	writel((u32) rx_local->Fbr0Realpa, &rx_dma->fbr0_base_lo);
-	writel(rx_local->Fbr0NumEntries - 1, &rx_dma->fbr0_num_des);
+	writel((u32) (rx_local->fbr0_real_physaddr >> 32),
+	       &rx_dma->fbr0_base_hi);
+	writel((u32) rx_local->fbr0_real_physaddr, &rx_dma->fbr0_base_lo);
+	writel(rx_local->fbr0_num_entries - 1, &rx_dma->fbr0_num_des);
 	writel(ET_DMA10_WRAP, &rx_dma->fbr0_full_offset);
 
 	/* This variable tracks the free buffer ring 0 full position, so it
 	 * has to match the above.
 	 */
-	rx_local->local_Fbr0_full = ET_DMA10_WRAP;
-	writel(((rx_local->Fbr0NumEntries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
-	       &rx_dma->fbr0_min_des);
+	rx_local->local_fbr0_full = ET_DMA10_WRAP;
+	writel(
+	    ((rx_local->fbr0_num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
+	    &rx_dma->fbr0_min_des);
 #endif
 
 	/* Program the number of packets we will receive before generating an
@@ -745,15 +752,15 @@ static void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
 	 */
 	if (
 #ifdef USE_FBR0
-	    (ring_index == 0 && buff_index < rx_local->Fbr0NumEntries) ||
+	    (ring_index == 0 && buff_index < rx_local->fbr0_num_entries) ||
 #endif
-	    (ring_index == 1 && buff_index < rx_local->Fbr1NumEntries)) {
+	    (ring_index == 1 && buff_index < rx_local->fbr1_num_entries)) {
 		spin_lock_irqsave(&etdev->FbrLock, flags);
 
 		if (ring_index == 1) {
 			struct fbr_desc *next =
-			    (struct fbr_desc *) (rx_local->pFbr1RingVa) +
-					 INDEX10(rx_local->local_Fbr1_full);
+			    (struct fbr_desc *) (rx_local->fbr1_ring_virtaddr) +
+					 INDEX10(rx_local->local_fbr1_full);
 
 			/* Handle the Free Buffer Ring advancement here. Write
 			 * the PA / Buffer Index for the returned buffer into
@@ -763,15 +770,15 @@ static void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
 			next->addr_lo = rx_local->fbr[1]->bus_low[buff_index];
 			next->word2 = buff_index;
 
-			writel(bump_free_buff_ring(&rx_local->local_Fbr1_full,
-				rx_local->Fbr1NumEntries - 1),
+			writel(bump_free_buff_ring(&rx_local->local_fbr1_full,
+				rx_local->fbr1_num_entries - 1),
 				&rx_dma->fbr1_full_offset);
 		}
 #ifdef USE_FBR0
 		else {
 			struct fbr_desc *next = (struct fbr_desc *)
-				rx_local->pFbr0RingVa +
-					INDEX10(rx_local->local_Fbr0_full);
+				rx_local->fbr0_ring_virtaddr +
+					INDEX10(rx_local->local_fbr0_full);
 
 			/* Handle the Free Buffer Ring advancement here. Write
 			 * the PA / Buffer Index for the returned buffer into
@@ -781,8 +788,8 @@ static void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
 			next->addr_lo = rx_local->fbr[0]->bus_low[buff_index];
 			next->word2 = buff_index;
 
-			writel(bump_free_buff_ring(&rx_local->local_Fbr0_full,
-					rx_local->Fbr0NumEntries - 1),
+			writel(bump_free_buff_ring(&rx_local->local_fbr0_full,
+					rx_local->fbr0_num_entries - 1),
 			       &rx_dma->fbr0_full_offset);
 		}
 #endif
@@ -796,11 +803,11 @@ static void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
 	 * our list
 	 */
 	spin_lock_irqsave(&etdev->rcv_lock, flags);
-	list_add_tail(&rfd->list_node, &rx_local->RecvList);
-	rx_local->nReadyRecv++;
+	list_add_tail(&rfd->list_node, &rx_local->recv_list);
+	rx_local->num_ready_recv++;
 	spin_unlock_irqrestore(&etdev->rcv_lock, flags);
 
-	WARN_ON(rx_local->nReadyRecv > rx_local->NumRfd);
+	WARN_ON(rx_local->num_ready_recv > rx_local->num_rfd);
 }
 
 /**
@@ -832,19 +839,19 @@ void et131x_rx_dma_enable(struct et131x_adapter *etdev)
 	/* Setup the receive dma configuration register for normal operation */
 	u32 csr =  0x2000;	/* FBR1 enable */
 
-	if (etdev->rx_ring.Fbr1BufferSize == 4096)
+	if (etdev->rx_ring.fbr1_buffsize == 4096)
 		csr |= 0x0800;
-	else if (etdev->rx_ring.Fbr1BufferSize == 8192)
+	else if (etdev->rx_ring.fbr1_buffsize == 8192)
 		csr |= 0x1000;
-	else if (etdev->rx_ring.Fbr1BufferSize == 16384)
+	else if (etdev->rx_ring.fbr1_buffsize == 16384)
 		csr |= 0x1800;
 #ifdef USE_FBR0
 	csr |= 0x0400;		/* FBR0 enable */
-	if (etdev->rx_ring.Fbr0BufferSize == 256)
+	if (etdev->rx_ring.fbr0_buffsize == 256)
 		csr |= 0x0100;
-	else if (etdev->rx_ring.Fbr0BufferSize == 512)
+	else if (etdev->rx_ring.fbr0_buffsize == 512)
 		csr |= 0x0200;
-	else if (etdev->rx_ring.Fbr0BufferSize == 1024)
+	else if (etdev->rx_ring.fbr0_buffsize == 1024)
 		csr |= 0x0300;
 #endif
 	writel(csr, &etdev->regs->rxdma.csr);
@@ -868,7 +875,7 @@ void et131x_rx_dma_enable(struct et131x_adapter *etdev)
  * Returns rfd, a pointer to our MPRFD.
  *
  * Checks the hardware for available packets, using completion ring
- * If packets are available, it gets an RFD from the RecvList, attaches
+ * If packets are available, it gets an RFD from the recv_list, attaches
  * the packet to it, puts the RFD in the RecvPendList, and also returns
  * the pointer to the RFD.
  */
@@ -893,7 +900,7 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 	 * Status Ring, and also the two Free Buffer rings.
 	 */
 	status = rx_local->rx_status_block;
-	word1 = status->Word1 >> 16;	/* Get the useful bits */
+	word1 = status->word1 >> 16;	/* Get the useful bits */
 
 	/* Check the PSR and wrap bits do not match */
 	if ((word1 & 0x1FFF) == (rx_local->local_psr_full & 0x1FFF))
@@ -901,7 +908,7 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 		return NULL;
 
 	/* The packet status ring indicates that data is available. */
-	psr = (struct pkt_stat_desc *) (rx_local->pPSRingVa) +
+	psr = (struct pkt_stat_desc *) (rx_local->ps_ring_virtaddr) +
 			(rx_local->local_psr_full & 0xFFF);
 
 	/* Grab any information that is required once the PSR is
@@ -916,7 +923,8 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 	/* Indicate that we have used this PSR entry. */
 	/* FIXME wrap 12 */
 	add_12bit(&rx_local->local_psr_full, 1);
-	if ((rx_local->local_psr_full & 0xFFF)  > rx_local->PsrNumEntries - 1) {
+	if (
+	  (rx_local->local_psr_full & 0xFFF) > rx_local->psr_num_entries - 1) {
 		/* Clear psr full and toggle the wrap bit */
 		rx_local->local_psr_full &=  ~0xFFF;
 		rx_local->local_psr_full ^= 0x1000;
@@ -933,11 +941,11 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 #ifdef USE_FBR0
 	if (ring_index > 1 ||
 		(ring_index == 0 &&
-		buff_index > rx_local->Fbr0NumEntries - 1) ||
+		buff_index > rx_local->fbr0_num_entries - 1) ||
 		(ring_index == 1 &&
-		buff_index > rx_local->Fbr1NumEntries - 1))
+		buff_index > rx_local->fbr1_num_entries - 1))
 #else
-	if (ring_index != 1 || buff_index > rx_local->Fbr1NumEntries - 1)
+	if (ring_index != 1 || buff_index > rx_local->fbr1_num_entries - 1)
 #endif
 	{
 		/* Illegal buffer or ring index cannot be used by S/W*/
@@ -953,7 +961,7 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 	spin_lock_irqsave(&etdev->rcv_lock, flags);
 
 	rfd = NULL;
-	element = rx_local->RecvList.next;
+	element = rx_local->recv_list.next;
 	rfd = (struct rfd *) list_entry(element, struct rfd, list_node);
 
 	if (rfd == NULL) {
@@ -962,7 +970,7 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 	}
 
 	list_del(&rfd->list_node);
-	rx_local->nReadyRecv--;
+	rx_local->num_ready_recv--;
 
 	spin_unlock_irqrestore(&etdev->rcv_lock, flags);
 
@@ -1087,7 +1095,7 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
  */
 void et131x_reset_recv(struct et131x_adapter *etdev)
 {
-	WARN_ON(list_empty(&etdev->rx_ring.RecvList));
+	WARN_ON(list_empty(&etdev->rx_ring.recv_list));
 }
 
 /**
@@ -1104,8 +1112,8 @@ void et131x_handle_recv_interrupt(struct et131x_adapter *etdev)
 
 	/* Process up to available RFD's */
 	while (count < NUM_PACKETS_HANDLED) {
-		if (list_empty(&etdev->rx_ring.RecvList)) {
-			WARN_ON(etdev->rx_ring.nReadyRecv != 0);
+		if (list_empty(&etdev->rx_ring.recv_list)) {
+			WARN_ON(etdev->rx_ring.num_ready_recv != 0);
 			done = false;
 			break;
 		}
@@ -1129,7 +1137,7 @@ void et131x_handle_recv_interrupt(struct et131x_adapter *etdev)
 		etdev->net_stats.rx_packets++;
 
 		/* Set the status on the packet, either resources or success */
-		if (etdev->rx_ring.nReadyRecv < RFD_LOW_WATER_MARK) {
+		if (etdev->rx_ring.num_ready_recv < RFD_LOW_WATER_MARK) {
 			dev_warn(&etdev->pdev->dev,
 				    "RFD's are running out\n");
 		}
@@ -1137,11 +1145,11 @@ void et131x_handle_recv_interrupt(struct et131x_adapter *etdev)
 	}
 
 	if (count == NUM_PACKETS_HANDLED || !done) {
-		etdev->rx_ring.UnfinishedReceives = true;
+		etdev->rx_ring.unfinished_receives = true;
 		writel(PARM_TX_TIME_INT_DEF * NANO_IN_A_MICRO,
 		       &etdev->regs->global.watchdog_timer);
 	} else
 		/* Watchdog timer will disable itself if appropriate. */
-		etdev->rx_ring.UnfinishedReceives = false;
+		etdev->rx_ring.unfinished_receives = false;
 }
 
diff --git a/drivers/staging/et131x/et1310_rx.h b/drivers/staging/et131x/et1310_rx.h
index e8c653d..1448aa9 100644
--- a/drivers/staging/et131x/et1310_rx.h
+++ b/drivers/staging/et131x/et1310_rx.h
@@ -174,8 +174,8 @@ struct pkt_stat_desc {
  * DMA engine it sits in free memory, and is pointed to by 0x101c / 0x1020
  */
 struct rx_status_block {
-	u32 Word0;
-	u32 Word1;
+	u32 word0;
+	u32 word1;
 };
 
 /*
@@ -190,54 +190,54 @@ struct fbr_lookup {
 };
 
 /*
- * struct rx_ring is the ssructure representing the adaptor's local
+ * struct rx_ring is the sructure representing the adaptor's local
  * reference(s) to the rings
  */
 struct rx_ring {
 #ifdef USE_FBR0
-	void *pFbr0RingVa;
-	dma_addr_t pFbr0RingPa;
-	void *Fbr0MemVa[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
-	dma_addr_t Fbr0MemPa[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
-	uint64_t Fbr0Realpa;
-	uint64_t Fbr0offset;
-	u32 local_Fbr0_full;
-	u32 Fbr0NumEntries;
-	u32 Fbr0BufferSize;
+	void *fbr0_ring_virtaddr;
+	dma_addr_t fbr0_ring_physaddr;
+	void *fbr0_mem_virtaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
+	dma_addr_t fbr0_mem_physaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
+	uint64_t fbr0_real_physaddr;
+	uint64_t fbr0_offset;
+	u32 local_fbr0_full;
+	u32 fbr0_num_entries;
+	u32 fbr0_buffsize;
 #endif
-	void *pFbr1RingVa;
-	dma_addr_t pFbr1RingPa;
-	void *Fbr1MemVa[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
-	dma_addr_t Fbr1MemPa[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
-	uint64_t Fbr1Realpa;
-	uint64_t Fbr1offset;
+	void *fbr1_ring_virtaddr;
+	dma_addr_t fbr1_ring_physaddr;
+	void *fbr1_mem_virtaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
+	dma_addr_t fbr1_mem_physaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
+	uint64_t fbr1_real_physaddr;
+	uint64_t fbr1_offset;
 	struct fbr_lookup *fbr[2];	/* One per ring */
-	u32 local_Fbr1_full;
-	u32 Fbr1NumEntries;
-	u32 Fbr1BufferSize;
+	u32 local_fbr1_full;
+	u32 fbr1_num_entries;
+	u32 fbr1_buffsize;
 
-	void *pPSRingVa;
-	dma_addr_t pPSRingPa;
+	void *ps_ring_virtaddr;
+	dma_addr_t ps_ring_physaddr;
 	u32 local_psr_full;
-	u32 PsrNumEntries;
+	u32 psr_num_entries;
 
 	struct rx_status_block *rx_status_block;
 	dma_addr_t rx_status_bus;
 
-	struct list_head RecvBufferPool;
+	struct list_head recv_buff_pool;
 
 	/* RECV */
-	struct list_head RecvList;
-	u32 nReadyRecv;
+	struct list_head recv_list;
+	u32 num_ready_recv;
 
-	u32 NumRfd;
+	u32 num_rfd;
 
-	bool UnfinishedReceives;
+	bool unfinished_receives;
 
-	struct list_head RecvPacketPool;
+	struct list_head recv_packet_pool;
 
 	/* lookaside lists */
-	struct kmem_cache *RecvLookaside;
+	struct kmem_cache *recv_lookaside;
 };
 
 #endif /* __ET1310_RX_H__ */
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index dd952f0..33d432f 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -200,7 +200,7 @@ irqreturn_t et131x_isr(int irq, void *dev_id)
 			if (++tcb->stale > 1)
 				status |= ET_INTR_TXDMA_ISR;
 
-		if (adapter->rx_ring.UnfinishedReceives)
+		if (adapter->rx_ring.unfinished_receives)
 			status |= ET_INTR_RXDMA_XFR_DONE;
 		else if (tcb == NULL)
 			writel(0, &adapter->regs->global.watchdog_timer);
-- 
1.7.4.4

