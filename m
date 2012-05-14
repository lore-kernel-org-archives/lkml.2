Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab2ENW5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:57:07 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14210 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152Ab2ENW5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:57:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 14 May 2012 15:57:04 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: <linux-kernel@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH v4] mfd: tps65910-irq: Add devicetree init support
Date: Mon, 14 May 2012 18:55:42 -0400
Message-ID: <1337036142-10899-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change changes the tps65910-irq code to use irqdomain, and support
initialization from devicetree. This assumes that the irq_base in the platform
data is -1 if devicetree is used.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 v4: moved driver to use irq domains
 v3: no change from v2.
 v2: split off irq specific changes based on previous review comments

 drivers/mfd/Kconfig          |    1 +
 drivers/mfd/tps65910-irq.c   |   96 +++++++++++++++++++++++++++---------------
 include/linux/mfd/tps65910.h |    1 +
 3 files changed, 64 insertions(+), 34 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9846424..dcb51e4 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -191,6 +191,7 @@ config MFD_TPS65910
 	select MFD_CORE
 	select GPIO_TPS65910
 	select REGMAP_I2C
+	select IRQ_DOMAIN
 	help
 	  if you say yes here you get support for the TPS65910 series of
 	  Power Management chips.
diff --git a/drivers/mfd/tps65910-irq.c b/drivers/mfd/tps65910-irq.c
index c9ed5c0..2886166 100644
--- a/drivers/mfd/tps65910-irq.c
+++ b/drivers/mfd/tps65910-irq.c
@@ -20,15 +20,10 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/gpio.h>
 #include <linux/mfd/tps65910.h>
 
-static inline int irq_to_tps65910_irq(struct tps65910 *tps65910,
-							int irq)
-{
-	return (irq - tps65910->irq_base);
-}
-
 /*
  * This is a threaded IRQ handler so can access I2C/SPI.  Since all
  * interrupts are clear on read the IRQ line will be reasserted and
@@ -76,7 +71,7 @@ static irqreturn_t tps65910_irq(int irq, void *irq_data)
 		if (!(irq_sts & (1 << i)))
 			continue;
 
-		handle_nested_irq(tps65910->irq_base + i);
+		handle_nested_irq(irq_find_mapping(tps65910->domain, i));
 	}
 
 	/* Write the STS register back to clear IRQs we handled */
@@ -135,14 +130,14 @@ static void tps65910_irq_enable(struct irq_data *data)
 {
 	struct tps65910 *tps65910 = irq_data_get_irq_chip_data(data);
 
-	tps65910->irq_mask &= ~( 1 << irq_to_tps65910_irq(tps65910, data->irq));
+	tps65910->irq_mask &= ~(1 << data->hwirq);
 }
 
 static void tps65910_irq_disable(struct irq_data *data)
 {
 	struct tps65910 *tps65910 = irq_data_get_irq_chip_data(data);
 
-	tps65910->irq_mask |= ( 1 << irq_to_tps65910_irq(tps65910, data->irq));
+	tps65910->irq_mask |= (1 << data->hwirq);
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -164,10 +159,35 @@ static struct irq_chip tps65910_irq_chip = {
 	.irq_set_wake = tps65910_irq_set_wake,
 };
 
+static int tps65910_irq_map(struct irq_domain *h, unsigned int virq,
+				irq_hw_number_t hw)
+{
+	struct tps65910 *tps65910 = h->host_data;
+
+	irq_set_chip_data(virq, tps65910);
+	irq_set_chip_and_handler(virq, &tps65910_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(virq, 1);
+
+	/* ARM needs us to explicitly flag the IRQ as valid
+	 * and will set them noprobe when we do so. */
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	irq_set_noprobe(virq);
+#endif
+
+	return 0;
+}
+
+static struct irq_domain_ops tps65910_domain_ops = {
+	.map	= tps65910_irq_map,
+	.xlate	= irq_domain_xlate_twocell,
+};
+
 int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 		    struct tps65910_platform_data *pdata)
 {
-	int ret, cur_irq;
+	int ret;
 	int flags = IRQF_ONESHOT;
 
 	if (!irq) {
@@ -175,17 +195,11 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 		return -EINVAL;
 	}
 
-	if (!pdata || !pdata->irq_base) {
-		dev_warn(tps65910->dev, "No interrupt support, no IRQ base\n");
+	if (!pdata) {
+		dev_warn(tps65910->dev, "No interrupt support, no pdata\n");
 		return -EINVAL;
 	}
 
-	tps65910->irq_mask = 0xFFFFFF;
-
-	mutex_init(&tps65910->irq_lock);
-	tps65910->chip_irq = irq;
-	tps65910->irq_base = pdata->irq_base;
-
 	switch (tps65910_chip_id(tps65910)) {
 	case TPS65910:
 		tps65910->irq_num = TPS65910_NUM_IRQ;
@@ -195,22 +209,36 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 		break;
 	}
 
-	/* Register with genirq */
-	for (cur_irq = tps65910->irq_base;
-	     cur_irq < tps65910->irq_num + tps65910->irq_base;
-	     cur_irq++) {
-		irq_set_chip_data(cur_irq, tps65910);
-		irq_set_chip_and_handler(cur_irq, &tps65910_irq_chip,
-					 handle_edge_irq);
-		irq_set_nested_thread(cur_irq, 1);
-
-		/* ARM needs us to explicitly flag the IRQ as valid
-		 * and will set them noprobe when we do so. */
-#ifdef CONFIG_ARM
-		set_irq_flags(cur_irq, IRQF_VALID);
-#else
-		irq_set_noprobe(cur_irq);
-#endif
+	if (pdata->irq_base > 0) {
+		pdata->irq_base = irq_alloc_descs(pdata->irq_base, 0,
+					tps65910->irq_num, -1);
+		if (pdata->irq_base < 0) {
+			dev_warn(tps65910->dev, "Failed to alloc IRQs: %d\n",
+					pdata->irq_base);
+			return pdata->irq_base;
+		}
+	}
+
+	tps65910->irq_mask = 0xFFFFFF;
+
+	mutex_init(&tps65910->irq_lock);
+	tps65910->chip_irq = irq;
+	tps65910->irq_base = pdata->irq_base;
+
+	if (pdata->irq_base > 0)
+		tps65910->domain = irq_domain_add_legacy(tps65910->dev->of_node,
+					tps65910->irq_num,
+					pdata->irq_base,
+					0,
+					&tps65910_domain_ops, tps65910);
+	else
+		tps65910->domain = irq_domain_add_linear(tps65910->dev->of_node,
+					tps65910->irq_num,
+					&tps65910_domain_ops, tps65910);
+
+	if (!tps65910->domain) {
+		dev_err(tps65910->dev, "Failed to create IRQ domain\n");
+		return -ENOMEM;
 	}
 
 	ret = request_threaded_irq(irq, NULL, tps65910_irq, flags,
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 56903ad..18a7e0f 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -840,6 +840,7 @@ struct tps65910 {
 	int irq_base;
 	int irq_num;
 	u32 irq_mask;
+	struct irq_domain *domain;
 };
 
 struct tps65910_platform_data {
-- 
1.7.0.4

