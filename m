Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab1JWJYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 05:24:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63075 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab1JWJYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 05:24:31 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 08/12] staging: et131x: Remove yet more forward declarations
Date: Sun, 23 Oct 2011 10:22:50 +0100
Message-Id: <1319361774-3148-9-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved functions in et131x.c file to remove the forward declarations of:

et1310_setup_device_for_multicast
et1310_setup_device_for_unicast
et131x_up
et131x_down
et131x_enable_txrx
et131x_disable_txrx

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |  434 +++++++++++++++++++--------------------
 1 files changed, 214 insertions(+), 220 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 44fff21..208c69f 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -576,12 +576,6 @@ struct et131x_adapter {
 	struct net_device_stats net_stats;
 };
 
-void et1310_setup_device_for_multicast(struct et131x_adapter *adapter);
-void et1310_setup_device_for_unicast(struct et131x_adapter *adapter);
-void et131x_up(struct net_device *netdev);
-void et131x_down(struct net_device *netdev);
-void et131x_enable_txrx(struct net_device *netdev);
-void et131x_disable_txrx(struct net_device *netdev);
 int et1310_in_phy_coma(struct et131x_adapter *adapter);
 void et1310_phy_access_mii_bit(struct et131x_adapter *adapter,
 			       u16 action,
@@ -1025,6 +1019,95 @@ void et1310_config_mac_regs2(struct et131x_adapter *adapter)
 	}
 }
 
+void et1310_setup_device_for_multicast(struct et131x_adapter *adapter)
+{
+	struct rxmac_regs __iomem *rxmac = &adapter->regs->rxmac;
+	uint32_t nIndex;
+	uint32_t result;
+	uint32_t hash1 = 0;
+	uint32_t hash2 = 0;
+	uint32_t hash3 = 0;
+	uint32_t hash4 = 0;
+	u32 pm_csr;
+
+	/* If ET131X_PACKET_TYPE_MULTICAST is specified, then we provision
+	 * the multi-cast LIST.  If it is NOT specified, (and "ALL" is not
+	 * specified) then we should pass NO multi-cast addresses to the
+	 * driver.
+	 */
+	if (adapter->packet_filter & ET131X_PACKET_TYPE_MULTICAST) {
+		/* Loop through our multicast array and set up the device */
+		for (nIndex = 0; nIndex < adapter->multicast_addr_count;
+		     nIndex++) {
+			result = ether_crc(6, adapter->multicast_list[nIndex]);
+
+			result = (result & 0x3F800000) >> 23;
+
+			if (result < 32) {
+				hash1 |= (1 << result);
+			} else if ((31 < result) && (result < 64)) {
+				result -= 32;
+				hash2 |= (1 << result);
+			} else if ((63 < result) && (result < 96)) {
+				result -= 64;
+				hash3 |= (1 << result);
+			} else {
+				result -= 96;
+				hash4 |= (1 << result);
+			}
+		}
+	}
+
+	/* Write out the new hash to the device */
+	pm_csr = readl(&adapter->regs->global.pm_csr);
+	if (!et1310_in_phy_coma(adapter)) {
+		writel(hash1, &rxmac->multi_hash1);
+		writel(hash2, &rxmac->multi_hash2);
+		writel(hash3, &rxmac->multi_hash3);
+		writel(hash4, &rxmac->multi_hash4);
+	}
+}
+
+void et1310_setup_device_for_unicast(struct et131x_adapter *adapter)
+{
+	struct rxmac_regs __iomem *rxmac = &adapter->regs->rxmac;
+	u32 uni_pf1;
+	u32 uni_pf2;
+	u32 uni_pf3;
+	u32 pm_csr;
+
+	/* Set up unicast packet filter reg 3 to be the first two octets of
+	 * the MAC address for both address
+	 *
+	 * Set up unicast packet filter reg 2 to be the octets 2 - 5 of the
+	 * MAC address for second address
+	 *
+	 * Set up unicast packet filter reg 3 to be the octets 2 - 5 of the
+	 * MAC address for first address
+	 */
+	uni_pf3 = (adapter->addr[0] << ET_UNI_PF_ADDR2_1_SHIFT) |
+		  (adapter->addr[1] << ET_UNI_PF_ADDR2_2_SHIFT) |
+		  (adapter->addr[0] << ET_UNI_PF_ADDR1_1_SHIFT) |
+		   adapter->addr[1];
+
+	uni_pf2 = (adapter->addr[2] << ET_UNI_PF_ADDR2_3_SHIFT) |
+		  (adapter->addr[3] << ET_UNI_PF_ADDR2_4_SHIFT) |
+		  (adapter->addr[4] << ET_UNI_PF_ADDR2_5_SHIFT) |
+		   adapter->addr[5];
+
+	uni_pf1 = (adapter->addr[2] << ET_UNI_PF_ADDR1_3_SHIFT) |
+		  (adapter->addr[3] << ET_UNI_PF_ADDR1_4_SHIFT) |
+		  (adapter->addr[4] << ET_UNI_PF_ADDR1_5_SHIFT) |
+		   adapter->addr[5];
+
+	pm_csr = readl(&adapter->regs->global.pm_csr);
+	if (!et1310_in_phy_coma(adapter)) {
+		writel(uni_pf1, &rxmac->uni_pf_addr1);
+		writel(uni_pf2, &rxmac->uni_pf_addr2);
+		writel(uni_pf3, &rxmac->uni_pf_addr3);
+	}
+}
+
 void et1310_config_rxmac_regs(struct et131x_adapter *adapter)
 {
 	struct rxmac_regs __iomem *rxmac = &adapter->regs->rxmac;
@@ -1358,95 +1441,6 @@ void et1310_handle_macstat_interrupt(struct et131x_adapter *adapter)
 		adapter->stats.tx_collisions	+= COUNTER_WRAP_12_BIT;
 }
 
