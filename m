Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2FRJC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:02:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63415 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab2FRJC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:02:57 -0400
Message-ID: <4FDEEEBD.5070108@linaro.org>
Date: Mon, 18 Jun 2012 10:02:53 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linus.walleij@stericsson.com, arnd@arndb.de,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 08/14] mfd: Add IRQ domain support for the AB8500
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-9-git-send-email-lee.jones@linaro.org> <20120614183231.GA30185@sirena.org.uk>
In-Reply-To: <20120614183231.GA30185@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do this look better to you Mark?

From: Lee Jones <lee.jones@linaro.org>
Date: Sat, 26 May 2012 06:54:04 +0100
Subject: [PATCH 1/1] mfd: Add IRQ domain support for the AB8500

As the AB8500 is an IRQ controller in its own right, here we provide
the AB8500 driver with IRQ domain support. This is required if we wish
to reference any of its IRQs from a platform's Device Tree.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/Kconfig               |    1 +
 drivers/mfd/ab8500-core.c         |  114 ++++++++++++++++++++-----------------
 include/linux/mfd/abx500/ab8500.h |    5 ++
 3 files changed, 69 insertions(+), 51 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 170072e..e3637c2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -696,6 +696,7 @@ config AB8500_CORE
 	bool "ST-Ericsson AB8500 Mixed Signal Power Management chip"
 	depends on GENERIC_HARDIRQS && ABX500_CORE && MFD_DB8500_PRCMU
 	select MFD_CORE
