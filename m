Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1KXV5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 16:57:11 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:52410 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab1KXV4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 16:56:55 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, robherring2@gmail.com,
        grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        plagnioj@jcrosoft.com, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/3] ARM: at91/aic: add device tree support for AIC
Date: Thu, 24 Nov 2011 22:56:27 +0100
Message-Id: <167b5ccfc31d9637186c5201cd83cb62df81fc0f.1322171620.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ioremap registers from DT specification and adding
of a simple irq domain for AIC interrupts.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 arch/arm/Kconfig         |    1 +
 arch/arm/mach-at91/irq.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 44789ef..293c152 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -318,6 +318,7 @@ config ARCH_AT91
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
 	select CLKDEV_LOOKUP
+	select IRQ_DOMAIN
 	help
 	  This enables support for systems based on the Atmel AT91RM9200,
 	  AT91SAM9 and AT91CAP9 processors.
diff --git a/arch/arm/mach-at91/irq.c b/arch/arm/mach-at91/irq.c
index be6b639..80783b0 100644
--- a/arch/arm/mach-at91/irq.c
+++ b/arch/arm/mach-at91/irq.c
@@ -24,6 +24,8 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/types.h>
+#include <linux/of_address.h>
+#include <linux/irqdomain.h>
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
@@ -34,6 +36,7 @@
 #include <asm/mach/map.h>
 
 void __iomem *at91_aic_base;
+static struct irq_domain at91_aic_domain;
 
 static void at91_aic_mask_irq(struct irq_data *d)
 {
@@ -127,14 +130,44 @@ static struct irq_chip at91_aic_chip = {
 	.irq_set_wake	= at91_aic_set_wake,
 };
 
+#if defined(CONFIG_OF)
+static struct of_device_id aic_ids[]  = {
+	{ .compatible = "atmel,at91rm9200-aic" },
+	{ /*sentinel*/ }
+};
+
+static int __init at91_aic_of_init(void)
+{
+	struct device_node *np;
+
+	np = of_find_matching_node(NULL, aic_ids);
+	if (np == NULL)
+		return -ENODEV;
+
+	at91_aic_base = of_iomap(np, 0);
+	at91_aic_domain.of_node = np;
+	/* Keep refcount of the node */
+
+	return 0;
+}
+#else
+static int __init at91_aic_of_init(void)
+{
+	return -ENOSYS;
+}
+#endif
+
 /*
  * Initialize the AIC interrupt controller.
  */
 void __init at91_aic_init(unsigned int priority[NR_AIC_IRQS])
 {
 	unsigned int i;
+	int ret;
 
-	at91_aic_base = ioremap(AT91_AIC, 512);
+	ret = at91_aic_of_init();
+	if (ret < 0)
+		at91_aic_base = ioremap(AT91_AIC, 512);
 
 	if (!at91_aic_base)
 		panic("Impossible to ioremap AT91_AIC\n");
@@ -169,4 +202,10 @@ void __init at91_aic_init(unsigned int priority[NR_AIC_IRQS])
 	/* Disable and clear all interrupts initially */
 	at91_aic_write(AT91_AIC_IDCR, 0xFFFFFFFF);
 	at91_aic_write(AT91_AIC_ICCR, 0xFFFFFFFF);
+
+	/* Add irq domain for AIC */
+	at91_aic_domain.irq_base = at91_aic_domain.hwirq_base = 0;
+	at91_aic_domain.nr_irq = NR_AIC_IRQS;
+	at91_aic_domain.ops = &irq_domain_simple_ops;
+	irq_domain_add(&at91_aic_domain);
 }
-- 
1.7.5.4