-void et1310_setup_device_for_multicast(struct et131x_adapter *adapter)
-{
-	struct rxmac_regs __iomem *rxmac = &adapter->regs->rxmac;
-	uint32_t nIndex;
-	uint32_t result;
-	uint32_t hash1 = 0;
-	uint32_t hash2 = 0;
-	uint32_t hash3 = 0;
-	uint32_t hash4 = 0;
-	u32 pm_csr;
-
-	/* If ET131X_PACKET_TYPE_MULTICAST is specified, then we provision
-	 * the multi-cast LIST.  If it is NOT specified, (and "ALL" is not
-	 * specified) then we should pass NO multi-cast addresses to the
-	 * driver.
-	 */
-	if (adapter->packet_filter & ET131X_PACKET_TYPE_MULTICAST) {
-		/* Loop through our multicast array and set up the device */
-		for (nIndex = 0; nIndex < adapter->multicast_addr_count;
-		     nIndex++) {
-			result = ether_crc(6, adapter->multicast_list[nIndex]);
-
-			result = (result & 0x3F800000) >> 23;
-
-			if (result < 32) {
-				hash1 |= (1 << result);
-			} else if ((31 < result) && (result < 64)) {
-				result -= 32;
-				hash2 |= (1 << result);
-			} else if ((63 < result) && (result < 96)) {
-				result -= 64;
-				hash3 |= (1 << result);
-			} else {
-				result -= 96;
-				hash4 |= (1 << result);
-			}
-		}
-	}
-
-	/* Write out the new hash to the device */
-	pm_csr = readl(&adapter->regs->global.pm_csr);
-	if (!et1310_in_phy_coma(adapter)) {
-		writel(hash1, &rxmac->multi_hash1);
-		writel(hash2, &rxmac->multi_hash2);
-		writel(hash3, &rxmac->multi_hash3);
-		writel(hash4, &rxmac->multi_hash4);
-	}
-}
-
-void et1310_setup_device_for_unicast(struct et131x_adapter *adapter)
-{
-	struct rxmac_regs __iomem *rxmac = &adapter->regs->rxmac;
-	u32 uni_pf1;
-	u32 uni_pf2;
-	u32 uni_pf3;
-	u32 pm_csr;
-
-	/* Set up unicast packet filter reg 3 to be the first two octets of
-	 * the MAC address for both address
-	 *
-	 * Set up unicast packet filter reg 2 to be the octets 2 - 5 of the
-	 * MAC address for second address
-	 *
-	 * Set up unicast packet filter reg 3 to be the octets 2 - 5 of the
-	 * MAC address for first address
-	 */
-	uni_pf3 = (adapter->addr[0] << ET_UNI_PF_ADDR2_1_SHIFT) |
-		  (adapter->addr[1] << ET_UNI_PF_ADDR2_2_SHIFT) |
-		  (adapter->addr[0] << ET_UNI_PF_ADDR1_1_SHIFT) |
-		   adapter->addr[1];
-
-	uni_pf2 = (adapter->addr[2] << ET_UNI_PF_ADDR2_3_SHIFT) |
-		  (adapter->addr[3] << ET_UNI_PF_ADDR2_4_SHIFT) |
-		  (adapter->addr[4] << ET_UNI_PF_ADDR2_5_SHIFT) |
-		   adapter->addr[5];
-
-	uni_pf1 = (adapter->addr[2] << ET_UNI_PF_ADDR1_3_SHIFT) |
-		  (adapter->addr[3] << ET_UNI_PF_ADDR1_4_SHIFT) |
-		  (adapter->addr[4] << ET_UNI_PF_ADDR1_5_SHIFT) |
-		   adapter->addr[5];
-
-	pm_csr = readl(&adapter->regs->global.pm_csr);
-	if (!et1310_in_phy_coma(adapter)) {
-		writel(uni_pf1, &rxmac->uni_pf_addr1);
-		writel(uni_pf2, &rxmac->uni_pf_addr2);
-		writel(uni_pf3, &rxmac->uni_pf_addr3);
-	}
-}
-
 /* PHY functions */
 
 int et131x_mdio_read(struct mii_bus *bus, int phy_addr, int reg)
