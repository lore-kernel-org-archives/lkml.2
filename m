Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab1DBWKK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 18:10:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:37169 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757114Ab1DBWKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 18:10:08 -0400
Date: Sun, 3 Apr 2011 00:10:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jamie Iles <jamie@jamieiles.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH] gpio: support for Synopsys DesignWare APB GPIO
In-Reply-To: <1301665638-29841-1-git-send-email-jamie@jamieiles.com>
Message-ID: <alpine.LFD.2.00.1104022300130.5929@localhost6.localdomain6>
References: <1301665638-29841-1-git-send-email-jamie@jamieiles.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2401;0cOn Fri, 1 Apr 2011, Jamie Iles wrote:

> This patch adds support for the Synopsys DesignWare APB GPIO controller
> that can be found in some ARM systems.  The controller supports up to

Not only ARM.

> 4x32 bit ports and port A is capable of raising interrupts.

So I assume that there are already a bunch of ARM SoC gpio
implementations in the arch/arm/* space which implement the very same
thing. Did you check that? And if yes, then it would be very helpful
to actually convert those platforms so there is a reason why we merge
another instance.

> +#define GPIO_SW_PORT_A_DR_REG_OFFSET		0x00
> +#define GPIO_SW_PORT_A_DDR_REG_OFFSET		0x04
> +#define GPIO_SW_PORT_A_CTL_REG_OFFSET		0x08
> +#define GPIO_SW_PORT_B_DR_REG_OFFSET		0x0C

I think this whole register offset thing needs to be runtime
configurable. We all know that SoC designers decide to move registers
around for pointless reasons or just change the stride.

> +#define GPIO_INT_EN_REG_OFFSET			0x30
> +#define GPIO_INT_MASK_REG_OFFSET		0x34

I bet there are implementations of the very same thing which have irq
support for more than one port. So that wants to be generalized as
well.

> +/*
> + * Get the port mapping for the controller.  There are 4 possible ports that
> + * we can use but some platforms may reserve ports for hardware purposes that
> + * cannot be used as GPIO so we allow these to be masked off.
> + */
> +static void dw_gpio_configure_ports(struct dw_gpio_chip *dw,
> +				    unsigned long port_mask)
> +{
> +	unsigned long cfg1, cfg2;
> +	int nr_ports;
> +
> +	cfg1 = readl(dw->iobase + GPIO_CFG1_REG_OFFSET);
> +	cfg2 = readl(dw->iobase + GPIO_CFG2_REG_OFFSET);
> +
> +	nr_ports = (cfg1 & GPIO_NR_PORTS_MASK) >> GPIO_NR_PORTS_SHIFT;
> +
> +	if (port_mask & DW_GPIO_PORTA_MASK) {
> +		dw->porta_end = ((cfg2 & GPIO_PORTA_WIDTH_MASK) >>
> +				 GPIO_PORTA_WIDTH_SHIFT) + 1;
> +		if (nr_ports == 1)
> +			return;

These nr_ports checks are pointless. This is a setup function and not
a hotpath.

> +	} else
> +		dw->porta_end = 0;
> +
> +	if (port_mask & DW_GPIO_PORTB_MASK) {
> +		dw->portb_end = ((cfg2 & GPIO_PORTB_WIDTH_MASK) >>
> +				 GPIO_PORTB_WIDTH_SHIFT) + 1 + dw->porta_end;
> +		if (nr_ports == 2)
> +			return;
> +	} else
> +		dw->portb_end = dw->porta_end;
> +
> +	if (port_mask & DW_GPIO_PORTC_MASK) {
> +		dw->portc_end = ((cfg2 & GPIO_PORTC_WIDTH_MASK) >>
> +				 GPIO_PORTC_WIDTH_SHIFT) + 1 + dw->portb_end;
> +		if (nr_ports == 3)
> +			return;
> +	} else
> +		dw->portc_end = dw->portb_end;
> +
> +	if (port_mask & DW_GPIO_PORTD_MASK)
> +		dw->portd_end = ((cfg2 & GPIO_PORTD_WIDTH_MASK) >>
> +				 GPIO_PORTD_WIDTH_SHIFT) + 1 + dw->portc_end;
> +	else
> +		dw->portd_end = dw->portb_end;
> +}

