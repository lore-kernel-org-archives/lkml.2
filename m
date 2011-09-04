Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab1IDK2X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 06:28:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53453 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1IDK02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 06:26:28 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 09/12] staging: et131x: Replace magic numbers in et1310_phy.c with defines
Date: Sun,  4 Sep 2011 11:24:40 +0100
Message-Id: <1315131883-11068-10-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
References: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced et131x_phy.c magic numbers specifying registers and their values with defines, defined in et131x_phy.h

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.c |   77 +++++++++++++++++---------------
 drivers/staging/et131x/et1310_phy.h |   84 ++++++++++++++++++++++++++--------
 2 files changed, 105 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 6c3ceed..3c82f44 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -122,12 +122,11 @@ int et131x_mdio_reset(struct mii_bus *bus)
 	struct net_device *netdev = bus->priv;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
-	et131x_mii_write(adapter, MII_BMCR, 0x8000);
+	et131x_mii_write(adapter, MII_BMCR, BMCR_RESET);
 
 	return 0;
 }
 
-
 int et131x_mii_read(struct et131x_adapter *adapter, u8 reg, u16 *value)
 {
 	struct phy_device *phydev = adapter->phydev;
@@ -293,9 +292,9 @@ void et1310_phy_power_down(struct et131x_adapter *adapter, bool down)
 	u16 data;
 
 	et131x_mii_read(adapter, MII_BMCR, &data);
-	data &= ~0x0800;	/* Power UP */
-	if (down) /* Power DOWN */
-		data |= 0x0800;
+	data &= ~BMCR_PDOWN;
+	if (down)
+		data |= BMCR_PDOWN;
 	et131x_mii_write(adapter, MII_BMCR, data);
 }
 
@@ -333,19 +332,20 @@ static void et1310_phy_link_status(struct et131x_adapter *adapter,
 	et131x_mii_read(adapter, PHY_PHY_STATUS, &vmi_phystatus);
 	et131x_mii_read(adapter, MII_BMCR, &control);
 
-	*link_status = (vmi_phystatus & 0x0040) ? 1 : 0;
-	*autoneg = (control & 0x1000) ? ((vmi_phystatus & 0x0020) ?
+	*link_status = (vmi_phystatus & ET_PHY_LSTATUS) ? 1 : 0;
+	*autoneg = (control & ET_PHY_AUTONEG_STATUS) ?
+			((vmi_phystatus & ET_PHY_AUTONEG_ENABLE) ?
 					    TRUEPHY_ANEG_COMPLETE :
 					    TRUEPHY_ANEG_NOT_COMPLETE) :
-		    TRUEPHY_ANEG_DISABLED;
-	*linkspeed = (vmi_phystatus & 0x0300) >> 8;
-	*duplex_mode = (vmi_phystatus & 0x0080) >> 7;
+							TRUEPHY_ANEG_DISABLED;
+	*linkspeed = (vmi_phystatus & ET_PHY_SPEED_STATUS) >> 8;
+	*duplex_mode = (vmi_phystatus & ET_PHY_DUPLEX_STATUS) >> 7;
 	/* NOTE: Need to complete this */
 	*mdi_mdix = 0;
 
-	*masterslave = (is1000BaseT & 0x4000) ?
+	*masterslave = (is1000BaseT & ET_1000BT_MSTR_SLV) ?
 			TRUEPHY_CFG_MASTER : TRUEPHY_CFG_SLAVE;
-	*polarity = (vmi_phystatus & 0x0400) ?
+	*polarity = (vmi_phystatus & ET_PHY_POLARITY_STATUS) ?
 			TRUEPHY_POLARITY_INVERTED : TRUEPHY_POLARITY_NORMAL;
 }
 
@@ -402,15 +402,17 @@ void et131x_xcvr_init(struct et131x_adapter *adapter)
 	/* Zero out the adapter structure variable representing BMSR */
 	adapter->bmsr = 0;
 
-	et131x_mii_read(adapter, (u8) offsetof(struct mi_regs, isr), &isr);
-	et131x_mii_read(adapter, (u8) offsetof(struct mi_regs, imr), &imr);
+	et131x_mii_read(adapter, PHY_INTERRUPT_STATUS, &isr);
+	et131x_mii_read(adapter, PHY_INTERRUPT_MASK, &imr);
 
 	/* Set the link status interrupt only.  Bad behavior when link status
 	 * and auto neg are set, we run into a nested interrupt problem
 	 */
-	imr |= 0x0105;
+	imr |= (ET_PHY_INT_MASK_AUTONEGSTAT &
+		ET_PHY_INT_MASK_LINKSTAT &
+		ET_PHY_INT_MASK_ENABLE);
 
-	et131x_mii_write(adapter, (u8) offsetof(struct mi_regs, imr), imr);
+	et131x_mii_write(adapter, PHY_INTERRUPT_MASK, imr);
 
 	/* Set the LED behavior such that LED 1 indicates speed (off =
 	 * 10Mbits, blink = 100Mbits, on = 1000Mbits) and LED 2 indicates
@@ -421,19 +423,17 @@ void et131x_xcvr_init(struct et131x_adapter *adapter)
 	 * EEPROM. However, the above description is the default.
 	 */
 	if ((adapter->eeprom_data[1] & 0x4) == 0) {
-		et131x_mii_read(adapter, (u8) offsetof(struct mi_regs, lcr2),
-		       &lcr2);
+		et131x_mii_read(adapter, PHY_LED_2, &lcr2);
 
-		lcr2 &= 0x00FF;
-		lcr2 |= 0xA000;	/* led link */
+		lcr2 &= (ET_LED2_LED_100TX & ET_LED2_LED_1000T);
+		lcr2 |= (LED_VAL_LINKON_ACTIVE << LED_LINK_SHIFT);
 
 		if ((adapter->eeprom_data[1] & 0x8) == 0)
-			lcr2 |= 0x0300;
+			lcr2 |= (LED_VAL_1000BT_100BTX << LED_TXRX_SHIFT);
 		else
-			lcr2 |= 0x0400;
+			lcr2 |= (LED_VAL_LINKON << LED_TXRX_SHIFT);
 
-		et131x_mii_write(adapter, (u8) offsetof(struct mi_regs, lcr2),
-			lcr2);
+		et131x_mii_write(adapter, PHY_LED_2, lcr2);
 	}
 }
 
