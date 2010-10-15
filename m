Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab0JOPGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:06:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37043 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755350Ab0JOPGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:06:03 -0400
Date: Fri, 15 Oct 2010 16:04:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [RESEND PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20101015160445.69d7695b@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1010151443520.2496@localhost6.localdomain6>
References: <20101014142924.12442.3219.stgit@localhost.localdomain>
	<alpine.LFD.2.00.1010151443520.2496@localhost6.localdomain6>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	pr_info("Moorestown GPIO pin info:\n");
> > +	for (i = 0; i < num; i++, pentry++)
> > +		pr_info("info[%2d]: controller = %16.16s, pin_name = %16.16s,"
> > +		" pin = %d\n", i,
> > +			pentry->controller_name,
> > +			pentry->pin_name,
> > +			pentry->pin_no);
> 
> Shouldn't this be pr_debug ? Also MRST boot seems to be printing out
> the world and some more in a completely inconsistent way. Grep will
> fail miserably to get any info from this noise.

Probably. There is a lot of debug that should probably get pruned for
upstream.

> Can we please make this 16/17 string length stuff all over the place a
> readable define like SFI_DEVNAME_LEN instead of a magic number ?

OK

> > +/* the offset for the mapping of global gpio pin to irq */
> > +#define MRST_IRQ_OFFSET 0x100
> 
> Uuurg. How does the gpio irq chip implementation know about this
> number ? Another define somewhere else ?

Good question. I'll chase that up in detail

> > +static void *pmic_gpio_platform_data(void *info)
> > +{
> > +	static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
> > +	int gpio_base = get_gpio_by_name("pmic_gpio_base");
> > +
> > +	if (gpio_base == -1)
> > +		gpio_base = 64;	/* Needed for 0.7 SFI firmware */
> 
> Hmm, for 0.8 firmware this will do the same thing, when the
> pmic_gpio_base entry or the gpio table itself are missing. So how is
> this 0.7 specific and what are the consequences when the table is
> wrong or the entry missing on purpose?

That would make no sense at all. A GPIO chip needs th GPIO base. We'd
fall back, which worst case is no worse than failing anyway.

> These printks, pr_info, pr_err ...  lack a consistent prefix like
> "MRST: " all over the place. IIRC pr_xxx supports that already.

Ok.

> So these pin numbers are taken as is from the SFI table. Are those
> tables more trustworthy than ACPI tables? I'm not seeing that there is
> any basic sanity checking on those entries.

They should be trustworthy, if not your box isn't going to get very
whether sanity checked or not ?

> > +static void intel_scu_device_register(struct platform_device *pdev)
> > +{
> > +	BUG_ON(ipc_next_dev == MAX_IPCDEVS);
> 
> Why crash the machine here ? Above you don't care when the pin number
> is 4711 or whatever.

If we have more devices than the array can hold we are screwed, but the
values we have set are way in excess of anything on current systems and I
don't think old kernel on a system from far future is going to work
anyway because of the nature of the devices.

> > +/* Called by IPC driver */
> > +void intel_scu_devices_create(void)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < ipc_next_dev; i++)
> > +		platform_device_add(ipc_devs[i]);
> > +
> > +	for (i = 0; i < spi_next_dev; i++) {
> > +		spi_register_board_info(spi_devs[i], 1);
> > +		kfree(spi_devs[i]);
> 
> Hmm, we kfree but keep the reference in spi_devs.

That's a bug I think. Will double check.


> > +static void install_irq_resource(struct platform_device *pdev, int irq)
> > +{
> > +	/* Single threaded */
> > +	static struct resource res = {
> > +		.name = "IRQ",
> > +		.flags = IORESOURCE_IRQ,
> > +	};
> 
> And why needs this to be static and cant be just on the stack ?

I would ask the reverse question. Why put this on the stack when the code
to put it there is larger than the structure being statically
initialised ?

> > +	const char **p = &to_force[0];
> > +	while (*p != NULL) {
> > +		if (strcmp(*p, name) == 0)
> > +			return 1;
> > +		p++;
> > +	}
> > +	return 0;
> > +}
> 
> Aren't most of these functions including the static arrays inside of
> the functions __init ?

No. Or do you mean that they should be ? The latter seems to be a good
point, and would make the static structs even more sensible.

> > +	spi_info->platform_data = pdata;
> > +	if (dev->delay)
> 
> What's the reason of this delay magic ? I guess the scu module needs
> to be loaded, right? Took me a time to figure it out. So can we give
> that a sensible function name which makes that obvious ?

Some hardware needs to initialise after the SCU (or SCU dependant
devices) are discovered. What sort of name did you have in mind other
than intel_delayed_spi_device_register ?

> > +#define MRST_SPI2_CS_START	4
> 
> Where's that magic constant coming from and is it never subject to
> change on later MRST incarnations ?

It's fixed and magic (don't blame me I didn't design this platform !)

> > +static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;

> How is that different from pmic_gpio_pdata in
> pmic_gpio_platform_data() and why do we need two incarnations of the
> same data structure with the same name in different places ?

Yes I ought to move it into the function so its clear which is which.

> Guys, this is confusing as hell and needs a cleanup. I understand that
> your firmware dudes suck big time, but replicating the suckage in the
> kernel is even worse. I don't want to see the code which is cooking
> for SFI version 0.9.

I've not seen any yet. I'm hoping I can get the OK to delete all the 0.7
stuff as well.
 
> So either consolidate this or split out the horror into different
> source files so it's entirely clear which clusterfuck is necessary for
> which broken version of SFI.
> 
> While at it we really need to start to move that stuff into a separate
> directory. arch/x86/kernel has become the dumpground for everything
> and some more. We are going to see a gazillion of mrst, sodaville and
> next gen support files, which really have nothing to do with the core
> kernel functionality of x86.

Yes I had this argument about a year ago and was told the reverse 8)

We need x86/platform/ type stuff for PC, EFI "post PC", MID, OLPC etc just
as ARM has. (ok maybe not quite... ;))

Where do you want it put.

> This function should be written into one line and submitted to the
> obfuscated c-code contest.

Well we are submitting code to the kernel so it isn't one line and it's
not obfuscated. I'm not sure I follow your point ?

> What about making gpio_button __init_data and let pb_shrink copy the
> real entries to gpio_button_real, which even could be kmalloc'ed with
> the proper size ?

Yeah we could, which would make it use more memory than if we didn't and
introduce another theoretical out of memory failure case.


I'm not convinced about the static struct arguments. I'll go over the
other stuff and also kick people about dumping 0.7 support.

Alan
