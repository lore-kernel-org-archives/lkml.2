Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab1GJPi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 11:38:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33989 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab1GJPg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 11:36:26 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 05/10] staging: et131x: Converting et1310_rx.c function and local names from CamelCase
Date: Sun, 10 Jul 2011 16:35:30 +0100
Message-Id: <1310312135-28407-6-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
References: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also renamed some items to improve readability, and other minor tidy-ups.
Tested on an ET-131x device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.c     |    2 +-
 drivers/staging/et131x/et1310_rx.c      |  191 +++++++++++++++----------------
 drivers/staging/et131x/et131x.h         |    4 +-
 drivers/staging/et131x/et131x_initpci.c |    2 +-
 4 files changed, 97 insertions(+), 102 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 61ee744..f6c35b6 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -853,7 +853,7 @@ void et131x_mii_check(struct et131x_adapter *etdev,
 				et1310_phy_and_or_reg(etdev, 0x16, 0xcfff,
 								   0x2000);
 
-			SetRxDmaTimer(etdev);
+			et131x_set_rx_dma_timer(etdev);
 			config_mac_regs2(etdev);
 		}
 	}
diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index 7e386e0..e5bafc8 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -88,22 +88,22 @@
 #include "et1310_rx.h"
 #include "et131x.h"
 
