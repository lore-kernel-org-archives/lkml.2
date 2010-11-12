Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab0KLBts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 20:49:48 -0500
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:28386 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756147Ab0KLBtr (ORCPT
	<rfc822;groupwise-jlee@novell.com:12:2>);
	Thu, 11 Nov 2010 20:49:47 -0500
Message-Id: <4CDD37E40200002300023BFA@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Thu, 11 Nov 2010 18:49:40 -0700
From: "Joey Lee" <jlee@novell.com>
To: <rui.zhang@intel.com>
Cc: <eric@anholt.net>, <chris@chris-wilson.co.uk>, <alexdeucher@gmail.com>,
        <lenb@kernel.org>, <airlied@linux.ie>,
        <dri-devel@lists.freedesktop.org>, <randy.dunlap@oracle.com>,
        <airlied@redhat.com>, <bskeggs@redhat.com>, <mjg59@srcf.ucam.org>,
        <gregkh@suse.de>, <trenn@suse.de>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Valdis.Kletnieks@vt.edu>,
        <Dennis.Jansen@web.de>
Subject: Re: [PATCH] Add Intel GMA500(Poulsbo) Stub Driver
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui, 

First, thank's for your review and take care.

於 五，2010-11-12 於 09:31 +0800，Zhang Rui 提到：
> Hi, Lee,
> 
> there are several regressions caused by this patch,
> http://marc.info/?l=linux-acpi&m=128872402020412&w=2
> http://marc.info/?l=linux-acpi&m=128858111022621&w=2
> 
> Yes, We can fix it by "select INPUT if ACPI"/"select
> VIDEO_OUTPUT_CONTROL if ACPI".
> But IMO,  STUB_POULSBO should not select ACPI_VIDEO at all,
> what do you think?
> 

Yes, I agreed.

We can just remove the _select ACPI_VIDEO if ACPI_ because user should
select it when they want to use.
If CONFIG_ACPI_VIDEO doesn't select, the stub poulsbo just do _not_
thing but will have no any bad thing.

So, let's direct remove it from Kconfig. Should I submit patch again?


Thank's
Joey Lee

