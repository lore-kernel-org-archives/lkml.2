Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2BUWi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 17:38:29 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:48712 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754477Ab2BUWi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 17:38:28 -0500
X-Greylist: delayed 2213 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Feb 2012 17:38:28 EST
Date: Tue, 21 Feb 2012 15:28:53 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Aaron Sierra <asierra@xes-inc.com>
Cc: Guenter Roeck <guenter@roeck-us.net>, Peter Tyser <ptyser@xes-inc.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3 v4] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <20120221152853.054855fe@endymion.delvare>
In-Reply-To: <f850063d-78c1-4fa7-b7ba-49fb4aa28c5b@zimbra>
References: <20120218183158.47dfc0b6@endymion.delvare>
	<f850063d-78c1-4fa7-b7ba-49fb4aa28c5b@zimbra>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Feb 2012 14:36:27 -0600 (CST), Aaron Sierra wrote:
> > > +	}
> > > +
> > > +	/* Enable LPC ACPI space */
> > > +	pci_read_config_byte(dev, ACPICTRL, &reg_save);
> > > +	pci_write_config_byte(dev, ACPICTRL, reg_save | 0x10);
> > > +	lpc_ich_acpi_save = reg_save;
> > > +
> > > +pm_done:
> > > +	/* Setup GPIO base register */
> > > +	pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
> > > +	base_addr = base_addr_cfg & 0x0000ff80;
> > > +	if (!base_addr) {
> > > +		dev_err(&dev->dev, "I/O space for GPIO uninitialized\n");
> > > +		/* GPIO in power-management space may still be available */
> > > +		goto gpio_reg;
> > > +	}
> > > +
> > > +	gpio_ich_res[ICH_RES_GPIO].start = base_addr;
> > > +	gpio_ich_res[ICH_RES_GPIO].end = base_addr + GPIOBASE_IO_SIZE -
> > > 1;
> > > +	ret = acpi_check_resource_conflict(&gpio_ich_res[ICH_RES_GPIO]);
> > > +	if (ret) {
> > > +		/* this isn't necessarily fatal for the GPIO */
> > > +		gpio_ich_res[ICH_RES_GPIO].start = 0;
> > > +		gpio_ich_res[ICH_RES_GPIO].end = 0;
> > 
> > I don't quite get how this can be non-fatal, given that the gpio-ich
> > driver's probe function will return -ENODEV in this case. So if this
> > resource is mandatory, let's make it exactly that.
> 
> The necessity for the ICH_RES_GPIO resource to exist is an issue I
> thought better left to the gpio-ich driver. The way that driver is
> currently written it is mandatory, but it doesn't *have* to be written
> that way. For chipsets that have GPE0 and GPIO space, only one needs
> to be present to have some usable GPIO.

Ah, OK, I had misunderstood this, I thought GPIO was always mandatory.

We're only talking about the ICH6 and 3100, right? I find it
questionable that you even attempt to request and enable the GPE0 space
on all other chips then. This could cause error messages that are not
relevant at all.

> 
> > This means that resource 0 is mandatory and resource 1 is optional.
> > All you have to do then is:
> > * Don't register the mfd device at all if GPIO resource is
> > unavailable.
> > * If ACPI resource is unavailable, set num_resources to 1.
> > 
> > That should work, and this solves the ghost resource problem I
> > mentioned earlier.
> >
> > Yet a completely different approach would be to delegate the ACPI
> > resource conflict checking to the gpio-ich subdriver. I suspect we
> > may end up doing that anyway, as requesting the whole I/O range when
> > we only need subsets thereof is likely to cause ACPI resource
> > conflicts on too many systems for the driver to be useful in practice.
> > This is a bigger change though and I would understand if you are
> > reluctant to do it as this point of the review cycle. This can be
> > changed later and I volunteer to take care of it (I need it for my
> > Asus Z8NA-D6 board.)
> 
> You mean creating resources for individual bytes within 32-bit registers?

No, no, not to this level of granularity. My idea is to request 3
16-byte regions separately, namely starting at offsets 0x00, 0x30 and
0x40. This has two advantages :
* If the ACPI BIOS requests optional I/O ports as is the case on my
  board (they request one port at offset 0x1A, presumably to blink a
  LED) we can still request everything else. Of course we shouldn't
  touch the one GPIO used by the ACPI BIOS, but you should never touch
  a GPIO if you don't know what you're doing anyway.
* If the ACPI BIOS requests one block of GPIOs, this still gives us a
  chance to get our hands on the other blocks. I have not yet see a
  BIOS doing that but I imagine it could happen.

> Otherwise, the only optimization (fix) I see is that ACPIBASE_GPE0_BASE
> should be 0x28, not 0x20 and gpe0_sts_ofs in gpio-ich should be removed.
> Currently, that portion of gpio-ich appears to be broken.

If you only need the I/O port at offset 0x28, then indeed it might make
sense to only request that one to limit the risk of resource conflicts.

> The whole issue of anything related to boot firmware having dominion
> over hardware after booting to an OS is very frustrating.

Oh yes :( I really would like to see future versions of the ACPI
specification come up with a general solution to this problem.

> > > +		acpi_conflict = true;
> > > +		goto gpio_reg;
> > > +	}
> > > +
> > > +	/* Enable LPC GPIO space */
> > > +	pci_read_config_byte(dev, GPIOCTRL, &reg_save);
> > > +	pci_write_config_byte(dev, GPIOCTRL, reg_save | 0x10);
> > > +	lpc_ich_gpio_save = reg_save;
> > > +
> > > +gpio_reg:
> > 
> > Shouldn't this label be named gpio_done for consistency? Probably a
> > moot point given my remark above anyway.
> 
> Again, the label names come from lpc_ich after all three patches have
> been applied. In that case one label jumps to code immediately following
> WDT cell registration, "done with registration" and the other jumps
> immediately before GPIO cell registration, "do registration". If I make
> ICH_RES_GPIO mandatory, like you suggest, these labels could both follow
> cell registration and be named consistently.

Oh, OK. I have to admit I didn't look at the watchdog patch at all, as
I'm not using this feature. So feel free to ignore every comment of
mine which would find an answer in that patch ;)

> > > +	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_GPIO], id);
> > > +	ret = mfd_add_devices(&dev->dev, 0, &lpc_ich_cells[LPC_GPIO],
> > > +				1, NULL, 0);
> > > +	if (!ret)
> > > +		cell_added = true;
> > > +
> > > +	if (acpi_conflict)
> > > +		dev_info(&dev->dev, "ACPI resource conflicts found; "
> > > +				"consider using acpi_enforce_resources=lax?\n");
> > 
> > I'm not sure if it really makes sense to report this. ACPI resource
> > conflicts are already reported quite loudly by the acpi core. And
> > passing acpi_enforce_resources=lax blindly isn't quite recommended,
> > so I'm not sure if we really want to mention it here, it might do more
> > harm than help.
> 
> So the question mark doesn't imply strongly enough that it's not an action
> that should definitely be taken. Would you prefer a warning summarizing which
> drivers are affected by the detected resource conflicts or no additional warning
> at all?

I wouldn't put any additional warning at all. But maybe that's just me.

-- 
Jean Delvare
