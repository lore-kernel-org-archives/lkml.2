Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab0JROeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:34:19 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:5842 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab0JROeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:34:17 -0400
Date: Mon, 18 Oct 2010 16:33:57 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        David Brownell <david-b@pacbell.net>
Cc: Mike Frysinger <vapier@gentoo.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [PATCH] i2c: add irq_flags to board info
Message-ID: <20101018163357.659efe25@endymion.delvare>
In-Reply-To: <544AC56F16B56944AEC3BD4E3D5917713094520FA6@LIMKCMBX1.ad.analog.com>
References: <1287359019-1476-1-git-send-email-vapier@gentoo.org>
	<20101018103610.77b7e605@endymion.delvare>
	<544AC56F16B56944AEC3BD4E3D5917713094520EDB@LIMKCMBX1.ad.analog.com>
	<20101018140136.2b44d29e@endymion.delvare>
	<544AC56F16B56944AEC3BD4E3D5917713094520FA6@LIMKCMBX1.ad.analog.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael, David,

David, question for you below.

On Mon, 18 Oct 2010 13:31:21 +0100, Hennerich, Michael wrote:
> Jean Delvare wrote on 2010-10-18:
> > Hi Michael,
> >
> > On Mon, 18 Oct 2010 10:55:57 +0100, Hennerich, Michael wrote:
> >> Jean Delvare wrote on 2010-10-18:
> >>> Hi Mike,
> >>>
> >>> On Sun, 17 Oct 2010 19:43:39 -0400, Mike Frysinger wrote:
> >>>> From: Michael Hennerich <michael.hennerich@analog.com>
> >>>>
> >>>> These flags can be optionally defined - slave drivers may use them as
> >>>> flags argument for request_irq().  In case they are left
> >>>> uninitialized they will default to zero, and therefore shouldn't
> >>>> cause problems.
> >>>>
> >>>> This allows us to avoid having to add dedicated platform init
> >>>> code just to call set_irq_type()
> >>>
> >>> Do you have examples of this? Can we see a preview of the amount
> >>> of cleanups this patch would allow?
> >>
> >> Examples can be found in various board setup files:
> >>
> >> One example arch/sh/boards/mach-ecovec24/setup.c:
> >>
> >> static struct i2c_board_info ts_i2c_clients = {
> >>         I2C_BOARD_INFO("tsc2007", 0x48),
> >>         .type           = "tsc2007",
> >>         .platform_data  = &tsc2007_info,
> >>         .irq            = IRQ0,
> >> };
> >>
> >> [--snip--]
> >>
> >>                 /* enable TouchScreen */
> >>                 i2c_register_board_info(0, &ts_i2c_clients, 1);
> >>                 set_irq_type(IRQ0, IRQ_TYPE_LEVEL_LOW);
> >
> > This example doesn't quite match the patch description. There's no
> > "dedicated platform init code just to call set_irq_type()", as you
> > already have platform code to call i2c_register_board_info(). It's
> > really only calling set_irq_type() from platform code vs. from driver
> > code.
> 
> In the past I also saw initcalls just doing set_irq_type(), to make drivers happy.
> That doesn't pass the right irq_flags along with request_irq().

But it's OK to call request_irq() without these flags, as long as
set_irq_type() is called additionally, isn't it?

Why do we have set_irq_type() if we're not supposed to call it? I am
not claiming to be an expert in the area, but it seems totally
reasonable to me that the same piece of code instantiating an I2C
device is also responsible for setting its IRQ type.

> 
> >>>> -- which doesn't work very well when coupled with module drivers.
> >>>
> >>> I don't quite get what you mean here.
> >>
> >> Since the driver doesn't setup the irq_type itself you need to do it
> >> manually in advance using set_irq_type().
> >> This happens most likely from your paltform setup/configuration file.
> >>
> >> Assuming the driver is built as a module, this code gets executed
> >> unconditionally, no matter if the driver gets finally loaded or not.
> >>
> >> Assuming you have several drivers build as modules, using the same irq
> >> but with different irq types, you run into problems here.
> >
> > I do not get why.
> >
> > You're not going to register several I2C devices using the same IRQ
> > but requiring different IRQ flags anyway, as it wouldn't work. So
> > you'll have to only register the I2C devices which are actually
> > present on the system. Setting the IRQ type at the same time or
> > deferring this action to the driver(s) doesn't make any difference then, does it?
> 
> If I remember correctly i2c as well as spi doesn't check for irq conflicts in irqs passed with
> struct i2c/spi_board_info. So you can have multiple drivers build as modules all using the same
> irq number but with different flags.

Indeed i2c doesn't check the IRQs at all, it passes them transparently
from platform data to device driver.

But you're mixing devices and drivers. Devices are bound to an IRQ, not
drivers, and so do IRQ flags.

> 
> The user decides which add-on module is plugged onto the processor board, by loading the appropriate
> driver module.

This can't work, sorry. Unless you are using I2C device auto-detection,
which I seem to understand is NOT used in the embedded world at all,
loading a driver module doesn't do anything if a device it supports
hasn't been instantiated first. So the user can't just load a driver
and see the required I2C devices magically appear for the driver to
bind to them.

So the first problem you have to solve is how you instantiate the right
I2C devices depending on which extension is plugged in. As long as this
problem isn't solved, there's no point in discussing where the IRQ
flags should be set.

> >> There are some development boards featuring extension options, which
> >> all plug on the same socket but required different drivers/irq types.
> >
> > How do you figure out which extension option is plugged? You can't
> > instantiate an I2C device which isn't present, so you must have a way
> > to know what extension option is used, to instantiate the right I2C
> > device at the right address.
> 
> The user decides.
> The platform code provides resources for all potential boards being used.
> And here is exactly the conflict.

"Provides", how? It can't possibly instantiate them all. Please
describe the mechanism.

> >> The ideal way is therefore to pass the irq_flags together with the
> > SPI/I2C board info.
> >
> > All I see so far is two data structures made slightly larger, for no
> > actual benefit.
> 
> I don't see a reason why i2c/spi bus drivers should be different from other bus drivers.
> The platform_device bus driver allows you to pass IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL with flags
> in struct resource.

This is an interesting point. David, you're the one who added irq to
struct i2c_client, you didn't add irq_flags then, did you have a good
reason not to?

> There are drivers that work around this deficiency, by adding irq_flags to the bus clients dev.platform_data
> See include/linux/spi/ads7846.h for one example.

Interesting example, better matching the initial comment that came
along with the patch. But it also seems to be an isolated case, as I
can't find any other irq_flags in include/linux/{i2c,spi}/.

-- 
Jean Delvare
