Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab2BQJ2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:28:33 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:58026 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab2BQJ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:28:28 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org
Cc: tglx@linutronix.de, avictor.za@gmail.com, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91: AIC and GPIO IRQ device tree initilization
Date: Fri, 17 Feb 2012 10:27:58 +0100
Message-Id: <1329470878-14635-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both AIC and GPIO controllers are now using the standard of_irq_init()
function to initialize IRQs in case of DT use.
The DT specific initialization functions are now separated from the
non-DT case and are now using "linear" irq domains.
The .map() irqdomain operation is responsible for positioning the IRQ
handlers. In AIC case, the Linux IRQ number is directly programmed in
the hardware to avoid an additional reverse mapping operation.
The AIC position its irq domain as the "default" irq domain.

For DT case, the priority is not yet filled in the SMR. It will be the
subject of another patch.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi,

This patch goes on top of previous series:
"[PATCH 0/9] ARM: at91: irqdomain and device tree for AIC and GPIO"
(which goes on top of Grant's "irq_domain generalization and rework").

It should address all advices by Rob Herring and I hope it is the best
way to deal with irq domains in all DT/non-DT cases.

A simple concern is that the IRQ latency may be bigger because of the
irq_create_mapping() call in .to_irq(). This is called in the hot path
of GPIO IRQ handler...

Best regards,


 arch/arm/mach-at91/board-dt.c |   11 +++-
 arch/arm/mach-at91/generic.h  |    6 ++
 arch/arm/mach-at91/gpio.c     |  124 +++++++++++++++++++++++++++++++----------
 arch/arm/mach-at91/irq.c      |   92 ++++++++++++++++++++-----------
 4 files changed, 171 insertions(+), 62 deletions(-)

diff --git a/arch/arm/mach-at91/board-dt.c b/arch/arm/mach-at91/board-dt.c
index 6120978..e0df4e5 100644
--- a/arch/arm/mach-at91/board-dt.c
+++ b/arch/arm/mach-at91/board-dt.c
@@ -15,6 +15,8 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/gpio.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 
 #include <mach/hardware.h>
@@ -86,9 +88,16 @@ static void __init ek_add_device_nand(void)
 	at91_add_device_nand(&ek_nand_data);
 }
 
+static const struct of_device_id irq_of_match[] __initconst = {
+
+	{ .compatible = "atmel,at91rm9200-aic", .data = at91_aic_of_init },
+	{ .compatible = "atmel,at91rm9200-gpio", .data = at91_gpio_of_irq_setup },
+	{ /*sentinel*/ }
+};
+
 static void __init at91_dt_init_irq(void)
 {
-	at91_init_irq_default();
+	of_irq_init(irq_of_match);
 }
 
 static void __init at91_dt_device_init(void)
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 78cd605..c5d16e5 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -9,6 +9,7 @@
  */
 
 #include <linux/clkdev.h>
+#include <linux/of.h>
 
  /* Map io */
 extern void __init at91_map_io(void);
@@ -25,6 +26,9 @@ extern void __init at91_init_irq_default(void);
 extern void __init at91_init_interrupts(unsigned int priority[]);
 extern void __init at91x40_init_interrupts(unsigned int priority[]);
 extern void __init at91_aic_init(unsigned int priority[]);
+extern int  __init at91_aic_of_init(struct device_node *node,
+				    struct device_node *parent);
+
 
  /* Timer */
 struct sys_timer;
@@ -75,5 +79,7 @@ struct at91_gpio_bank {
 };
 extern void __init at91_gpio_init(struct at91_gpio_bank *, int nr_banks);
 extern void __init at91_gpio_irq_setup(void);
+extern int  __init at91_gpio_of_irq_setup(struct device_node *node,
+					  struct device_node *parent);
 
 extern int at91_extern_irq;
diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
index fbcb47e..64395a5 100644
--- a/arch/arm/mach-at91/gpio.c
+++ b/arch/arm/mach-at91/gpio.c
@@ -27,6 +27,7 @@
 #include <linux/irqdomain.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/of_gpio.h>
 
 #include <mach/hardware.h>
 #include <mach/at91_pio.h>
@@ -37,6 +38,7 @@ struct at91_gpio_chip {
 	struct gpio_chip	chip;
 	struct at91_gpio_chip	*next;		/* Bank sharing same clock */
 	int			pioc_hwirq;	/* PIO bank interrupt identifier on AIC */
+	int			pioc_virq;	/* PIO bank Linux virtual interrupt */
 	int			pioc_idx;	/* PIO bank index */
 	void __iomem		*regbase;	/* PIO bank virtual address */
 	struct clk		*clock;		/* associated clock */
@@ -295,7 +297,7 @@ static int gpio_irq_set_wake(struct irq_data *d, unsigned state)
 	else
 		wakeups[bank] &= ~mask;
 
-	irq_set_irq_wake(gpio_chip[bank].pioc_hwirq, state);
+	irq_set_irq_wake(at91_gpio->pioc_virq, state);
 
 	return 0;
 }
