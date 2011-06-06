Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1FFM7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:59:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59345 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab1FFM7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:59:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] spi: reorganize drivers
Date: Mon, 6 Jun 2011 14:57:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-pcmcia@lists.infradead.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        "David S. Miller" <davem@davemloft.net>, Michael Buesch <mb@bu3sch.de>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Florian Fainelli <florian@openwrt.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
References: <20110605071725.26517.11573.stgit@ponder> <201106061321.07400.arnd@arndb.de> <20110606141636.150c54b5@endymion.delvare>
In-Reply-To: <20110606141636.150c54b5@endymion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061457.43999.arnd@arndb.de>
X-Provags-ID: V02:K0:2N7MKq4y3vDJVVEPpxnyAZbZxkUyJ7nrFePAp56Pykg
 N1me7ULVlmxbMEYMjPJrL4NQpnLgGVezkPRm9XTIs8CLT9qnnv
 +hNN4U1FyhVqQXzlP/L8swejYynus+/a5/AyPjYJgNS+wmbejx
 G2mmMWB4CWLgdRgIQfBVsGQ06Xj+jiiafqkb/ivPJWl+xKDRNe
 sVbT0POBlSknS1sPQ/Tuw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 June 2011, Jean Delvare wrote:
> On Mon, 6 Jun 2011 13:21:07 +0200, Arnd Bergmann wrote:
> > A top-level /bus would work for me, and I guess would also address Russell's
> > concern. Regarding bus-specific drivers, we're gradually moving those out
> > of the bus specific directories anyway, basically the only bus directory
> > that really has device driver in it is USB at this point. It makes some
> > sense to have a bus-specific low-level user space interface driver like
> > sg or uio in the bus directory, but everything else should really belong
> > into some other subsystem.
> 
> Err, what about I2C and SPI? Aren't drivers/i2c/busses and drivers/spi
> full of "device drivers"? Or are these what you call "bus-specific
> drivers"? Maybe we need to define all the terms before the discussion
> continues further.

drivers/i2c/busses and drivers/spi are full of what I would call "bus
drivers" or "host drivers". They bind to a device from another bus
(platform, pci, ...) and export devices of their own type (i2c, spi, ...).
This is what all bus drivers do.

An i2c or spi device driver would in turn bind to that device and
provide a functionality not specific to that bus (e.g. hwmon, input,
leds, rtc or media).

> > (...)
> > This is about to get worse as we introduce new subsystems (e.g. iommu,
> > irq, clocksource, eeprom, nvram, ...) into which we are moving
> > code from arch/arm, drivers/char and drivers/misc. Having buses and
> > drivers in a separate hierarchy would make the drivers directory and
> > the respective menuconfig list more clearly structured IMHO.
> 
> This gets interesting. Would you suggest for example that i2c-core.c
> goes to bus/i2c, and drivers/i2c/busses becomes drivers/i2c? And that
> CONFIG_I2C is somewhere in menuconfig, and the hardware driver
> selection for drivers/i2c is in a totally different place?

No, all of drivers/i2c would go into bus/i2c or drivers/bus/i2c, there
is no point splitting that. The part that would no go there is the various
drivers that are already not under drivers/i2c but are for devices
connected to an i2c bus.

The confusion is probably that in case of drivers/scsi and drivers/usb,
both bus and device drivers are in the same subdirectories. If we move
drivers/usb to bus/usb, I would probably recommend to split
drivers/usb/{serial,storage,atm,misc} out of it and move it to
drivers/{tty/usb-serial,block/usb,net/usb/atm,misc/usb} though, to
make it look more like PCI or i2c that already have a clean split.

> While I am surprised, I am not necessarily objecting. But it seems that
> you should better define what your actual plan is, before asking us if
> we agree with it.

My original plan was to think this through a bit more, but Grant posted
the big spi reorganization, so I jumped in on that because it wouldn't
be nice to have to move all those drivers again.

	Arnd
