Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab1FPMrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:47:23 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42315 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1FPMrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:47:19 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04992C049D@HQMAIL01.nvidia.com>
References: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04992C02AC@HQMAIL01.nvidia.com>
	<BANLkTinNmPVEM4Eu4efxkuwrCU_FVWFaAg@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04992C049D@HQMAIL01.nvidia.com>
Date: Thu, 16 Jun 2011 14:47:18 +0200
Message-ID: <BANLkTikFLbU70uJO0yrf8HipcVEwbUHgsw@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pinmux subsystem v3
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 12:11 AM, Stephen Warren <swarren@nvidia.com> wrote:
> [Me]
>> Can't you just send some patch or example .h file for the API
>> you would like to see so I understand how you think about
>> this?
>
> Are your patches in git somewhere? It's much easier for me to pull
> at present than grab patches out of email; something I certainly need
> to fix...

Yep:
git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git
pinmux-subsystem
It's based on v3.0-rc3 as of now. I tend to rebase it though.

>> static unsigned int mmc0_1_pins[] = { 56, 57 };
>> static unsigned int mmc0_2_pins[] = { 56, 57, 58, 59 };
>> static unsigned int mmc0_3_pins[] = { 56, 57, 58, 59, 60, 61, 62, 63 };
>>
>> static struct foo_pmx_func myfuncs[] = {
>>       {
>>               .name = "mmc0-2bit",
>>               .pins = mmc0_1_pins,
>>               .num_pins = ARRAY_SIZE(mmc0_1_pins),
>>       },
>>       {
>>               .name = "mmc0-4bit",
>>               .pins = mmc0_2_pins,
>>               .num_pins = ARRAY_SIZE(mmc0_2_pins),
>>       },
>>       {
>>               .name = "mmc0-8bit",
>>               .pins = mmc0_3_pins,
>>               .num_pins = ARRAY_SIZE(mmc0_3_pins),
>>       },
>> };
>>
>> Looks OK?
>
> I think that's exactly the setup I was looking to avoid. See the portion
> of the thread starting from:

Gah. Baudelaire once said something like the reason people think
they agree is that they misunderstand each other all the time.
Sorry for my lameness :-/

> static unsigned int mmc0_1_pins[] = { 56, 57 };
> static unsigned int mmc0_2_pins[] = { 58, 59 };
> static unsigned int mmc0_3_pins[] = { 60, 61, 62, 63 };
>
>        {
>                .name = "mmc0-1:0",
>                .pins = mmc0_1_pins,
>                .num_pins = ARRAY_SIZE(mmc0_1_pins),
>        },
>        {
>                .name = "mmc0-3:2",
>                .pins = mmc0_2_pins,
>                .num_pins = ARRAY_SIZE(mmc0_2_pins),
>        },
>        {
>                .name = "mmc0-7:4",
>                .pins = mmc0_3_pins,
>                .num_pins = ARRAY_SIZE(mmc0_3_pins),
>        },
>
> So a board that happens to use a 2-bit bus would define:
>
> static struct pinmux_map pmx_mapping[] = {
>        {
>                .functions = {"mmc0-1:0"},
>                .dev_name = "tegra-sdhci.0",
>        },
> };
>
> But a board that happens to use an 8-bit bus would define:
>
> static struct pinmux_map pmx_mapping[] = {
>        {
>                .functions = {"mmc0-1:0", "mmc0-3:2", "mmc0-7:4"},
>                .dev_name = "tegra-sdhci.0",
>        },
> };

NOW I  *think* I get it.

So we're basically talking about the function mapping API here.

So the idea is that one mapping can reference several functions.

So with this scheme actually both ways of doing this would be
possible IIUC.

Note that this will be *quite* tricky to implement, since you have
an array of undetermined size with elements of undetermined size
in .functions = {"mmc0-1:0", "mmc0-3:2", "mmc0-7:4"}.

You will need atleast to move the functions out of the mapping
something like this:

static char *mmc0_10[] = { "mmc0-1:0", "mmc0-3:2", "mmc0-7:4" };

static struct pinmux_map pmx_mapping[] = {
       {
               .functions = &mmc0_10,
               .functions_len = ARRAY_SIZE(mmc0_10);
               .dev_name = "tegra-sdhci.0",
       },
};

Which sort of kludges up the syntax for all the simple cases that will
also have to add ARRAY_SIZE() and a separate string array for
each of its single-function maps.

So it has the downside of complicating the simple maps.

What I think we need to understand at this point is what will be the
most common case: that a mapping selects a single or multiple
functions. If the case is rare I'd opt for my scheme (i.e. defining
one function per bus width) to keep it simple, whereas if a vast
majority of the function tables and mappings for say Tegra will be
way simpler this way, it'll be worth the increase in complexity
of the function mapping API.