+	select IRQ_DOMAIN
 	help
 	  Select this option to enable access to AB8500 power management
 	  chip. This connects to U8500 either on the SSP/SPI bus (deprecated
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 4dc5024..47bf8aa 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
@@ -361,7 +362,7 @@ static void ab8500_irq_sync_unlock(struct irq_data *data)
 static void ab8500_irq_mask(struct irq_data *data)
 {
 	struct ab8500 *ab8500 = irq_data_get_irq_chip_data(data);
-	int offset = data->irq - ab8500->irq_base;
+	int offset = data->irq;
 	int index = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -371,7 +372,7 @@ static void ab8500_irq_mask(struct irq_data *data)
 static void ab8500_irq_unmask(struct irq_data *data)
 {
 	struct ab8500 *ab8500 = irq_data_get_irq_chip_data(data);
-	int offset = data->irq - ab8500->irq_base;
+	int offset = data->irq;
 	int index = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -501,7 +502,7 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
 			int bit = __ffs(value);
 			int line = i * 8 + bit;
 
-			handle_nested_irq(ab8500->irq_base + line);
+			handle_nested_irq(line);
 			value &= ~(1 << bit);
 
 		} while (value);
@@ -510,38 +511,51 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-static int ab8500_irq_init(struct ab8500 *ab8500)
+/**
+ * ab8500_irq_get_virq(): Map an interrupt on a chip to a virtual IRQ
+ *
+ * @ab8500: ab8500_irq controller to operate on.
+ * @irq: index of the interrupt requested in the chip IRQs
+ *
+ * Useful for drivers to request their own IRQs.
+ */
+int ab8500_irq_get_virq(struct ab8500 *ab8500, int irq)
 {
-	int base = ab8500->irq_base;
-	int irq;
-	int num_irqs;
+	if (!ab8500)
+		return -EINVAL;
 
-	if (is_ab9540(ab8500))
-		num_irqs = AB9540_NR_IRQS;
-	else if (is_ab8505(ab8500))
-		num_irqs = AB8505_NR_IRQS;
-	else
-		num_irqs = AB8500_NR_IRQS;
+	return irq_create_mapping(ab8500->domain, irq);
+}
+EXPORT_SYMBOL_GPL(ab8500_irq_get_virq);
+
+static int ab8500_irq_map(struct irq_domain *d, unsigned int virq,
+				irq_hw_number_t hwirq)
+{
+	struct ab8500 *ab8500 = d->host_data;
 
-	for (irq = base; irq < base + num_irqs; irq++) {
-		irq_set_chip_data(irq, ab8500);
-		irq_set_chip_and_handler(irq, &ab8500_irq_chip,
-					 handle_simple_irq);
-		irq_set_nested_thread(irq, 1);
+	if (!ab8500)
+		return -EINVAL;
+
+	irq_set_chip_data(virq, ab8500);
+	irq_set_chip_and_handler(virq, &ab8500_irq_chip,
+				handle_simple_irq);
+	irq_set_nested_thread(virq, 1);
 #ifdef CONFIG_ARM
-		set_irq_flags(irq, IRQF_VALID);
+	set_irq_flags(virq, IRQF_VALID);
 #else
-		irq_set_noprobe(irq);
+	irq_set_noprobe(virq);
 #endif
-	}
 
 	return 0;
 }
 
-static void ab8500_irq_remove(struct ab8500 *ab8500)
+static struct irq_domain_ops ab8500_irq_ops = {
+        .map    = ab8500_irq_map,
+        .xlate  = irq_domain_xlate_twocell,
+};
+
+static int ab8500_irq_init(struct ab8500 *ab8500, struct device_node *np)
 {
-	int base = ab8500->irq_base;
-	int irq;
 	int num_irqs;
 
 	if (is_ab9540(ab8500))
@@ -551,13 +565,22 @@ static void ab8500_irq_remove(struct ab8500 *ab8500)
 	else
 		num_irqs = AB8500_NR_IRQS;
 
-	for (irq = base; irq < base + num_irqs; irq++) {
-#ifdef CONFIG_ARM
-		set_irq_flags(irq, 0);
-#endif
-		irq_set_chip_and_handler(irq, NULL, NULL);
-		irq_set_chip_data(irq, NULL);
+	if (ab8500->irq_base) {
+		ab8500->domain = irq_domain_add_legacy(
+			NULL, num_irqs, ab8500->irq_base,
+			0, &ab8500_irq_ops, ab8500);
+	}
+	else {
+		ab8500->domain = irq_domain_add_linear(
+			np, num_irqs, &ab8500_irq_ops, ab8500);
+	}
+
+	if (!ab8500->domain) {
+		dev_err(ab8500->dev, "Failed to create irqdomain\n");
+		return -ENOSYS;
 	}
+
+	return 0;
 }
 
 int ab8500_suspend(struct ab8500 *ab8500)
@@ -1233,14 +1256,6 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 
 	if (plat)
 		ab8500->irq_base = plat->irq_base;
-	else if (np)
-		ret = of_property_read_u32(np, "stericsson,irq-base", &ab8500->irq_base);
-
-	if (!ab8500->irq_base) {
-		dev_info(&pdev->dev, "couldn't find irq-base\n");
-		ret = -EINVAL;
-		goto out_free_ab8500;
-	}
 
 	ab8500->dev = &pdev->dev;
 
@@ -1323,7 +1338,7 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 		AB8500_SWITCH_OFF_STATUS, &value);
 	if (ret < 0)
 		return ret;
-	dev_info(ab8500->dev, "switch off status: %#x", value);
+	dev_info(ab8500->dev, "switch off status: %#x\n", value);
 
 	if (plat && plat->init)
 		plat->init(ab8500);
@@ -1352,8 +1367,8 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 	for (i = 0; i < ab8500->mask_size; i++)
 		ab8500->mask[i] = ab8500->oldmask[i] = 0xff;
 
-	if (ab8500->irq_base) {
-		ret = ab8500_irq_init(ab8500);
+	if (ab8500->irq_base || np) {
+		ret = ab8500_irq_init(ab8500, np);
 		if (ret)
 			goto out_freeoldmask;
 
@@ -1370,7 +1385,7 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 					IRQF_ONESHOT | IRQF_NO_SUSPEND,
 					"ab8500", ab8500);
 		if (ret)
-			goto out_removeirq;
+			goto out_freeoldmask;
 	}
 
 	if (!np) {
@@ -1417,15 +1432,12 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 					&ab8500_attr_group);
 	if (ret)
 		dev_err(ab8500->dev, "error creating sysfs entries\n");
-	else
-		return ret;
+
+	return ret;
 
 out_freeirq:
-	if (ab8500->irq_base)
+	if (ab8500->irq_base || np)
 		free_irq(ab8500->irq, ab8500);
-out_removeirq:
-	if (ab8500->irq_base)
-		ab8500_irq_remove(ab8500);
 out_freeoldmask:
 	kfree(ab8500->oldmask);
 out_freemask:
@@ -1439,16 +1451,16 @@ out_free_ab8500:
 static int __devexit ab8500_remove(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = platform_get_drvdata(pdev);
+	struct device_node *np = pdev->dev.of_node;
 
 	if (is_ab9540(ab8500))
 		sysfs_remove_group(&ab8500->dev->kobj, &ab9540_attr_group);
 	else
 		sysfs_remove_group(&ab8500->dev->kobj, &ab8500_attr_group);
 	mfd_remove_devices(ab8500->dev);
-	if (ab8500->irq_base) {
+	if (ab8500->irq_base || np)
 		free_irq(ab8500->irq, ab8500);
-		ab8500_irq_remove(ab8500);
-	}
+
 	kfree(ab8500->oldmask);
 	kfree(ab8500->mask);
 	kfree(ab8500);
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 91dd3ef..4ae2cd9 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -9,6 +9,7 @@
 
 #include <linux/atomic.h>
 #include <linux/mutex.h>
+#include <linux/irqdomain.h>
 
 struct device;
 
@@ -227,6 +228,7 @@ enum ab8500_version {
  * @irq_lock: genirq bus lock
  * @transfer_ongoing: 0 if no transfer ongoing
  * @irq: irq line
+ * @irq_domain: irq domain
  * @version: chip version id (e.g. ab8500 or ab9540)
  * @chip_id: chip revision id
  * @write: register write
@@ -247,6 +249,7 @@ struct ab8500 {
 	atomic_t	transfer_ongoing;
 	int		irq_base;
 	int		irq;
+	struct irq_domain  *domain;
 	enum ab8500_version version;
 	u8		chip_id;
 
@@ -336,4 +339,6 @@ static inline int is_ab8500_2p0(struct ab8500 *ab)
 	return (is_ab8500(ab) && (ab->chip_id == AB8500_CUT2P0));
 }
 
+int ab8500_irq_get_virq(struct ab8500 *ab8500, int irq);
+
 #endif /* MFD_AB8500_H */
-- 
1.7.9.5
