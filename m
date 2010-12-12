Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab0LLMSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 07:18:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34940 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752576Ab0LLMSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 07:18:49 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ian Molton <spyro@f2s.com>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Convert t7166xb driver to new irq_ API
Date: Sun, 12 Dec 2010 12:18:58 +0000
Message-Id: <1292156338-19893-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The genirq core is being updated to pass struct irq_data rather than an
irq number to irq_chip operations. Update the t7166xb driver to the new
APIs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/t7l66xb.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index 006c121..9caeb4a 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -199,37 +199,37 @@ static void t7l66xb_irq(unsigned int irq, struct irq_desc *desc)
 				generic_handle_irq(irq_base + i);
 }
 
-static void t7l66xb_irq_mask(unsigned int irq)
+static void t7l66xb_irq_mask(struct irq_data *data)
 {
-	struct t7l66xb *t7l66xb = get_irq_chip_data(irq);
+	struct t7l66xb *t7l66xb = irq_data_get_irq_chip_data(data);
 	unsigned long			flags;
 	u8 imr;
 
 	spin_lock_irqsave(&t7l66xb->lock, flags);
 	imr = tmio_ioread8(t7l66xb->scr + SCR_IMR);
-	imr |= 1 << (irq - t7l66xb->irq_base);
+	imr |= 1 << (data->irq - t7l66xb->irq_base);
 	tmio_iowrite8(imr, t7l66xb->scr + SCR_IMR);
 	spin_unlock_irqrestore(&t7l66xb->lock, flags);
 }
 
-static void t7l66xb_irq_unmask(unsigned int irq)
+static void t7l66xb_irq_unmask(struct irq_data *data)
 {
-	struct t7l66xb *t7l66xb = get_irq_chip_data(irq);
+	struct t7l66xb *t7l66xb = irq_data_get_irq_chip_data(data);
 	unsigned long flags;
 	u8 imr;
 
 	spin_lock_irqsave(&t7l66xb->lock, flags);
 	imr = tmio_ioread8(t7l66xb->scr + SCR_IMR);
-	imr &= ~(1 << (irq - t7l66xb->irq_base));
+	imr &= ~(1 << (data->irq - t7l66xb->irq_base));
 	tmio_iowrite8(imr, t7l66xb->scr + SCR_IMR);
 	spin_unlock_irqrestore(&t7l66xb->lock, flags);
 }
 
 static struct irq_chip t7l66xb_chip = {
-	.name	= "t7l66xb",
-	.ack	= t7l66xb_irq_mask,
-	.mask	= t7l66xb_irq_mask,
-	.unmask	= t7l66xb_irq_unmask,
+	.name		= "t7l66xb",
+	.irq_ack	= t7l66xb_irq_mask,
+	.irq_mask	= t7l66xb_irq_mask,
+	.irq_unmask	= t7l66xb_irq_unmask,
 };
 
 /*--------------------------------------------------------------------------*/
-- 
1.7.2.3

