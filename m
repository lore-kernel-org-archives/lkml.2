Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0LLMeO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 07:34:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34106 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750993Ab0LLMeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 07:34:13 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Vasut <marek.vasut@gmail.com>, Ian Molton <ian@mnementh.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Convert tc6393xb driver to new irq_ APIs
Date: Sun, 12 Dec 2010 12:34:04 +0000
Message-Id: <1292157244-21679-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The genirq core is being update to pass struct irq_data to irq_chip rather
than an irq number to operations. Update tc6393 to the new API.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/tc6393xb.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 1ea80d8a..9a23863 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -527,41 +527,41 @@ tc6393xb_irq(unsigned int irq, struct irq_desc *desc)
 		}
 }
 
-static void tc6393xb_irq_ack(unsigned int irq)
+static void tc6393xb_irq_ack(struct irq_data *data)
 {
 }
 
-static void tc6393xb_irq_mask(unsigned int irq)
+static void tc6393xb_irq_mask(struct irq_data *data)
 {
-	struct tc6393xb *tc6393xb = get_irq_chip_data(irq);
+	struct tc6393xb *tc6393xb = irq_data_get_irq_chip_data(data);
 	unsigned long flags;
 	u8 imr;
 
 	spin_lock_irqsave(&tc6393xb->lock, flags);
 	imr = tmio_ioread8(tc6393xb->scr + SCR_IMR);
-	imr |= 1 << (irq - tc6393xb->irq_base);
+	imr |= 1 << (data->irq - tc6393xb->irq_base);
 	tmio_iowrite8(imr, tc6393xb->scr + SCR_IMR);
 	spin_unlock_irqrestore(&tc6393xb->lock, flags);
 }
 
-static void tc6393xb_irq_unmask(unsigned int irq)
+static void tc6393xb_irq_unmask(struct irq_data *data)
 {
-	struct tc6393xb *tc6393xb = get_irq_chip_data(irq);
+	struct tc6393xb *tc6393xb = irq_data_get_irq_chip_data(data);
 	unsigned long flags;
 	u8 imr;
 
 	spin_lock_irqsave(&tc6393xb->lock, flags);
 	imr = tmio_ioread8(tc6393xb->scr + SCR_IMR);
-	imr &= ~(1 << (irq - tc6393xb->irq_base));
+	imr &= ~(1 << (data->irq - tc6393xb->irq_base));
 	tmio_iowrite8(imr, tc6393xb->scr + SCR_IMR);
 	spin_unlock_irqrestore(&tc6393xb->lock, flags);
 }
 
 static struct irq_chip tc6393xb_chip = {
-	.name	= "tc6393xb",
-	.ack	= tc6393xb_irq_ack,
-	.mask	= tc6393xb_irq_mask,
-	.unmask	= tc6393xb_irq_unmask,
+	.name		= "tc6393xb",
+	.irq_ack	= tc6393xb_irq_ack,
+	.irq_mask	= tc6393xb_irq_mask,
+	.irq_unmask	= tc6393xb_irq_unmask,
 };
 
 static void tc6393xb_attach_irq(struct platform_device *dev)
-- 
1.7.2.3

