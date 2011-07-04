Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab1GDUMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 16:12:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62104 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab1GDUMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 16:12:32 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH] staging: et131x: Remove typedefs from et1310_phy.h
Date: Mon,  4 Jul 2011 21:11:45 +0100
Message-Id: <1309810305-4483-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the associated checkpatch warnings.
Tested with ifconfig/general use of a device (Agere Systems ET-131x PCI-E
Ethernet Controller (rev 02)).

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.c     |   15 ++--
 drivers/staging/et131x/et1310_phy.h     |  169 +++++++++++--------------------
 drivers/staging/et131x/et131x.h         |    2 +-
 drivers/staging/et131x/et131x_adapter.h |    2 +-
 drivers/staging/et131x/et131x_initpci.c |    4 +-
 drivers/staging/et131x/et131x_isr.c     |   12 +-
 6 files changed, 76 insertions(+), 128 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index f88b204..8d66e8e 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -582,7 +582,7 @@ static void et131x_xcvr_init(struct et131x_adapter *etdev)
 	u16 lcr2;
 
 	/* Zero out the adapter structure variable representing BMSR */
-	etdev->Bmsr.value = 0;
+	etdev->bmsr = 0;
 
 	MiRead(etdev, (u8) offsetof(struct mi_regs, isr), &isr);
 	MiRead(etdev, (u8) offsetof(struct mi_regs, imr), &imr);
