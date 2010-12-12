Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab0LLLqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 06:46:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55819 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751099Ab0LLLqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 06:46:32 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Convert jz4740-adc to new irq_ methods
Date: Sun, 12 Dec 2010 11:46:40 +0000
Message-Id: <1292154400-15759-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <4D03CE07.4050100@metafoo.de>
References: <4D03CE07.4050100@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the jz4740-adc driver to use the recently introduced IRQ API
variants which are passed struct irq_data rather than an IRQ number.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/jz4740-adc.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index 9dd1b33..7188c06 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -84,31 +84,31 @@ static inline void jz4740_adc_irq_set_masked(struct jz4740_adc *adc, int irq,
 	spin_unlock_irqrestore(&adc->lock, flags);
 }
 
-static void jz4740_adc_irq_mask(unsigned int irq)
+static void jz4740_adc_irq_mask(struct irq_data *data)
 {
-	struct jz4740_adc *adc = get_irq_chip_data(irq);
-	jz4740_adc_irq_set_masked(adc, irq, true);
+	struct jz4740_adc *adc = irq_data_get_irq_chip_data(data);
+	jz4740_adc_irq_set_masked(adc, data->irq, true);
 }
 
-static void jz4740_adc_irq_unmask(unsigned int irq)
+static void jz4740_adc_irq_unmask(struct irq_data *data)
 {
-	struct jz4740_adc *adc = get_irq_chip_data(irq);
-	jz4740_adc_irq_set_masked(adc, irq, false);
+	struct jz4740_adc *adc = irq_data_get_irq_chip_data(data);
+	jz4740_adc_irq_set_masked(adc, data->irq, false);
 }
 
-static void jz4740_adc_irq_ack(unsigned int irq)
+static void jz4740_adc_irq_ack(struct irq_data *data)
 {
-	struct jz4740_adc *adc = get_irq_chip_data(irq);
+	struct jz4740_adc *adc = irq_data_get_irq_chip_data(data);
 
-	irq -= adc->irq_base;
+	data->irq -= adc->irq_base;
 	writeb(BIT(irq), adc->base + JZ_REG_ADC_STATUS);
 }
 
 static struct irq_chip jz4740_adc_irq_chip = {
 	.name = "jz4740-adc",
-	.mask = jz4740_adc_irq_mask,
-	.unmask = jz4740_adc_irq_unmask,
-	.ack = jz4740_adc_irq_ack,
+	.irq_mask = jz4740_adc_irq_mask,
+	.irq_unmask = jz4740_adc_irq_unmask,
+	.irq_ack = jz4740_adc_irq_ack,
 };
 
 static void jz4740_adc_irq_demux(unsigned int irq, struct irq_desc *desc)
-- 
1.7.2.3

