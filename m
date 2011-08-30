Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab1H3Lst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:48:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53808 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab1H3Lsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:48:45 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 3/3] staging: et131x: Remove redundant phy code
Date: Tue, 30 Aug 2011 12:47:24 +0100
Message-Id: <1314704844-5643-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314704844-5643-1-git-send-email-mark.einon@gmail.com>
References: <1314704844-5643-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we are using a phy_device, remove driver functionality that is now handled by the phydev.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.c     |  415 +------------------------------
 drivers/staging/et131x/et1310_pm.c      |   15 +-
 drivers/staging/et131x/et131x.h         |    7 +-
 drivers/staging/et131x/et131x_initpci.c |   30 +---
 4 files changed, 15 insertions(+), 452 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 9613846..c216bbb 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -122,7 +122,7 @@ int et131x_mdio_reset(struct mii_bus *bus)
 	struct net_device *netdev = bus->priv;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
-	et1310_phy_reset(adapter);
+	et131x_mii_write(adapter, PHY_CONTROL, 0x8000);
 
 	return 0;
 }
@@ -278,11 +278,6 @@ int et131x_mii_write(struct et131x_adapter *adapter, u8 reg, u16 value)
 	return status;
 }
 
-void et1310_phy_reset(struct et131x_adapter *adapter)
-{
-	et131x_mii_write(adapter, PHY_CONTROL, 0x8000);
-}
-
 /**
  *	et1310_phy_power_down	-	PHY power control
  *	@adapter: device to control
@@ -305,63 +300,6 @@ void et1310_phy_power_down(struct et131x_adapter *adapter, bool down)
 }
 
 /**
- *	et1310_phy_auto_neg	-	autonegotiate control
- *	@adapter: device to control
- *	@enabe: autoneg on/off
- *
- *	Set up the autonegotiation state according to whether we will be
- *	negotiating the state or forcing a speed.
- */
-static void et1310_phy_auto_neg(struct et131x_adapter *adapter, bool enable)
-{
-	u16 data;
-
-	et131x_mii_read(adapter, PHY_CONTROL, &data);
-	data &= ~0x1000;	/* Autonegotiation OFF */
-	if (enable)
-		data |= 0x1000;		/* Autonegotiation ON */
-	et131x_mii_write(adapter, PHY_CONTROL, data);
-}
-
-/**
- *	et1310_phy_duplex_mode	-	duplex control
- *	@adapter: device to control
- *	@duplex: duplex on/off
- *
- *	Set up the duplex state on the PHY
- */
-static void et1310_phy_duplex_mode(struct et131x_adapter *adapter, u16 duplex)
-{
-	u16 data;
-
-	et131x_mii_read(adapter, PHY_CONTROL, &data);
-	data &= ~0x100;		/* Set Half Duplex */
-	if (duplex == TRUEPHY_DUPLEX_FULL)
-		data |= 0x100;	/* Set Full Duplex */
-	et131x_mii_write(adapter, PHY_CONTROL, data);
-}
-
-/**
- *	et1310_phy_speed_select	-	speed control
- *	@adapter: device to control
- *	@duplex: duplex on/off
- *
- *	Set the speed of our PHY.
- */
-static void et1310_phy_speed_select(struct et131x_adapter *adapter, u16 speed)
-{
-	u16 data;
-	static const u16 bits[3] = {0x0000, 0x2000, 0x0040};
-
-	/* Read the PHY control register */
-	et131x_mii_read(adapter, PHY_CONTROL, &data);
-	/* Clear all Speed settings (Bits 6, 13) */
-	data &= ~0x2040;
-	/* Write back the new speed */
-	et131x_mii_write(adapter, PHY_CONTROL, data | bits[speed]);
-}
-
-/**
  *	et1310_phy_link_status	-	read link state
  *	@adapter: device to read
  *	@link_status: reported link state
@@ -450,122 +388,12 @@ void et1310_phy_access_mii_bit(struct et131x_adapter *adapter, u16 action,
 	}
 }
 
-void et1310_phy_advertise_1000BaseT(struct et131x_adapter *adapter,
-				  u16 duplex)
-{
-	u16 data;
-
-	/* Read the PHY 1000 Base-T Control Register */
-	et131x_mii_read(adapter, PHY_1000_CONTROL, &data);
-
-	/* Clear Bits 8,9 */
-	data &= ~0x0300;
-
-	switch (duplex) {
-	case TRUEPHY_ADV_DUPLEX_NONE:
-		/* Duplex already cleared, do nothing */
-		break;
-
-	case TRUEPHY_ADV_DUPLEX_FULL:
-		/* Set Bit 9 */
-		data |= 0x0200;
-		break;
-
-	case TRUEPHY_ADV_DUPLEX_HALF:
-		/* Set Bit 8 */
-		data |= 0x0100;
-		break;
-
-	case TRUEPHY_ADV_DUPLEX_BOTH:
-	default:
-		data |= 0x0300;
-		break;
-	}
-
-	/* Write back advertisement */
-	et131x_mii_write(adapter, PHY_1000_CONTROL, data);
-}
-
-static void et1310_phy_advertise_100BaseT(struct et131x_adapter *adapter,
-					  u16 duplex)
-{
-	u16 data;
-
-	/* Read the Autonegotiation Register (10/100) */
-	et131x_mii_read(adapter, PHY_AUTO_ADVERTISEMENT, &data);
-
-	/* Clear bits 7,8 */
-	data &= ~0x0180;
-
-	switch (duplex) {
-	case TRUEPHY_ADV_DUPLEX_NONE:
-		/* Duplex already cleared, do nothing */
-		break;
-
-	case TRUEPHY_ADV_DUPLEX_FULL:
-		/* Set Bit 8 */
-		data |= 0x0100;
-		break;
-
-	case TRUEPHY_ADV_DUPLEX_HALF:
-		/* Set Bit 7 */
-		data |= 0x0080;
-		break;
-
-	case TRUEPHY_ADV_DUPLEX_BOTH:
-	default:
-		/* Set Bits 7,8 */
-		data |= 0x0180;
-		break;
-	}
-
-	/* Write back advertisement */
-	et131x_mii_write(adapter, PHY_AUTO_ADVERTISEMENT, data);
-}
-
-static void et1310_phy_advertise_10BaseT(struct et131x_adapter *adapter,
-				u16 duplex)
-{
-	u16 data;
-
-	/* Read the Autonegotiation Register (10/100) */
-	et131x_mii_read(adapter, PHY_AUTO_ADVERTISEMENT, &data);
-
-	/* Clear bits 5,6 */
-	data &= ~0x0060;
-
-	switch (duplex) {
-	case TRUEPHY_ADV_DUPLEX_NONE:
-		/* Duplex already cleared, do nothing */
-		break;
-
-	case TRUEPHY_ADV_DUPLEX_FULL:
-		/* Set Bit 6 */
-		data |= 0x0040;
-		break;
-
-	case TRUEPHY_ADV_DUPLEX_HALF:
-		/* Set Bit 5 */
-		data |= 0x0020;
-		break;
-
-	case TRUEPHY_ADV_DUPLEX_BOTH:
-	default:
-		/* Set Bits 5,6 */
-		data |= 0x0060;
-		break;
-	}
-
-	/* Write back advertisement */
-	et131x_mii_write(adapter, PHY_AUTO_ADVERTISEMENT, data);
-}
-
 /**
  * et131x_xcvr_init - Init the phy if we are setting it into force mode
  * @adapter: pointer to our private adapter structure
  *
  */
