Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1FHVgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:36:05 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:11481 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab1FHVgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:36:02 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1307568896!5167350!49
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.31]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio-ep93xx: convert to platform_driver and use basic_mmio_gpio library
Date: Wed, 8 Jun 2011 14:35:33 -0700
User-Agent: KMail/1.9.9
CC: ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Ryan Mallon <ryan@bluewatersys.com>, <grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106081435.33578.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the gpio-ep93xx driver into a platform_driver and uses
the basic_mmio_gpio library.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>
Cc: Grant Likely <grant.likely@secretlab.ca>

---

diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
index cc9f1d4..1280046 100644
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -174,14 +174,10 @@ struct sys_timer ep93xx_timer = {
 /*************************************************************************
  * EP93xx IRQ handling
  *************************************************************************/
-extern void ep93xx_gpio_init_irq(void);
-
 void __init ep93xx_init_irq(void)
 {
 	vic_init(EP93XX_VIC1_BASE, 0, EP93XX_VIC1_VALID_IRQ_MASK, 0);
 	vic_init(EP93XX_VIC2_BASE, 32, EP93XX_VIC2_VALID_IRQ_MASK, 0);
-
-	ep93xx_gpio_init_irq();
 }
 
 
@@ -241,6 +237,24 @@ unsigned int ep93xx_chip_revision(void)
 }
 
 /*************************************************************************
+ * EP93xx GPIO
+ *************************************************************************/
+static struct resource ep93xx_gpio_resource[] = {
+	{
+		.start		= EP93XX_GPIO_PHYS_BASE,
+		.end		= EP93XX_GPIO_PHYS_BASE + 0xcc - 1,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device ep93xx_gpio_device = {
+	.name		= "gpio-ep93xx",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(ep93xx_gpio_resource),
+	.resource	= ep93xx_gpio_resource,
+};
+
+/*************************************************************************
  * EP93xx peripheral handling
  *************************************************************************/
 #define EP93XX_UART_MCR_OFFSET		(0x0100)
@@ -870,14 +884,13 @@ void __init ep93xx_register_ac97(void)
 	platform_device_register(&ep93xx_pcm_device);
 }
 
-extern void ep93xx_gpio_init(void);
-
 void __init ep93xx_init_devices(void)
 {
 	/* Disallow access to MaverickCrunch initially */
 	ep93xx_devcfg_clear_bits(EP93XX_SYSCON_DEVCFG_CPENA);
 
-	ep93xx_gpio_init();
+	/* Get the GPIO working early, other devices need it */
+	platform_device_register(&ep93xx_gpio_device);
 
 	amba_device_register(&uart1_device, &iomem_resource);
 	amba_device_register(&uart2_device, &iomem_resource);
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index b84666a..9f06e63 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -87,6 +87,7 @@ config GPIO_IT8761E
 config GPIO_EP93XX
 	def_bool y
 	depends on ARCH_EP93XX
+	select GPIO_GENERIC
 
 config GPIO_EXYNOS4
 	def_bool y
diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
index 3d427b9..22ffa1d 100644
--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -2,6 +2,7 @@
  * Generic EP93xx GPIO handling
  *
  * Copyright (c) 2008 Ryan Mallon <ryan@bluewatersys.com>
+ * Copyright (c) 2011 H Hartley Sweeten <hsweeten@visionengravers.com>
  *
  * Based on code originally from:
  *  linux/arch/arm/mach-ep93xx/core.c
@@ -14,14 +15,20 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/init.h>
-#include <linux/module.h>
-#include <linux/seq_file.h>
+#include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/irq.h>
+#include <linux/slab.h>
+#include <linux/basic_mmio_gpio.h>
 
 #include <mach/hardware.h>
 
+struct ep93xx_gpio {
+	void __iomem		*mmio_base;
+	struct bgpio_chip	bgc[8];
+};
+
 /*************************************************************************
  * Interrupt handling for EP93xx on-chip GPIOs
  *************************************************************************/
@@ -223,7 +230,7 @@ static struct irq_chip ep93xx_gpio_irq_chip = {
 	.irq_set_type	= ep93xx_gpio_irq_type,
 };
 
-void __init ep93xx_gpio_init_irq(void)
+static void ep93xx_gpio_init_irq(void)
 {
 	int gpio_irq;
 
@@ -258,151 +265,142 @@ void __init ep93xx_gpio_init_irq(void)
 /*************************************************************************
  * gpiolib interface for EP93xx on-chip GPIOs
  *************************************************************************/
-struct ep93xx_gpio_chip {
-	struct gpio_chip	chip;
-
-	void __iomem		*data_reg;
-	void __iomem		*data_dir_reg;
+struct ep93xx_gpio_bank {
+	const char	*label;
+	int		data;
+	int		dir;
+	int		base;
+	bool		has_debounce;
 };
 
-#define to_ep93xx_gpio_chip(c) container_of(c, struct ep93xx_gpio_chip, chip)
+#define EP93XX_GPIO_BANK(_label, _data, _dir, _base, _debounce)	\
+	{							\
+		.label		= _label,			\
+		.data		= _data,			\
+		.dir		= _dir,				\
+		.base		= _base,			\
+		.has_debounce	= _debounce,			\
+	}
 
-static int ep93xx_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+static struct ep93xx_gpio_bank ep93xx_gpio_banks[] = {
+	EP93XX_GPIO_BANK("A", 0x00, 0x10, 0, true),
+	EP93XX_GPIO_BANK("B", 0x04, 0x14, 8, true),
+	EP93XX_GPIO_BANK("C", 0x08, 0x18, 40, false),
+	EP93XX_GPIO_BANK("D", 0x0c, 0x1c, 24, false),
+	EP93XX_GPIO_BANK("E", 0x20, 0x24, 32, false),
+	EP93XX_GPIO_BANK("F", 0x30, 0x34, 16, true),
+	EP93XX_GPIO_BANK("G", 0x38, 0x3c, 48, false),
+	EP93XX_GPIO_BANK("H", 0x40, 0x44, 56, false),
+};
+
+static int ep93xx_gpio_set_debounce(struct gpio_chip *chip,
+				    unsigned offset, unsigned debounce)
 {
-	struct ep93xx_gpio_chip *ep93xx_chip = to_ep93xx_gpio_chip(chip);
-	unsigned long flags;
-	u8 v;
+	int gpio = chip->base + offset;
+	int irq = gpio_to_irq(gpio);
 
-	local_irq_save(flags);
-	v = __raw_readb(ep93xx_chip->data_dir_reg);
-	v &= ~(1 << offset);
-	__raw_writeb(v, ep93xx_chip->data_dir_reg);
-	local_irq_restore(flags);
+	if (irq < 0)
+		return -EINVAL;
+
+	ep93xx_gpio_int_debounce(irq, debounce ? true : false);
 
 	return 0;
 }
 
-static int ep93xx_gpio_direction_output(struct gpio_chip *chip,
-					unsigned offset, int val)
+static int ep93xx_gpio_add_bank(struct bgpio_chip *bgc, struct device *dev,
+	void __iomem *mmio_base, struct ep93xx_gpio_bank *bank)
 {
-	struct ep93xx_gpio_chip *ep93xx_chip = to_ep93xx_gpio_chip(chip);
-	unsigned long flags;
-	int line;
-	u8 v;
-
-	local_irq_save(flags);
+	void __iomem *data = mmio_base + bank->data;
+	void __iomem *dir =  mmio_base + bank->dir;
+	int err;
 
-	/* Set the value */
-	v = __raw_readb(ep93xx_chip->data_reg);
-	if (val)
-		v |= (1 << offset);
-	else
-		v &= ~(1 << offset);
-	__raw_writeb(v, ep93xx_chip->data_reg);
-
-	/* Drive as an output */
-	line = chip->base + offset;
-	if (line <= EP93XX_GPIO_LINE_MAX_IRQ) {
-		/* Ports A/B/F */
-		ep93xx_gpio_int_mask(line);
-		ep93xx_gpio_update_int_params(line >> 3);
-	}
+	err = bgpio_init(bgc, dev, 1, data, NULL, NULL, dir, NULL, false);
+	if (err)
+		return err;
 
-	v = __raw_readb(ep93xx_chip->data_dir_reg);
-	v |= (1 << offset);
-	__raw_writeb(v, ep93xx_chip->data_dir_reg);
+	bgc->gc.label = bank->label;
+	bgc->gc.base = bank->base;
 
-	local_irq_restore(flags);
+	if (bank->has_debounce)
+		bgc->gc.set_debounce = ep93xx_gpio_set_debounce;
 
-	return 0;
+	return gpiochip_add(&bgc->gc);
 }
 
-static int ep93xx_gpio_get(struct gpio_chip *chip, unsigned offset)
+static int __devinit ep93xx_gpio_probe(struct platform_device *pdev)
 {
-	struct ep93xx_gpio_chip *ep93xx_chip = to_ep93xx_gpio_chip(chip);
+	struct ep93xx_gpio *ep93xx_gpio;
+	struct resource *res;
+	void __iomem *mmio;
+	int i;
+	int ret;
 
-	return !!(__raw_readb(ep93xx_chip->data_reg) & (1 << offset));
-}
+	ep93xx_gpio = kzalloc(sizeof(*ep93xx_gpio), GFP_KERNEL);
+	if (!ep93xx_gpio)
+		return -ENOMEM;
 
-static void ep93xx_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
-{
-	struct ep93xx_gpio_chip *ep93xx_chip = to_ep93xx_gpio_chip(chip);
-	unsigned long flags;
-	u8 v;
-
-	local_irq_save(flags);
-	v = __raw_readb(ep93xx_chip->data_reg);
-	if (val)
-		v |= (1 << offset);
-	else
-		v &= ~(1 << offset);
-	__raw_writeb(v, ep93xx_chip->data_reg);
-	local_irq_restore(flags);
-}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		ret = -ENXIO;
+		goto exit_free;
+	}
 
-static int ep93xx_gpio_set_debounce(struct gpio_chip *chip,
-				    unsigned offset, unsigned debounce)
-{
-	int gpio = chip->base + offset;
-	int irq = gpio_to_irq(gpio);
+	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
+		ret = -EBUSY;
+		goto exit_free;
+	}
 
-	if (irq < 0)
-		return -EINVAL;
+	mmio = ioremap(res->start, resource_size(res));
+	if (!mmio) {
+		ret = -ENXIO;
+		goto exit_release;
+	}
+	ep93xx_gpio->mmio_base = mmio;
 
-	ep93xx_gpio_int_debounce(irq, debounce ? true : false);
+	/* Default all ports to GPIO */
+	ep93xx_devcfg_set_bits(EP93XX_SYSCON_DEVCFG_KEYS |
+			       EP93XX_SYSCON_DEVCFG_GONK |
+			       EP93XX_SYSCON_DEVCFG_EONIDE |
+			       EP93XX_SYSCON_DEVCFG_GONIDE |
+			       EP93XX_SYSCON_DEVCFG_HONIDE);
 
-	return 0;
-}
+	for (i = 0; i < ARRAY_SIZE(ep93xx_gpio_banks); i++) {
+		struct bgpio_chip *bgc = &ep93xx_gpio->bgc[i];
+		struct ep93xx_gpio_bank *bank = &ep93xx_gpio_banks[i];
 
-#define EP93XX_GPIO_BANK(name, dr, ddr, base_gpio)			\
-	{								\
-		.chip = {						\
-			.label		  = name,			\
-			.direction_input  = ep93xx_gpio_direction_input, \
-			.direction_output = ep93xx_gpio_direction_output, \
-			.get		  = ep93xx_gpio_get,		\
-			.set		  = ep93xx_gpio_set,		\
-			.base		  = base_gpio,			\
-			.ngpio		  = 8,				\
-		},							\
-		.data_reg	= EP93XX_GPIO_REG(dr),			\
-		.data_dir_reg	= EP93XX_GPIO_REG(ddr),			\
+		if (ep93xx_gpio_add_bank(bgc, &pdev->dev, mmio, bank))
+			dev_warn(&pdev->dev, "Unable to add gpio bank %s\n",
+				bank->label);
 	}
 
-static struct ep93xx_gpio_chip ep93xx_gpio_banks[] = {
-	EP93XX_GPIO_BANK("A", 0x00, 0x10, 0),
-	EP93XX_GPIO_BANK("B", 0x04, 0x14, 8),
-	EP93XX_GPIO_BANK("C", 0x08, 0x18, 40),
-	EP93XX_GPIO_BANK("D", 0x0c, 0x1c, 24),
-	EP93XX_GPIO_BANK("E", 0x20, 0x24, 32),
-	EP93XX_GPIO_BANK("F", 0x30, 0x34, 16),
-	EP93XX_GPIO_BANK("G", 0x38, 0x3c, 48),
-	EP93XX_GPIO_BANK("H", 0x40, 0x44, 56),
-};
+	ep93xx_gpio_init_irq();
 
-void __init ep93xx_gpio_init(void)
-{
-	int i;
+	return 0;
 
-	/* Set Ports C, D, E, G, and H for GPIO use */
-	ep93xx_devcfg_set_bits(EP93XX_SYSCON_DEVCFG_KEYS |
-				 EP93XX_SYSCON_DEVCFG_GONK |
-				 EP93XX_SYSCON_DEVCFG_EONIDE |
-				 EP93XX_SYSCON_DEVCFG_GONIDE |
-				 EP93XX_SYSCON_DEVCFG_HONIDE);
+exit_release:
+	release_mem_region(res->start, resource_size(res));
+exit_free:
+	kfree(ep93xx_gpio);
+	dev_info(&pdev->dev, "%s failed with errno %d\n", __func__, ret);
+	return ret;
+}
 
-	for (i = 0; i < ARRAY_SIZE(ep93xx_gpio_banks); i++) {
-		struct gpio_chip *chip = &ep93xx_gpio_banks[i].chip;
-
-		/*
-		 * Ports A, B, and F support input debouncing when
-		 * used as interrupts.
-		 */
-		if (!strcmp(chip->label, "A") ||
-		    !strcmp(chip->label, "B") ||
-		    !strcmp(chip->label, "F"))
-			chip->set_debounce = ep93xx_gpio_set_debounce;
-
-		gpiochip_add(chip);
-	}
+static struct platform_driver ep93xx_gpio_driver = {
+	.driver		= {
+		.name	= "gpio-ep93xx",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= ep93xx_gpio_probe,
+};
+
+static int __init ep93xx_gpio_init(void)
+{
+	pr_info("%s\n", __func__);
+        return platform_driver_register(&ep93xx_gpio_driver);
 }
+postcore_initcall(ep93xx_gpio_init);
+
+MODULE_AUTHOR("Ryan Mallon <ryan@bluewatersys.com> "
+		"H Hartley Sweeten <hsweeten@visionengravers.com>");
+MODULE_DESCRIPTION("EP93XX GPIO driver");
+MODULE_LICENSE("GPL");
