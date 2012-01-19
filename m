Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab2ASQzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:55:52 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:32901 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab2ASQzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:55:50 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17801D230A@HQMAIL01.nvidia.com>
References: <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
	<7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
	<74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
	<20120107135445.GI4790@S2101-09.ap.freescale.net>
	<74CDBE0F657A3D45AFBB94109FB122FF177EE3A6E5@HQMAIL01.nvidia.com>
	<20120112033941.GH20968@S2101-09.ap.freescale.net>
	<74CDBE0F657A3D45AFBB94109FB122FF17801D1DCC@HQMAIL01.nvidia.com>
	<20120113034558.GA12184@S2101-09.ap.freescale.net>
	<74CDBE0F657A3D45AFBB94109FB122FF17801D1F9D@HQMAIL01.nvidia.com>
	<20120114012213.GD1810@S2101-09.ap.freescale.net>
	<CACRpkdYmxQd7aaRhs+xc5nizC7OjwRzsduq-28kVTLjhTGjVZw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17801D230A@HQMAIL01.nvidia.com>
Date: Thu, 19 Jan 2012 17:55:49 +0100
Message-ID: <CACRpkdZj9KGCoq2G2nHymUe2WxJLUVfGT4e=uCDq6kuZFNYU7Q@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux mappings
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Dong Aisheng <dongas86@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 8:50 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Monday, January 16, 2012 9:09 AM:

>> As you can see none of the text above claims that the group is
>> about hardware-defined groups or anything like that.
>
> Well, I guess that's true, but didn't we only add the concept of groups
> to the pinctrl subsystem in order to support Tegra's HW-group-based
> muxing?

The groups appeared in v6 of the very first patchset, this is
from git log drivers/pinctrl

    ChangeLog v5->v6:

    - Create an abstract pin group concept that can sort pins into
      named and enumerated groups no matter what the use of these
      groups may be, one possible usecase is a group of pins being
      muxed in or so. The intention is however to also use these
      groups for other pin control activities.
    - Make it compulsory for pinmux functions to associate with
      at least one group, so the abstract pin group concept is used
      to define the groups of pins affected by a pinmux function.
      The pinmux driver interface has been altered so as to enforce
      a function to list applicable groups per function.
    - Provide an optional .group entry in the pinmux machine map
      so the map can select beteween different available groups
      to be used with a certain function.
    - Consequent changes all over the place so that e.g. debugfs
      present reasonable information about the world.
    - Drop the per-pin mux (*config) function in the pinmux_ops
      struct - I was afraid that this would start to be used for
      things totally unrelated to muxing, we can introduce that to
      the generic struct pinctrl_ops if needed. I want to keep
      muxing orthogonal to other pin control subjects and not mix
      these things up.

The first driver using the concept was the U300 driver.

> And irrespective of that, why would you want to define "virtual"
> groups in the pinctrl driver when the whole point of the pin mux mapping
> table allowing multiple entries for a device was to handle the mux-by-
> pin case?

In the U300 the driver define groups of pins like these:

static const unsigned uart0_pins[] = { 134, 135, 136, 137 };
static const unsigned mmc0_pins[] = { 166, 167, 168, 169, 170, 171, 176, 177 };
static const unsigned spi0_pins[] = { 420, 421, 422, 423, 424, 425 };

These groups are associated with muxes.

Then each such group is activated by reading masking and writing
several registers, but basically they are muxed in and out
on a per-group basis.

So yes, in this case the U300 use is consistent with a 1-1
mapping between physical handling of a group and a certain
per-group register setting.

But I also added these groups:

static const unsigned emif0_pins[] = { 355, 356, 357, 362, 363, 364, 365, 366,
        367, 368, 369, 370, 371, 376, 377, 378, 379, 380, 381, 382, 383, 384,
        385, 386, 387, 393, 394, 395, 396, 397, 398, 406, 407, 410, 411, 412,
        417, 418 };
static const unsigned emif1_pins[] = { 216, 217, 219, 220, 221, 222, 227, 228,
        229, 230, 233, 234, 235, 236, 241, 242, 243, 244, 247, 248, 249, 250,
        253, 254, 255, 260, 261, 262, 263, 266, 267, 268, 269, 272, 273, 274,
        275, 280, 281, 282, 283, 286, 287, 288, 289, 292, 293, 294, 297, 298,
        304, 305, 306, 307, 308, 313, 314, 315 };

It's not like I could remux the pins used by the external memory
interface, so these groups are not used by the mux driver at
all.

They are used to give a nice overview in debugfs, and for
blocking up these pins from other users so as not to make
mistakes. So no relation to any registers or so.

As how to use them for controllers that can support
per-pin muxing I don't know, in the gpio-nomadik.c
case (and I should hack on this driver!) pins are controlled
on a per-pin basis, but the only settings that make any
sense is to use them in certain groupings.

Example: pins {0, 1} can be used for I2C, or GPIO.
It doesn't make sense to mux in SCL on pin 0 and
have GPIO on pin 1, do defining a group of {0, 1}
and associate that with a mux setting for I2C is the
sensible thing to do IMO, even though this is in
practice achived by writing mux registers for two
different pins.

I don't know if that is what you're discussing here,
I might have missed the point :-/

>> The groups
>> are just that - a group of pins, an abstract concept of a group.
>> It could be drawn i UML even... maybe I'll do that for my
>> ELC presentation :-)
>
> I should ask: Who here is coming to Linaro Connect and/or ELC? I'm
> Currently signed up for Linaro Connect, but not ELC. I could probably
> add ELC if there was good reason.

I'm coming to both, so see you there :-)

Thanks,
Linus Walleij
