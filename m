Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab2BMWK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 17:10:58 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:36516 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669Ab2BMWK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:10:56 -0500
Message-ID: <4F398A6E.8040905@gmail.com>
Date: Mon, 13 Feb 2012 16:10:54 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, avictor.za@gmail.com
Subject: Re: [PATCH v5 1/9] ARM: at91/aic: add irq domain and device tree
 support
References: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com> <2fd1ebedc5ad5ac7aeb15c590c4400212a3b06cf.1329139662.git.nicolas.ferre@atmel.com>
In-Reply-To: <2fd1ebedc5ad5ac7aeb15c590c4400212a3b06cf.1329139662.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 08:43 AM, Nicolas Ferre wrote:
> Add an irqdomain for the AIC interrupt controller.
> The device tree support is mapping the registers and
> is using the irq_domain_add_legacy() to manage hwirq
> translation.
> The documentation is describing the meaning of the
> two cells required for using this "interrupt-controller"
> in a device tree node.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> ---
> v5: - rebased on top of Grant's "irq_domain generalization and refinement"
>       patch series
>     - use of irq_domain_add_legacy() API
> 
> v4: - use irq_alloc_descs() to find irq_base
>     - add a new constant AIC_BASE_IRQ that will allow to skip
>       first interrupt numbers (in the future)
> 
> v3: - change number of cells to define an AIC interrupt (irq trigger type)
>     - change current .dtsi files to match specification
>     - use irq_domain_simple_ops (for DT mapping)
> 
> v2: - use of_irq_init() function for device tree probing
>     - add documentation
>     - use own simple struct irq_domain_ops
> 
> 
>  .../devicetree/bindings/arm/atmel-aic.txt          |   38 ++++++++++
>  arch/arm/Kconfig                                   |    1 +
>  arch/arm/boot/dts/at91sam9g20.dtsi                 |   18 +++---
>  arch/arm/boot/dts/at91sam9g45.dtsi                 |   16 ++--
>  arch/arm/mach-at91/include/mach/irqs.h             |    3 +-
>  arch/arm/mach-at91/irq.c                           |   74 ++++++++++++++++----
>  6 files changed, 119 insertions(+), 31 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/atmel-aic.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/atmel-aic.txt b/Documentation/devicetree/bindings/arm/atmel-aic.txt
> new file mode 100644
> index 0000000..289feb1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/atmel-aic.txt
> @@ -0,0 +1,38 @@
> +* Advanced Interrupt Controller (AIC)
> +
> +Required properties:
> +- compatible: Should be "atmel,<chip>-aic"
> +- interrupt-controller: Identifies the node as an interrupt controller.
> +- interrupt-parent: For single AIC system, it is an empty property.
> +- #interrupt-cells: The number of cells to define the interrupts. It sould be 2.
> +  The first cell is the GPIO number.

s/GPIO/IRQ/

> +  The second cell is used to specify flags:
> +    bits[3:0] trigger type and level flags:
> +      1 = low-to-high edge triggered.
> +      2 = high-to-low edge triggered.
> +      4 = active high level-sensitive.
> +      8 = active low level-sensitive.
> +      Valid combinations are 1, 2, 3, 4, 8.
> +      Default flag for internal sources should be set to 4 (active high).
> +- reg: Should contain AIC registers location and length
> +
> +Examples:
> +	/*
> +	 * AIC
> +	 */
> +	aic: interrupt-controller@fffff000 {
> +		compatible = "atmel,at91rm9200-aic";
> +		interrupt-controller;
> +		interrupt-parent;
> +		#interrupt-cells = <2>;
> +		reg = <0xfffff000 0x200>;
> +	};
> +
> +	/*
> +	 * An interrupt generating device that is wired to an AIC.
> +	 */
> +	dma: dma-controller@ffffec00 {
> +		compatible = "atmel,at91sam9g45-dma";
> +		reg = <0xffffec00 0x200>;
> +		interrupts = <21 4>;
> +	};
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 92c9c79..cabd8f5 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -322,6 +322,7 @@ config ARCH_AT91
>  	select ARCH_REQUIRE_GPIOLIB
>  	select HAVE_CLK
>  	select CLKDEV_LOOKUP
> +	select IRQ_DOMAIN

This can likely go away assuming my change to select IRQ_DOMAIN for all
of ARM goes upstream.

