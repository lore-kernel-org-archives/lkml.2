Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992981Ab2KOIty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:49:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60327 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992592Ab2KOItw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:49:52 -0500
Date: Thu, 15 Nov 2012 09:49:45 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH 1/3] OF: Add helper for matching against linux,stdout-path
Message-ID: <20121115084945.GZ10369@pengutronix.de>
References: <1351849734-9836-1-git-send-email-s.hauer@pengutronix.de>
 <1351849734-9836-2-git-send-email-s.hauer@pengutronix.de>
 <CACxGe6uW+XN6RDnP+8QFXaCYqqPZO4dZM_aynR6AVMYZT=KuMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6uW+XN6RDnP+8QFXaCYqqPZO4dZM_aynR6AVMYZT=KuMg@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:47:56 up 144 days, 23:59, 40 users,  load average: 10.06, 14.55,
 12.45
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 08:49:54PM +0000, Grant Likely wrote:
> On Fri, Nov 2, 2012 at 9:48 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > devicetrees may have a linux,stdout-path property in the chosen
> > node describing the console device. This adds a helper function
> > to match a device against this property so a driver can call
> > add_preferred_console for a matching device.
> >
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >  drivers/of/Kconfig        |    3 +++
> >  drivers/of/Makefile       |    1 +
> >  drivers/of/of_stdout.c    |   27 +++++++++++++++++++++++++++
> >  include/linux/of_stdout.h |   24 ++++++++++++++++++++++++
> >  4 files changed, 55 insertions(+)
> >  create mode 100644 drivers/of/of_stdout.c
> >  create mode 100644 include/linux/of_stdout.h
> >
> > diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> > index dfba3e6..8574ebb 100644
> > --- a/drivers/of/Kconfig
> > +++ b/drivers/of/Kconfig
> > @@ -67,6 +67,9 @@ config OF_MDIO
> >         help
> >           OpenFirmware MDIO bus (Ethernet PHY) accessors
> >
> > +config OF_STDOUT
> > +       def_bool y
> > +
> >  config OF_PCI
> >         def_tristate PCI
> >         depends on PCI
> > diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> > index e027f44..c9f3f2f 100644
> > --- a/drivers/of/Makefile
> > +++ b/drivers/of/Makefile
> > @@ -8,6 +8,7 @@ obj-$(CONFIG_OF_I2C)    += of_i2c.o
> >  obj-$(CONFIG_OF_NET)   += of_net.o
> >  obj-$(CONFIG_OF_SELFTEST) += selftest.o
> >  obj-$(CONFIG_OF_MDIO)  += of_mdio.o
> > +obj-$(CONFIG_OF_STDOUT) += of_stdout.o
> >  obj-$(CONFIG_OF_PCI)   += of_pci.o
> >  obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
> >  obj-$(CONFIG_OF_MTD)   += of_mtd.o
> > diff --git a/drivers/of/of_stdout.c b/drivers/of/of_stdout.c
> > new file mode 100644
> > index 0000000..c9e370e
> > --- /dev/null
> > +++ b/drivers/of/of_stdout.c
> > @@ -0,0 +1,27 @@
> > +/*
> > + * OF helper for linux,stdoutpath property.
> > + *
> > + * This file is released under the GPLv2
> > + */
> > +#include <linux/of_stdout.h>
> > +
> > +/**
> > + * of_device_is_stdout_path - check if a device node matches the
> > + *                            linux,stdout-path property
> > + *
> > + * Check if this device node matches the linux,stdout-path property
> > + * in the chosen node. return true if yes, false otherwise.
> > + */
> > +int of_device_is_stdout_path(struct device_node *dn)
> > +{
> > +       const char *name;
> > +
> > +       name = of_get_property(of_chosen, "linux,stdout-path", NULL);
> > +       if (name == NULL)
> > +               return 0;
> > +
> > +       if (dn == of_find_node_by_path(name))
> 
> need to of_node_put() the return value of of_find_node_by_path()
> 
> > +               return 1;
> > +
> > +       return 0;
> > +}
> 
> Hi Sascha,
> 
> I'm fine with the helper, but there really is no need for a completely
> separate .c file. Just put it in drivers/of/base.c.

I guess the same applies to include/linux/of_stdout.h.

Should I drop the CONFIG_OF_STDOUT aswell?

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
