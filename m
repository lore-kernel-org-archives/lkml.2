Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761316Ab2KABCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 21:02:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39862 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761301Ab2KABCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 21:02:20 -0400
Message-ID: <5091CA18.7020905@gmail.com>
Date: Wed, 31 Oct 2012 20:02:16 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH] ARM: plat-versatile: move FPGA irq driver to drivers/irqchip
References: <1351719113-30880-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1351719113-30880-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 04:31 PM, Linus Walleij wrote:
> This moves the Versatile FPGA interrupt controller driver, used in
> the Integrator/AP, Integrator/CP and some Versatile boards, out
> of arch/arm/plat-versatile and down to drivers/irqchip where we
> have consensus that such drivers belong. The header file is
> consequently moved to <linux/platform_data/irq-versatile-fpga.h>.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  arch/arm/Kconfig                                   |   4 +-
>  arch/arm/mach-integrator/integrator_ap.c           |   3 +-
>  arch/arm/mach-integrator/integrator_cp.c           |   2 +-
>  arch/arm/mach-versatile/core.c                     |   2 +-
>  arch/arm/plat-versatile/Kconfig                    |   9 -
>  arch/arm/plat-versatile/Makefile                   |   1 -
>  drivers/irqchip/Kconfig                            |   9 +-
>  drivers/irqchip/Makefile                           |   1 +
>  drivers/irqchip/irq-arm-fpga.c                     | 204 +++++++++++++++++++++
>  .../irqchip/irq-versatile-fpga.c                   |   4 +-
>  .../linux/platform_data/irq-versatile-fpga.h       |   0
>  11 files changed, 220 insertions(+), 19 deletions(-)
>  create mode 100644 drivers/irqchip/irq-arm-fpga.c
>  rename arch/arm/plat-versatile/fpga-irq.c => drivers/irqchip/irq-versatile-fpga.c (97%)
>  rename arch/arm/plat-versatile/include/plat/fpga-irq.h => include/linux/platform_data/irq-versatile-fpga.h (100%)

I think include/linux/irqchip/ is the right place. Ideally we would not
need the header at all. You can remove some of the function declarations
if you base this on Thomas Petazzoni's series to have a common init
function for DT and also move the fpga_handle_irq init into the
fpga_irq_init function.

Rob

> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 73067ef..2205e3e 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -284,8 +284,8 @@ config ARCH_INTEGRATOR
>  	select MULTI_IRQ_HANDLER
>  	select NEED_MACH_MEMORY_H
>  	select PLAT_VERSATILE
> -	select PLAT_VERSATILE_FPGA_IRQ
>  	select SPARSE_IRQ
> +	select VERSATILE_FPGA_IRQ
>  	help
>  	  Support for ARM's Integrator platform.
>  
> @@ -318,7 +318,7 @@ config ARCH_VERSATILE
>  	select PLAT_VERSATILE
>  	select PLAT_VERSATILE_CLCD
>  	select PLAT_VERSATILE_CLOCK
> -	select PLAT_VERSATILE_FPGA_IRQ
> +	select VERSATILE_FPGA_IRQ
>  	help
>  	  This enables support for ARM Ltd Versatile board.
>  
> diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
> index 4f13bc5..caa279f 100644
> --- a/arch/arm/mach-integrator/integrator_ap.c
> +++ b/arch/arm/mach-integrator/integrator_ap.c
> @@ -34,6 +34,7 @@
>  #include <linux/mtd/physmap.h>
>  #include <linux/clk.h>
>  #include <linux/platform_data/clk-integrator.h>
> +#include <linux/platform_data/irq-versatile-fpga.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_address.h>
>  #include <linux/of_platform.h>
> @@ -56,8 +57,6 @@
>  #include <asm/mach/pci.h>
>  #include <asm/mach/time.h>
>  
> -#include <plat/fpga-irq.h>
> -
>  #include "common.h"
>  
>  /* 
> diff --git a/arch/arm/mach-integrator/integrator_cp.c b/arch/arm/mach-integrator/integrator_cp.c
> index 4423bc8..b50fdc7 100644
> --- a/arch/arm/mach-integrator/integrator_cp.c
> +++ b/arch/arm/mach-integrator/integrator_cp.c
> @@ -23,6 +23,7 @@
>  #include <linux/gfp.h>
>  #include <linux/mtd/physmap.h>
>  #include <linux/platform_data/clk-integrator.h>
> +#include <linux/platform_data/irq-versatile-fpga.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_address.h>
>  #include <linux/of_platform.h>
> @@ -46,7 +47,6 @@
>  #include <asm/hardware/timer-sp.h>
>  
>  #include <plat/clcd.h>
> -#include <plat/fpga-irq.h>
>  #include <plat/sched_clock.h>
>  
>  #include "common.h"
> diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
> index 5b5c1ee..46bfb8c 100644
> --- a/arch/arm/mach-versatile/core.c
> +++ b/arch/arm/mach-versatile/core.c
> @@ -35,6 +35,7 @@
>  #include <linux/gfp.h>
>  #include <linux/clkdev.h>
>  #include <linux/mtd/physmap.h>
> +#include <linux/platform_data/irq-versatile-fpga.h>
>  
>  #include <asm/irq.h>
>  #include <asm/hardware/arm_timer.h>
> @@ -51,7 +52,6 @@
>  #include <asm/hardware/timer-sp.h>
>  
>  #include <plat/clcd.h>
> -#include <plat/fpga-irq.h>
>  #include <plat/sched_clock.h>
>  
>  #include "core.h"
> diff --git a/arch/arm/plat-versatile/Kconfig b/arch/arm/plat-versatile/Kconfig
> index 2a4ae8a..619f0fa 100644
> --- a/arch/arm/plat-versatile/Kconfig
> +++ b/arch/arm/plat-versatile/Kconfig
> @@ -6,15 +6,6 @@ config PLAT_VERSATILE_CLOCK
>  config PLAT_VERSATILE_CLCD
>  	bool
>  
> -config PLAT_VERSATILE_FPGA_IRQ
> -	bool
> -	select IRQ_DOMAIN
> -
> -config PLAT_VERSATILE_FPGA_IRQ_NR
> -       int
> -       default 4
> -       depends on PLAT_VERSATILE_FPGA_IRQ
> -
>  config PLAT_VERSATILE_LEDS
>  	def_bool y if NEW_LEDS
>  	depends on ARCH_REALVIEW || ARCH_VERSATILE
> diff --git a/arch/arm/plat-versatile/Makefile b/arch/arm/plat-versatile/Makefile
> index 74cfd94..f88d448 100644
> --- a/arch/arm/plat-versatile/Makefile
> +++ b/arch/arm/plat-versatile/Makefile
> @@ -2,7 +2,6 @@ ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include
>  
>  obj-$(CONFIG_PLAT_VERSATILE_CLOCK) += clock.o
>  obj-$(CONFIG_PLAT_VERSATILE_CLCD) += clcd.o
> -obj-$(CONFIG_PLAT_VERSATILE_FPGA_IRQ) += fpga-irq.o
>  obj-$(CONFIG_PLAT_VERSATILE_LEDS) += leds.o
>  obj-$(CONFIG_PLAT_VERSATILE_SCHED_CLOCK) += sched-clock.o
>  obj-$(CONFIG_SMP) += headsmp.o platsmp.o
> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index 1bb8bf6..62ca575 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -1 +1,8 @@
> -# empty
> +config VERSATILE_FPGA_IRQ
> +	bool
> +	select IRQ_DOMAIN
> +
> +config VERSATILE_FPGA_IRQ_NR
> +       int
> +       default 4
> +       depends on VERSATILE_FPGA_IRQ
> diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
> index 054321d..e2e6eb5 100644
> --- a/drivers/irqchip/Makefile
> +++ b/drivers/irqchip/Makefile
> @@ -1 +1,2 @@
>  obj-$(CONFIG_ARCH_BCM2835) += irq-bcm2835.o
> +obj-$(CONFIG_VERSATILE_FPGA_IRQ) += irq-versatile-fpga.o
> diff --git a/drivers/irqchip/irq-arm-fpga.c b/drivers/irqchip/irq-arm-fpga.c
> new file mode 100644
> index 0000000..92fb9d6
> --- /dev/null
> +++ b/drivers/irqchip/irq-arm-fpga.c
> @@ -0,0 +1,204 @@
> +/*
> + *  Support for Versatile FPGA-based IRQ controllers
> + */
> +#include <linux/bitops.h>
> +#include <linux/irq.h>
> +#include <linux/io.h>
> +#include <linux/irqdomain.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_data/irq-versatile-fpga.h>
> +
> +#include <asm/exception.h>
> +#include <asm/mach/irq.h>
> +
> +#define IRQ_STATUS		0x00
> +#define IRQ_RAW_STATUS		0x04
> +#define IRQ_ENABLE_SET		0x08
> +#define IRQ_ENABLE_CLEAR	0x0c
> +#define INT_SOFT_SET		0x10
> +#define INT_SOFT_CLEAR		0x14
> +#define FIQ_STATUS		0x20
> +#define FIQ_RAW_STATUS		0x24
> +#define FIQ_ENABLE		0x28
> +#define FIQ_ENABLE_SET		0x28
> +#define FIQ_ENABLE_CLEAR	0x2C
> +
> +/**
> + * struct fpga_irq_data - irq data container for the FPGA IRQ controller
> + * @base: memory offset in virtual memory
> + * @chip: chip container for this instance
> + * @domain: IRQ domain for this instance
> + * @valid: mask for valid IRQs on this controller
> + * @used_irqs: number of active IRQs on this controller
> + */
> +struct fpga_irq_data {
> +	void __iomem *base;
> +	struct irq_chip chip;
> +	u32 valid;
> +	struct irq_domain *domain;
> +	u8 used_irqs;
> +};
> +
> +/* we cannot allocate memory when the controllers are initially registered */
> +static struct fpga_irq_data fpga_irq_devices[CONFIG_VERSATILE_FPGA_IRQ_NR];
> +static int fpga_irq_id;
> +
> +static void fpga_irq_mask(struct irq_data *d)
> +{
> +	struct fpga_irq_data *f = irq_data_get_irq_chip_data(d);
> +	u32 mask = 1 << d->hwirq;
> +
> +	writel(mask, f->base + IRQ_ENABLE_CLEAR);
> +}
> +
> +static void fpga_irq_unmask(struct irq_data *d)
> +{
> +	struct fpga_irq_data *f = irq_data_get_irq_chip_data(d);
> +	u32 mask = 1 << d->hwirq;
> +
> +	writel(mask, f->base + IRQ_ENABLE_SET);
> +}
> +
> +static void fpga_irq_handle(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct fpga_irq_data *f = irq_desc_get_handler_data(desc);
> +	u32 status = readl(f->base + IRQ_STATUS);
> +
> +	if (status == 0) {
> +		do_bad_IRQ(irq, desc);
> +		return;
> +	}
> +
> +	do {
> +		irq = ffs(status) - 1;
> +		status &= ~(1 << irq);
> +		generic_handle_irq(irq_find_mapping(f->domain, irq));
> +	} while (status);
> +}
> +
> +/*
> + * Handle each interrupt in a single FPGA IRQ controller.  Returns non-zero
> + * if we've handled at least one interrupt.  This does a single read of the
> + * status register and handles all interrupts in order from LSB first.
> + */
> +static int handle_one_fpga(struct fpga_irq_data *f, struct pt_regs *regs)
> +{
> +	int handled = 0;
> +	int irq;
> +	u32 status;
> +
> +	while ((status  = readl(f->base + IRQ_STATUS))) {
> +		irq = ffs(status) - 1;
> +		handle_IRQ(irq_find_mapping(f->domain, irq), regs);
> +		handled = 1;
> +	}
> +
> +	return handled;
> +}
> +
> +/*
> + * Keep iterating over all registered FPGA IRQ controllers until there are
> + * no pending interrupts.
> + */
> +asmlinkage void __exception_irq_entry fpga_handle_irq(struct pt_regs *regs)
> +{
> +	int i, handled;
> +
> +	do {
> +		for (i = 0, handled = 0; i < fpga_irq_id; ++i)
> +			handled |= handle_one_fpga(&fpga_irq_devices[i], regs);
> +	} while (handled);
> +}
> +
> +static int fpga_irqdomain_map(struct irq_domain *d, unsigned int irq,
> +		irq_hw_number_t hwirq)
> +{
> +	struct fpga_irq_data *f = d->host_data;
> +
> +	/* Skip invalid IRQs, only register handlers for the real ones */
> +	if (!(f->valid & BIT(hwirq)))
> +		return -ENOTSUPP;
> +	irq_set_chip_data(irq, f);
> +	irq_set_chip_and_handler(irq, &f->chip,
> +				handle_level_irq);
> +	set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
> +	return 0;
> +}
> +
> +static struct irq_domain_ops fpga_irqdomain_ops = {
> +	.map = fpga_irqdomain_map,
> +	.xlate = irq_domain_xlate_onetwocell,
> +};
> +
> +void __init fpga_irq_init(void __iomem *base, const char *name, int irq_start,
> +			  int parent_irq, u32 valid, struct device_node *node)
> +{
> +	struct fpga_irq_data *f;
> +	int i;
> +
> +	if (fpga_irq_id >= ARRAY_SIZE(fpga_irq_devices)) {
> +		pr_err("%s: too few FPGA IRQ controllers, increase CONFIG_VERSATILE_FPGA_IRQ_NR\n", __func__);
> +		return;
> +	}
> +	f = &fpga_irq_devices[fpga_irq_id];
> +	f->base = base;
> +	f->chip.name = name;
> +	f->chip.irq_ack = fpga_irq_mask;
> +	f->chip.irq_mask = fpga_irq_mask;
> +	f->chip.irq_unmask = fpga_irq_unmask;
> +	f->valid = valid;
> +
> +	if (parent_irq != -1) {
> +		irq_set_handler_data(parent_irq, f);
> +		irq_set_chained_handler(parent_irq, fpga_irq_handle);
> +	}
> +
> +	/* This will also allocate irq descriptors */
> +	f->domain = irq_domain_add_simple(node, fls(valid), irq_start,
> +					  &fpga_irqdomain_ops, f);
> +
> +	/* This will allocate all valid descriptors in the linear case */
> +	for (i = 0; i < fls(valid); i++)
> +		if (valid & BIT(i)) {
> +			if (!irq_start)
> +				irq_create_mapping(f->domain, i);
> +			f->used_irqs++;
> +		}
> +
> +	pr_info("FPGA IRQ chip %d \"%s\" @ %p, %u irqs\n",
> +		fpga_irq_id, name, base, f->used_irqs);
> +
> +	fpga_irq_id++;
> +}
> +
> +#ifdef CONFIG_OF
> +int __init fpga_irq_of_init(struct device_node *node,
> +			    struct device_node *parent)
> +{
> +	struct fpga_irq_data *f;
> +	void __iomem *base;
> +	u32 clear_mask;
> +	u32 valid_mask;
> +
> +	if (WARN_ON(!node))
> +		return -ENODEV;
> +
> +	base = of_iomap(node, 0);
> +	WARN(!base, "unable to map fpga irq registers\n");
> +
> +	if (of_property_read_u32(node, "clear-mask", &clear_mask))
> +		clear_mask = 0;
> +
> +	if (of_property_read_u32(node, "valid-mask", &valid_mask))
> +		valid_mask = 0;
> +
> +	fpga_irq_init(base, node->name, 0, -1, valid_mask, node);
> +
> +	writel(clear_mask, base + IRQ_ENABLE_CLEAR);
> +	writel(clear_mask, base + FIQ_ENABLE_CLEAR);
> +
> +	return 0;
> +}
> +#endif
> diff --git a/arch/arm/plat-versatile/fpga-irq.c b/drivers/irqchip/irq-versatile-fpga.c
> similarity index 97%
> rename from arch/arm/plat-versatile/fpga-irq.c
> rename to drivers/irqchip/irq-versatile-fpga.c
> index dfe317c..b7aab6e 100644
> --- a/arch/arm/plat-versatile/fpga-irq.c
> +++ b/drivers/irqchip/irq-versatile-fpga.c
> @@ -8,10 +8,10 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> +#include <linux/platform_data/irq-versatile-fpga.h>
>  
>  #include <asm/exception.h>
>  #include <asm/mach/irq.h>
> -#include <plat/fpga-irq.h>
>  
>  #define IRQ_STATUS		0x00
>  #define IRQ_RAW_STATUS		0x04
> @@ -42,7 +42,7 @@ struct fpga_irq_data {
>  };
>  
>  /* we cannot allocate memory when the controllers are initially registered */
> -static struct fpga_irq_data fpga_irq_devices[CONFIG_PLAT_VERSATILE_FPGA_IRQ_NR];
> +static struct fpga_irq_data fpga_irq_devices[CONFIG_VERSATILE_FPGA_IRQ_NR];
>  static int fpga_irq_id;
>  
>  static void fpga_irq_mask(struct irq_data *d)
> diff --git a/arch/arm/plat-versatile/include/plat/fpga-irq.h b/include/linux/platform_data/irq-versatile-fpga.h
> similarity index 100%
> rename from arch/arm/plat-versatile/include/plat/fpga-irq.h
> rename to include/linux/platform_data/irq-versatile-fpga.h
> 

