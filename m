Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab2KENUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:20:55 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52836 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2KENUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:20:53 -0500
MIME-Version: 1.0
In-Reply-To: <20121105131519.GG24532@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
	<20121105120219.GF24532@intel.com>
	<20121105132350.59c6e4d9@endymion.delvare>
	<1983976.4JKTfcThF7@vostro.rjw.lan>
	<20121105131519.GG24532@intel.com>
Date: Mon, 5 Nov 2012 14:20:52 +0100
Message-ID: <CACRpkdaZqka7g2ECAyD_bKhnoULhCP6cTJwMyEsTuVxiUiHy+A@mail.gmail.com>
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jean Delvare <khali@linux-fr.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com, grant.likely@secretlab.ca,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 2:15 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Mon, Nov 05, 2012 at 01:59:23PM +0100, Rafael J. Wysocki wrote:
>> On Monday, November 05, 2012 01:23:50 PM Jean Delvare wrote:
>> > On Mon, 5 Nov 2012 14:02:19 +0200, Mika Westerberg wrote:
>> > > On Mon, Nov 05, 2012 at 11:56:39AM +0100, Mark Brown wrote:
(...)
>> > > Yeah, I just went through DSDT table of one of our machines and found a
>> > > device that actually has two I2CSerialBus connectors (and those are to the
>> > > same controller). What I'm not sure is that is it used to select between
>> > > two different addresses or doest the device really have two physical I2C
>> > > connections.
>> >
>> > Neither would make sense from a hardware perspective.
>>
>> Well, interesting. :-)
>
> It looks like some PMICs for example have two I2C control interfaces, like
> TI's TWL6030 if I'm not mistaken. If both are put behind the same I2C
> controller with different address, you have the situation like above.

This is quite common. So for example the AB8500 (drivers/mfd/ab8500-core.c)
has this. The reason is usually that the device has more than 256 registers
to the address space simply is not big enough.

What we do is refer to the subaddresses as "banks" and they happen
to always be at the next consecutive address so n+1.

So the same device appear behind several addresses just to support
a lot of registers.

So you're not actually modelling the devices on the other end but the
multiple addresses of a single device.

If the addresses are consecutive like ours it makes sense
to just instantiate one device and have the driver know that it will
also be able to access address +1, +2 ... +n. So is it possible
to group the consecutive related addresses after each other
here at the acpi-spi level and just create a single device?

If the addresses are not consecutive I guess you need to have
one device driver bind to several devices and return -EPROBE_DEFER
until the driver has been probed for all of them or something like
that, this is what multi-block GPIO drivers sometimes do.

Yours,
Linus Walleij
