Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab2IJIvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:51:13 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:45294 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab2IJIvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:51:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8CAHGoTVBbdWObgWdsb2JhbABFhge1SiIBARYmJ4IgAQEFIwQLAUYQIAUCJgICVwYTiBSoFZI7gSGPFoESA5VdiTOJUg
X-IronPort-AV: E=Sophos;i="4.80,397,1344204000"; 
   d="scan'208";a="949262522"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 20/20] Staging: ipack/bridges/tpci200: Store the irq holder in slot_irq.
Date: Mon, 10 Sep 2012 10:51:58 +0200
Message-Id: <1347267118-9580-20-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

This way we do no longer need to keep a dangling pointer to struct
ipack_device in tpci200_slot after the device has been removed.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   19 ++++++++++++-------
 drivers/staging/ipack/bridges/tpci200.h |    2 +-
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 531dfd5..6873b4d 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -91,6 +91,7 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 	unsigned short status_reg, reg_value;
 	unsigned short unhandled_ints = 0;
 	irqreturn_t ret = IRQ_NONE;
+	struct slot_irq *slot_irq;
 
 	/* Read status register */
 	status_reg = readw(&tpci200->info->interface_regs->status);
@@ -99,15 +100,17 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 		unhandled_ints = status_reg & TPCI200_SLOT_INT_MASK;
 		/* callback to the IRQ handler for the corresponding slot */
 		for (i = 0; i < TPCI200_NB_SLOT; i++) {
-			if ((tpci200->slots[i].irq != NULL) &&
+			slot_irq = tpci200->slots[i].irq;
+
+			if ((slot_irq != NULL) &&
 			    (status_reg & ((TPCI200_A_INT0 | TPCI200_A_INT1) << (2*i)))) {
 
-				ret = tpci200->slots[i].irq->handler(tpci200->slots[i].irq->arg);
+				ret = slot_irq->handler(slot_irq->arg);
 
 				/* Dummy reads */
-				readw(tpci200->slots[i].dev->io_space.address +
+				readw(slot_irq->holder->io_space.address +
 				      0xC0);
-				readw(tpci200->slots[i].dev->io_space.address +
+				readw(slot_irq->holder->io_space.address +
 				      0xC2);
 
 				unhandled_ints &= ~(((TPCI200_A_INT0 | TPCI200_A_INT1) << (2*i)));
@@ -117,8 +120,10 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 	/* Interrupts not handled are disabled */
 	if (unhandled_ints) {
 		for (i = 0; i < TPCI200_NB_SLOT; i++) {
+			slot_irq = tpci200->slots[i].irq;
+
 			if (unhandled_ints & ((TPCI200_INT0_EN | TPCI200_INT1_EN) << (2*i))) {
-				dev_info(&tpci200->slots[i].dev->dev,
+				dev_info(&slot_irq->holder->dev,
 					 "No registered ISR for slot [%d:%d]!. IRQ will be disabled.\n",
 					 tpci200->number, i);
 				reg_value = readw(
@@ -489,6 +494,7 @@ static int tpci200_request_irq(struct ipack_device *dev, int vector,
 	slot_irq->vector = vector;
 	slot_irq->handler = handler;
 	slot_irq->arg = arg;
+	slot_irq->holder = dev;
 
 	tpci200->slots[dev->slot].irq = slot_irq;
 	res = __tpci200_request_irq(tpci200, dev);
@@ -703,8 +709,7 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 	 * The TPCI200 has assigned his own two IRQ by PCI bus driver
 	 */
 	for (i = 0; i < TPCI200_NB_SLOT; i++)
-		tpci200->slots[i].dev =
-			ipack_device_register(tpci200->info->ipack_bus, i, i);
+		ipack_device_register(tpci200->info->ipack_bus, i, i);
 	return 0;
 
 out_err_bus_register:
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index 0fc1900..b9de6be 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -121,6 +121,7 @@ struct tpci200_regs {
  *
  */
 struct slot_irq {
+	struct ipack_device *holder;
 	int		vector;
 	int		(*handler)(void *);
 	void		*arg;
@@ -136,7 +137,6 @@ struct slot_irq {
  *
  */
 struct tpci200_slot {
-	struct ipack_device	*dev;
 	struct slot_irq		*irq;
 	struct ipack_addr_space io_phys;
 	struct ipack_addr_space id_phys;
-- 
1.7.10.4