@@ -729,7 +729,7 @@ static void et131x_xcvr_init(struct et131x_adapter *etdev)
 }
 
 void et131x_Mii_check(struct et131x_adapter *etdev,
-		      MI_BMSR_t bmsr, MI_BMSR_t bmsr_ints)
+		      u16 bmsr, u16 bmsr_ints)
 {
 	u8 link_status;
 	u32 autoneg_status;
@@ -740,8 +740,8 @@ void et131x_Mii_check(struct et131x_adapter *etdev,
 	u32 polarity;
 	unsigned long flags;
 
-	if (bmsr_ints.bits.link_status) {
-		if (bmsr.bits.link_status) {
+	if (bmsr_ints & MI_BMSR_LINK_STATUS) {
+		if (bmsr & MI_BMSR_LINK_STATUS) {
 			etdev->boot_coma = 20;
 
 			/* Update our state variables and indicate the
@@ -820,9 +820,10 @@ void et131x_Mii_check(struct et131x_adapter *etdev,
 		}
 	}
 
-	if (bmsr_ints.bits.auto_neg_complete ||
-	    (etdev->AiForceDpx == 3 && bmsr_ints.bits.link_status)) {
-		if (bmsr.bits.auto_neg_complete || etdev->AiForceDpx == 3) {
+	if ((bmsr_ints & MI_BMSR_AUTO_NEG_COMPLETE) ||
+	    (etdev->AiForceDpx == 3 && (bmsr_ints & MI_BMSR_LINK_STATUS))) {
+		if ((bmsr & MI_BMSR_AUTO_NEG_COMPLETE) ||
+		    etdev->AiForceDpx == 3) {
 			ET1310_PhyLinkStatus(etdev,
 					     &link_status, &autoneg_status,
 					     &speed, &duplex, &mdi_mdix,
diff --git a/drivers/staging/et131x/et1310_phy.h b/drivers/staging/et131x/et1310_phy.h
index 946c0c5..6b38a3e 100644
--- a/drivers/staging/et131x/et1310_phy.h
+++ b/drivers/staging/et131x/et1310_phy.h
@@ -126,119 +126,66 @@ struct mi_regs {
 	u8 mi_res4[3];	/* Future use by MI working group(Reg 0x1D - 0x1F) */
 };
 
-/* MI Register 0: Basic mode control register */
-typedef union _MI_BMCR_t {
-	u16 value;
-	struct {
-#ifdef _BIT_FIELDS_HTOL
-		u16 reset:1;		/* bit 15 */
-		u16 loopback:1;		/* bit 14 */
-		u16 speed_sel:1;		/* bit 13 */
-		u16 enable_autoneg:1;	/* bit 12 */
-		u16 power_down:1;		/* bit 11 */
-		u16 isolate:1;		/* bit 10 */
-		u16 restart_autoneg:1;	/* bit 9 */
-		u16 duplex_mode:1;		/* bit 8 */
-		u16 col_test:1;		/* bit 7 */
-		u16 speed_1000_sel:1;	/* bit 6 */
-		u16 res1:6;		/* bits 0-5 */
-#else
-		u16 res1:6;		/* bits 0-5 */
-		u16 speed_1000_sel:1;	/* bit 6 */
-		u16 col_test:1;		/* bit 7 */
-		u16 duplex_mode:1;		/* bit 8 */
-		u16 restart_autoneg:1;	/* bit 9 */
-		u16 isolate:1;		/* bit 10 */
-		u16 power_down:1;		/* bit 11 */
-		u16 enable_autoneg:1;	/* bit 12 */
-		u16 speed_sel:1;		/* bit 13 */
-		u16 loopback:1;		/* bit 14 */
-		u16 reset:1;		/* bit 15 */
-#endif
-	} bits;
-} MI_BMCR_t, *PMI_BMCR_t;
-
-/* MI Register 1:  Basic mode status register */
-typedef union _MI_BMSR_t {
-	u16 value;
-	struct {
-#ifdef _BIT_FIELDS_HTOL
-		u16 link_100T4:1;		/* bit 15 */
-		u16 link_100fdx:1;		/* bit 14 */
-		u16 link_100hdx:1;		/* bit 13 */
-		u16 link_10fdx:1;		/* bit 12 */
-		u16 link_10hdx:1;		/* bit 11 */
-		u16 link_100T2fdx:1;	/* bit 10 */
-		u16 link_100T2hdx:1;	/* bit 9 */
-		u16 extend_status:1;	/* bit 8 */
-		u16 res1:1;		/* bit 7 */
-		u16 preamble_supress:1;	/* bit 6 */
-		u16 auto_neg_complete:1;	/* bit 5 */
-		u16 remote_fault:1;	/* bit 4 */
-		u16 auto_neg_able:1;	/* bit 3 */
-		u16 link_status:1;		/* bit 2 */
-		u16 jabber_detect:1;	/* bit 1 */
-		u16 ext_cap:1;		/* bit 0 */
-#else
-		u16 ext_cap:1;		/* bit 0 */
-		u16 jabber_detect:1;	/* bit 1 */
-		u16 link_status:1;		/* bit 2 */
-		u16 auto_neg_able:1;	/* bit 3 */
-		u16 remote_fault:1;	/* bit 4 */
-		u16 auto_neg_complete:1;	/* bit 5 */
-		u16 preamble_supress:1;	/* bit 6 */
-		u16 res1:1;		/* bit 7 */
-		u16 extend_status:1;	/* bit 8 */
-		u16 link_100T2hdx:1;	/* bit 9 */
-		u16 link_100T2fdx:1;	/* bit 10 */
-		u16 link_10hdx:1;		/* bit 11 */
-		u16 link_10fdx:1;		/* bit 12 */
-		u16 link_100hdx:1;		/* bit 13 */
-		u16 link_100fdx:1;		/* bit 14 */
-		u16 link_100T4:1;		/* bit 15 */
-#endif
-	} bits;
-} MI_BMSR_t, *PMI_BMSR_t;
-
-/* MI Register 4: Auto-negotiation advertisement register */
-typedef union _MI_ANAR_t {
-	u16 value;
-	struct {
-#ifdef _BIT_FIELDS_HTOL
-		u16 np_indication:1;	/* bit 15 */
-		u16 res2:1;		/* bit 14 */
-		u16 remote_fault:1;	/* bit 13 */
-		u16 res1:1;		/* bit 12 */
-		u16 cap_asmpause:1;	/* bit 11 */
-		u16 cap_pause:1;		/* bit 10 */
-		u16 cap_100T4:1;		/* bit 9 */
-		u16 cap_100fdx:1;		/* bit 8 */
-		u16 cap_100hdx:1;		/* bit 7 */
-		u16 cap_10fdx:1;		/* bit 6 */
-		u16 cap_10hdx:1;		/* bit 5 */
-		u16 selector:5;		/* bits 0-4 */
-#else
-		u16 selector:5;		/* bits 0-4 */
-		u16 cap_10hdx:1;		/* bit 5 */
-		u16 cap_10fdx:1;		/* bit 6 */
-		u16 cap_100hdx:1;		/* bit 7 */
-		u16 cap_100fdx:1;		/* bit 8 */
-		u16 cap_100T4:1;		/* bit 9 */
-		u16 cap_pause:1;		/* bit 10 */
-		u16 cap_asmpause:1;	/* bit 11 */
-		u16 res1:1;		/* bit 12 */
-		u16 remote_fault:1;	/* bit 13 */
-		u16 res2:1;		/* bit 14 */
-		u16 np_indication:1;	/* bit 15 */
-#endif
-	} bits;
-} MI_ANAR_t, *PMI_ANAR_t;
+/*
+ * MI Register 0: Basic mode control register
+ *	15:	reset
+ *	14:	loopback
+ *	13:	speed_sel
+ *	12:	enable_autoneg
+ *	11:	power_down
+ *	10:	isolate
+ *	9:	restart_autoneg
+ *	8:	duplex_mode
+ *	7:	col_test
+ *	6:	speed_1000_sel
+ *	5-0:	res1
+ */
+
+/*
+ * MI Register 1:  Basic mode status register
+ *	15:	link_100T4
+ *	14:	link_100fdx
+ *	13:	link_100hdx
+ *	12:	link_10fdx
+ *	11:	link_10hdx
+ *	10:	link_100T2fdx
+ *	9:	link_100T2hdx
+ *	8:	extend_status
+ *	7:	res1
+ *	6:	preamble_supress
+ *	5:	auto_neg_complete
+ *	4:	remote_fault
+ *	3:	auto_neg_able
+ *	2:	link_status
+ *	1:	jabber_detect
+ *	0:	ext_cap
+ */
+
+#define MI_BMSR_LINK_STATUS	  0x04
+#define MI_BMSR_AUTO_NEG_COMPLETE 0x20
+
+/*
+ * MI Register 4: Auto-negotiation advertisement register
+ *
+ *	15:	np_indication
+ *	14:	res2
+ *	13:	remote_fault
+ *	12:	res1
+ *	11:	cap_asmpause
+ *	10:	cap_pause
+ *	9:	cap_100T4
+ *	8:	cap_100fdx
+ *	7:	cap_100hdx
+ *	6:	cap_10fdx
+ *	5:	cap_10hdx
+ *	4-0:	selector
+ */
 
 /* MI Register 5: Auto-negotiation link partner advertisement register
  *	15:	np_indication
  *	14:	acknowledge
  *	13:	remote_fault
- *	12:	res1:1;		
+ *	12:	res1
  *	11:	cap_asmpause
  *	10:	cap_pause
  *	9:	cap_100T4
@@ -258,7 +205,7 @@ typedef union _MI_ANAR_t {
  *	0:	lp_an_able
  */
 
-/* MI Register 7: Auto-negotiation next page transmit reg(0x07) 
+/* MI Register 7: Auto-negotiation next page transmit reg(0x07)
  *	15:	np
  *	14:	reserved
  *	13:	msg_page
@@ -267,7 +214,7 @@ typedef union _MI_ANAR_t {
  *	10-0	msg
  */
 
-/* MI Register 8: Link Partner Next Page Reg(0x08) 
+/* MI Register 8: Link Partner Next Page Reg(0x08)
  *	15:	np
  *	14:	ack
  *	13:	msg_page
@@ -473,7 +420,7 @@ typedef union _MI_ANAR_t {
 #define TRUEPHY_ADV_DUPLEX_FULL         0x01
 #define TRUEPHY_ADV_DUPLEX_HALF         0x02
 #define TRUEPHY_ADV_DUPLEX_BOTH     \
-    (TRUEPHY_ADV_DUPLEX_FULL | TRUEPHY_ADV_DUPLEX_HALF)
+	(TRUEPHY_ADV_DUPLEX_FULL | TRUEPHY_ADV_DUPLEX_HALF)
 
 #define PHY_CONTROL                0x00	/* #define TRU_MI_CONTROL_REGISTER                 0 */
 #define PHY_STATUS                 0x01	/* #define TRU_MI_STATUS_REGISTER                  1 */
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index e425147..48ebac0 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -113,7 +113,7 @@ int PhyMiRead(struct et131x_adapter *adapter, u8 xcvrAddr,
 int32_t MiWrite(struct et131x_adapter *adapter,
 		u8 xcvReg, u16 value);
 void et131x_Mii_check(struct et131x_adapter *pAdapter,
-		      MI_BMSR_t bmsr, MI_BMSR_t bmsr_ints);
+		      u16 bmsr, u16 bmsr_ints);
 
 /* This last is not strictly required (the driver could call the TPAL
  * version instead), but this sets the adapter up correctly, and calls the
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index 99c2ef6..c8908fa 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -222,7 +222,7 @@ struct et131x_adapter {
 	u32 CachedMaskValue;
 
 	/* Xcvr status at last poll */
-	MI_BMSR_t Bmsr;
+	u16 bmsr;
 
 	/* Tx Memory Variables */
 	struct tx_ring tx_ring;
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index a9d2521..8c8d6b8 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -274,14 +274,14 @@ void et131x_error_timer_handler(unsigned long data)
 		dev_err(&etdev->pdev->dev,
 		    "No interrupts, in PHY coma, pm_csr = 0x%x\n", pm_csr);
 
-	if (!etdev->Bmsr.bits.link_status &&
+	if (!(etdev->bmsr & MI_BMSR_LINK_STATUS) &&
 	    etdev->RegistryPhyComa &&
 	    etdev->boot_coma < 11) {
 		etdev->boot_coma++;
 	}
 
 	if (etdev->boot_coma == 10) {
-		if (!etdev->Bmsr.bits.link_status
+		if (!(etdev->bmsr & MI_BMSR_LINK_STATUS)
 		    && etdev->RegistryPhyComa) {
 			if ((pm_csr & ET_PM_PHY_SW_COMA) == 0) {
 				/* NOTE - This was originally a 'sync with
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index 19d6726..0a5ce80 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -365,7 +365,8 @@ void et131x_isr_handler(struct work_struct *work)
 		/* Handle the PHY interrupt */
 		if (status & ET_INTR_PHY) {
 			u32 pm_csr;
-			MI_BMSR_t BmsrInts, BmsrData;
+			u16 bmsr_ints;
+			u16 bmsr_data;
 			u16 myisr;
 
 			/* If we are in coma mode when we get this interrupt,
@@ -390,14 +391,13 @@ void et131x_isr_handler(struct work_struct *work)
 			if (!etdev->ReplicaPhyLoopbk) {
 				MiRead(etdev,
 				       (uint8_t) offsetof(struct mi_regs, bmsr),
-				       &BmsrData.value);
+				       &bmsr_data);
 
-				BmsrInts.value =
-				    etdev->Bmsr.value ^ BmsrData.value;
-				etdev->Bmsr.value = BmsrData.value;
+				bmsr_ints = etdev->bmsr ^ bmsr_data;
+				etdev->bmsr = bmsr_data;
 
 				/* Do all the cable in / cable out stuff */
-				et131x_Mii_check(etdev, BmsrData, BmsrInts);
+				et131x_Mii_check(etdev, bmsr_data, bmsr_ints);
 			}
 		}
 
-- 
1.7.4.4

