Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab1JRQLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 12:11:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47634 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945Ab1JRQKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 12:10:31 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 25/26] staging: et131x: Remove forward declaration of et131x_adapter_setup
Date: Tue, 18 Oct 2011 17:07:58 +0100
Message-Id: <1318954079-16666-26-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
References: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also associated function movements within et131x.c file

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |  445 +++++++++++++++++++--------------------
 1 files changed, 222 insertions(+), 223 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 8048d67..2947635 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -576,7 +576,6 @@ struct et131x_adapter {
 	struct net_device_stats net_stats;
 };
 
-void et131x_adapter_setup(struct et131x_adapter *adapter);
 void et131x_soft_reset(struct et131x_adapter *adapter);
 void et131x_isr_handler(struct work_struct *work);
 void et1310_setup_device_for_multicast(struct et131x_adapter *adapter);
@@ -1731,6 +1730,53 @@ void et131x_xcvr_init(struct et131x_adapter *adapter)
 	}
 }
 
+/**
+ * et131x_configure_global_regs	-	configure JAGCore global regs
+ * @adapter: pointer to our adapter structure
+ *
+ * Used to configure the global registers on the JAGCore
+ */
+void et131x_configure_global_regs(struct et131x_adapter *adapter)
+{
+	struct global_regs __iomem *regs = &adapter->regs->global;
+
+	writel(0, &regs->rxq_start_addr);
+	writel(INTERNAL_MEM_SIZE - 1, &regs->txq_end_addr);
+
+	if (adapter->registry_jumbo_packet < 2048) {
+		/* Tx / RxDMA and Tx/Rx MAC interfaces have a 1k word
+		 * block of RAM that the driver can split between Tx
+		 * and Rx as it desires.  Our default is to split it
+		 * 50/50:
+		 */
+		writel(PARM_RX_MEM_END_DEF, &regs->rxq_end_addr);
+		writel(PARM_RX_MEM_END_DEF + 1, &regs->txq_start_addr);
+	} else if (adapter->registry_jumbo_packet < 8192) {
+		/* For jumbo packets > 2k but < 8k, split 50-50. */
+		writel(INTERNAL_MEM_RX_OFFSET, &regs->rxq_end_addr);
+		writel(INTERNAL_MEM_RX_OFFSET + 1, &regs->txq_start_addr);
+	} else {
+		/* 9216 is the only packet size greater than 8k that
+		 * is available. The Tx buffer has to be big enough
+		 * for one whole packet on the Tx side. We'll make
+		 * the Tx 9408, and give the rest to Rx
+		 */
+		writel(0x01b3, &regs->rxq_end_addr);
+		writel(0x01b4, &regs->txq_start_addr);
+	}
+
+	/* Initialize the loopback register. Disable all loopbacks. */
+	writel(0, &regs->loopback);
+
+	/* MSI Register */
+	writel(0, &regs->msi_config);
+
+	/* By default, disable the watchdog timer.  It will be enabled when
+	 * a packet is queued.
+	 */
+	writel(0, &regs->watchdog_timer);
+}
+
 /* PM functions */
 
 /**
@@ -1749,6 +1795,181 @@ int et1310_in_phy_coma(struct et131x_adapter *adapter)
 }
 
 /**
+ * et131x_config_rx_dma_regs - Start of Rx_DMA init sequence
+ * @adapter: pointer to our adapter structure
+ */
+void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
+{
+	struct rxdma_regs __iomem *rx_dma = &adapter->regs->rxdma;
+	struct rx_ring *rx_local = &adapter->rx_ring;
+	struct fbr_desc *fbr_entry;
+	u32 entry;
+	u32 psr_num_des;
+	unsigned long flags;
+
+	/* Halt RXDMA to perform the reconfigure.  */
+	et131x_rx_dma_disable(adapter);
+
+	/* Load the completion writeback physical address
+	 *
+	 * NOTE : dma_alloc_coherent(), used above to alloc DMA regions,
+	 * ALWAYS returns SAC (32-bit) addresses. If DAC (64-bit) addresses
+	 * are ever returned, make sure the high part is retrieved here
+	 * before storing the adjusted address.
+	 */
+	writel((u32) ((u64)rx_local->rx_status_bus >> 32),
+	       &rx_dma->dma_wb_base_hi);
+	writel((u32) rx_local->rx_status_bus, &rx_dma->dma_wb_base_lo);
+
+	memset(rx_local->rx_status_block, 0, sizeof(struct rx_status_block));
+
+	/* Set the address and parameters of the packet status ring into the
+	 * 1310's registers
+	 */
+	writel((u32) ((u64)rx_local->ps_ring_physaddr >> 32),
+	       &rx_dma->psr_base_hi);
+	writel((u32) rx_local->ps_ring_physaddr, &rx_dma->psr_base_lo);
+	writel(rx_local->psr_num_entries - 1, &rx_dma->psr_num_des);
+	writel(0, &rx_dma->psr_full_offset);
+
+	psr_num_des = readl(&rx_dma->psr_num_des) & 0xFFF;
+	writel((psr_num_des * LO_MARK_PERCENT_FOR_PSR) / 100,
+	       &rx_dma->psr_min_des);
+
+	spin_lock_irqsave(&adapter->rcv_lock, flags);
+
+	/* These local variables track the PSR in the adapter structure */
+	rx_local->local_psr_full = 0;
+
+	/* Now's the best time to initialize FBR1 contents */
+	fbr_entry = (struct fbr_desc *) rx_local->fbr[0]->ring_virtaddr;
+	for (entry = 0; entry < rx_local->fbr[0]->num_entries; entry++) {
+		fbr_entry->addr_hi = rx_local->fbr[0]->bus_high[entry];
+		fbr_entry->addr_lo = rx_local->fbr[0]->bus_low[entry];
+		fbr_entry->word2 = entry;
+		fbr_entry++;
+	}
+
+	/* Set the address and parameters of Free buffer ring 1 (and 0 if
+	 * required) into the 1310's registers
+	 */
+	writel((u32) (rx_local->fbr[0]->real_physaddr >> 32),
+	       &rx_dma->fbr1_base_hi);
+	writel((u32) rx_local->fbr[0]->real_physaddr, &rx_dma->fbr1_base_lo);
+	writel(rx_local->fbr[0]->num_entries - 1, &rx_dma->fbr1_num_des);
+	writel(ET_DMA10_WRAP, &rx_dma->fbr1_full_offset);
+
+	/* This variable tracks the free buffer ring 1 full position, so it
+	 * has to match the above.
+	 */
+	rx_local->fbr[0]->local_full = ET_DMA10_WRAP;
+	writel(
+	    ((rx_local->fbr[0]->num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
+	    &rx_dma->fbr1_min_des);
+
+#ifdef USE_FBR0
+	/* Now's the best time to initialize FBR0 contents */
+	fbr_entry = (struct fbr_desc *) rx_local->fbr[1]->ring_virtaddr;
+	for (entry = 0; entry < rx_local->fbr[1]->num_entries; entry++) {
+		fbr_entry->addr_hi = rx_local->fbr[1]->bus_high[entry];
+		fbr_entry->addr_lo = rx_local->fbr[1]->bus_low[entry];
+		fbr_entry->word2 = entry;
+		fbr_entry++;
+	}
+
+	writel((u32) (rx_local->fbr[1]->real_physaddr >> 32),
+	       &rx_dma->fbr0_base_hi);
+	writel((u32) rx_local->fbr[1]->real_physaddr, &rx_dma->fbr0_base_lo);
+	writel(rx_local->fbr[1]->num_entries - 1, &rx_dma->fbr0_num_des);
+	writel(ET_DMA10_WRAP, &rx_dma->fbr0_full_offset);
+
+	/* This variable tracks the free buffer ring 0 full position, so it
+	 * has to match the above.
+	 */
+	rx_local->fbr[1]->local_full = ET_DMA10_WRAP;
+	writel(
+	    ((rx_local->fbr[1]->num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
+	    &rx_dma->fbr0_min_des);
+#endif
+
+	/* Program the number of packets we will receive before generating an
+	 * interrupt.
+	 * For version B silicon, this value gets updated once autoneg is
+	 *complete.
+	 */
+	writel(PARM_RX_NUM_BUFS_DEF, &rx_dma->num_pkt_done);
+
+	/* The "time_done" is not working correctly to coalesce interrupts
+	 * after a given time period, but rather is giving us an interrupt
+	 * regardless of whether we have received packets.
+	 * This value gets updated once autoneg is complete.
+	 */
+	writel(PARM_RX_TIME_INT_DEF, &rx_dma->max_pkt_time);
+
+	spin_unlock_irqrestore(&adapter->rcv_lock, flags);
+}
+
+/**
+ * et131x_config_tx_dma_regs - Set up the tx dma section of the JAGCore.
+ * @adapter: pointer to our private adapter structure
+ *
+ * Configure the transmit engine with the ring buffers we have created
+ * and prepare it for use.
+ */
+void et131x_config_tx_dma_regs(struct et131x_adapter *adapter)
+{
+	struct txdma_regs __iomem *txdma = &adapter->regs->txdma;
+
+	/* Load the hardware with the start of the transmit descriptor ring. */
+	writel((u32) ((u64)adapter->tx_ring.tx_desc_ring_pa >> 32),
+	       &txdma->pr_base_hi);
+	writel((u32) adapter->tx_ring.tx_desc_ring_pa,
+	       &txdma->pr_base_lo);
+
+	/* Initialise the transmit DMA engine */
+	writel(NUM_DESC_PER_RING_TX - 1, &txdma->pr_num_des);
+
+	/* Load the completion writeback physical address */
+	writel((u32)((u64)adapter->tx_ring.tx_status_pa >> 32),
+						&txdma->dma_wb_base_hi);
+	writel((u32)adapter->tx_ring.tx_status_pa, &txdma->dma_wb_base_lo);
+
+	*adapter->tx_ring.tx_status = 0;
+
+	writel(0, &txdma->service_request);
+	adapter->tx_ring.send_idx = 0;
+}
+
+/**
+ * et131x_adapter_setup - Set the adapter up as per cassini+ documentation
+ * @adapter: pointer to our private adapter structure
+ *
+ * Returns 0 on success, errno on failure (as defined in errno.h)
+ */
+void et131x_adapter_setup(struct et131x_adapter *adapter)
+{
+	/* Configure the JAGCore */
+	et131x_configure_global_regs(adapter);
+
+	et1310_config_mac_regs1(adapter);
+
+	/* Configure the MMC registers */
+	/* All we need to do is initialize the Memory Control Register */
+	writel(ET_MMC_ENABLE, &adapter->regs->mmc.mmc_ctrl);
+
+	et1310_config_rxmac_regs(adapter);
+	et1310_config_txmac_regs(adapter);
+
+	et131x_config_rx_dma_regs(adapter);
+	et131x_config_tx_dma_regs(adapter);
+
+	et1310_config_macstat_regs(adapter);
+
+	et1310_phy_power_down(adapter, 0);
+	et131x_xcvr_init(adapter);
+}
+
+/**
  * et1310_enable_phy_coma - called when network cable is unplugged
  * @adapter: pointer to our adapter structure
  *
@@ -2390,121 +2611,6 @@ int et131x_init_recv(struct et131x_adapter *adapter)
 }
 
 /**
- * et131x_config_rx_dma_regs - Start of Rx_DMA init sequence
- * @adapter: pointer to our adapter structure
- */
-void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
-{
-	struct rxdma_regs __iomem *rx_dma = &adapter->regs->rxdma;
-	struct rx_ring *rx_local = &adapter->rx_ring;
-	struct fbr_desc *fbr_entry;
-	u32 entry;
-	u32 psr_num_des;
-	unsigned long flags;
-
-	/* Halt RXDMA to perform the reconfigure.  */
-	et131x_rx_dma_disable(adapter);
-
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
-
-	memset(rx_local->rx_status_block, 0, sizeof(struct rx_status_block));
-
-	/* Set the address and parameters of the packet status ring into the
-	 * 1310's registers
-	 */
-	writel((u32) ((u64)rx_local->ps_ring_physaddr >> 32),
-	       &rx_dma->psr_base_hi);
-	writel((u32) rx_local->ps_ring_physaddr, &rx_dma->psr_base_lo);
-	writel(rx_local->psr_num_entries - 1, &rx_dma->psr_num_des);
-	writel(0, &rx_dma->psr_full_offset);
-
-	psr_num_des = readl(&rx_dma->psr_num_des) & 0xFFF;
-	writel((psr_num_des * LO_MARK_PERCENT_FOR_PSR) / 100,
-	       &rx_dma->psr_min_des);
-
-	spin_lock_irqsave(&adapter->rcv_lock, flags);
-
-	/* These local variables track the PSR in the adapter structure */
-	rx_local->local_psr_full = 0;
-
-	/* Now's the best time to initialize FBR1 contents */
-	fbr_entry = (struct fbr_desc *) rx_local->fbr[0]->ring_virtaddr;
-	for (entry = 0; entry < rx_local->fbr[0]->num_entries; entry++) {
-		fbr_entry->addr_hi = rx_local->fbr[0]->bus_high[entry];
-		fbr_entry->addr_lo = rx_local->fbr[0]->bus_low[entry];
-		fbr_entry->word2 = entry;
-		fbr_entry++;
-	}
-
-	/* Set the address and parameters of Free buffer ring 1 (and 0 if
-	 * required) into the 1310's registers
-	 */
-	writel((u32) (rx_local->fbr[0]->real_physaddr >> 32),
-	       &rx_dma->fbr1_base_hi);
-	writel((u32) rx_local->fbr[0]->real_physaddr, &rx_dma->fbr1_base_lo);
-	writel(rx_local->fbr[0]->num_entries - 1, &rx_dma->fbr1_num_des);
-	writel(ET_DMA10_WRAP, &rx_dma->fbr1_full_offset);
-
-	/* This variable tracks the free buffer ring 1 full position, so it
-	 * has to match the above.
-	 */
-	rx_local->fbr[0]->local_full = ET_DMA10_WRAP;
-	writel(
-	    ((rx_local->fbr[0]->num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
-	    &rx_dma->fbr1_min_des);
-
-#ifdef USE_FBR0
-	/* Now's the best time to initialize FBR0 contents */
-	fbr_entry = (struct fbr_desc *) rx_local->fbr[1]->ring_virtaddr;
-	for (entry = 0; entry < rx_local->fbr[1]->num_entries; entry++) {
-		fbr_entry->addr_hi = rx_local->fbr[1]->bus_high[entry];
-		fbr_entry->addr_lo = rx_local->fbr[1]->bus_low[entry];
-		fbr_entry->word2 = entry;
-		fbr_entry++;
-	}
-
-	writel((u32) (rx_local->fbr[1]->real_physaddr >> 32),
-	       &rx_dma->fbr0_base_hi);
-	writel((u32) rx_local->fbr[1]->real_physaddr, &rx_dma->fbr0_base_lo);
-	writel(rx_local->fbr[1]->num_entries - 1, &rx_dma->fbr0_num_des);
-	writel(ET_DMA10_WRAP, &rx_dma->fbr0_full_offset);
-
-	/* This variable tracks the free buffer ring 0 full position, so it
-	 * has to match the above.
-	 */
-	rx_local->fbr[1]->local_full = ET_DMA10_WRAP;
-	writel(
-	    ((rx_local->fbr[1]->num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
-	    &rx_dma->fbr0_min_des);
-#endif
-
-	/* Program the number of packets we will receive before generating an
-	 * interrupt.
-	 * For version B silicon, this value gets updated once autoneg is
-	 *complete.
-	 */
-	writel(PARM_RX_NUM_BUFS_DEF, &rx_dma->num_pkt_done);
-
-	/* The "time_done" is not working correctly to coalesce interrupts
-	 * after a given time period, but rather is giving us an interrupt
-	 * regardless of whether we have received packets.
-	 * This value gets updated once autoneg is complete.
-	 */
-	writel(PARM_RX_TIME_INT_DEF, &rx_dma->max_pkt_time);
-
-	spin_unlock_irqrestore(&adapter->rcv_lock, flags);
-}
-
-/**
  * et131x_set_rx_dma_timer - Set the heartbeat timer according to line rate.
  * @adapter: pointer to our adapter structure
  */
@@ -3046,37 +3152,6 @@ void et131x_tx_dma_memory_free(struct et131x_adapter *adapter)
 }
 
 /**
- * et131x_config_tx_dma_regs - Set up the tx dma section of the JAGCore.
- * @adapter: pointer to our private adapter structure
- *
- * Configure the transmit engine with the ring buffers we have created
- * and prepare it for use.
- */
-void et131x_config_tx_dma_regs(struct et131x_adapter *adapter)
-{
-	struct txdma_regs __iomem *txdma = &adapter->regs->txdma;
-
-	/* Load the hardware with the start of the transmit descriptor ring. */
-	writel((u32) ((u64)adapter->tx_ring.tx_desc_ring_pa >> 32),
-	       &txdma->pr_base_hi);
-	writel((u32) adapter->tx_ring.tx_desc_ring_pa,
-	       &txdma->pr_base_lo);
-
-	/* Initialise the transmit DMA engine */
-	writel(NUM_DESC_PER_RING_TX - 1, &txdma->pr_num_des);
-
-	/* Load the completion writeback physical address */
-	writel((u32)((u64)adapter->tx_ring.tx_status_pa >> 32),
-						&txdma->dma_wb_base_hi);
-	writel((u32)adapter->tx_ring.tx_status_pa, &txdma->dma_wb_base_lo);
-
-	*adapter->tx_ring.tx_status = 0;
-
-	writel(0, &txdma->service_request);
-	adapter->tx_ring.send_idx = 0;
-}
-
-/**
  * et131x_tx_dma_disable - Stop of Tx_DMA on the ET1310
  * @adapter: pointer to our adapter structure
  */
@@ -4022,82 +4097,6 @@ void et131x_error_timer_handler(unsigned long data)
 }
 
 /**
- * et131x_configure_global_regs	-	configure JAGCore global regs
- * @adapter: pointer to our adapter structure
- *
- * Used to configure the global registers on the JAGCore
- */
-void et131x_configure_global_regs(struct et131x_adapter *adapter)
-{
-	struct global_regs __iomem *regs = &adapter->regs->global;
-
-	writel(0, &regs->rxq_start_addr);
-	writel(INTERNAL_MEM_SIZE - 1, &regs->txq_end_addr);
-
-	if (adapter->registry_jumbo_packet < 2048) {
-		/* Tx / RxDMA and Tx/Rx MAC interfaces have a 1k word
-		 * block of RAM that the driver can split between Tx
-		 * and Rx as it desires.  Our default is to split it
-		 * 50/50:
-		 */
-		writel(PARM_RX_MEM_END_DEF, &regs->rxq_end_addr);
-		writel(PARM_RX_MEM_END_DEF + 1, &regs->txq_start_addr);
-	} else if (adapter->registry_jumbo_packet < 8192) {
-		/* For jumbo packets > 2k but < 8k, split 50-50. */
-		writel(INTERNAL_MEM_RX_OFFSET, &regs->rxq_end_addr);
-		writel(INTERNAL_MEM_RX_OFFSET + 1, &regs->txq_start_addr);
-	} else {
-		/* 9216 is the only packet size greater than 8k that
-		 * is available. The Tx buffer has to be big enough
-		 * for one whole packet on the Tx side. We'll make
-		 * the Tx 9408, and give the rest to Rx
-		 */
-		writel(0x01b3, &regs->rxq_end_addr);
-		writel(0x01b4, &regs->txq_start_addr);
-	}
-
-	/* Initialize the loopback register. Disable all loopbacks. */
-	writel(0, &regs->loopback);
-
-	/* MSI Register */
-	writel(0, &regs->msi_config);
-
-	/* By default, disable the watchdog timer.  It will be enabled when
-	 * a packet is queued.
-	 */
-	writel(0, &regs->watchdog_timer);
-}
-
-/**
- * et131x_adapter_setup - Set the adapter up as per cassini+ documentation
- * @adapter: pointer to our private adapter structure
- *
- * Returns 0 on success, errno on failure (as defined in errno.h)
- */
-void et131x_adapter_setup(struct et131x_adapter *adapter)
-{
-	/* Configure the JAGCore */
-	et131x_configure_global_regs(adapter);
-
-	et1310_config_mac_regs1(adapter);
-
-	/* Configure the MMC registers */
-	/* All we need to do is initialize the Memory Control Register */
-	writel(ET_MMC_ENABLE, &adapter->regs->mmc.mmc_ctrl);
-
-	et1310_config_rxmac_regs(adapter);
-	et1310_config_txmac_regs(adapter);
-
-	et131x_config_rx_dma_regs(adapter);
-	et131x_config_tx_dma_regs(adapter);
-
-	et1310_config_macstat_regs(adapter);
-
-	et1310_phy_power_down(adapter, 0);
-	et131x_xcvr_init(adapter);
-}
-
-/**
  * et131x_soft_reset - Issue a soft reset to the hardware, complete for ET1310
  * @adapter: pointer to our private adapter structure
  */
-- 
1.7.6.4

