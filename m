Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab1IDK0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 06:26:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51740 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab1IDK0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 06:26:13 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 01/12] staging: et131x: Remove private adapter->linkspeed and use phydev->speed instead
Date: Sun,  4 Sep 2011 11:24:32 +0100
Message-Id: <1315131883-11068-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
References: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The phy device keeps a note of the link speed, so use that value instead of the driver private one.

Also use the phydev defines for link speeds, and remove the driver private ones.

adapter->hw_errs was never used, even in the vendor driver, so remove that too.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_mac.c     |    7 +++++--
 drivers/staging/et131x/et1310_phy.c     |    9 ++++-----
 drivers/staging/et131x/et1310_phy.h     |    5 -----
 drivers/staging/et131x/et1310_rx.c      |    9 +++++++--
 drivers/staging/et131x/et1310_tx.c      |    6 ++++--
 drivers/staging/et131x/et131x_adapter.h |    2 --
 drivers/staging/et131x/et131x_initpci.c |   12 ++++++------
 7 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index 36f2168..efabc03 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -82,6 +82,7 @@
 #include <linux/if_arp.h>
 #include <linux/ioport.h>
 #include <linux/crc32.h>
+#include <linux/phy.h>
 
 #include "et1310_phy.h"
 #include "et131x_adapter.h"
