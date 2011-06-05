Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab1FERgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 13:36:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37629 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab1FERf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 13:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gofDp4n+oIBzEX20ERzqrAtWBUafT8vdmjjCBlQDtgFATPYhKyl9CA5JGf7SwVzB2k
         cptqYP1OixKy4bznblnh2r4CCbLqMKfXn6I/A6+cmBDAAIGIAmCR3NRZHUiKpRc+dJE7
         nRYLVm6ii/sWJ2RI+lerg7DmjuVyyHUVwUDRs=
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <Mark.Einon@gmail.com>,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/5] staging: et131x: et1310_rx.c checkpatch fixes
Date: Sun,  5 Jun 2011 18:35:17 +0100
Message-Id: <1307295320-31716-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307295320-31716-1-git-send-email-mark.einon@gmail.com>
References: <1307295320-31716-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Einon <Mark.Einon@gmail.com>

Fixes extern in .c file and formatting issues.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_rx.c |  193 ++++++++++++++++++------------------
 1 files changed, 96 insertions(+), 97 deletions(-)

diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index fc6bd43..cd72a0b 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -88,7 +88,23 @@
 #include "et1310_rx.h"
 #include "et131x.h"
 
-void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd);
+static inline u32 bump_fbr(u32 *fbr, u32 limit)
+{
+	u32 v = *fbr;
+	v++;
+	/* This works for all cases where limit < 1024. The 1023 case
+	   works because 1023++ is 1024 which means the if condition is not
+	   taken but the carry of the bit into the wrap bit toggles the wrap
+	   value correctly */
+	if ((v & ET_DMA10_MASK) > limit) {
+		v &= ~ET_DMA10_MASK;
+		v ^= ET_DMA10_WRAP;
+	}
+	/* For the 1023 case */
+	v &= (ET_DMA10_MASK|ET_DMA10_WRAP);
+	*fbr = v;
+	return v;
+}
 
 /**
  * et131x_rx_dma_memory_alloc
@@ -246,7 +262,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 					 &rx_ring->Fbr1MemPa[i]);
 
 		if (!rx_ring->Fbr1MemVa[i]) {
-		dev_err(&adapter->pdev->dev,
+			dev_err(&adapter->pdev->dev,
 				"Could not alloc memory\n");
 			return -ENOMEM;
 		}
@@ -491,7 +507,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 	/* Free Packet Status Ring */
 	if (rx_ring->pPSRingVa) {
 		pktStatRingSize =
-		    sizeof(struct pkt_stat_desc) * adapter->rx_ring.PsrNumEntries;
+		  sizeof(struct pkt_stat_desc) * adapter->rx_ring.PsrNumEntries;
 
 		pci_free_consistent(adapter->pdev, pktStatRingSize,
 				    rx_ring->pPSRingVa, rx_ring->pPSRingPa);
@@ -708,6 +724,82 @@ void SetRxDmaTimer(struct et131x_adapter *etdev)
 }
 
 /**
+ * NICReturnRFD - Recycle a RFD and put it back onto the receive list
+ * @etdev: pointer to our adapter
+ * @rfd: pointer to the RFD
+ */
+void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
+{
+	struct rx_ring *rx_local = &etdev->rx_ring;
+	struct rxdma_regs __iomem *rx_dma = &etdev->regs->rxdma;
+	u16 bi = rfd->bufferindex;
+	u8 ri = rfd->ringindex;
+	unsigned long flags;
+
+	/* We don't use any of the OOB data besides status. Otherwise, we
+	 * need to clean up OOB data
+	 */
+	if (
+#ifdef USE_FBR0
+	    (ri == 0 && bi < rx_local->Fbr0NumEntries) ||
+#endif
+	    (ri == 1 && bi < rx_local->Fbr1NumEntries)) {
+		spin_lock_irqsave(&etdev->FbrLock, flags);
+
+		if (ri == 1) {
+			struct fbr_desc *next =
+			    (struct fbr_desc *) (rx_local->pFbr1RingVa) +
+					 INDEX10(rx_local->local_Fbr1_full);
+
+			/* Handle the Free Buffer Ring advancement here. Write
+			 * the PA / Buffer Index for the returned buffer into
+			 * the oldest (next to be freed)FBR entry
+			 */
+			next->addr_hi = rx_local->fbr[1]->bus_high[bi];
+			next->addr_lo = rx_local->fbr[1]->bus_low[bi];
+			next->word2 = bi;
+
+			writel(bump_fbr(&rx_local->local_Fbr1_full,
+				rx_local->Fbr1NumEntries - 1),
+				&rx_dma->fbr1_full_offset);
+		}
+#ifdef USE_FBR0
+		else {
+			struct fbr_desc *next = (struct fbr_desc *)
+				rx_local->pFbr0RingVa +
+					INDEX10(rx_local->local_Fbr0_full);
+
+			/* Handle the Free Buffer Ring advancement here. Write
+			 * the PA / Buffer Index for the returned buffer into
+			 * the oldest (next to be freed) FBR entry
+			 */
+			next->addr_hi = rx_local->fbr[0]->bus_high[bi];
+			next->addr_lo = rx_local->fbr[0]->bus_low[bi];
+			next->word2 = bi;
+
+			writel(bump_fbr(&rx_local->local_Fbr0_full,
+					rx_local->Fbr0NumEntries - 1),
+			       &rx_dma->fbr0_full_offset);
+		}
+#endif
+		spin_unlock_irqrestore(&etdev->FbrLock, flags);
+	} else {
+		dev_err(&etdev->pdev->dev,
+			  "NICReturnRFD illegal Buffer Index returned\n");
+	}
+
+	/* The processing on this RFD is done, so put it back on the tail of
+	 * our list
+	 */
+	spin_lock_irqsave(&etdev->rcv_lock, flags);
+	list_add_tail(&rfd->list_node, &rx_local->RecvList);
+	rx_local->nReadyRecv++;
+	spin_unlock_irqrestore(&etdev->rcv_lock, flags);
+
+	WARN_ON(rx_local->nReadyRecv > rx_local->NumRfd);
+}
+
+/**
  * et131x_rx_dma_disable - Stop of Rx_DMA on the ET1310
  * @etdev: pointer to our adapter structure
  */
