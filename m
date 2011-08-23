Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab1HWWn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:43:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54029 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab1HWWmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:42:12 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 3/8] [RESEND] staging: et131x: Converting et1310_adapter.h variable names from CamelCase
Date: Tue, 23 Aug 2011 23:40:35 +0100
Message-Id: <1314139240-869-4-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314139240-869-1-git-send-email-mark.einon@gmail.com>
References: <1312321621-2695-1-git-send-email-mark.einon@gmail.com>
 <1314139240-869-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on an ET-131x device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_mac.c     |   77 +++++++++++++-------------
 drivers/staging/et131x/et1310_phy.c     |   36 ++++++------
 drivers/staging/et131x/et1310_pm.c      |    8 ++--
 drivers/staging/et131x/et1310_rx.c      |   54 +++++++++++--------
 drivers/staging/et131x/et1310_tx.c      |   44 ++++++++--------
 drivers/staging/et131x/et131x_adapter.h |   91 +++++++++++++++----------------
 drivers/staging/et131x/et131x_initpci.c |   52 +++++++++---------
 drivers/staging/et131x/et131x_isr.c     |   10 ++--
 drivers/staging/et131x/et131x_netdev.c  |   71 +++++++++++++------------
 9 files changed, 228 insertions(+), 215 deletions(-)

diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index d1847c1..8e124fe 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -149,10 +149,10 @@ void et1310_config_mac_regs1(struct et131x_adapter *etdev)
 	 * being truncated.  Allow the MAC to pass 4 more than our max packet
 	 * size.  This is 4 for the Ethernet CRC.
 	 *
-	 * Packets larger than (RegistryJumboPacket) that do not contain a
+	 * Packets larger than (registry_jumbo_packet) that do not contain a
 	 * VLAN ID will be dropped by the Rx function.
 	 */
-	writel(etdev->RegistryJumboPacket + 4, &macregs->max_fm_len);
+	writel(etdev->registry_jumbo_packet + 4, &macregs->max_fm_len);
 
 	/* clear out MAC config reset */
 	writel(0, &macregs->cfg1);
@@ -294,7 +294,7 @@ void et1310_config_rxmac_regs(struct et131x_adapter *etdev)
 	writel(0, &rxmac->pf_ctrl);
 
 	/* Let's initialize the Unicast Packet filtering address */
-	if (etdev->PacketFilter & ET131X_PACKET_TYPE_DIRECTED) {
+	if (etdev->packet_filter & ET131X_PACKET_TYPE_DIRECTED) {
 		et1310_setup_device_for_unicast(etdev);
 		pf_ctrl |= 4;	/* Unicast filter */
 	} else {
@@ -304,7 +304,7 @@ void et1310_config_rxmac_regs(struct et131x_adapter *etdev)
 	}
 
 	/* Let's initialize the Multicast hash */
-	if (!(etdev->PacketFilter & ET131X_PACKET_TYPE_ALL_MULTICAST)) {
+	if (!(etdev->packet_filter & ET131X_PACKET_TYPE_ALL_MULTICAST)) {
 		pf_ctrl |= 2;	/* Multicast filter */
 		et1310_setup_device_for_multicast(etdev);
 	}
@@ -313,7 +313,7 @@ void et1310_config_rxmac_regs(struct et131x_adapter *etdev)
 	pf_ctrl |= (NIC_MIN_PACKET_SIZE + 4) << 16;
 	pf_ctrl |= 8;	/* Fragment filter */
 
-	if (etdev->RegistryJumboPacket > 8192)
+	if (etdev->registry_jumbo_packet > 8192)
 		/* In order to transmit jumbo packets greater than 8k, the
 		 * FIFO between RxMAC and RxDMA needs to be reduced in size
 		 * to (16k - Jumbo packet size).  In order to implement this,
@@ -489,22 +489,22 @@ void et1310_update_macstat_host_counters(struct et131x_adapter *etdev)
 	struct macstat_regs __iomem *macstat =
 		&etdev->regs->macstat;
 
-	stats->collisions           += readl(&macstat->tx_total_collisions);
-	stats->first_collision      += readl(&macstat->tx_single_collisions);
-	stats->tx_deferred          += readl(&macstat->tx_deferred);
-	stats->excessive_collisions += readl(&macstat->tx_multiple_collisions);
-	stats->late_collisions      += readl(&macstat->tx_late_collisions);
-	stats->tx_uflo              += readl(&macstat->tx_undersize_frames);
-	stats->max_pkt_error        += readl(&macstat->tx_oversize_frames);
-
-	stats->alignment_err        += readl(&macstat->rx_align_errs);
-	stats->crc_err              += readl(&macstat->rx_code_errs);
-	stats->norcvbuf             += readl(&macstat->rx_drops);
-	stats->rx_ov_flow           += readl(&macstat->rx_oversize_packets);
-	stats->code_violations      += readl(&macstat->rx_fcs_errs);
-	stats->length_err           += readl(&macstat->rx_frame_len_errs);
-
-	stats->other_errors         += readl(&macstat->rx_fragment_packets);
+	stats->tx_collisions	       += readl(&macstat->tx_total_collisions);
+	stats->tx_first_collisions     += readl(&macstat->tx_single_collisions);
+	stats->tx_deferred	       += readl(&macstat->tx_deferred);
+	stats->tx_excessive_collisions +=
+				readl(&macstat->tx_multiple_collisions);
+	stats->tx_late_collisions      += readl(&macstat->tx_late_collisions);
+	stats->tx_underflows	       += readl(&macstat->tx_undersize_frames);
+	stats->tx_max_pkt_errs	       += readl(&macstat->tx_oversize_frames);
+
+	stats->rx_align_errs        += readl(&macstat->rx_align_errs);
+	stats->rx_crc_errs          += readl(&macstat->rx_code_errs);
+	stats->rcvd_pkts_dropped    += readl(&macstat->rx_drops);
+	stats->rx_overflows         += readl(&macstat->rx_oversize_packets);
+	stats->rx_code_violations   += readl(&macstat->rx_fcs_errs);
+	stats->rx_length_errs       += readl(&macstat->rx_frame_len_errs);
+	stats->rx_other_errs        += readl(&macstat->rx_fragment_packets);
 }
 
 /**
@@ -536,33 +536,33 @@ void et1310_handle_macstat_interrupt(struct et131x_adapter *etdev)
 	 * block indicates that one of the counters has wrapped.
 	 */
 	if (carry_reg1 & (1 << 14))
-		etdev->stats.code_violations      += COUNTER_WRAP_16_BIT;
+		etdev->stats.rx_code_violations	+= COUNTER_WRAP_16_BIT;
 	if (carry_reg1 & (1 << 8))
-		etdev->stats.alignment_err        += COUNTER_WRAP_12_BIT;
+		etdev->stats.rx_align_errs	+= COUNTER_WRAP_12_BIT;
 	if (carry_reg1 & (1 << 7))
-		etdev->stats.length_err           += COUNTER_WRAP_16_BIT;
+		etdev->stats.rx_length_errs	+= COUNTER_WRAP_16_BIT;
 	if (carry_reg1 & (1 << 2))
-		etdev->stats.other_errors         += COUNTER_WRAP_16_BIT;
+		etdev->stats.rx_other_errs	+= COUNTER_WRAP_16_BIT;
 	if (carry_reg1 & (1 << 6))
-		etdev->stats.crc_err              += COUNTER_WRAP_16_BIT;
+		etdev->stats.rx_crc_errs	+= COUNTER_WRAP_16_BIT;
 	if (carry_reg1 & (1 << 3))
-		etdev->stats.rx_ov_flow           += COUNTER_WRAP_16_BIT;
+		etdev->stats.rx_overflows	+= COUNTER_WRAP_16_BIT;
 	if (carry_reg1 & (1 << 0))
-		etdev->stats.norcvbuf             += COUNTER_WRAP_16_BIT;
+		etdev->stats.rcvd_pkts_dropped	+= COUNTER_WRAP_16_BIT;
 	if (carry_reg2 & (1 << 16))
-		etdev->stats.max_pkt_error        += COUNTER_WRAP_12_BIT;
+		etdev->stats.tx_max_pkt_errs	+= COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 15))
-		etdev->stats.tx_uflo              += COUNTER_WRAP_12_BIT;
+		etdev->stats.tx_underflows	+= COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 6))
-		etdev->stats.first_collision      += COUNTER_WRAP_12_BIT;
+		etdev->stats.tx_first_collisions += COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 8))
-		etdev->stats.tx_deferred          += COUNTER_WRAP_12_BIT;
+		etdev->stats.tx_deferred	+= COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 5))
-		etdev->stats.excessive_collisions += COUNTER_WRAP_12_BIT;
+		etdev->stats.tx_excessive_collisions += COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 4))
-		etdev->stats.late_collisions      += COUNTER_WRAP_12_BIT;
+		etdev->stats.tx_late_collisions	+= COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 2))
-		etdev->stats.collisions           += COUNTER_WRAP_12_BIT;
+		etdev->stats.tx_collisions	+= COUNTER_WRAP_12_BIT;
 }
 
 void et1310_setup_device_for_multicast(struct et131x_adapter *etdev)