> ... although struct pinmux_map would probably need to grow a separate
> name field

I don't get this, the member "function" is a name of the function:

struct pinmux_map {
        const char *function;
        (...)
};

> to match against pinmux_get's 2nd parameter, rather than
> assuming the driver's function names and the mapping's function names
> were the same.
>
> Such a new name field would also introduce a second namespace that'd
> satisfy my next concern.
>
>> > ** How can the board/machine name pins? That should be a function of the
>> > chip (i.e. pinmux driver), since that's where the pins are located. A
>> > chip's pins don't have different names on different boards; the names of
>> > the signals on the PCB connected to those pins are defined by the board,
>> > but not the names of the actual pins themselves.
>>
>> Actually I don't really like the use of the concept of board and machine
>> for chip packages either. But if I say that without devicetrees it
>> could be something like arch/arm/plat-nomadik/package-db8500.c
>> defining the pins. Then it is still coming from the outside, for
>> a particular platform, for a particular chip package.
>>
>> Then the init function in that file gets called on relevant systems.
>>
>> As you can see in the example implementation for U300 I actually
>> do this in the driver itself by including the machine.h file to that one.
>> So this driver first registers pins, then functions.
>>
>> I think there is broad consensus that this should come in from
>> the device tree in the future. And if it comes from the device tree, it's
>> still the say arch/arm/plat-nomadik/package-db8500.c file that looks
>> up the pins from the device tree and registers them, just it gets the
>> data from the outside.
>
> I think discussion of DeviceTree here is a bit of a distraction; if the
> pinmux core APIs imply the correct data model, it doesn't seem especially
> relevant.

OK... maybe too much distraction here. All the DT noise
makes me dizzy too :-P

> For the pinmux drivers themselves, I expect the SoC's pinmux driver to
> define the set of pins available, and the set of functions available.

Yes, for those that map 1-to-1 for a certain platform.

I'm a little bit sceptical due to the risk of getting into a situation
where every implementation claims to be special and ending up
having to consolidate a lot of stuff that really wasn't that special a few
years down the road, like the ARM tree right now. But maybe that's
our destiny  so no big deal :-)

> There will be a single static set of pins/functions for any Tegra 2
> device. Tegra 3 will have a different set of pins/functions since the
> HW changed quite a bit in this area. As such, DeviceTree doesn't really
> help much, since there will always be a custom driver per SoC, and the
> data a given driver uses will not vary between boards, so DeviceTree
> helps little.

Yep I get it. s/device tree/board file/g and the same reasoning holds
for anything coming from the platform/package/machine data.

> On the other hand, if you've got a very generic pinmux controller, and
> it gets included in N (versions of) SoCs with the same register layout,
>  but the actual pin names related to each register bit
> are different, then I can see it making sense for the pinmux driver
> itself to parameterize itself with data from DeviceTree.

We have that situation already in Ux500. c.f.:
arch/arm/mach-ux500/pins-db5500.h
arch/arm/mach-ux500/pins-db8500.h

Two ASICs, same set of hardware registers, but vastly different pin
assignments.

> Either way
> though, this is purely an implementation detail within the pinmux driver,
> and not something the core would even be aware of.

OK with me for now atleast, I don't know about other people's
ambitions.

> However, I do think the board-specific list of struct pinmux_map will
> come from DeviceTree. This will vary from board to board with potentially
> little commonality. DeviceTree seems a great solution to keep all that
> varying data out of the kernel. The core pinmux code could well include
> the common code to parse the DeviceTree for this data.

Agreed.

>> > ** struct pinmux_map requires that each function name be globally unique,
>> > since one can only specify "function" not "function on a specific chip".
>> > This can't be a requirement; what if there are two instances of the same
>> > chip on the board (think some expansion chip attached to a memory-mapped
>> > bus rather than the primary SoC itself).
>>
>> Namespace clashes are a problem but the way I see it basically a
>> problem with how you design the namespace. It's just a string and
>> the document is just an example.
>
> The issue here is that the pinmux driver defines a single namespace for
> functions, and struct pinmux_map's definition passes that single namespace
> through, since the value of .function comes from that same namespace, and
> is also the search key for the list of driver-visible functions.

So this would be the case if you say had two identical chips on I2C, both
of which could mix some their pins.

That (in the sense of the present design) would be an argument to mandate
to always pass the function names from platform data to drivers that
handle more than once instance, so the function names are always
unique.

(This is more about understanding, really, tell me if I got it wrong.)

