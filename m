Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab2ILMzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:55:55 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:52874 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab2ILMzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBSdSECAxVwYTiBG8YpFSA5Vfkwc
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511719"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 03/24] Staging: ipack/bridges/tpci200: Clean up interrupt handler.
Date: Wed, 12 Sep 2012 14:55:25 +0200
Message-Id: <1347454546-23236-3-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

This also removes a possible bug in the unhandles_ints part when
slots[i] is not set.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   42 +++++++++++++------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 3285dad..24e2a11 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -108,12 +108,22 @@ static void tpci200_unregister(struct tpci200_board *tpci200)
 	}
 }
 
+static irqreturn_t tpci200_slot_irq(struct slot_irq *slot_irq)
+{
+	irqreturn_t ret = slot_irq->handler(slot_irq->arg);
+
+	/* Dummy reads */
+	readw(slot_irq->holder->io_space.address + 0xC0);
+	readw(slot_irq->holder->io_space.address + 0xC2);
+
+	return ret;
+}
+
 static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 {
 	struct tpci200_board *tpci200 = (struct tpci200_board *) dev_id;
 	int i;
 	unsigned short status_reg;
-	unsigned short unhandled_ints = 0;
 	irqreturn_t ret = IRQ_NONE;
 	struct slot_irq *slot_irq;
 
@@ -121,33 +131,15 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 	status_reg = readw(&tpci200->info->interface_regs->status);
 
 	if (status_reg & TPCI200_SLOT_INT_MASK) {
-		unhandled_ints = status_reg & TPCI200_SLOT_INT_MASK;
 		/* callback to the IRQ handler for the corresponding slot */
 		for (i = 0; i < TPCI200_NB_SLOT; i++) {
+			if (!(status_reg & ((TPCI200_A_INT0 | TPCI200_A_INT1) << (2*i))))
+				continue;
 			slot_irq = tpci200->slots[i].irq;
-
-			if ((slot_irq != NULL) &&
-			    (status_reg & ((TPCI200_A_INT0 | TPCI200_A_INT1) << (2*i)))) {
-
-				ret = slot_irq->handler(slot_irq->arg);
-
-				/* Dummy reads */
-				readw(slot_irq->holder->io_space.address +
-				      0xC0);
-				readw(slot_irq->holder->io_space.address +
-				      0xC2);
-
-				unhandled_ints &= ~(((TPCI200_A_INT0 | TPCI200_A_INT1) << (2*i)));
-			}
-		}
-	}
-	/* Interrupts not handled are disabled */
-	if (unhandled_ints) {
-		for (i = 0; i < TPCI200_NB_SLOT; i++) {
-			slot_irq = tpci200->slots[i].irq;
-
-			if (unhandled_ints & ((TPCI200_INT0_EN | TPCI200_INT1_EN) << (2*i))) {
-				dev_info(&slot_irq->holder->dev,
+			if (slot_irq) {
+				ret = tpci200_slot_irq(slot_irq);
+			} else {
+				dev_info(&tpci200->info->pdev->dev,
 					 "No registered ISR for slot [%d:%d]!. IRQ will be disabled.\n",
 					 tpci200->number, i);
 				__tpci200_clear_mask(
-- 
1.7.10.4

