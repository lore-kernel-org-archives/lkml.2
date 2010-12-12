Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab0LLMjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 07:39:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35232 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752602Ab0LLMjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 07:39:20 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Rapoport <mike@compulab.co.il>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Convert tps6586x driver to new irq_ API
Date: Sun, 12 Dec 2010 12:39:28 +0000
Message-Id: <1292157568-23220-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The genirq core is being updated to supply struct irq_data to irq_chip
operations rather than an irq number. Update the tps6586x driver to the
new APIs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/tps6586x.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index b4931ab..fe443d7 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -325,37 +325,37 @@ static int tps6586x_remove_subdevs(struct tps6586x *tps6586x)
 	return device_for_each_child(tps6586x->dev, NULL, __remove_subdev);
 }
 
-static void tps6586x_irq_lock(unsigned int irq)
+static void tps6586x_irq_lock(struct irq_data *data)
 {
-	struct tps6586x *tps6586x = get_irq_chip_data(irq);
+	struct tps6586x *tps6586x = irq_data_get_irq_chip_data(data);
 
 	mutex_lock(&tps6586x->irq_lock);
 }
 
-static void tps6586x_irq_enable(unsigned int irq)
+static void tps6586x_irq_enable(struct irq_data *irq_data)
 {
-	struct tps6586x *tps6586x = get_irq_chip_data(irq);
-	unsigned int __irq = irq - tps6586x->irq_base;
+	struct tps6586x *tps6586x = irq_data_get_irq_chip_data(irq_data);
+	unsigned int __irq = irq_data->irq - tps6586x->irq_base;
 	const struct tps6586x_irq_data *data = &tps6586x_irqs[__irq];
 
 	tps6586x->mask_reg[data->mask_reg] &= ~data->mask_mask;
 	tps6586x->irq_en |= (1 << __irq);
 }
 
-static void tps6586x_irq_disable(unsigned int irq)
+static void tps6586x_irq_disable(struct irq_data *irq_data)
 {
-	struct tps6586x *tps6586x = get_irq_chip_data(irq);
+	struct tps6586x *tps6586x = irq_data_get_irq_chip_data(irq_data);
 
-	unsigned int __irq = irq - tps6586x->irq_base;
+	unsigned int __irq = irq_data->irq - tps6586x->irq_base;
 	const struct tps6586x_irq_data *data = &tps6586x_irqs[__irq];
 
 	tps6586x->mask_reg[data->mask_reg] |= data->mask_mask;
 	tps6586x->irq_en &= ~(1 << __irq);
 }
 
-static void tps6586x_irq_sync_unlock(unsigned int irq)
+static void tps6586x_irq_sync_unlock(struct irq_data *data)
 {
-	struct tps6586x *tps6586x = get_irq_chip_data(irq);
+	struct tps6586x *tps6586x = irq_data_get_irq_chip_data(data);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(tps6586x->mask_reg); i++) {
@@ -421,10 +421,10 @@ static int __devinit tps6586x_irq_init(struct tps6586x *tps6586x, int irq,
 	tps6586x->irq_base = irq_base;
 
 	tps6586x->irq_chip.name = "tps6586x";
-	tps6586x->irq_chip.enable = tps6586x_irq_enable;
-	tps6586x->irq_chip.disable = tps6586x_irq_disable;
-	tps6586x->irq_chip.bus_lock = tps6586x_irq_lock;
-	tps6586x->irq_chip.bus_sync_unlock = tps6586x_irq_sync_unlock;
+	tps6586x->irq_chip.irq_enable = tps6586x_irq_enable;
+	tps6586x->irq_chip.irq_disable = tps6586x_irq_disable;
+	tps6586x->irq_chip.irq_bus_lock = tps6586x_irq_lock;
+	tps6586x->irq_chip.irq_bus_sync_unlock = tps6586x_irq_sync_unlock;
 
 	for (i = 0; i < ARRAY_SIZE(tps6586x_irqs); i++) {
 		int __irq = i + tps6586x->irq_base;
-- 
1.7.2.3

