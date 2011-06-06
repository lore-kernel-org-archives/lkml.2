Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab1FFNqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:46:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36140 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab1FFNqW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:46:22 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 6 Jun 2011 15:44:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jean Delvare <khali@linux-fr.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Grant Likely <grant.likely@secretlab.ca>,
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
Subject: Re: [PATCH] spi: reorganize drivers
Message-ID: <20110606154447.51f07c7b@stein>
In-Reply-To: <201106061457.43999.arnd@arndb.de>
References: <20110605071725.26517.11573.stgit@ponder>
	<201106061321.07400.arnd@arndb.de>
	<20110606141636.150c54b5@endymion.delvare>
	<201106061457.43999.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 06 Arnd Bergmann wrote:
> On Monday 06 June 2011, Jean Delvare wrote:
> > On Mon, 6 Jun 2011 13:21:07 +0200, Arnd Bergmann wrote:
> > > A top-level /bus would work for me, and I guess would also address Russell's
> > > concern. Regarding bus-specific drivers, we're gradually moving those out
> > > of the bus specific directories anyway, basically the only bus directory
> > > that really has device driver in it is USB at this point. It makes some
> > > sense to have a bus-specific low-level user space interface driver like
> > > sg or uio in the bus directory, but everything else should really belong
> > > into some other subsystem.
> > 
> > Err, what about I2C and SPI? Aren't drivers/i2c/busses and drivers/spi
> > full of "device drivers"? Or are these what you call "bus-specific
> > drivers"? Maybe we need to define all the terms before the discussion
> > continues further.
> 
> drivers/i2c/busses and drivers/spi are full of what I would call "bus
> drivers" or "host drivers". They bind to a device from another bus
> (platform, pci, ...) and export devices of their own type (i2c, spi, ...).
> This is what all bus drivers do.
> 
> An i2c or spi device driver would in turn bind to that device and
> provide a functionality not specific to that bus (e.g. hwmon, input,
> leds, rtc or media).
> 
> > > (...)
> > > This is about to get worse as we introduce new subsystems (e.g. iommu,
> > > irq, clocksource, eeprom, nvram, ...) into which we are moving
> > > code from arch/arm, drivers/char and drivers/misc. Having buses and
> > > drivers in a separate hierarchy would make the drivers directory and
> > > the respective menuconfig list more clearly structured IMHO.
> > 
> > This gets interesting. Would you suggest for example that i2c-core.c
> > goes to bus/i2c, and drivers/i2c/busses becomes drivers/i2c? And that
> > CONFIG_I2C is somewhere in menuconfig, and the hardware driver
> > selection for drivers/i2c is in a totally different place?
> 
> No, all of drivers/i2c would go into bus/i2c or drivers/bus/i2c, there
> is no point splitting that. The part that would no go there is the various
> drivers that are already not under drivers/i2c but are for devices
> connected to an i2c bus.
> 
> The confusion is probably that in case of drivers/scsi and drivers/usb,
> both bus and device drivers are in the same subdirectories. If we move
> drivers/usb to bus/usb, I would probably recommend to split
> drivers/usb/{serial,storage,atm,misc} out of it and move it to
> drivers/{tty/usb-serial,block/usb,net/usb/atm,misc/usb} though, to
> make it look more like PCI or i2c that already have a clean split.

On drivers/firewire/:

FireWire drivers are currently spread over drivers/firewire (three
link-layer controller drivers + the IEEE 1394 core + two IEEE 1394
application layer drivers), drivers/media/dvb/firewire/ (one 1394
application layer driver), sound/firewire/ (two 1394 application layer
drivers, more are planned to be added there).

>From the Linux driver model POV,
  1. the IEEE 1394 core driver implements the firewire bus,
  2. the link-layer controller drivers implement pci bus based devices,
  3. the IEEE 1394 application layer drivers implement firewire bus based
     devices.  The two of them that are located in drivers/firewire/
     expose a SCSI LLD (a transport in SCSI Architecture Model terms, but
     a host rather than a transport in Linux implementation terms) and a
     networking interface driver.

Number 2 is something one would expect to find in a hypothetical
drivers/bus/ directory.  But where do the others belong?

Would type 1 drivers be kept in drivers/bus/firewire/?  I understand your
above response to Jean that this is what you have in mind.

firewire-sbp2 could be moved into drivers/scsi/, and firewire-net could be
moved into drivers/net/.  But what about maintenance?  They could still be
maintained via linux1394-2.6.git because this worked so far, but then the
directory structure might irritate people who don't use
scripts/get_maintainer.pl all the time.  Well, I could actually picture
firewire-net to be maintained via the net development tree, but I do
wonder how well firewire-sbp2 maintenance through the scsi tree would work.

PS,
these are the same questions like with USB, only on a smaller scale.  (The
usb-storage driver is maintained through the usb tree as well, not the
scsi tree.  drivers/net/usb/ has got T: git .../gregkh/usb-2.6.git
assigned in MAINTAINERS but most of the commits there are actually done by
DaveM.)

PPS,
besides association of source files with development trees, there is also
the association with developer mailing lists and user mailing lists and
web resources, e.g. wiki.  How logical the directory layout is in this
sense could be approximately measured by means of the count of necessary
entries in MAINTAINERS.
-- 
Stefan Richter
-=====-==-== -==- --==-
http://arcgraph.de/sr/
