Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab2BGVKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 16:10:52 -0500
Received: from imr4.ericy.com ([198.24.6.9]:48025 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837Ab2BGVKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 16:10:52 -0500
Message-ID: <1328648948.2261.309.camel@groeck-laptop>
Subject: Re: [PATCH 1/3 v2] mfd: Add LPC driver for Intel ICH chipsets
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Aaron Sierra <asierra@xes-inc.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>
Date: Tue, 7 Feb 2012 13:09:08 -0800
In-Reply-To: <107b5c23-51b0-4365-ae8c-810fb380a707@zimbra>
References: <107b5c23-51b0-4365-ae8c-810fb380a707@zimbra>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 16:00 -0500, Aaron Sierra wrote:
> > > +static int __devinit lpc_ich_probe(struct pci_dev *dev,
> > > +                               const struct pci_device_id *id)
> > > +{
> > > +       u32 base_addr_cfg;
> > > +       u32 base_addr;
> > > +       u8 reg_save;
> > > +       int ret;
> > > +       int cells = 0;
> > > +       int acpi_conflict = 0;
> > > +
> > You can use bool for acpi_conflict (and cells, but I don't think that
> > is needed anyway).
> 
> I agree that bool is a better type choice. See my comment at the end
> regarding my reason for using cells.
> 
> 
> > > +pm_done:
> > > +       /* Setup GPIO base register */
> > > +       pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
> > > +       base_addr = base_addr_cfg & 0x0000ff80;
> > > +       if (!base_addr) {
> > > +               dev_err(&dev->dev, "I/O space for GPIO
> > > uninitialized\n");
> > > +               /* GPIO in power-management space may still be
> > > available */
> > > +               goto gpio_reg;
> > > +       }
> > > +
> > > +       gpio_ich_res[ICH_RES_GPIO].start = base_addr;
> > > +       gpio_ich_res[ICH_RES_GPIO].end = base_addr +
> > > GPIOBASE_IO_SIZE - 1;
> > > +       ret =
> > > acpi_check_resource_conflict(&gpio_ich_res[ICH_RES_GPIO]);
> > > +       if (ret) {
> > > +               /* this isn't necessarily fatal for the GPIO */
> > > +               gpio_ich_res[ICH_RES_GPIO].start = 0;
> > > +               gpio_ich_res[ICH_RES_GPIO].end = 0;
> > > +               acpi_conflict++;
> > 
> > 	acpi_conflict = true;
> > 
> > After all, it does not really matter how many conflicts were
> > detected.
> 
> I agree.
> 
> > > +gpio_reg:
> > > +       lpc_ich_finalize_cell(&lpc_ich_cells[LPC_GPIO], id);
> > > +       ret = mfd_add_devices(&dev->dev, 0,
> > > &lpc_ich_cells[LPC_GPIO],
> > > +                               1, NULL, 0);
> > > +       if (!ret)
> > > +               cells++;
> > > +
> > So if there is an error, ret < 0, correct ?
> > 
> > > +       if (acpi_conflict)
> > > +               dev_info(&dev->dev, "ACPI resource conflicts found;
> > > "
> > > +                               "consider using
> > > acpi_enforce_resources=lax?\n");
> > > +
> > > +       if (cells)
> > > +               return 0;
> > > +       else
> > > +               return -ENODEV;
> > 
> > If the above is true, you can just return ret, and you don't need the
> > cells variable. Or, even better, move the acpi warning above the call
> > to mfd_add_devices().
> 
> The cells variable isn't strictly necessary when we're only dealing
> with one cell registration, as we have if only looking at the lpc_ich
> and gpio-ich patches. The iTCO_wdt patch adds a second call to
> mfd_add_devices, so when we return we're interested if either of the
> calls succeeded. This was intended to be a forward thinking
> implementation, but I have no qualms about simplifying it in the
> initial lpc_ich patch.

No, just keep it - I realized that when I looked into the iTCO patch.

Thanks,
Guenter


