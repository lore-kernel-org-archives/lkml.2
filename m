Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab2BHRsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:48:38 -0500
Received: from xes-mad.com ([216.165.139.218]:37376 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab2BHRsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:48:36 -0500
Date: Wed, 08 Feb 2012 11:48:21 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: guenter roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>
Subject: Re: [PATCH 3/3 v2] watchdog: Convert iTCO_wdt driver to mfd model
Message-ID: <e6ecaf2e-feb0-4ba8-9bf4-a5144411d8a4@zimbra>
In-Reply-To: <1328648878.2261.308.camel@groeck-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC15 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -429,11 +463,52 @@ static int __devinit lpc_ich_probe(struct
> > pci_dev *dev,
> >                 acpi_conflict++;
> >         }
> > 
> > +       wdt_io_res(ICH_RES_IO_TCO)->start = base_addr +
> > ACPIBASE_TCO_OFF;
> > +       wdt_io_res(ICH_RES_IO_TCO)->end = base_addr +
> > ACPIBASE_TCO_END;
> > +       ret =
> > acpi_check_resource_conflict(wdt_io_res(ICH_RES_IO_TCO));
> > +       if (ret) {
> > +               acpi_conflict++;
> > +               goto pm_done;
> > +       }
> > +
> > +       wdt_io_res(ICH_RES_IO_SMI)->start = base_addr +
> > ACPIBASE_SMI_OFF;
> > +       wdt_io_res(ICH_RES_IO_SMI)->end = base_addr +
> > ACPIBASE_SMI_END;
> > +       ret =
> > acpi_check_resource_conflict(wdt_io_res(ICH_RES_IO_SMI));
> > +       if (ret) {
> > +               acpi_conflict++;
> > +               goto pm_done;
> > +       }
> > +
> I'll have to look into the merged code, but doesn't this mean that
> iTCO resource requirement conflicts impact GPIO resource
> requirements ? If yes, is it possible to keep those separate ?

I believe that I accounted for this properly. I attempt to assign
the GPE0 resource before the iTCO resources. That way an ACPI
conflict with the iTCO resources can't cause the GPE0 resource to not
be assigned.


> > +static int __devinit iTCO_wdt_probe(struct platform_device *dev)
> >  {
> >         int ret;
> > -       u32 base_address;
> > -       unsigned long RCBA;
> >         unsigned long val32;
> > +       struct lpc_ich_info *ich_info = dev->dev.platform_data;
> > 
> > -       /*
> > -        *      Find the ACPI/PM base I/O address which is the base
> > -        *      for the TCO registers (TCOBASE=ACPIBASE + 0x60)
> > -        *      ACPIBASE is bits [15:7] from 0x40-0x43
> > -        */
> > -       pci_read_config_dword(pdev, 0x40, &base_address);
> > -       base_address &= 0x0000ff80;
> > -       if (base_address == 0x00000000) {
> > -               /* Something's wrong here, ACPIBASE has to be set
> > */
> > -               printk(KERN_ERR PFX "failed to get TCOBASE address,
> > "
> > -                                       "device disabled by
> > hardware/BIOS\n");
> > +       if (!ich_info)
> > +               return -ENODEV;
> > +
> > +       spin_lock_init(&iTCO_wdt_private.io_lock);
> > +
> > +       iTCO_wdt_private.tco_res =
> > +               platform_get_resource(dev, IORESOURCE_IO,
> > ICH_RES_IO_TCO);
> > +
> > +       iTCO_wdt_private.smi_res =
> > +               platform_get_resource(dev, IORESOURCE_IO,
> > ICH_RES_IO_SMI);
> > +
> > +       iTCO_wdt_private.gcs_res =
> > +               platform_get_resource(dev, IORESOURCE_MEM,
> > ICH_RES_MEM_GCS);
> > +
> > +       if (!iTCO_wdt_private.tco_res || !iTCO_wdt_private.smi_res
> > ||
> > +                       !iTCO_wdt_private.gcs_res) {
> > +               pr_info("No device detected.\n");
> >                 return -ENODEV;

This test and return doesn't account for any of the resources that may
have been successfully obtained.

> >         }
> > -       iTCO_wdt_private.iTCO_version =
> > -
> >                       iTCO_chipset_info[ent->driver_data].iTCO_version;
> > -       iTCO_wdt_private.ACPIBASE = base_address;
> > -       iTCO_wdt_private.pdev = pdev;
> > -
> > -       /* Get the Memory-Mapped GCS register, we need it for the
> > -          NO_REBOOT flag (TCO v2). To get access to it you have to
> > -          read RCBA from PCI Config space 0xf0 and use it as base.
> > -          GCS = RCBA + ICH6_GCS(0x3410). */
> > +
> > +       iTCO_wdt_private.iTCO_version = ich_info->iTCO_version;
> > +       iTCO_wdt_private.dev = dev;
> > +       iTCO_wdt_private.pdev = to_pci_dev(dev->dev.parent);
> > +
> > +       /*
> > +        * Get the Memory-Mapped GCS register, we need it for the
> > +        * NO_REBOOT flag (TCO v2).
> > +        */
> >         if (iTCO_wdt_private.iTCO_version == 2) {
> > -               pci_read_config_dword(pdev, 0xf0, &base_address);
> > -               if ((base_address & 1) == 0) {
> > -                       printk(KERN_ERR PFX "RCBA is disabled by
> > hardware"
> > -                                               "/BIOS, device
> > disabled\n");
> > -                       ret = -ENODEV;
> > +               if
> > (!request_mem_region(iTCO_wdt_private.gcs_res->start,
> > +                       resource_size(iTCO_wdt_private.gcs_res),
> > dev->name)) {
> > +                       ret = -EBUSY;
> >                         goto out;
> >                 }
> > -               RCBA = base_address & 0xffffc000;
> > -               iTCO_wdt_private.gcs = ioremap((RCBA + 0x3410), 4);
> > +               iTCO_wdt_private.gcs =
> > ioremap(iTCO_wdt_private.gcs_res->start,
> > +                       resource_size(iTCO_wdt_private.gcs_res));
> >         }
> > 
> >         /* Check chipset's NO_REBOOT bit */
> >         if (iTCO_wdt_unset_NO_REBOOT_bit() &&
> >         iTCO_vendor_check_noreboot_on()) {
> > -               printk(KERN_INFO PFX "unable to reset NO_REBOOT
> > flag, "
> > +               pr_info("unable to reset NO_REBOOT flag, "
> >                                         "device disabled by
> >                                         hardware/BIOS\n");
> >                 ret = -ENODEV;  /* Cannot reset NO_REBOOT bit */
> >                 goto out_unmap;
> > @@ -841,11 +559,11 @@ static int __devinit iTCO_wdt_init(struct
> > pci_dev *pdev,
> >         iTCO_wdt_set_NO_REBOOT_bit();
> > 
> >         /* The TCO logic uses the TCO_EN bit in the SMI_EN register
> >         */
> > -       if (!request_region(SMI_EN, 4, "iTCO_wdt")) {
> > -               printk(KERN_ERR PFX
> > -                       "I/O address 0x%04lx already in use, "
> > +       if (!request_region(iTCO_wdt_private.smi_res->start,
> > +                       resource_size(iTCO_wdt_private.smi_res),
> > dev->name)) {
> > +               pr_err("I/O address 0x%04llx already in use, "
> >                                                 "device
> >                                                 disabled\n",
> >                                                 SMI_EN);
> > -               ret = -EIO;
> > +               ret = -EBUSY;
> >                 goto out_unmap;
> >         }
> >         if (turn_SMI_watchdog_clear_off >=
> >         iTCO_wdt_private.iTCO_version) {
> > @@ -855,20 +573,16 @@ static int __devinit iTCO_wdt_init(struct
> > pci_dev *pdev,
> >                 outl(val32, SMI_EN);
> >         }
> > 
> > -       /* The TCO I/O registers reside in a 32-byte range pointed
> > to
> > -          by the TCOBASE value */
> > -       if (!request_region(TCOBASE, 0x20, "iTCO_wdt")) {
> > -               printk(KERN_ERR PFX "I/O address 0x%04lx already in
> > use "
> > -                                               "device
> > disabled\n", TCOBASE);
> > -               ret = -EIO;
> > +       if (!request_region(iTCO_wdt_private.tco_res->start,
> > +                       resource_size(iTCO_wdt_private.tco_res),
> > dev->name)) {
> > +               pr_err("I/O address 0x%04llx already in use device
> > disabled\n",
> > +                               TCOBASE);
> > +               ret = -EBUSY;
> >                 goto unreg_smi_en;
> >         }
> > 
> > -       printk(KERN_INFO PFX
> > -               "Found a %s TCO device (Version=%d,
> > TCOBASE=0x%04lx)\n",
> > -                       iTCO_chipset_info[ent->driver_data].name,
> > -
> >                       iTCO_chipset_info[ent->driver_data].iTCO_version,
> > -                       TCOBASE);
> > +       pr_info("Found a %s TCO device (Version=%d,
> > TCOBASE=0x%04llx)\n",
> > +               ich_info->name, ich_info->iTCO_version, TCOBASE);
> > 
> >         /* Clear out the (probably old) status */
> >         outw(0x0008, TCO1_STS); /* Clear the Time Out Status bit */
> > @@ -882,79 +596,38 @@ static int __devinit iTCO_wdt_init(struct
> > pci_dev *pdev,
> >            if not reset to the default */
> >         if (iTCO_wdt_set_heartbeat(heartbeat)) {
> >                 iTCO_wdt_set_heartbeat(WATCHDOG_HEARTBEAT);
> > -               printk(KERN_INFO PFX
> > -                       "timeout value out of range, using %d\n",
> > heartbeat);
> > +               pr_info("timeout value out of range, using %d\n",
> > heartbeat);
> >         }
> > 
> >         ret = misc_register(&iTCO_wdt_miscdev);
> >         if (ret != 0) {
> > -               printk(KERN_ERR PFX
> > -                       "cannot register miscdev on minor=%d
> > (err=%d)\n",
> > +               pr_err("cannot register miscdev on minor=%d
> > (err=%d)\n",
> >                                                         WATCHDOG_MINOR,
> >                                                         ret);
> >                 goto unreg_region;
> >         }
> > 
> > -       printk(KERN_INFO PFX "initialized. heartbeat=%d sec
> > (nowayout=%d)\n",
> > +       pr_info("initialized. heartbeat=%d sec (nowayout=%d)\n",
> >                                                         heartbeat,
> >                                                         nowayout);
> > 
> >         return 0;
> > 
> >  unreg_region:
> > -       release_region(TCOBASE, 0x20);
> > +       release_resource(iTCO_wdt_private.tco_res);
> >  unreg_smi_en:
> > -       release_region(SMI_EN, 4);
> > +       release_resource(iTCO_wdt_private.tco_res);
> 
> This doesn't look correct - you release tco_res twice. smi_res ?

Also, a release for gcs_res is currently missing here...

> 
> >  out_unmap:
> >         if (iTCO_wdt_private.iTCO_version == 2)
> >                 iounmap(iTCO_wdt_private.gcs);
> >  out:
> > -       iTCO_wdt_private.ACPIBASE = 0;
> > -       return ret;
> > -}
> > -
