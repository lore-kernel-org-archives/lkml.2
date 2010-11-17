Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab0KQDE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 22:04:27 -0500
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:10517 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871Ab0KQDE0 (ORCPT
	<rfc822;groupwise-jlee@novell.com:5:2>);
	Tue, 16 Nov 2010 22:04:26 -0500
Message-Id: <4CE3E0DE0200002300024037@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Tue, 16 Nov 2010 20:04:14 -0700
From: "Joey Lee" <jlee@novell.com>
To: <rui.zhang@intel.com>
Cc: <mingo@elte.hu>, <lenb@kernel.org>, <airlied@redhat.com>,
        <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  do not select ACPI_VIDEO in poulsbo stub driver
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui, 

於 三，2010-11-17 於 08:42 +0800，Zhang Rui 提到：
> On Tue, 2010-11-16 at 15:34 +0800, Joey Lee wrote:
> > Hi Rui, 
> > 
> > Sorry about this patch will not work on my MSi poulsbo machine.
> > 
> > 於 二，2010-11-16 於 14:04 +0800，Zhang Rui 提到：
> > > the poulsbo stub driver should not select ACPI video driver.
> > > 
> > > The reason why i915 driver selects ACPI video driver is that it needs some
> > > cooperation between these two drivers during initialization, or else the
> > > system may hang.
> > > 
> > > So if users want ACPI backlight control, please set CONFIG_ACPI_VIDEO manually.
> > > 
> > > http://marc.info/?l=linux-acpi&m=128952659018533&w=2
> > > 
> > > CC: Ingo Molnar <mingo@elte.hu>
> > > CC: Dave Airlie <airlied@redhat.com>
> > > CC: Lee, Chun-Yi <joeyli.kernel@gmail.com>
> > > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > > ---
> > >  drivers/gpu/stub/Kconfig   |   11 +----------
> > >  drivers/gpu/stub/poulsbo.c |    5 +----
> > >  2 files changed, 2 insertions(+), 14 deletions(-)
> > > 
> > > Index: linux-2.6/drivers/gpu/stub/Kconfig
> > > ===================================================================
> > > --- linux-2.6.orig/drivers/gpu/stub/Kconfig
> > > +++ linux-2.6/drivers/gpu/stub/Kconfig
> > > @@ -1,16 +1,7 @@
> > >  config STUB_POULSBO
> > >  	tristate "Intel GMA500 Stub Driver"
> > >  	depends on PCI
> > > -	# Poulsbo stub depends on ACPI_VIDEO when ACPI is enabled
> > > -	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
> > > -	select VIDEO_OUTPUT_CONTROL if ACPI
> > > -	select BACKLIGHT_CLASS_DEVICE if ACPI
> > > -	select INPUT if ACPI
> > > -	select ACPI_VIDEO if ACPI
> > >  	help
> > >  	  Choose this option if you have a system that has Intel GMA500
> > >  	  (Poulsbo) integrated graphics. If M is selected, the module will
> > > -	  be called Poulsbo. This driver is a stub driver for Poulsbo that
> > > -	  will call poulsbo.ko to enable the acpi backlight control sysfs
> > > -	  entry file because there have no poulsbo native driver can support
> > > -	  intel opregion.
> > > +	  be called Poulsbo.
> > > Index: linux-2.6/drivers/gpu/stub/poulsbo.c
> > > ===================================================================
> > > --- linux-2.6.orig/drivers/gpu/stub/poulsbo.c
> > > +++ linux-2.6/drivers/gpu/stub/poulsbo.c
> > > @@ -11,8 +11,6 @@
> > >  
> > >  #include <linux/module.h>
> > >  #include <linux/pci.h>
> > > -#include <linux/acpi.h>
> > > -#include <acpi/video.h>
> > >  
> > >  #define DRIVER_NAME "poulsbo"
> > >  
> > > @@ -29,12 +27,11 @@ static DEFINE_PCI_DEVICE_TABLE(pciidlist
> > >  
> > >  static int poulsbo_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> > >  {
> > > -	return acpi_video_register();
> > > +	return 0;
> > >  }
> > 
> > Sorry, we cann't remove to call acpi_video_register, because the acpi
> > video will not generate because there have some poulsbo machine declare
> > Intel opregion in DSDT but the i915 driver not support poulsbo.
> > 
> I'm confused.
> It's the i915 driver that supports Intel Opregion.
> i.e. for a poulsbo machine with Intel Opregion, loading ACPI video
> driver won't help neither.
> 

Matthew have a patch:

      * http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=commitdiff;h=74a365b3f354fafc537efa5867deb7a9fadbfe27

This patch do:

- ACPI video driver will not register if it check the DSDT have opregion table declare.
- i915_opregion will call acpi_video_register after it initialised the DIDL field in opregion.

That means acpi video driver will blocked when have opregion declare in
DSDT until i915 drm driver call acpi_video_register. The patch fixed
BKO#11259, but introduced a side effect: If there have Intel video chip
not supported by Intel drm driver, the acpi_video_register will never
called, then some machine have good acpi backlight interface
implementation will never have acpi brightness sysfs interface for
userland control. e.g. any Poulsbo netbook.

Matthew's comment to talk about the side effect: Intel IGD opregion and
GMA500

There have some machines declare opregion in DSDT but they also
implement the backlight control by EC in _BCM. Like: MSI poulsbo
netbook.
Before introduce the above patch to kernel, those machine's acpi
backlight control works fine. On current kernel, those machines
backlight control broken.

One function workable with old kernel but broken by new kernel, now.


> > That's why we add the poulsbo stub driver to enable the acpi video
> > because those machine implement acpi _BCL, _BCM interace and control
> > brightness by ec.
> 
> I got your idea.
> I'm not sure if this is right. IMO, the graphics driver and ACPI video
> driver are independent. I mean, to enable the ACPI backlight control,
> users should set CONFIG_ACPI_VIDEO explicitly.
> 
> And again, the reason why i915 driver selects ACPI_VIDEO is that the
> i915 Opregion code must run *before* ACPI video driver loaded, or else
> system hangs on some machines.
> and the reason why DRM_NOUVEAU selects ACPI_VIDEO is that it depends on
> ACPI to get the EDID info.
> 

Yes, Matthew's patch fix this issue. 

> So I don't see a strong reason that STUB_POULSBO should select
> ACPI_VIDEO.
> 

Does it possible we direct remove the "select ACPI_VIDEO if ACPI" from
Kconfig but keep the acpi_video_register function call in stub poulsbo
driver?
Because acpi/video.h already handle the ACPI VIDEO config check:

#if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
extern int acpi_video_register(void);
extern void acpi_video_unregister(void);
extern int acpi_video_get_edid(struct acpi_device *device, int type,
                               int device_id, void **edid);
#else
static inline int acpi_video_register(void) { return 0; }
static inline void acpi_video_unregister(void) { return; }


Thank's a lot!
Joey Lee

> thanks,
> rui
> > 
> > Here is our discussion:
> > 	http://www.spinics.net/lists/linux-acpi/msg30027.html
> > 
> > >  
> > >  static void poulsbo_remove(struct pci_dev *pdev)
> > >  {
> > > -	acpi_video_unregister();
> > >  }
> > >  
> > >  static struct pci_driver poulsbo_driver = {
> > > 
> > > 
> > 
> > I am sorry I miss understand your last mail for poulsbo stub driver
> > cann't dependency on input, because your patch is old.
> > 
> > The following is the newest patch that was send out by me:
> > 
> > 
> > >From 340b1068b20cfa152ff9992a7d69d19501b57163 Mon Sep 17 00:00:00 2001
> > From: Lee, Chun-Yi <jlee@novell.com>
> > Date: Wed, 15 Sep 2010 22:19:25 +0800
> > Subject: [PATCH] Add Intel GMA500(Poulsbo) Stub Driver
> > 
> > Currently, there have no GMA500(Poulsbo) native video driver to support
> > intel opregion. So, use this stub driver to enable the acpi backlight
> > control sysfs entry files by requrest acpi_video_register.
> > 
> > Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
> > ---
> >  drivers/gpu/Makefile       |    2 +-
> >  drivers/gpu/stub/Kconfig   |   13 +++++++++
> >  drivers/gpu/stub/Makefile  |    1 +
> >  drivers/gpu/stub/poulsbo.c |   63 ++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/video/Kconfig      |    2 +
> >  5 files changed, 80 insertions(+), 1 deletions(-)
> >  create mode 100644 drivers/gpu/stub/Kconfig
> >  create mode 100644 drivers/gpu/stub/Makefile
> >  create mode 100644 drivers/gpu/stub/poulsbo.c
> > 
> > diff --git a/drivers/gpu/Makefile b/drivers/gpu/Makefile
> > index 30879df..cc92778 100644
> > --- a/drivers/gpu/Makefile
> > +++ b/drivers/gpu/Makefile
> > @@ -1 +1 @@
> > -obj-y			+= drm/ vga/
> > +obj-y			+= drm/ vga/ stub/
> > diff --git a/drivers/gpu/stub/Kconfig b/drivers/gpu/stub/Kconfig
> > new file mode 100644
> > index 0000000..8f5a540
> > --- /dev/null
> > +++ b/drivers/gpu/stub/Kconfig
> > @@ -0,0 +1,13 @@
> > +config STUB_POULSBO
> > +	tristate "Intel GMA500 Stub Driver"
> > +	depends on> > +        # Poulsbo stub depends on ACPI_VIDEO when ACPI is enabled
> > +        # but for select to work, need to select ACPI_VIDEO's dependencies, ick
> > +        select ACPI_VIDEO if ACPI
> > +	help
> > +	  Choose this option if you have a system that has Intel GMA500
> > +	  (Poulsbo) integrated graphics. If M is selected, the module will
> > +	  be called Poulsbo. This driver is a stub driver for Poulsbo that
> > +	  will call poulsbo.ko to enable the acpi backlight control sysfs
> > +	  entry file because there have no poulsbo native driver can support
> > +	  intel opregion.
> > diff --git a/drivers/gpu/stub/Makefile b/drivers/gpu/stub/Makefile
> > new file mode 100644
> > index 0000000..cd940cc
> > --- /dev/null
> > +++ b/drivers/gpu/stub/Makefile
> > @@ -0,0 +1 @@
> > +obj-$(CONFIG_STUB_POULSBO) += poulsbo.o
> > diff --git a/drivers/gpu/stub/poulsbo.c b/drivers/gpu/stub/poulsbo.c
> > new file mode 100644
> > index 0000000..d8aa636
> > --- /dev/null
> > +++ b/drivers/gpu/stub/poulsbo.c
> > @@ -0,0 +1,63 @@
> > +/*
> > + * Intel Poulsbo Stub driver
> > + *
> > + * Copyright (C) 2010 Novell <jlee@novell.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License version 2 as published by
> > + * the Free Software Foundation.
> > + *
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/pci.h>
> > +#include <acpi/video.h>
> > +
> > +#define DRIVER_NAME "poulsbo"
> > +
> > +enum {
> > +	CHIP_PSB_8108 = 0,
> > +	CHIP_PSB_8109 = 1,
> > +};
> > +
> > +static struct pci_device_id pciidlist[] = {
> > +	{0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8108}, \
> > +	{0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8109}, \
> > +	{0, 0, 0}
> > +};
> > +
> > +static int poulsbo_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> > +{
> > +	return acpi_video_register();
> > +}
> > +
> > +static void poulsbo_remove(struct pci_dev *pdev)
> > +{
> > +	acpi_video_unregister();
> > +}
> > +
> > +static struct pci_driver poulsbo_driver = {
> > +	.name = DRIVER_NAME,
> > +	.id_table = pciidlist,
> > +	.probe = poulsbo_probe,
> > +	.remove = poulsbo_remove,
> > +};
> > +
> > +static int __init poulsbo_init(void)
> > +{
> > +	return pci_register_driver(&poulsbo_driver);
> > +}
> > +
> > +static void __exit poulsbo_exit(void)
> > +{
> > +	pci_unregister_driver(&poulsbo_driver);
> > +}
> > +
> > +module_init(poulsbo_init);
> > +module_exit(poulsbo_exit);
> > +
> > +MODULE_AUTHOR("Lee, Chun-Yi <jlee@novell.com>");
> > +MODULE_DESCRIPTION("Poulsbo Stub Driver");
> > +MODULE_LICENSE("GPL");
> > +
> > +MODULE_DEVICE_TABLE(pci, pciidlist);
> > diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> > index 8b31fdf..8807ae5 100644
> > --- a/drivers/video/Kconfig
> > +++ b/drivers/video/Kconfig
> > @@ -17,6 +17,8 @@ source "drivers/gpu/vga/Kconfig"
> >  
> >  source "drivers/gpu/drm/Kconfig"
> >  
> > +source "drivers/gpu/stub/Kconfig"
> > +
> >  config VGASTATE
> >         tristate
> >         default n
> 
> 