> thanks,
> rui
> 
> On Wed, 2010-11-03 at 09:19 +0800, Zhang Rui wrote:
> > Hi, Lee,
> > 
> > Sorry I missed this thread.
> > 
> > On Wed, 2010-10-20 at 13:51 +0800, Lee, Chun-Yi wrote:
> > > Currently, there have no GMA500(Poulsbo) native video driver to support
> > > intel opregion. So, use this stub driver to enable the acpi backlight
> > > control sysfs entry files by requrest acpi_video_register.
> > > 
> > If you want the acpi backlight control, why not set CONFIG_ACPI_VIDEO
> > driver directly?
> > The reason why i915 driver selects ACPI_VIDEO is that it needs some
> > cooperation between these two drivers during initialization, or else the
> > system may hang.
> > 
> > thanks,
> > rui
> > 
> > > Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
> > > ---
> > >  drivers/gpu/Makefile       |    2 +-
> > >  drivers/gpu/stub/Kconfig   |   13 +++++++++
> > >  drivers/gpu/stub/Makefile  |    1 +
> > >  drivers/gpu/stub/poulsbo.c |   63 ++++++++++++++++++++++++++++++++++++++++++++
> > >  drivers/video/Kconfig      |    2 +
> > >  5 files changed, 80 insertions(+), 1 deletions(-)
> > >  create mode 100644 drivers/gpu/stub/Kconfig
> > >  create mode 100644 drivers/gpu/stub/Makefile
> > >  create mode 100644 drivers/gpu/stub/poulsbo.c
> > > 
> > > diff --git a/drivers/gpu/Makefile b/drivers/gpu/Makefile
> > > index 30879df..cc92778 100644
> > > --- a/drivers/gpu/Makefile
> > > +++ b/drivers/gpu/Makefile
> > > @@ -1 +1 @@
> > > -obj-y			+= drm/ vga/
> > > +obj-y			+= drm/ vga/ stub/
> > > diff --git a/drivers/gpu/stub/Kconfig b/drivers/gpu/stub/Kconfig
> > > new file mode 100644
> > > index 0000000..8f5a540
> > > --- /dev/null
> > > +++ b/drivers/gpu/stub/Kconfig
> > > @@ -0,0 +1,13 @@
> > > +config STUB_POULSBO
> > > +	tristate "Intel GMA500 Stub Driver"
> > > +	depends on PCI
> > > +        # Poulsbo stub depends on ACPI_VIDEO when ACPI is enabled
> > > +        # but for select to work, need to select ACPI_VIDEO's dependencies, ick
> > > +        select ACPI_VIDEO if ACPI
> > > +	help
> > > +	  Choose this option if you have a system that has Intel GMA500
> > > +	  (Poulsbo) integrated graphics. If M is selected, the module will
> > > +	  be called Poulsbo. This driver is a stub driver for Poulsbo that
> > > +	  will call poulsbo.ko to enable the acpi backlight control sysfs
> > > +	  entry file because there have no poulsbo native driver can support
> > > +	  intel opregion.
> > > diff --git a/drivers/gpu/stub/Makefile b/drivers/gpu/stub/Makefile
> > > new file mode 100644
> > > index 0000000..cd940cc
> > > --- /dev/null
> > > +++ b/drivers/gpu/stub/Makefile
> > > @@ -0,0 +1 @@
> > > +obj-$(CONFIG_STUB_POULSBO) += poulsbo.o
> > > diff --git a/drivers/gpu/stub/poulsbo.c b/drivers/gpu/stub/poulsbo.c
> > > new file mode 100644
> > > index 0000000..d8aa636
> > > --- /dev/null
> > > +++ b/drivers/gpu/stub/poulsbo.c
> > > @@ -0,0 +1,63 @@
> > > +/*
> > > + * Intel Poulsbo Stub driver
> > > + *
> > > + * Copyright (C) 2010 Novell <jlee@novell.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify it
> > > + * under the terms of the GNU General Public License version 2 as published by
> > > + * the Free Software Foundation.
> > > + *
> > > + */
> > > +
> > > +#include <linux/module.h>
> > > +#include <linux/pci.h>
> > > +#include <acpi/video.h>
> > > +
> > > +#define DRIVER_NAME "poulsbo"
> > > +
> > > +enum {
> > > +	CHIP_PSB_8108 = 0,
> > > +	CHIP_PSB_8109 = 1,
> > > +};
> > > +
> > > +static struct pci_device_id pciidlist[] = {
> > > +	{0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8108}, \
> > > +	{0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8109}, \
> > > +	{0, 0, 0}
> > > +};
> > > +
> > > +static int poulsbo_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> > > +{
> > > +	return acpi_video_register();
> > > +}
> > > +
> > > +static void poulsbo_remove(struct pci_dev *pdev)
> > > +{
> > > +	acpi_video_unregister();
> > > +}
> > > +
> > > +static struct pci_driver poulsbo_driver = {
> > > +	.name = DRIVER_NAME,
> > > +	.id_table = pciidlist,
> > > +	.probe = poulsbo_probe,
> > > +	.remove = poulsbo_remove,
> > > +};
> > > +
> > > +static int __init poulsbo_init(void)
> > > +{
> > > +	return pci_register_driver(&poulsbo_driver);
> > > +}
> > > +
> > > +static void __exit poulsbo_exit(void)
> > > +{
> > > +	pci_unregister_driver(&poulsbo_driver);
> > > +}
> > > +
> > > +module_init(poulsbo_init);
> > > +module_exit(poulsbo_exit);
> > > +
> > > +MODULE_AUTHOR("Lee, Chun-Yi <jlee@novell.com>");
> > > +MODULE_DESCRIPTION("Poulsbo Stub Driver");
> > > +MODULE_LICENSE("GPL");
> > > +
> > > +MODULE_DEVICE_TABLE(pci, pciidlist);
> > > diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> > > index 8b31fdf..8807ae5 100644
> > > --- a/drivers/video/Kconfig
> > > +++ b/drivers/video/Kconfig
> > > @@ -17,6 +17,8 @@ source "drivers/gpu/vga/Kconfig"
> > >  
> > >  source "drivers/gpu/drm/Kconfig"
> > >  
> > > +source "drivers/gpu/stub/Kconfig"
> > > +
> > >  config VGASTATE
> > >         tristate
> > >         default n
> > 
> 
> 

