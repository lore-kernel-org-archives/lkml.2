Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2KERnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:43:40 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51674 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab2KERni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:43:38 -0500
MIME-Version: 1.0
In-Reply-To: <20121105171248.GJ24532@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdaZqka7g2ECAyD_bKhnoULhCP6cTJwMyEsTuVxiUiHy+A@mail.gmail.com>
 <20121105150326.3bbf69df@endymion.delvare> <1925265.4Cx64DgKbB@vostro.rjw.lan>
 <20121105145315.GI24532@intel.com> <20121105161920.44e8e1cb@endymion.delvare> <20121105171248.GJ24532@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 5 Nov 2012 10:43:17 -0700
Message-ID: <CAErSpo6h1uUG=Be8TmMeFcRcmTw2GWxChXUWOE0iS7oPNALNCQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Jean Delvare <khali@linux-fr.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, grant.likely@secretlab.ca,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 10:12 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Mon, Nov 05, 2012 at 04:19:20PM +0100, Jean Delvare wrote:
>> On Mon, 5 Nov 2012 16:53:15 +0200, Mika Westerberg wrote:
>> > On Mon, Nov 05, 2012 at 03:19:58PM +0100, Rafael J. Wysocki wrote:
>> > >
>> > > In the ACPI namespace we have device nodes and serial interfaces below them.
>> > > In the above case we see that a single device node supports two different
>> > > interfaces and in that case we probably should create two different
>> > > struct i2c_adapter objects for the same ACPI device node.
>> > >
>> > > Mika, what do you think?
>> >
>> > I agree.
>> >
>> > Only problem I see is that then we have two I2C adapter devices with the
>> > same ACPI ID (and hence the same i2c_client->name). I wonder what the I2C
>> > core thinks about that.
>>
>> I2C core fears that you're mixing up everything ;) I2C adapter devices
>> are struct i2c_adapter aka i2c-0, i2c-1 etc. i2c_client is for slave
>> devices. There's nothing wrong with i2c_clients sharing ->name, that's
>> even how device driver matching is achieved. The uniqueness of
>> i2c_clients is on their bus_id which is the combination of i2c adapter
>> number and slave address (e.g. 0-0050)
>
> Yeah, I mixed I2C adapter and client. Thanks for correcting.
>
> So if we create one I2C adapter from the platform bus code as we do now and
> then for each I2CSerialBus connector we create one I2C client (well, the
> one that is created when i2c_new_device() is called), everything should
> work, right?
>
> Then I suggest that we have a list of serial bus resources in the struct
> acpi_device and create the I2C clients based on that.
>
>> i2c_adapter->name should, OTOH, be unique. In i2c bus drivers we
>> usually append the base I/O address at the end of the name to guarantee
>> that. ACPI will have to come up with something similar.
>
> It should already be unique in case of ACPI. We use ACPI _HID and _UID to
> achieve that.

Using only _HID and _UID to guarantee uniqueness means you're relying
on a property of the BIOS, so you're vulnerable to BIOS bugs.

If there's an ACPI Device for I2C adapters, why wouldn't you just use
its device name as set in acpi_device_register() (basically a _HID +
instance number)?
