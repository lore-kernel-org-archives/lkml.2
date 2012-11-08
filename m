Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab2KHUuC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:50:02 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:34899 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504Ab2KHUuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:50:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Date: Thu, 08 Nov 2012 21:54:12 +0100
Message-ID: <67633481.iZ3LZ2XKmP@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121108202042.GD16012@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <30766811.i5oXHLoU7e@vostro.rjw.lan> <20121108202042.GD16012@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 08, 2012 10:20:42 PM Mika Westerberg wrote:
> On Thu, Nov 08, 2012 at 01:46:24AM +0100, Rafael J. Wysocki wrote:
> > On Wednesday, November 07, 2012 03:05:48 PM Mika Westerberg wrote:
> > > On Wed, Nov 07, 2012 at 12:14:31PM +0100, Rafael J. Wysocki wrote:
> > > > > So is the idea now that the ACPI core parses the resources and passes them
> > > > > forward via struct acpi_device? I'm just wondering how to proceed with
> > > > > these I2C and SPI enumeration patches.
> > > > 
> > > > Well, we definitely don't want to duplicate what drivers/pnp/pnpacpi/rsparser.c
> > > > does, so the idea is to move the code from there to the core in such a way that
> > > > both the SPI/I2C patches and the PNP layer can use it.
> > > 
> > > Ok.
> > > 
> > > > I'll have some prototype code ready shortly, hopefully, and I'll post it
> > > > in that form for comments (and so that you know what to expect).
> > > 
> > > Sounds good. Thanks!
> > 
> > There you go.
> > 
> > I haven't even try to compile it, so most likely it breaks things left, right
> > and in between, but I hope it shows the idea.
> 
> Thanks Rafael!
> 
> I'll try this tomorrow (we had problems with the HW today so I wasn't able
> to do any testing).
> 
> I'll convert the SPI and I2C enumeration patches to use this method.

OK, but I still need to move parsers of interrupt resources from rsparser.c
to resource.c. :-)

> > It does a couple of things at the same time, so it should be split into a few
> > simpler patches.  First, it moves some code from drivers/pnp/pnpacpi/rsparser.c
> > to a new file drivers/acpi/resource.c and makes pnpacpi use functions from
> > there.  Second, it changes acpi_platform.c to use those functions too.
> > Finally, it adds a list of ACPI resources to struct acpi_device and
> > makes acpi_platform.c use that list intead of evaluating _CRS and parsing its
> > output with acpi_walk_resources().
> > 
> > While changing acpi_platform.c I noticed that we had a bug in there, because
> > GSIs were registered for the struct acpi_device object, although they should be
> > registered for the struct platform_device one created by that code.  I didn't
> > try to fix that in the patch below, but it generally needs fixing.
> 
> Good point.
> 
> I wonder if the acpi_register_gsi() wants a device that is registered to
> the Linux device framework?

No, it doesn't, as far as I can tell.  At least the pnpacpi code adds
devices after registering GSIs for them.  Also the existing implementations
of acpi_register_gsi() don't require that.

> At least with the SPI and I2C we generally
> don't have such until we call i2c_new_device() or spi_add_device() and they
> are getting passed the IRQ number which should be translated to the Linux
> IRQ before that...

That's correct.

It looks like we could follow the hpet code and pass NULL as the dev argument
to acpi_register_gsi() from there, as apparently the dev argument is only
used to special-case PCI devices in mp_config_acpi_gsi().

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
