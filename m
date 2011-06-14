Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab1FNWM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 18:12:56 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4046 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1FNWMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 18:12:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 14 Jun 2011 15:12:47 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Date: Tue, 14 Jun 2011 15:11:58 -0700
Subject: RE: [PATCH 1/2] drivers: create a pinmux subsystem v3
Thread-Topic: [PATCH 1/2] drivers: create a pinmux subsystem v3
Thread-Index: AcwqnuvSW9qfDGCASW+T7fPOGF1ZPgAOZBGQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04992C049D@HQMAIL01.nvidia.com>
References: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04992C02AC@HQMAIL01.nvidia.com>
 <BANLkTinNmPVEM4Eu4efxkuwrCU_FVWFaAg@mail.gmail.com>
In-Reply-To: <BANLkTinNmPVEM4Eu4efxkuwrCU_FVWFaAg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Tuesday, June 14, 2011 8:26 AM:
> On Tue, Jun 14, 2011 at 1:28 AM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > I'm a little confused by this version.
> 
> Sorry, I'll try to clarify.
> 
> > In particular:
> >
> > * I don't see some changes that I thought we'd agreed upon during earlier
> > review rounds, such as:
> >
> > ** Removing pinmux_ops members list_functions, get_function_name,
> > get_function_pins; it seems odd not to push this into the pinmux core
> > as data, but instead have the core pull it out of the driver in a
> > "polling" function.
> 
> I don't find any particular discussion on that, did I miss something?
> It might be that I simply do not agree...

That was:

https://lkml.org/lkml/2011/5/19/365
https://lkml.org/lkml/2011/5/19/379

> Anyway, this is modeled exactly on how the regulator subsystem
> interact with its drivers to enumerate voltages. It seems intuitive
> to me, it's an established kernel design pattern that drivers know
> the hardware particulars, and so I don't get the problem here.
> Would you argue that the regulator subsystem has bad design
> too or is this case different?

Well, I guess it does do something like this on a much smaller scale.

I'm surprised this style exists; I'd expect the following:

driver:
pinmux_register_driver(
    ops
    list of pins
    list of functions);

to be much simpler than:

driver:
pinmux_register_driver(ops)
core:
for loop:
    ops->list_functions
    ops->get_function_name
    ops->get_function_pins

Still, this is something that doesn't affect the publically visible
client interface, and is easy to change in the future without a lot
of work, so probably not a huge deal.

> Can't you just send some patch or example .h file for the API
> you would like to see so I understand how you think about
> this?

Are your patches in git somewhere? It's much easier for me to pull
at present than grab patches out of email; something I certainly need
to fix...

