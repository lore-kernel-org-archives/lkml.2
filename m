Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab1ISSrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:47:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:57018 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab1ISSro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:47:44 -0400
Date: Mon, 19 Sep 2011 20:47:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] irq fixes for 3.1
Message-ID: <alpine.LFD.2.02.1109192045410.2723@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://tesla.tglx.de/git/linux-2.6-tip irq-fixes-for-linus

Thanks,

	tglx

------------------>
Geert Uytterhoeven (1):
      genirq: Make irq_shutdown() symmetric vs. irq_startup again

Thomas Gleixner (1):
      x86, iommu: Mark DMAR IRQ as non-threaded


 drivers/iommu/dmar.c |    2 +-
 kernel/irq/chip.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 3dc9bef..6dcc7e2 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1388,7 +1388,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
 		return ret;
 	}
 
-	ret = request_irq(irq, dmar_fault, 0, iommu->name, iommu);
+	ret = request_irq(irq, dmar_fault, IRQF_NO_THREAD, iommu->name, iommu);
 	if (ret)
 		printk(KERN_ERR "IOMMU: can't request irq\n");
 	return ret;
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index d5a3009..dc5114b 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -178,7 +178,7 @@ void irq_shutdown(struct irq_desc *desc)
 	desc->depth = 1;
 	if (desc->irq_data.chip->irq_shutdown)
 		desc->irq_data.chip->irq_shutdown(&desc->irq_data);
-	if (desc->irq_data.chip->irq_disable)
+	else if (desc->irq_data.chip->irq_disable)
 		desc->irq_data.chip->irq_disable(&desc->irq_data);
 	else
 		desc->irq_data.chip->irq_mask(&desc->irq_data);
