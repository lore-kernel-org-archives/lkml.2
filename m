Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab2ILMz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:55:58 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:15608 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134Ab2ILMzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBSdSECAxVwYTiBG8YpFSA5VfiTOJVA
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511776"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 15/24] Staging: ipack/bridges/tpci200: move tpci200_free_irq() and tpci200_request_irq()
Date: Wed, 12 Sep 2012 14:55:37 +0200
Message-Id: <1347454546-23236-15-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Now, all the interrupt related functions are next to each other.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |  154 +++++++++++++++----------------
 1 file changed, 77 insertions(+), 77 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index c7ec342..b0d2205 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -165,6 +165,83 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int tpci200_free_irq(struct ipack_device *dev)
+{
+	struct slot_irq *slot_irq;
+	struct tpci200_board *tpci200;
+
+	tpci200 = check_slot(dev);
+	if (tpci200 == NULL)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&tpci200->mutex))
+		return -ERESTARTSYS;
+
+	if (tpci200->slots[dev->slot].irq == NULL) {
+		mutex_unlock(&tpci200->mutex);
+		return -EINVAL;
+	}
+
+	tpci200_disable_irq(tpci200, dev->slot);
+	slot_irq = tpci200->slots[dev->slot].irq;
+	/* uninstall handler */
+	RCU_INIT_POINTER(tpci200->slots[dev->slot].irq, NULL);
+	synchronize_rcu();
+	kfree(slot_irq);
+	mutex_unlock(&tpci200->mutex);
+	return 0;
+}
+
+static int tpci200_request_irq(struct ipack_device *dev, int vector,
+			       int (*handler)(void *), void *arg)
+{
+	int res = 0;
+	struct slot_irq *slot_irq;
+	struct tpci200_board *tpci200;
+
+	tpci200 = check_slot(dev);
+	if (tpci200 == NULL)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&tpci200->mutex))
+		return -ERESTARTSYS;
+
+	if (tpci200->slots[dev->slot].irq != NULL) {
+		dev_err(&dev->dev,
+			"Slot [%d:%d] IRQ already registered !\n", dev->bus_nr,
+			dev->slot);
+		res = -EINVAL;
+		goto out_unlock;
+	}
+
+	slot_irq = kzalloc(sizeof(struct slot_irq), GFP_KERNEL);
+	if (slot_irq == NULL) {
+		dev_err(&dev->dev,
+			"Slot [%d:%d] unable to allocate memory for IRQ !\n",
+			dev->bus_nr, dev->slot);
+		res = -ENOMEM;
+		goto out_unlock;
+	}
+
+	/*
+	 * WARNING: Setup Interrupt Vector in the IndustryPack device
+	 * before an IRQ request.
+	 * Read the User Manual of your IndustryPack device to know
+	 * where to write the vector in memory.
+	 */
+	slot_irq->vector = vector;
+	slot_irq->handler = handler;
+	slot_irq->arg = arg;
+	slot_irq->holder = dev;
+
+	rcu_assign_pointer(tpci200->slots[dev->slot].irq, slot_irq);
+	tpci200_enable_irq(tpci200, dev->slot);
+
+out_unlock:
+	mutex_unlock(&tpci200->mutex);
+	return res;
+}
+
 static int tpci200_register(struct tpci200_board *tpci200)
 {
 	int i;
@@ -283,33 +360,6 @@ out_disable_pci:
 	return res;
 }
 
-static int tpci200_free_irq(struct ipack_device *dev)
-{
-	struct slot_irq *slot_irq;
-	struct tpci200_board *tpci200;
-
-	tpci200 = check_slot(dev);
-	if (tpci200 == NULL)
-		return -EINVAL;
-
-	if (mutex_lock_interruptible(&tpci200->mutex))
-		return -ERESTARTSYS;
-
-	if (tpci200->slots[dev->slot].irq == NULL) {
-		mutex_unlock(&tpci200->mutex);
-		return -EINVAL;
-	}
-
-	tpci200_disable_irq(tpci200, dev->slot);
-	slot_irq = tpci200->slots[dev->slot].irq;
-	/* uninstall handler */
-	RCU_INIT_POINTER(tpci200->slots[dev->slot].irq, NULL);
-	synchronize_rcu();
-	kfree(slot_irq);
-	mutex_unlock(&tpci200->mutex);
-	return 0;
-}
-
 static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
 {
 	struct ipack_addr_space *virt_addr_space;
@@ -448,56 +498,6 @@ out_unlock:
 	return res;
 }
 
-static int tpci200_request_irq(struct ipack_device *dev, int vector,
-			       int (*handler)(void *), void *arg)
-{
-	int res = 0;
-	struct slot_irq *slot_irq;
-	struct tpci200_board *tpci200;
-
-	tpci200 = check_slot(dev);
-	if (tpci200 == NULL)
-		return -EINVAL;
-
-	if (mutex_lock_interruptible(&tpci200->mutex))
-		return -ERESTARTSYS;
-
-	if (tpci200->slots[dev->slot].irq != NULL) {
-		dev_err(&dev->dev,
-			"Slot [%d:%d] IRQ already registered !\n", dev->bus_nr,
-			dev->slot);
-		res = -EINVAL;
-		goto out_unlock;
-	}
-
-	slot_irq = kzalloc(sizeof(struct slot_irq), GFP_KERNEL);
-	if (slot_irq == NULL) {
-		dev_err(&dev->dev,
-			"Slot [%d:%d] unable to allocate memory for IRQ !\n",
-			dev->bus_nr, dev->slot);
-		res = -ENOMEM;
-		goto out_unlock;
-	}
-
-	/*
-	 * WARNING: Setup Interrupt Vector in the IndustryPack device
-	 * before an IRQ request.
-	 * Read the User Manual of your IndustryPack device to know
-	 * where to write the vector in memory.
-	 */
-	slot_irq->vector = vector;
-	slot_irq->handler = handler;
-	slot_irq->arg = arg;
-	slot_irq->holder = dev;
-
-	rcu_assign_pointer(tpci200->slots[dev->slot].irq, slot_irq);
-	tpci200_enable_irq(tpci200, dev->slot);
-
-out_unlock:
-	mutex_unlock(&tpci200->mutex);
-	return res;
-}
-
 static int tpci200_get_clockrate(struct ipack_device *dev)
 {
 	struct tpci200_board *tpci200 = check_slot(dev);
-- 
1.7.10.4