> I might be thinking inside the box of my current design here so
> help me get out of it, I just have a hard time seeing how to
> do it.
> 
> > ** Similarly, I'd asked for at least some documentation about how to
> > handle the "multi-width bus" problem, but I didn't see that.
> 
> SORRY! Missed it.
> 
> So sure that can be added, so something like this?
> 
>         A   B   C   D   E   F   G   H
>       +---+
>    8  | o | o   o   o   o   o   o   o
>       |   |
>    7  | o | o   o   o   o   o   o   o
>       |   |
>    6  | o | o   o   o   o   o   o   o
>       +---+---+
>    5  | o | o | o   o   o   o   o   o
>       +---+---+               +---+
>    4    o   o   o   o   o   o | o | o
>                               |   |
>    3    o   o   o   o   o   o | o | o
>                               |   |
>    2    o   o   o   o   o   o | o | o
>       +-------+-------+-------+---+---+
>    1  | o   o | o   o | o   o | o | o |
>       +-------+-------+-------+---+---+
> 
> (...)
> 
> On the botton row at { A1, B1, C1, D1, E1, F1, G1, H1 } we have something
> special - it's an external MMC bus that can be 2, 4 or 8 bits wide, and it will
> consume 2, 4 or 8 pins respectively, so either { A1, B1 } are taken or
> { A1, B1, C1, D1 } or all of them. If we use all 8 bits, we cannot use the SPI
> port on pins { G4, G3, G2, G1 } of course.
> 
> (...)
> 
> A simple driver for the above example will work by setting bits 0, 1, 2, 3,
> 4 or 5 into some register named MUX, so it enumerates its available
> settings
> and their pin assignments, and expose them like this:
> 
> #include <linux/pinctrl/pinmux.h>
> 
> struct foo_pmx_func {
> 	char *name;
> 	const unsigned int *pins;
> 	const unsigned num_pins;
> };
> 
> static unsigned int spi0_0_pins[] = { 0, 8, 16, 24 };
> static unsigned int i2c0_pins[] = { 24, 25 };
> static unsigned int spi0_1_pins[] = { 38, 46, 54, 62 };
> static unsigned int mmc0_1_pins[] = { 56, 57 };
> static unsigned int mmc0_2_pins[] = { 56, 57, 58, 59 };
> static unsigned int mmc0_3_pins[] = { 56, 57, 58, 59, 60, 61, 62, 63 };
> 
> static struct foo_pmx_func myfuncs[] = {
> 	{
> 		.name = "spi0-0",
> 		.pins = spi0_0_pins,
> 		.num_pins = ARRAY_SIZE(spi0_1_pins),
> 	},
> 	{
> 		.name = "i2c0",
> 		.pins = i2c0_pins,
> 		.num_pins = ARRAY_SIZE(i2c0_pins),
> 	},
> 	{
> 		.name = "spi0-1",
> 		.pins = spi0_1_pins,
> 		.num_pins = ARRAY_SIZE(spi0_1_pins),
> 	},
> 	{
> 		.name = "mmc0-2bit",
> 		.pins = mmc0_1_pins,
> 		.num_pins = ARRAY_SIZE(mmc0_1_pins),
> 	},
> 	{
> 		.name = "mmc0-4bit",
> 		.pins = mmc0_2_pins,
> 		.num_pins = ARRAY_SIZE(mmc0_2_pins),
> 	},
> 	{
> 		.name = "mmc0-8bit",
> 		.pins = mmc0_3_pins,
> 		.num_pins = ARRAY_SIZE(mmc0_3_pins),
> 	},
> };
> 
> Looks OK?

I think that's exactly the setup I was looking to avoid. See the portion
of the thread starting from:

https://lkml.org/lkml/2011/5/13/424

In particular, in:

https://lkml.org/lkml/2011/5/18/33

I explained how I understood you intended to solve this (summarized just
below) and you appeared to agree with that.

The functions a pinmux driver exposes are purely driven by the smallest
set of pins the HW can control at once (pin-by-pin for many HW I imagine,
but groups of 1-10 pins on Tegra).

To provide the "bus" abstraction, struct pinmux_map will be expanded to
include N pinmux driver functions to activate per map entry.

