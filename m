Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2JPHPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:15:37 -0400
Received: from smtp2.goneo.de ([212.90.139.82]:20162 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab2JPHPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:15:36 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.737
From: Lars Poeschel <poeschel@lemonage.de>
To: Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [PATCH v2 1/4] mfd: add viperboard driver
Date: Tue, 16 Oct 2012 09:15:33 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
References: <20120925085559.GL28670@sortiz-mobl> <1350052469-27802-1-git-send-email-larsi@wh2.tu-dresden.de> <alpine.DEB.2.01.1210151900530.27712@pmeerw.net>
In-Reply-To: <alpine.DEB.2.01.1210151900530.27712@pmeerw.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210160915.33766.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2012 at 19:09:53, Peter Meerwald wrote:
> minor nitpicking below
> 
> > From: Lars Poeschel <poeschel@lemonage.de>
> > 
> > Add mfd driver for Nano River Technologies viperboard.
> > 
> > Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> > ---
> > 
> >  drivers/mfd/Kconfig            |   14 ++++
> >  drivers/mfd/Makefile           |    1 +
> >  drivers/mfd/viperboard.c       |  149
> >  ++++++++++++++++++++++++++++++++++++++++ include/linux/mfd/viperboard.h
> >  |   99 ++++++++++++++++++++++++++ 4 files changed, 263 insertions(+)
> >  create mode 100644 drivers/mfd/viperboard.c
> >  create mode 100644 include/linux/mfd/viperboard.h
> > 
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index b1a1462..98d9fa3 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -1003,6 +1003,20 @@ config MFD_PALMAS
> > 
> >  	  If you say yes here you get support for the Palmas
> >  	  series of PMIC chips from Texas Instruments.
> > 
> > +config MFD_VIPERBOARD
> > +        tristate "Support for Nano River Technologies Viperboard"
> 
> probably wrong indentation (space vs. tab)?
> 
> > +	select MFD_CORE
> > +	depends on USB && IIO
> > +        default n
> > +        help
> > +          Say yes here if you want support for Nano River Technologies
> > +          Viperboard.
> > +          There are mfd cell drivers available for i2c master, adc and
> > +          both gpios found on the board. The spi part does not yet
> > +          have a driver.
> > +          You need to select the mfd cell drivers seperatly.
> 
> separately
> 
> > +          The drivers do not support all features the board exposes.
> > +
> > 
> >  endmenu
> >  endif
> > 
> > diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> > index 79dd22d..6ab6b64 100644
> > --- a/drivers/mfd/Makefile
> > +++ b/drivers/mfd/Makefile
> > @@ -128,6 +128,7 @@ obj-$(CONFIG_MFD_TPS65090)	+= tps65090.o
> > 
> >  obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
> >  obj-$(CONFIG_MFD_INTEL_MSIC)	+= intel_msic.o
> >  obj-$(CONFIG_MFD_PALMAS)	+= palmas.o
> > 
> > +obj-$(CONFIG_MFD_VIPERBOARD)    += viperboard.o
> > 
> >  obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
> >  obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
> >  obj-$(CONFIG_MFD_ANATOP)	+= anatop-mfd.o
> > 
> > diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
> > new file mode 100644
> > index 0000000..8095ea2
> > --- /dev/null
> > +++ b/drivers/mfd/viperboard.c
> > @@ -0,0 +1,149 @@
> > +/*
> > + *  Nano River Technologies viperboard driver
> > + *
> > + *  This is the core driver for the viperboard. There are cell drivers
> > + *  available for I2C, ADC and both GPIOs. SPI is not yet supported
> 
> full stop (.) missing
> 
> > + *  The drivers do not support all features the board exposes. See user
> > + *  manual of the viperboard.
> > + *
> > + *  (C) 2012 by Lemonage GmbH
> > + *  Author: Lars Poeschel <poeschel@lemonage.de>
> > + *  All rights reserved.
> > + *
> > + *  This program is free software; you can redistribute  it and/or
> > modify it + *  under  the terms of  the GNU General  Public License as
> > published by the + *  Free Software Foundation;  either version 2 of the
> >  License, or (at your + *  option) any later version.
> > + *
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/errno.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/types.h>
> > +#include <linux/mutex.h>
> > +
> > +#include <linux/mfd/core.h>
> > +#include <linux/mfd/viperboard.h>
> > +
> > +#include <linux/usb.h>
> > +
> > +
> > +static const struct usb_device_id vprbrd_table[] = {
> > +	{ USB_DEVICE(0x2058, 0x1005) },   /* Nano River Technologies */
> > +	{ }                               /* Terminating entry */
> > +};
> > +
> > +MODULE_DEVICE_TABLE(usb, vprbrd_table);
> > +
> > +static void vprbrd_dev_release(struct device *dev)
> > +{
> > +	return;
> 
> return not needed
> 
> > +}
> > +
> > +static void vprbrd_free(struct vprbrd *dev)
> > +{
> > +	usb_put_dev(dev->usb_dev);
> > +	kfree(dev);
> > +}

Thanks for your review. I will change this and after waiting some time for 
additional comments, I will do a version 3 of the whole patchset.

Regards,
Lars
