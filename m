Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab1LTFBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 00:01:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61100 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1LTFAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 00:00:51 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 2/2] gpio-pch: Add the irq_disable/irq_enable hooks for pch irq chip
Date: Tue, 20 Dec 2011 13:58:53 +0900
Message-Id: <1324357133-16086-2-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1324357133-16086-1-git-send-email-tomoya.rohm@gmail.com>
References: <1324357133-16086-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also need the following patch for gpio-pch

commit f9ea14efa5277c47efec341dee2c408b6b80f854
Author: Feng Tang <feng.tang@intel.com>
Date:   Tue Dec 13 23:53:49 2011 +0800

    gpio-ml-ioh: fix a bug in the interrupt handler

    GPIO's irq action's dev_id is set to the first struct ioh_gpio chip,
    so when loop checking the 8 chips, the "chip" should be changed
    according.

    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Reported-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/gpio/gpio-pch.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index 01bd405..e80eedb 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -313,6 +313,34 @@ static void pch_irq_mask(struct irq_data *d)
 	iowrite32(1 << (d->irq - chip->irq_base), &chip->reg->imask);
 }
 
+static void pch_irq_disable(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct pch_gpio *chip = gc->private;
+	unsigned long flags;
+	u32 ien;
+
+	spin_lock_irqsave(&chip->spinlock, flags);
+	ien = ioread32(&chip->reg->ien);
+	ien &= ~(1 << (d->irq - chip->irq_base));
+	iowrite32(ien, &chip->reg->ien);
+	spin_unlock_irqrestore(&chip->spinlock, flags);
+}
+
+static void pch_irq_enable(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct pch_gpio *chip = gc->private;
+	unsigned long flags;
+	u32 ien;
+
+	spin_lock_irqsave(&chip->spinlock, flags);
+	ien = ioread32(&chip->reg->ien);
+	ien |= 1 << (d->irq - chip->irq_base);
+	iowrite32(ien, &chip->reg->ien);
+	spin_unlock_irqrestore(&chip->spinlock, flags);
+}
+
 static irqreturn_t pch_gpio_handler(int irq, void *dev_id)
 {
 	struct pch_gpio *chip = dev_id;
@@ -346,6 +374,8 @@ static __devinit void pch_gpio_alloc_generic_chip(struct pch_gpio *chip,
 	ct->chip.irq_mask = pch_irq_mask;
 	ct->chip.irq_unmask = pch_irq_unmask;
 	ct->chip.irq_set_type = pch_irq_type;
+	ct->chip.irq_disable = pch_irq_disable;
+	ct->chip.irq_enable = pch_irq_enable;
 
 	irq_setup_generic_chip(gc, IRQ_MSK(num), IRQ_GC_INIT_MASK_CACHE,
 			       IRQ_NOREQUEST | IRQ_NOPROBE, 0);
-- 
1.7.4.4