@@ -776,7 +868,7 @@ void et131x_rx_dma_enable(struct et131x_adapter *etdev)
  * the packet to it, puts the RFD in the RecvPendList, and also returns
  * the pointer to the RFD.
  */
-struct rfd * nic_rx_pkts(struct et131x_adapter *etdev)
+struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 {
 	struct rx_ring *rx_local = &etdev->rx_ring;
 	struct rx_status_block *status;
@@ -1059,96 +1151,3 @@ void et131x_handle_recv_interrupt(struct et131x_adapter *etdev)
 		etdev->rx_ring.UnfinishedReceives = false;
 }
 
-static inline u32 bump_fbr(u32 *fbr, u32 limit)
-{
-	u32 v = *fbr;
-	v++;
-	/* This works for all cases where limit < 1024. The 1023 case
-	   works because 1023++ is 1024 which means the if condition is not
-	   taken but the carry of the bit into the wrap bit toggles the wrap
-	   value correctly */
-	if ((v & ET_DMA10_MASK) > limit) {
-		v &= ~ET_DMA10_MASK;
-		v ^= ET_DMA10_WRAP;
-	}
-	/* For the 1023 case */
-	v &= (ET_DMA10_MASK|ET_DMA10_WRAP);
-	*fbr = v;
-	return v;
-}
-
-/**
- * NICReturnRFD - Recycle a RFD and put it back onto the receive list
- * @etdev: pointer to our adapter
- * @rfd: pointer to the RFD
- */
-void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
-{
-	struct rx_ring *rx_local = &etdev->rx_ring;
-	struct rxdma_regs __iomem *rx_dma = &etdev->regs->rxdma;
-	u16 bi = rfd->bufferindex;
-	u8 ri = rfd->ringindex;
-	unsigned long flags;
-
-	/* We don't use any of the OOB data besides status. Otherwise, we
-	 * need to clean up OOB data
-	 */
-	if (
-#ifdef USE_FBR0
-	    (ri == 0 && bi < rx_local->Fbr0NumEntries) ||
-#endif
-	    (ri == 1 && bi < rx_local->Fbr1NumEntries)) {
-		spin_lock_irqsave(&etdev->FbrLock, flags);
-
-		if (ri == 1) {
-			struct fbr_desc *next =
-			    (struct fbr_desc *) (rx_local->pFbr1RingVa) +
-					 INDEX10(rx_local->local_Fbr1_full);
-
-			/* Handle the Free Buffer Ring advancement here. Write
-			 * the PA / Buffer Index for the returned buffer into
-			 * the oldest (next to be freed)FBR entry
-			 */
-			next->addr_hi = rx_local->fbr[1]->bus_high[bi];
-			next->addr_lo = rx_local->fbr[1]->bus_low[bi];
-			next->word2 = bi;
-
-			writel(bump_fbr(&rx_local->local_Fbr1_full,
-				rx_local->Fbr1NumEntries - 1),
-				&rx_dma->fbr1_full_offset);
-		}
-#ifdef USE_FBR0
-		else {
-			struct fbr_desc *next = (struct fbr_desc *)
-				rx_local->pFbr0RingVa +
-					INDEX10(rx_local->local_Fbr0_full);
-
-			/* Handle the Free Buffer Ring advancement here. Write
-			 * the PA / Buffer Index for the returned buffer into
-			 * the oldest (next to be freed) FBR entry
-			 */
-			next->addr_hi = rx_local->fbr[0]->bus_high[bi];
-			next->addr_lo = rx_local->fbr[0]->bus_low[bi];
-			next->word2 = bi;
-
-			writel(bump_fbr(&rx_local->local_Fbr0_full,
-					rx_local->Fbr0NumEntries - 1),
-			       &rx_dma->fbr0_full_offset);
-		}
-#endif
-		spin_unlock_irqrestore(&etdev->FbrLock, flags);
-	} else {
-		dev_err(&etdev->pdev->dev,
-			  "NICReturnRFD illegal Buffer Index returned\n");
-	}
-
-	/* The processing on this RFD is done, so put it back on the tail of
-	 * our list
-	 */
-	spin_lock_irqsave(&etdev->rcv_lock, flags);
-	list_add_tail(&rfd->list_node, &rx_local->RecvList);
-	rx_local->nReadyRecv++;
-	spin_unlock_irqrestore(&etdev->rcv_lock, flags);
-
-	WARN_ON(rx_local->nReadyRecv > rx_local->NumRfd);
-}
-- 
1.7.4.4

