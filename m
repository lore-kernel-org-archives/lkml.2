Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab2BTUgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:36:43 -0500
Received: from xes-mad.com ([216.165.139.218]:52157 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab2BTUgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:36:42 -0500
Date: Mon, 20 Feb 2012 14:36:27 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter@roeck-us.net>, Peter Tyser <ptyser@xes-inc.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3 v4] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <f850063d-78c1-4fa7-b7ba-49fb4aa28c5b@zimbra>
In-Reply-To: <20120218183158.47dfc0b6@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC15 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +{
> > +	cell->id = id->driver_data;
> > +	cell->platform_data = &lpc_chipset_info[id->driver_data];
> > +	cell->pdata_size = sizeof(struct lpc_ich_info);
> > +}
> > +
> > +static int __devinit lpc_ich_probe(struct pci_dev *dev,
> > +				const struct pci_device_id *id)
> > +{
> > +	u32 base_addr_cfg;
> > +	u32 base_addr;
> > +	u8 reg_save;
> > +	int ret;
> > +	bool cell_added = false;
> > +	bool acpi_conflict = false;
> > +
> > +	/* Setup power management base register */
> > +	pci_read_config_dword(dev, ACPIBASE, &base_addr_cfg);
> > +	base_addr = base_addr_cfg & 0x0000ff80;
> > +	if (!base_addr) {
> > +		dev_err(&dev->dev, "I/O space for ACPI uninitialized\n");
> > +		goto pm_done;
> > +	}
> > +
> > +	gpio_ich_res[ICH_RES_GPE0].start = base_addr + ACPIBASE_GPE_OFF;
> > +	gpio_ich_res[ICH_RES_GPE0].end = base_addr + ACPIBASE_GPE_END;
> > +	ret = acpi_check_resource_conflict(&gpio_ich_res[ICH_RES_GPE0]);
> > +	if (ret) {
> > +		/* this isn't necessarily fatal for the GPIO */
> > +		gpio_ich_res[ICH_RES_GPE0].start = 0;
> > +		gpio_ich_res[ICH_RES_GPE0].end = 0;
> 
> Is it really sufficient to disable the resource? I see that you handle
> this case properly in the gpio-ich driver, however there's also the
> platform subsystem which needs to be considered. The above will cause
> platform_device_add_resources (called by mfd_add_device) to register
> an I/O resource at address 0, size 1. I can see it in /proc/ioports:
> 
> 0000-0cf7 : PCI Bus 0000:00
>   0000-001f : dma1
>     0000-0000 : gpio_ich.32	<-- HERE
>   0020-0021 : pic1
> 
> This is not clean and could cause a conflict on its own. So I don't
> think this is the right approach. See below for a possible solution.

I will work on a solution for this.

> > +		acpi_conflict = true;
> 
> Don't you want to jump to pm_done here? There's no point in enabling
> the LPC ACPI space if you are never going to access it. Not that it
> should really make a difference in practice, I presume that if ACPI
> is using the resource, the LPC ACPI space is already enabled...

I think this is another case where the code structure is based on the
complete 3-patch set. In this patch it would makes sense to have a jump
here, but after the 3rd patch is applied it would be removed anyway
because I consider the GPE region to be not strictly mandatory (which I
get into more below) and the watchdog timer regions in ACPI space need
to be tested before jumping.

> > +	}
> > +
> > +	/* Enable LPC ACPI space */
> > +	pci_read_config_byte(dev, ACPICTRL, &reg_save);
> > +	pci_write_config_byte(dev, ACPICTRL, reg_save | 0x10);
> > +	lpc_ich_acpi_save = reg_save;
> > +
> > +pm_done:
> > +	/* Setup GPIO base register */
> > +	pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
> > +	base_addr = base_addr_cfg & 0x0000ff80;
> > +	if (!base_addr) {
> > +		dev_err(&dev->dev, "I/O space for GPIO uninitialized\n");
> > +		/* GPIO in power-management space may still be available */
> > +		goto gpio_reg;
> > +	}
> > +
> > +	gpio_ich_res[ICH_RES_GPIO].start = base_addr;
> > +	gpio_ich_res[ICH_RES_GPIO].end = base_addr + GPIOBASE_IO_SIZE -
> > 1;
> > +	ret = acpi_check_resource_conflict(&gpio_ich_res[ICH_RES_GPIO]);
> > +	if (ret) {
> > +		/* this isn't necessarily fatal for the GPIO */
> > +		gpio_ich_res[ICH_RES_GPIO].start = 0;
> > +		gpio_ich_res[ICH_RES_GPIO].end = 0;
> 
> I don't quite get how this can be non-fatal, given that the gpio-ich
> driver's probe function will return -ENODEV in this case. So if this
> resource is mandatory, let's make it exactly that.

The necessity for the ICH_RES_GPIO resource to exist is an issue I
thought better left to the gpio-ich driver. The way that driver is
currently written it is mandatory, but it doesn't *have* to be written
that way. For chipsets that have GPE0 and GPIO space, only one needs
to be present to have some usable GPIO.

> This means that resource 0 is mandatory and resource 1 is optional.
> All you have to do then is:
> * Don't register the mfd device at all if GPIO resource is
> unavailable.
> * If ACPI resource is unavailable, set num_resources to 1.
> 
> That should work, and this solves the ghost resource problem I
> mentioned earlier.
>
> Yet a completely different approach would be to delegate the ACPI
> resource conflict checking to the gpio-ich subdriver. I suspect we
> may end up doing that anyway, as requesting the whole I/O range when
> we only need subsets thereof is likely to cause ACPI resource
> conflicts on too many systems for the driver to be useful in practice.
> This is a bigger change though and I would understand if you are
> reluctant to do it as this point of the review cycle. This can be
> changed later and I volunteer to take care of it (I need it for my
> Asus Z8NA-D6 board.)

You mean creating resources for individual bytes within 32-bit registers?
Otherwise, the only optimization (fix) I see is that ACPIBASE_GPE0_BASE
should be 0x28, not 0x20 and gpe0_sts_ofs in gpio-ich should be removed.
Currently, that portion of gpio-ich appears to be broken.

The whole issue of anything related to boot firmware having dominion
over hardware after booting to an OS is very frustrating.

> > +		acpi_conflict = true;
> > +		goto gpio_reg;
> > +	}
> > +
> > +	/* Enable LPC GPIO space */
> > +	pci_read_config_byte(dev, GPIOCTRL, &reg_save);
> > +	pci_write_config_byte(dev, GPIOCTRL, reg_save | 0x10);
> > +	lpc_ich_gpio_save = reg_save;
> > +
> > +gpio_reg:
> 
> Shouldn't this label be named gpio_done for consistency? Probably a
> moot point given my remark above anyway.

Again, the label names come from lpc_ich after all three patches have
been applied. In that case one label jumps to code immediately following
WDT cell registration, "done with registration" and the other jumps
immediately before GPIO cell registration, "do registration". If I make
ICH_RES_GPIO mandatory, like you suggest, these labels could both follow
cell registration and be named consistently.
 
> > +	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_GPIO], id);
> > +	ret = mfd_add_devices(&dev->dev, 0, &lpc_ich_cells[LPC_GPIO],
> > +				1, NULL, 0);
> > +	if (!ret)
> > +		cell_added = true;
> > +
> > +	if (acpi_conflict)
> > +		dev_info(&dev->dev, "ACPI resource conflicts found; "
> > +				"consider using acpi_enforce_resources=lax?\n");
> 
> I'm not sure if it really makes sense to report this. ACPI resource
> conflicts are already reported quite loudly by the acpi core. And
> passing acpi_enforce_resources=lax blindly isn't quite recommended,
> so I'm not sure if we really want to mention it here, it might do more
> harm than help.

So the question mark doesn't imply strongly enough that it's not an action
that should definitely be taken. Would you prefer a warning summarizing which
drivers are affected by the detected resource conflicts or no additional warning
at all?

-Aaron S.