(I agreed that the actual implementation could be deferred to a later
set of patches, but wanted the documentation to describe the final model
so that we didn't end up people implementing the example you wrote above).

So, in the example above:

static unsigned int mmc0_1_pins[] = { 56, 57 };
static unsigned int mmc0_2_pins[] = { 58, 59 };
static unsigned int mmc0_3_pins[] = { 60, 61, 62, 63 };

	{
		.name = "mmc0-1:0",
		.pins = mmc0_1_pins,
		.num_pins = ARRAY_SIZE(mmc0_1_pins),
	},
	{
		.name = "mmc0-3:2",
		.pins = mmc0_2_pins,
		.num_pins = ARRAY_SIZE(mmc0_2_pins),
	},
	{
		.name = "mmc0-7:4",
		.pins = mmc0_3_pins,
		.num_pins = ARRAY_SIZE(mmc0_3_pins),
	},

So a board that happens to use a 2-bit bus would define:

static struct pinmux_map pmx_mapping[] = {
	{
		.functions = {"mmc0-1:0"},
		.dev_name = "tegra-sdhci.0",
	},
};

But a board that happens to use an 8-bit bus would define:

static struct pinmux_map pmx_mapping[] = {
	{
		.functions = {"mmc0-1:0", "mmc0-3:2", "mmc0-7:4"},
		.dev_name = "tegra-sdhci.0",
	},
};

... although struct pinmux_map would probably need to grow a separate
name field to match against pinmux_get's 2nd parameter, rather than
assuming the driver's function names and the mapping's function names
were the same.

Such a new name field would also introduce a second namespace that'd
satisfy my next concern.

> > ** How can the board/machine name pins? That should be a function of the
> > chip (i.e. pinmux driver), since that's where the pins are located. A
> > chip's pins don't have different names on different boards; the names of
> > the signals on the PCB connected to those pins are defined by the board,
> > but not the names of the actual pins themselves.
> 
> Actually I don't really like the use of the concept of board and machine
> for chip packages either. But if I say that without devicetrees it
> could be something like arch/arm/plat-nomadik/package-db8500.c
> defining the pins. Then it is still coming from the outside, for
> a particular platform, for a particular chip package.
> 
> Then the init function in that file gets called on relevant systems.
> 
> As you can see in the example implementation for U300 I actually
> do this in the driver itself by including the machine.h file to that one.
> So this driver first registers pins, then functions.
> 
> I think there is broad consensus that this should come in from
> the device tree in the future. And if it comes from the device tree, it's
> still the say arch/arm/plat-nomadik/package-db8500.c file that looks
> up the pins from the device tree and registers them, just it gets the
> data from the outside.

I think discussion of DeviceTree here is a bit of a distraction; if the
pinmux core APIs imply the correct data model, it doesn't seem especially
relevant.

For the pinmux drivers themselves, I expect the SoC's pinmux driver to
define the set of pins available, and the set of functions available.

A couple examples:

There will be a single static set of pins/functions for any Tegra 2
device. Tegra 3 will have a different set of pins/functions since the
HW changed quite a bit in this area. As such, DeviceTree doesn't really
help much, since there will always be a custom driver per SoC, and the
data a given driver uses will not vary between boards, so DeviceTree
helps little.

On the other hand, if you've got a very generic pinmux controller, and
it gets included in N (versions of) SoCs with the same register layout,
 but the actual pin names related to each register bit
are different, then I can see it making sense for the pinmux driver
itself to parameterize itself with data from DeviceTree. Either way
though, this is purely an implementation detail within the pinmux driver,
and not something the core would even be aware of.

However, I do think the board-specific list of struct pinmux_map will
come from DeviceTree. This will vary from board to board with potentially
little commonality. DeviceTree seems a great solution to keep all that
varying data out of the kernel. The core pinmux code could well include
the common code to parse the DeviceTree for this data.

> Possibly the core could be made to do this. I know too little about
> device tree I think :-/
> 
> > ** struct pinmux_map requires that each function name be globally unique,
> > since one can only specify "function" not "function on a specific chip".
> > This can't be a requirement; what if there are two instances of the same
> > chip on the board (think some expansion chip attached to a memory-mapped
> > bus rather than the primary SoC itself).
> 
> Namespace clashes are a problem but the way I see it basically a
> problem with how you design the namespace. It's just a string and
> the document is just an example.

The issue here is that the pinmux driver defines a single namespace for
functions, and struct pinmux_map's definition passes that single namespace
through, since the value of .function comes from that same namespace, and
is also the search key for the list of driver-visible functions.

As I alluded to above, if struct pinmux_map had a separate field for the
search key (for pinmux_get's use) v.s. the set of driver functions that
key maps to, then there can be separate namespaces, and a place to resolve
conflicts:

struct pinmux_map_entry {
	struct pinmux_dev *pmxdev
	const char *function; // pmxdev's specific function name-space
};

struct pinmux_map {
	const char *name; // global driver-visible function name-space
	struct device *dev;
	const char *dev_name;
	int n_ functions;
	const struct pinmux_map_entry * functions;
};

Thinking about this at a high level, this seems equivalent to the GPIO
driver: There are two name-spaces there:

1) One used by clients: A global name-space, equivalent to
pinmux_map.name.

2) One used by GPIO drivers: A per-driver name-space, equivalent to
pinmux_map_entry.function.

... and the GPIO core maps from (1) to (2) above internally.

In the pinmux case, since everything is named by a string rather than a
linear number range, the mapping process needs the pinmux_map_entry.function
field, rather than just substracting a GPIO driver's base GPIO number.

-- 
nvpublic

