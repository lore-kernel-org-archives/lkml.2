Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab0LLMvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 07:51:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50825 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750854Ab0LLMve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 07:51:34 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Convert TWL4030 to new irq_ APIs
Date: Sun, 12 Dec 2010 12:51:39 +0000
Message-Id: <1292158299-25368-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The genirq core is being updated to pass struct irq_data to irq_chip
operations. Update the TWL4030 driver to the new APIs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/twl4030-irq.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 5d3a147..63a30e8 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -599,38 +599,38 @@ static void twl4030_sih_do_edge(struct work_struct *work)
  * completion, potentially including some re-ordering, of these requests.
  */
 
-static void twl4030_sih_mask(unsigned irq)
+static void twl4030_sih_mask(struct irq_data *data)
 {
-	struct sih_agent *sih = get_irq_chip_data(irq);
+	struct sih_agent *sih = irq_data_get_irq_chip_data(data);
 	unsigned long flags;
 
 	spin_lock_irqsave(&sih_agent_lock, flags);
-	sih->imr |= BIT(irq - sih->irq_base);
+	sih->imr |= BIT(data->irq - sih->irq_base);
 	sih->imr_change_pending = true;
 	queue_work(wq, &sih->mask_work);
 	spin_unlock_irqrestore(&sih_agent_lock, flags);
 }
 
-static void twl4030_sih_unmask(unsigned irq)
+static void twl4030_sih_unmask(struct irq_data *data)
 {
-	struct sih_agent *sih = get_irq_chip_data(irq);
+	struct sih_agent *sih = irq_data_get_irq_chip_data(data);
 	unsigned long flags;
 
 	spin_lock_irqsave(&sih_agent_lock, flags);
-	sih->imr &= ~BIT(irq - sih->irq_base);
+	sih->imr &= ~BIT(data->irq - sih->irq_base);
 	sih->imr_change_pending = true;
 	queue_work(wq, &sih->mask_work);
 	spin_unlock_irqrestore(&sih_agent_lock, flags);
 }
 
-static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
+static int twl4030_sih_set_type(struct irq_data *data, unsigned trigger)
 {
-	struct sih_agent *sih = get_irq_chip_data(irq);
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct sih_agent *sih = irq_data_get_irq_chip_data(data);
+	struct irq_desc *desc = irq_to_desc(data->irq);
 	unsigned long flags;
 
 	if (!desc) {
-		pr_err("twl4030: Invalid IRQ: %d\n", irq);
+		pr_err("twl4030: Invalid IRQ: %d\n", data->irq);
 		return -EINVAL;
 	}
 
@@ -641,7 +641,7 @@ static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
 	if ((desc->status & IRQ_TYPE_SENSE_MASK) != trigger) {
 		desc->status &= ~IRQ_TYPE_SENSE_MASK;
 		desc->status |= trigger;
-		sih->edge_change |= BIT(irq - sih->irq_base);
+		sih->edge_change |= BIT(data->irq - sih->irq_base);
 		queue_work(wq, &sih->edge_work);
 	}
 	spin_unlock_irqrestore(&sih_agent_lock, flags);
@@ -650,9 +650,9 @@ static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
 
 static struct irq_chip twl4030_sih_irq_chip = {
 	.name		= "twl4030",
-	.mask		= twl4030_sih_mask,
-	.unmask		= twl4030_sih_unmask,
-	.set_type	= twl4030_sih_set_type,
+	.irq_mask      	= twl4030_sih_mask,
+	.irq_unmask	= twl4030_sih_unmask,
+	.irq_set_type	= twl4030_sih_set_type,
 };
 
 /*----------------------------------------------------------------------*/
-- 
1.7.2.3

