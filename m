Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab1IYSTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 14:19:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59929 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1IYST1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 14:19:27 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@linux.intel.com,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 3/6] staging: et131x: Remove et131x_check_mii() and move functionality into et131x_adjust_link()
Date: Sun, 25 Sep 2011 19:17:54 +0100
Message-Id: <1316974677-17108-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316974677-17108-1-git-send-email-mark.einon@gmail.com>
References: <1316974677-17108-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

et131x_check_mii() is now only being called from et131x_adjust_link.
Removed this call and associated subroutines, putting the functionality directly into et131x_adjust_link(), in preparation for further simplification.
Changed register checks from bare BMSR checks to use phydev/netif versions, also now uses adapter->link to track link state changes.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.c     |  167 -------------------------------
 drivers/staging/et131x/et131x_initpci.c |  115 ++++++++++++++++++---
 2 files changed, 98 insertions(+), 184 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index c4bc41d..fc37b18 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -298,68 +298,6 @@ void et1310_phy_power_down(struct et131x_adapter *adapter, bool down)
 	et131x_mii_write(adapter, MII_BMCR, data);
 }
 
-/**
- *	et1310_phy_link_status	-	read link state
- *	@adapter: device to read
- *	@link_status: reported link state
- *	@autoneg: reported autonegotiation state (complete/incomplete/disabled)
- *	@linkspeed: returnedlink speed in use
- *	@duplex_mode: reported half/full duplex state
- *	@mdi_mdix: not yet working
- *	@masterslave: report whether we are master or slave
- *	@polarity: link polarity
- *
- *	I can read your lan like a magazine
- *	I see if your up
- *	I know your link speed
- *	I see all the setting that you'd rather keep
- */
-static void et1310_phy_link_status(struct et131x_adapter *adapter,
-			  u8 *link_status,
-			  u32 *autoneg,
-			  u32 *linkspeed,
-			  u32 *duplex_mode,
-			  u32 *mdi_mdix,
-			  u32 *masterslave, u32 *polarity)
-{
-	u16 mistatus = 0;
-	u16 is1000BaseT = 0;
-	u16 vmi_phystatus = 0;
-	u16 control = 0;
-
-	et131x_mii_read(adapter, MII_BMSR, &mistatus);
-	et131x_mii_read(adapter, MII_STAT1000, &is1000BaseT);
-	et131x_mii_read(adapter, PHY_PHY_STATUS, &vmi_phystatus);
-	et131x_mii_read(adapter, MII_BMCR, &control);
-
-	*link_status = (vmi_phystatus & ET_PHY_LSTATUS) ? 1 : 0;
-	*autoneg = (control & ET_PHY_AUTONEG_STATUS) ?
-			((vmi_phystatus & ET_PHY_AUTONEG_ENABLE) ?
-					    TRUEPHY_ANEG_COMPLETE :
-					    TRUEPHY_ANEG_NOT_COMPLETE) :
-							TRUEPHY_ANEG_DISABLED;
-	*linkspeed = (vmi_phystatus & ET_PHY_SPEED_STATUS) >> 8;
-	*duplex_mode = (vmi_phystatus & ET_PHY_DUPLEX_STATUS) >> 7;
-	/* NOTE: Need to complete this */
-	*mdi_mdix = 0;
-
-	*masterslave = (is1000BaseT & ET_1000BT_MSTR_SLV) ?
-			TRUEPHY_CFG_MASTER : TRUEPHY_CFG_SLAVE;
-	*polarity = (vmi_phystatus & ET_PHY_POLARITY_STATUS) ?
-			TRUEPHY_POLARITY_INVERTED : TRUEPHY_POLARITY_NORMAL;
-}
-
-static void et1310_phy_and_or_reg(struct et131x_adapter *adapter,
-				  u16 regnum, u16 and_mask, u16 or_mask)
-{
-	u16 reg;
-
-	et131x_mii_read(adapter, regnum, &reg);
-	reg &= and_mask;
-	reg |= or_mask;
-	et131x_mii_write(adapter, regnum, reg);
-}
-
 /* Still used from _mac for BIT_READ */
 void et1310_phy_access_mii_bit(struct et131x_adapter *adapter, u16 action,
 			       u16 regnum, u16 bitnum, u8 *value)
