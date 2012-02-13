Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab2BMOoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:44:20 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:15074 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab2BMOoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:44:18 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Cc: tglx@linutronix.de, devicetree-discuss@lists.ozlabs.org,
        avictor.za@gmail.com, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v5 5/9] ARM: at91/gpio: add irqdomain and DT support
Date: Mon, 13 Feb 2012 15:43:05 +0100
Message-Id: <52349c67f3af8c8eef10a31cff59213577e1aba0.1329139662.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <2fd1ebedc5ad5ac7aeb15c590c4400212a3b06cf.1329139662.git.nicolas.ferre@atmel.com>
References: <2fd1ebedc5ad5ac7aeb15c590c4400212a3b06cf.1329139662.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "legacy" type of irqdomain to preserve old-style numbering
and allow smooth transition for both DT and non-DT cases.

Original idea and code by Jean-Christophe Plagniol-Villard.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
v5: - merge irqdomain and device tree modifications
    - use "legacy" type of irqdomain (call to irq_domain_add_legacy())
    - use more explicit variable names

v4: - at91_gpio_setup_clk() returns an error code

v3: - Corrections proposed by Russell King:
      - use of clk_prepare()/clk_unprepare()
      - helper function to setup the clock for both DT/non DT init functions

v2: - no BUG_ON() anymore in case of an "interrupts" property missing
      just stop configuring the gpio bank
    - review error path in both of_at91_gpio_init_one() and
      at91_gpio_init_one()
    - use for_each_compatible_node() iterator instead of a homemade loop

 .../devicetree/bindings/gpio/gpio_atmel.txt        |   20 ++
 arch/arm/boot/dts/at91sam9g20.dtsi                 |   30 +++
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   50 +++++
 arch/arm/mach-at91/gpio.c                          |  233 ++++++++++++++++----
 4 files changed, 287 insertions(+), 46 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio_atmel.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio_atmel.txt b/Documentation/devicetree/bindings/gpio/gpio_atmel.txt
new file mode 100644
index 0000000..a7bcaec
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio_atmel.txt
@@ -0,0 +1,20 @@
+* Atmel GPIO controller (PIO)
+
+Required properties:
+- compatible: "atmel,at91rm9200-gpio"
+- reg: Should contain GPIO controller registers location and length
+- interrupts: Should be the port interrupt shared by all the pins.
+- #gpio-cells: Should be two.  The first cell is the pin number and
+  the second cell is used to specify optional parameters (currently
+  unused).
+- gpio-controller: Marks the device node as a GPIO controller.
+
+Example:
+	pioA: gpio@fffff200 {
+		compatible = "atmel,at91rm9200-gpio";
+		reg = <0xfffff200 0x100>;
+		interrupts = <2 4>;
+		#gpio-cells = <2>;
+		gpio-controller;
+	};
+
diff --git a/arch/arm/boot/dts/at91sam9g20.dtsi b/arch/arm/boot/dts/at91sam9g20.dtsi
index 9a0aee7..325989a 100644
--- a/arch/arm/boot/dts/at91sam9g20.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20.dtsi
@@ -23,6 +23,9 @@
 		serial4 = &usart3;
 		serial5 = &usart4;
 		serial6 = &usart5;