@@ -464,14 +464,16 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 				 */
 				u16 register18;
 
-				et131x_mii_read(adapter, 0x12, &register18);
-				et131x_mii_write(adapter, 0x12,
+				et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG,
+						 &register18);
+				et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,
 						 register18 | 0x4);
-				et131x_mii_write(adapter, 0x10,
+				et131x_mii_write(adapter, PHY_INDEX_REG,
 						 register18 | 0x8402);
-				et131x_mii_write(adapter, 0x11,
+				et131x_mii_write(adapter, PHY_DATA_REG,
 						 register18 | 511);
-				et131x_mii_write(adapter, 0x12, register18);
+				et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,
+						 register18);
 			}
 
 			/* Free the packets being actively sent & stopped */
@@ -516,22 +518,25 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 				 */
 				u16 register18;
 
-				et131x_mii_read(adapter, 0x12, &register18);
-				et131x_mii_write(adapter, 0x12,
+				et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG,
+						 &register18);
+				et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,
 						 register18 | 0x4);
-				et131x_mii_write(adapter, 0x10,
+				et131x_mii_write(adapter, PHY_INDEX_REG,
 						 register18 | 0x8402);
-				et131x_mii_write(adapter, 0x11,
+				et131x_mii_write(adapter, PHY_DATA_REG,
 						 register18 | 511);
-				et131x_mii_write(adapter, 0x12, register18);
+				et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,
+						 register18);
 			}
 
 			et1310_config_flow_control(adapter);
 
 			if (phydev && phydev->speed == SPEED_1000 &&
 					adapter->registry_jumbo_packet > 2048)
-				et1310_phy_and_or_reg(adapter, 0x16, 0xcfff,
-								   0x2000);
+				et1310_phy_and_or_reg(adapter, PHY_CONFIG,
+						~ET_PHY_CONFIG_TX_FIFO_DEPTH,
+						ET_PHY_CONFIG_FIFO_DEPTH_32);
 
 			et131x_set_rx_dma_timer(adapter);
 			et1310_config_mac_regs2(adapter);