@@ -581,10 +581,11 @@ void et1310_setup_device_for_multicast(struct et131x_adapter *etdev)
 	 * specified) then we should pass NO multi-cast addresses to the
 	 * driver.
 	 */
-	if (etdev->PacketFilter & ET131X_PACKET_TYPE_MULTICAST) {
+	if (etdev->packet_filter & ET131X_PACKET_TYPE_MULTICAST) {
 		/* Loop through our multicast array and set up the device */
-		for (nIndex = 0; nIndex < etdev->MCAddressCount; nIndex++) {
-			result = ether_crc(6, etdev->MCList[nIndex]);
+		for (nIndex = 0; nIndex < etdev->multicast_addr_count;
+		     nIndex++) {
+			result = ether_crc(6, etdev->multicast_list[nIndex]);
 
 			result = (result & 0x3F800000) >> 23;
 
diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 3653426..9d2ce08 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -596,7 +596,7 @@ static void et131x_xcvr_init(struct et131x_adapter *etdev)
 	}
 
 	/* Determine if we need to go into a force mode and set it */
-	if (etdev->AiForceSpeed == 0 && etdev->AiForceDpx == 0) {
+	if (etdev->ai_force_speed == 0 && etdev->ai_force_duplex == 0) {
 		if (etdev->wanted_flow == FLOW_TXONLY ||
 		    etdev->wanted_flow == FLOW_BOTH)
 			et1310_phy_access_mii_bit(etdev,
@@ -623,7 +623,7 @@ static void et131x_xcvr_init(struct et131x_adapter *etdev)
 	et1310_phy_auto_neg(etdev, false);
 
 	/* Set to the correct force mode. */
-	if (etdev->AiForceDpx != 1) {
+	if (etdev->ai_force_duplex != 1) {
 		if (etdev->wanted_flow == FLOW_TXONLY ||
 		    etdev->wanted_flow == FLOW_BOTH)
 			et1310_phy_access_mii_bit(etdev,
@@ -645,16 +645,16 @@ static void et131x_xcvr_init(struct et131x_adapter *etdev)
 					  4, 11, NULL);
 	}
 	et1310_phy_power_down(etdev, 1);
-	switch (etdev->AiForceSpeed) {
+	switch (etdev->ai_force_speed) {
 	case 10:
 		/* First we need to turn off all other advertisement */
 		et1310_phy_advertise_1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
 		et1310_phy_advertise_100BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
-		if (etdev->AiForceDpx == 1) {
+		if (etdev->ai_force_duplex == 1) {
 			/* Set our advertise values accordingly */
 			et1310_phy_advertise_10BaseT(etdev,
 						TRUEPHY_ADV_DUPLEX_HALF);
-		} else if (etdev->AiForceDpx == 2) {
+		} else if (etdev->ai_force_duplex == 2) {
 			/* Set our advertise values accordingly */
 			et1310_phy_advertise_10BaseT(etdev,
 						TRUEPHY_ADV_DUPLEX_FULL);
@@ -674,13 +674,13 @@ static void et131x_xcvr_init(struct et131x_adapter *etdev)
 		/* first we need to turn off all other advertisement */
 		et1310_phy_advertise_1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
 		et1310_phy_advertise_10BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
-		if (etdev->AiForceDpx == 1) {
+		if (etdev->ai_force_duplex == 1) {
 			/* Set our advertise values accordingly */
 			et1310_phy_advertise_100BaseT(etdev,
 						TRUEPHY_ADV_DUPLEX_HALF);
 			/* Set speed */
 			et1310_phy_speed_select(etdev, TRUEPHY_SPEED_100MBPS);
-		} else if (etdev->AiForceDpx == 2) {
+		} else if (etdev->ai_force_duplex == 2) {
 			/* Set our advertise values accordingly */
 			et1310_phy_advertise_100BaseT(etdev,
 						TRUEPHY_ADV_DUPLEX_FULL);
@@ -741,11 +741,11 @@ void et131x_mii_check(struct et131x_adapter *etdev,
 			/* Update our state variables and indicate the
 			 * connected state
 			 */
-			spin_lock_irqsave(&etdev->Lock, flags);
+			spin_lock_irqsave(&etdev->lock, flags);
 
-			etdev->MediaState = NETIF_STATUS_MEDIA_CONNECT;
+			etdev->media_state = NETIF_STATUS_MEDIA_CONNECT;
 
-			spin_unlock_irqrestore(&etdev->Lock, flags);
+			spin_unlock_irqrestore(&etdev->lock, flags);
 
 			netif_carrier_on(etdev->netdev);
 		} else {
@@ -774,11 +774,11 @@ void et131x_mii_check(struct et131x_adapter *etdev,
 			 * Timer expires, we can report disconnected (handled
 			 * in the LinkDetectionDPC).
 			 */
-			if ((etdev->MediaState == NETIF_STATUS_MEDIA_DISCONNECT)) {
-				spin_lock_irqsave(&etdev->Lock, flags);
-				etdev->MediaState =
+			if (etdev->media_state == NETIF_STATUS_MEDIA_DISCONNECT) {
+				spin_lock_irqsave(&etdev->lock, flags);
+				etdev->media_state =
 				    NETIF_STATUS_MEDIA_DISCONNECT;
-				spin_unlock_irqrestore(&etdev->Lock,
+				spin_unlock_irqrestore(&etdev->lock,
 						       flags);
 
 				netif_carrier_off(etdev->netdev);
@@ -810,15 +810,15 @@ void et131x_mii_check(struct et131x_adapter *etdev,
 			/* Setup the PHY into coma mode until the cable is
 			 * plugged back in
 			 */
-			if (etdev->RegistryPhyComa == 1)
+			if (etdev->registry_phy_coma == 1)
 				et1310_enable_phy_coma(etdev);
 		}
 	}
 
 	if ((bmsr_ints & MI_BMSR_AUTO_NEG_COMPLETE) ||
-	    (etdev->AiForceDpx == 3 && (bmsr_ints & MI_BMSR_LINK_STATUS))) {
+	   (etdev->ai_force_duplex == 3 && (bmsr_ints & MI_BMSR_LINK_STATUS))) {
 		if ((bmsr & MI_BMSR_AUTO_NEG_COMPLETE) ||
-		    etdev->AiForceDpx == 3) {
+		    etdev->ai_force_duplex == 3) {
 			et1310_phy_link_status(etdev,
 					     &link_status, &autoneg_status,
 					     &speed, &duplex, &mdi_mdix,
@@ -849,7 +849,7 @@ void et131x_mii_check(struct et131x_adapter *etdev,
 			et1310_config_flow_control(etdev);
 
 			if (etdev->linkspeed == TRUEPHY_SPEED_1000MBPS &&
-					etdev->RegistryJumboPacket > 2048)
+					etdev->registry_jumbo_packet > 2048)
 				et1310_phy_and_or_reg(etdev, 0x16, 0xcfff,
 								   0x2000);
 
diff --git a/drivers/staging/et131x/et1310_pm.c b/drivers/staging/et131x/et1310_pm.c
index 1bfcc67..914aff6 100644
--- a/drivers/staging/et131x/et1310_pm.c
+++ b/drivers/staging/et131x/et1310_pm.c
@@ -116,8 +116,8 @@ void et1310_enable_phy_coma(struct et131x_adapter *etdev)
 	/* Save the GbE PHY speed and duplex modes. Need to restore this
 	 * when cable is plugged back in
 	 */
-	etdev->pdown_speed = etdev->AiForceSpeed;
-	etdev->pdown_duplex = etdev->AiForceDpx;
+	etdev->pdown_speed = etdev->ai_force_speed;
+	etdev->pdown_duplex = etdev->ai_force_duplex;
 
 	/* Stop sending packets. */
 	spin_lock_irqsave(&etdev->send_hw_lock, flags);
@@ -153,8 +153,8 @@ void et1310_disable_phy_coma(struct et131x_adapter *etdev)
 	/* Restore the GbE PHY speed and duplex modes;
 	 * Reset JAGCore; re-configure and initialize JAGCore and gigE PHY
 	 */
-	etdev->AiForceSpeed = etdev->pdown_speed;
-	etdev->AiForceDpx = etdev->pdown_duplex;
+	etdev->ai_force_speed = etdev->pdown_speed;
+	etdev->ai_force_duplex = etdev->pdown_duplex;
 
 	/* Re-initialize the send structures */
 	et131x_init_send(etdev);
diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index 694bb02..0924309 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -149,14 +149,14 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 * the number of entries halves.  FBR0 increases in size, however.
 	 */
 
-	if (adapter->RegistryJumboPacket < 2048) {
+	if (adapter->registry_jumbo_packet < 2048) {
 #ifdef USE_FBR0
 		rx_ring->fbr0_buffsize = 256;
 		rx_ring->fbr0_num_entries = 512;
 #endif
 		rx_ring->fbr1_buffsize = 2048;
 		rx_ring->fbr1_num_entries = 512;
-	} else if (adapter->RegistryJumboPacket < 4096) {
+	} else if (adapter->registry_jumbo_packet < 4096) {
 #ifdef USE_FBR0
 		rx_ring->fbr0_buffsize = 512;
 		rx_ring->fbr0_num_entries = 1024;
@@ -755,7 +755,7 @@ static void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
 	    (ring_index == 0 && buff_index < rx_local->fbr0_num_entries) ||
 #endif
 	    (ring_index == 1 && buff_index < rx_local->fbr1_num_entries)) {
-		spin_lock_irqsave(&etdev->FbrLock, flags);
+		spin_lock_irqsave(&etdev->fbr_lock, flags);
 
 		if (ring_index == 1) {
 			struct fbr_desc *next =
@@ -793,7 +793,7 @@ static void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
 			       &rx_dma->fbr0_full_offset);
 		}
 #endif
-		spin_unlock_irqrestore(&etdev->FbrLock, flags);
+		spin_unlock_irqrestore(&etdev->fbr_lock, flags);
 	} else {
 		dev_err(&etdev->pdev->dev,
 			  "%s illegal Buffer Index returned\n", __func__);
@@ -983,18 +983,18 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 	 * also counted here.
 	 */
 	if (len < (NIC_MIN_PACKET_SIZE + 4)) {
-		etdev->stats.other_errors++;
+		etdev->stats.rx_other_errs++;
 		len = 0;
 	}
 
 	if (len) {
-		if (etdev->ReplicaPhyLoopbk == 1) {
+		if (etdev->replica_phy_loopbk == 1) {
 			buf = rx_local->fbr[ring_index]->virt[buff_index];
 
 			if (memcmp(&buf[6], etdev->addr, ETH_ALEN) == 0) {
 				if (memcmp(&buf[42], "Replica packet",
 					   ETH_HLEN)) {
-					etdev->ReplicaPhyLoopbkPF = 1;
+					etdev->replica_phy_loopbk_passfail = 1;
 				}
 			}
 		}
@@ -1009,9 +1009,12 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 			 * filters. Generally filter is 0x2b when in
 			 * promiscuous mode.
 			 */
-			if ((etdev->PacketFilter & ET131X_PACKET_TYPE_MULTICAST)
-			    && !(etdev->PacketFilter & ET131X_PACKET_TYPE_PROMISCUOUS)
-			    && !(etdev->PacketFilter & ET131X_PACKET_TYPE_ALL_MULTICAST)) {
+			if ((etdev->packet_filter &
+					ET131X_PACKET_TYPE_MULTICAST)
+			    && !(etdev->packet_filter &
+					ET131X_PACKET_TYPE_PROMISCUOUS)
+			    && !(etdev->packet_filter &
+					ET131X_PACKET_TYPE_ALL_MULTICAST)) {
 				buf = rx_local->fbr[ring_index]->
 						virt[buff_index];
 
@@ -1019,13 +1022,20 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 				 * destination address of this packet
 				 * matches one in our list.
 				 */
-				for (i = 0; i < etdev->MCAddressCount; i++) {
-					if (buf[0] == etdev->MCList[i][0]
-					    && buf[1] == etdev->MCList[i][1]
-					    && buf[2] == etdev->MCList[i][2]
-					    && buf[3] == etdev->MCList[i][3]
-					    && buf[4] == etdev->MCList[i][4]
-					    && buf[5] == etdev->MCList[i][5]) {
+				for (i = 0; i < etdev->multicast_addr_count;
+				     i++) {
+					if (buf[0] ==
+						etdev->multicast_list[i][0]
+					    && buf[1] ==
+						etdev->multicast_list[i][1]
+					    && buf[2] ==
+						etdev->multicast_list[i][2]
+					    && buf[3] ==
+						etdev->multicast_list[i][3]
+					    && buf[4] ==
+						etdev->multicast_list[i][4]
+					    && buf[5] ==
+						etdev->multicast_list[i][5]) {
 						break;
 					}
 				}
@@ -1038,21 +1048,21 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 				 * so we free our RFD when we return
 				 * from this function.
 				 */
-				if (i == etdev->MCAddressCount)
+				if (i == etdev->multicast_addr_count)
 					len = 0;
 			}
 
 			if (len > 0)
-				etdev->stats.multircv++;
+				etdev->stats.multicast_pkts_rcvd++;
 		} else if (word0 & ALCATEL_BROADCAST_PKT)
-			etdev->stats.brdcstrcv++;
+			etdev->stats.broadcast_pkts_rcvd++;
 		else
 			/* Not sure what this counter measures in
 			 * promiscuous mode. Perhaps we should check
 			 * the MAC address to see if it is directed
 			 * to us in promiscuous mode.
 			 */
-			etdev->stats.unircv++;
+			etdev->stats.unicast_pkts_rcvd++;
 	}
 
 	if (len > 0) {
@@ -1128,7 +1138,7 @@ void et131x_handle_recv_interrupt(struct et131x_adapter *etdev)
 		 * If length is zero, return the RFD in order to advance the
 		 * Free buffer ring.
 		 */
-		if (!etdev->PacketFilter ||
+		if (!etdev->packet_filter ||
 		    !netif_carrier_ok(etdev->netdev) ||
 		    rfd->len == 0)
 			continue;
diff --git a/drivers/staging/et131x/et1310_tx.c b/drivers/staging/et131x/et1310_tx.c
index da9b4af..eb8552b 100644
--- a/drivers/staging/et131x/et1310_tx.c
+++ b/drivers/staging/et131x/et1310_tx.c
@@ -456,7 +456,7 @@ static int nic_send_packet(struct et131x_adapter *etdev, struct tcb *tcb)
 	} else
 		tcb->index = etdev->tx_ring.send_idx - 1;
 
-	spin_lock(&etdev->TCBSendQLock);
+	spin_lock(&etdev->tcb_send_qlock);
 
 	if (etdev->tx_ring.send_tail)
 		etdev->tx_ring.send_tail->next = tcb;
@@ -469,7 +469,7 @@ static int nic_send_packet(struct et131x_adapter *etdev, struct tcb *tcb)
 
 	etdev->tx_ring.used++;
 
-	spin_unlock(&etdev->TCBSendQLock);
+	spin_unlock(&etdev->tcb_send_qlock);
 
 	/* Write the new write pointer back to the device. */
 	writel(etdev->tx_ring.send_idx,
@@ -508,12 +508,12 @@ static int send_packet(struct sk_buff *skb, struct et131x_adapter *etdev)
 		return -EIO;
 
 	/* Get a TCB for this packet */
-	spin_lock_irqsave(&etdev->TCBReadyQLock, flags);
+	spin_lock_irqsave(&etdev->tcb_ready_qlock, flags);
 
 	tcb = etdev->tx_ring.tcb_qhead;
 
 	if (tcb == NULL) {
-		spin_unlock_irqrestore(&etdev->TCBReadyQLock, flags);
+		spin_unlock_irqrestore(&etdev->tcb_ready_qlock, flags);
 		return -ENOMEM;
 	}
 
@@ -522,7 +522,7 @@ static int send_packet(struct sk_buff *skb, struct et131x_adapter *etdev)
 	if (etdev->tx_ring.tcb_qhead == NULL)
 		etdev->tx_ring.tcb_qtail = NULL;
 
-	spin_unlock_irqrestore(&etdev->TCBReadyQLock, flags);
+	spin_unlock_irqrestore(&etdev->tcb_ready_qlock, flags);
 
 	tcb->skb = skb;
 
@@ -543,7 +543,7 @@ static int send_packet(struct sk_buff *skb, struct et131x_adapter *etdev)
 	status = nic_send_packet(etdev, tcb);
 
 	if (status != 0) {
-		spin_lock_irqsave(&etdev->TCBReadyQLock, flags);
+		spin_lock_irqsave(&etdev->tcb_ready_qlock, flags);
 
 		if (etdev->tx_ring.tcb_qtail)
 			etdev->tx_ring.tcb_qtail->next = tcb;
@@ -552,7 +552,7 @@ static int send_packet(struct sk_buff *skb, struct et131x_adapter *etdev)
 			etdev->tx_ring.tcb_qhead = tcb;
 
 		etdev->tx_ring.tcb_qtail = tcb;
-		spin_unlock_irqrestore(&etdev->TCBReadyQLock, flags);
+		spin_unlock_irqrestore(&etdev->tcb_ready_qlock, flags);
 		return status;
 	}
 	WARN_ON(etdev->tx_ring.used > NUM_TCB);
@@ -627,11 +627,11 @@ static inline void free_send_packet(struct et131x_adapter *etdev,
 	struct net_device_stats *stats = &etdev->net_stats;
 
 	if (tcb->flags & fMP_DEST_BROAD)
-		atomic_inc(&etdev->stats.brdcstxmt);
+		atomic_inc(&etdev->stats.broadcast_pkts_xmtd);
 	else if (tcb->flags & fMP_DEST_MULTI)
-		atomic_inc(&etdev->stats.multixmt);
+		atomic_inc(&etdev->stats.multicast_pkts_xmtd);
 	else
-		atomic_inc(&etdev->stats.unixmt);
+		atomic_inc(&etdev->stats.unicast_pkts_xmtd);
 
 	if (tcb->skb) {
 		stats->tx_bytes += tcb->skb->len;
@@ -663,7 +663,7 @@ static inline void free_send_packet(struct et131x_adapter *etdev,
 	memset(tcb, 0, sizeof(struct tcb));
 
 	/* Add the TCB to the Ready Q */
-	spin_lock_irqsave(&etdev->TCBReadyQLock, flags);
+	spin_lock_irqsave(&etdev->tcb_ready_qlock, flags);
 
 	etdev->net_stats.tx_packets++;
 
@@ -675,7 +675,7 @@ static inline void free_send_packet(struct et131x_adapter *etdev,
 
 	etdev->tx_ring.tcb_qtail = tcb;
 
-	spin_unlock_irqrestore(&etdev->TCBReadyQLock, flags);
+	spin_unlock_irqrestore(&etdev->tcb_ready_qlock, flags);
 	WARN_ON(etdev->tx_ring.used < 0);
 }
 
@@ -692,7 +692,7 @@ void et131x_free_busy_send_packets(struct et131x_adapter *etdev)
 	u32 freed = 0;
 
 	/* Any packets being sent? Check the first TCB on the send list */
-	spin_lock_irqsave(&etdev->TCBSendQLock, flags);
+	spin_lock_irqsave(&etdev->tcb_send_qlock, flags);
 
 	tcb = etdev->tx_ring.send_head;
 
@@ -706,19 +706,19 @@ void et131x_free_busy_send_packets(struct et131x_adapter *etdev)
 
 		etdev->tx_ring.used--;
 
-		spin_unlock_irqrestore(&etdev->TCBSendQLock, flags);
+		spin_unlock_irqrestore(&etdev->tcb_send_qlock, flags);
 
 		freed++;
 		free_send_packet(etdev, tcb);
 
-		spin_lock_irqsave(&etdev->TCBSendQLock, flags);
+		spin_lock_irqsave(&etdev->tcb_send_qlock, flags);
 
 		tcb = etdev->tx_ring.send_head;
 	}
 
 	WARN_ON(freed == NUM_TCB);
 
-	spin_unlock_irqrestore(&etdev->TCBSendQLock, flags);
+	spin_unlock_irqrestore(&etdev->tcb_send_qlock, flags);
 
 	etdev->tx_ring.used = 0;
 }
@@ -745,7 +745,7 @@ void et131x_handle_send_interrupt(struct et131x_adapter *etdev)
 	/* Has the ring wrapped?  Process any descriptors that do not have
 	 * the same "wrap" indicator as the current completion indicator
 	 */
-	spin_lock_irqsave(&etdev->TCBSendQLock, flags);
+	spin_lock_irqsave(&etdev->tcb_send_qlock, flags);
 
 	tcb = etdev->tx_ring.send_head;
 
@@ -757,9 +757,9 @@ void et131x_handle_send_interrupt(struct et131x_adapter *etdev)
 		if (tcb->next == NULL)
 			etdev->tx_ring.send_tail = NULL;
 
-		spin_unlock_irqrestore(&etdev->TCBSendQLock, flags);
+		spin_unlock_irqrestore(&etdev->tcb_send_qlock, flags);
 		free_send_packet(etdev, tcb);
-		spin_lock_irqsave(&etdev->TCBSendQLock, flags);
+		spin_lock_irqsave(&etdev->tcb_send_qlock, flags);
 
 		/* Goto the next packet */
 		tcb = etdev->tx_ring.send_head;
@@ -772,9 +772,9 @@ void et131x_handle_send_interrupt(struct et131x_adapter *etdev)
 		if (tcb->next == NULL)
 			etdev->tx_ring.send_tail = NULL;
 
-		spin_unlock_irqrestore(&etdev->TCBSendQLock, flags);
+		spin_unlock_irqrestore(&etdev->tcb_send_qlock, flags);
 		free_send_packet(etdev, tcb);
-		spin_lock_irqsave(&etdev->TCBSendQLock, flags);
+		spin_lock_irqsave(&etdev->tcb_send_qlock, flags);
 
 		/* Goto the next packet */
 		tcb = etdev->tx_ring.send_head;
@@ -784,6 +784,6 @@ void et131x_handle_send_interrupt(struct et131x_adapter *etdev)
 	if (etdev->tx_ring.used <= NUM_TCB / 3)
 		netif_wake_queue(etdev->netdev);
 
-	spin_unlock_irqrestore(&etdev->TCBSendQLock, flags);
+	spin_unlock_irqrestore(&etdev->tcb_send_qlock, flags);
 }
 
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index 408c50b..5dfa153 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -105,40 +105,39 @@ struct ce_stats {
 	 * MUST have 32, then we'll need another way to perform atomic
 	 * operations
 	 */
-	u32 unircv;	/* # multicast packets received */
-	atomic_t unixmt;	/* # multicast packets for Tx */
-	u32 multircv;	/* # multicast packets received */
-	atomic_t multixmt;	/* # multicast packets for Tx */
-	u32 brdcstrcv;	/* # broadcast packets received */
-	atomic_t brdcstxmt;	/* # broadcast packets for Tx */
-	u32 norcvbuf;	/* # Rx packets discarded */
-	u32 noxmtbuf;	/* # Tx packets discarded */
+	u32		unicast_pkts_rcvd;
+	atomic_t	unicast_pkts_xmtd;
+	u32		multicast_pkts_rcvd;
+	atomic_t	multicast_pkts_xmtd;
+	u32		broadcast_pkts_rcvd;
+	atomic_t	broadcast_pkts_xmtd;
+	u32		rcvd_pkts_dropped;
 
 	/* Transceiver state informations. */
-	u8 xcvr_addr;
-	u32 xcvr_id;
+	u8		xcvr_addr;
+	u32		xcvr_id;
 
 	/* Tx Statistics. */
-	u32 tx_uflo;		/* Tx Underruns */
+	u32		tx_underflows;
 
-	u32 collisions;
-	u32 excessive_collisions;
-	u32 first_collision;
-	u32 late_collisions;
-	u32 max_pkt_error;
-	u32 tx_deferred;
+	u32		tx_collisions;
+	u32		tx_excessive_collisions;
+	u32		tx_first_collisions;
+	u32		tx_late_collisions;
+	u32		tx_max_pkt_errs;
+	u32		tx_deferred;
 
 	/* Rx Statistics. */
-	u32 rx_ov_flow;	/* Rx Overflow */
+	u32		rx_overflows;
 
-	u32 length_err;
-	u32 alignment_err;
-	u32 crc_err;
-	u32 code_violations;
-	u32 other_errors;
+	u32		rx_length_errs;
+	u32		rx_align_errs;
+	u32		rx_crc_errs;
+	u32		rx_code_violations;
+	u32		rx_other_errs;
 
-	u32 SynchrounousIterations;
-	u32 InterruptStatus;
+	u32		synchronous_iterations;
+	u32		interrupt_status;
 };
 
 
@@ -151,7 +150,7 @@ struct et131x_adapter {
 
 	/* Flags that indicate current state of the adapter */
 	u32 flags;
-	u32 HwErrCount;
+	u32 hw_errs;
 
 	/* Configuration  */
 	u8 rom_addr[ETH_ALEN];
@@ -160,52 +159,52 @@ struct et131x_adapter {
 	u8 eeprom_data[2];
 
 	/* Spinlocks */
-	spinlock_t Lock;
+	spinlock_t lock;
 
-	spinlock_t TCBSendQLock;
-	spinlock_t TCBReadyQLock;
+	spinlock_t tcb_send_qlock;
+	spinlock_t tcb_ready_qlock;
 	spinlock_t send_hw_lock;
 
 	spinlock_t rcv_lock;
-	spinlock_t RcvPendLock;
-	spinlock_t FbrLock;
+	spinlock_t rcv_pend_lock;
+	spinlock_t fbr_lock;
 
-	spinlock_t PHYLock;
+	spinlock_t phy_lock;
 
 	/* Packet Filter and look ahead size */
-	u32 PacketFilter;
+	u32 packet_filter;
 	u32 linkspeed;
 	u32 duplex_mode;
 
 	/* multicast list */
-	u32 MCAddressCount;
-	u8 MCList[NIC_MAX_MCAST_LIST][ETH_ALEN];
+	u32 multicast_addr_count;
+	u8 multicast_list[NIC_MAX_MCAST_LIST][ETH_ALEN];
 
 	/* Pointer to the device's PCI register space */
 	struct address_map __iomem *regs;
 
 	/* Registry parameters */
-	u8 SpeedDuplex;		/* speed/duplex */
+	u8 speed_duplex;	/* speed/duplex */
 	u8 wanted_flow;		/* Flow we want for 802.3x flow control */
-	u8 RegistryPhyComa;	/* Phy Coma mode enable/disable */
+	u8 registry_phy_coma;	/* Phy Coma mode enable/disable */
 
-	u32 RegistryRxMemEnd;	/* Size of internal rx memory */
-	u32 RegistryJumboPacket;	/* Max supported ethernet packet size */
+	u32 registry_rx_mem_end;	/* Size of internal rx memory */
+	u32 registry_jumbo_packet;	/* Max supported ethernet packet size */
 
 
 	/* Derived from the registry: */
-	u8 AiForceDpx;		/* duplex setting */
-	u16 AiForceSpeed;	/* 'Speed', user over-ride of line speed */
+	u8 ai_force_duplex;	/* duplex setting */
+	u16 ai_force_speed;	/* 'Speed', user over-ride of line speed */
 	u8 flowcontrol;		/* flow control validated by the far-end */
 	enum {
 		NETIF_STATUS_INVALID = 0,
 		NETIF_STATUS_MEDIA_CONNECT,
 		NETIF_STATUS_MEDIA_DISCONNECT,
 		NETIF_STATUS_MAX
-	} MediaState;
+	} media_state;
 
 	/* Minimize init-time */
-	struct timer_list ErrorTimer;
+	struct timer_list error_timer;
 
 	/* variable putting the phy into coma mode when boot up with no cable
 	 * plugged in after 5 seconds
@@ -219,7 +218,7 @@ struct et131x_adapter {
 	u16 pdown_speed;
 	u8 pdown_duplex;
 
-	u32 CachedMaskValue;
+	u32 cached_mask_value;
 
 	/* Xcvr status at last poll */
 	u16 bmsr;
@@ -231,8 +230,8 @@ struct et131x_adapter {
 	struct rx_ring rx_ring;
 
 	/* Loopback specifics */
-	u8 ReplicaPhyLoopbk;	/* Replica Enable */
-	u8 ReplicaPhyLoopbkPF;	/* Replica Enable Pass/Fail */
+	u8 replica_phy_loopbk;		/* Replica Enable */
+	u8 replica_phy_loopbk_passfail;	/* Replica Enable Pass/Fail */
 
 	/* Stats */
 	struct ce_stats stats;
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index c217a05..32a20ddaa 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -275,14 +275,14 @@ void et131x_error_timer_handler(unsigned long data)
 		    "No interrupts, in PHY coma, pm_csr = 0x%x\n", pm_csr);
 
 	if (!(etdev->bmsr & MI_BMSR_LINK_STATUS) &&
-	    etdev->RegistryPhyComa &&
+	    etdev->registry_phy_coma &&
 	    etdev->boot_coma < 11) {
 		etdev->boot_coma++;
 	}
 
 	if (etdev->boot_coma == 10) {
 		if (!(etdev->bmsr & MI_BMSR_LINK_STATUS)
-		    && etdev->RegistryPhyComa) {
+		    && etdev->registry_phy_coma) {
 			if ((pm_csr & ET_PM_PHY_SW_COMA) == 0) {
 				/* NOTE - This was originally a 'sync with
 				 *  interrupt'. How to do that under Linux?
@@ -294,7 +294,7 @@ void et131x_error_timer_handler(unsigned long data)
 	}
 
 	/* This is a periodic timer, so reschedule */
-	mod_timer(&etdev->ErrorTimer, jiffies +
+	mod_timer(&etdev->error_timer, jiffies +
 					  TX_ERROR_PERIOD * HZ / 1000);
 }
 
@@ -308,12 +308,12 @@ void et131x_link_detection_handler(unsigned long data)
 	struct et131x_adapter *etdev = (struct et131x_adapter *) data;
 	unsigned long flags;
 
-	if (etdev->MediaState == 0) {
-		spin_lock_irqsave(&etdev->Lock, flags);
+	if (etdev->media_state == 0) {
+		spin_lock_irqsave(&etdev->lock, flags);
 
-		etdev->MediaState = NETIF_STATUS_MEDIA_DISCONNECT;
+		etdev->media_state = NETIF_STATUS_MEDIA_DISCONNECT;
 
-		spin_unlock_irqrestore(&etdev->Lock, flags);
+		spin_unlock_irqrestore(&etdev->lock, flags);
 
 		netif_carrier_off(etdev->netdev);
 	}
@@ -332,7 +332,7 @@ void et131x_configure_global_regs(struct et131x_adapter *etdev)
 	writel(0, &regs->rxq_start_addr);
 	writel(INTERNAL_MEM_SIZE - 1, &regs->txq_end_addr);
 
-	if (etdev->RegistryJumboPacket < 2048) {
+	if (etdev->registry_jumbo_packet < 2048) {
 		/* Tx / RxDMA and Tx/Rx MAC interfaces have a 1k word
 		 * block of RAM that the driver can split between Tx
 		 * and Rx as it desires.  Our default is to split it
@@ -340,7 +340,7 @@ void et131x_configure_global_regs(struct et131x_adapter *etdev)
 		 */
 		writel(PARM_RX_MEM_END_DEF, &regs->rxq_end_addr);
 		writel(PARM_RX_MEM_END_DEF + 1, &regs->txq_start_addr);
-	} else if (etdev->RegistryJumboPacket < 8192) {
+	} else if (etdev->registry_jumbo_packet < 8192) {
 		/* For jumbo packets > 2k but < 8k, split 50-50. */
 		writel(INTERNAL_MEM_RX_OFFSET, &regs->rxq_end_addr);
 		writel(INTERNAL_MEM_RX_OFFSET + 1, &regs->txq_start_addr);
@@ -547,27 +547,27 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 	netdev->base_addr = pci_resource_start(pdev, 0);
 
 	/* Initialize spinlocks here */
-	spin_lock_init(&etdev->Lock);
-	spin_lock_init(&etdev->TCBSendQLock);
-	spin_lock_init(&etdev->TCBReadyQLock);
+	spin_lock_init(&etdev->lock);
+	spin_lock_init(&etdev->tcb_send_qlock);
+	spin_lock_init(&etdev->tcb_ready_qlock);
 	spin_lock_init(&etdev->send_hw_lock);
 	spin_lock_init(&etdev->rcv_lock);
-	spin_lock_init(&etdev->RcvPendLock);
-	spin_lock_init(&etdev->FbrLock);
-	spin_lock_init(&etdev->PHYLock);
+	spin_lock_init(&etdev->rcv_pend_lock);
+	spin_lock_init(&etdev->fbr_lock);
+	spin_lock_init(&etdev->phy_lock);
 
 	/* Parse configuration parameters into the private adapter struct */
 	if (et131x_speed_set)
 		dev_info(&etdev->pdev->dev,
 			"Speed set manually to : %d\n", et131x_speed_set);
 
-	etdev->SpeedDuplex = et131x_speed_set;
-	etdev->RegistryJumboPacket = 1514;	/* 1514-9216 */
+	etdev->speed_duplex = et131x_speed_set;
+	etdev->registry_jumbo_packet = 1514;	/* 1514-9216 */
 
 	/* Set the MAC address to a default */
 	memcpy(etdev->addr, default_mac, ETH_ALEN);
 
-	/* Decode SpeedDuplex
+	/* Decode speed_duplex
 	 *
 	 * Set up as if we are auto negotiating always and then change if we
 	 * go into force mode
@@ -576,11 +576,11 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 	 * knock it down to 100 full.
 	 */
 	if (etdev->pdev->device == ET131X_PCI_DEVICE_ID_FAST &&
-	    etdev->SpeedDuplex == 5)
-		etdev->SpeedDuplex = 4;
+	    etdev->speed_duplex == 5)
+		etdev->speed_duplex = 4;
 
-	etdev->AiForceSpeed = speed[etdev->SpeedDuplex];
-	etdev->AiForceDpx = duplex[etdev->SpeedDuplex];	/* Auto FDX */
+	etdev->ai_force_speed = speed[etdev->speed_duplex];
+	etdev->ai_force_duplex = duplex[etdev->speed_duplex];	/* Auto FDX */
 
 	return etdev;
 }
@@ -711,11 +711,11 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	et131x_adapter_setup(adapter);
 
 	/* Create a timer to count errors received by the NIC */
-	init_timer(&adapter->ErrorTimer);
+	init_timer(&adapter->error_timer);
 
-	adapter->ErrorTimer.expires = jiffies + TX_ERROR_PERIOD * HZ / 1000;
-	adapter->ErrorTimer.function = et131x_error_timer_handler;
-	adapter->ErrorTimer.data = (unsigned long)adapter;
+	adapter->error_timer.expires = jiffies + TX_ERROR_PERIOD * HZ / 1000;
+	adapter->error_timer.function = et131x_error_timer_handler;
+	adapter->error_timer.data = (unsigned long)adapter;
 
 	/* Initialize link state */
 	et131x_link_detection_handler((unsigned long)adapter);
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index 9b316be..1584ab2 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -124,7 +124,7 @@ void et131x_enable_interrupts(struct et131x_adapter *adapter)
 	else
 		mask = INT_MASK_ENABLE_NO_FLOW;
 
-	adapter->CachedMaskValue = mask;
+	adapter->cached_mask_value = mask;
 	writel(mask, &adapter->regs->global.int_mask);
 }
 
@@ -138,7 +138,7 @@ void et131x_enable_interrupts(struct et131x_adapter *adapter)
 void et131x_disable_interrupts(struct et131x_adapter *adapter)
 {
 	/* Disable all global interrupts */
-	adapter->CachedMaskValue = INT_MASK_DISABLE;
+	adapter->cached_mask_value = INT_MASK_DISABLE;
 	writel(INT_MASK_DISABLE, &adapter->regs->global.int_mask);
 }
 
@@ -222,7 +222,7 @@ irqreturn_t et131x_isr(int irq, void *dev_id)
 	 * DPC. We will clear the software copy of that in that
 	 * routine.
 	 */
-	adapter->stats.InterruptStatus = status;
+	adapter->stats.interrupt_status = status;
 
 	/* Schedule the ISR handler as a bottom-half task in the
 	 * kernel's tq_immediate queue, and mark the queue for
@@ -244,7 +244,7 @@ void et131x_isr_handler(struct work_struct *work)
 {
 	struct et131x_adapter *etdev =
 		container_of(work, struct et131x_adapter, task);
-	u32 status = etdev->stats.InterruptStatus;
+	u32 status = etdev->stats.interrupt_status;
 	struct address_map __iomem *iomem = etdev->regs;
 
 	/*
@@ -389,7 +389,7 @@ void et131x_isr_handler(struct work_struct *work)
 					(uint8_t) offsetof(struct mi_regs, isr),
 					&myisr);
 
-			if (!etdev->ReplicaPhyLoopbk) {
+			if (!etdev->replica_phy_loopbk) {
 				et131x_mii_read(etdev,
 				       (uint8_t) offsetof(struct mi_regs, bmsr),
 				       &bmsr_data);
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 6eef4be..5fe3ec4 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -100,15 +100,18 @@ static struct net_device_stats *et131x_stats(struct net_device *netdev)
 	struct net_device_stats *stats = &adapter->net_stats;
 	struct ce_stats *devstat = &adapter->stats;
 
-	stats->rx_errors = devstat->length_err + devstat->alignment_err +
-	    devstat->crc_err + devstat->code_violations + devstat->other_errors;
-	stats->tx_errors = devstat->max_pkt_error;
-	stats->multicast = devstat->multircv;
-	stats->collisions = devstat->collisions;
-
-	stats->rx_length_errors = devstat->length_err;
-	stats->rx_over_errors = devstat->rx_ov_flow;
-	stats->rx_crc_errors = devstat->crc_err;
+	stats->rx_errors = devstat->rx_length_errs +
+			   devstat->rx_align_errs +
+			   devstat->rx_crc_errs +
+			   devstat->rx_code_violations +
+			   devstat->rx_other_errs;
+	stats->tx_errors = devstat->tx_max_pkt_errs;
+	stats->multicast = devstat->multicast_pkts_rcvd;
+	stats->collisions = devstat->tx_collisions;
+
+	stats->rx_length_errors = devstat->rx_length_errs;
+	stats->rx_over_errors = devstat->rx_overflows;
+	stats->rx_crc_errors = devstat->rx_crc_errs;
 
 	/* NOTE: These stats don't have corresponding values in CE_STATS,
 	 * so we're going to have to update these directly from within the
@@ -144,7 +147,7 @@ int et131x_open(struct net_device *netdev)
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
 	/* Start the timer to track NIC errors */
-	add_timer(&adapter->ErrorTimer);
+	add_timer(&adapter->error_timer);
 
 	/* Register our IRQ */
 	result = request_irq(netdev->irq, et131x_isr, IRQF_SHARED,
@@ -194,7 +197,7 @@ int et131x_close(struct net_device *netdev)
 	free_irq(netdev->irq, netdev);
 
 	/* Stop the error timer */
-	del_timer_sync(&adapter->ErrorTimer);
+	del_timer_sync(&adapter->error_timer);
 	return 0;
 }
 
@@ -275,7 +278,7 @@ int et131x_ioctl(struct net_device *netdev, struct ifreq *reqbuf, int cmd)
 int et131x_set_packet_filter(struct et131x_adapter *adapter)
 {
 	int status = 0;
-	uint32_t filter = adapter->PacketFilter;
+	uint32_t filter = adapter->packet_filter;
 	u32 ctrl;
 	u32 pf_ctrl;
 
@@ -337,67 +340,67 @@ int et131x_set_packet_filter(struct et131x_adapter *adapter)
 void et131x_multicast(struct net_device *netdev)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
-	uint32_t PacketFilter = 0;
+	uint32_t packet_filter = 0;
 	unsigned long flags;
 	struct netdev_hw_addr *ha;
 	int i;
 
-	spin_lock_irqsave(&adapter->Lock, flags);
+	spin_lock_irqsave(&adapter->lock, flags);
 
 	/* Before we modify the platform-independent filter flags, store them
 	 * locally. This allows us to determine if anything's changed and if
 	 * we even need to bother the hardware
 	 */
-	PacketFilter = adapter->PacketFilter;
+	packet_filter = adapter->packet_filter;
 
 	/* Clear the 'multicast' flag locally; because we only have a single
 	 * flag to check multicast, and multiple multicast addresses can be
 	 * set, this is the easiest way to determine if more than one
 	 * multicast address is being set.
 	 */
-	PacketFilter &= ~ET131X_PACKET_TYPE_MULTICAST;
+	packet_filter &= ~ET131X_PACKET_TYPE_MULTICAST;
 
 	/* Check the net_device flags and set the device independent flags
 	 * accordingly
 	 */
 
 	if (netdev->flags & IFF_PROMISC)
-		adapter->PacketFilter |= ET131X_PACKET_TYPE_PROMISCUOUS;
+		adapter->packet_filter |= ET131X_PACKET_TYPE_PROMISCUOUS;
 	else
-		adapter->PacketFilter &= ~ET131X_PACKET_TYPE_PROMISCUOUS;
+		adapter->packet_filter &= ~ET131X_PACKET_TYPE_PROMISCUOUS;
 
 	if (netdev->flags & IFF_ALLMULTI)
-		adapter->PacketFilter |= ET131X_PACKET_TYPE_ALL_MULTICAST;
+		adapter->packet_filter |= ET131X_PACKET_TYPE_ALL_MULTICAST;
 
 	if (netdev_mc_count(netdev) > NIC_MAX_MCAST_LIST)
-		adapter->PacketFilter |= ET131X_PACKET_TYPE_ALL_MULTICAST;
+		adapter->packet_filter |= ET131X_PACKET_TYPE_ALL_MULTICAST;
 
 	if (netdev_mc_count(netdev) < 1) {
-		adapter->PacketFilter &= ~ET131X_PACKET_TYPE_ALL_MULTICAST;
-		adapter->PacketFilter &= ~ET131X_PACKET_TYPE_MULTICAST;
+		adapter->packet_filter &= ~ET131X_PACKET_TYPE_ALL_MULTICAST;
+		adapter->packet_filter &= ~ET131X_PACKET_TYPE_MULTICAST;
 	} else
-		adapter->PacketFilter |= ET131X_PACKET_TYPE_MULTICAST;
+		adapter->packet_filter |= ET131X_PACKET_TYPE_MULTICAST;
 
 	/* Set values in the private adapter struct */
 	i = 0;
 	netdev_for_each_mc_addr(ha, netdev) {
 		if (i == NIC_MAX_MCAST_LIST)
 			break;
-		memcpy(adapter->MCList[i++], ha->addr, ETH_ALEN);
+		memcpy(adapter->multicast_list[i++], ha->addr, ETH_ALEN);
 	}
-	adapter->MCAddressCount = i;
+	adapter->multicast_addr_count = i;
 
 	/* Are the new flags different from the previous ones? If not, then no
 	 * action is required
 	 *
-	 * NOTE - This block will always update the MCList with the hardware,
-	 *        even if the addresses aren't the same.
+	 * NOTE - This block will always update the multicast_list with the
+	 *        hardware, even if the addresses aren't the same.
 	 */
-	if (PacketFilter != adapter->PacketFilter) {
+	if (packet_filter != adapter->packet_filter) {
 		/* Call the device's filter function */
 		et131x_set_packet_filter(adapter);
 	}
-	spin_unlock_irqrestore(&adapter->Lock, flags);
+	spin_unlock_irqrestore(&adapter->lock, flags);
 }
 
 /**
@@ -459,7 +462,7 @@ void et131x_tx_timeout(struct net_device *netdev)
 	}
 
 	/* Is send stuck? */
-	spin_lock_irqsave(&etdev->TCBSendQLock, flags);
+	spin_lock_irqsave(&etdev->tcb_send_qlock, flags);
 
 	tcb = etdev->tx_ring.send_head;
 
@@ -467,7 +470,7 @@ void et131x_tx_timeout(struct net_device *netdev)
 		tcb->count++;
 
 		if (tcb->count > NIC_SEND_HANG_THRESHOLD) {
-			spin_unlock_irqrestore(&etdev->TCBSendQLock,
+			spin_unlock_irqrestore(&etdev->tcb_send_qlock,
 					       flags);
 
 			dev_warn(&etdev->pdev->dev,
@@ -482,7 +485,7 @@ void et131x_tx_timeout(struct net_device *netdev)
 		}
 	}
 
-	spin_unlock_irqrestore(&etdev->TCBSendQLock, flags);
+	spin_unlock_irqrestore(&etdev->tcb_send_qlock, flags);
 }
 
 /**
@@ -520,7 +523,7 @@ int et131x_change_mtu(struct net_device *netdev, int new_mtu)
 	et131x_adapter_memory_free(adapter);
 
 	/* Set the config parameter for Jumbo Packet support */
-	adapter->RegistryJumboPacket = new_mtu + 14;
+	adapter->registry_jumbo_packet = new_mtu + 14;
 	et131x_soft_reset(adapter);
 
 	/* Alloc and init Rx DMA memory */
@@ -601,7 +604,7 @@ int et131x_set_mac_addr(struct net_device *netdev, void *new_mac)
 	et131x_adapter_memory_free(adapter);
 
 	/* Set the config parameter for Jumbo Packet support */
-	/* adapter->RegistryJumboPacket = new_mtu + 14; */
+	/* adapter->registry_jumbo_packet = new_mtu + 14; */
 	/* blux: not needet here, we'll change the MAC */
 
 	et131x_soft_reset(adapter);
-- 
1.7.6

