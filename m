Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab1ELAlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 20:41:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36557 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab1ELAlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 20:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kqynPp8ULV+KxqakEYw5Zyf9Glx2ZxvLUdTWJi7Wi23VqJe0gOOu93mWydb3nrp8DO
         ZAvhTTZDBNU1vR8gpRWvFdC1KtlTFeHxBJ/Cz0H8nv7SfxXx9GirgJTRPnpx7Bet6d+/
         sCui/C7J815afLbUEd9A//VESzwBQcyEBb+WU=
MIME-Version: 1.0
In-Reply-To: <20110511095031.GD31070@lunn.ch>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
	<20110503172712.GE6538@lunn.ch>
	<BANLkTi=ncV3M1q5SXNdUaXmtfkZ8Wn9dmw@mail.gmail.com>
	<20110511095031.GD31070@lunn.ch>
Date: Thu, 12 May 2011 02:41:52 +0200
X-Google-Sender-Auth: 3n9blgzW3fXFd5k3CRGKUvl7KKA
Message-ID: <BANLkTikTVEAWEjWV8da0Vq1vvOUDHa4FVw@mail.gmail.com>
Subject: Re: [PATCH 0/4] Pinmux subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/11 Andrew Lunn <andrew@lunn.ch>:

> plat-orion knows about the registers for controlling muxing.  It knows
> it has a bank of four registers, each register containing one nibble
> per pad. It can provide functions to set these registers. However
> plat-orion has no idea what these pads are used for. It does not know
> what functions each pad has.

