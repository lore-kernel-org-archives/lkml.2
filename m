Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab1HaQsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:48:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47389 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab1HaQsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:48:00 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH] staging: et131x: Use MII register defines from mii.h
Date: Wed, 31 Aug 2011 17:46:41 +0100
Message-Id: <1314809201-9574-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use defines from include/linux/mii.h instead of et131x_phy.h and delete the latter defines.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.c     |   22 ++--
 drivers/staging/et131x/et1310_phy.h     |  160 -------------------------------
 drivers/staging/et131x/et131x_initpci.c |    4 +-
 3 files changed, 13 insertions(+), 173 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index c216bbb..fedde6b 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -122,7 +122,7 @@ int et131x_mdio_reset(struct mii_bus *bus)
 	struct net_device *netdev = bus->priv;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
-	et131x_mii_write(adapter, PHY_CONTROL, 0x8000);
+	et131x_mii_write(adapter, MII_BMCR, 0x8000);
 
 	return 0;
 }
@@ -292,11 +292,11 @@ void et1310_phy_power_down(struct et131x_adapter *adapter, bool down)
 {
 	u16 data;
 
-	et131x_mii_read(adapter, PHY_CONTROL, &data);
+	et131x_mii_read(adapter, MII_BMCR, &data);
 	data &= ~0x0800;	/* Power UP */
 	if (down) /* Power DOWN */
 		data |= 0x0800;
-	et131x_mii_write(adapter, PHY_CONTROL, data);
+	et131x_mii_write(adapter, MII_BMCR, data);
 }
 
 /**
@@ -328,10 +328,10 @@ static void et1310_phy_link_status(struct et131x_adapter *adapter,
 	u16 vmi_phystatus = 0;
 	u16 control = 0;
 
-	et131x_mii_read(adapter, PHY_STATUS, &mistatus);
-	et131x_mii_read(adapter, PHY_1000_STATUS, &is1000BaseT);
+	et131x_mii_read(adapter, MII_BMSR, &mistatus);
+	et131x_mii_read(adapter, MII_STAT1000, &is1000BaseT);
 	et131x_mii_read(adapter, PHY_PHY_STATUS, &vmi_phystatus);
-	et131x_mii_read(adapter, PHY_CONTROL, &control);
+	et131x_mii_read(adapter, MII_BMCR, &control);
 
 	*link_status = (vmi_phystatus & 0x0040) ? 1 : 0;
 	*autoneg = (control & 0x1000) ? ((vmi_phystatus & 0x0020) ?
@@ -448,8 +448,8 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 	u32 masterslave;
 	u32 polarity;
 
-	if (bmsr_ints & MI_BMSR_LINK_STATUS) {
-		if (bmsr & MI_BMSR_LINK_STATUS) {
+	if (bmsr_ints & BMSR_LSTATUS) {
+		if (bmsr & BMSR_LSTATUS) {
 			adapter->boot_coma = 20;
 			netif_carrier_on(adapter->netdev);
 		} else {
@@ -505,9 +505,9 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 		}
 	}
 
-	if ((bmsr_ints & MI_BMSR_AUTO_NEG_COMPLETE) ||
-	   (adapter->ai_force_duplex == 3 && (bmsr_ints & MI_BMSR_LINK_STATUS))) {
-		if ((bmsr & MI_BMSR_AUTO_NEG_COMPLETE) ||
+	if ((bmsr_ints & BMSR_ANEGCOMPLETE) ||
+	   (adapter->ai_force_duplex == 3 && (bmsr_ints & BMSR_LSTATUS))) {
+		if ((bmsr & BMSR_ANEGCOMPLETE) ||
 		    adapter->ai_force_duplex == 3) {
 			et1310_phy_link_status(adapter,
 					     &link_status, &autoneg_status,
diff --git a/drivers/staging/et131x/et1310_phy.h b/drivers/staging/et131x/et1310_phy.h
index 8e9404e..d8753f1 100644
--- a/drivers/staging/et131x/et1310_phy.h
+++ b/drivers/staging/et131x/et1310_phy.h
@@ -61,24 +61,6 @@
 
 #include "et1310_address_map.h"
 
-/* MI Register Addresses */
-#define MI_CONTROL_REG                      0
-#define MI_STATUS_REG                       1
-#define MI_PHY_IDENTIFIER_1_REG             2
-#define MI_PHY_IDENTIFIER_2_REG             3
-#define MI_AUTONEG_ADVERTISEMENT_REG        4
-#define MI_AUTONEG_LINK_PARTNER_ABILITY_REG 5
-#define MI_AUTONEG_EXPANSION_REG            6
-#define MI_AUTONEG_NEXT_PAGE_TRANSMIT_REG   7
-#define MI_LINK_PARTNER_NEXT_PAGE_REG       8
-#define MI_1000BASET_CONTROL_REG            9
-#define MI_1000BASET_STATUS_REG             10
-#define MI_RESERVED11_REG                   11
-#define MI_RESERVED12_REG                   12
-#define MI_RESERVED13_REG                   13
-#define MI_RESERVED14_REG                   14
-#define MI_EXTENDED_STATUS_REG              15
-
 /* VMI Register Addresses */
 #define VMI_RESERVED16_REG                  16
 #define VMI_RESERVED17_REG                  17
