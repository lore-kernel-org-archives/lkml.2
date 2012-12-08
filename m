Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab2LHL0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 06:26:53 -0500
Received: from londo.lunn.ch ([80.238.139.98]:56137 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab2LHL0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 06:26:51 -0500
Date: Sat, 8 Dec 2012 12:26:24 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Subject: Re: [PATCH] ARM: Orion: Hoist bridge interrupt handling out of the
 timer
Message-ID: <20121208112624.GD25315@lunn.ch>
References: <20121207225507.GB29262@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207225507.GB29262@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 03:55:07PM -0700, Jason Gunthorpe wrote:
> The intent of this patch is to expose the other bridge cause
> interrupts to users in the kernel.
> 
> - Add orion_bridge_irq_init to create a new edge triggered interrupt
>   chip based on the bridge cause register
> - Remove all interrupt register code from time.c and use normal
>   interrupt functions instead
> - Update the machines that use orion_time_init to call
>   orion_bridge_irq_init and use the new signature

Hi Jason

I like the idea, but i think it needs to go a bit further. 

1) It should have an IRQ domain, like the other IRQ chips we have.
2) It should have a DT binding, like the other IRQ chips we have.
3) We then pass the timer interrupt via DT to the timer driver.
4) We than pass the watchdog interrupt via DT.

We plan to remove old style platforms in the next few cycles, so its
important that changes like this are orientated towards DT but have
the necessary backward compatibility for the old ways for the boards
not yet converted. I think for Dove all boards are DT based...

3) is not so simple, because we currently don't have a timer binding
for Orion SoC. However, with this cleanup, we are much closer to being
able to use the 370/XP timer code.


> @@ -534,8 +535,9 @@ static void __init kirkwood_timer_init(void)
>  {
>  	kirkwood_tclk = kirkwood_find_tclk();
>  
> -	orion_time_init(BRIDGE_VIRT_BASE, BRIDGE_INT_TIMER1_CLR,
> -			IRQ_KIRKWOOD_BRIDGE, kirkwood_tclk);
> +	orion_bridge_irq_init(IRQ_KIRKWOOD_BRIDGE, IRQ_KIRKWOOD_BRIDGE_START,
> +			      BRIDGE_CAUSE);
> +	orion_time_init(IRQ_KIRKWOOD_BRIDGE_TIMER1, kirkwood_tclk);
>  }

I think it would be better to do this in kirkwood_init_irq(). Same for
the other platforms. 

> +static void bridge_irq_handler(unsigned irq, struct irq_desc *desc)
> +{
> +	struct irq_chip_generic *gc = irq_get_handler_data(irq);
> +	u32 cause;
> +	int i;
> +
> +	cause = readl(gc->reg_base) & readl(gc->reg_base + 4);

Could you add a #define for this 4. I guess its an interrupt enable
mask? Could regs.mask be used?

> +	for (i = 0; i < 6; i++)
> +		if ((cause & (1 << i)))
> +			generic_handle_irq(i + gc->irq_base);
> +}
> +
> +static void irq_gc_eoi_inv(struct irq_data *d)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> +	u32 mask = 1 << (d->irq - gc->irq_base);
> +	struct irq_chip_regs *regs;
> +
> +	regs = &container_of(d->chip, struct irq_chip_type, chip)->regs;
> +	irq_gc_lock(gc);
> +	irq_reg_writel(~mask, gc->reg_base + regs->eoi);
> +	irq_gc_unlock(gc);
> +}
> +
> +void __init orion_bridge_irq_init(unsigned int bridge_irq,
> +				  unsigned int irq_start,
> +				  void __iomem *causeaddr)
> +{
> +	struct irq_chip_generic *gc;
> +	struct irq_chip_type *ct;
> +
> +	gc = irq_alloc_generic_chip("orion_irq_edge", 1, irq_start,

Maybe the name orion_bridge would be better?

Thanks
      Andrew
