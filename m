Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910Ab0IVEDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 00:03:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51437 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab0IVEDa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 00:03:30 -0400
MIME-Version: 1.0
In-Reply-To: <20100920152705.GJ3414@rakim.wolfsonmicro.main>
References: <20100920140049.31408.67527.stgit@localhost.localdomain>
 <20100920150431.GD31167@sirena.org.uk> <20100920152726.68ac2d84@linux.intel.com>
 <20100920152705.GJ3414@rakim.wolfsonmicro.main>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 22 Sep 2010 01:03:08 -0300
X-Google-Sender-Auth: T50rgDCpXqrXFwOiVCIs1ipnEeg
Message-ID: <AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 12:27 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Sep 20, 2010 at 03:27:26PM +0100, Alan Cox wrote:
>
>> > It's rather concerning that the parser here needs to have all this
>> > knowledge about the specific chips that will be on the boards.  Is
>> > there a plan for how this will be managed once system integrators
>> > begin putting other chips onto Moorestown boards?
>
>> For a device that doesn't need any private structure passing it's just
>> a case of knowing the Linux name that matches the firmware description.
>> For a chip that already has a Linux driver that expects private data
>> (or a new driver that needs to) the info has to come from somewhere and
>> Linux packages it in per device fashion.
>
> Right, we need to do something and given that folks decided that OF
> wasn't for them... :/
>
>> The parser has the knowledge precisely because we don't want to put the
>> knowledge in the driver.
>
> This is precisely the opposite approach to that which has been taken
> with all the OF stuff where individual drivers take care of parsing
> their own data out of the OF tree.  I guess it'd be good if we could
> achieve some level of consistency on this one, though I have this
> horrible feeling that we're going to end up with all sorts of board
> specific workarounds in here, especially around things like audio where
> you've got multiple chips working together.
>
> The OF approach does have the advantage of avoiding collisions between
> multiple devices, and gives us some hope that the driver maintainers may
> have seen the definitions that are being created for the BIOSes.

Shudder.

Okay, before I start a long rant I'll start with this disclaimer; at
least this patch is isolated to the mrst platform so that it doesn't
impact the rest of the kernel.  Feel free to take the stance that this
is platform specific code and therefore will never have to handle the
general-case of multiple machines.  In that case each machine will
need to have a separate copy of this functionality, but at least the
damage is contained. </disclaim>

This will be an utter nightmare to maintain over the long term.  It
combines the worst parts of both static device tables and firmware
data parsers.  From the former it uses large statically allocated
tables that cannot be either extended or freed at runtime which is
unfriendly for multiplatform kernels.

>From the latter it takes the approach of abstracting all the details
of the firmware interface away from the device drivers which forces
the abstraction layer to encode every possible permutation and
combination of devices in a hunk of code that cannot be modularized
and will become larger and larger for each new device that is
supported.  The lesson was learned with OF that the device driver is
the only place where it makes sense to decode device specific data
(addresses and irqs can have common code decoders, but the binding
name and extra data is device driver specific).  Trying to do it
anywhere else is insanity.

That being said, there already is a defined method for passing in
external data about the machine layout.  I'm certainly not keen on
adding another.  It is already an uphill battle to convince device
driver maintainers that adding device tree parsing code (appropriately
contained) to .probe() hooks is the right thing to do.  Asking them to
also support SFI hooks (plus the next firmware-interface-of-the-month)
is likely to end in a revolt.

Both tglx and dwmw2 [cc'd] have stated that they they are in favor of
standardizing on OF device tree for x86 embedded.  dwmw2 suggested
translating data in other formats into the device tree during early
boot so that existing OF routines can be used to parse the data by
device drivers.  That would keep the support code in the device
drivers where it belongs without creating new SFI-specific device
infrastructure.  It also eliminates the statically allocated tables
and board specific hacks.

Since data in the tree is free-form key-value properties, any
device-specific SFI data can be imported into the tree verbatim to
eliminate the risk that critical data will get discarded in the
translation process.  Well understood properties, like address ranges,
IRQs and GPIOs would be straight forward to translate into the device
tree form to make it parsable by common code.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
