Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab1FNOZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 10:25:34 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40426 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1FNOZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 10:25:32 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04992C02AC@HQMAIL01.nvidia.com>
References: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04992C02AC@HQMAIL01.nvidia.com>
Date: Tue, 14 Jun 2011 16:25:31 +0200
Message-ID: <BANLkTinNmPVEM4Eu4efxkuwrCU_FVWFaAg@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pinmux subsystem v3
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 1:28 AM, Stephen Warren <swarren@nvidia.com> wrote:

> I'm a little confused by this version.

Sorry, I'll try to clarify.

> In particular:
>
> * I don't see some changes that I thought we'd agreed upon during earlier
> review rounds, such as:
>
> ** Removing pinmux_ops members list_functions, get_function_name,
> get_function_pins; it seems odd not to push this into the pinmux core
> as data, but instead have the core pull it out of the driver in a
> "polling" function.

I don't find any particular discussion on that, did I miss something?
It might be that I simply do not agree...

Anyway, this is modeled exactly on how the regulator subsystem
interact with its drivers to enumerate voltages. It seems intuitive
to me, it's an established kernel design pattern that drivers know
the hardware particulars, and so I don't get the problem here.
Would you argue that the regulator subsystem has bad design
too or is this case different?

Can't you just send some patch or example .h file for the API
you would like to see so I understand how you think about
this?

I might be thinking inside the box of my current design here so
help me get out of it, I just have a hard time seeing how to
do it.

> ** Similarly, I'd asked for at least some documentation about how to
> handle the "multi-width bus" problem, but I didn't see that.

SORRY! Missed it.

So sure that can be added, so something like this?

        A   B   C   D   E   F   G   H
      +---+
   8  | o | o   o   o   o   o   o   o
      |   |
   7  | o | o   o   o   o   o   o   o
      |   |
   6  | o | o   o   o   o   o   o   o
      +---+---+
   5  | o | o | o   o   o   o   o   o
      +---+---+               +---+
   4    o   o   o   o   o   o | o | o
                              |   |
   3    o   o   o   o   o   o | o | o
                              |   |
   2    o   o   o   o   o   o | o | o
      +-------+-------+-------+---+---+
   1  | o   o | o   o | o   o | o | o |
      +-------+-------+-------+---+---+

(...)

On the botton row at { A1, B1, C1, D1, E1, F1, G1, H1 } we have something
special - it's an external MMC bus that can be 2, 4 or 8 bits wide, and it will
consume 2, 4 or 8 pins respectively, so either { A1, B1 } are taken or
{ A1, B1, C1, D1 } or all of them. If we use all 8 bits, we cannot use the SPI
port on pins { G4, G3, G2, G1 } of course.

(...)

A simple driver for the above example will work by setting bits 0, 1, 2, 3,
4 or 5 into some register named MUX, so it enumerates its available settings
and their pin assignments, and expose them like this:

#include <linux/pinctrl/pinmux.h>

struct foo_pmx_func {
	char *name;
	const unsigned int *pins;
	const unsigned num_pins;
};

static unsigned int spi0_0_pins[] = { 0, 8, 16, 24 };
static unsigned int i2c0_pins[] = { 24, 25 };
static unsigned int spi0_1_pins[] = { 38, 46, 54, 62 };
static unsigned int mmc0_1_pins[] = { 56, 57 };
static unsigned int mmc0_2_pins[] = { 56, 57, 58, 59 };
static unsigned int mmc0_3_pins[] = { 56, 57, 58, 59, 60, 61, 62, 63 };

static struct foo_pmx_func myfuncs[] = {
	{
		.name = "spi0-0",
		.pins = spi0_0_pins,
		.num_pins = ARRAY_SIZE(spi0_1_pins),
	},
	{
		.name = "i2c0",
		.pins = i2c0_pins,
		.num_pins = ARRAY_SIZE(i2c0_pins),
	},
	{
		.name = "spi0-1",
		.pins = spi0_1_pins,
		.num_pins = ARRAY_SIZE(spi0_1_pins),
	},
	{
		.name = "mmc0-2bit",
		.pins = mmc0_1_pins,
		.num_pins = ARRAY_SIZE(mmc0_1_pins),
	},
	{
		.name = "mmc0-4bit",
		.pins = mmc0_2_pins,
		.num_pins = ARRAY_SIZE(mmc0_2_pins),
	},
	{
		.name = "mmc0-8bit",
		.pins = mmc0_3_pins,
		.num_pins = ARRAY_SIZE(mmc0_3_pins),
	},
};

Looks OK?

> ** How can the board/machine name pins? That should be a function of the
> chip (i.e. pinmux driver), since that's where the pins are located. A
> chip's pins don't have different names on different boards; the names of
> the signals on the PCB connected to those pins are defined by the board,
> but not the names of the actual pins themselves.