@@ -437,108 +375,3 @@ void et131x_xcvr_init(struct et131x_adapter *adapter)
 	}
 }
 
-void et131x_mii_check(struct et131x_adapter *adapter,
-		      u16 bmsr, u16 bmsr_ints)
-{
-	struct phy_device *phydev = adapter->phydev;
-	u8 link_status;
-	u32 autoneg_status;
-	u32 speed;
-	u32 duplex;
-	u32 mdi_mdix;
-	u32 masterslave;
-	u32 polarity;
-
-	if (bmsr_ints & BMSR_LSTATUS) {
-		if (bmsr & BMSR_LSTATUS) {
-			adapter->boot_coma = 20;
-		} else {
-			dev_warn(&adapter->pdev->dev,
-			    "Link down - cable problem ?\n");
-
-			if (phydev && phydev->speed == SPEED_10) {
-				/* NOTE - Is there a way to query this without
-				 * TruePHY?
-				 * && TRU_QueryCoreType(adapter->hTruePhy, 0) ==
-				 * EMI_TRUEPHY_A13O) {
-				 */
-				u16 register18;
-
-				et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG,
-						 &register18);
-				et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,
-						 register18 | 0x4);
-				et131x_mii_write(adapter, PHY_INDEX_REG,
-						 register18 | 0x8402);
-				et131x_mii_write(adapter, PHY_DATA_REG,
-						 register18 | 511);
-				et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,
-						 register18);
-			}
-
-			/* Free the packets being actively sent & stopped */
-			et131x_free_busy_send_packets(adapter);
-
-			/* Re-initialize the send structures */
-			et131x_init_send(adapter);
-
-			/* Reset the RFD list and re-start RU */
-			et131x_reset_recv(adapter);
-
-			/*
-			 * Bring the device back to the state it was during
-			 * init prior to autonegotiation being complete. This
-			 * way, when we get the auto-neg complete interrupt,
-			 * we can complete init by calling config_mac_regs2.
-			 */
-			et131x_soft_reset(adapter);
-
-			/* Setup ET1310 as per the documentation */
-			et131x_adapter_setup(adapter);
-		}
-	}
-
-	if (bmsr_ints & BMSR_ANEGCOMPLETE) {
-		if (bmsr & BMSR_ANEGCOMPLETE) {
-			et1310_phy_link_status(adapter,
-					     &link_status, &autoneg_status,
-					     &speed, &duplex, &mdi_mdix,
-					     &masterslave, &polarity);
-
-			adapter->boot_coma = 20;
-
-			if (phydev && phydev->speed == SPEED_10) {
-				/*
-				 * NOTE - Is there a way to query this without
-				 * TruePHY?
-				 * && TRU_QueryCoreType(adapter->hTruePhy, 0)==
-				 * EMI_TRUEPHY_A13O) {
-				 */
-				u16 register18;
-
-				et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG,
-						 &register18);
-				et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,
-						 register18 | 0x4);
-				et131x_mii_write(adapter, PHY_INDEX_REG,
-						 register18 | 0x8402);
-				et131x_mii_write(adapter, PHY_DATA_REG,
-						 register18 | 511);
-				et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,
-						 register18);
-			}
-
-			et1310_config_flow_control(adapter);
-
-			if (phydev && phydev->speed == SPEED_1000 &&
-					adapter->registry_jumbo_packet > 2048)
-				et1310_phy_and_or_reg(adapter, PHY_CONFIG,
-						~ET_PHY_CONFIG_TX_FIFO_DEPTH,
-						ET_PHY_CONFIG_FIFO_DEPTH_32);
-
-			et131x_set_rx_dma_timer(adapter);
-			et1310_config_mac_regs2(adapter);
-		}
-	}
-}
-
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 799aad6..618f844 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -446,29 +446,110 @@ static void et131x_adjust_link(struct net_device *netdev)
 	struct address_map __iomem *iomem = adapter->regs;
 
 	u32 pm_csr;
-	u16 bmsr_ints;
-	u16 bmsr_data;
 
