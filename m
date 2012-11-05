Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab2KEOPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:15:51 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:56015 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab2KEOPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:15:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Delvare <khali@linux-fr.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com, grant.likely@secretlab.ca,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Date: Mon, 05 Nov 2012 15:19:58 +0100
Message-ID: <1925265.4Cx64DgKbB@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121105150326.3bbf69df@endymion.delvare>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <CACRpkdaZqka7g2ECAyD_bKhnoULhCP6cTJwMyEsTuVxiUiHy+A@mail.gmail.com> <20121105150326.3bbf69df@endymion.delvare>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 05, 2012 03:03:26 PM Jean Delvare wrote:
> Hi Linus,
> 
> On Mon, 5 Nov 2012 14:20:52 +0100, Linus Walleij wrote:
> > On Mon, Nov 5, 2012 at 2:15 PM, Mika Westerberg
> > <mika.westerberg@linux.intel.com> wrote:
> > > On Mon, Nov 05, 2012 at 01:59:23PM +0100, Rafael J. Wysocki wrote:
> > >> On Monday, November 05, 2012 01:23:50 PM Jean Delvare wrote:
> > >> > On Mon, 5 Nov 2012 14:02:19 +0200, Mika Westerberg wrote:
> > >> > > On Mon, Nov 05, 2012 at 11:56:39AM +0100, Mark Brown wrote:
> > (...)
> > >> > > Yeah, I just went through DSDT table of one of our machines and found a
> > >> > > device that actually has two I2CSerialBus connectors (and those are to the
> > >> > > same controller). What I'm not sure is that is it used to select between
> > >> > > two different addresses or doest the device really have two physical I2C
> > >> > > connections.
> > >> >
> > >> > Neither would make sense from a hardware perspective.
> > >>
> > >> Well, interesting. :-)
> > >
> > > It looks like some PMICs for example have two I2C control interfaces, like
> > > TI's TWL6030 if I'm not mistaken. If both are put behind the same I2C
> > > controller with different address, you have the situation like above.
> 
> Ah, OK, if this is a degenerated case of a more complex initial design
> then yes it makes some sense. I had never met chips like that and did
> not know such chips existed.
> 
> That being said, from a software perspective, there is no difference
> between one or two I2C pin pairs being soldered. All we care about is
> which master they are ultimately connected to, and to which slave
> address(es) the chip replies.
> 
> > This is quite common. So for example the AB8500 (drivers/mfd/ab8500-core.c)
> > has this. The reason is usually that the device has more than 256 registers
> > to the address space simply is not big enough.
> 
> This is completely different from the case being discussed above. Even
> the most complex addressing scheme can be implemented using a single
> hardware I2C interface. You can use 16-bit register addresses (if you
> can live without SMBus compatibility, AT24C32 and larger EEPROMs do
> that), or implement internal banks (using one of the registers as the
> bank selector, hardware monitoring chips do that), or you can use
> multiple slave addresses (AT24C04 to C16 EEPROMs do that.)
> 
> > What we do is refer to the subaddresses as "banks" and they happen
> > to always be at the next consecutive address so n+1.
> > 
> > So the same device appear behind several addresses just to support
> > a lot of registers.
> > 
> > So you're not actually modelling the devices on the other end but the
> > multiple addresses of a single device.
> > 
> > If the addresses are consecutive like ours it makes sense
> > to just instantiate one device and have the driver know that it will
> > also be able to access address +1, +2 ... +n. So is it possible
> > to group the consecutive related addresses after each other
> > here at the acpi-spi level and just create a single device?
> 
> We were actually discussing I2C here, although I admit not in the right
> thread, and maybe some of this applies to SPI as well.
> 
> There are I2C devices replying to multiple non-consecutive slave
> addresses. Most notably Winbond hardware monitoring chips replying to
> one address in 0x2c-0x2f and 2 addresses in 0x48-0x4f. And of course
> there are the DDR3 DIMM SPD chips which have an EEPROM at 0x50-0x57 and
> a thermal sensor at 0x18-0x1f. So if multiple slave addresses must be
> supported, please do not limit this support to consecutive addresses.
> There really is no reason to limit us that way anyway, as i2c-core
> supports attaching any additional slave address to en existing
> i2c_client using i2c_new_dummy().
> 
> Note for DDR3 DIMM SPD chips we currently have two different drivers
> handling the two slave addresses (eeprom/at24 and jc42.) I don't know
> if this is something that could be instantiated from ACPI. So it seems
> we really have two different cases when a single chip replies to
> multiple slave addresses: either they refer to the same function and we
> want a single driver for all of them, or they are for unrelated
> functions and we want separate drivers (and thus separate i2c_clients.)
> Not sure how we can always handle that properly on the ACPI side.
> 
> > If the addresses are not consecutive I guess you need to have
> > one device driver bind to several devices and return -EPROBE_DEFER
> > until the driver has been probed for all of them or something like
> > that, this is what multi-block GPIO drivers sometimes do.
> 
> Consecutive or not makes no difference really, as long as the driver
> can deduce the additional addresses from the main address or register
> contents accessible from the main address. This has always been the
> case so far.

In the ACPI namespace we have device nodes and serial interfaces below them.
In the above case we see that a single device node supports two different
interfaces and in that case we probably should create two different
struct i2c_adapter objects for the same ACPI device node.

Mika, what do you think?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
