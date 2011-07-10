Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab1GJPgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 11:36:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61774 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab1GJPgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 11:36:21 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 02/10] staging: et131x: Converting et1310_phy.c function and local names from CamelCase
Date: Sun, 10 Jul 2011 16:35:27 +0100
Message-Id: <1310312135-28407-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
References: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on an ET-131x device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_mac.c     |   10 +-
 drivers/staging/et131x/et1310_phy.c     |  402 +++++++++++++++----------------
 drivers/staging/et131x/et131x.h         |   35 ++--
 drivers/staging/et131x/et131x_initpci.c |   14 +-
 drivers/staging/et131x/et131x_isr.c     |    9 +-
 drivers/staging/et131x/et131x_netdev.c  |    4 +-
 6 files changed, 234 insertions(+), 240 deletions(-)

diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index db34c79..21b6153 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -451,11 +451,11 @@ void config_flow_control(struct et131x_adapter *etdev)
 	} else {
 		char remote_pause, remote_async_pause;
 
-		ET1310_PhyAccessMiBit(etdev,
-				      TRUEPHY_BIT_READ, 5, 10, &remote_pause);
-		ET1310_PhyAccessMiBit(etdev,
-				      TRUEPHY_BIT_READ, 5, 11,
-				      &remote_async_pause);
+		et1310_phy_access_mii_bit(etdev,
+				TRUEPHY_BIT_READ, 5, 10, &remote_pause);
+		et1310_phy_access_mii_bit(etdev,
+				TRUEPHY_BIT_READ, 5, 11,
+				&remote_async_pause);
 
 		if ((remote_pause == TRUEPHY_BIT_SET) &&
 		    (remote_async_pause == TRUEPHY_BIT_SET)) {
diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index d5b02a8..d53656b 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -93,39 +93,36 @@
 
 #include "et131x.h"
 
-/* Prototypes for functions with local scope */
-static void et131x_xcvr_init(struct et131x_adapter *etdev);
-
 /**
- * PhyMiRead - Read from the PHY through the MII Interface on the MAC
+ * et131x_phy_mii_read - Read from the PHY through the MII Interface on the MAC
  * @etdev: pointer to our private adapter structure
- * @xcvrAddr: the address of the transceiver
- * @xcvrReg: the register to read
+ * @xcvr_addr: the address of the transceiver
+ * @xcvr_reg: the register to read
  * @value: pointer to a 16-bit value in which the value will be stored
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-int PhyMiRead(struct et131x_adapter *etdev, u8 xcvrAddr,
-	      u8 xcvrReg, u16 *value)
+int et131x_phy_mii_read(struct et131x_adapter *etdev, u8 xcvr_addr,
+	      u8 xcvr_reg, u16 *value)
 {
 	struct mac_regs __iomem *mac = &etdev->regs->mac;
 	int status = 0;
 	u32 delay;
-	u32 miiAddr;
-	u32 miiCmd;
-	u32 miiIndicator;
+	u32 mii_addr;
+	u32 mii_cmd;
+	u32 mii_indicator;
 
 	/* Save a local copy of the registers we are dealing with so we can
 	 * set them back
 	 */
-	miiAddr = readl(&mac->mii_mgmt_addr);
-	miiCmd = readl(&mac->mii_mgmt_cmd);
+	mii_addr = readl(&mac->mii_mgmt_addr);
+	mii_cmd = readl(&mac->mii_mgmt_cmd);
 
 	/* Stop the current operation */
 	writel(0, &mac->mii_mgmt_cmd);
 
 	/* Set up the register we need to read from on the correct PHY */
-	writel(MII_ADDR(xcvrAddr, xcvrReg), &mac->mii_mgmt_addr);
+	writel(MII_ADDR(xcvr_addr, xcvr_reg), &mac->mii_mgmt_addr);
 
 	/* Kick the read cycle off */
 	delay = 0;
@@ -135,15 +132,15 @@ int PhyMiRead(struct et131x_adapter *etdev, u8 xcvrAddr,
 	do {
 		udelay(50);
 		delay++;
-		miiIndicator = readl(&mac->mii_mgmt_indicator);
-	} while ((miiIndicator & MGMT_WAIT) && delay < 50);
+		mii_indicator = readl(&mac->mii_mgmt_indicator);
+	} while ((mii_indicator & MGMT_WAIT) && delay < 50);
 
 	/* If we hit the max delay, we could not read the register */
 	if (delay == 50) {
 		dev_warn(&etdev->pdev->dev,
-			    "xcvrReg 0x%08x could not be read\n", xcvrReg);
+			    "xcvrReg 0x%08x could not be read\n", xcvr_reg);
 		dev_warn(&etdev->pdev->dev, "status is  0x%08x\n",
-			    miiIndicator);
+			    mii_indicator);
 
 		status = -EIO;
 	}
@@ -158,43 +155,43 @@ int PhyMiRead(struct et131x_adapter *etdev, u8 xcvrAddr,
 	/* set the registers we touched back to the state at which we entered
 	 * this function
 	 */
-	writel(miiAddr, &mac->mii_mgmt_addr);
-	writel(miiCmd, &mac->mii_mgmt_cmd);
+	writel(mii_addr, &mac->mii_mgmt_addr);
+	writel(mii_cmd, &mac->mii_mgmt_cmd);
 
 	return status;
 }
 
 /**
- * MiWrite - Write to a PHY register through the MII interface of the MAC
+ * et131x_mii_write - Write to a PHY register through the MII interface of the MAC
  * @etdev: pointer to our private adapter structure
- * @xcvrReg: the register to read
+ * @xcvr_reg: the register to read
  * @value: 16-bit value to write
  *
  * FIXME: one caller in netdev still
  *
  * Return 0 on success, errno on failure (as defined in errno.h)
  */
