Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369Ab2ILNDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:03:43 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:16819 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079Ab2ILMzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBSdSECAxVwYTiBG8YpFSA5VfiTOJVA
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511745"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 10/24] Staging: ipack/bridges/tpci200: RCU protect slot_irq pointers.
Date: Wed, 12 Sep 2012 14:55:32 +0200
Message-Id: <1347454546-23236-10-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

In tpci200_request_irq as well as tpci200_free_irq we set and unset the
pointer to struct slot_irq.  This pointer is accessed in
tpci200_interrupt.  To ensure that the pointer is not freed after it has
been fetched in tpci200_interrupt() it is now protected through RCU.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 24e2a11..9ce577a 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -132,10 +132,11 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 
 	if (status_reg & TPCI200_SLOT_INT_MASK) {
 		/* callback to the IRQ handler for the corresponding slot */
+		rcu_read_lock();
 		for (i = 0; i < TPCI200_NB_SLOT; i++) {
 			if (!(status_reg & ((TPCI200_A_INT0 | TPCI200_A_INT1) << (2*i))))
 				continue;
-			slot_irq = tpci200->slots[i].irq;
+			slot_irq = rcu_dereference(tpci200->slots[i].irq);
 			if (slot_irq) {
 				ret = tpci200_slot_irq(slot_irq);
 			} else {
@@ -147,6 +148,7 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 					TPCI200_INT0_EN | TPCI200_INT1_EN);
 			}
 		}
+		rcu_read_unlock();
 	}
 
 	return ret;
@@ -303,9 +305,9 @@ static int tpci200_free_irq(struct ipack_device *dev)
 
 	__tpci200_free_irq(tpci200, dev);
 	slot_irq = tpci200->slots[dev->slot].irq;
-	tpci200->slots[dev->slot].irq = NULL;
+	RCU_INIT_POINTER(tpci200->slots[dev->slot].irq, NULL);
+	synchronize_rcu();
 	kfree(slot_irq);
-
 	mutex_unlock(&tpci200->mutex);
 	return 0;
 }
@@ -490,7 +492,7 @@ static int tpci200_request_irq(struct ipack_device *dev, int vector,
 	slot_irq->arg = arg;
 	slot_irq->holder = dev;
 
-	tpci200->slots[dev->slot].irq = slot_irq;
+	rcu_assign_pointer(tpci200->slots[dev->slot].irq, slot_irq);
 	res = __tpci200_request_irq(tpci200, dev);
 
 out_unlock:
-- 
1.7.10.4