Actually I don't really like the use of the concept of board and machine
for chip packages either. But if I say that without devicetrees it
could be something like arch/arm/plat-nomadik/package-db8500.c
defining the pins. Then it is still coming from the outside, for
a particular platform, for a particular chip package.

Then the init function in that file gets called on relevant systems.

As you can see in the example implementation for U300 I actually
do this in the driver itself by including the machine.h file to that one.
So this driver first registers pins, then functions.

I think there is broad consensus that this should come in from
the device tree in the future. And if it comes from the device tree, it's
still the say arch/arm/plat-nomadik/package-db8500.c file that looks
up the pins from the device tree and registers them, just it gets the
data from the outside.

Possibly the core could be made to do this. I know too little about
device tree I think :-/

> ** struct pinmux_map requires that each function name be globally unique,
> since one can only specify "function" not "function on a specific chip".
> This can't be a requirement; what if there are two instances of the same
> chip on the board (think some expansion chip attached to a memory-mapped
> bus rather than the primary SoC itself).

Namespace clashes are a problem but the way I see it basically a
problem with how you design the namespace. It's just a string and
the document is just an example.

If namespacing is a big issue, we may need naming schemes, but
with only one driver as I have now I think that is overkill. Platforms
already need to take care of their namespaceing, so if I create
a kernel that have mmc ports on two blocks I would just prefix them,
say:

	{
		.name = "chip0-mmc0",
		.pins = chip0_mmc0_pins,
		.num_pins = ARRAY_SIZE(chip0_mmc0_pins),
	},
	{
		.name = "chip1-mmc0",
		.pins = chip1_mmc0_pins,
		.num_pins = ARRAY_SIZE(chip1_mmc0_pins),
	},

etc for the functions (the device names are namespaced by the
device driver core I believe).

> ** Perhaps primarily due to the lack of consideration in the documentation,
> I'm not convinced we have a clearly defined path to solve the "multi-width
> bus" issue. This needs to be a feature of the core pinmux API, rather than
> something that's deferred to the board/machine files setting up different
> function mappings, since it's not possible to solve purely in function
> mappins as they're defined today.

Can this be considered fixed with the above example?
(Which will be in v4)

> Some minor mainly typo, patch-separation, etc. feedback below.

Fixed most of them...

>> +++ b/include/linux/pinctrl/pinmux.h
>> +struct pinmux;
>> +
>> +#ifdef CONFIG_PINCTRL
>> +
>> +struct pinmux_dev;
>
> I think "struct pinmux_map" is needed outside that ifdef, or an include of
> <pinctrl/machine.h>.

Yeah and it should only be used in machine.h as you point out
later, plus I forgot to stub 2 functions for sparse/dense pin registration.
Thanks!

>> +/**
>> + * struct pinmux_ops - pinmux operations, to be implemented by drivers
>> + * @request: called by the core to see if a certain pin can be muxed in
>> + *   and made available in a certain mux setting The driver is allowed
>> + *   to answer "no" by returning a negative error code
>
> That says "and made available in a certain mux setting", but no mux setting
> is passed in. s/a certain/the current/?

Sorry the missing words are "for later being selected for a certain mux
setting". So the idea is that this request control over a specific pin
and then the enable() call can select it. So a first opportunity for
the driver to  say "no" really.

I'm editing the text...

> Documentation for @free is missing here

Fixed it!

>> +/**
>> + * struct pinmux_desc - pinmux descriptor, register this to pinmux subsystem
>> + * @name: name for the pinmux
>> + * @ops: pinmux operation table
>> + * @owner: module providing the pinmux, used for refcounting
>> + * @base: the number of the first pin handled by this pinmux, in the global
>> + *   pin space, subtracted from a given pin to get the offset into the range
>> + *   of a certain pinmux
>> + * @npins: the number of pins handled by this pinmux - note that
>> + *   this is the number of possible pin settings, if your driver handles
>> + *   8 pins that each can be muxed in 3 different ways, you reserve 24
>> + *   pins in the global pin space and set this to 24
>
> That's not correct, right; if you have 8 pins, you just say 8 here?

You are right this is a leftover a previous designed where I used
a virtual pin range covering all possible mux settings. This design
was insane, so thanks for helping me smoking out the last
remnants.

> The multiplier for N functions per pin is through list_functions,
> get_function_name, get_function_pins as I understand it.

Right.

>> +static inline int pinmux_register_mappings(struct pinmux_map const *map,
>> +                                        unsigned num_maps)
>> +{
>> +     return 0;
>> +}
>
> I think you moved that to <pinmux/machine.h>?

Yep, fixed and added two missing stubs in machine.h too.

Thanks a lot!

Yours,
Linus Walleij
