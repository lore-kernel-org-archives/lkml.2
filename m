Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab2KHURx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:17:53 -0500
Received: from mga03.intel.com ([143.182.124.21]:45961 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756614Ab2KHURw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:17:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,739,1344236400"; 
   d="scan'208";a="215196499"
Date: Thu, 8 Nov 2012 22:20:42 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Message-ID: <20121108202042.GD16012@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <1493573.krE1QVlUux@vostro.rjw.lan>
 <20121107130548.GZ24532@intel.com>
 <30766811.i5oXHLoU7e@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30766811.i5oXHLoU7e@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 01:46:24AM +0100, Rafael J. Wysocki wrote:
> On Wednesday, November 07, 2012 03:05:48 PM Mika Westerberg wrote:
> > On Wed, Nov 07, 2012 at 12:14:31PM +0100, Rafael J. Wysocki wrote:
> > > > So is the idea now that the ACPI core parses the resources and passes them
> > > > forward via struct acpi_device? I'm just wondering how to proceed with
> > > > these I2C and SPI enumeration patches.
> > > 
> > > Well, we definitely don't want to duplicate what drivers/pnp/pnpacpi/rsparser.c
> > > does, so the idea is to move the code from there to the core in such a way that
> > > both the SPI/I2C patches and the PNP layer can use it.
> > 
> > Ok.
> > 
> > > I'll have some prototype code ready shortly, hopefully, and I'll post it
> > > in that form for comments (and so that you know what to expect).
> > 
> > Sounds good. Thanks!
> 
> There you go.
> 
> I haven't even try to compile it, so most likely it breaks things left, right
> and in between, but I hope it shows the idea.

Thanks Rafael!

I'll try this tomorrow (we had problems with the HW today so I wasn't able
to do any testing).

I'll convert the SPI and I2C enumeration patches to use this method.

> It does a couple of things at the same time, so it should be split into a few
> simpler patches.  First, it moves some code from drivers/pnp/pnpacpi/rsparser.c
> to a new file drivers/acpi/resource.c and makes pnpacpi use functions from
> there.  Second, it changes acpi_platform.c to use those functions too.
> Finally, it adds a list of ACPI resources to struct acpi_device and
> makes acpi_platform.c use that list intead of evaluating _CRS and parsing its
> output with acpi_walk_resources().
> 
> While changing acpi_platform.c I noticed that we had a bug in there, because
> GSIs were registered for the struct acpi_device object, although they should be
> registered for the struct platform_device one created by that code.  I didn't
> try to fix that in the patch below, but it generally needs fixing.

Good point.

I wonder if the acpi_register_gsi() wants a device that is registered to
the Linux device framework? At least with the SPI and I2C we generally
don't have such until we call i2c_new_device() or spi_add_device() and they
are getting passed the IRQ number which should be translated to the Linux
IRQ before that...