-int MiWrite(struct et131x_adapter *etdev, u8 xcvrReg, u16 value)
+int et131x_mii_write(struct et131x_adapter *etdev, u8 xcvr_reg, u16 value)
 {
 	struct mac_regs __iomem *mac = &etdev->regs->mac;
 	int status = 0;
-	u8 xcvrAddr = etdev->stats.xcvr_addr;
+	u8 xcvr_addr = etdev->stats.xcvr_addr;
 	u32 delay;
-	u32 miiAddr;
-	u32 miiCmd;
-	u32 miiIndicator;
+	u32 mii_addr;
+	u32 mii_cmd;
+	u32 mii_indicator;
 
 	/* Save a local copy of the registers we are dealing with so we can
 	 * set them back
 	 */
-	miiAddr = readl(&mac->mii_mgmt_addr);
-	miiCmd = readl(&mac->mii_mgmt_cmd);
+	mii_addr = readl(&mac->mii_mgmt_addr);
+	mii_cmd = readl(&mac->mii_mgmt_cmd);
 
 	/* Stop the current operation */
 	writel(0, &mac->mii_mgmt_cmd);
 
 	/* Set up the register we need to write to on the correct PHY */
-	writel(MII_ADDR(xcvrAddr, xcvrReg), &mac->mii_mgmt_addr);
+	writel(MII_ADDR(xcvr_addr, xcvr_reg), &mac->mii_mgmt_addr);
 
 	/* Add the value to write to the registers to the mac */
 	writel(value, &mac->mii_mgmt_ctrl);
@@ -203,32 +200,33 @@ int MiWrite(struct et131x_adapter *etdev, u8 xcvrReg, u16 value)
 	do {
 		udelay(50);
 		delay++;
-		miiIndicator = readl(&mac->mii_mgmt_indicator);
-	} while ((miiIndicator & MGMT_BUSY) && delay < 100);
+		mii_indicator = readl(&mac->mii_mgmt_indicator);
+	} while ((mii_indicator & MGMT_BUSY) && delay < 100);
 
 	/* If we hit the max delay, we could not write the register */
 	if (delay == 100) {
-		u16 TempValue;
+		u16 tmp;
 
 		dev_warn(&etdev->pdev->dev,
-		    "xcvrReg 0x%08x could not be written", xcvrReg);
+		    "xcvrReg 0x%08x could not be written", xcvr_reg);
 		dev_warn(&etdev->pdev->dev, "status is  0x%08x\n",
-			    miiIndicator);
+			    mii_indicator);
 		dev_warn(&etdev->pdev->dev, "command is  0x%08x\n",
 			    readl(&mac->mii_mgmt_cmd));
 
-		MiRead(etdev, xcvrReg, &TempValue);
+		et131x_mii_read(etdev, xcvr_reg, &tmp);
 
 		status = -EIO;
 	}
 	/* Stop the write operation */
 	writel(0, &mac->mii_mgmt_cmd);
 
-	/* set the registers we touched back to the state at which we entered
+	/*
+	 * set the registers we touched back to the state at which we entered
 	 * this function
 	 */
-	writel(miiAddr, &mac->mii_mgmt_addr);
-	writel(miiCmd, &mac->mii_mgmt_cmd);
+	writel(mii_addr, &mac->mii_mgmt_addr);
+	writel(mii_cmd, &mac->mii_mgmt_cmd);
 
 	return status;
 }
@@ -249,12 +247,12 @@ int et131x_xcvr_find(struct et131x_adapter *etdev)
 	/* We need to get xcvr id and address we just get the first one */
 	for (xcvr_addr = 0; xcvr_addr < 32; xcvr_addr++) {
 		/* Read the ID from the PHY */
-		PhyMiRead(etdev, xcvr_addr,
-			  (u8) offsetof(struct mi_regs, idr1),
-			  &idr1);
-		PhyMiRead(etdev, xcvr_addr,
-			  (u8) offsetof(struct mi_regs, idr2),
-			  &idr2);
+		et131x_phy_mii_read(etdev, xcvr_addr,
+			     (u8) offsetof(struct mi_regs, idr1),
+			     &idr1);
+		et131x_phy_mii_read(etdev, xcvr_addr,
+			     (u8) offsetof(struct mi_regs, idr2),
+			     &idr2);
 
 		xcvr_id = (u32) ((idr1 << 16) | idr2);
 
@@ -267,13 +265,13 @@ int et131x_xcvr_find(struct et131x_adapter *etdev)
 	return -ENODEV;
 }
 
-void ET1310_PhyReset(struct et131x_adapter *etdev)
+void et1310_phy_reset(struct et131x_adapter *etdev)
 {
-	MiWrite(etdev, PHY_CONTROL, 0x8000);
+	et131x_mii_write(etdev, PHY_CONTROL, 0x8000);
 }
 
 /**
- *	ET1310_PhyPowerDown	-	PHY power control
+ *	et1310_phy_power_down	-	PHY power control
  *	@etdev: device to control
  *	@down: true for off/false for back on
  *
@@ -282,80 +280,76 @@ void ET1310_PhyReset(struct et131x_adapter *etdev)
  *	Can't you see that this code processed
  *	Phy power, phy power..
  */
-
-void ET1310_PhyPowerDown(struct et131x_adapter *etdev, bool down)
+void et1310_phy_power_down(struct et131x_adapter *etdev, bool down)
 {
 	u16 data;
 
-	MiRead(etdev, PHY_CONTROL, &data);
+	et131x_mii_read(etdev, PHY_CONTROL, &data);
 	data &= ~0x0800;	/* Power UP */
 	if (down) /* Power DOWN */
 		data |= 0x0800;
-	MiWrite(etdev, PHY_CONTROL, data);
+	et131x_mii_write(etdev, PHY_CONTROL, data);
 }
 
 /**
- *	ET130_PhyAutoNEg	-	autonegotiate control
+ *	et1310_phy_auto_neg	-	autonegotiate control
  *	@etdev: device to control
  *	@enabe: autoneg on/off
  *
  *	Set up the autonegotiation state according to whether we will be
  *	negotiating the state or forcing a speed.
  */
