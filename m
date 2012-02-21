Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab2BUWVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 17:21:25 -0500
Received: from xes-mad.com ([216.165.139.218]:56065 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab2BUWVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 17:21:24 -0500
Date: Tue, 21 Feb 2012 16:21:12 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter@roeck-us.net>, Peter Tyser <ptyser@xes-inc.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3 v4] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <14262b0b-3937-45c0-bc01-93de9e2b4113@zimbra>
In-Reply-To: <20120221152853.054855fe@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC15 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 20 Feb 2012 14:36:27 -0600 (CST), Aaron Sierra wrote:
> > > > +	}
> > > > +
> > > > +	/* Enable LPC ACPI space */
> > > > +	pci_read_config_byte(dev, ACPICTRL, &reg_save);
> > > > +	pci_write_config_byte(dev, ACPICTRL, reg_save | 0x10);
> > > > +	lpc_ich_acpi_save = reg_save;
> > > > +
> > > > +pm_done:
> > > > +	/* Setup GPIO base register */
> > > > +	pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
> > > > +	base_addr = base_addr_cfg & 0x0000ff80;
> > > > +	if (!base_addr) {
> > > > +		dev_err(&dev->dev, "I/O space for GPIO uninitialized\n");
> > > > +		/* GPIO in power-management space may still be available */
> > > > +		goto gpio_reg;
> > > > +	}
> > > > +
> > > > +	gpio_ich_res[ICH_RES_GPIO].start = base_addr;
> > > > +	gpio_ich_res[ICH_RES_GPIO].end = base_addr + GPIOBASE_IO_SIZE
> > > > -
> > > > 1;
> > > > +	ret =
> > > > acpi_check_resource_conflict(&gpio_ich_res[ICH_RES_GPIO]);
> > > > +	if (ret) {
> > > > +		/* this isn't necessarily fatal for the GPIO */
> > > > +		gpio_ich_res[ICH_RES_GPIO].start = 0;
> > > > +		gpio_ich_res[ICH_RES_GPIO].end = 0;
> > > 
> > > I don't quite get how this can be non-fatal, given that the
> > > gpio-ich driver's probe function will return -ENODEV in this
> > > case. So if this resource is mandatory, let's make it exactly
> > > that.
> > 
> > The necessity for the ICH_RES_GPIO resource to exist is an issue I
> > thought better left to the gpio-ich driver. The way that driver is
> > currently written it is mandatory, but it doesn't *have* to be
> > written that way. For chipsets that have GPE0 and GPIO space, only
> > one needs to be present to have some usable GPIO.
> 
> Ah, OK, I had misunderstood this, I thought GPIO was always
> mandatory.
> 
> We're only talking about the ICH6 and 3100, right? I find it
> questionable that you even attempt to request and enable the GPE0
> space on all other chips then. This could cause error messages
> that are not relevant at all.

You'll see in the V5 patch that I followed your suggestion and now
treat the GPIO space as mandatory. The local version I have
prepared for V6 only looks for GPE0 space for ICH6 and i3100
devices.

> > Otherwise, the only optimization (fix) I see is that
> > ACPIBASE_GPE0_BASE should be 0x28, not 0x20 and gpe0_sts_ofs
> > in gpio-ich should be removed. Currently, that portion of
> > gpio-ich appears to be broken.
> 
> If you only need the I/O port at offset 0x28, then indeed it might
> make sense to only request that one to limit the risk of resource
> conflicts.

I addressed this with V5.

> > > > +	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_GPIO], id);
> > > > +	ret = mfd_add_devices(&dev->dev, 0, &lpc_ich_cells[LPC_GPIO],
> > > > +				1, NULL, 0);
> > > > +	if (!ret)
> > > > +		cell_added = true;
> > > > +
> > > > +	if (acpi_conflict)
> > > > +		dev_info(&dev->dev, "ACPI resource conflicts found; "
> > > > +				"consider using acpi_enforce_resources=lax?\n");
> > > 
> > > I'm not sure if it really makes sense to report this. ACPI
> > > resource
> > > conflicts are already reported quite loudly by the acpi core. And
> > > passing acpi_enforce_resources=lax blindly isn't quite
> > > recommended,
> > > so I'm not sure if we really want to mention it here, it might do
> > > more
> > > harm than help.
> > 
> > So the question mark doesn't imply strongly enough that it's not an
> > action that should definitely be taken. Would you prefer a warning
> > summarizing which drivers are affected by the detected resource
> > conflicts or no additional warning at all?
> 
> I wouldn't put any additional warning at all. But maybe that's just
> me.

In V5, I added warnings indicating which drivers are affected by
conflicts, since it was trivial with the way that I compartmentalized
gpio and watchdog mfd cell creation in that version.

-Aaron S.