-static void et131x_xcvr_init(struct et131x_adapter *adapter)
+void et131x_xcvr_init(struct et131x_adapter *adapter)
 {
 	u16 imr;
 	u16 isr;
@@ -607,132 +435,6 @@ static void et131x_xcvr_init(struct et131x_adapter *adapter)
 		et131x_mii_write(adapter, (u8) offsetof(struct mi_regs, lcr2),
 			lcr2);
 	}
-
-	/* Determine if we need to go into a force mode and set it */
-	if (adapter->ai_force_speed == 0 && adapter->ai_force_duplex == 0) {
-		if (adapter->wanted_flow == FLOW_TXONLY ||
-		    adapter->wanted_flow == FLOW_BOTH)
-			et1310_phy_access_mii_bit(adapter,
-					      TRUEPHY_BIT_SET, 4, 11, NULL);
-		else
-			et1310_phy_access_mii_bit(adapter,
-					      TRUEPHY_BIT_CLEAR, 4, 11, NULL);
-
-		if (adapter->wanted_flow == FLOW_BOTH)
-			et1310_phy_access_mii_bit(adapter,
-					      TRUEPHY_BIT_SET, 4, 10, NULL);
-		else
-			et1310_phy_access_mii_bit(adapter,
-					      TRUEPHY_BIT_CLEAR, 4, 10, NULL);
-
-		/* Set the phy to autonegotiation */
-		et1310_phy_auto_neg(adapter, true);
-
-		/* NOTE - Do we need this? */
-		et1310_phy_access_mii_bit(adapter, TRUEPHY_BIT_SET, 0, 9, NULL);
-		return;
-	}
-
-	et1310_phy_auto_neg(adapter, false);
-
-	/* Set to the correct force mode. */
-	if (adapter->ai_force_duplex != 1) {
-		if (adapter->wanted_flow == FLOW_TXONLY ||
-		    adapter->wanted_flow == FLOW_BOTH)
-			et1310_phy_access_mii_bit(adapter,
-				      TRUEPHY_BIT_SET, 4, 11, NULL);
-		else
-			et1310_phy_access_mii_bit(adapter,
-					      TRUEPHY_BIT_CLEAR, 4, 11, NULL);
-
-		if (adapter->wanted_flow == FLOW_BOTH)
-			et1310_phy_access_mii_bit(adapter,
-					      TRUEPHY_BIT_SET, 4, 10, NULL);
-		else
-			et1310_phy_access_mii_bit(adapter,
-					      TRUEPHY_BIT_CLEAR, 4, 10, NULL);
-	} else {
-		et1310_phy_access_mii_bit(adapter, TRUEPHY_BIT_CLEAR,
-					  4, 10, NULL);
-		et1310_phy_access_mii_bit(adapter, TRUEPHY_BIT_CLEAR,
-					  4, 11, NULL);
-	}
-	et1310_phy_power_down(adapter, 1);
-	switch (adapter->ai_force_speed) {
-	case 10:
-		/* First we need to turn off all other advertisement */
-		et1310_phy_advertise_1000BaseT(adapter, TRUEPHY_ADV_DUPLEX_NONE);
-		et1310_phy_advertise_100BaseT(adapter, TRUEPHY_ADV_DUPLEX_NONE);
-		if (adapter->ai_force_duplex == 1) {
-			/* Set our advertise values accordingly */
-			et1310_phy_advertise_10BaseT(adapter,
-						TRUEPHY_ADV_DUPLEX_HALF);
-		} else if (adapter->ai_force_duplex == 2) {
-			/* Set our advertise values accordingly */
-			et1310_phy_advertise_10BaseT(adapter,
-						TRUEPHY_ADV_DUPLEX_FULL);
-		} else {
-			/* Disable autoneg */
-			et1310_phy_auto_neg(adapter, false);
-			/* Disable rest of the advertisements */
-			et1310_phy_advertise_10BaseT(adapter,
-					TRUEPHY_ADV_DUPLEX_NONE);
-			/* Force 10 Mbps */
-			et1310_phy_speed_select(adapter, TRUEPHY_SPEED_10MBPS);
-			/* Force Full duplex */
-			et1310_phy_duplex_mode(adapter, TRUEPHY_DUPLEX_FULL);
-		}
-		break;
-	case 100:
-		/* first we need to turn off all other advertisement */
-		et1310_phy_advertise_1000BaseT(adapter, TRUEPHY_ADV_DUPLEX_NONE);
-		et1310_phy_advertise_10BaseT(adapter, TRUEPHY_ADV_DUPLEX_NONE);
-		if (adapter->ai_force_duplex == 1) {
-			/* Set our advertise values accordingly */
-			et1310_phy_advertise_100BaseT(adapter,
-						TRUEPHY_ADV_DUPLEX_HALF);
-			/* Set speed */
-			et1310_phy_speed_select(adapter, TRUEPHY_SPEED_100MBPS);
-		} else if (adapter->ai_force_duplex == 2) {
-			/* Set our advertise values accordingly */
-			et1310_phy_advertise_100BaseT(adapter,
-						TRUEPHY_ADV_DUPLEX_FULL);
-		} else {
-			/* Disable autoneg */
-			et1310_phy_auto_neg(adapter, false);
-			/* Disable other advertisement */
-			et1310_phy_advertise_100BaseT(adapter,
-						TRUEPHY_ADV_DUPLEX_NONE);
-			/* Force 100 Mbps */
-			et1310_phy_speed_select(adapter, TRUEPHY_SPEED_100MBPS);
-			/* Force Full duplex */
-			et1310_phy_duplex_mode(adapter, TRUEPHY_DUPLEX_FULL);
-		}
-		break;
-	case 1000:
-		/* first we need to turn off all other advertisement */
-		et1310_phy_advertise_100BaseT(adapter, TRUEPHY_ADV_DUPLEX_NONE);
-		et1310_phy_advertise_10BaseT(adapter, TRUEPHY_ADV_DUPLEX_NONE);
-		/* set our advertise values accordingly */
-		et1310_phy_advertise_1000BaseT(adapter, TRUEPHY_ADV_DUPLEX_FULL);
-		break;
-	}
-	et1310_phy_power_down(adapter, 0);
-}
-
-/**
- * et131x_setphy_normal - Set PHY for normal operation.
- * @adapter: pointer to our private adapter structure
- *
- * Used by Power Management to force the PHY into 10 Base T half-duplex mode,
- * when going to D3 in WOL mode. Also used during initialization to set the
- * PHY for normal operation.
- */
-void et131x_setphy_normal(struct et131x_adapter *adapter)
-{
-	/* Make sure the PHY is powered up */
-	et1310_phy_power_down(adapter, 0);
-	et131x_xcvr_init(adapter);
 }
 
 void et131x_mii_check(struct et131x_adapter *adapter,
@@ -847,116 +549,3 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 	}
 }
 
