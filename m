Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab1LMPxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:53:18 -0500
Received: from mga14.intel.com ([143.182.124.37]:3434 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab1LMPxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:53:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85223355"
From: Feng Tang <feng.tang@intel.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        tomoya-linux@dsn.lapis-semi.com, linux-kernel@vger.kernel.org
Cc: joel.clark@intel.com, ying.huang@intel.com, qi.wang@intel.com,
        kok.howg.ewe@intel.com, Feng Tang <feng.tang@intel.com>
Subject: [PATCH 2/2] gpio-ml-ioh: Add the irq_disable/irq_enable hooks for ml-ioh irq chip
Date: Tue, 13 Dec 2011 23:53:50 +0800
Message-Id: <1323791630-4125-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1323791630-4125-1-git-send-email-feng.tang@intel.com>
References: <1323791630-4125-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These hooks will be needed by the general disabl/enable_irq();

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/gpio/gpio-ml-ioh.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index 92b6f51..461958f 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -332,6 +332,34 @@ static void ioh_irq_mask(struct irq_data *d)
 		  &chip->reg->regs[chip->ch].imask);
 }
 
+static void ioh_irq_disable(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct ioh_gpio *chip = gc->private;
+	unsigned long flags;
+	u32 ien;
+
+	spin_lock_irqsave(&chip->spinlock, flags);
+	ien = ioread32(&chip->reg->regs[chip->ch].ien);
+	ien &= ~(1 << (d->irq - chip->irq_base));
+	iowrite32(ien, &chip->reg->regs[chip->ch].ien);
+	spin_unlock_irqrestore(&chip->spinlock, flags);
+}
+
+static void ioh_irq_enable(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct ioh_gpio *chip = gc->private;
+	unsigned long flags;
+	u32 ien;
+
+	spin_lock_irqsave(&chip->spinlock, flags);
+	ien = ioread32(&chip->reg->regs[chip->ch].ien);
+	ien |= 1 << (d->irq - chip->irq_base);
+	iowrite32(ien, &chip->reg->regs[chip->ch].ien);
+	spin_unlock_irqrestore(&chip->spinlock, flags);
+}
+
 static irqreturn_t ioh_gpio_handler(int irq, void *dev_id)
 {
 	struct ioh_gpio *chip = dev_id;
@@ -370,6 +398,8 @@ static __devinit void ioh_gpio_alloc_generic_chip(struct ioh_gpio *chip,
 	ct->chip.irq_mask = ioh_irq_mask;
 	ct->chip.irq_unmask = ioh_irq_unmask;
 	ct->chip.irq_set_type = ioh_irq_type;
+	ct->chip.irq_disable = ioh_irq_disable;
+	ct->chip.irq_enable = ioh_irq_enable;
 
 	irq_setup_generic_chip(gc, IRQ_MSK(num), IRQ_GC_INIT_MASK_CACHE,
 			       IRQ_NOREQUEST | IRQ_NOPROBE, 0);
-- 
1.7.1

