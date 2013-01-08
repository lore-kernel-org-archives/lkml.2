Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab3AHVIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:08:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:45970 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab3AHVIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243605124"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 17/21] mei: use non cached hcsr for interrupt enablement
Date: Tue,  8 Jan 2013 23:07:28 +0200
Message-Id: <1357679252-12958-18-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c     |   17 +++++++++++------
 drivers/misc/mei/interrupt.c |    2 +-
 drivers/misc/mei/main.c      |    2 --
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index ec4ab89..ed61659 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -106,8 +106,9 @@ void mei_hcsr_set(struct mei_device *dev)
  */
 void mei_clear_interrupts(struct mei_device *dev)
 {
-	if ((dev->host_hw_state & H_IS) == H_IS)
-		mei_reg_write(dev, H_CSR, dev->host_hw_state);
+	u32 hcsr = mei_hcsr_read(dev);
+	if ((hcsr & H_IS) == H_IS)
+		mei_reg_write(dev, H_CSR, hcsr);
 }
 
 /**
@@ -117,8 +118,10 @@ void mei_clear_interrupts(struct mei_device *dev)
  */
 void mei_enable_interrupts(struct mei_device *dev)
 {
-	dev->host_hw_state |= H_IE;
-	mei_hcsr_set(dev);
+	u32 hcsr = mei_hcsr_read(dev);
+	hcsr |= H_IE;
+	hcsr &= ~H_IS;
+	mei_reg_write(dev, H_CSR, hcsr);
 }
 
 /**
@@ -128,8 +131,10 @@ void mei_enable_interrupts(struct mei_device *dev)
  */
 void mei_disable_interrupts(struct mei_device *dev)
 {
-	dev->host_hw_state &= ~H_IE;
-	mei_hcsr_set(dev);
+	u32 hcsr = mei_hcsr_read(dev);
+	hcsr  &= ~H_IE;
+	hcsr &= ~H_IS;
+	mei_reg_write(dev, H_CSR, hcsr);
 }
 
 /**
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index d1ef926..d7e1b79 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -691,7 +691,6 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 	/* initialize our complete list */
 	mutex_lock(&dev->device_lock);
 	mei_io_list_init(&complete_list);
-	dev->host_hw_state = mei_hcsr_read(dev);
 
 	/* Ack the interrupt here
 	 * In case of MSI we don't go through the quick handler */
@@ -710,6 +709,7 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
+	dev->host_hw_state = mei_hcsr_read(dev);
 	/*  check if we need to start the dev */
 	if ((dev->host_hw_state & H_RDY) == 0) {
 		if ((dev->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA) {
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index ec5fd7a..f72bb77 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -915,8 +915,6 @@ static int mei_probe(struct pci_dev *pdev,
 	return 0;
 
 release_irq:
-	/* disable interrupts */
-	dev->host_hw_state = mei_hcsr_read(dev);
 	mei_disable_interrupts(dev);
 	flush_scheduled_work();
 	free_irq(pdev->irq, dev);
-- 
1.7.4.4