+		gpio0 = &pioA;
+		gpio1 = &pioB;
+		gpio2 = &pioC;
 	};
 	cpus {
 		cpu@0 {
@@ -54,6 +57,33 @@
 				reg = <0xfffff000 0x200>;
 			};
 
+			pioA: gpio@fffff400 {
+				compatible = "atmel,at91rm9200-gpio";
+				reg = <0xfffff400 0x100>;
+				interrupts = <2 4>;
+				#gpio-cells = <2>;
+				gpio-controller;
+				interrupt-controller;
+			};
+
+			pioB: gpio@fffff600 {
+				compatible = "atmel,at91rm9200-gpio";
+				reg = <0xfffff600 0x100>;
+				interrupts = <3 4>;
+				#gpio-cells = <2>;
+				gpio-controller;
+				interrupt-controller;
+			};
+
+			pioC: gpio@fffff800 {
+				compatible = "atmel,at91rm9200-gpio";
+				reg = <0xfffff800 0x100>;
+				interrupts = <4 4>;
+				#gpio-cells = <2>;
+				gpio-controller;
+				interrupt-controller;
+			};
+
 			dbgu: serial@fffff200 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffff200 0x200>;
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index 67f94d3..a9dbbb5 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -22,6 +22,11 @@
 		serial2 = &usart1;
 		serial3 = &usart2;
 		serial4 = &usart3;
+		gpio0 = &pioA;
+		gpio1 = &pioB;
+		gpio2 = &pioC;
+		gpio3 = &pioD;
+		gpio4 = &pioE;
 	};
 	cpus {
 		cpu@0 {
@@ -59,6 +64,51 @@
 				interrupts = <21 4>;
 			};
 
+			pioA: gpio@fffff200 {
+				compatible = "atmel,at91rm9200-gpio";
+				reg = <0xfffff200 0x100>;
+				interrupts = <2 4>;
+				#gpio-cells = <2>;
+				gpio-controller;
+				interrupt-controller;
+			};
+
+			pioB: gpio@fffff400 {
+				compatible = "atmel,at91rm9200-gpio";
+				reg = <0xfffff400 0x100>;
+				interrupts = <3 4>;
+				#gpio-cells = <2>;
+				gpio-controller;
+				interrupt-controller;
+			};
+
+			pioC: gpio@fffff600 {
+				compatible = "atmel,at91rm9200-gpio";
+				reg = <0xfffff600 0x100>;
+				interrupts = <4 4>;
+				#gpio-cells = <2>;
+				gpio-controller;
+				interrupt-controller;
+			};
+
+			pioD: gpio@fffff800 {
+				compatible = "atmel,at91rm9200-gpio";
+				reg = <0xfffff800 0x100>;
+				interrupts = <5 4>;
+				#gpio-cells = <2>;
+				gpio-controller;
+				interrupt-controller;
+			};
+
+			pioE: gpio@fffffa00 {
+				compatible = "atmel,at91rm9200-gpio";
+				reg = <0xfffffa00 0x100>;
+				interrupts = <5 4>;
+				#gpio-cells = <2>;
+				gpio-controller;
+				interrupt-controller;
+			};
+
 			dbgu: serial@ffffee00 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xffffee00 0x200>;
diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
index b762afc..89e683a 100644
--- a/arch/arm/mach-at91/gpio.c
+++ b/arch/arm/mach-at91/gpio.c
@@ -20,6 +20,9 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/io.h>
+#include <linux/irqdomain.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 
 #include <mach/hardware.h>
 #include <mach/at91_pio.h>
@@ -30,8 +33,10 @@ struct at91_gpio_chip {
 	struct gpio_chip	chip;
 	struct at91_gpio_chip	*next;		/* Bank sharing same clock */
 	int			pioc_hwirq;	/* PIO bank interrupt identifier on AIC */
+	int			pioc_idx;	/* PIO bank index */
 	void __iomem		*regbase;	/* PIO bank virtual address */
 	struct clk		*clock;		/* associated clock */
+	struct irq_domain	*domain;	/* associated irq domain */
 };
 
 #define to_at91_gpio_chip(c) container_of(c, struct at91_gpio_chip, chip)
@@ -273,9 +278,9 @@ static u32 backups[MAX_GPIO_BANKS];
 
 static int gpio_irq_set_wake(struct irq_data *d, unsigned state)
 {
-	unsigned	pin = irq_to_gpio(d->irq);
-	unsigned	mask = pin_to_mask(pin);
-	unsigned	bank = pin / 32;
+	struct at91_gpio_chip *at91_gpio = irq_data_get_irq_chip_data(d);
+	unsigned	mask = 1 << d->hwirq;
+	unsigned	bank = at91_gpio->pioc_idx;
 
 	if (unlikely(bank >= MAX_GPIO_BANKS))
 		return -EINVAL;
@@ -301,9 +306,10 @@ void at91_gpio_suspend(void)
 		__raw_writel(backups[i], pio + PIO_IDR);
 		__raw_writel(wakeups[i], pio + PIO_IER);
 
-		if (!wakeups[i])
+		if (!wakeups[i]) {
+			clk_unprepare(gpio_chip[i].clock);
 			clk_disable(gpio_chip[i].clock);
-		else {
+		} else {
 #ifdef CONFIG_PM_DEBUG
 			printk(KERN_DEBUG "GPIO-%c may wake for %08x\n", 'A'+i, wakeups[i]);
 #endif
@@ -318,8 +324,10 @@ void at91_gpio_resume(void)
 	for (i = 0; i < gpio_banks; i++) {
 		void __iomem	*pio = gpio_chip[i].regbase;
 
-		if (!wakeups[i])
-			clk_enable(gpio_chip[i].clock);
+		if (!wakeups[i]) {
+			if (clk_prepare(gpio_chip[i].clock) == 0)
+				clk_enable(gpio_chip[i].clock);
+		}
 
 		__raw_writel(wakeups[i], pio + PIO_IDR);
 		__raw_writel(backups[i], pio + PIO_IER);
@@ -344,9 +352,9 @@ void at91_gpio_resume(void)
 
 static void gpio_irq_mask(struct irq_data *d)
 {
-	unsigned	pin = irq_to_gpio(d->irq);
-	void __iomem	*pio = pin_to_controller(pin);
-	unsigned	mask = pin_to_mask(pin);
+	struct at91_gpio_chip *at91_gpio = irq_data_get_irq_chip_data(d);
+	void __iomem	*pio = at91_gpio->regbase;
+	unsigned	mask = 1 << d->hwirq;
 
 	if (pio)
 		__raw_writel(mask, pio + PIO_IDR);
@@ -354,9 +362,9 @@ static void gpio_irq_mask(struct irq_data *d)
 
 static void gpio_irq_unmask(struct irq_data *d)
 {
-	unsigned	pin = irq_to_gpio(d->irq);
-	void __iomem	*pio = pin_to_controller(pin);
-	unsigned	mask = pin_to_mask(pin);
+	struct at91_gpio_chip *at91_gpio = irq_data_get_irq_chip_data(d);
+	void __iomem	*pio = at91_gpio->regbase;
+	unsigned	mask = 1 << d->hwirq;
 
 	if (pio)
 		__raw_writel(mask, pio + PIO_IER);
@@ -384,7 +392,7 @@ static struct irq_chip gpio_irqchip = {
 
 static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 {
-	unsigned	irq_pin;
+	unsigned	virq;
 	struct irq_data *idata = irq_desc_get_irq_data(desc);
 	struct irq_chip *chip = irq_data_get_irq_chip(idata);
 	struct at91_gpio_chip *at91_gpio = irq_data_get_irq_chip_data(idata);
@@ -407,12 +415,12 @@ static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 			continue;
 		}
 
-		irq_pin = gpio_to_irq(at91_gpio->chip.base);
+		virq = gpio_to_irq(at91_gpio->chip.base);
 
 		while (isr) {
 			if (isr & 1)
-				generic_handle_irq(irq_pin);
-			irq_pin++;
+				generic_handle_irq(virq);
+			virq++;
 			isr >>= 1;
 		}
 	}
@@ -483,6 +491,26 @@ postcore_initcall(at91_gpio_debugfs_init);
 /*--------------------------------------------------------------------------*/
 
 /*
+ * irqdomain initialization: pile up irqdomains on top of AIC range
+ */
+static void __init at91_gpio_irqdomain(struct at91_gpio_chip *at91_gpio)
+{
+	int irq_base;
+
+	irq_base = irq_alloc_descs(-1, 0, at91_gpio->chip.ngpio, 0);
+	if (irq_base < 0)
+		panic("at91_gpio.%d: error %d: couldn't allocate IRQ numbers.\n",
+			at91_gpio->pioc_idx, irq_base);
+	at91_gpio->domain = irq_domain_add_legacy(at91_gpio->chip.of_node,
+						  at91_gpio->chip.ngpio,
+						  irq_base, 0,
+						  &irq_domain_simple_ops, NULL);
+	if (!at91_gpio->domain)
+		panic("at91_gpio.%d: couldn't allocate irq domain.\n",
+			at91_gpio->pioc_idx);
+}
+
+/*
  * This lock class tells lockdep that GPIO irqs are in a different
  * category than their parents, so it won't report false recursion.
  */
@@ -493,28 +521,35 @@ static struct lock_class_key gpio_lock_class;
  */
 void __init at91_gpio_irq_setup(void)
 {
-	unsigned		pioc, irq = gpio_to_irq(0);
+	unsigned		pioc;
+	int			gpio_irqnbr = 0;
 	struct at91_gpio_chip	*this, *prev;
 
 	for (pioc = 0, this = gpio_chip, prev = NULL;
 			pioc++ < gpio_banks;
 			prev = this, this++) {
 		unsigned	pioc_hwirq = this->pioc_hwirq;
-		unsigned	i;
+		int		offset;
 
 		__raw_writel(~0, this->regbase + PIO_IDR);
 
-		for (i = 0, irq = gpio_to_irq(this->chip.base); i < 32;
-		     i++, irq++) {
-			irq_set_lockdep_class(irq, &gpio_lock_class);
+		/* setup irq domain for this GPIO controller */
+		at91_gpio_irqdomain(this);
+
+		for (offset = 0; offset < this->chip.ngpio; offset++) {
+			unsigned int virq = irq_find_mapping(this->domain, offset);
+			irq_set_lockdep_class(virq, &gpio_lock_class);
 
 			/*
 			 * Can use the "simple" and not "edge" handler since it's
 			 * shorter, and the AIC handles interrupts sanely.
 			 */
-			irq_set_chip_and_handler(irq, &gpio_irqchip,
+			irq_set_chip_and_handler(virq, &gpio_irqchip,
 						 handle_simple_irq);
-			set_irq_flags(irq, IRQF_VALID);
+			set_irq_flags(virq, IRQF_VALID);
+			irq_set_chip_data(virq, this);
+
+			gpio_irqnbr++;
 		}
 
 		/* The toplevel handler handles one bank of GPIOs, except
@@ -527,7 +562,7 @@ void __init at91_gpio_irq_setup(void)
 		irq_set_chip_data(pioc_hwirq, this);
 		irq_set_chained_handler(pioc_hwirq, gpio_irq_handler);
 	}
-	pr_info("AT91: %d gpio irqs in %d banks\n", irq - gpio_to_irq(0), gpio_banks);
+	pr_info("AT91: %d gpio irqs in %d banks\n", gpio_irqnbr, gpio_banks);
 }
 
 /* gpiolib support */
@@ -600,39 +635,145 @@ static void at91_gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 	}
 }
 
+static int __init at91_gpio_setup_clk(int idx)
+{
+	struct at91_gpio_chip *at91_gpio = &gpio_chip[idx];
+
+	/* retreive PIO controller's clock */
+	at91_gpio->clock = clk_get_sys(NULL, at91_gpio->chip.label);
+	if (IS_ERR(at91_gpio->clock)) {
+		pr_err("at91_gpio.%d, failed to get clock, ignoring.\n", idx);
+		goto err;
+	}
+
+	if (clk_prepare(at91_gpio->clock))
+		goto clk_prep_err;
+
+	/* enable PIO controller's clock */
+	if (clk_enable(at91_gpio->clock)) {
+		pr_err("at91_gpio.%d, failed to enable clock, ignoring.\n", idx);
+		goto clk_err;
+	}
+
+	return 0;
+
+clk_err:
+	clk_unprepare(at91_gpio->clock);
+clk_prep_err:
+	clk_put(at91_gpio->clock);
+err:
+	return -EINVAL;
+}
+
+#ifdef CONFIG_OF_GPIO
+static void __init of_at91_gpio_init_one(struct device_node *np)
+{
+	int alias_idx;
+	struct at91_gpio_chip *at91_gpio;
+
+	if (!np)
+		return;
+
+	alias_idx = of_alias_get_id(np, "gpio");
+	if (alias_idx >= MAX_GPIO_BANKS) {
+		pr_err("at91_gpio, failed alias idx(%d) > MAX_GPIO_BANKS(%d), ignoring.\n",
+						alias_idx, MAX_GPIO_BANKS);
+		return;
+	}
+
+	at91_gpio = &gpio_chip[alias_idx];
+	at91_gpio->chip.base = alias_idx * at91_gpio->chip.ngpio;
+
+	at91_gpio->regbase = of_iomap(np, 0);
+	if (!at91_gpio->regbase) {
+		pr_err("at91_gpio.%d, failed to map registers, ignoring.\n",
+								alias_idx);
+		return;
+	}
+
+	/* Get the interrupts property */
+	if (of_property_read_u32(np, "interrupts", &at91_gpio->pioc_hwirq)) {
+		pr_err("at91_gpio.%d, failed to get interrupts property, ignoring.\n",
+								alias_idx);
+		goto ioremap_err;
+	}
+
+	/* Setup clock */
+	if (at91_gpio_setup_clk(alias_idx))
+		goto ioremap_err;
+
+	at91_gpio->chip.of_node = np;
+	gpio_banks = max(gpio_banks, alias_idx + 1);
+	at91_gpio->pioc_idx = alias_idx;
+	return;
+
+ioremap_err:
+	iounmap(at91_gpio->regbase);
+}
+
+static int __init of_at91_gpio_init(void)
+{
+	struct device_node *np = NULL;
+
+	/*
+	 * This isn't ideal, but it gets things hooked up until this
+	 * driver is converted into a platform_device
+	 */
+	for_each_compatible_node(np, NULL, "atmel,at91rm9200-gpio")
+		of_at91_gpio_init_one(np);
+
+	return gpio_banks > 0 ? 0 : -EINVAL;
+}
+#else
+static int __init of_at91_gpio_init(void)
+{
+	return -EINVAL;
+}
+#endif
+
+static void __init at91_gpio_init_one(int idx, u32 regbase, int pioc_hwirq)
+{
+	struct at91_gpio_chip *at91_gpio = &gpio_chip[idx];
+
+	at91_gpio->chip.base = idx * at91_gpio->chip.ngpio;
+	at91_gpio->pioc_hwirq = pioc_hwirq;
+	at91_gpio->pioc_idx = idx;
+
+	at91_gpio->regbase = ioremap(regbase, 512);
+	if (!at91_gpio->regbase) {
+		pr_err("at91_gpio.%d, failed to map registers, ignoring.\n", idx);
+		return;
+	}
+
+	if (at91_gpio_setup_clk(idx))
+		goto ioremap_err;
+
+	gpio_banks = max(gpio_banks, idx + 1);
+	return;
+
+ioremap_err:
+	iounmap(at91_gpio->regbase);
+}
+
 /*
  * Called from the processor-specific init to enable GPIO pin support.
  */
 void __init at91_gpio_init(struct at91_gpio_bank *data, int nr_banks)
 {
-	unsigned		i;
+	unsigned i;
 	struct at91_gpio_chip *at91_gpio, *last = NULL;
 
 	BUG_ON(nr_banks > MAX_GPIO_BANKS);
 
-	gpio_banks = nr_banks;
+	if (of_at91_gpio_init() < 0) {
+		/* No GPIO controller found in device tree */
+		for (i = 0; i < nr_banks; i++)
+			at91_gpio_init_one(i, data[i].regbase, data[i].id);
+	}
 
-	for (i = 0; i < nr_banks; i++) {
+	for (i = 0; i < gpio_banks; i++) {
 		at91_gpio = &gpio_chip[i];
 
-		at91_gpio->pioc_hwirq = data[i].pioc_hwirq;
-		at91_gpio->chip.base = i * 32;
-
-		at91_gpio->regbase = ioremap(data[i].regbase, 512);
-		if (!at91_gpio->regbase) {
-			pr_err("at91_gpio.%d, failed to map registers, ignoring.\n", i);
-			continue;
-		}
-
-		at91_gpio->clock = clk_get_sys(NULL, at91_gpio->chip.label);
-		if (!at91_gpio->clock) {
-			pr_err("at91_gpio.%d, failed to get clock, ignoring.\n", i);
-			continue;
-		}
-
-		/* enable PIO controller's clock */
-		clk_enable(at91_gpio->clock);
-
 		/*
 		 * GPIO controller are grouped on some SoC:
 		 * PIOC, PIOD and PIOE can share the same IRQ line
-- 
1.7.9