-
-static void ET1310_PhyAutoNeg(struct et131x_adapter *etdev, bool enable)
+static void et1310_phy_auto_neg(struct et131x_adapter *etdev, bool enable)
 {
 	u16 data;
 
-	MiRead(etdev, PHY_CONTROL, &data);
+	et131x_mii_read(etdev, PHY_CONTROL, &data);
 	data &= ~0x1000;	/* Autonegotiation OFF */
 	if (enable)
 		data |= 0x1000;		/* Autonegotiation ON */
-	MiWrite(etdev, PHY_CONTROL, data);
+	et131x_mii_write(etdev, PHY_CONTROL, data);
 }
 
 /**
- *	ET130_PhyDuplexMode	-	duplex control
+ *	et1310_phy_duplex_mode	-	duplex control
  *	@etdev: device to control
  *	@duplex: duplex on/off
  *
  *	Set up the duplex state on the PHY
  */
-
-static void ET1310_PhyDuplexMode(struct et131x_adapter *etdev, u16 duplex)
+static void et1310_phy_duplex_mode(struct et131x_adapter *etdev, u16 duplex)
 {
 	u16 data;
 
-	MiRead(etdev, PHY_CONTROL, &data);
+	et131x_mii_read(etdev, PHY_CONTROL, &data);
 	data &= ~0x100;		/* Set Half Duplex */
 	if (duplex == TRUEPHY_DUPLEX_FULL)
 		data |= 0x100;	/* Set Full Duplex */
-	MiWrite(etdev, PHY_CONTROL, data);
+	et131x_mii_write(etdev, PHY_CONTROL, data);
 }
 
 /**
- *	ET130_PhySpeedSelect	-	speed control
+ *	et1310_phy_speed_select	-	speed control
  *	@etdev: device to control
  *	@duplex: duplex on/off
  *
  *	Set the speed of our PHY.
  */
-
-static void ET1310_PhySpeedSelect(struct et131x_adapter *etdev, u16 speed)
+static void et1310_phy_speed_select(struct et131x_adapter *etdev, u16 speed)
 {
 	u16 data;
 	static const u16 bits[3] = {0x0000, 0x2000, 0x0040};
 
 	/* Read the PHY control register */
-	MiRead(etdev, PHY_CONTROL, &data);
+	et131x_mii_read(etdev, PHY_CONTROL, &data);
 	/* Clear all Speed settings (Bits 6, 13) */
 	data &= ~0x2040;
 	/* Write back the new speed */
-	MiWrite(etdev, PHY_CONTROL, data | bits[speed]);
+	et131x_mii_write(etdev, PHY_CONTROL, data | bits[speed]);
 }
 
 /**
- *	ET1310_PhyLinkStatus	-	read link state
+ *	et1310_phy_link_status	-	read link state
  *	@etdev: device to read
  *	@link_status: reported link state
  *	@autoneg: reported autonegotiation state (complete/incomplete/disabled)
@@ -370,8 +364,7 @@ static void ET1310_PhySpeedSelect(struct et131x_adapter *etdev, u16 speed)
  *	I know your link speed
  *	I see all the setting that you'd rather keep
  */