-	/* If we are in coma mode, we need to disable it. */
-	pm_csr = readl(&iomem->global.pm_csr);
-	if (pm_csr & ET_PM_PHY_SW_COMA) {
-		/*
-		 * Check to see if we are in coma mode and if
-		 * so, disable it because we will not be able
-		 * to read PHY values until we are out.
-		 */
-		et1310_disable_phy_coma(adapter);
+	if (netif_carrier_ok(netdev)) {
+		adapter->boot_coma = 20;
+
+		if (phydev && phydev->speed == SPEED_10) {
+			/*
+			 * NOTE - Is there a way to query this without
+			 * TruePHY?
+			 * && TRU_QueryCoreType(adapter->hTruePhy, 0)==
+			 * EMI_TRUEPHY_A13O) {
+			 */
+			u16 register18;
+
+			et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG,
+					 &register18);
+			et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,
+					 register18 | 0x4);
+			et131x_mii_write(adapter, PHY_INDEX_REG,
+					 register18 | 0x8402);
+			et131x_mii_write(adapter, PHY_DATA_REG,
+					 register18 | 511);
+			et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,
+					 register18);
+		}
+
+		et1310_config_flow_control(adapter);
+
+		if (phydev && phydev->speed == SPEED_1000 &&
+				adapter->registry_jumbo_packet > 2048) {
+			u16 reg;
+
+			et131x_mii_read(adapter, PHY_CONFIG, &reg);
+			reg &= ~ET_PHY_CONFIG_TX_FIFO_DEPTH;
+			reg |= ET_PHY_CONFIG_FIFO_DEPTH_32;
+			et131x_mii_write(adapter, PHY_CONFIG, reg);
+		}
+
+		et131x_set_rx_dma_timer(adapter);
+		et1310_config_mac_regs2(adapter);
 	}
 
-	et131x_phy_mii_read(adapter, phydev->addr, MII_BMSR, &bmsr_data);
+	if (phydev->link != adapter->link) {
+		/* If we are in coma mode, we need to disable it. */
+		pm_csr = readl(&iomem->global.pm_csr);
+		if (pm_csr & ET_PM_PHY_SW_COMA) {
+			/*
+			 * Check to see if we are in coma mode and if
+			 * so, disable it because we will not be able
+			 * to read PHY values until we are out.
+			 */
+			et1310_disable_phy_coma(adapter);
+		}
+
+		if (phydev->link) {
+			adapter->boot_coma = 20;
+		} else {
+			dev_warn(&adapter->pdev->dev,
+			    "Link down - cable problem ?\n");
+
+			if (phydev && phydev->speed == SPEED_10) {
+				/* NOTE - Is there a way to query this without
+				 * TruePHY?
+				 * && TRU_QueryCoreType(adapter->hTruePhy, 0) ==
+				 * EMI_TRUEPHY_A13O)
+				 */
+				u16 register18;
+
+				et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG,
+						 &register18);
+				et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,
+						 register18 | 0x4);
+				et131x_mii_write(adapter, PHY_INDEX_REG,
+						 register18 | 0x8402);
+				et131x_mii_write(adapter, PHY_DATA_REG,
+						 register18 | 511);
+				et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,
+						 register18);
+			}
+
+			/* Free the packets being actively sent & stopped */
+			et131x_free_busy_send_packets(adapter);
+
+			/* Re-initialize the send structures */
+			et131x_init_send(adapter);
 
-	bmsr_ints = adapter->bmsr ^ bmsr_data;
-	adapter->bmsr = bmsr_data;
+			/* Reset the RFD list and re-start RU */
+			et131x_reset_recv(adapter);
 
-	/* Do all the cable in / cable out stuff */
-	et131x_mii_check(adapter, bmsr_data, bmsr_ints);
+			/*
+			 * Bring the device back to the state it was during
+			 * init prior to autonegotiation being complete. This
+			 * way, when we get the auto-neg complete interrupt,
+			 * we can complete init by calling config_mac_regs2.
+			 */
+			et131x_soft_reset(adapter);
 
-	phy_print_status(phydev);
+			/* Setup ET1310 as per the documentation */
+			et131x_adapter_setup(adapter);
+		}
+
+		adapter->link = phydev->link;
+
+		phy_print_status(phydev);
+	}
 }
 
 int et131x_mii_probe(struct net_device *netdev)
-- 
1.7.6

