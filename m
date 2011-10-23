Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab1JWJYi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 05:24:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63075 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab1JWJYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 05:24:35 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 10/12] staging: et131x: Remove last of the forward declarations
Date: Sun, 23 Oct 2011 10:22:52 +0100
Message-Id: <1319361774-3148-11-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved functions in et131x.c file to remove the forward declarations of:

et131x_rx_dma_disable
et131x_rx_dma_enable
et131x_init_send
et131x_tx_dma_enable

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |  262 +++++++++++++++++++--------------------
 1 files changed, 128 insertions(+), 134 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 2e621aa..8d36da0 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -576,11 +576,6 @@ struct et131x_adapter {
 	struct net_device_stats net_stats;
 };
 
-void et131x_rx_dma_disable(struct et131x_adapter *adapter);
-void et131x_rx_dma_enable(struct et131x_adapter *adapter);
-void et131x_init_send(struct et131x_adapter *adapter);
-void et131x_tx_dma_enable(struct et131x_adapter *adapter);
-
 /* EEPROM functions */
 
 static int eeprom_wait_ready(struct pci_dev *pdev, u32 *status)
@@ -869,6 +864,100 @@ int et131x_init_eeprom(struct et131x_adapter *adapter)
 	return 0;
 }
 
+/**
+ * et131x_rx_dma_enable - re-start of Rx_DMA on the ET1310.
+ * @adapter: pointer to our adapter structure
+ */
+void et131x_rx_dma_enable(struct et131x_adapter *adapter)
+{
+	/* Setup the receive dma configuration register for normal operation */
+	u32 csr =  0x2000;	/* FBR1 enable */
+
+	if (adapter->rx_ring.fbr[0]->buffsize == 4096)
+		csr |= 0x0800;
+	else if (adapter->rx_ring.fbr[0]->buffsize == 8192)
+		csr |= 0x1000;
+	else if (adapter->rx_ring.fbr[0]->buffsize == 16384)
+		csr |= 0x1800;
+#ifdef USE_FBR0
+	csr |= 0x0400;		/* FBR0 enable */
+	if (adapter->rx_ring.fbr[1]->buffsize == 256)
+		csr |= 0x0100;
+	else if (adapter->rx_ring.fbr[1]->buffsize == 512)
+		csr |= 0x0200;
+	else if (adapter->rx_ring.fbr[1]->buffsize == 1024)
+		csr |= 0x0300;
+#endif
+	writel(csr, &adapter->regs->rxdma.csr);
+
+	csr = readl(&adapter->regs->rxdma.csr);
+	if ((csr & 0x00020000) != 0) {
+		udelay(5);
+		csr = readl(&adapter->regs->rxdma.csr);
+		if ((csr & 0x00020000) != 0) {
+			dev_err(&adapter->pdev->dev,
+			    "RX Dma failed to exit halt state.  CSR 0x%08x\n",
+				csr);
+		}
+	}
+}
+
+/**
+ * et131x_rx_dma_disable - Stop of Rx_DMA on the ET1310
+ * @adapter: pointer to our adapter structure
+ */
+void et131x_rx_dma_disable(struct et131x_adapter *adapter)
+{
+	u32 csr;
+	/* Setup the receive dma configuration register */
+	writel(0x00002001, &adapter->regs->rxdma.csr);
+	csr = readl(&adapter->regs->rxdma.csr);
+	if ((csr & 0x00020000) == 0) {	/* Check halt status (bit 17) */
+		udelay(5);
+		csr = readl(&adapter->regs->rxdma.csr);
+		if ((csr & 0x00020000) == 0)
+			dev_err(&adapter->pdev->dev,
+			"RX Dma failed to enter halt state. CSR 0x%08x\n",
+				csr);
+	}
+}
+
+/**
+ * et131x_tx_dma_enable - re-start of Tx_DMA on the ET1310.
+ * @adapter: pointer to our adapter structure
+ *
+ * Mainly used after a return to the D0 (full-power) state from a lower state.
+ */
+void et131x_tx_dma_enable(struct et131x_adapter *adapter)
+{
+	/* Setup the transmit dma configuration register for normal
+	 * operation
+	 */
+	writel(ET_TXDMA_SNGL_EPKT|(PARM_DMA_CACHE_DEF << ET_TXDMA_CACHE_SHIFT),
+					&adapter->regs->txdma.csr);
+}
+
+static inline void add_10bit(u32 *v, int n)
+{
+	*v = INDEX10(*v + n) | (*v & ET_DMA10_WRAP);
+}
+
+static inline void add_12bit(u32 *v, int n)
+{
+	*v = INDEX12(*v + n) | (*v & ET_DMA12_WRAP);
+}
+
+/**
+ * nic_rx_pkts - Checks the hardware for available packets
+ * @adapter: pointer to our adapter
+ *
+ * Returns rfd, a pointer to our MPRFD.
+ *
+ * Checks the hardware for available packets, using completion ring
+ * If packets are available, it gets an RFD from the recv_list, attaches
+ * the packet to it, puts the RFD in the RecvPendList, and also returns
+ * the pointer to the RFD.
+ */
 /* MAC functions */
 
 /**
@@ -2011,21 +2100,6 @@ void et131x_tx_dma_disable(struct et131x_adapter *adapter)
 }
 
 /**
- * et131x_tx_dma_enable - re-start of Tx_DMA on the ET1310.
- * @adapter: pointer to our adapter structure
- *
- * Mainly used after a return to the D0 (full-power) state from a lower state.
- */
-void et131x_tx_dma_enable(struct et131x_adapter *adapter)
-{
-	/* Setup the transmit dma configuration register for normal
-	 * operation
-	 */
-	writel(ET_TXDMA_SNGL_EPKT|(PARM_DMA_CACHE_DEF << ET_TXDMA_CACHE_SHIFT),
-					&adapter->regs->txdma.csr);
-}
-
-/**
  * et131x_enable_txrx - Enable tx/rx queues
  * @netdev: device to be enabled
  */