@@ -397,12 +399,12 @@ static struct irq_chip gpio_irqchip = {
 
 static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 {
-	unsigned	virq;
 	struct irq_data *idata = irq_desc_get_irq_data(desc);
 	struct irq_chip *chip = irq_data_get_irq_chip(idata);
 	struct at91_gpio_chip *at91_gpio = irq_data_get_irq_chip_data(idata);
 	void __iomem	*pio = at91_gpio->regbase;
-	u32		isr;
+	unsigned long	isr;
+	int		n;
 
 	/* temporarily mask (level sensitive) parent IRQ */
 	chip->irq_ack(idata);
@@ -420,13 +422,10 @@ static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 			continue;
 		}
 
-		virq = gpio_to_irq(at91_gpio->chip.base);
-
-		while (isr) {
-			if (isr & 1)
-				generic_handle_irq(virq);
-			virq++;
-			isr >>= 1;
+		n = find_first_bit(&isr, BITS_PER_LONG);
+		while (n < BITS_PER_LONG) {
+			generic_handle_irq(at91_gpiolib_to_irq(&at91_gpio->chip, n));
+			n = find_next_bit(&isr, BITS_PER_LONG, n + 1);
 		}
 	}
 	chip->irq_unmask(idata);
@@ -496,23 +495,91 @@ postcore_initcall(at91_gpio_debugfs_init);
 /*--------------------------------------------------------------------------*/
 
 /*
+ * This lock class tells lockdep that GPIO irqs are in a different
+ * category than their parents, so it won't report false recursion.
+ */
+static struct lock_class_key gpio_lock_class;
+
+#if defined(CONFIG_OF)
+static int at91_gpio_irq_map(struct irq_domain *h, unsigned int virq,
+							irq_hw_number_t hw)
+{
+	struct at91_gpio_chip	*at91_gpio = h->host_data;
+
+	irq_set_lockdep_class(virq, &gpio_lock_class);
+
+	/*
+	 * Can use the "simple" and not "edge" handler since it's
+	 * shorter, and the AIC handles interrupts sanely.
+	 */
+	irq_set_chip_and_handler(virq, &gpio_irqchip,
+				 handle_simple_irq);
+	set_irq_flags(virq, IRQF_VALID);
+	irq_set_chip_data(virq, at91_gpio);
+
+	return 0;
+}
+
+static struct irq_domain_ops at91_gpio_ops = {
+	.map	= at91_gpio_irq_map,
+	.xlate	= irq_domain_xlate_twocell,
+};
+
+int __init at91_gpio_of_irq_setup(struct device_node *node,
+				     struct device_node *parent)
+{
+	struct at91_gpio_chip	*prev = NULL;
+	int			alias_idx = of_alias_get_id(node, "gpio");
+	struct at91_gpio_chip	*at91_gpio = &gpio_chip[alias_idx];
+
+	/* Disable irqs of this PIO controller */
+	__raw_writel(~0, at91_gpio->regbase + PIO_IDR);
+
+	/* Setup irq domain */
+	at91_gpio->domain = irq_domain_add_linear(node, at91_gpio->chip.ngpio,
+						&at91_gpio_ops, at91_gpio);
+	if (!at91_gpio->domain)
+		panic("at91_gpio.%d: couldn't allocate irq domain (DT).\n",
+			at91_gpio->pioc_idx);
+
+	/* Setup chained handler */
+	if (at91_gpio->pioc_idx)
+		prev = &gpio_chip[at91_gpio->pioc_idx - 1];
+
+	/* The toplevel handler handles one bank of GPIOs, except
+	 * on some SoC it can handles up to three...
+	 * We only set up the handler for the first of the list.
+	 */
+	if (prev && prev->next == at91_gpio)
+		return 0;
+
+	at91_gpio->pioc_virq = irq_create_mapping(irq_find_host(parent),
+							at91_gpio->pioc_hwirq);
+	irq_set_chip_data(at91_gpio->pioc_virq, at91_gpio);
+	irq_set_chained_handler(at91_gpio->pioc_virq, gpio_irq_handler);
+
+	return 0;
+}
+#else
+int __init at91_gpio_of_irq_setup(struct device_node *node,
+				     struct device_node *parent)
+{
+	return -EINVAL;
+}
+#endif
+
+/*
  * irqdomain initialization: pile up irqdomains on top of AIC range
  */
 static void __init at91_gpio_irqdomain(struct at91_gpio_chip *at91_gpio)
 {
 	int irq_base;
-#if defined(CONFIG_OF)
-	struct device_node *of_node = at91_gpio->chip.of_node;
-#else
-	struct device_node *of_node = NULL;
-#endif
 
 	irq_base = irq_alloc_descs(-1, 0, at91_gpio->chip.ngpio, 0);
 	if (irq_base < 0)
 		panic("at91_gpio.%d: error %d: couldn't allocate IRQ numbers.\n",
 			at91_gpio->pioc_idx, irq_base);
-	at91_gpio->domain = irq_domain_add_legacy(of_node,
-						  at91_gpio->chip.ngpio,
+	at91_gpio->domain = irq_domain_add_legacy(NULL, at91_gpio->chip.ngpio,
 						  irq_base, 0,
 						  &irq_domain_simple_ops, NULL);
 	if (!at91_gpio->domain)
@@ -521,12 +588,6 @@ static void __init at91_gpio_irqdomain(struct at91_gpio_chip *at91_gpio)
 }
 
 /*
- * This lock class tells lockdep that GPIO irqs are in a different
- * category than their parents, so it won't report false recursion.
- */
-static struct lock_class_key gpio_lock_class;
-
-/*
  * Called from the processor-specific init to enable GPIO interrupt support.
  */
 void __init at91_gpio_irq_setup(void)
@@ -538,8 +599,7 @@ void __init at91_gpio_irq_setup(void)
 	for (pioc = 0, this = gpio_chip, prev = NULL;
 			pioc++ < gpio_banks;
 			prev = this, this++) {
-		unsigned	pioc_hwirq = this->pioc_hwirq;
-		int		offset;
+		int offset;
 
 		__raw_writel(~0, this->regbase + PIO_IDR);
 
@@ -547,7 +607,7 @@ void __init at91_gpio_irq_setup(void)
 		at91_gpio_irqdomain(this);
 
 		for (offset = 0; offset < this->chip.ngpio; offset++) {
-			unsigned int virq = irq_find_mapping(this->domain, offset);
+			unsigned int virq = irq_create_mapping(this->domain, offset);
 			irq_set_lockdep_class(virq, &gpio_lock_class);
 
 			/*
@@ -569,8 +629,9 @@ void __init at91_gpio_irq_setup(void)
 		if (prev && prev->next == this)
 			continue;
 
-		irq_set_chip_data(pioc_hwirq, this);
-		irq_set_chained_handler(pioc_hwirq, gpio_irq_handler);
+		this->pioc_virq = irq_create_mapping(NULL, this->pioc_hwirq);
+		irq_set_chip_data(this->pioc_virq, this);
+		irq_set_chained_handler(this->pioc_virq, gpio_irq_handler);
 	}
 	pr_info("AT91: %d gpio irqs in %d banks\n", gpio_irqnbr, gpio_banks);
 }
@@ -648,7 +709,12 @@ static void at91_gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 static int at91_gpiolib_to_irq(struct gpio_chip *chip, unsigned offset)
 {
 	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
-	int virq = irq_find_mapping(at91_gpio->domain, offset);
+	int virq;
+
+	if (offset < chip->ngpio)
+		virq = irq_create_mapping(at91_gpio->domain, offset);
+	else
+		virq = -ENXIO;
 
 	dev_dbg(chip->dev, "%s: request IRQ for GPIO %d, return %d\n",
 				chip->label, offset + chip->base, virq);
diff --git a/arch/arm/mach-at91/irq.c b/arch/arm/mach-at91/irq.c
index 46682fa..2e4ee09 100644
--- a/arch/arm/mach-at91/irq.c
+++ b/arch/arm/mach-at91/irq.c
@@ -135,27 +135,72 @@ static struct irq_chip at91_aic_chip = {
 	.irq_set_wake	= at91_aic_set_wake,
 };
 
+static void __init at91_aic_hw_init(unsigned int spu_vector)
+{
+	int i;
+
+	/*
+	 * Perform 8 End Of Interrupt Command to make sure AIC
+	 * will not Lock out nIRQ
+	 */
+	for (i = 0; i < 8; i++)
+		at91_aic_write(AT91_AIC_EOICR, 0);
+
+	/*
+	 * Spurious Interrupt ID in Spurious Vector Register.
+	 * When there is no current interrupt, the IRQ Vector Register
+	 * reads the value stored in AIC_SPU
+	 */
+	at91_aic_write(AT91_AIC_SPU, spu_vector);
+
+	/* No debugging in AIC: Debug (Protect) Control Register */
+	at91_aic_write(AT91_AIC_DCR, 0);
+
+	/* Disable and clear all interrupts initially */
+	at91_aic_write(AT91_AIC_IDCR, 0xFFFFFFFF);
+	at91_aic_write(AT91_AIC_ICCR, 0xFFFFFFFF);
+}
+
+
+
 #if defined(CONFIG_OF)
-static int __init __at91_aic_of_init(struct device_node *node,
-				     struct device_node *parent)
+static int at91_aic_irq_map(struct irq_domain *h, unsigned int virq,
+							irq_hw_number_t hw)
 {
-	at91_aic_base = of_iomap(node, 0);
-	at91_aic_np = node;
+	/* Put virq number in Source Vector Register */
+	at91_aic_write(AT91_AIC_SVR(hw), virq);
+
+	/* Active Low interrupt, without priority */
+	at91_aic_write(AT91_AIC_SMR(hw), AT91_AIC_SRCTYPE_LOW);
+
+	irq_set_chip_and_handler(virq, &at91_aic_chip, handle_level_irq);
+	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
 
 	return 0;
 }
 
-static const struct of_device_id aic_ids[] __initconst = {
-	{ .compatible = "atmel,at91rm9200-aic", .data = __at91_aic_of_init },
-	{ /*sentinel*/ }
+static struct irq_domain_ops at91_aic_irq_ops = {
+	.map	= at91_aic_irq_map,
+	.xlate	= irq_domain_xlate_twocell,
 };
 
-static void __init at91_aic_of_init(void)
+int __init at91_aic_of_init(struct device_node *node,
+				     struct device_node *parent)
 {
-	of_irq_init(aic_ids);
+	at91_aic_base = of_iomap(node, 0);
+	at91_aic_np = node;
+
+	at91_aic_domain = irq_domain_add_linear(at91_aic_np, NR_AIC_IRQS,
+						&at91_aic_irq_ops, NULL);
+	if (!at91_aic_domain)
+		panic("Unable to add AIC irq domain (DT)\n");
+
+	irq_set_default_host(at91_aic_domain);
+
+	at91_aic_hw_init(NR_AIC_IRQS);
+
+	return 0;
 }
-#else
-static void __init at91_aic_of_init(void) {}
 #endif
 
 /*
@@ -166,11 +211,7 @@ void __init at91_aic_init(unsigned int priority[NR_AIC_IRQS])
 	unsigned int i;
 	int irq_base;
 
-	if (of_have_populated_dt())
-		at91_aic_of_init();
-	else
-		at91_aic_base = ioremap(AT91_AIC, 512);
-
+	at91_aic_base = ioremap(AT91_AIC, 512);
 	if (!at91_aic_base)
 		panic("Unable to ioremap AIC registers\n");
 
@@ -187,6 +228,8 @@ void __init at91_aic_init(unsigned int priority[NR_AIC_IRQS])
 	if (!at91_aic_domain)
 		panic("Unable to add AIC irq domain\n");
 
+	irq_set_default_host(at91_aic_domain);
+
 	/*
 	 * The IVR is used by macro get_irqnr_and_base to read and verify.
 	 * The irq number is NR_AIC_IRQS when a spurious interrupt has occurred.
@@ -199,22 +242,7 @@ void __init at91_aic_init(unsigned int priority[NR_AIC_IRQS])
 
 		irq_set_chip_and_handler(i, &at91_aic_chip, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
-
-		/* Perform 8 End Of Interrupt Command to make sure AIC will not Lock out nIRQ */
-		if (i < 8)
-			at91_aic_write(AT91_AIC_EOICR, 0);
 	}
 
-	/*
-	 * Spurious Interrupt ID in Spurious Vector Register is NR_AIC_IRQS
-	 * When there is no current interrupt, the IRQ Vector Register reads the value stored in AIC_SPU
-	 */
-	at91_aic_write(AT91_AIC_SPU, NR_AIC_IRQS);
-
-	/* No debugging in AIC: Debug (Protect) Control Register */
-	at91_aic_write(AT91_AIC_DCR, 0);
-
-	/* Disable and clear all interrupts initially */
-	at91_aic_write(AT91_AIC_IDCR, 0xFFFFFFFF);
-	at91_aic_write(AT91_AIC_ICCR, 0xFFFFFFFF);
+	at91_aic_hw_init(NR_AIC_IRQS);
 }
-- 
1.7.9

