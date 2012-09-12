Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab2ILNDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:03:11 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:52874 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758102Ab2ILMzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBSdSECAxVwYTiBG8YpFSA5Vfkwc
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511754"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 11/24] Staging: ipack/bridges/tpci200: Protect device registers with spinlock.
Date: Wed, 12 Sep 2012 14:55:33 +0200
Message-Id: <1347454546-23236-11-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Some of the device registers are accessed from both interrupt and
non-interrupt context.  To ensure proper read-modify-write modification
of these registers we can not use the  "global" tpci200 mutex.  Instead
a spin-lock is used.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   33 +++++++++++++------------------
 drivers/staging/ipack/bridges/tpci200.h |    1 +
 2 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 9ce577a..b1ddbe3 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -53,30 +53,22 @@ static struct tpci200_board *check_slot(struct ipack_device *dev)
 	return tpci200;
 }
 
-static void __tpci200_clear_mask(__le16 __iomem *addr, u16 mask)
-{
-	iowrite16(ioread16(addr) & (~mask), addr);
-}
-
 static void tpci200_clear_mask(struct tpci200_board *tpci200,
 			       __le16 __iomem *addr, u16 mask)
 {
-	mutex_lock(&tpci200->mutex);
-	__tpci200_clear_mask(addr, mask);
-	mutex_unlock(&tpci200->mutex);
-}
-
-static void __tpci200_set_mask(__le16 __iomem *addr, u16 mask)
-{
-	iowrite16(ioread16(addr) | mask, addr);
+	unsigned long flags;
+	spin_lock_irqsave(&tpci200->regs_lock, flags);
+	iowrite16(ioread16(addr) & (~mask), addr);
+	spin_unlock_irqrestore(&tpci200->regs_lock, flags);
 }
 
 static void tpci200_set_mask(struct tpci200_board *tpci200,
 			     __le16 __iomem *addr, u16 mask)
 {
-	mutex_lock(&tpci200->mutex);
-	__tpci200_set_mask(addr, mask);
-	mutex_unlock(&tpci200->mutex);
+	unsigned long flags;
+	spin_lock_irqsave(&tpci200->regs_lock, flags);
+	iowrite16(ioread16(addr) | mask, addr);
+	spin_unlock_irqrestore(&tpci200->regs_lock, flags);
 }
 
 static void tpci200_unregister(struct tpci200_board *tpci200)
@@ -143,7 +135,7 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 				dev_info(&tpci200->info->pdev->dev,
 					 "No registered ISR for slot [%d:%d]!. IRQ will be disabled.\n",
 					 tpci200->number, i);
-				__tpci200_clear_mask(
+				tpci200_clear_mask(tpci200,
 					&tpci200->info->interface_regs->control[i],
 					TPCI200_INT0_EN | TPCI200_INT1_EN);
 			}
@@ -213,6 +205,9 @@ static int tpci200_register(struct tpci200_board *tpci200)
 					   TPCI200_MEM8_SPACE_BAR),
 			TPCI200_MEM8_SIZE);
 
+	/* Initialize lock that protects interface_regs */
+	spin_lock_init(&tpci200->regs_lock);
+
 	ioidint_base = pci_resource_start(tpci200->info->pdev,
 					  TPCI200_IO_ID_INT_SPACES_BAR);
 	mem_base = pci_resource_start(tpci200->info->pdev,
@@ -272,7 +267,7 @@ out_disable_pci:
 static int __tpci200_request_irq(struct tpci200_board *tpci200,
 				 struct ipack_device *dev)
 {
-	__tpci200_set_mask(
+	tpci200_set_mask(tpci200,
 			&tpci200->info->interface_regs->control[dev->slot],
 			TPCI200_INT0_EN | TPCI200_INT1_EN);
 	return 0;
@@ -281,7 +276,7 @@ static int __tpci200_request_irq(struct tpci200_board *tpci200,
 static void __tpci200_free_irq(struct tpci200_board *tpci200,
 			       struct ipack_device *dev)
 {
-	__tpci200_clear_mask(
+	tpci200_clear_mask(tpci200,
 			&tpci200->info->interface_regs->control[dev->slot],
 			TPCI200_INT0_EN | TPCI200_INT1_EN);
 }
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index 75a5dcc..b8e9826 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -163,6 +163,7 @@ struct tpci200_infos {
 struct tpci200_board {
 	unsigned int		number;
 	struct mutex		mutex;
+	spinlock_t		regs_lock;
 	struct tpci200_slot	*slots;
 	struct tpci200_infos	*info;
 };
-- 
1.7.10.4