So you try to create a linear GPIO space which skips reserved
pins. What's the point of that? It adds useless overhead in the
hotpath for no value. It is confusing as there is no relation between
the HW pin and the gpio number anymore.

Why can't we just have a linear space where the reserved gpios are
simply not accessible?

> +#define __DWGPIO_REG(__chip, __gpio_nr, __reg)				\
> +	({								\
> +		void __iomem *ret = NULL;				\
> +		if ((__gpio_nr) <= (__chip)->porta_end)			\
> +			ret = ((__chip)->iobase +			\
> +				GPIO_SW_PORT_A_##__reg##_REG_OFFSET);	\
> +		else if ((__gpio_nr) <= (__chip)->portb_end)		\
> +			ret = ((__chip)->iobase +			\
> +				GPIO_SW_PORT_B_##__reg##_REG_OFFSET);	\
> +		else if ((__gpio_nr) <= (__chip)->portc_end)		\
> +			ret = ((__chip)->iobase +			\
> +				GPIO_SW_PORT_C_##__reg##_REG_OFFSET);	\
> +		else							\
> +			ret = ((__chip)->iobase +			\
> +				GPIO_SW_PORT_D_##__reg##_REG_OFFSET);	\
> +		ret;							\
> +	})
> +

> +static inline unsigned dw_gpio_bit_offs(struct dw_gpio_chip *dw,
> +					unsigned offset)
> +{
> +	/*
> +	 * The gpios are controlled via three sets of registers. The register
> +	 * addressing is already taken care of by the __DWGPIO_REG macro,

Shudder. A linear mapping would avoid all that ugliness.

> +	 * this takes care of the bit offsets within each register.
> +	 */
> +	if (offset <= dw->porta_end)
> +		return offset;
> +	else if (offset <= dw->portb_end)
> +		return offset - dw->porta_end;
> +	else if (offset <= dw->portc_end)
> +		return offset - dw->portb_end;
> +	else
> +		return offset - dw->portc_end;
> +}
> +
> +static int dwgpio_direction_input(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct dw_gpio_chip *dw = to_dw_gpio_chip(chip);
> +	void __iomem *ddr = DWGPIO_DDR(dw, offset);
> +	void __iomem *cr = DWGPIO_CTL(dw, offset);
> +	unsigned long flags, val, bit_offset = dw_gpio_bit_offs(dw, offset);
> +
> +	spin_lock_irqsave(&dw->lock, flags);
> +	/* Mark the pin as an output. */
> +	val = readl(ddr);

Why is this value not cached ?

> +	val &= ~(1 << bit_offset);
> +	writel(val, ddr);
> +
> +	/* Set the pin as software controlled. */
> +	val = readl(cr);

Ditto

> +	val &= ~(1 << bit_offset);
> +	writel(val, cr);
> +	spin_unlock_irqrestore(&dw->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int dwgpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct dw_gpio_chip *dw = to_dw_gpio_chip(chip);
> +	void __iomem *ext = DWGPIO_EXT(dw, offset);
> +	unsigned long bit_offset = dw_gpio_bit_offs(dw, offset);
> +
> +	return !!(readl(ext) & (1 << bit_offset));
> +}
> +
> +static void dwgpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +	struct dw_gpio_chip *dw = to_dw_gpio_chip(chip);
> +	void __iomem *dr = DWGPIO_DR(dw, offset);
> +	unsigned long val, flags, bit_offset = dw_gpio_bit_offs(dw, offset);
> +
> +	spin_lock_irqsave(&dw->lock, flags);
> +	val = readl(dr);

Even more so. More instances ignored.

> +static void dwgpio_irq_enable(struct irq_data *d)
> +{
> +	int gpio = irq_to_gpio(d->irq);
> +	struct dw_gpio_chip *dw = irq_data_get_irq_chip_data(d);
> +	void *port_inten = INT_EN_REG(dw);
> +	unsigned long val, flags;
> +
> +	spin_lock_irqsave(&dw->lock, flags);

This is nested into irq_desc->lock and wants to be a raw_spinlock
therefor.

> +	val = readl(port_inten);
> +	val |= (1 << gpio);
> +	writel(val, port_inten);
> +	spin_unlock_irqrestore(&dw->lock, flags);
> +}
> +
> +static void dwgpio_irq_disable(struct irq_data *d)
> +{
> +	int gpio = irq_to_gpio(d->irq);
> +	struct dw_gpio_chip *dw = irq_data_get_irq_chip_data(d);
> +	void __iomem *port_inten = INT_EN_REG(dw);

All this information can be precomputed at setup time and supplied as
irq_chip_data to the irq in a form wich does not require to compute it
over and over.

> +static void dwgpio_irq_ack(struct irq_data *d)
> +{
> +	int gpio = irq_to_gpio(d->irq);
> +	struct dw_gpio_chip *dw = irq_data_get_irq_chip_data(d);
> +	void __iomem *port_intmask = INT_MASK_REG(dw);
> +	void __iomem *port_eoi = EOI_REG(dw);
> +	void __iomem *port_inttype_level = INT_TYPE_REG(dw);
> +	unsigned long val, flags;
> +
> +	spin_lock_irqsave(&dw->lock, flags);
> +	val = readl(port_inttype_level);
> +	if (val & (1 << gpio)) {
> +		/* Edge-sensitive */
> +		val = readl(port_eoi);
> +		val |= (1 << gpio);
> +		writel(val, port_eoi);
> +	} else {
> +		/* Level-sensitive */
> +		val = readl(port_intmask);
> +		val |= (1 << gpio);
> +		writel(val, port_intmask);
> +	}

These conditionals are completely wrong. We use different irq_chip
implementations to distinguish different flows.

> +	spin_unlock_irqrestore(&dw->lock, flags);
> +}

> +static int dwgpio_irq_set_type(struct irq_data *d,
> +			       unsigned int trigger)
> +{
> +	int gpio = irq_to_gpio(d->irq);
> +	struct dw_gpio_chip *dw = irq_data_get_irq_chip_data(d);
> +	void __iomem *port_inttype_level = INT_TYPE_REG(dw);
> +	void __iomem *port_int_polarity = INT_POLARITY_REG(dw);
> +	unsigned long level, polarity, flags;
> +
> +	if (trigger & ~(IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
> +			IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&dw->lock, flags);
> +	level = readl(port_inttype_level);
> +	polarity = readl(port_int_polarity);
> +
> +	if (trigger & IRQ_TYPE_EDGE_RISING) {
> +		level	    |= (1 << gpio);
> +		polarity    |= (1 << gpio);
> +	} else if (trigger & IRQ_TYPE_EDGE_FALLING) {
> +		level	    |= (1 << gpio);
> +		polarity    &= ~(1 << gpio);
> +	} else if (trigger & IRQ_TYPE_LEVEL_HIGH) {
> +		level	    &= ~(1 << gpio);
> +		polarity    |= (1 << gpio);
> +	} else if (trigger & IRQ_TYPE_LEVEL_LOW) {
> +		level	    &= ~(1 << gpio);
> +		polarity    &= ~(1 << gpio);
> +	}
> +
> +	writel(level, port_inttype_level);
> +	writel(polarity, port_int_polarity);

So this should set the proper irq chip for the edge/level flow, but
yes that's pointless. See below.

> +	spin_unlock_irqrestore(&dw->lock, flags);
> +
> +	return 0;
> +}
> +
> +static struct irq_chip dwgpio_irqchip = {
> +	.name		= "dwgpio",
> +	.irq_ack	= dwgpio_irq_ack,
> +	.irq_mask	= dwgpio_irq_mask,
> +	.irq_unmask	= dwgpio_irq_unmask,
> +	.irq_enable	= dwgpio_irq_enable,
> +	.irq_disable	= dwgpio_irq_disable,
> +	.irq_set_type	= dwgpio_irq_set_type,
> +};
> +
> +static void dw_gpio_irq_handler(unsigned irq, struct irq_desc *desc)
> +{
> +	struct dw_gpio_chip *dw = irq_get_handler_data(irq);
> +	int i;
> +
> +	/*
> +	 * Mask and ack the interrupt in the parent interrupt controller
> +	 * before handling it.
> +	 */
> +	desc->irq_data.chip->irq_mask(&desc->irq_data);
> +	desc->irq_data.chip->irq_ack(&desc->irq_data);

Please get chip and irq_data with the proper accessors.

> +	for (;;) {
> +		unsigned long status = readl(INT_STATUS_REG(dw));
> +
> +		if (!status)
> +			break;
> +		writel(status, EOI_REG(dw));
> +
> +		for_each_set_bit(i, &status, 8)
> +			generic_handle_irq(dw->irq_base + i);
> +	}
> +	desc->irq_data.chip->irq_unmask(&desc->irq_data);
> +}
> +
> +/*
> + * We want to enable/disable interrupts for the GPIO pins through the GPIO
> + * block itself.  The current configuration assumes a 1-to-1 mapping of GPIO
> + * interrupt sources to IRQ numbers.  We use a chained handler as the GPIO
> + * IRQ's may pass through a separate VIC on some systems so need to be
> + * enabled/disabled there too.
> + *
> + * The chained handler simply converts from the virtual IRQ handler to the
> + * real interrupt source and calls the GPIO IRQ handler.
> + */
> +static void dwgpio_irq_init(struct dw_gpio_chip *dw,
> +			    struct resource *demux_irqs,
> +			    struct resource *irqs)
> +{
> +	int i;
> +
> +	if (!demux_irqs && !irqs)
> +		return;
> +
> +	if (!demux_irqs || !irqs ||
> +	    resource_size(demux_irqs) != resource_size(irqs)) {
> +		dev_warn(dw->chip.dev, "unsupported IRQ demuxing configuration, continuing without GPIO IRQ support\n");
> +		return;
> +	}
> +
> +	dw->irq_base = irqs->start;
> +
> +	writel(0, INT_EN_REG(dw));
> +	writel(~0, EOI_REG(dw));
> +	for (i = irqs->start; i <= irqs->end; ++i) {
> +		irq_set_chip_and_handler_name(i, &dwgpio_irqchip,
> +					      handle_simple_irq, "demux");

Why do you have irq_ack/mask/unmask functions when you use
handle_simple_irq? Just because the random driver you copied from has
them as well? They are never called.

> +		irq_set_chip_data(i, dw);
> +		irq_set_status_flags(i, IRQ_TYPE_EDGE_BOTH |
> +					IRQ_TYPE_LEVEL_HIGH |
> +					IRQ_TYPE_LEVEL_LOW);

What's that for ?

> +		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);

Why are those irqs probable ?

> +	}
> +
> +	for (i = demux_irqs->start; i <= demux_irqs->end; ++i) {
> +		irq_set_handler_data(i, dw);
> +		irq_set_chained_handler(i, dw_gpio_irq_handler);
> +		set_irq_flags(i, IRQF_VALID);
> +	}
> +}

> +static void dwgpio_irq_stop(struct dw_gpio_chip *dw,
> +			    struct resource *demux_irqs,
> +			    struct resource *irqs)
> +{
> +	int i;
> +
> +	if (!demux_irqs || !irqs ||
> +	    resource_size(demux_irqs) != resource_size(irqs))
> +		return;
> +
> +	for (i = irqs->start; i < irqs->end; ++i) {

Are those interrupts disabled? And what removes the handler ?

> +		irq_set_chip(i, NULL);
> +		irq_set_chip_data(i, NULL);
> +	}
> +
> +	for (i = demux_irqs->start; i < demux_irqs->end; ++i) {

Ditto

> +		irq_set_chip(i, NULL);
> +		irq_set_chip_data(i, NULL);
> +	}
> +}

Sigh. This is another incarnation of a bog standard GPIO driver, which
has the ever repeating pattern of configuration, input read, output
write and interrupt functions. It's about time to stop that nonsense.

GPIO implementations are not that different and we really want to
abstract out the few implementations and be done with it.

Thanks,

	tglx
