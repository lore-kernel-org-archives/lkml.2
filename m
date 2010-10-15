Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab0JOPdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:33:00 -0400
Received: from www.tglx.de ([62.245.132.106]:37511 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab0JOPc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:32:59 -0400
Date: Fri, 15 Oct 2010 17:32:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [RESEND PATCH] x86/mrst: add SFI platform device parsing code
In-Reply-To: <20101015160445.69d7695b@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1010151710260.2496@localhost6.localdomain6>
References: <20101014142924.12442.3219.stgit@localhost.localdomain> <alpine.LFD.2.00.1010151443520.2496@localhost6.localdomain6> <20101015160445.69d7695b@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010, Alan Cox wrote:
> > > +static void *pmic_gpio_platform_data(void *info)
> > > +{
> > > +	static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
> > > +	int gpio_base = get_gpio_by_name("pmic_gpio_base");
> > > +
> > > +	if (gpio_base == -1)
> > > +		gpio_base = 64;	/* Needed for 0.7 SFI firmware */
> > 
> > Hmm, for 0.8 firmware this will do the same thing, when the
> > pmic_gpio_base entry or the gpio table itself are missing. So how is
> > this 0.7 specific and what are the consequences when the table is
> > wrong or the entry missing on purpose?
> 
> That would make no sense at all. A GPIO chip needs th GPIO base. We'd
> fall back, which worst case is no worse than failing anyway.

Right, a GPIO chip needs the base. But when someone left out that
entry in the table because he does not use the GPIOs at this very
point the GPIO controller will initialize with random numbers, won't
it ?

Probably pointless hair splitting, but it looks weird and might
prevent the box to come up with some sensible debug info due to
initializing some black magic default stuff and exploding.
 
> > So these pin numbers are taken as is from the SFI table. Are those
> > tables more trustworthy than ACPI tables? I'm not seeing that there is
> > any basic sanity checking on those entries.
> 
> They should be trustworthy, if not your box isn't going to get very
> whether sanity checked or not ?

See above.
 
> > > +static void install_irq_resource(struct platform_device *pdev, int irq)
> > > +{
> > > +	/* Single threaded */
> > > +	static struct resource res = {
> > > +		.name = "IRQ",
> > > +		.flags = IORESOURCE_IRQ,
> > > +	};
> > 
> > And why needs this to be static and cant be just on the stack ?
> 
> I would ask the reverse question. Why put this on the stack when the code
> to put it there is larger than the structure being statically
> initialised ?

Fair enough.
 
> > > +	const char **p = &to_force[0];
> > > +	while (*p != NULL) {
> > > +		if (strcmp(*p, name) == 0)
> > > +			return 1;
> > > +		p++;
> > > +	}
> > > +	return 0;
> > > +}
> > 
> > Aren't most of these functions including the static arrays inside of
> > the functions __init ?
> 
> No. Or do you mean that they should be ? The latter seems to be a good
> point, and would make the static structs even more sensible.

Yes, they should be made __init. Sorry for being unclear.

> > > +	spi_info->platform_data = pdata;
> > > +	if (dev->delay)
> > 
> > What's the reason of this delay magic ? I guess the scu module needs
> > to be loaded, right? Took me a time to figure it out. So can we give
> > that a sensible function name which makes that obvious ?
> 
> Some hardware needs to initialise after the SCU (or SCU dependant
> devices) are discovered. What sort of name did you have in mind other
> than intel_delayed_spi_device_register ?

Well, if it depends on the SCU module to be loaded then make it
something like scu_spi_dev_register(), so it's obvious that these
depend on the SCU and cannot be registered directly with the spi
subsystem. intel_delayed tells nothing about the nature of the delay.

> > > +#define MRST_SPI2_CS_START	4
> > 
> > Where's that magic constant coming from and is it never subject to
> > change on later MRST incarnations ?
> 
> It's fixed and magic (don't blame me I didn't design this platform !)

I expected that you did not :)

> > > +static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
> 
> > How is that different from pmic_gpio_pdata in
> > pmic_gpio_platform_data() and why do we need two incarnations of the
> > same data structure with the same name in different places ?
> 
> Yes I ought to move it into the function so its clear which is which.
> 
> > Guys, this is confusing as hell and needs a cleanup. I understand that
> > your firmware dudes suck big time, but replicating the suckage in the
> > kernel is even worse. I don't want to see the code which is cooking
> > for SFI version 0.9.
> 
> I've not seen any yet. I'm hoping I can get the OK to delete all the 0.7
> stuff as well.

Would be the preferred solution :)
  
> > So either consolidate this or split out the horror into different
> > source files so it's entirely clear which clusterfuck is necessary for
> > which broken version of SFI.
> > 
> > While at it we really need to start to move that stuff into a separate
> > directory. arch/x86/kernel has become the dumpground for everything
> > and some more. We are going to see a gazillion of mrst, sodaville and
> > next gen support files, which really have nothing to do with the core
> > kernel functionality of x86.
> 
> Yes I had this argument about a year ago and was told the reverse 8)

Grr. Who was against it? I hope it was not me :)

> We need x86/platform/ type stuff for PC, EFI "post PC", MID, OLPC etc just
> as ARM has. (ok maybe not quite... ;))
> 
> Where do you want it put.

x86/platform/ with subdirectories for each family of particular horror
would be my obvious choice.

> > This function should be written into one line and submitted to the
> > obfuscated c-code contest.
> 
> Well we are submitting code to the kernel so it isn't one line and it's
> not obfuscated. I'm not sure I follow your point ?

Yeah, it's not one line. Otherwise I wouldnt have tried to understand
it and figure out whether it's correct or not. Which was harder than
necessary.

> > What about making gpio_button __init_data and let pb_shrink copy the
> > real entries to gpio_button_real, which even could be kmalloc'ed with
> > the proper size ?
> 
> Yeah we could, which would make it use more memory than if we didn't and
> introduce another theoretical out of memory failure case.

So make gpio_button __init_data and gpio_button_real static, which
gives you a bit more __init_data size, but less and easy to read code
to create the real data.
 
> I'm not convinced about the static struct arguments.

See above.

> I'll go over the other stuff and also kick people about dumping
> 0.7 support.

Thanks,

	tglx