@@ -2065,6 +2139,40 @@ void et131x_disable_txrx(struct net_device *netdev)
 }
 
 /**
+ * et131x_init_send - Initialize send data structures
+ * @adapter: pointer to our private adapter structure
+ */
+void et131x_init_send(struct et131x_adapter *adapter)
+{
+	struct tcb *tcb;
+	u32 ct;
+	struct tx_ring *tx_ring;
+
+	/* Setup some convenience pointers */
+	tx_ring = &adapter->tx_ring;
+	tcb = adapter->tx_ring.tcb_ring;
+
+	tx_ring->tcb_qhead = tcb;
+
+	memset(tcb, 0, sizeof(struct tcb) * NUM_TCB);
+
+	/* Go through and set up each TCB */
+	for (ct = 0; ct++ < NUM_TCB; tcb++)
+		/* Set the link pointer in HW TCB to the next TCB in the
+		 * chain
+		 */
+		tcb->next = tcb + 1;
+
+	/* Set the  tail pointer */
+	tcb--;
+	tx_ring->tcb_qtail = tcb;
+	tcb->next = NULL;
+	/* Curr send queue should now be empty */
+	tx_ring->send_head = NULL;
+	tx_ring->send_tail = NULL;
+}
+
+/**
  * et1310_enable_phy_coma - called when network cable is unplugged
  * @adapter: pointer to our adapter structure
  *
@@ -2802,86 +2910,6 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 	WARN_ON(rx_local->num_ready_recv > rx_local->num_rfd);
 }
 
-/**
- * et131x_rx_dma_disable - Stop of Rx_DMA on the ET1310
- * @adapter: pointer to our adapter structure
- */
-void et131x_rx_dma_disable(struct et131x_adapter *adapter)
-{
-	u32 csr;
-	/* Setup the receive dma configuration register */
-	writel(0x00002001, &adapter->regs->rxdma.csr);
-	csr = readl(&adapter->regs->rxdma.csr);
-	if ((csr & 0x00020000) == 0) {	/* Check halt status (bit 17) */
-		udelay(5);
-		csr = readl(&adapter->regs->rxdma.csr);
-		if ((csr & 0x00020000) == 0)
-			dev_err(&adapter->pdev->dev,
-			"RX Dma failed to enter halt state. CSR 0x%08x\n",
-				csr);
-	}
-}
-
-/**
- * et131x_rx_dma_enable - re-start of Rx_DMA on the ET1310.
- * @adapter: pointer to our adapter structure
- */
-void et131x_rx_dma_enable(struct et131x_adapter *adapter)
-{
-	/* Setup the receive dma configuration register for normal operation */
-	u32 csr =  0x2000;	/* FBR1 enable */
-
-	if (adapter->rx_ring.fbr[0]->buffsize == 4096)
-		csr |= 0x0800;
-	else if (adapter->rx_ring.fbr[0]->buffsize == 8192)
-		csr |= 0x1000;
-	else if (adapter->rx_ring.fbr[0]->buffsize == 16384)
-		csr |= 0x1800;
-#ifdef USE_FBR0
-	csr |= 0x0400;		/* FBR0 enable */
-	if (adapter->rx_ring.fbr[1]->buffsize == 256)
-		csr |= 0x0100;
-	else if (adapter->rx_ring.fbr[1]->buffsize == 512)
-		csr |= 0x0200;
-	else if (adapter->rx_ring.fbr[1]->buffsize == 1024)
-		csr |= 0x0300;
-#endif
-	writel(csr, &adapter->regs->rxdma.csr);
-
-	csr = readl(&adapter->regs->rxdma.csr);
-	if ((csr & 0x00020000) != 0) {
-		udelay(5);
-		csr = readl(&adapter->regs->rxdma.csr);
-		if ((csr & 0x00020000) != 0) {
-			dev_err(&adapter->pdev->dev,
-			    "RX Dma failed to exit halt state.  CSR 0x%08x\n",
-				csr);
-		}
-	}
-}
-
-
-static inline void add_10bit(u32 *v, int n)
-{
-	*v = INDEX10(*v + n) | (*v & ET_DMA10_WRAP);
-}
-
-static inline void add_12bit(u32 *v, int n)
-{
-	*v = INDEX12(*v + n) | (*v & ET_DMA12_WRAP);
-}
-
-/**
- * nic_rx_pkts - Checks the hardware for available packets
- * @adapter: pointer to our adapter
- *
- * Returns rfd, a pointer to our MPRFD.
- *
- * Checks the hardware for available packets, using completion ring
- * If packets are available, it gets an RFD from the recv_list, attaches
- * the packet to it, puts the RFD in the RecvPendList, and also returns
- * the pointer to the RFD.
- */
 static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 {
 	struct rx_ring *rx_local = &adapter->rx_ring;
@@ -3247,40 +3275,6 @@ void et131x_tx_dma_memory_free(struct et131x_adapter *adapter)
 }
 
 /**
- * et131x_init_send - Initialize send data structures
- * @adapter: pointer to our private adapter structure
- */
-void et131x_init_send(struct et131x_adapter *adapter)
-{
-	struct tcb *tcb;
-	u32 ct;
-	struct tx_ring *tx_ring;
-
-	/* Setup some convenience pointers */
-	tx_ring = &adapter->tx_ring;
-	tcb = adapter->tx_ring.tcb_ring;
-
-	tx_ring->tcb_qhead = tcb;
-
-	memset(tcb, 0, sizeof(struct tcb) * NUM_TCB);
-
-	/* Go through and set up each TCB */
-	for (ct = 0; ct++ < NUM_TCB; tcb++)
-		/* Set the link pointer in HW TCB to the next TCB in the
-		 * chain
-		 */
-		tcb->next = tcb + 1;
-
-	/* Set the  tail pointer */
-	tcb--;
-	tx_ring->tcb_qtail = tcb;
-	tcb->next = NULL;
-	/* Curr send queue should now be empty */
-	tx_ring->send_head = NULL;
-	tx_ring->send_tail = NULL;
-}
-
-/**
  * nic_send_packet - NIC specific send handler for version B silicon.
  * @adapter: pointer to our adapter
  * @tcb: pointer to struct tcb
-- 
1.7.6.4