No thanks, no code in plat-orion or any plat-xxx. No register definitions
either. This is all part of the problem with arch/arm/*.

Any drivers and register definitions for the pinmux driver goes into
drivers/pinmux/*, the machine/board provide base address for where it
is if need be, any IRQ as struct resource and any platform data on
some kind of custom format.

If you absolutely think it is a bad idea to put data about what function
groups there are and which pins they have directly into drivers/pinmux/*
you need to define a platform data struct someplace like
<linux/pinmux/foo.h> and pass it in through that, in the future we may even
be able to pass it directly from the device tree and skip all of these
info passing mechanisms.

> mach-kirkwood does know what selection of functions each pad can take.
> PAD0 can be a GPIO, or a NAND FLASH data bit2, or an SPI chip select
> line.

I think the driver in drivers/pinmux/* need to know this. Whether the raw
data comes from the machine or resides directly in drivers/pinmux/* is
an implementation thing.

> Maybe more interestingly, PAD4 can be UART0 RXD, but also PAD11
> can also be UART0 RXD. It can also know that the TWI interface 0 needs
> PADs 8 and 9 and that there are no other alternatives. So it could
> export this information. However TWI interface 1 has two pads for SDA
> and two pads for SCL. It could in theory export all four combinations
> which make valid TWI configurations.

OK.

> bubba3 board code knows that the board uses UART0 RXD from PAD 10. It
> also knows that its a simple 3 wire UART, so the flow control signals
> on various pads are not needed etc.

I don't think the board code should "know" about anything related to
a specific indvidual pad. It will know that to use UART0 on this board,
it should select some function name like "uart0-1". The pinmux driver
knows which pads this name is connected to. Noone else. Maybe
it got some static table out of the mach dir when instantiating itself,
that's not "knowing" IMO, I don't know what term to use sorry.

> Now lets map these different logical hierarchies onto a pinmux driver
> that would be placed into drivers/pinmux/kirkwood.c. I'm making a big
> assumption here.

This sounds like a strange name, more like it would be
drivers/pinmux/pinmux-orion.c or so, then configured with different
functions and pad sets for different machines by a set of
array tables.

> Each mach will provide a pinmux driver, not each
> board.

No, the machines provide no drivers. We need to get driver out
of arch/arm/*. The drivers shall be in drivers/pinmux/*. The mach
or if you like package may provide data to the driver if you
need to.

> We are trying to reduce code bloat, so we want to minimize
> repeated code. This is why i expect a pinmux driver per mach, not per
> board, since i expect there is a lot of duplication between boards of
> the same mach.

I expect one pinmux driver for all machines covered by a plat-*,
unless they have totally different registers, different striding, different
features altogether etc, in case they are really totally different
hardware, then we need drivers/pinmux/pinmux-foo.c,
pinmux-bar.c etc to cover them unless we can consolidate the
code.

> We also want to keep maintenance simple, so what is
> probably never going to be used outside of bubba3 should probably be
> kept in the bubba3 board file.

Board data is to be kept there, and that means which functions shall
be mapped to what devices and nothing else IMO.

The package of a certain chip is something else than the board IMO,
and that is what the driver in drivers/pinmux/* is all about. The only
thing the board is about is how to map the muxable functions for this
specific board.

> foo_enable() and foo_disable() methods come from plat-orion. So i
> #include <plat/orion> and use the functions. That works fine for all
> the other systems based on orion.

No code in plat-orion. drivers/pinmux/pinmux-orion.c.

> Now to pins
>
> The example driver in your Documentation has
>
> static unsigned int i2c0_pins[] = { 24, 25 };
>
> We can do the same for the TWI interface 0
>
> static unsigned int twi_0_pins[] = { 8, 9};
>
> but what about TWI interface 1? There are only four combinations, so i
> could do:
>
> static unsigned int twi_1_a_pins[] = { 12, 17};
> static unsigned int twi_1_b_pins[] = { 12, 37};
> static unsigned int twi_1_c_pins[] = { 36, 17};
> static unsigned int twi_1_d_pins[] = { 36, 37};
>
> static struct foo_pmx_func myfuncs[] = {
>       {
>               .name = "twi-1-a",
>               .pins = twi-1-a,
>               .num_pins = ARRAY_SIZE(twi_1_a_pins),
>       },
>       {
>               .name = "twi-1-b",
>               .pins = twi-1-b,
>               .num_pins = ARRAY_SIZE(twi_1_b_pins),
>       },
>       {
>               .name = "twi-1-c",
>               .pins = twi-1-c,
>               .num_pins = ARRAY_SIZE(twi_1_c_pins),
>       },
>       {
>               .name = "twi-1-d",
>               .pins = twi-1-d,
>               .num_pins = ARRAY_SIZE(twi_1_d_pins),
>       },
> };
>
> and let the board tell the Marvell TWI driver to use twi-1-c with:
>
>       PINMUX_MAP("twi-1-c", "mv-spi.1")

Yes exactly.

> Four combinations is not too bad. But SPI is worse, there are
> something like 32 combinations, maybe more. I could look at all the
> different kirkwood boards and find the subset used and add just those?
> And when a new board is added, it might have to add yet another
> combination. The same problem exists for the UART. Not just which pins
> are used, but also, is HW flow control used, are modem lines used,
> etc.

How would you do it today? I am not trying to solve the problem that
the world needs to be enumerated somehow, I am trying to provide
a framework for doing so.

And yes, since this isn't about mathematics we only need to enumerate
that which is practically useful.

If you want a futureproof solution you will have to wait until we have
device tree, then you can encode all of these combinations in the
device tree passed to the kernel.

> To me, it makes more sense that drivers/pinmux/kirkwood.c provides the
> unique pin functions, where there are no alternatives, eg the twi
> 0. It could also provide the pin functions used my Marvell in the
> kirkwood reference design. It is likely that many real boards will be
> based on that. However, if my bubba3 SPI pins don't fit with the
> Marvell RDK, i probably want to put them in my board file.

Sorry I'm not following, what is an RDK?

Anyway you need a way to specify all the useful functions for some
chip in a package on that board, then the board need to select a
subset of these functions.

> Looking at the API, i don't see how my board could provide the list of
> SPI pins. So it looks like each kirkwood board will have to extend
> drivers/pinmux/kirkwood.c with its own specific pin definitions. This
> i don't like.

But I don't think this is about board data at all. I think the pads and
their function combinations are about package data, not board.

There are alternatives:

* If the number of pins and possible muxings are reasonably small
  you can encode it directly in the driver as done in the U300 example.

* If you feel this clutters the driver with tables and header files, you can
  pass it in from the platform data (assuming a platform device), i.e.
  a custom struct containing the same stuff that is encoded in the
  table in the example driver. (Or the U300.) This is no different from
  how you pass data to any platform driver today.

The fact that the data about a certain package (for example the
DB3350 in the U300 case) would come from some
mach-u300/package-db3350.c file or header does not make it a board
file, it's a package file.

Soon we need to get rid of that also to get data encoding out of the
kernel, then we will probably need to encode it in a device tree
that knows about both the board and the chip package in a hierarchical
manner.

I'll go over the documentation again and see if I can clarify further...

Yours,
Linus Walleij
