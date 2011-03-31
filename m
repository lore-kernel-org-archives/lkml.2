Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab1CaQ7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:59:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:37464 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868Ab1CaQ7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:59:10 -0400
Date: Thu, 31 Mar 2011 18:58:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Kevin Hilman <khilman@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Nicolas Pitre <nico@fluxnic.net>,
        david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-Reply-To: <201103311723.02301.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1103311826070.22418@localhost6.localdomain6>
References: <201103301906.42429.arnd@arndb.de> <alpine.LFD.2.00.1103311359320.22418@localhost6.localdomain6> <87d3l7jqpr.fsf@ti.com> <201103311723.02301.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Arnd Bergmann wrote:

> On Thursday 31 March 2011, Kevin Hilman wrote:
> > Some SoCs families (like OMAP) have huge amount of diversity even within
> > the SoC family, so better abstractions and generic infrastrucure
> > improvements are an obvious win, even staying within the SoC.
> 
> But that's the point. The incentive is there for managing the infrastructure
> within the SoC, but not across SoCs. Allow me to use OMAP as a bad example
> while pointing out that it's really one of the best supported platforms
> we currently have, while the others are usually much worse in terms of
> working with the community (or at least they are behind on the learning
> curve but getting there):
> 
> * OMAP2 introduced the hwmod concept as an attempt to reduce duplication
>   between board code, but the code was done on the mach-omap2 level
>   instead of finding a way to make it work across SOC vendors, or using
>   an existing solution.
> 
> * The IOMMU code in omap2 duplicates the API we have in the common kernel,
>   with slight differences, instead of using the existing code, making it
>   impossible to share a driver between SOC families.
> 
> * The ti-st code duplicates parts of the bluetooth layer (apparently
>   that is getting fixed soon).
> 
> * The DSS display drivers introduce new infrastructure include new bus
>   types that have the complexity to make them completely generic, but
>   in practice can only work on OMAP, and are clearly not written with
>   cross-vendor abstractions in mind.

Right, but the problem starts in way simpler areas like irq chips and
gpio stuff, where lots of the IP cores are similar and trivial enough
to be shared across many SoC families.

Even the OMAP "consolidated" code is silly:

static void _set_gpio_dataout(struct gpio_bank *bank, int gpio, int enable)
{
	void __iomem *reg = bank->base;
	u32 l = 0;

	switch (bank->method) {
#ifdef CONFIG_ARCH_OMAP1
	case METHOD_MPUIO:
		reg += OMAP_MPUIO_OUTPUT / bank->stride;
		l = __raw_readl(reg);
		if (enable)
			l |= 1 << gpio;
		else
			l &= ~(1 << gpio);
		break;
#endif
#ifdef CONFIG_ARCH_OMAP15XX
	case METHOD_GPIO_1510:
		reg += OMAP1510_GPIO_DATA_OUTPUT;
		l = __raw_readl(reg);
		if (enable)
			l |= 1 << gpio;
		else
			l &= ~(1 << gpio);
		break;
#endif
#ifdef CONFIG_ARCH_OMAP16XX
	case METHOD_GPIO_1610:
		if (enable)
			reg += OMAP1610_GPIO_SET_DATAOUT;
		else
			reg += OMAP1610_GPIO_CLEAR_DATAOUT;
		l = 1 << gpio;
		break;
#endif
#if defined(CONFIG_ARCH_OMAP730) || defined(CONFIG_ARCH_OMAP850)
	case METHOD_GPIO_7XX:
		reg += OMAP7XX_GPIO_DATA_OUTPUT;
		l = __raw_readl(reg);
		if (enable)
			l |= 1 << gpio;
		else
			l &= ~(1 << gpio);
		break;
#endif
#if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3)
	case METHOD_GPIO_24XX:
		if (enable)
			reg += OMAP24XX_GPIO_SETDATAOUT;
	else
			reg += OMAP24XX_GPIO_CLEARDATAOUT;
		l = 1 << gpio;
		break;
#endif
#ifdef CONFIG_ARCH_OMAP4
	case METHOD_GPIO_44XX:
		if (enable)
			reg += OMAP4_GPIO_SETDATAOUT;
		else
			reg += OMAP4_GPIO_CLEARDATAOUT;
		l = 1 << gpio;
		break;
#endif
	default:
		WARN_ON(1);
		return;
	}
	__raw_writel(l, reg);
}

So we have 2 types of sections:

#1
      data = read_reg();
      if (enable)
      	 data |= bit;
      else
         data &= ~bit;
      write_reg(data);

#2
      if (enable)
      	 write_enable_reg(bit);
      else
         write_disable_reg(bit);

But the code above has 6 cases in the switch because nobody abstracted
it out consequently. Not to talk about the ifdef mess.

So now look at tons of other gpio implementations all over the DOZENS
of ARM plat-/mach- space and guess what.

Most have either type #1 or type #2 just slightly different copied,
less or better abstracted and I'm pretty damned sure, that you could
consolidate all that stuff into a handful or even less drivers which
provide the code across the board.

Same for irq chips. Most of these gpio things have callbacks which do:

irq_xxx(struct irq_data *d)
{
	gpio = irq_data_get_irq_chip_data(d);
	irq = d->irq - gpio->base_irq;
	reg = convert_to_reg(gpio, irq);
	mask = convert_to_mask(gpio);

	write(reg, mask);
}

I saw all those incarnations lately and you can boil them down to a
handful or less as well which fit all over the place.

Start off with such a trivial, but immense effective cleanup and see
what it helps to share code even accross SoC vendors. They all glue
together random IP blocks from the market and there are not soo many
sources which are relevant. This makes sense in all aspects:

      1) less and better code
      2) faster setup for new SoCs
      3) shared benefit for all vendors

Thanks,

	tglx