diff --git a/drivers/staging/et131x/et1310_phy.h b/drivers/staging/et131x/et1310_phy.h
index 9cbc185..104008e 100644
--- a/drivers/staging/et131x/et1310_phy.h
+++ b/drivers/staging/et131x/et1310_phy.h
@@ -61,6 +61,25 @@
 
 #include "et1310_address_map.h"
 
+/* some defines for modem registers that seem to be 'reserved' */
+#define PHY_INDEX_REG              0x10
+#define PHY_DATA_REG               0x11
+#define PHY_MPHY_CONTROL_REG       0x12
+
+/* defines for specified registers */
+#define PHY_LOOPBACK_CONTROL       0x13	/* TRU_VMI_LOOPBACK_CONTROL_1_REG 19 */
+					/* TRU_VMI_LOOPBACK_CONTROL_2_REG 20 */
+#define PHY_REGISTER_MGMT_CONTROL  0x15	/* TRU_VMI_MI_SEQ_CONTROL_REG     21 */
+#define PHY_CONFIG                 0x16	/* TRU_VMI_CONFIGURATION_REG      22 */
+#define PHY_PHY_CONTROL            0x17	/* TRU_VMI_PHY_CONTROL_REG        23 */
+#define PHY_INTERRUPT_MASK         0x18	/* TRU_VMI_INTERRUPT_MASK_REG     24 */
+#define PHY_INTERRUPT_STATUS       0x19	/* TRU_VMI_INTERRUPT_STATUS_REG   25 */
+#define PHY_PHY_STATUS             0x1A	/* TRU_VMI_PHY_STATUS_REG         26 */
+#define PHY_LED_1                  0x1B	/* TRU_VMI_LED_CONTROL_1_REG      27 */
+#define PHY_LED_2                  0x1C	/* TRU_VMI_LED_CONTROL_2_REG      28 */
+					/* TRU_VMI_LINK_CONTROL_REG       29 */
+					/* TRU_VMI_TIMING_CONTROL_REG        */
+
 /* PHY Register Mapping(MI) Management Interface Regs */
 struct mi_regs {
 	u8 bmcr;	/* Basic mode control reg(Reg 0x00) */
@@ -90,6 +109,9 @@ struct mi_regs {
 	u8 mi_res4[3];	/* Future use by MI working group(Reg 0x1D - 0x1F) */
 };
 
+/* MI Register 10: Gigabit basic mode status reg(Reg 0x0A) */
+#define ET_1000BT_MSTR_SLV 0x4000
+
 /* MI Register 16 - 18: Reserved Reg(0x10-0x12) */
 
 /* MI Register 19: Loopback Control Reg(0x13)
@@ -128,6 +150,13 @@ struct mi_regs {
  *	2-0:	mac_if_mode
  */
 
+#define ET_PHY_CONFIG_TX_FIFO_DEPTH	0x3000
+
+#define ET_PHY_CONFIG_FIFO_DEPTH_8	0x0000
+#define ET_PHY_CONFIG_FIFO_DEPTH_16	0x1000
+#define ET_PHY_CONFIG_FIFO_DEPTH_32	0x2000
+#define ET_PHY_CONFIG_FIFO_DEPTH_64	0x3000
+
 /* MI Register 23: PHY CONTROL Reg(0x17)
  *	15:	reserved
  *	14:	tdr_en
@@ -156,6 +185,9 @@ struct mi_regs {
  *	0:	int_en
  */
 
+#define ET_PHY_INT_MASK_AUTONEGSTAT	0x0100
+#define ET_PHY_INT_MASK_LINKSTAT	0x0004
+#define ET_PHY_INT_MASK_ENABLE		0x0001
 
 /* MI Register 25: Interrupt Status Reg(0x19)
  *	15-10:	reserved
@@ -187,6 +219,12 @@ struct mi_regs {
  *	1:	pause_en
  *	0:	asymmetric_dir
  */
+#define ET_PHY_AUTONEG_STATUS	0x1000
+#define ET_PHY_POLARITY_STATUS	0x0400
+#define ET_PHY_SPEED_STATUS	0x0300
+#define ET_PHY_DUPLEX_STATUS	0x0080
+#define ET_PHY_LSTATUS		0x0040
+#define ET_PHY_AUTONEG_ENABLE	0x0020
 
 /* MI Register 27: LED Control Reg 1(0x1B)
  *	15-14:	reserved
@@ -205,11 +243,35 @@ struct mi_regs {
  *	7-4:	led_100BaseTX
  *	3-0:	led_1000BaseT
  */
+#define ET_LED2_LED_LINK	0xF000
+#define ET_LED2_LED_TXRX	0x0F00
+#define ET_LED2_LED_100TX	0x00F0
+#define ET_LED2_LED_1000T	0x000F
 
-/* MI Register 29 - 31: Reserved Reg(0x1D - 0x1E) */
+/* defines for LED control reg 2 values */
+#define LED_VAL_1000BT			0x0
+#define LED_VAL_100BTX			0x1
+#define LED_VAL_10BT			0x2
+#define LED_VAL_1000BT_100BTX		0x3 /* 1000BT on, 100BTX blink */
+#define LED_VAL_LINKON			0x4
+#define LED_VAL_TX			0x5
+#define LED_VAL_RX			0x6
+#define LED_VAL_TXRX			0x7 /* TX or RX */
+#define LED_VAL_DUPLEXFULL		0x8
+#define LED_VAL_COLLISION		0x9
+#define LED_VAL_LINKON_ACTIVE		0xA /* Link on, activity blink */
+#define LED_VAL_LINKON_RECV		0xB /* Link on, receive blink */
+#define LED_VAL_DUPLEXFULL_COLLISION	0xC /* Duplex on, collision blink */
+#define LED_VAL_BLINK			0xD
+#define LED_VAL_ON			0xE
+#define LED_VAL_OFF			0xF
+
+#define LED_LINK_SHIFT			12
+#define LED_TXRX_SHIFT			8
+#define LED_100TX_SHIFT			4
 
+/* MI Register 29 - 31: Reserved Reg(0x1D - 0x1E) */
 
-/* Prototypes for ET1310_phy.c */
 /* Defines for PHY access routines */
 
 /* Define bit operation flags */
@@ -249,22 +311,4 @@ struct mi_regs {
 #define TRUEPHY_ADV_DUPLEX_BOTH     \
 	(TRUEPHY_ADV_DUPLEX_FULL | TRUEPHY_ADV_DUPLEX_HALF)
 
-/* some defines for modem registers that seem to be 'reserved' */
-#define PHY_INDEX_REG              0x10
-#define PHY_DATA_REG               0x11
-
-#define PHY_MPHY_CONTROL_REG       0x12
-#define PHY_LOOPBACK_CONTROL       0x13	/* TRU_VMI_LOOPBACK_CONTROL_1_REG 19 */
-					/* TRU_VMI_LOOPBACK_CONTROL_2_REG 20 */
-#define PHY_REGISTER_MGMT_CONTROL  0x15	/* TRU_VMI_MI_SEQ_CONTROL_REG     21 */
-#define PHY_CONFIG                 0x16	/* TRU_VMI_CONFIGURATION_REG      22 */
-#define PHY_PHY_CONTROL            0x17	/* TRU_VMI_PHY_CONTROL_REG        23 */
-#define PHY_INTERRUPT_MASK         0x18	/* TRU_VMI_INTERRUPT_MASK_REG     24 */
-#define PHY_INTERRUPT_STATUS       0x19	/* TRU_VMI_INTERRUPT_STATUS_REG   25 */
-#define PHY_PHY_STATUS             0x1A	/* TRU_VMI_PHY_STATUS_REG         26 */
-#define PHY_LED_1                  0x1B	/* TRU_VMI_LED_CONTROL_1_REG      27 */
-#define PHY_LED_2                  0x1C	/* TRU_VMI_LED_CONTROL_2_REG      28 */
-					/* TRU_VMI_LINK_CONTROL_REG       29 */
-					/* TRU_VMI_TIMING_CONTROL_REG        */
-
 #endif /* _ET1310_PHY_H_ */
-- 
1.7.6