-/*
- * The routines which follow provide low-level access to the PHY, and are used
- * primarily by the routines above (although there are a few places elsewhere
- * in the driver where this level of access is required).
- */
-static const u16 config_phy[25][2] = {
-	/* Reg	 Value		Register */
-	/* Addr                         */
-	{0x880B, 0x0926},	/* AfeIfCreg4B1000Msbs */
-	{0x880C, 0x0926},	/* AfeIfCreg4B100Msbs */
-	{0x880D, 0x0926},	/* AfeIfCreg4B10Msbs */
-
-	{0x880E, 0xB4D3},	/* AfeIfCreg4B1000Lsbs */
-	{0x880F, 0xB4D3},	/* AfeIfCreg4B100Lsbs */
-	{0x8810, 0xB4D3},	/* AfeIfCreg4B10Lsbs */
-
-	{0x8805, 0xB03E},	/* AfeIfCreg3B1000Msbs */
-	{0x8806, 0xB03E},	/* AfeIfCreg3B100Msbs */
-	{0x8807, 0xFF00},	/* AfeIfCreg3B10Msbs */
-
-	{0x8808, 0xE090},	/* AfeIfCreg3B1000Lsbs */
-	{0x8809, 0xE110},	/* AfeIfCreg3B100Lsbs */
-	{0x880A, 0x0000},	/* AfeIfCreg3B10Lsbs */
-
-	{0x300D, 1},		/* DisableNorm */
-
-	{0x280C, 0x0180},	/* LinkHoldEnd */
-
-	{0x1C21, 0x0002},	/* AlphaM */
-
-	{0x3821, 6},		/* FfeLkgTx0 */
-	{0x381D, 1},		/* FfeLkg1g4 */
-	{0x381E, 1},		/* FfeLkg1g5 */
-	{0x381F, 1},		/* FfeLkg1g6 */
-	{0x3820, 1},		/* FfeLkg1g7 */
-
-	{0x8402, 0x01F0},	/* Btinact */
-	{0x800E, 20},		/* LftrainTime */
-	{0x800F, 24},		/* DvguardTime */
-	{0x8010, 46},		/* IdlguardTime */
-
-	{0, 0}
-};
-
-/* condensed version of the phy initialization routine */
-void et1310_phy_init(struct et131x_adapter *adapter)
-{
-	u16 data, index;
-
-	/* get the identity (again ?) */
-	et131x_mii_read(adapter, PHY_ID_1, &data);
-	et131x_mii_read(adapter, PHY_ID_2, &data);
-
-	/* what does this do/achieve ? */
-	/* should read 0002 */
-	et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG, &data);
-	et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,	0x0006);
-
-	/* read modem register 0402, should I do something with the return
-	   data ? */
-	et131x_mii_write(adapter, PHY_INDEX_REG, 0x0402);
-	et131x_mii_read(adapter, PHY_DATA_REG, &data);
-
-	/* what does this do/achieve ? */
-	et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG, 0x0002);
-
-	/* get the identity (again ?) */
-	et131x_mii_read(adapter, PHY_ID_1, &data);
-	et131x_mii_read(adapter, PHY_ID_2, &data);
-
-	/* what does this achieve ? */
-	/* should read 0002 */
-	et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG, &data);
-	et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG, 0x0006);
-
-	/* read modem register 0402, should I do something with
-	   the return data? */
-	et131x_mii_write(adapter, PHY_INDEX_REG, 0x0402);
-	et131x_mii_read(adapter, PHY_DATA_REG, &data);
-
-	et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG, 0x0002);
-
-	/* what does this achieve (should return 0x1040) */
-	et131x_mii_read(adapter, PHY_CONTROL, &data);
-	/* should read 0002 */
-	et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG, &data);
-	et131x_mii_write(adapter, PHY_CONTROL, 0x1840);
-
-	et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG, 0x0007);
-
-	/* here the writing of the array starts.... */
-	index = 0;
-	while (config_phy[index][0] != 0x0000) {
-		/* write value */
-		et131x_mii_write(adapter, PHY_INDEX_REG, config_phy[index][0]);
-		et131x_mii_write(adapter, PHY_DATA_REG, config_phy[index][1]);
-
-		/* read it back */
-		et131x_mii_write(adapter, PHY_INDEX_REG, config_phy[index][0]);
-		et131x_mii_read(adapter, PHY_DATA_REG, &data);
-
-		/* do a check on the value read back ? */
-		index++;
-	}
-	/* here the writing of the array ends... */
-
-	et131x_mii_read(adapter, PHY_CONTROL, &data);		/* 0x1840 */
-	/* should read 0007 */
-	et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG, &data);
-	et131x_mii_write(adapter, PHY_CONTROL, 0x1040);
-	et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG, 0x0002);
-}
-
diff --git a/drivers/staging/et131x/et1310_pm.c b/drivers/staging/et131x/et1310_pm.c
index 5ebf064..b20d5d6 100644
--- a/drivers/staging/et131x/et1310_pm.c
+++ b/drivers/staging/et131x/et1310_pm.c
@@ -116,8 +116,12 @@ void et1310_enable_phy_coma(struct et131x_adapter *adapter)
 	/* Save the GbE PHY speed and duplex modes. Need to restore this
 	 * when cable is plugged back in
 	 */
