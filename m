Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0LLTIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 14:08:41 -0500
Received: from smtp-out-063.synserver.de ([212.40.180.63]:1055 "HELO
	smtp-out-063.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753815Ab0LLTIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 14:08:40 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 2298
From: Lars-Peter Clausen <lars@metafoo.de>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: lethal@linux-sh.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2] mfd: Convert jz4740-adc to new irq_ methods
Date: Sun, 12 Dec 2010 20:08:30 +0100
Message-Id: <1292180910-22952-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1292172032-20463-1-git-send-email-lars@metafoo.de>
References: <1292172032-20463-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Convert the jz4740-adc driver to use the recently introduced IRQ API
variants which are passed struct irq_data rather than an IRQ number.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/mfd/jz4740-adc.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index 9dd1b33..0cc5979 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -84,31 +84,30 @@ static inline void jz4740_adc_irq_set_masked(struct jz4740_adc *adc, int irq,
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
-
-	irq -= adc->irq_base;
+	struct jz4740_adc *adc = irq_data_get_irq_chip_data(data);
+	unsigned int irq = data->irq - adc->irq_base;
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