@@ -166,6 +167,7 @@ void et1310_config_mac_regs2(struct et131x_adapter *adapter)
 {
 	int32_t delay = 0;
 	struct mac_regs __iomem *mac = &adapter->regs->mac;
+	struct phy_device *phydev = adapter->phydev;
 	u32 cfg1;
 	u32 cfg2;
 	u32 ifctrl;
@@ -178,7 +180,7 @@ void et1310_config_mac_regs2(struct et131x_adapter *adapter)
 
 	/* Set up the if mode bits */
 	cfg2 &= ~0x300;
-	if (adapter->linkspeed == TRUEPHY_SPEED_1000MBPS) {
+	if (phydev && phydev->speed == SPEED_1000) {
 		cfg2 |= 0x200;
 		/* Phy mode bit */
 		ifctrl &= ~(1 << 24);
@@ -239,6 +241,7 @@ void et1310_config_mac_regs2(struct et131x_adapter *adapter)
 void et1310_config_rxmac_regs(struct et131x_adapter *adapter)
 {
 	struct rxmac_regs __iomem *rxmac = &adapter->regs->rxmac;
+	struct phy_device *phydev = adapter->phydev;
 	u32 sa_lo;
 	u32 sa_hi = 0;
 	u32 pf_ctrl = 0;
@@ -351,7 +354,7 @@ void et1310_config_rxmac_regs(struct et131x_adapter *adapter)
 	 * bit 16: Receive frame truncated.
 	 * bit 17: Drop packet enable
 	 */
-	if (adapter->linkspeed == TRUEPHY_SPEED_100MBPS)
+	if (phydev && phydev->speed == SPEED_100)
 		writel(0x30038, &rxmac->mif_ctrl);
 	else
 		writel(0x30030, &rxmac->mif_ctrl);
diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 12345c7..c5d0d02 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -440,6 +440,7 @@ void et131x_xcvr_init(struct et131x_adapter *adapter)
 void et131x_mii_check(struct et131x_adapter *adapter,
 		      u16 bmsr, u16 bmsr_ints)
 {
+	struct phy_device *phydev = adapter->phydev;
 	u8 link_status;
 	u32 autoneg_status;
 	u32 speed;
@@ -456,7 +457,7 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 			dev_warn(&adapter->pdev->dev,
 			    "Link down - cable problem ?\n");
 
-			if (adapter->linkspeed == TRUEPHY_SPEED_10MBPS) {
+			if (phydev && phydev->speed == SPEED_10) {
 				/* NOTE - Is there a way to query this without
 				 * TruePHY?
 				 * && TRU_QueryCoreType(adapter->hTruePhy, 0) ==
@@ -476,7 +477,6 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 
 			netif_carrier_off(adapter->netdev);
 
-			adapter->linkspeed = 0;
 			adapter->duplex_mode = 0;
 
 			/* Free the packets being actively sent & stopped */
@@ -516,12 +516,11 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 					     &speed, &duplex, &mdi_mdix,
 					     &masterslave, &polarity);
 
-			adapter->linkspeed = speed;
 			adapter->duplex_mode = duplex;
 
 			adapter->boot_coma = 20;
 
-			if (adapter->linkspeed == TRUEPHY_SPEED_10MBPS) {
+			if (phydev && phydev->speed == SPEED_10) {
 				/*
 				 * NOTE - Is there a way to query this without
 				 * TruePHY?
@@ -542,7 +541,7 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 
 			et1310_config_flow_control(adapter);
 
-			if (adapter->linkspeed == TRUEPHY_SPEED_1000MBPS &&
+			if (phydev && phydev->speed == SPEED_1000 &&
 					adapter->registry_jumbo_packet > 2048)
 				et1310_phy_and_or_reg(adapter, 0x16, 0xcfff,
 								   0x2000);
diff --git a/drivers/staging/et131x/et1310_phy.h b/drivers/staging/et131x/et1310_phy.h
index 88dc8cd..3e95c66 100644
--- a/drivers/staging/et131x/et1310_phy.h
+++ b/drivers/staging/et131x/et1310_phy.h
@@ -242,11 +242,6 @@ struct mi_regs {
 #define TRUEPHY_MASK                    2
 #endif
 
-/* Define speeds */
-#define TRUEPHY_SPEED_10MBPS            0
-#define TRUEPHY_SPEED_100MBPS           1
-#define TRUEPHY_SPEED_1000MBPS          2
-
 /* Define duplex modes */
 #define TRUEPHY_DUPLEX_HALF             0
 #define TRUEPHY_DUPLEX_FULL             1
diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index f50420c..c402c5e 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -82,6 +82,7 @@
 #include <linux/skbuff.h>
 #include <linux/if_arp.h>
 #include <linux/ioport.h>
+#include <linux/phy.h>
 
 #include "et1310_phy.h"
 #include "et131x_adapter.h"
@@ -724,11 +725,15 @@ void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
  */
 void et131x_set_rx_dma_timer(struct et131x_adapter *adapter)
 {
+	struct phy_device *phydev = adapter->phydev;
+
+	if (!phydev)
+		return;
+
 	/* For version B silicon, we do not use the RxDMA timer for 10 and 100
 	 * Mbits/s line rates. We do not enable and RxDMA interrupt coalescing.
 	 */
-	if ((adapter->linkspeed == TRUEPHY_SPEED_100MBPS) ||
-	    (adapter->linkspeed == TRUEPHY_SPEED_10MBPS)) {
+	if ((phydev->speed == SPEED_100) || (phydev->speed == SPEED_10)) {
 		writel(0, &adapter->regs->rxdma.max_pkt_time);
 		writel(1, &adapter->regs->rxdma.num_pkt_done);
 	}
diff --git a/drivers/staging/et131x/et1310_tx.c b/drivers/staging/et131x/et1310_tx.c
index aa07138..1f80651 100644
--- a/drivers/staging/et131x/et1310_tx.c
+++ b/drivers/staging/et131x/et1310_tx.c
@@ -82,6 +82,7 @@
 #include <linux/skbuff.h>
 #include <linux/if_arp.h>
 #include <linux/ioport.h>
+#include <linux/phy.h>
 
 #include "et1310_phy.h"
 #include "et131x_adapter.h"
@@ -287,6 +288,7 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 	u32 nr_frags = skb_shinfo(skb)->nr_frags + 1;
 	struct skb_frag_struct *frags = &skb_shinfo(skb)->frags[0];
 	unsigned long flags;
+	struct phy_device *phydev = adapter->phydev;
 
 	/* Part of the optimizations of this send routine restrict us to
 	 * sending 24 fragments at a pass.  In practice we should never see
@@ -400,7 +402,7 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 	if (frag == 0)
 		return -EIO;
 
-	if (adapter->linkspeed == TRUEPHY_SPEED_1000MBPS) {
+	if (phydev && phydev->speed == SPEED_1000) {
 		if (++adapter->tx_ring.since_irq == PARM_TX_NUM_BUFS_DEF) {
 			/* Last element & Interrupt flag */
 			desc[frag - 1].flags = 0x5;
@@ -478,7 +480,7 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 	/* For Gig only, we use Tx Interrupt coalescing.  Enable the software
 	 * timer to wake us up if this packet isn't followed by N more.
 	 */
-	if (adapter->linkspeed == TRUEPHY_SPEED_1000MBPS) {
+	if (phydev && phydev->speed == SPEED_1000) {
 		writel(PARM_TX_TIME_INT_DEF * NANO_IN_A_MICRO,
 		       &adapter->regs->global.watchdog_timer);
 	}
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index fbefd2e..1e65e79 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -147,7 +147,6 @@ struct et131x_adapter {
 
 	/* Flags that indicate current state of the adapter */
 	u32 flags;
-	u32 hw_errs;
 
 	/* Configuration  */
 	u8 rom_addr[ETH_ALEN];
@@ -170,7 +169,6 @@ struct et131x_adapter {
 
 	/* Packet Filter and look ahead size */
 	u32 packet_filter;
-	u32 linkspeed;
 	u32 duplex_mode;
 
 	/* multicast list */
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 3cfcc2d..eb08889 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -678,12 +678,6 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	/* Copy address into the net_device struct */
 	memcpy(netdev->dev_addr, adapter->addr, ETH_ALEN);
 
-	/* Setup et1310 as per the documentation */
-	et131x_adapter_setup(adapter);
-
-	/* Create a timer to count errors received by the NIC */
-	init_timer(&adapter->error_timer);
-
 	adapter->error_timer.expires = jiffies + TX_ERROR_PERIOD * HZ / 1000;
 	adapter->error_timer.function = et131x_error_timer_handler;
 	adapter->error_timer.data = (unsigned long)adapter;
@@ -726,6 +720,12 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 		goto err_mdio_unregister;
 	}
 
+	/* Setup et1310 as per the documentation */
+	et131x_adapter_setup(adapter);
+
+	/* Create a timer to count errors received by the NIC */
+	init_timer(&adapter->error_timer);
+
 	/* We can enable interrupts now
 	 *
 	 *  NOTE - Because registration of interrupt handler is done in the
-- 
1.7.6