-static inline u32 bump_fbr(u32 *fbr, u32 limit)
+static inline u32 bump_free_buff_ring(u32 *free_buff_ring, u32 limit)
 {
-	u32 v = *fbr;
-	v++;
+	u32 tmp_free_buff_ring = *free_buff_ring;
+	tmp_free_buff_ring++;
 	/* This works for all cases where limit < 1024. The 1023 case
 	   works because 1023++ is 1024 which means the if condition is not
 	   taken but the carry of the bit into the wrap bit toggles the wrap
 	   value correctly */
-	if ((v & ET_DMA10_MASK) > limit) {
-		v &= ~ET_DMA10_MASK;
-		v ^= ET_DMA10_WRAP;
+	if ((tmp_free_buff_ring & ET_DMA10_MASK) > limit) {
+		tmp_free_buff_ring &= ~ET_DMA10_MASK;
+		tmp_free_buff_ring ^= ET_DMA10_WRAP;
 	}
 	/* For the 1023 case */
-	v &= (ET_DMA10_MASK|ET_DMA10_WRAP);
-	*fbr = v;
-	return v;
+	tmp_free_buff_ring &= (ET_DMA10_MASK|ET_DMA10_WRAP);
+	*free_buff_ring = tmp_free_buff_ring;
+	return tmp_free_buff_ring;
 }
 
 /**
@@ -119,7 +119,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 {
 	u32 i, j;
 	u32 bufsize;
-	u32 pktStatRingSize, FBRChunkSize;
+	u32 pktstat_ringsize, fbr_chunksize;
 	struct rx_ring *rx_ring;
 
 	/* Setup some convenience pointers */
@@ -239,9 +239,9 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 	for (i = 0; i < (rx_ring->Fbr1NumEntries / FBR_CHUNKS);
 	     i++) {
-		u64 Fbr1Offset;
-		u64 Fbr1TempPa;
-		u32 Fbr1Align;
+		u64 fbr1_offset;
+		u64 fbr1_tmp_physaddr;
+		u32 fbr1_align;
 
 		/* This code allocates an area of memory big enough for N
 		 * free buffers + (buffer_size - 1) so that the buffers can
@@ -251,14 +251,14 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 		 * reduce this overhead.
 		 */
 		if (rx_ring->Fbr1BufferSize > 4096)
-			Fbr1Align = 4096;
+			fbr1_align = 4096;
 		else
-			Fbr1Align = rx_ring->Fbr1BufferSize;
+			fbr1_align = rx_ring->Fbr1BufferSize;
 
-		FBRChunkSize =
-		    (FBR_CHUNKS * rx_ring->Fbr1BufferSize) + Fbr1Align - 1;
+		fbr_chunksize =
+		    (FBR_CHUNKS * rx_ring->Fbr1BufferSize) + fbr1_align - 1;
 		rx_ring->Fbr1MemVa[i] =
-		    pci_alloc_consistent(adapter->pdev, FBRChunkSize,
+		    pci_alloc_consistent(adapter->pdev, fbr_chunksize,
 					 &rx_ring->Fbr1MemPa[i]);
 
 		if (!rx_ring->Fbr1MemVa[i]) {
@@ -268,11 +268,11 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 		}
 
 		/* See NOTE in "Save Physical Address" comment above */
-		Fbr1TempPa = rx_ring->Fbr1MemPa[i];
+		fbr1_tmp_physaddr = rx_ring->Fbr1MemPa[i];
 
 		et131x_align_allocated_memory(adapter,
-					      &Fbr1TempPa,
-					      &Fbr1Offset, (Fbr1Align - 1));
+					      &fbr1_tmp_physaddr,
+					      &fbr1_offset, (fbr1_align - 1));
 
 		for (j = 0; j < FBR_CHUNKS; j++) {
 			u32 index = (i * FBR_CHUNKS) + j;
@@ -282,16 +282,17 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			 */
 			rx_ring->fbr[1]->virt[index] =
 			    (u8 *) rx_ring->Fbr1MemVa[i] +
-			    (j * rx_ring->Fbr1BufferSize) + Fbr1Offset;
+			    (j * rx_ring->Fbr1BufferSize) + fbr1_offset;
 
 			/* now store the physical address in the descriptor
 			 * so the device can access it
 			 */
 			rx_ring->fbr[1]->bus_high[index] =
-			    (u32) (Fbr1TempPa >> 32);
-			rx_ring->fbr[1]->bus_low[index] = (u32) Fbr1TempPa;
+			    (u32) (fbr1_tmp_physaddr >> 32);
+			rx_ring->fbr[1]->bus_low[index] =
+			    (u32) fbr1_tmp_physaddr;
 
-			Fbr1TempPa += rx_ring->Fbr1BufferSize;
+			fbr1_tmp_physaddr += rx_ring->Fbr1BufferSize;
 
 			rx_ring->fbr[1]->buffer1[index] =
 			    rx_ring->fbr[1]->virt[index];
@@ -304,12 +305,13 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	/* Same for FBR0 (if in use) */
 	for (i = 0; i < (rx_ring->Fbr0NumEntries / FBR_CHUNKS);
 	     i++) {
-		u64 Fbr0Offset;
-		u64 Fbr0TempPa;
+		u64 fbr0_offset;
+		u64 fbr0_tmp_physaddr;
 
-		FBRChunkSize = ((FBR_CHUNKS + 1) * rx_ring->Fbr0BufferSize) - 1;
+		fbr_chunksize =
+		    ((FBR_CHUNKS + 1) * rx_ring->Fbr0BufferSize) - 1;
 		rx_ring->Fbr0MemVa[i] =
-		    pci_alloc_consistent(adapter->pdev, FBRChunkSize,
+		    pci_alloc_consistent(adapter->pdev, fbr_chunksize,
 					 &rx_ring->Fbr0MemPa[i]);
 
 		if (!rx_ring->Fbr0MemVa[i]) {
@@ -319,11 +321,11 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 		}
 
 		/* See NOTE in "Save Physical Address" comment above */
-		Fbr0TempPa = rx_ring->Fbr0MemPa[i];
+		fbr0_tmp_physaddr = rx_ring->Fbr0MemPa[i];
 
 		et131x_align_allocated_memory(adapter,
-					      &Fbr0TempPa,
-					      &Fbr0Offset,
+					      &fbr0_tmp_physaddr,
+					      &fbr0_offset,
 					      rx_ring->Fbr0BufferSize - 1);
 
 		for (j = 0; j < FBR_CHUNKS; j++) {
@@ -331,13 +333,14 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 			rx_ring->fbr[0]->virt[index] =
 			    (u8 *) rx_ring->Fbr0MemVa[i] +
-			    (j * rx_ring->Fbr0BufferSize) + Fbr0Offset;
+			    (j * rx_ring->Fbr0BufferSize) + fbr0_offset;
 
 			rx_ring->fbr[0]->bus_high[index] =
-			    (u32) (Fbr0TempPa >> 32);
-			rx_ring->fbr[0]->bus_low[index] = (u32) Fbr0TempPa;
+			    (u32) (fbr0_tmp_physaddr >> 32);
+			rx_ring->fbr[0]->bus_low[index] =
+			    (u32) fbr0_tmp_physaddr;
 
-			Fbr0TempPa += rx_ring->Fbr0BufferSize;
+			fbr0_tmp_physaddr += rx_ring->Fbr0BufferSize;
 
 			rx_ring->fbr[0]->buffer1[index] =
 			    rx_ring->fbr[0]->virt[index];
@@ -348,11 +351,11 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 #endif
 
 	/* Allocate an area of memory for FIFO of Packet Status ring entries */
-	pktStatRingSize =
+	pktstat_ringsize =
 	    sizeof(struct pkt_stat_desc) * adapter->rx_ring.PsrNumEntries;
 
 	rx_ring->pPSRingVa = pci_alloc_consistent(adapter->pdev,
-						  pktStatRingSize,
+						  pktstat_ringsize,
 						  &rx_ring->pPSRingPa);
 
 	if (!rx_ring->pPSRingVa) {
@@ -360,7 +363,8 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			  "Cannot alloc memory for Packet Status Ring\n");
 		return -ENOMEM;
 	}
-	printk(KERN_INFO "PSR %lx\n", (unsigned long) rx_ring->pPSRingPa);
+	printk(KERN_INFO "Packet Status Ring %lx\n",
+	    (unsigned long) rx_ring->pPSRingPa);
 
 	/*
 	 * NOTE : pci_alloc_consistent(), used above to alloc DMA regions,
@@ -411,7 +415,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 {
 	u32 index;
 	u32 bufsize;
-	u32 pktStatRingSize;
+	u32 pktstat_ringsize;
 	struct rfd *rfd;
 	struct rx_ring *rx_ring;
 
@@ -436,16 +440,16 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 		for (index = 0; index <
 		     (rx_ring->Fbr1NumEntries / FBR_CHUNKS); index++) {
 			if (rx_ring->Fbr1MemVa[index]) {
-				u32 Fbr1Align;
+				u32 fbr1_align;
 
 				if (rx_ring->Fbr1BufferSize > 4096)
-					Fbr1Align = 4096;
+					fbr1_align = 4096;
 				else
-					Fbr1Align = rx_ring->Fbr1BufferSize;
+					fbr1_align = rx_ring->Fbr1BufferSize;
 
 				bufsize =
 				    (rx_ring->Fbr1BufferSize * FBR_CHUNKS) +
-				    Fbr1Align - 1;
+				    fbr1_align - 1;
 
 				pci_free_consistent(adapter->pdev,
 						    bufsize,
@@ -506,10 +510,10 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 
 	/* Free Packet Status Ring */
 	if (rx_ring->pPSRingVa) {
-		pktStatRingSize =
+		pktstat_ringsize =
 		  sizeof(struct pkt_stat_desc) * adapter->rx_ring.PsrNumEntries;
 
-		pci_free_consistent(adapter->pdev, pktStatRingSize,
+		pci_free_consistent(adapter->pdev, pktstat_ringsize,
 				    rx_ring->pPSRingVa, rx_ring->pPSRingPa);
 
 		rx_ring->pPSRingVa = NULL;
@@ -597,10 +601,10 @@ int et131x_init_recv(struct et131x_adapter *adapter)
 }
 
 /**
- * ConfigRxDmaRegs - Start of Rx_DMA init sequence
+ * et131x_config_rx_dma_regs - Start of Rx_DMA init sequence
  * @etdev: pointer to our adapter structure
  */
-void ConfigRxDmaRegs(struct et131x_adapter *etdev)
+void et131x_config_rx_dma_regs(struct et131x_adapter *etdev)
 {
 	struct rxdma_regs __iomem *rx_dma = &etdev->regs->rxdma;
 	struct rx_ring *rx_local = &etdev->rx_ring;
@@ -708,10 +712,10 @@ void ConfigRxDmaRegs(struct et131x_adapter *etdev)
 }
 
 /**
- * SetRxDmaTimer - Set the heartbeat timer according to line rate.
+ * et131x_set_rx_dma_timer - Set the heartbeat timer according to line rate.
  * @etdev: pointer to our adapter structure
  */
-void SetRxDmaTimer(struct et131x_adapter *etdev)
+void et131x_set_rx_dma_timer(struct et131x_adapter *etdev)
 {
 	/* For version B silicon, we do not use the RxDMA timer for 10 and 100
 	 * Mbits/s line rates. We do not enable and RxDMA interrupt coalescing.
@@ -732,8 +736,8 @@ void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
 {
 	struct rx_ring *rx_local = &etdev->rx_ring;
 	struct rxdma_regs __iomem *rx_dma = &etdev->regs->rxdma;
-	u16 bi = rfd->bufferindex;
-	u8 ri = rfd->ringindex;
+	u16 buff_index = rfd->bufferindex;
+	u8 ring_index = rfd->ringindex;
 	unsigned long flags;
 
 	/* We don't use any of the OOB data besides status. Otherwise, we
@@ -741,12 +745,12 @@ void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
 	 */
 	if (
 #ifdef USE_FBR0
-	    (ri == 0 && bi < rx_local->Fbr0NumEntries) ||
+	    (ring_index == 0 && buff_index < rx_local->Fbr0NumEntries) ||
 #endif
-	    (ri == 1 && bi < rx_local->Fbr1NumEntries)) {
+	    (ring_index == 1 && buff_index < rx_local->Fbr1NumEntries)) {
 		spin_lock_irqsave(&etdev->FbrLock, flags);
 
-		if (ri == 1) {
+		if (ring_index == 1) {
 			struct fbr_desc *next =
 			    (struct fbr_desc *) (rx_local->pFbr1RingVa) +
 					 INDEX10(rx_local->local_Fbr1_full);
@@ -755,11 +759,11 @@ void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
 			 * the PA / Buffer Index for the returned buffer into
 			 * the oldest (next to be freed)FBR entry
 			 */
-			next->addr_hi = rx_local->fbr[1]->bus_high[bi];
-			next->addr_lo = rx_local->fbr[1]->bus_low[bi];
-			next->word2 = bi;
+			next->addr_hi = rx_local->fbr[1]->bus_high[buff_index];
+			next->addr_lo = rx_local->fbr[1]->bus_low[buff_index];
+			next->word2 = buff_index;
 
-			writel(bump_fbr(&rx_local->local_Fbr1_full,
+			writel(bump_free_buff_ring(&rx_local->local_Fbr1_full,
 				rx_local->Fbr1NumEntries - 1),
 				&rx_dma->fbr1_full_offset);
 		}
@@ -773,11 +777,11 @@ void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
 			 * the PA / Buffer Index for the returned buffer into
 			 * the oldest (next to be freed) FBR entry
 			 */
-			next->addr_hi = rx_local->fbr[0]->bus_high[bi];
-			next->addr_lo = rx_local->fbr[0]->bus_low[bi];
-			next->word2 = bi;
+			next->addr_hi = rx_local->fbr[0]->bus_high[buff_index];
+			next->addr_lo = rx_local->fbr[0]->bus_low[buff_index];
+			next->word2 = buff_index;
 
-			writel(bump_fbr(&rx_local->local_Fbr0_full,
+			writel(bump_free_buff_ring(&rx_local->local_Fbr0_full,
 					rx_local->Fbr0NumEntries - 1),
 			       &rx_dma->fbr0_full_offset);
 		}
@@ -785,7 +789,7 @@ void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
 		spin_unlock_irqrestore(&etdev->FbrLock, flags);
 	} else {
 		dev_err(&etdev->pdev->dev,
-			  "NICReturnRFD illegal Buffer Index returned\n");
+			  "%s illegal Buffer Index returned\n", __func__);
 	}
 
 	/* The processing on this RFD is done, so put it back on the tail of
@@ -878,8 +882,8 @@ struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 	u8 *buf;
 	unsigned long flags;
 	struct list_head *element;
-	u8 rindex;
-	u16 bindex;
+	u8 ring_index;
+	u16 buff_index;
 	u32 len;
 	u32 word0;
 	u32 word1;
@@ -905,8 +909,8 @@ struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 	 * accurate
 	 */
 	len = psr->word1 & 0xFFFF;
-	rindex = (psr->word1 >> 26) & 0x03;
-	bindex = (psr->word1 >> 16) & 0x3FF;
+	ring_index = (psr->word1 >> 26) & 0x03;
+	buff_index = (psr->word1 >> 16) & 0x3FF;
 	word0 = psr->word0;
 
 	/* Indicate that we have used this PSR entry. */
@@ -922,18 +926,18 @@ struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 	       &etdev->regs->rxdma.psr_full_offset);
 
 #ifndef USE_FBR0
-	if (rindex != 1)
+	if (ring_index != 1)
 		return NULL;
 #endif
 
 #ifdef USE_FBR0
-	if (rindex > 1 ||
-		(rindex == 0 &&
-		bindex > rx_local->Fbr0NumEntries - 1) ||
-		(rindex == 1 &&
-		bindex > rx_local->Fbr1NumEntries - 1))
+	if (ring_index > 1 ||
+		(ring_index == 0 &&
+		buff_index > rx_local->Fbr0NumEntries - 1) ||
+		(ring_index == 1 &&
+		buff_index > rx_local->Fbr1NumEntries - 1))
 #else
-	if (rindex != 1 || bindex > rx_local->Fbr1NumEntries - 1)
+	if (ring_index != 1 || buff_index > rx_local->Fbr1NumEntries - 1)
 #endif
 	{
 		/* Illegal buffer or ring index cannot be used by S/W*/
@@ -941,7 +945,7 @@ struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 			  "NICRxPkts PSR Entry %d indicates "
 			  "length of %d and/or bad bi(%d)\n",
 			  rx_local->local_psr_full & 0xFFF,
-			  len, bindex);
+			  len, buff_index);
 		return NULL;
 	}
 
@@ -962,8 +966,8 @@ struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 
 	spin_unlock_irqrestore(&etdev->rcv_lock, flags);
 
-	rfd->bufferindex = bindex;
-	rfd->ringindex = rindex;
+	rfd->bufferindex = buff_index;
+	rfd->ringindex = ring_index;
 
 	/* In V1 silicon, there is a bug which screws up filtering of
 	 * runt packets.  Therefore runt packet filtering is disabled
@@ -977,7 +981,7 @@ struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 
 	if (len) {
 		if (etdev->ReplicaPhyLoopbk == 1) {
-			buf = rx_local->fbr[rindex]->virt[bindex];
+			buf = rx_local->fbr[ring_index]->virt[buff_index];
 
 			if (memcmp(&buf[6], etdev->addr, ETH_ALEN) == 0) {
 				if (memcmp(&buf[42], "Replica packet",
@@ -1000,28 +1004,20 @@ struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 			if ((etdev->PacketFilter & ET131X_PACKET_TYPE_MULTICAST)
 			    && !(etdev->PacketFilter & ET131X_PACKET_TYPE_PROMISCUOUS)
 			    && !(etdev->PacketFilter & ET131X_PACKET_TYPE_ALL_MULTICAST)) {
-				buf = rx_local->fbr[rindex]->
-						virt[bindex];
+				buf = rx_local->fbr[ring_index]->
+						virt[buff_index];
 
 				/* Loop through our list to see if the
 				 * destination address of this packet
 				 * matches one in our list.
 				 */
-				for (i = 0;
-				     i < etdev->MCAddressCount;
-				     i++) {
-					if (buf[0] ==
-					    etdev->MCList[i][0]
-					    && buf[1] ==
-					    etdev->MCList[i][1]
-					    && buf[2] ==
-					    etdev->MCList[i][2]
-					    && buf[3] ==
-					    etdev->MCList[i][3]
-					    && buf[4] ==
-					    etdev->MCList[i][4]
-					    && buf[5] ==
-					    etdev->MCList[i][5]) {
+				for (i = 0; i < etdev->MCAddressCount; i++) {
+					if (buf[0] == etdev->MCList[i][0]
+					    && buf[1] == etdev->MCList[i][1]
+					    && buf[2] == etdev->MCList[i][2]
+					    && buf[3] == etdev->MCList[i][3]
+					    && buf[4] == etdev->MCList[i][4]
+					    && buf[5] == etdev->MCList[i][5]) {
 						break;
 					}
 				}
@@ -1067,7 +1063,7 @@ struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 		etdev->net_stats.rx_bytes += rfd->len;
 
 		memcpy(skb_put(skb, rfd->len),
-		       rx_local->fbr[rindex]->virt[bindex],
+		       rx_local->fbr[ring_index]->virt[buff_index],
 		       rfd->len);
 
 		skb->dev = etdev->netdev;
@@ -1092,7 +1088,6 @@ struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 void et131x_reset_recv(struct et131x_adapter *etdev)
 {
 	WARN_ON(list_empty(&etdev->rx_ring.RecvList));
-
 }
 
 /**
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index 240305e..c33594b 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -126,8 +126,8 @@ void et131x_rfd_resources_free(struct et131x_adapter *adapter,
 			       struct rfd *rfd);
 int et131x_init_recv(struct et131x_adapter *adapter);
 
-void ConfigRxDmaRegs(struct et131x_adapter *adapter);
-void SetRxDmaTimer(struct et131x_adapter *adapter);
+void et131x_config_rx_dma_regs(struct et131x_adapter *adapter);
+void et131x_set_rx_dma_timer(struct et131x_adapter *adapter);
 void et131x_rx_dma_disable(struct et131x_adapter *adapter);
 void et131x_rx_dma_enable(struct et131x_adapter *adapter);
 
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index c39f5f0..75b2c48 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -389,7 +389,7 @@ int et131x_adapter_setup(struct et131x_adapter *etdev)
 	config_rxmac_regs(etdev);
 	config_txmac_regs(etdev);
 
-	ConfigRxDmaRegs(etdev);
+	et131x_config_rx_dma_regs(etdev);
 	ConfigTxDmaRegs(etdev);
 
 	config_macstat_regs(etdev);
-- 
1.7.4.4

