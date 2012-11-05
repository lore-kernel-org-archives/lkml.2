Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab2KEUmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:42:11 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53037 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab2KEUmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:42:06 -0500
MIME-Version: 1.0
In-Reply-To: <20121105150326.3bbf69df@endymion.delvare>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
	<20121105120219.GF24532@intel.com>
	<20121105132350.59c6e4d9@endymion.delvare>
	<1983976.4JKTfcThF7@vostro.rjw.lan>
	<20121105131519.GG24532@intel.com>
	<CACRpkdaZqka7g2ECAyD_bKhnoULhCP6cTJwMyEsTuVxiUiHy+A@mail.gmail.com>
	<20121105150326.3bbf69df@endymion.delvare>
Date: Mon, 5 Nov 2012 21:42:04 +0100
Message-ID: <CACRpkda26Ms3kipp4gF9TtOZY_qw8Y0DjYeAg-MB7iOre6j7aA@mail.gmail.com>
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
From: Linus Walleij <linus.walleij@linaro.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com, grant.likely@secretlab.ca,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 3:03 PM, Jean Delvare <khali@linux-fr.org> wrote:
(...)
>> If the addresses are consecutive like ours it makes sense
>> to just instantiate one device and have the driver know that it will
>> also be able to access address +1, +2 ... +n. So is it possible
>> to group the consecutive related addresses after each other
>> here at the acpi-spi level and just create a single device?
>
> We were actually discussing I2C here, although I admit not in the right
> thread, and maybe some of this applies to SPI as well.

This is my typo. The AB8500 example is indeed I2C.

> So if multiple slave addresses must be
> supported, please do not limit this support to consecutive addresses.

I buy that ... in Nomadik we even have an instance of a single device
with two discrete *physical* interfaces connected to it, on both of
them it responds to the same address, but with totally different
register layouts ... hardware engineers rule! :-)

> There really is no reason to limit us that way anyway, as i2c-core
> supports attaching any additional slave address to en existing
> i2c_client using i2c_new_dummy().

Yes, this is how we do it in AB8500. We just take advantage of
the fact that the addresses are consecutive.

> Note for DDR3 DIMM SPD chips we currently have two different drivers
> handling the two slave addresses (eeprom/at24 and jc42.) I don't know
> if this is something that could be instantiated from ACPI. So it seems
> we really have two different cases when a single chip replies to
> multiple slave addresses: either they refer to the same function and we
> want a single driver for all of them, or they are for unrelated
> functions and we want separate drivers (and thus separate i2c_clients.)
> Not sure how we can always handle that properly on the ACPI side.

If they can be accessed concurrently and do not share
any locks or code they should be separate I think?
When they have strong dependencies we immediately sort of
fall into the MFD class where you need a mediator I think.

>> If the addresses are not consecutive I guess you need to have
>> one device driver bind to several devices and return -EPROBE_DEFER
>> until the driver has been probed for all of them or something like
>> that, this is what multi-block GPIO drivers sometimes do.
>
> Consecutive or not makes no difference really, as long as the driver
> can deduce the additional addresses from the main address or register
> contents accessible from the main address. This has always been the
> case so far.

You're right.

Yours,
Linus Walleij