-
-static void ET1310_PhyLinkStatus(struct et131x_adapter *etdev,
+static void et1310_phy_link_status(struct et131x_adapter *etdev,
 			  u8 *link_status,
 			  u32 *autoneg,
 			  u32 *linkspeed,
@@ -384,10 +377,10 @@ static void ET1310_PhyLinkStatus(struct et131x_adapter *etdev,
 	u16 vmi_phystatus = 0;
 	u16 control = 0;
 
-	MiRead(etdev, PHY_STATUS, &mistatus);
-	MiRead(etdev, PHY_1000_STATUS, &is1000BaseT);
-	MiRead(etdev, PHY_PHY_STATUS, &vmi_phystatus);
-	MiRead(etdev, PHY_CONTROL, &control);
+	et131x_mii_read(etdev, PHY_STATUS, &mistatus);
+	et131x_mii_read(etdev, PHY_1000_STATUS, &is1000BaseT);
+	et131x_mii_read(etdev, PHY_PHY_STATUS, &vmi_phystatus);
+	et131x_mii_read(etdev, PHY_CONTROL, &control);
 
 	*link_status = (vmi_phystatus & 0x0040) ? 1 : 0;
 	*autoneg = (control & 0x1000) ? ((vmi_phystatus & 0x0020) ?
@@ -405,26 +398,26 @@ static void ET1310_PhyLinkStatus(struct et131x_adapter *etdev,
 			TRUEPHY_POLARITY_INVERTED : TRUEPHY_POLARITY_NORMAL;
 }
 
-static void ET1310_PhyAndOrReg(struct et131x_adapter *etdev,
-			u16 regnum, u16 andMask, u16 orMask)
+static void et1310_phy_and_or_reg(struct et131x_adapter *etdev,
+				  u16 regnum, u16 and_mask, u16 or_mask)
 {
 	u16 reg;
 
-	MiRead(etdev, regnum, &reg);
-	reg &= andMask;
-	reg |= orMask;
-	MiWrite(etdev, regnum, reg);
+	et131x_mii_read(etdev, regnum, &reg);
+	reg &= and_mask;
+	reg |= or_mask;
+	et131x_mii_write(etdev, regnum, reg);
 }
 
-/* Still used from _mac  for BIT_READ */
-void ET1310_PhyAccessMiBit(struct et131x_adapter *etdev, u16 action,
-			   u16 regnum, u16 bitnum, u8 *value)
+/* Still used from _mac for BIT_READ */
+void et1310_phy_access_mii_bit(struct et131x_adapter *etdev, u16 action,
+			       u16 regnum, u16 bitnum, u8 *value)
 {
 	u16 reg;
 	u16 mask = 0x0001 << bitnum;
 
 	/* Read the requested register */
-	MiRead(etdev, regnum, &reg);
+	et131x_mii_read(etdev, regnum, &reg);
 
 	switch (action) {
 	case TRUEPHY_BIT_READ:
@@ -432,11 +425,11 @@ void ET1310_PhyAccessMiBit(struct et131x_adapter *etdev, u16 action,
 		break;
 
 	case TRUEPHY_BIT_SET:
-		MiWrite(etdev, regnum, reg | mask);
+		et131x_mii_write(etdev, regnum, reg | mask);
 		break;
 
 	case TRUEPHY_BIT_CLEAR:
-		MiWrite(etdev, regnum, reg & ~mask);
+		et131x_mii_write(etdev, regnum, reg & ~mask);
 		break;
 
 	default:
@@ -444,13 +437,13 @@ void ET1310_PhyAccessMiBit(struct et131x_adapter *etdev, u16 action,
 	}
 }
 
-void ET1310_PhyAdvertise1000BaseT(struct et131x_adapter *etdev,
+void et1310_phy_advertise_1000BaseT(struct et131x_adapter *etdev,
 				  u16 duplex)
 {
 	u16 data;
 
 	/* Read the PHY 1000 Base-T Control Register */
-	MiRead(etdev, PHY_1000_CONTROL, &data);
+	et131x_mii_read(etdev, PHY_1000_CONTROL, &data);
 
 	/* Clear Bits 8,9 */
 	data &= ~0x0300;
@@ -477,16 +470,16 @@ void ET1310_PhyAdvertise1000BaseT(struct et131x_adapter *etdev,
 	}
 
 	/* Write back advertisement */
-	MiWrite(etdev, PHY_1000_CONTROL, data);
+	et131x_mii_write(etdev, PHY_1000_CONTROL, data);
 }
 
-static void ET1310_PhyAdvertise100BaseT(struct et131x_adapter *etdev,
-				 u16 duplex)
+static void et1310_phy_advertise_100BaseT(struct et131x_adapter *etdev,
+					  u16 duplex)
 {
 	u16 data;
 
 	/* Read the Autonegotiation Register (10/100) */
-	MiRead(etdev, PHY_AUTO_ADVERTISEMENT, &data);
+	et131x_mii_read(etdev, PHY_AUTO_ADVERTISEMENT, &data);
 
 	/* Clear bits 7,8 */
 	data &= ~0x0180;
@@ -514,16 +507,16 @@ static void ET1310_PhyAdvertise100BaseT(struct et131x_adapter *etdev,
 	}
 
 	/* Write back advertisement */
-	MiWrite(etdev, PHY_AUTO_ADVERTISEMENT, data);
+	et131x_mii_write(etdev, PHY_AUTO_ADVERTISEMENT, data);
 }
 
-static void ET1310_PhyAdvertise10BaseT(struct et131x_adapter *etdev,
+static void et1310_phy_advertise_10BaseT(struct et131x_adapter *etdev,
 				u16 duplex)
 {
 	u16 data;
 
 	/* Read the Autonegotiation Register (10/100) */
-	MiRead(etdev, PHY_AUTO_ADVERTISEMENT, &data);
+	et131x_mii_read(etdev, PHY_AUTO_ADVERTISEMENT, &data);
 
 	/* Clear bits 5,6 */
 	data &= ~0x0060;
@@ -551,25 +544,9 @@ static void ET1310_PhyAdvertise10BaseT(struct et131x_adapter *etdev,
 	}
 
 	/* Write back advertisement */
-	MiWrite(etdev, PHY_AUTO_ADVERTISEMENT, data);
-}
-
-/**
- * et131x_setphy_normal - Set PHY for normal operation.
- * @etdev: pointer to our private adapter structure
- *
- * Used by Power Management to force the PHY into 10 Base T half-duplex mode,
- * when going to D3 in WOL mode. Also used during initialization to set the
- * PHY for normal operation.
- */
-void et131x_setphy_normal(struct et131x_adapter *etdev)
-{
-	/* Make sure the PHY is powered up */
-	ET1310_PhyPowerDown(etdev, 0);
-	et131x_xcvr_init(etdev);
+	et131x_mii_write(etdev, PHY_AUTO_ADVERTISEMENT, data);
 }
 
-
 /**
  * et131x_xcvr_init - Init the phy if we are setting it into force mode
  * @etdev: pointer to our private adapter structure
@@ -584,15 +561,15 @@ static void et131x_xcvr_init(struct et131x_adapter *etdev)
 	/* Zero out the adapter structure variable representing BMSR */
 	etdev->bmsr = 0;
 
-	MiRead(etdev, (u8) offsetof(struct mi_regs, isr), &isr);
-	MiRead(etdev, (u8) offsetof(struct mi_regs, imr), &imr);
+	et131x_mii_read(etdev, (u8) offsetof(struct mi_regs, isr), &isr);
+	et131x_mii_read(etdev, (u8) offsetof(struct mi_regs, imr), &imr);
 
 	/* Set the link status interrupt only.  Bad behavior when link status
 	 * and auto neg are set, we run into a nested interrupt problem
 	 */
 	imr |= 0x0105;
 
-	MiWrite(etdev, (u8) offsetof(struct mi_regs, imr), imr);
+	et131x_mii_write(etdev, (u8) offsetof(struct mi_regs, imr), imr);
 
 	/* Set the LED behavior such that LED 1 indicates speed (off =
 	 * 10Mbits, blink = 100Mbits, on = 1000Mbits) and LED 2 indicates
@@ -603,7 +580,7 @@ static void et131x_xcvr_init(struct et131x_adapter *etdev)
 	 * EEPROM. However, the above description is the default.
 	 */
 	if ((etdev->eeprom_data[1] & 0x4) == 0) {
-		MiRead(etdev, (u8) offsetof(struct mi_regs, lcr2),
+		et131x_mii_read(etdev, (u8) offsetof(struct mi_regs, lcr2),
 		       &lcr2);
 
 		lcr2 &= 0x00FF;
@@ -614,7 +591,7 @@ static void et131x_xcvr_init(struct et131x_adapter *etdev)
 		else
 			lcr2 |= 0x0400;
 
-		MiWrite(etdev, (u8) offsetof(struct mi_regs, lcr2),
+		et131x_mii_write(etdev, (u8) offsetof(struct mi_regs, lcr2),
 			lcr2);
 	}
 
@@ -622,113 +599,130 @@ static void et131x_xcvr_init(struct et131x_adapter *etdev)
 	if (etdev->AiForceSpeed == 0 && etdev->AiForceDpx == 0) {
 		if (etdev->wanted_flow == FLOW_TXONLY ||
 		    etdev->wanted_flow == FLOW_BOTH)
-			ET1310_PhyAccessMiBit(etdev,
+			et1310_phy_access_mii_bit(etdev,
 					      TRUEPHY_BIT_SET, 4, 11, NULL);
 		else
-			ET1310_PhyAccessMiBit(etdev,
+			et1310_phy_access_mii_bit(etdev,
 					      TRUEPHY_BIT_CLEAR, 4, 11, NULL);
 
 		if (etdev->wanted_flow == FLOW_BOTH)
-			ET1310_PhyAccessMiBit(etdev,
+			et1310_phy_access_mii_bit(etdev,
 					      TRUEPHY_BIT_SET, 4, 10, NULL);
 		else
-			ET1310_PhyAccessMiBit(etdev,
+			et1310_phy_access_mii_bit(etdev,
 					      TRUEPHY_BIT_CLEAR, 4, 10, NULL);
 
 		/* Set the phy to autonegotiation */
-		ET1310_PhyAutoNeg(etdev, true);
+		et1310_phy_auto_neg(etdev, true);
 
 		/* NOTE - Do we need this? */
-		ET1310_PhyAccessMiBit(etdev, TRUEPHY_BIT_SET, 0, 9, NULL);
+		et1310_phy_access_mii_bit(etdev, TRUEPHY_BIT_SET, 0, 9, NULL);
 		return;
 	}
 
-	ET1310_PhyAutoNeg(etdev, false);
+	et1310_phy_auto_neg(etdev, false);
 
 	/* Set to the correct force mode. */
 	if (etdev->AiForceDpx != 1) {
 		if (etdev->wanted_flow == FLOW_TXONLY ||
 		    etdev->wanted_flow == FLOW_BOTH)
-			ET1310_PhyAccessMiBit(etdev,
+			et1310_phy_access_mii_bit(etdev,
 				      TRUEPHY_BIT_SET, 4, 11, NULL);
 		else
-			ET1310_PhyAccessMiBit(etdev,
+			et1310_phy_access_mii_bit(etdev,
 					      TRUEPHY_BIT_CLEAR, 4, 11, NULL);
 
 		if (etdev->wanted_flow == FLOW_BOTH)
-			ET1310_PhyAccessMiBit(etdev,
+			et1310_phy_access_mii_bit(etdev,
 					      TRUEPHY_BIT_SET, 4, 10, NULL);
 		else
-			ET1310_PhyAccessMiBit(etdev,
+			et1310_phy_access_mii_bit(etdev,
 					      TRUEPHY_BIT_CLEAR, 4, 10, NULL);
 	} else {
-		ET1310_PhyAccessMiBit(etdev, TRUEPHY_BIT_CLEAR, 4, 10, NULL);
-		ET1310_PhyAccessMiBit(etdev, TRUEPHY_BIT_CLEAR, 4, 11, NULL);
+		et1310_phy_access_mii_bit(etdev, TRUEPHY_BIT_CLEAR,
+					  4, 10, NULL);
+		et1310_phy_access_mii_bit(etdev, TRUEPHY_BIT_CLEAR,
+					  4, 11, NULL);
 	}
-	ET1310_PhyPowerDown(etdev, 1);
+	et1310_phy_power_down(etdev, 1);
 	switch (etdev->AiForceSpeed) {
 	case 10:
 		/* First we need to turn off all other advertisement */
-		ET1310_PhyAdvertise1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
-		ET1310_PhyAdvertise100BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
+		et1310_phy_advertise_1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
+		et1310_phy_advertise_100BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
 		if (etdev->AiForceDpx == 1) {
 			/* Set our advertise values accordingly */
-			ET1310_PhyAdvertise10BaseT(etdev,
+			et1310_phy_advertise_10BaseT(etdev,
 						TRUEPHY_ADV_DUPLEX_HALF);
 		} else if (etdev->AiForceDpx == 2) {
 			/* Set our advertise values accordingly */
-			ET1310_PhyAdvertise10BaseT(etdev,
+			et1310_phy_advertise_10BaseT(etdev,
 						TRUEPHY_ADV_DUPLEX_FULL);
 		} else {
 			/* Disable autoneg */
-			ET1310_PhyAutoNeg(etdev, false);
+			et1310_phy_auto_neg(etdev, false);
 			/* Disable rest of the advertisements */
-			ET1310_PhyAdvertise10BaseT(etdev,
+			et1310_phy_advertise_10BaseT(etdev,
 					TRUEPHY_ADV_DUPLEX_NONE);
 			/* Force 10 Mbps */
-			ET1310_PhySpeedSelect(etdev, TRUEPHY_SPEED_10MBPS);
+			et1310_phy_speed_select(etdev, TRUEPHY_SPEED_10MBPS);
 			/* Force Full duplex */
-			ET1310_PhyDuplexMode(etdev, TRUEPHY_DUPLEX_FULL);
+			et1310_phy_duplex_mode(etdev, TRUEPHY_DUPLEX_FULL);
 		}
 		break;
 	case 100:
 		/* first we need to turn off all other advertisement */
-		ET1310_PhyAdvertise1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
-		ET1310_PhyAdvertise10BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
+		et1310_phy_advertise_1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
+		et1310_phy_advertise_10BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
 		if (etdev->AiForceDpx == 1) {
 			/* Set our advertise values accordingly */
-			ET1310_PhyAdvertise100BaseT(etdev,
+			et1310_phy_advertise_100BaseT(etdev,
 						TRUEPHY_ADV_DUPLEX_HALF);
 			/* Set speed */
-			ET1310_PhySpeedSelect(etdev, TRUEPHY_SPEED_100MBPS);
+			et1310_phy_speed_select(etdev, TRUEPHY_SPEED_100MBPS);
 		} else if (etdev->AiForceDpx == 2) {
 			/* Set our advertise values accordingly */
-			ET1310_PhyAdvertise100BaseT(etdev,
+			et1310_phy_advertise_100BaseT(etdev,
 						TRUEPHY_ADV_DUPLEX_FULL);
 		} else {
 			/* Disable autoneg */
-			ET1310_PhyAutoNeg(etdev, false);
+			et1310_phy_auto_neg(etdev, false);
 			/* Disable other advertisement */
-			ET1310_PhyAdvertise100BaseT(etdev,
+			et1310_phy_advertise_100BaseT(etdev,
 						TRUEPHY_ADV_DUPLEX_NONE);
 			/* Force 100 Mbps */
-			ET1310_PhySpeedSelect(etdev, TRUEPHY_SPEED_100MBPS);
+			et1310_phy_speed_select(etdev, TRUEPHY_SPEED_100MBPS);
 			/* Force Full duplex */
-			ET1310_PhyDuplexMode(etdev, TRUEPHY_DUPLEX_FULL);
+			et1310_phy_duplex_mode(etdev, TRUEPHY_DUPLEX_FULL);
 		}
 		break;
 	case 1000:
 		/* first we need to turn off all other advertisement */
-		ET1310_PhyAdvertise100BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
-		ET1310_PhyAdvertise10BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
+		et1310_phy_advertise_100BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
+		et1310_phy_advertise_10BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
 		/* set our advertise values accordingly */
-		ET1310_PhyAdvertise1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_FULL);
+		et1310_phy_advertise_1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_FULL);
 		break;
 	}
-	ET1310_PhyPowerDown(etdev, 0);
+	et1310_phy_power_down(etdev, 0);
+}
+
+/**
+ * et131x_setphy_normal - Set PHY for normal operation.
+ * @etdev: pointer to our private adapter structure
+ *
+ * Used by Power Management to force the PHY into 10 Base T half-duplex mode,
+ * when going to D3 in WOL mode. Also used during initialization to set the
+ * PHY for normal operation.
+ */
+void et131x_setphy_normal(struct et131x_adapter *etdev)
+{
+	/* Make sure the PHY is powered up */
+	et1310_phy_power_down(etdev, 0);
+	et131x_xcvr_init(etdev);
 }
 
-void et131x_Mii_check(struct et131x_adapter *etdev,
+void et131x_mii_check(struct et131x_adapter *etdev,
 		      u16 bmsr, u16 bmsr_ints)
 {
 	u8 link_status;
@@ -764,13 +758,14 @@ void et131x_Mii_check(struct et131x_adapter *etdev,
 				 * && TRU_QueryCoreType(etdev->hTruePhy, 0) ==
 				 * EMI_TRUEPHY_A13O) {
 				 */
-				u16 Register18;
-
-				MiRead(etdev, 0x12, &Register18);
-				MiWrite(etdev, 0x12, Register18 | 0x4);
-				MiWrite(etdev, 0x10, Register18 | 0x8402);
-				MiWrite(etdev, 0x11, Register18 | 511);
-				MiWrite(etdev, 0x12, Register18);
+				u16 register18;
+
+				et131x_mii_read(etdev, 0x12, &register18);
+				et131x_mii_write(etdev, 0x12, register18 | 0x4);
+				et131x_mii_write(etdev, 0x10,
+						 register18 | 0x8402);
+				et131x_mii_write(etdev, 0x11, register18 | 511);
+				et131x_mii_write(etdev, 0x12, register18);
 			}
 
 			/* For the first N seconds of life, we are in "link
@@ -805,7 +800,7 @@ void et131x_Mii_check(struct et131x_adapter *etdev,
 			 * Bring the device back to the state it was during
 			 * init prior to autonegotiation being complete. This
 			 * way, when we get the auto-neg complete interrupt,
-			 * we can complete init by calling ConfigMacREGS2.
+			 * we can complete init by calling config_mac_regs2.
 			 */
 			et131x_soft_reset(etdev);
 
@@ -824,7 +819,7 @@ void et131x_Mii_check(struct et131x_adapter *etdev,
 	    (etdev->AiForceDpx == 3 && (bmsr_ints & MI_BMSR_LINK_STATUS))) {
 		if ((bmsr & MI_BMSR_AUTO_NEG_COMPLETE) ||
 		    etdev->AiForceDpx == 3) {
-			ET1310_PhyLinkStatus(etdev,
+			et1310_phy_link_status(etdev,
 					     &link_status, &autoneg_status,
 					     &speed, &duplex, &mdi_mdix,
 					     &masterslave, &polarity);
@@ -841,20 +836,21 @@ void et131x_Mii_check(struct et131x_adapter *etdev,
 				 * && TRU_QueryCoreType(etdev->hTruePhy, 0)==
 				 * EMI_TRUEPHY_A13O) {
 				 */
-				u16 Register18;
-
-				MiRead(etdev, 0x12, &Register18);
-				MiWrite(etdev, 0x12, Register18 | 0x4);
-				MiWrite(etdev, 0x10, Register18 | 0x8402);
-				MiWrite(etdev, 0x11, Register18 | 511);
-				MiWrite(etdev, 0x12, Register18);
+				u16 register18;
+
+				et131x_mii_read(etdev, 0x12, &register18);
+				et131x_mii_write(etdev, 0x12, register18 | 0x4);
+				et131x_mii_write(etdev, 0x10,
+						 register18 | 0x8402);
+				et131x_mii_write(etdev, 0x11, register18 | 511);
+				et131x_mii_write(etdev, 0x12, register18);
 			}
 
 			config_flow_control(etdev);
 
 			if (etdev->linkspeed == TRUEPHY_SPEED_1000MBPS &&
 					etdev->RegistryJumboPacket > 2048)
-				ET1310_PhyAndOrReg(etdev, 0x16, 0xcfff,
+				et1310_phy_and_or_reg(etdev, 0x16, 0xcfff,
 								   0x2000);
 
 			SetRxDmaTimer(etdev);
@@ -868,9 +864,8 @@ void et131x_Mii_check(struct et131x_adapter *etdev,
  * primarily by the routines above (although there are a few places elsewhere
  * in the driver where this level of access is required).
  */
-
-static const u16 ConfigPhy[25][2] = {
-	/* Reg      Value      Register */
+static const u16 config_phy[25][2] = {
+	/* Reg	 Value		Register */
 	/* Addr                         */
 	{0x880B, 0x0926},	/* AfeIfCreg4B1000Msbs */
 	{0x880C, 0x0926},	/* AfeIfCreg4B100Msbs */
@@ -906,11 +901,10 @@ static const u16 ConfigPhy[25][2] = {
 	{0x8010, 46},		/* IdlguardTime */
 
 	{0, 0}
-
 };
 
 /* condensed version of the phy initialization routine */
-void ET1310_PhyInit(struct et131x_adapter *etdev)
+void et1310_phy_init(struct et131x_adapter *etdev)
 {
 	u16 data, index;
 
@@ -918,62 +912,66 @@ void ET1310_PhyInit(struct et131x_adapter *etdev)
 		return;
 
 	/* get the identity (again ?) */
-	MiRead(etdev, PHY_ID_1, &data);
-	MiRead(etdev, PHY_ID_2, &data);
+	et131x_mii_read(etdev, PHY_ID_1, &data);
+	et131x_mii_read(etdev, PHY_ID_2, &data);
 
 	/* what does this do/achieve ? */
-	MiRead(etdev, PHY_MPHY_CONTROL_REG, &data); /* should read 0002 */
-	MiWrite(etdev, PHY_MPHY_CONTROL_REG,	0x0006);
+	/* should read 0002 */
+	et131x_mii_read(etdev, PHY_MPHY_CONTROL_REG, &data);
+	et131x_mii_write(etdev, PHY_MPHY_CONTROL_REG,	0x0006);
 
 	/* read modem register 0402, should I do something with the return
 	   data ? */
-	MiWrite(etdev, PHY_INDEX_REG, 0x0402);
-	MiRead(etdev, PHY_DATA_REG, &data);
+	et131x_mii_write(etdev, PHY_INDEX_REG, 0x0402);
+	et131x_mii_read(etdev, PHY_DATA_REG, &data);
 
 	/* what does this do/achieve ? */
-	MiWrite(etdev, PHY_MPHY_CONTROL_REG, 0x0002);
+	et131x_mii_write(etdev, PHY_MPHY_CONTROL_REG, 0x0002);
 
 	/* get the identity (again ?) */
-	MiRead(etdev, PHY_ID_1, &data);
-	MiRead(etdev, PHY_ID_2, &data);
+	et131x_mii_read(etdev, PHY_ID_1, &data);
+	et131x_mii_read(etdev, PHY_ID_2, &data);
 
 	/* what does this achieve ? */
-	MiRead(etdev, PHY_MPHY_CONTROL_REG, &data); /* should read 0002 */
-	MiWrite(etdev, PHY_MPHY_CONTROL_REG, 0x0006);
+	/* should read 0002 */
+	et131x_mii_read(etdev, PHY_MPHY_CONTROL_REG, &data);
+	et131x_mii_write(etdev, PHY_MPHY_CONTROL_REG, 0x0006);
 
 	/* read modem register 0402, should I do something with
 	   the return data? */
-	MiWrite(etdev, PHY_INDEX_REG, 0x0402);
-	MiRead(etdev, PHY_DATA_REG, &data);
+	et131x_mii_write(etdev, PHY_INDEX_REG, 0x0402);
+	et131x_mii_read(etdev, PHY_DATA_REG, &data);
 
-	MiWrite(etdev, PHY_MPHY_CONTROL_REG, 0x0002);
+	et131x_mii_write(etdev, PHY_MPHY_CONTROL_REG, 0x0002);
 
 	/* what does this achieve (should return 0x1040) */
-	MiRead(etdev, PHY_CONTROL, &data);
-	MiRead(etdev, PHY_MPHY_CONTROL_REG, &data); /* should read 0002 */
-	MiWrite(etdev, PHY_CONTROL, 0x1840);
+	et131x_mii_read(etdev, PHY_CONTROL, &data);
+	/* should read 0002 */
+	et131x_mii_read(etdev, PHY_MPHY_CONTROL_REG, &data);
+	et131x_mii_write(etdev, PHY_CONTROL, 0x1840);
 
-	MiWrite(etdev, PHY_MPHY_CONTROL_REG, 0x0007);
+	et131x_mii_write(etdev, PHY_MPHY_CONTROL_REG, 0x0007);
 
 	/* here the writing of the array starts.... */
 	index = 0;
-	while (ConfigPhy[index][0] != 0x0000) {
+	while (config_phy[index][0] != 0x0000) {
 		/* write value */
-		MiWrite(etdev, PHY_INDEX_REG, ConfigPhy[index][0]);
-		MiWrite(etdev, PHY_DATA_REG, ConfigPhy[index][1]);
+		et131x_mii_write(etdev, PHY_INDEX_REG, config_phy[index][0]);
+		et131x_mii_write(etdev, PHY_DATA_REG, config_phy[index][1]);
 
 		/* read it back */
-		MiWrite(etdev, PHY_INDEX_REG, ConfigPhy[index][0]);
-		MiRead(etdev, PHY_DATA_REG, &data);
+		et131x_mii_write(etdev, PHY_INDEX_REG, config_phy[index][0]);
+		et131x_mii_read(etdev, PHY_DATA_REG, &data);
 
 		/* do a check on the value read back ? */
 		index++;
 	}
 	/* here the writing of the array ends... */
 
-	MiRead(etdev, PHY_CONTROL, &data);		/* 0x1840 */
-	MiRead(etdev, PHY_MPHY_CONTROL_REG, &data);/* should read 0007 */
-	MiWrite(etdev, PHY_CONTROL, 0x1040);
-	MiWrite(etdev, PHY_MPHY_CONTROL_REG, 0x0002);
+	et131x_mii_read(etdev, PHY_CONTROL, &data);		/* 0x1840 */
+	/* should read 0007 */
+	et131x_mii_read(etdev, PHY_MPHY_CONTROL_REG, &data);
+	et131x_mii_write(etdev, PHY_CONTROL, 0x1040);
+	et131x_mii_write(etdev, PHY_MPHY_CONTROL_REG, 0x0002);
 }
 
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index 289d511..c4f9032 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -90,14 +90,14 @@ void EnablePhyComa(struct et131x_adapter *adapter);
 void DisablePhyComa(struct et131x_adapter *adapter);
 
 /* et131x_phy.c */
-void ET1310_PhyInit(struct et131x_adapter *adapter);
-void ET1310_PhyReset(struct et131x_adapter *adapter);
-void ET1310_PhyPowerDown(struct et131x_adapter *adapter, bool down);
-void ET1310_PhyAdvertise1000BaseT(struct et131x_adapter *adapter,
-				  u16 duplex);
-void ET1310_PhyAccessMiBit(struct et131x_adapter *adapter,
-			   u16 action,
-			   u16 regnum, u16 bitnum, u8 *value);
+void et1310_phy_init(struct et131x_adapter *adapter);
+void et1310_phy_reset(struct et131x_adapter *adapter);
+void et1310_phy_power_down(struct et131x_adapter *adapter, bool down);
+void et1310_phy_advertise_1000BaseT(struct et131x_adapter *adapter,
+				    u16 duplex);
+void et1310_phy_access_mii_bit(struct et131x_adapter *adapter,
+			       u16 action,
+			       u16 regnum, u16 bitnum, u8 *value);
 
 int et131x_xcvr_find(struct et131x_adapter *adapter);
 void et131x_setphy_normal(struct et131x_adapter *adapter);
@@ -105,23 +105,18 @@ void et131x_setphy_normal(struct et131x_adapter *adapter);
 /* static inline function does not work because et131x_adapter is not always
  * defined
  */
-int PhyMiRead(struct et131x_adapter *adapter, u8 xcvrAddr,
+int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 xcvrAddr,
 	      u8 xcvrReg, u16 *value);
-#define MiRead(adapter, xcvrReg, value) \
-	PhyMiRead((adapter), (adapter)->stats.xcvr_addr, (xcvrReg), (value))
+#define et131x_mii_read(adapter, xcvrReg, value) \
+	et131x_phy_mii_read((adapter), \
+			    (adapter)->stats.xcvr_addr, \
+			    (xcvrReg), (value))
 
-int32_t MiWrite(struct et131x_adapter *adapter,
+int32_t et131x_mii_write(struct et131x_adapter *adapter,
 		u8 xcvReg, u16 value);
-void et131x_Mii_check(struct et131x_adapter *pAdapter,
+void et131x_mii_check(struct et131x_adapter *pAdapter,
 		      u16 bmsr, u16 bmsr_ints);
 
-/* This last is not strictly required (the driver could call the TPAL
- * version instead), but this sets the adapter up correctly, and calls the
- * access routine indirectly.  This protects the driver from changes in TPAL.
- */
-void SetPhy_10BaseTHalfDuplex(struct et131x_adapter *adapter);
-
-
 /* et1310_rx.c */
 int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter);
 void et131x_rx_dma_memory_free(struct et131x_adapter *adapter);
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index d98db85..9b01f22 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -401,28 +401,28 @@ int et131x_adapter_setup(struct et131x_adapter *etdev)
 		dev_warn(&etdev->pdev->dev, "Could not find the xcvr\n");
 
 	/* Prepare the TRUEPHY library. */
-	ET1310_PhyInit(etdev);
+	et1310_phy_init(etdev);
 
 	/* Reset the phy now so changes take place */
-	ET1310_PhyReset(etdev);
+	et1310_phy_reset(etdev);
 
 	/* Power down PHY */
-	ET1310_PhyPowerDown(etdev, 1);
+	et1310_phy_power_down(etdev, 1);
 
 	/*
 	 * We need to turn off 1000 base half dulplex, the mac does not
 	 * support it. For the 10/100 part, turn off all gig advertisement
 	 */
 	if (etdev->pdev->device != ET131X_PCI_DEVICE_ID_FAST)
-		ET1310_PhyAdvertise1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_FULL);
+		et1310_phy_advertise_1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_FULL);
 	else
-		ET1310_PhyAdvertise1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
+		et1310_phy_advertise_1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
 
 	/* Power up PHY */
-	ET1310_PhyPowerDown(etdev, 0);
+	et1310_phy_power_down(etdev, 0);
 
 	et131x_setphy_normal(etdev);
-;	return status;
+	return status;
 }
 
 /**
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index 48b4d78..0a810cc 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -385,11 +385,12 @@ void et131x_isr_handler(struct work_struct *work)
 			/* Read the PHY ISR to clear the reason for the
 			 * interrupt.
 			 */
-			MiRead(etdev, (uint8_t) offsetof(struct mi_regs, isr),
-			       &myisr);
+			et131x_mii_read(etdev,
+					(uint8_t) offsetof(struct mi_regs, isr),
+					&myisr);
 
 			if (!etdev->ReplicaPhyLoopbk) {
-				MiRead(etdev,
+				et131x_mii_read(etdev,
 				       (uint8_t) offsetof(struct mi_regs, bmsr),
 				       &bmsr_data);
 
@@ -397,7 +398,7 @@ void et131x_isr_handler(struct work_struct *work)
 				etdev->bmsr = bmsr_data;
 
 				/* Do all the cable in / cable out stuff */
-				et131x_Mii_check(etdev, bmsr_data, bmsr_ints);
+				et131x_mii_check(etdev, bmsr_data, bmsr_ints);
 			}
 		}
 
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 4e9e176..0f12b58 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -221,7 +221,7 @@ int et131x_ioctl_mii(struct net_device *netdev, struct ifreq *reqbuf, int cmd)
 		if (!capable(CAP_NET_ADMIN))
 			status = -EPERM;
 		else
-			status = MiRead(etdev,
+			status = et131x_mii_read(etdev,
 					data->reg_num, &data->val_out);
 		break;
 
@@ -229,7 +229,7 @@ int et131x_ioctl_mii(struct net_device *netdev, struct ifreq *reqbuf, int cmd)
 		if (!capable(CAP_NET_ADMIN))
 			status = -EPERM;
 		else
-			status = MiWrite(etdev, data->reg_num,
+			status = et131x_mii_write(etdev, data->reg_num,
 					 data->val_in);
 		break;
 
-- 
1.7.4.4