> As I alluded to above, if struct pinmux_map had a separate field for the
> search key (for pinmux_get's use) v.s. the set of driver functions that
> key maps to, then there can be separate namespaces, and a place to resolve
> conflicts:
>
> struct pinmux_map_entry {
>        struct pinmux_dev *pmxdev
>        const char *function; // pmxdev's specific function name-space
> };

This looks scary to me: we're already trying to avoid putting
struct device * into the map in favor of using dev_name to look
it up.

How do you intend to get struct pinmux_dev * into the map
entry?

Remember that the map is a static thing that is defined at
compile-time, whereas struct pinmux_dev * is something
that appears at runtime.

It seems smarter to me to use some naming convention,
but it definately need to keep track of instances, so we
need something like the device_name() from the
pinmux_dev:s struct device, that will be unique for each
instance, then match on that.

But maybe if you make a patch I can understand this better,
I might just not see how this could work.

> struct pinmux_map {
>        const char *name; // global driver-visible function name-space
>        struct device *dev;

This struct device *dev is curretly unused btw.

I even made my map a __initdata in the U300 case, and I think
that should be the norm, this would only be useful in runtime,
maybe with device trees.

>        const char *dev_name;
>        int n_ functions;
>        const struct pinmux_map_entry * functions;
> };
>
> Thinking about this at a high level, this seems equivalent to the GPIO
> driver:

Sorry, not following. Which GPIO driver? Are you referring to
gpiolib?

> There are two name-spaces there:
>
> 1) One used by clients: A global name-space, equivalent to
> pinmux_map.name.
>
> 2) One used by GPIO drivers: A per-driver name-space, equivalent to
> pinmux_map_entry.function.
>
> ... and the GPIO core maps from (1) to (2) above internally.
>
> In the pinmux case, since everything is named by a string rather than a
> linear number range, the mapping process needs the pinmux_map_entry.function
> field, rather than just substracting a GPIO driver's base GPIO number.

I see you refer to the way that the global GPIO ID is mapped to an
offset into the respective GPIO driver by subtracting the offset of each
GPIO chip. (Correct me if wrong.)

I think I understand what you mean, but I would claim that that an
unsigned integer number space has quite different semantics from a
namespace for them to be compared in that way. For example
it is very simple and quick to map one into the other by a simple
subtraction of an offset.

In this case, with the design above you need to know two
namespaces instead of one when writing your platform data,
and that makes things more complex in my view.

So instead of using a simple 1D string "chip0::mmc0" to identify
some function in a specific driver, you use the tuple
("chip0", "mmc0") and I think it's getting complex and hard to
express as struct members, but that may be because I don't
quite see how clever this is.

To me it seems plausible that the easiest way
to do this is that if a driver wants a private namespace
it just defines a separator such as "::" in above and we provide
some simple string split function to get chipname and function
name from that.

Non-surprsingly, that is exactly what the drivers/leds subsystem
commonly does to identify LEDs on different chips:

drivers/leds$ grep '::' *
dell-led.c:	.name		= "dell::lid",
leds-ams-delta.c:			.name		= "ams-delta::camera",
leds-ams-delta.c:			.name		= "ams-delta::advert",
leds-ams-delta.c:			.name		= "ams-delta::email",
leds-ams-delta.c:			.name		= "ams-delta::handsfree",
leds-ams-delta.c:			.name		= "ams-delta::voicemail",
leds-ams-delta.c:			.name		= "ams-delta::voice",
leds-clevo-mail.c:	.name			= "clevo::mail",
leds-cobalt-qube.c:	.name			= "qube::front",
leds-cobalt-raq.c:	.name		= "raq::web",
leds-cobalt-raq.c:	.name			= "raq::power-off",
leds-net48xx.c:	.name		= "net48xx::error",
leds-wrap.c:	.name			= "wrap::power",
leds-wrap.c:	.name		= "wrap::error",
leds-wrap.c:	.name           = "wrap::extra",

So can't we use such a convention and some helpers
like drivers/leds does instead of trying to actually match
split the namespace to C struct members? It's still a
namespace, it's just not expressed in C, but in string
structure.

If the first part (before the "::") shall be unique per
chip instance, that can be generated in runtime from
the device name or some specific .init_name to make
sure it does not vary too much.

If you're uncertain what to think about this I can implement
this namespacing scheme for U300 so we have some example?

So to summarize there are two related areas of discussion
here:

1. Whether a pinmux map shall map one or 1..N functions
2. How to handle per-driver instance namespacing of functions

In both cases I'm currently using simple strings and claiming
that by namespacing these strings cleverly we can avoid
complexity. So my answer to these are:

1. Use several functions with ovelapping maps, just name
  them differently
2. Use a string convention and namespace by using
  platform/machine/package data and string conventions
  such as a "::" separator

While I *think* (and DO correct me!) that you would argue:

1. Make it possible to map several functions to a single
  device map
2. Namespace device instances by different map field
  members referring to specific instances

Is this correctly understood, even if we may not agree?

Thanks,
Linus Walleij