-	adapter->pdown_speed = adapter->ai_force_speed;
-	adapter->pdown_duplex = adapter->ai_force_duplex;
+	/*
+	 * TODO - when PM is re-enabled, check if we need to
+	 * perform a similar task as this -
+	 * adapter->pdown_speed = adapter->ai_force_speed;
+	 * adapter->pdown_duplex = adapter->ai_force_duplex;
+	 */
 
 	/* Stop sending packets. */
 	spin_lock_irqsave(&adapter->send_hw_lock, flags);
@@ -153,8 +157,11 @@ void et1310_disable_phy_coma(struct et131x_adapter *adapter)
 	/* Restore the GbE PHY speed and duplex modes;
 	 * Reset JAGCore; re-configure and initialize JAGCore and gigE PHY
 	 */
-	adapter->ai_force_speed = adapter->pdown_speed;
-	adapter->ai_force_duplex = adapter->pdown_duplex;
+	/* TODO - when PM is re-enabled, check if we need to
+	 * perform a similar task as this -
+	 * adapter->ai_force_speed = adapter->pdown_speed;
+	 * adapter->ai_force_duplex = adapter->pdown_duplex;
+	 */
 
 	/* Re-initialize the send structures */
 	et131x_init_send(adapter);
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index 763396a..f52fa18 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -89,17 +89,12 @@ void et1310_enable_phy_coma(struct et131x_adapter *adapter);
 void et1310_disable_phy_coma(struct et131x_adapter *adapter);
 
 /* et1310_phy.c */
