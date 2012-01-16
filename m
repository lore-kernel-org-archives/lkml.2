Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab2APQJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:09:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33180 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab2APQI7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:08:59 -0500
MIME-Version: 1.0
In-Reply-To: <20120114012213.GD1810@S2101-09.ap.freescale.net>
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
Date: Mon, 16 Jan 2012 17:08:57 +0100
Message-ID: <CACRpkdYmxQd7aaRhs+xc5nizC7OjwRzsduq-28kVTLjhTGjVZw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux mappings
From: Linus Walleij <linus.walleij@linaro.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>,
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 2:22 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Fri, Jan 13, 2012 at 10:16:36AM -0800, Stephen Warren wrote:
>> Admittedly, the wording of Linusw's actually seems to agree more with how
>> you're interpreting what Dong said, but in that case, I don't think his
>> reply makes sense - the whole purpose of the mux mapping table is to
>> represent the board-specific configuration. If we're going to circumvent
>> it, we should completely remove it from the pinctrl subsystem, rather than
>> having some boards avoid using it by creating virtual pin groups instead.
>>
> IMO, it's a compromise.  It still makes sense to have concept of
> pingroup in pinctrl subsystem, because platforms like Tegra have
> the HW pingroup.

I'm not able to follow this discussion, it's too much stuff here that I don't
quite grasp :-(

The pinctrl idea of a group is defined in Documentation/pinctrl.txt:


---------------------8<---------------------------8<-----------------------------

Pin groups
==========

Many controllers need to deal with groups of pins, so the pin controller
subsystem has a mechanism for enumerating groups of pins and retrieving the
actual enumerated pins that are part of a certain group.

For example, say that we have a group of pins dealing with an SPI interface
on { 0, 8, 16, 24 }, and a group of pins dealing with an I2C interface on pins
on { 24, 25 }.

These two groups are presented to the pin control subsystem by implementing
some generic pinctrl_ops like this:

#include <linux/pinctrl/pinctrl.h>

struct foo_group {
        const char *name;
        const unsigned int *pins;
        const unsigned num_pins;
};

static const unsigned int spi0_pins[] = { 0, 8, 16, 24 };
static const unsigned int i2c0_pins[] = { 24, 25 };

static const struct foo_group foo_groups[] = {
        {
                .name = "spi0_grp",
                .pins = spi0_pins,
                .num_pins = ARRAY_SIZE(spi0_pins),
        },
        {
                .name = "i2c0_grp",
                .pins = i2c0_pins,
                .num_pins = ARRAY_SIZE(i2c0_pins),
        },
};

static int foo_list_groups(struct pinctrl_dev *pctldev, unsigned selector)
{
        if (selector >= ARRAY_SIZE(foo_groups))
                return -EINVAL;
        return 0;
}

static const char *foo_get_group_name(struct pinctrl_dev *pctldev,
                                       unsigned selector)
{
        return foo_groups[selector].name;
}

static int foo_get_group_pins(struct pinctrl_dev *pctldev, unsigned selector,
                               unsigned ** const pins,
                               unsigned * const num_pins)
{
        *pins = (unsigned *) foo_groups[selector].pins;
        *num_pins = foo_groups[selector].num_pins;
        return 0;
}

static struct pinctrl_ops foo_pctrl_ops = {
        .list_groups = foo_list_groups,
        .get_group_name = foo_get_group_name,
        .get_group_pins = foo_get_group_pins,
};


static struct pinctrl_desc foo_desc = {
       ...
       .pctlops = &foo_pctrl_ops,
};

The pin control subsystem will call the .list_groups() function repeatedly
beginning on 0 until it returns non-zero to determine legal selectors, then
it will call the other functions to retrieve the name and pins of the group.
Maintaining the data structure of the groups is up to the driver, this is
just a simple example - in practice you may need more entries in your group
structure, for example specific register ranges associated with each group
and so on.

---------------------8<---------------------------8<-----------------------------


As you can see none of the text above claims that the group is
about hardware-defined groups or anything like that. The groups
are just that - a group of pins, an abstract concept of a group.
It could be drawn i UML even... maybe I'll do that for my
ELC presentation :-)

Then when we come to pinmux, which is slightly different
involving the definitions of a function and mappings between
functions and one or more pin groups as per above, which is
something completely different and seems to be what you're
discussing here?

For hardware that does handle pins in groups there are
special functions that can be used in the drivers like
configuring a whole group (which falls back to iterating
over pins if there is no such callback, showing again that
this is a theoretical concept) so if the hardware handles
pins in groups its a good idea to match group definitions
1-to-1 with these, but for hardware that doesn't there is
some freedom of how to use the groups.

I don't know if this helps though the discussion here seems
a bit contended :-/

Yours,
Linus Walleij
