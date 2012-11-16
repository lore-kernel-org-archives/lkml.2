Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab2KPT6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:58:16 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:49505 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab2KPT6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:58:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Jean Delvare <khali@linux-fr.org>, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        bhelgaas@google.com, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 3/3] i2c / ACPI: add ACPI enumeration support
Date: Fri, 16 Nov 2012 21:02:36 +0100
Message-ID: <5908031.ZEcDQlG5EW@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121116141729.GS17774@intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com> <20121116144256.55b49cae@endymion.delvare> <20121116141729.GS17774@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 16, 2012 04:17:29 PM Mika Westerberg wrote:
> On Fri, Nov 16, 2012 at 02:42:56PM +0100, Jean Delvare wrote:
> > On Fri, 16 Nov 2012 14:21:54 +0100, Rafael J. Wysocki wrote:
> > > On Friday, November 16, 2012 02:03:57 PM Jean Delvare wrote:
> > > > Hi Rafael,
> > > > 
> > > > On Fri, 16 Nov 2012 11:09:03 +0100, Rafael J. Wysocki wrote:
> > > > > On Thursday, November 15, 2012 01:03:17 PM Mika Westerberg wrote:
> > > > > > ACPI 5 introduced I2cSerialBus resource that makes it possible to enumerate
> > > > > > and configure the I2C slave devices behind the I2C controller. This patch
> > > > > > adds helper functions to support I2C slave enumeration.
> > > > > > 
> > > > > > An ACPI enabled I2C controller driver only needs to call acpi_i2c_register_devices()
> > > > > > in order to get its slave devices enumerated, created and bound to the
> > > > > > corresponding ACPI handle.
> > > > > > 
> > > > > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > > > 
> > > > > Are there any objections against this patch or comments?
> > > > > 
> > > > > Worfram? Jean? Ben?
> > > > 
> > > > I am no longer maintaining the i2c subsystem and will not have the time
> > > > to look deeply into this. All I can say is that I very happy to see
> > > > this finally happen. Maybe with ACPI 5.0 we will finally be done with
> > > > resource conflicts plaguing many systems for several years now.
> > > > 
> > > > I took a quick look, and the only thing which seems suspicious is this
> > > > function:
> > > > 
> > > > > +static int acpi_i2c_find_child_address(struct acpi_resource *ares, void *data)
> > > > > +{
> > > > > +	struct acpi_resource_i2c_serialbus *sb;
> > > > > +	struct acpi_i2c_find *i2c_find = data;
> > > > > +
> > > > > +	if (ares->type != ACPI_RESOURCE_TYPE_SERIAL_BUS)
> > > > > +		return 1;
> > > > > +
> > > > > +	sb = &ares->data.i2c_serial_bus;
> > > > > +	if (sb->type != ACPI_RESOURCE_SERIAL_TYPE_I2C)
> > > > > +		return 1;
> > > > > +
> > > > > +	if (sb->slave_address == i2c_find->addr)
> > > > 
> > > > The 7-bit and 10-bit address maps overlap, so the above isn't enough.
> > > > You must compare the addresses _and_ sb->access_mode with
> > > > i2c_find->access_mode (which needs to be added and filled properly.)
> 
> Ok. I wasn't sure about that and given that 10-bit addresses are not that
> common I tought that we can just compare the addr to zero. I'll add the
> check.
> 
> > > > 
> > > > > +		i2c_find->found = true;
> > > > > +
> > > > > +	return 1;
> > > > > +}
> > > > 
> > > > Plus, it seems odd that this function always returns 1.
> > > 
> > > Yes, this is a bug I think.  Mika?
> > 
> > The equivalent function for SPI devices does the same, so if this is a
> > bug, it must be fixed there too. If this is not a bug then it is
> > questionable why these functions return something in the first place.
> > 
> > But then again I didn't look into the design, so I may be missing
> > something.
> 
> It is not a bug, it just means that we don't want the ACPI core to fill in
> normal resources (we only want to peek the ACPI resources and find the
> corresponding I2CSerialBus() resource).

Ah, that's what's called by acpi_dev_get_resources().  But what about writing
it this way:

static int acpi_i2c_find_child_address(struct acpi_resource *ares, void *data)
{

       if (ares->type == ACPI_RESOURCE_TYPE_SERIAL_BUS) {
       	struct acpi_resource_i2c_serialbus *sb;

       	sb = &ares->data.i2c_serial_bus;
       	if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_I2C) {
       		struct acpi_i2c_find *i2c_find = data;

       		if (sb->slave_address == i2c_find->addr)
				i2c_find->found = true;
		}
	}

	/* Tell the ACPI core to skip this resource. */
	return 1;
}

Seems easier to follow. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
