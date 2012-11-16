Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab2KPNnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 08:43:15 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:14939 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab2KPNnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 08:43:14 -0500
Date: Fri, 16 Nov 2012 14:42:56 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        bhelgaas@google.com, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 3/3] i2c / ACPI: add ACPI enumeration support
Message-ID: <20121116144256.55b49cae@endymion.delvare>
In-Reply-To: <1499062.QDd9DGofy9@vostro.rjw.lan>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com>
	<2439178.tCj2rUMYJS@vostro.rjw.lan>
	<20121116140357.5e0a6d6b@endymion.delvare>
	<1499062.QDd9DGofy9@vostro.rjw.lan>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2012 14:21:54 +0100, Rafael J. Wysocki wrote:
> On Friday, November 16, 2012 02:03:57 PM Jean Delvare wrote:
> > Hi Rafael,
> > 
> > On Fri, 16 Nov 2012 11:09:03 +0100, Rafael J. Wysocki wrote:
> > > On Thursday, November 15, 2012 01:03:17 PM Mika Westerberg wrote:
> > > > ACPI 5 introduced I2cSerialBus resource that makes it possible to enumerate
> > > > and configure the I2C slave devices behind the I2C controller. This patch
> > > > adds helper functions to support I2C slave enumeration.
> > > > 
> > > > An ACPI enabled I2C controller driver only needs to call acpi_i2c_register_devices()
> > > > in order to get its slave devices enumerated, created and bound to the
> > > > corresponding ACPI handle.
> > > > 
> > > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > 
> > > Are there any objections against this patch or comments?
> > > 
> > > Worfram? Jean? Ben?
> > 
> > I am no longer maintaining the i2c subsystem and will not have the time
> > to look deeply into this. All I can say is that I very happy to see
> > this finally happen. Maybe with ACPI 5.0 we will finally be done with
> > resource conflicts plaguing many systems for several years now.
> > 
> > I took a quick look, and the only thing which seems suspicious is this
> > function:
> > 
> > > +static int acpi_i2c_find_child_address(struct acpi_resource *ares, void *data)
> > > +{
> > > +	struct acpi_resource_i2c_serialbus *sb;
> > > +	struct acpi_i2c_find *i2c_find = data;
> > > +
> > > +	if (ares->type != ACPI_RESOURCE_TYPE_SERIAL_BUS)
> > > +		return 1;
> > > +
> > > +	sb = &ares->data.i2c_serial_bus;
> > > +	if (sb->type != ACPI_RESOURCE_SERIAL_TYPE_I2C)
> > > +		return 1;
> > > +
> > > +	if (sb->slave_address == i2c_find->addr)
> > 
> > The 7-bit and 10-bit address maps overlap, so the above isn't enough.
> > You must compare the addresses _and_ sb->access_mode with
> > i2c_find->access_mode (which needs to be added and filled properly.)
> > 
> > > +		i2c_find->found = true;
> > > +
> > > +	return 1;
> > > +}
> > 
> > Plus, it seems odd that this function always returns 1.
> 
> Yes, this is a bug I think.  Mika?

The equivalent function for SPI devices does the same, so if this is a
bug, it must be fixed there too. If this is not a bug then it is
questionable why these functions return something in the first place.

But then again I didn't look into the design, so I may be missing
something.

-- 
Jean Delvare