@@ -126,134 +108,6 @@ struct mi_regs {
 	u8 mi_res4[3];	/* Future use by MI working group(Reg 0x1D - 0x1F) */
 };
 
-/*
- * MI Register 0: Basic mode control register
- *	15:	reset
- *	14:	loopback
- *	13:	speed_sel
- *	12:	enable_autoneg
- *	11:	power_down
- *	10:	isolate
- *	9:	restart_autoneg
- *	8:	duplex_mode
- *	7:	col_test
- *	6:	speed_1000_sel
- *	5-0:	res1
- */
-
-/*
- * MI Register 1:  Basic mode status register
- *	15:	link_100T4
- *	14:	link_100fdx
- *	13:	link_100hdx
- *	12:	link_10fdx
- *	11:	link_10hdx
- *	10:	link_100T2fdx
- *	9:	link_100T2hdx
- *	8:	extend_status
- *	7:	res1
- *	6:	preamble_supress
- *	5:	auto_neg_complete
- *	4:	remote_fault
- *	3:	auto_neg_able
- *	2:	link_status
- *	1:	jabber_detect
- *	0:	ext_cap
- */
-
-#define MI_BMSR_LINK_STATUS	  0x04
-#define MI_BMSR_AUTO_NEG_COMPLETE 0x20
-
-/*
- * MI Register 4: Auto-negotiation advertisement register
- *
- *	15:	np_indication
- *	14:	res2
- *	13:	remote_fault
- *	12:	res1
- *	11:	cap_asmpause
- *	10:	cap_pause
- *	9:	cap_100T4
- *	8:	cap_100fdx
- *	7:	cap_100hdx
- *	6:	cap_10fdx
- *	5:	cap_10hdx
- *	4-0:	selector
- */
-
-/* MI Register 5: Auto-negotiation link partner advertisement register
- *	15:	np_indication
- *	14:	acknowledge
- *	13:	remote_fault
- *	12:	res1
- *	11:	cap_asmpause
- *	10:	cap_pause
- *	9:	cap_100T4
- *	8:	cap_100fdx
- *	7:	cap_100hdx
- *	6:	cap_10fdx
- *	5:	cap_10hdx
- *	4-0:	selector
- */
-
-/* MI Register 6: Auto-negotiation expansion register
- *	15-5:	reserved
- *	4:	pdf
- *	3:	lp_np_able
- *	2:	np_able
- *	1:	page_rx
- *	0:	lp_an_able
- */
-
-/* MI Register 7: Auto-negotiation next page transmit reg(0x07)
- *	15:	np
- *	14:	reserved
- *	13:	msg_page
- *	12:	ack2
- *	11:	toggle
- *	10-0	msg
- */
-
-/* MI Register 8: Link Partner Next Page Reg(0x08)
- *	15:	np
- *	14:	ack
- *	13:	msg_page
- *	12:	ack2
- *	11:	toggle
- *	10-0:	msg
- */
-
-/* MI Register 9: 1000BaseT Control Reg(0x09)
- *	15-13:	test_mode
- *	12:	ms_config_en
- *	11:	ms_value
- *	10:	port_type
- *	9:	link_1000fdx
- *	8:	link_1000hdx
- *	7-0:	reserved
- */
-
-/* MI Register 10: 1000BaseT Status Reg(0x0A)
- *	15:	ms_config_fault
- *	14:	ms_resolve
- *	13:	local_rx_status
- *	12:	remote_rx_status
- *	11:	link_1000fdx
- *	10:	link_1000hdx
- *	9-8:	reserved
- *	7-0:	idle_err_cnt
- */
-
-/* MI Register 11 - 14: Reserved Regs(0x0B - 0x0E) */
-
-/* MI Register 15: Extended status Reg(0x0F)
- *	15:	link_1000Xfdx
- *	14:	link_1000Xhdx
- *	13:	link_1000fdx
- *	12:	link_1000hdx
- *	11-0:	reserved
- */
-
 /* MI Register 16 - 18: Reserved Reg(0x10-0x12) */
 
 /* MI Register 19: Loopback Control Reg(0x13)
@@ -422,20 +276,6 @@ struct mi_regs {
 #define TRUEPHY_ADV_DUPLEX_BOTH     \
 	(TRUEPHY_ADV_DUPLEX_FULL | TRUEPHY_ADV_DUPLEX_HALF)
 
-#define PHY_CONTROL                0x00	/* #define TRU_MI_CONTROL_REGISTER                 0 */
-#define PHY_STATUS                 0x01	/* #define TRU_MI_STATUS_REGISTER                  1 */
-#define PHY_ID_1                   0x02	/* #define TRU_MI_PHY_IDENTIFIER_1_REGISTER        2 */
-#define PHY_ID_2                   0x03	/* #define TRU_MI_PHY_IDENTIFIER_2_REGISTER        3 */
-#define PHY_AUTO_ADVERTISEMENT     0x04	/* #define TRU_MI_ADVERTISEMENT_REGISTER           4 */
-#define PHY_AUTO_LINK_PARTNER      0x05	/* #define TRU_MI_LINK_PARTNER_ABILITY_REGISTER    5 */
-#define PHY_AUTO_EXPANSION         0x06	/* #define TRU_MI_EXPANSION_REGISTER               6 */
-#define PHY_AUTO_NEXT_PAGE_TX      0x07	/* #define TRU_MI_NEXT_PAGE_TRANSMIT_REGISTER      7 */
-#define PHY_LINK_PARTNER_NEXT_PAGE 0x08	/* #define TRU_MI_LINK_PARTNER_NEXT_PAGE_REGISTER  8 */
-#define PHY_1000_CONTROL           0x09	/* #define TRU_MI_1000BASET_CONTROL_REGISTER       9 */
-#define PHY_1000_STATUS            0x0A	/* #define TRU_MI_1000BASET_STATUS_REGISTER        10 */
-
-#define PHY_EXTENDED_STATUS        0x0F	/* #define TRU_MI_EXTENDED_STATUS_REGISTER         15 */
-
 /* some defines for modem registers that seem to be 'reserved' */
 #define PHY_INDEX_REG              0x10
 #define PHY_DATA_REG               0x11
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 6ffebfa..2ef2a70 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -249,14 +249,14 @@ void et131x_error_timer_handler(unsigned long data)
 		dev_err(&adapter->pdev->dev,
 		    "No interrupts, in PHY coma, pm_csr = 0x%x\n", pm_csr);
 
-	if (!(adapter->bmsr & MI_BMSR_LINK_STATUS) &&
+	if (!(adapter->bmsr & BMSR_LSTATUS) &&
 	    adapter->registry_phy_coma &&
 	    adapter->boot_coma < 11) {
 		adapter->boot_coma++;
 	}
 
 	if (adapter->boot_coma == 10) {
-		if (!(adapter->bmsr & MI_BMSR_LINK_STATUS)
+		if (!(adapter->bmsr & BMSR_LSTATUS)
 		    && adapter->registry_phy_coma) {
 			if ((pm_csr & ET_PM_PHY_SW_COMA) == 0) {
 				/* NOTE - This was originally a 'sync with
-- 
1.7.6