-void et1310_phy_init(struct et131x_adapter *adapter);
-void et1310_phy_reset(struct et131x_adapter *adapter);
 void et1310_phy_power_down(struct et131x_adapter *adapter, bool down);
-void et1310_phy_advertise_1000BaseT(struct et131x_adapter *adapter,
-				    u16 duplex);
 void et1310_phy_access_mii_bit(struct et131x_adapter *adapter,
 			       u16 action,
 			       u16 regnum, u16 bitnum, u8 *value);
 
-int et131x_xcvr_find(struct et131x_adapter *adapter);
-void et131x_setphy_normal(struct et131x_adapter *adapter);
+void et131x_xcvr_init(struct et131x_adapter *adapter);
 
 /* static inline function does not work because et131x_adapter is not always
  * defined
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 66cf1ce..6ffebfa 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -137,7 +137,6 @@ void et131x_hwaddr_init(struct et131x_adapter *adapter)
 	}
 }
 
-
 /**
  * et131x_pci_init	 - initial PCI setup
  * @adapter: pointer to our private adapter structure
@@ -146,7 +145,6 @@ void et131x_hwaddr_init(struct et131x_adapter *adapter)
  * Perform the initial setup of PCI registers and if possible initialise
  * the MAC address. At this point the I/O registers have yet to be mapped
  */