@@ -1982,6 +1976,104 @@ void et131x_soft_reset(struct et131x_adapter *adapter)
 }
 
 /**
+ *	et131x_enable_interrupts	-	enable interrupt
+ *	@adapter: et131x device
+ *
+ *	Enable the appropriate interrupts on the ET131x according to our
+ *	configuration
+ */
+void et131x_enable_interrupts(struct et131x_adapter *adapter)
+{
+	u32 mask;
+
+	/* Enable all global interrupts */
+	if (adapter->flowcontrol == FLOW_TXONLY ||
+			    adapter->flowcontrol == FLOW_BOTH)
+		mask = INT_MASK_ENABLE;
+	else
+		mask = INT_MASK_ENABLE_NO_FLOW;
+
+	writel(mask, &adapter->regs->global.int_mask);
+}
+
+/**
+ *	et131x_disable_interrupts	-	interrupt disable
+ *	@adapter: et131x device
+ *
+ *	Block all interrupts from the et131x device at the device itself
+ */
+void et131x_disable_interrupts(struct et131x_adapter *adapter)
+{
+	/* Disable all global interrupts */
+	writel(INT_MASK_DISABLE, &adapter->regs->global.int_mask);
+}
+
+/**
+ * et131x_tx_dma_disable - Stop of Tx_DMA on the ET1310
+ * @adapter: pointer to our adapter structure
+ */
+void et131x_tx_dma_disable(struct et131x_adapter *adapter)
+{
+	/* Setup the tramsmit dma configuration register */
+	writel(ET_TXDMA_CSR_HALT|ET_TXDMA_SNGL_EPKT,
+					&adapter->regs->txdma.csr);
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
+/**
+ * et131x_enable_txrx - Enable tx/rx queues
+ * @netdev: device to be enabled
+ */
+void et131x_enable_txrx(struct net_device *netdev)
+{
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+
+	/* Enable the Tx and Rx DMA engines (if not already enabled) */
+	et131x_rx_dma_enable(adapter);
+	et131x_tx_dma_enable(adapter);
+
+	/* Enable device interrupts */
+	if (adapter->flags & fMP_ADAPTER_INTERRUPT_IN_USE)
+		et131x_enable_interrupts(adapter);
+
+	/* We're ready to move some data, so start the queue */
+	netif_start_queue(netdev);
+}
+
+/**
+ * et131x_disable_txrx - Disable tx/rx queues
+ * @netdev: device to be disabled
+ */
+void et131x_disable_txrx(struct net_device *netdev)
+{
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+
+	/* First thing is to stop the queue */
+	netif_stop_queue(netdev);
+
+	/* Stop the Tx and Rx DMA engines */
+	et131x_rx_dma_disable(adapter);
+	et131x_tx_dma_disable(adapter);
+
+	/* Disable device interrupts */
+	et131x_disable_interrupts(adapter);
+}
+
+/**
  * et1310_enable_phy_coma - called when network cable is unplugged
  * @adapter: pointer to our adapter structure
  *
@@ -3164,32 +3256,6 @@ void et131x_tx_dma_memory_free(struct et131x_adapter *adapter)
 }
 
 /**
- * et131x_tx_dma_disable - Stop of Tx_DMA on the ET1310
- * @adapter: pointer to our adapter structure
- */
-void et131x_tx_dma_disable(struct et131x_adapter *adapter)
-{
-	/* Setup the tramsmit dma configuration register */
-	writel(ET_TXDMA_CSR_HALT|ET_TXDMA_SNGL_EPKT,
-					&adapter->regs->txdma.csr);
-}
-
-/**
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
  * et131x_init_send - Initialize send data structures
  * @adapter: pointer to our private adapter structure
  */
@@ -4046,27 +4112,6 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 }
 
 /**
- *	et131x_enable_interrupts	-	enable interrupt
- *	@adapter: et131x device
- *
- *	Enable the appropriate interrupts on the ET131x according to our
- *	configuration
- */
-void et131x_enable_interrupts(struct et131x_adapter *adapter)
-{
-	u32 mask;
-
-	/* Enable all global interrupts */
-	if (adapter->flowcontrol == FLOW_TXONLY ||
-			    adapter->flowcontrol == FLOW_BOTH)
-		mask = INT_MASK_ENABLE;
-	else
-		mask = INT_MASK_ENABLE_NO_FLOW;
-
-	writel(mask, &adapter->regs->global.int_mask);
-}
-
-/**
  * et131x_error_timer_handler
  * @data: timer-specific variable; here a pointer to our adapter structure
  *
@@ -4350,18 +4395,6 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 }
 
 /**
- *	et131x_disable_interrupts	-	interrupt disable
- *	@adapter: et131x device
- *
- *	Block all interrupts from the et131x device at the device itself
- */
-void et131x_disable_interrupts(struct et131x_adapter *adapter)
-{
-	/* Disable all global interrupts */
-	writel(INT_MASK_DISABLE, &adapter->regs->global.int_mask);
-}
-
-/**
  * et131x_pci_remove
  * @pdev: a pointer to the device's pci_dev structure
  *
@@ -4388,6 +4421,33 @@ static void __devexit et131x_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+/**
+ * et131x_up - Bring up a device for use.
+ * @netdev: device to be opened
+ */
+void et131x_up(struct net_device *netdev)
+{
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+
+	et131x_enable_txrx(netdev);
+	phy_start(adapter->phydev);
+}
+
+/**
+ * et131x_down - Bring down the device
+ * @netdev: device to be broght down
+ */
+void et131x_down(struct net_device *netdev)
+{
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+
+	/* Save the timestamp for the TX watchdog, prevent a timeout */
+	netdev->trans_start = jiffies;
+
+	phy_stop(adapter->phydev);
+	et131x_disable_txrx(netdev);
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int et131x_suspend(struct device *dev)
 {
@@ -4766,57 +4826,6 @@ static struct net_device_stats *et131x_stats(struct net_device *netdev)
 }
 
 /**
- * et131x_enable_txrx - Enable tx/rx queues
- * @netdev: device to be enabled
- */
-void et131x_enable_txrx(struct net_device *netdev)
-{
-	struct et131x_adapter *adapter = netdev_priv(netdev);
-
-	/* Enable the Tx and Rx DMA engines (if not already enabled) */
-	et131x_rx_dma_enable(adapter);
-	et131x_tx_dma_enable(adapter);
-
-	/* Enable device interrupts */
-	if (adapter->flags & fMP_ADAPTER_INTERRUPT_IN_USE)
-		et131x_enable_interrupts(adapter);
-
-	/* We're ready to move some data, so start the queue */
-	netif_start_queue(netdev);
-}
-
-/**
- * et131x_disable_txrx - Disable tx/rx queues
- * @netdev: device to be disabled
- */
-void et131x_disable_txrx(struct net_device *netdev)
-{
-	struct et131x_adapter *adapter = netdev_priv(netdev);
-
-	/* First thing is to stop the queue */
-	netif_stop_queue(netdev);
-
-	/* Stop the Tx and Rx DMA engines */
-	et131x_rx_dma_disable(adapter);
-	et131x_tx_dma_disable(adapter);
-
-	/* Disable device interrupts */
-	et131x_disable_interrupts(adapter);
-}
-
-/**
- * et131x_up - Bring up a device for use.
- * @netdev: device to be opened
- */
-void et131x_up(struct net_device *netdev)
-{
-	struct et131x_adapter *adapter = netdev_priv(netdev);
-
-	et131x_enable_txrx(netdev);
-	phy_start(adapter->phydev);
-}
-
-/**
  * et131x_open - Open the device for use.
  * @netdev: device to be opened
  *
@@ -4851,21 +4860,6 @@ int et131x_open(struct net_device *netdev)
 }
 
 /**
- * et131x_down - Bring down the device
- * @netdev: device to be broght down
- */
-void et131x_down(struct net_device *netdev)
-{
-	struct et131x_adapter *adapter = netdev_priv(netdev);
-
-	/* Save the timestamp for the TX watchdog, prevent a timeout */
-	netdev->trans_start = jiffies;
-
-	phy_stop(adapter->phydev);
-	et131x_disable_txrx(netdev);
-}
-
-/**
  * et131x_close - Close the device
  * @netdev: device to be closed
  *
-- 
1.7.6.4

