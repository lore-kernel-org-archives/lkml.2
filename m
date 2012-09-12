Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab2ILNG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:06:29 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:52874 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2ILMzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqACACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEtUjCBDhOIEbxikVIDlV+TBw
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511716"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 01/24] Staging: ipack/bridges/tpci200: add helpers for writing control regs.
Date: Wed, 12 Sep 2012 14:55:23 +0200
Message-Id: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Convert tpci200_set_clockrate and tpci200_interrupt.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   49 ++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 9d886b7..2560519 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -53,6 +53,32 @@ static struct tpci200_board *check_slot(struct ipack_device *dev)
 	return tpci200;
 }
 
+static void __tpci200_clear_mask(__le16 __iomem *addr, u16 mask)
+{
+	iowrite16(ioread16(addr) & (~mask), addr);
+}
+
+static void tpci200_clear_mask(struct tpci200_board *tpci200,
+			       __le16 __iomem *addr, u16 mask)
+{
+	mutex_lock(&tpci200->mutex);
+	__tpci200_clear_mask(addr, mask);
+	mutex_unlock(&tpci200->mutex);
+}
+
+static void __tpci200_set_mask(__le16 __iomem *addr, u16 mask)
+{
+	iowrite16(ioread16(addr) | mask, addr);
+}
+
+static void tpci200_set_mask(struct tpci200_board *tpci200,
+			     __le16 __iomem *addr, u16 mask)
+{
+	mutex_lock(&tpci200->mutex);
+	__tpci200_set_mask(addr, mask);
+	mutex_unlock(&tpci200->mutex);
+}
+
 static void tpci200_unregister(struct tpci200_board *tpci200)
 {
 	int i;
@@ -86,7 +112,7 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 {
 	struct tpci200_board *tpci200 = (struct tpci200_board *) dev_id;
 	int i;
-	unsigned short status_reg, reg_value;
+	unsigned short status_reg;
 	unsigned short unhandled_ints = 0;
 	irqreturn_t ret = IRQ_NONE;
 	struct slot_irq *slot_irq;
@@ -124,12 +150,9 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 				dev_info(&slot_irq->holder->dev,
 					 "No registered ISR for slot [%d:%d]!. IRQ will be disabled.\n",
 					 tpci200->number, i);
-				reg_value = readw(
-					&tpci200->info->interface_regs->control[i]);
-				reg_value &=
-					~(TPCI200_INT0_EN | TPCI200_INT1_EN);
-				writew(reg_value,
-				       &tpci200->info->interface_regs->control[i]);
+				__tpci200_clear_mask(
+					&tpci200->info->interface_regs->control[i],
+					TPCI200_INT0_EN | TPCI200_INT1_EN);
 			}
 		}
 	}
@@ -518,30 +541,22 @@ static int tpci200_set_clockrate(struct ipack_device *dev, int mherz)
 {
 	struct tpci200_board *tpci200 = check_slot(dev);
 	u16 __iomem *addr;
-	u16 reg;
 
 	if (!tpci200)
 		return -ENODEV;
 
 	addr = &tpci200->info->interface_regs->control[dev->slot];
 
-	/* Ensure the control register is not changed by another task after we
-	 * have read it. */
-	mutex_lock(&tpci200->mutex);
-	reg = ioread16(addr);
 	switch (mherz) {
 	case 8:
-		reg &= ~(TPCI200_CLK32);
+		tpci200_clear_mask(tpci200, addr, TPCI200_CLK32);
 		break;
 	case 32:
-		reg |= TPCI200_CLK32;
+		tpci200_set_mask(tpci200, addr, TPCI200_CLK32);
 		break;
 	default:
-		mutex_unlock(&tpci200->mutex);
 		return -EINVAL;
 	}
-	iowrite16(reg, addr);
-	mutex_unlock(&tpci200->mutex);
 	return 0;
 }
 
-- 
1.7.10.4

