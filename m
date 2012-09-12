Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab2ILNCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:02:33 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:52874 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab2ILMzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBSdSECAxVwYTiBG8YpFSA5Vfkwc
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511770"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 14/24] Staging: ipack/bridges/tpci200: More cleanups.
Date: Wed, 12 Sep 2012 14:55:36 +0200
Message-Id: <1347454546-23236-14-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Rename __tpci_request_irq() to tpci_enable_irq() and __tpci_free_irq()
to tpci_disable_irq().  Change their second argument, move them above
tpci200_interrupt(), and use tpci_disable_irq() in the latter

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   44 +++++++++++++++----------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 4eaa2aa..c7ec342 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -100,6 +100,22 @@ static void tpci200_unregister(struct tpci200_board *tpci200)
 	}
 }
 
+static void tpci200_enable_irq(struct tpci200_board *tpci200,
+			       int islot)
+{
+	tpci200_set_mask(tpci200,
+			&tpci200->info->interface_regs->control[islot],
+			TPCI200_INT0_EN | TPCI200_INT1_EN);
+}
+
+static void tpci200_disable_irq(struct tpci200_board *tpci200,
+				int islot)
+{
+	tpci200_clear_mask(tpci200,
+			&tpci200->info->interface_regs->control[islot],
+			TPCI200_INT0_EN | TPCI200_INT1_EN);
+}
+
 static irqreturn_t tpci200_slot_irq(struct slot_irq *slot_irq)
 {
 	irqreturn_t ret;
@@ -141,9 +157,7 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 			dev_info(&tpci200->info->pdev->dev,
 				 "No registered ISR for slot [%d:%d]!. IRQ will be disabled.\n",
 				 tpci200->number, i);
-			tpci200_clear_mask(tpci200,
-				&tpci200->info->interface_regs->control[i],
-				TPCI200_INT0_EN | TPCI200_INT1_EN);
+			tpci200_disable_irq(tpci200, i);
 		}
 	}
 	rcu_read_unlock();
@@ -269,23 +283,6 @@ out_disable_pci:
 	return res;
 }
 
-static int __tpci200_request_irq(struct tpci200_board *tpci200,
-				 struct ipack_device *dev)
-{
-	tpci200_set_mask(tpci200,
-			&tpci200->info->interface_regs->control[dev->slot],
-			TPCI200_INT0_EN | TPCI200_INT1_EN);
-	return 0;
-}
-
-static void __tpci200_free_irq(struct tpci200_board *tpci200,
-			       struct ipack_device *dev)
-{
-	tpci200_clear_mask(tpci200,
-			&tpci200->info->interface_regs->control[dev->slot],
-			TPCI200_INT0_EN | TPCI200_INT1_EN);
-}
-
 static int tpci200_free_irq(struct ipack_device *dev)
 {
 	struct slot_irq *slot_irq;
@@ -303,8 +300,9 @@ static int tpci200_free_irq(struct ipack_device *dev)
 		return -EINVAL;
 	}
 
-	__tpci200_free_irq(tpci200, dev);
+	tpci200_disable_irq(tpci200, dev->slot);
 	slot_irq = tpci200->slots[dev->slot].irq;
+	/* uninstall handler */
 	RCU_INIT_POINTER(tpci200->slots[dev->slot].irq, NULL);
 	synchronize_rcu();
 	kfree(slot_irq);
@@ -453,7 +451,7 @@ out_unlock:
 static int tpci200_request_irq(struct ipack_device *dev, int vector,
 			       int (*handler)(void *), void *arg)
 {
-	int res;
+	int res = 0;
 	struct slot_irq *slot_irq;
 	struct tpci200_board *tpci200;
 
@@ -493,7 +491,7 @@ static int tpci200_request_irq(struct ipack_device *dev, int vector,
 	slot_irq->holder = dev;
 
 	rcu_assign_pointer(tpci200->slots[dev->slot].irq, slot_irq);
-	res = __tpci200_request_irq(tpci200, dev);
+	tpci200_enable_irq(tpci200, dev->slot);
 
 out_unlock:
 	mutex_unlock(&tpci200->mutex);
-- 
1.7.10.4