-
 static int et131x_pci_init(struct et131x_adapter *adapter,
 						struct pci_dev *pdev)
 {
@@ -347,28 +345,8 @@ void et131x_adapter_setup(struct et131x_adapter *adapter)
 
 	et1310_config_macstat_regs(adapter);
 
-	/* Prepare the TRUEPHY library. */
-	et1310_phy_init(adapter);
-
-	/* Reset the phy now so changes take place */
-	et1310_phy_reset(adapter);
-
-	/* Power down PHY */
-	et1310_phy_power_down(adapter, 1);
-
-	/*
-	 * We need to turn off 1000 base half dulplex, the mac does not
-	 * support it. For the 10/100 part, turn off all gig advertisement
-	 */
-	if (adapter->pdev->device != ET131X_PCI_DEVICE_ID_FAST)
-		et1310_phy_advertise_1000BaseT(adapter, TRUEPHY_ADV_DUPLEX_FULL);
-	else
-		et1310_phy_advertise_1000BaseT(adapter, TRUEPHY_ADV_DUPLEX_NONE);
-
-	/* Power up PHY */
 	et1310_phy_power_down(adapter, 0);
-
-	et131x_setphy_normal(adapter);
+	et131x_xcvr_init(adapter);
 }
 
 /**
@@ -547,8 +525,6 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 		struct pci_dev *pdev)
 {
 	static const u8 default_mac[] = { 0x00, 0x05, 0x3d, 0x00, 0x02, 0x00 };
-	static const u8 duplex[] = { 0, 1, 2, 1, 2, 2 };
-	static const u16 speed[] = { 0, 10, 10, 100, 100, 1000 };
 
 	struct et131x_adapter *adapter;
 
@@ -571,15 +547,11 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 	spin_lock_init(&adapter->fbr_lock);
 	spin_lock_init(&adapter->phy_lock);
 
-	adapter->speed_duplex = 0; /* Auto Speed Auto Duplex */
 	adapter->registry_jumbo_packet = 1514;	/* 1514-9216 */
 
 	/* Set the MAC address to a default */
 	memcpy(adapter->addr, default_mac, ETH_ALEN);
 
-	adapter->ai_force_speed = speed[adapter->speed_duplex];
-	adapter->ai_force_duplex = duplex[adapter->speed_duplex];	/* Auto FDX */
-
 	return adapter;
 }
 
-- 
1.7.6

