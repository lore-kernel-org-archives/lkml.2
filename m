Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2IJIu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:50:56 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:27136 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab2IJIux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:50:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8CAHGoTVBbdWObgWdsb2JhbABFhge1SiIBARYmJ4IgASkECwFGMAUCJgJfE4gUqBWSO4EhjxaBEgOVXZMF
X-IronPort-AV: E=Sophos;i="4.80,397,1344204000"; 
   d="scan'208";a="949262485"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 01/20] Staging: ipack/bridges/tpci200: Put the TPCI200 control registers into a struct.
Date: Mon, 10 Sep 2012 10:51:39 +0200
Message-Id: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

This saves us from a little pointer arithmetic and cleans up the code a bit.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   28 +++++++---------------------
 drivers/staging/ipack/bridges/tpci200.h |   21 +++++++++++++--------
 2 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index b81a8c9..4383953 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -16,14 +16,6 @@
 
 static struct ipack_bus_ops tpci200_bus_ops;
 
-/* TPCI200 controls registers */
-static int control_reg[] = {
-	TPCI200_CONTROL_A_REG,
-	TPCI200_CONTROL_B_REG,
-	TPCI200_CONTROL_C_REG,
-	TPCI200_CONTROL_D_REG
-};
-
 static int tpci200_slot_unregister(struct ipack_device *dev);
 
 static struct tpci200_board *check_slot(struct ipack_device *dev)
@@ -87,8 +79,7 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 	irqreturn_t ret = IRQ_NONE;
 
 	/* Read status register */
-	status_reg = readw(tpci200->info->interface_regs +
-			   TPCI200_STATUS_REG);
+	status_reg = readw(&tpci200->info->interface_regs->status);
 
 	if (status_reg & TPCI200_SLOT_INT_MASK) {
 		unhandled_ints = status_reg & TPCI200_SLOT_INT_MASK;
@@ -109,7 +100,7 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 			}
 		}
 	}
-	/* Interrupt not handled are disabled */
+	/* Interrupts not handled are disabled */
 	if (unhandled_ints) {
 		for (i = 0; i < TPCI200_NB_SLOT; i++) {
 			if (unhandled_ints & ((TPCI200_INT0_EN | TPCI200_INT1_EN) << (2*i))) {
@@ -117,13 +108,11 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 					 "No registered ISR for slot [%d:%d]!. IRQ will be disabled.\n",
 					 tpci200->number, i);
 				reg_value = readw(
-					tpci200->info->interface_regs +
-					control_reg[i]);
+					&tpci200->info->interface_regs->control[i]);
 				reg_value &=
 					~(TPCI200_INT0_EN | TPCI200_INT1_EN);
 				writew(reg_value,
-				       (tpci200->info->interface_regs +
-					control_reg[i]));
+				       &tpci200->info->interface_regs->control[i]);
 			}
 		}
 	}
@@ -221,8 +210,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			(void __iomem *)mem_base + TPCI200_MEM8_GAP*i;
 		tpci200->slots[i].mem_phys.size = TPCI200_MEM8_SIZE;
 
-		writew(slot_ctrl, (tpci200->info->interface_regs +
-				   control_reg[i]));
+		writew(slot_ctrl, &tpci200->info->interface_regs->control[i]);
 	}
 
 	res = request_irq(tpci200->info->pdev->irq,
@@ -261,8 +249,7 @@ static int __tpci200_request_irq(struct tpci200_board *tpci200,
 	 * clock rate 8 MHz
 	 */
 	slot_ctrl = TPCI200_INT0_EN | TPCI200_INT1_EN;
-	writew(slot_ctrl, (tpci200->info->interface_regs +
-			   control_reg[dev->slot]));
+	writew(slot_ctrl, &tpci200->info->interface_regs->control[dev->slot]);
 
 	return 0;
 }
@@ -281,8 +268,7 @@ static void __tpci200_free_irq(struct tpci200_board *tpci200,
 	 * clock rate 8 MHz
 	 */
 	slot_ctrl = 0;
-	writew(slot_ctrl, (tpci200->info->interface_regs +
-			   control_reg[dev->slot]));
+	writew(slot_ctrl, &tpci200->info->interface_regs->control[dev->slot]);
 }
 
 static int tpci200_free_irq(struct ipack_device *dev)
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index 38acba1..af48295 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -37,13 +37,15 @@
 #define TPCI200_MEM16_SPACE_BAR       4
 #define TPCI200_MEM8_SPACE_BAR        5
 
-#define TPCI200_REVISION_REG          0x00
-#define TPCI200_CONTROL_A_REG         0x02
-#define TPCI200_CONTROL_B_REG         0x04
-#define TPCI200_CONTROL_C_REG         0x06
-#define TPCI200_CONTROL_D_REG         0x08
-#define TPCI200_RESET_REG             0x0A
-#define TPCI200_STATUS_REG            0x0C
+struct tpci200_regs {
+	__le16	revision;
+	/* writes to control should occur with the mutex held to protect
+	 * read-modify-write operations */
+	__le16  control[4];
+	__le16	reset;
+	__le16	status;
+	u8	reserved[242];
+} __packed;
 
 #define TPCI200_IFACE_SIZE            0x100
 
@@ -63,6 +65,7 @@
 #define TPCI200_MEM16_GAP             0x00800000
 #define TPCI200_MEM16_SIZE            0x00800000
 
+/* control field in tpci200_regs */
 #define TPCI200_INT0_EN               0x0040
 #define TPCI200_INT1_EN               0x0080
 #define TPCI200_INT0_EDGE             0x0010
@@ -72,11 +75,13 @@
 #define TPCI200_RECOVER_EN            0x0002
 #define TPCI200_CLK32                 0x0001
 
+/* reset field in tpci200_regs */
 #define TPCI200_A_RESET               0x0001
 #define TPCI200_B_RESET               0x0002
 #define TPCI200_C_RESET               0x0004
 #define TPCI200_D_RESET               0x0008
 
+/* status field in tpci200_regs */
 #define TPCI200_A_TIMEOUT             0x1000
 #define TPCI200_B_TIMEOUT             0x2000
 #define TPCI200_C_TIMEOUT             0x4000
@@ -149,7 +154,7 @@ struct tpci200_slot {
 struct tpci200_infos {
 	struct pci_dev			*pdev;
 	struct pci_device_id		*id_table;
-	void __iomem			*interface_regs;
+	struct tpci200_regs __iomem	*interface_regs;
 	void __iomem			*ioidint_space;
 	void __iomem			*mem8_space;
 	void __iomem			*cfg_regs;
-- 
1.7.10.4

