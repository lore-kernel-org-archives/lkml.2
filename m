Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1EKRXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:23:07 -0400
Received: from londo.lunn.ch ([80.238.139.98]:33261 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab1EKRXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:23:03 -0400
Date: Wed, 11 May 2011 11:50:31 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] Pinmux subsystem
Message-ID: <20110511095031.GD31070@lunn.ch>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
 <20110503172712.GE6538@lunn.ch>
 <BANLkTi=ncV3M1q5SXNdUaXmtfkZ8Wn9dmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=ncV3M1q5SXNdUaXmtfkZ8Wn9dmw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 1) Three functions: uart-3wire, uart-hw-flow, uart-hw-flow-modem. ?The
> > ? first just has 2 pins, the second 4 and the last 8. The board code
> > ? selects one of these for the serial driver to use.
> 
> Sounds like a solid case for pinmuxing. Here the board code defines
> three mux settings by name that your pinmux driver shall be able to handle,
> and associate each of them with the same device.
> 
> > 2) Three functions: uart-core, uart-hw-flow, uart-mode. ?The first has
> > ? 2 pins, the second has 2 pins and the last 4 pins. The board code tells
> > ? the driver to use uart-core, plus say uart-hw-flow.
> No not board. The driver is a driver for the package or pad ring,
> nothing else. And the package certainly knows, by virtue of knowing
> what differernt functions it can mux in/out by poking bits in the
> hardware, about the actual groups that exists on the package.
> 
> The board in turn defines which of these possible functions that
> it wants to mux in to certain devices. Note that it can assign multiple
> functions to a single device, as mentioned in the reply to Russell.
> 
> > ?Maybe it makes
> > more sense to have a collection of standard pin functions in
> > drivers/pinmux/pinmux-foo.c, which cover 75% of the likely
> > combinations.
> 
> I don't get it. There are as many combinations as there are
> chips. A function on pin 12, 13 and 35 on my package is very
> unlikely to be viable on another package.
> 
> The pinmux API is *not* about keeping track of the fact that
> SPI uses so or so many pins, it's just about groups of pins
> in an array, nothing else.
> 
> > And recommend a board file to have its own additional
> > list of strange pin functions which it registers with the pinmux core?
> 
> The board file only references the functions that the the package
> can mux. The board file should *never* define any functions
> or pin groups whatsoever, the pinmux driver knows about those.

Hi Linus

Thanks for your reply. 

I still however don't get how the different part of this are spread
around the different levels of the logical hierarchy.

Lets take a system i'm familiar with. I'm working of a kirkwood board,
called bubba3. The logical hierarchy is:

linux | arm | plat-orion | mach-kirkwood | bubba3.

The pinmux core belongs in the linux level. It can be used by any
architecture. It is generic.

For the arm level, we have nothing.

plat-orion knows about the registers for controlling muxing.  It knows
it has a bank of four registers, each register containing one nibble
per pad. It can provide functions to set these registers. However
plat-orion has no idea what these pads are used for. It does not know
what functions each pad has.

mach-kirkwood does know what selection of functions each pad can take.
PAD0 can be a GPIO, or a NAND FLASH data bit2, or an SPI chip select
line. Maybe more interestingly, PAD4 can be UART0 RXD, but also PAD11
can also be UART0 RXD. It can also know that the TWI interface 0 needs
PADs 8 and 9 and that there are no other alternatives. So it could
export this information. However TWI interface 1 has two pads for SDA
and two pads for SCL. It could in theory export all four combinations
which make valid TWI configurations.

bubba3 board code knows that the board uses UART0 RXD from PAD 10. It
also knows that its a simple 3 wire UART, so the flow control signals
on various pads are not needed etc.

Now lets map these different logical hierarchies onto a pinmux driver
that would be placed into drivers/pinmux/kirkwood.c. I'm making a big
assumption here. Each mach will provide a pinmux driver, not each
board. We are trying to reduce code bloat, so we want to minimize
repeated code. This is why i expect a pinmux driver per mach, not per
board, since i expect there is a lot of duplication between boards of
the same mach. We also want to keep maintenance simple, so what is
probably never going to be used outside of bubba3 should probably be
kept in the bubba3 board file.

foo_enable() and foo_disable() methods come from plat-orion. So i
#include <plat/orion> and use the functions. That works fine for all
the other systems based on orion.

Now to pins

The example driver in your Documentation has

static unsigned int i2c0_pins[] = { 24, 25 };

We can do the same for the TWI interface 0

static unsigned int twi_0_pins[] = { 8, 9};

but what about TWI interface 1? There are only four combinations, so i
could do:

static unsigned int twi_1_a_pins[] = { 12, 17};
static unsigned int twi_1_b_pins[] = { 12, 37};
static unsigned int twi_1_c_pins[] = { 36, 17};
static unsigned int twi_1_d_pins[] = { 36, 37;

static struct foo_pmx_func myfuncs[] = {
       {
               .name = "twi-1-a",
               .pins = twi-1-a,
               .num_pins = ARRAY_SIZE(twi_1_a_pins),
       },
       {
               .name = "twi-1-b",
               .pins = twi-1-b,
               .num_pins = ARRAY_SIZE(twi_1_b_pins),
       },
       {
               .name = "twi-1-c",
               .pins = twi-1-c,
               .num_pins = ARRAY_SIZE(twi_1_c_pins),
       },
       {
               .name = "twi-1-d",
               .pins = twi-1-d,
               .num_pins = ARRAY_SIZE(twi_1_d_pins),
       },
};

and let the board tell the Marvell TWI driver to use twi-1-c with:

       PINMUX_MAP("twi-1-c", "mv-spi.1")

Four combinations is not too bad. But SPI is worse, there are
something like 32 combinations, maybe more. I could look at all the
different kirkwood boards and find the subset used and add just those?
And when a new board is added, it might have to add yet another
combination. The same problem exists for the UART. Not just which pins
are used, but also, is HW flow control used, are modem lines used,
etc.

To me, it makes more sense that drivers/pinmux/kirkwood.c provides the
unique pin functions, where there are no alternatives, eg the twi
0. It could also provide the pin functions used my Marvell in the
kirkwood reference design. It is likely that many real boards will be
based on that. However, if my bubba3 SPI pins don't fit with the
Marvell RDK, i probably want to put them in my board file.

Looking at the API, i don't see how my board could provide the list of
SPI pins. So it looks like each kirkwood board will have to extend
drivers/pinmux/kirkwood.c with its own specific pin definitions. This
i don't like.

     Andrew