>  	help
>  	  This enables support for systems based on the Atmel AT91RM9200,
>  	  AT91SAM9 processors.
> diff --git a/arch/arm/boot/dts/at91sam9g20.dtsi b/arch/arm/boot/dts/at91sam9g20.dtsi
> index 07603b8..9a0aee7 100644
> --- a/arch/arm/boot/dts/at91sam9g20.dtsi
> +++ b/arch/arm/boot/dts/at91sam9g20.dtsi
> @@ -47,7 +47,7 @@
>  			ranges;
>  
>  			aic: interrupt-controller@fffff000 {
> -				#interrupt-cells = <1>;
> +				#interrupt-cells = <2>;
>  				compatible = "atmel,at91rm9200-aic";
>  				interrupt-controller;
>  				interrupt-parent;
> @@ -57,14 +57,14 @@
>  			dbgu: serial@fffff200 {
>  				compatible = "atmel,at91sam9260-usart";
>  				reg = <0xfffff200 0x200>;
> -				interrupts = <1>;
> +				interrupts = <1 4>;
>  				status = "disabled";
>  			};
>  
>  			usart0: serial@fffb0000 {
>  				compatible = "atmel,at91sam9260-usart";
>  				reg = <0xfffb0000 0x200>;
> -				interrupts = <6>;
> +				interrupts = <6 4>;
>  				atmel,use-dma-rx;
>  				atmel,use-dma-tx;
>  				status = "disabled";
> @@ -73,7 +73,7 @@
>  			usart1: serial@fffb4000 {
>  				compatible = "atmel,at91sam9260-usart";
>  				reg = <0xfffb4000 0x200>;
> -				interrupts = <7>;
> +				interrupts = <7 4>;
>  				atmel,use-dma-rx;
>  				atmel,use-dma-tx;
>  				status = "disabled";
> @@ -82,7 +82,7 @@
>  			usart2: serial@fffb8000 {
>  				compatible = "atmel,at91sam9260-usart";
>  				reg = <0xfffb8000 0x200>;
> -				interrupts = <8>;
> +				interrupts = <8 4>;
>  				atmel,use-dma-rx;
>  				atmel,use-dma-tx;
>  				status = "disabled";
> @@ -91,7 +91,7 @@
>  			usart3: serial@fffd0000 {
>  				compatible = "atmel,at91sam9260-usart";
>  				reg = <0xfffd0000 0x200>;
> -				interrupts = <23>;
> +				interrupts = <23 4>;
>  				atmel,use-dma-rx;
>  				atmel,use-dma-tx;
>  				status = "disabled";
> @@ -100,7 +100,7 @@
>  			usart4: serial@fffd4000 {
>  				compatible = "atmel,at91sam9260-usart";
>  				reg = <0xfffd4000 0x200>;
> -				interrupts = <24>;
> +				interrupts = <24 4>;
>  				atmel,use-dma-rx;
>  				atmel,use-dma-tx;
>  				status = "disabled";
> @@ -109,7 +109,7 @@
>  			usart5: serial@fffd8000 {
>  				compatible = "atmel,at91sam9260-usart";
>  				reg = <0xfffd8000 0x200>;
> -				interrupts = <25>;
> +				interrupts = <25 4>;
>  				atmel,use-dma-rx;
>  				atmel,use-dma-tx;
>  				status = "disabled";
> @@ -118,7 +118,7 @@
>  			macb0: ethernet@fffc4000 {
>  				compatible = "cdns,at32ap7000-macb", "cdns,macb";
>  				reg = <0xfffc4000 0x100>;
> -				interrupts = <21>;
> +				interrupts = <21 4>;
>  				status = "disabled";
>  			};
>  		};
> diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
> index fffa005..67f94d3 100644
> --- a/arch/arm/boot/dts/at91sam9g45.dtsi
> +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
> @@ -46,7 +46,7 @@
>  			ranges;
>  
>  			aic: interrupt-controller@fffff000 {
> -				#interrupt-cells = <1>;
> +				#interrupt-cells = <2>;
>  				compatible = "atmel,at91rm9200-aic";
>  				interrupt-controller;
>  				interrupt-parent;
> @@ -56,20 +56,20 @@
>  			dma: dma-controller@ffffec00 {
>  				compatible = "atmel,at91sam9g45-dma";
>  				reg = <0xffffec00 0x200>;
> -				interrupts = <21>;
> +				interrupts = <21 4>;
>  			};
>  
>  			dbgu: serial@ffffee00 {
>  				compatible = "atmel,at91sam9260-usart";
>  				reg = <0xffffee00 0x200>;
> -				interrupts = <1>;
> +				interrupts = <1 4>;
>  				status = "disabled";
>  			};
>  
>  			usart0: serial@fff8c000 {
>  				compatible = "atmel,at91sam9260-usart";
>  				reg = <0xfff8c000 0x200>;
> -				interrupts = <7>;
> +				interrupts = <7 4>;
>  				atmel,use-dma-rx;
>  				atmel,use-dma-tx;
>  				status = "disabled";
> @@ -78,7 +78,7 @@
>  			usart1: serial@fff90000 {
>  				compatible = "atmel,at91sam9260-usart";
>  				reg = <0xfff90000 0x200>;
> -				interrupts = <8>;
> +				interrupts = <8 4>;
>  				atmel,use-dma-rx;
>  				atmel,use-dma-tx;
>  				status = "disabled";
> @@ -87,7 +87,7 @@
>  			usart2: serial@fff94000 {
>  				compatible = "atmel,at91sam9260-usart";
>  				reg = <0xfff94000 0x200>;
> -				interrupts = <9>;
> +				interrupts = <9 4>;
>  				atmel,use-dma-rx;
>  				atmel,use-dma-tx;
>  				status = "disabled";
> @@ -96,7 +96,7 @@
>  			usart3: serial@fff98000 {
>  				compatible = "atmel,at91sam9260-usart";
>  				reg = <0xfff98000 0x200>;
> -				interrupts = <10>;
> +				interrupts = <10 4>;
>  				atmel,use-dma-rx;
>  				atmel,use-dma-tx;
>  				status = "disabled";
> @@ -105,7 +105,7 @@
>  			macb0: ethernet@fffbc000 {
>  				compatible = "cdns,at32ap7000-macb", "cdns,macb";
>  				reg = <0xfffbc000 0x100>;
> -				interrupts = <25>;
> +				interrupts = <25 4>;
>  				status = "disabled";
>  			};
>  		};
> diff --git a/arch/arm/mach-at91/include/mach/irqs.h b/arch/arm/mach-at91/include/mach/irqs.h
> index ac8b7df..e3ee0fc 100644
> --- a/arch/arm/mach-at91/include/mach/irqs.h
> +++ b/arch/arm/mach-at91/include/mach/irqs.h
> @@ -25,6 +25,7 @@
>  #include <mach/at91_aic.h>
>  
>  #define NR_AIC_IRQS 32
> +#define AIC_BASE_IRQ 0
>  
>  
>  /*
> @@ -40,7 +41,7 @@
>   * symbols in gpio.h for ones handled indirectly as GPIOs.
>   * We make provision for 5 banks of GPIO.
>   */
> -#define	NR_IRQS		(NR_AIC_IRQS + (5 * 32))
> +#define	NR_IRQS		(AIC_BASE_IRQ + NR_AIC_IRQS + (5 * 32))

Why? You're not changing anything.

You should turn on SPARSE_IRQ at some point and then this value goes away.

>  
>  /* FIQ is AIC source 0. */
>  #define FIQ_START AT91_ID_FIQ
> diff --git a/arch/arm/mach-at91/irq.c b/arch/arm/mach-at91/irq.c
> index be6b639..880da98 100644
> --- a/arch/arm/mach-at91/irq.c
> +++ b/arch/arm/mach-at91/irq.c
> @@ -24,6 +24,12 @@
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/types.h>
> +#include <linux/irq.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/irqdomain.h>
> +#include <linux/err.h>
>  
>  #include <mach/hardware.h>
>  #include <asm/irq.h>
> @@ -34,22 +40,24 @@
>  #include <asm/mach/map.h>
>  
>  void __iomem *at91_aic_base;
> +static struct irq_domain *at91_aic_domain;
> +static struct device_node *at91_aic_np;
>  
>  static void at91_aic_mask_irq(struct irq_data *d)
>  {
>  	/* Disable interrupt on AIC */
> -	at91_aic_write(AT91_AIC_IDCR, 1 << d->irq);
> +	at91_aic_write(AT91_AIC_IDCR, 1 << d->hwirq);
>  }
>  
>  static void at91_aic_unmask_irq(struct irq_data *d)
>  {
>  	/* Enable interrupt on AIC */
> -	at91_aic_write(AT91_AIC_IECR, 1 << d->irq);
> +	at91_aic_write(AT91_AIC_IECR, 1 << d->hwirq);
>  }
>  
>  unsigned int at91_extern_irq;
>  
> -#define is_extern_irq(irq) ((1 << (irq)) & at91_extern_irq)
> +#define is_extern_irq(hwirq) ((1 << (hwirq)) & at91_extern_irq)
>  
>  static int at91_aic_set_type(struct irq_data *d, unsigned type)
>  {
> @@ -63,13 +71,13 @@ static int at91_aic_set_type(struct irq_data *d, unsigned type)
>  		srctype = AT91_AIC_SRCTYPE_RISING;
>  		break;
>  	case IRQ_TYPE_LEVEL_LOW:
> -		if ((d->irq == AT91_ID_FIQ) || is_extern_irq(d->irq))		/* only supported on external interrupts */
> +		if ((d->hwirq == AT91_ID_FIQ) || is_extern_irq(d->hwirq))		/* only supported on external interrupts */
>  			srctype = AT91_AIC_SRCTYPE_LOW;
>  		else
>  			return -EINVAL;
>  		break;
>  	case IRQ_TYPE_EDGE_FALLING:
> -		if ((d->irq == AT91_ID_FIQ) || is_extern_irq(d->irq))		/* only supported on external interrupts */
> +		if ((d->hwirq == AT91_ID_FIQ) || is_extern_irq(d->hwirq))		/* only supported on external interrupts */
>  			srctype = AT91_AIC_SRCTYPE_FALLING;
>  		else
>  			return -EINVAL;
> @@ -78,8 +86,8 @@ static int at91_aic_set_type(struct irq_data *d, unsigned type)
>  		return -EINVAL;
>  	}
>  
> -	smr = at91_aic_read(AT91_AIC_SMR(d->irq)) & ~AT91_AIC_SRCTYPE;
> -	at91_aic_write(AT91_AIC_SMR(d->irq), smr | srctype);
> +	smr = at91_aic_read(AT91_AIC_SMR(d->hwirq)) & ~AT91_AIC_SRCTYPE;
> +	at91_aic_write(AT91_AIC_SMR(d->hwirq), smr | srctype);
>  	return 0;
>  }
>  
> @@ -90,13 +98,13 @@ static u32 backups;
>  
>  static int at91_aic_set_wake(struct irq_data *d, unsigned value)
>  {
> -	if (unlikely(d->irq >= 32))
> +	if (unlikely(d->hwirq >= NR_AIC_IRQS))
>  		return -EINVAL;
>  
>  	if (value)
> -		wakeups |= (1 << d->irq);
> +		wakeups |= (1 << d->hwirq);
>  	else
> -		wakeups &= ~(1 << d->irq);
> +		wakeups &= ~(1 << d->hwirq);
>  
>  	return 0;
>  }
> @@ -127,24 +135,64 @@ static struct irq_chip at91_aic_chip = {
>  	.irq_set_wake	= at91_aic_set_wake,
>  };
>  
> +#if defined(CONFIG_OF)
> +static int __init __at91_aic_of_init(struct device_node *node,
> +				     struct device_node *parent)
> +{
> +	at91_aic_base = of_iomap(node, 0);
> +	at91_aic_np = node;
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id aic_ids[] __initconst = {
> +	{ .compatible = "atmel,at91rm9200-aic", .data = __at91_aic_of_init },
> +	{ /*sentinel*/ }
> +};
> +
> +static void __init at91_aic_of_init(void)
> +{
> +	of_irq_init(aic_ids);

This call and match str belongs in your board file (init_irq function)
and you should be doing all setup in __at91_aic_of_init.

> +}
> +#else
> +static void __init at91_aic_of_init(void) {}
> +#endif
> +
>  /*
>   * Initialize the AIC interrupt controller.
>   */
>  void __init at91_aic_init(unsigned int priority[NR_AIC_IRQS])

Perhaps the priority should be a cell in your interrupts property?

>  {
>  	unsigned int i;
> +	int irq_base;
>  
> -	at91_aic_base = ioremap(AT91_AIC, 512);
> +	if (of_have_populated_dt())
> +		at91_aic_of_init();

You should get to this point because of_irq_init called you and you
should already have a node ptr at point.

> +	else
> +		at91_aic_base = ioremap(AT91_AIC, 512);
>  
>  	if (!at91_aic_base)
> -		panic("Impossible to ioremap AT91_AIC\n");
> +		panic("Unable to ioremap AIC registers\n");
> +
> +	/* Add irq domain for AIC */
> +	irq_base = irq_alloc_descs(-1, AIC_BASE_IRQ, NR_AIC_IRQS, 0);

Really, you don't want to use irq0, but that would break your irq entry
code.

Rob

> +	if (irq_base < 0) {
> +		WARN(1, "Cannot allocate irq_descs, assuming pre-allocated\n");
> +		irq_base = AIC_BASE_IRQ;
> +	}
> +	at91_aic_domain = irq_domain_add_legacy(at91_aic_np, NR_AIC_IRQS,
> +						irq_base, 0,
> +						&irq_domain_simple_ops, NULL);
> +
> +	if (!at91_aic_domain)
> +		panic("Unable to add AIC irq domain\n");
>  
>  	/*
>  	 * The IVR is used by macro get_irqnr_and_base to read and verify.
>  	 * The irq number is NR_AIC_IRQS when a spurious interrupt has occurred.
>  	 */
>  	for (i = 0; i < NR_AIC_IRQS; i++) {
> -		/* Put irq number in Source Vector Register: */
> +		/* Put hardware irq number in Source Vector Register: */
>  		at91_aic_write(AT91_AIC_SVR(i), i);
>  		/* Active Low interrupt, with the specified priority */
>  		at91_aic_write(AT91_AIC_SMR(i), AT91_AIC_SRCTYPE_LOW | priority[i]);

