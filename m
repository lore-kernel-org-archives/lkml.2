Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab0LLMBI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 07:01:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50741 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751316Ab0LLMBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 07:01:05 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rabin VINCENT <rabin.vincent@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Convert SMTPE driver to new irq_ APIs
Date: Sun, 12 Dec 2010 12:01:08 +0000
Message-Id: <1292155268-18246-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The genirq core is being updated to supply struct irq_data to irq_chip
operations rather than an irq number. Update the SMTPE driver to the new
APIs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/stmpe.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index b11487f..3e5732b 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -699,16 +699,16 @@ static irqreturn_t stmpe_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void stmpe_irq_lock(unsigned int irq)
+static void stmpe_irq_lock(struct irq_data *data)
 {
-	struct stmpe *stmpe = get_irq_chip_data(irq);
+	struct stmpe *stmpe = irq_data_get_irq_chip_data(data);
 
 	mutex_lock(&stmpe->irq_lock);
 }
 
-static void stmpe_irq_sync_unlock(unsigned int irq)
+static void stmpe_irq_sync_unlock(struct irq_data *data)
 {
-	struct stmpe *stmpe = get_irq_chip_data(irq);
+	struct stmpe *stmpe = irq_data_get_irq_chip_data(data);
 	struct stmpe_variant_info *variant = stmpe->variant;
 	int num = DIV_ROUND_UP(variant->num_irqs, 8);
 	int i;
@@ -727,20 +727,20 @@ static void stmpe_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&stmpe->irq_lock);
 }
 
-static void stmpe_irq_mask(unsigned int irq)
+static void stmpe_irq_mask(struct irq_data *data)
 {
-	struct stmpe *stmpe = get_irq_chip_data(irq);
-	int offset = irq - stmpe->irq_base;
+	struct stmpe *stmpe = irq_data_get_irq_chip_data(data);
+	int offset = data->irq - stmpe->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
 	stmpe->ier[regoffset] &= ~mask;
 }
 
-static void stmpe_irq_unmask(unsigned int irq)
+static void stmpe_irq_unmask(struct irq_data *data)
 {
-	struct stmpe *stmpe = get_irq_chip_data(irq);
-	int offset = irq - stmpe->irq_base;
+	struct stmpe *stmpe = irq_data_get_irq_chip_data(data);
+	int offset = data->irq - stmpe->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -749,10 +749,10 @@ static void stmpe_irq_unmask(unsigned int irq)
 
 static struct irq_chip stmpe_irq_chip = {
 	.name			= "stmpe",
-	.bus_lock		= stmpe_irq_lock,
-	.bus_sync_unlock	= stmpe_irq_sync_unlock,
-	.mask			= stmpe_irq_mask,
-	.unmask			= stmpe_irq_unmask,
+	.irq_bus_lock		= stmpe_irq_lock,
+	.irq_bus_sync_unlock	= stmpe_irq_sync_unlock,
+	.irq_mask		= stmpe_irq_mask,
+	.irq_unmask		= stmpe_irq_unmask,
 };
 
 static int __devinit stmpe_irq_init(struct stmpe *stmpe)
-- 
1.7.2.3

