Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab1F0OfC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 10:35:02 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42494 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1F0Oe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 10:34:57 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04992C07E1@HQMAIL01.nvidia.com>
References: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04992C02AC@HQMAIL01.nvidia.com>
	<BANLkTinNmPVEM4Eu4efxkuwrCU_FVWFaAg@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04992C049D@HQMAIL01.nvidia.com>
	<BANLkTikFLbU70uJO0yrf8HipcVEwbUHgsw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04992C07E1@HQMAIL01.nvidia.com>
Date: Mon, 27 Jun 2011 16:34:55 +0200
Message-ID: <BANLkTinXKgdcsGPxGUbS7sv71mQi8eL_bQ@mail.gmail.com>
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

On Thu, Jun 16, 2011 at 9:10 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Thursday, June 16, 2011 6:47 AM:
>> NOW I  *think* I get it.
>>
>> So we're basically talking about the function mapping API here.
>
> Yes, basically.
>
> In more detail, I'm talking about making the "functions" exposed to
> clients of the pinmux be a different set than the "functions"
> implemented by the pinmux driver. Perhaps we should call the former
> "mappings" not make that clear; I see you did just below!

OK I get it now I believe.

> The mappings, provided by and specific to a particular board/machine
> would always expose only the exact configurations actually used on that
> board:
>
> mapping device: "tegra-kbc"
> mapping name: "config a"
> mapping function list: row[7:4], row[3:0], col[3:0]
>
> (note how I added a "mapping name" field here; more on this below. This
> is related to mapping and function names being different things)

OK so one mapping reference several functions in this way,
I see.

>> You will need atleast to move the functions out of the mapping
>> something like this:
>>
>> static char *mmc0_10[] = { "mmc0-1:0", "mmc0-3:2", "mmc0-7:4" };
>>
>> static struct pinmux_map pmx_mapping[] = {
>>        {
>>                .functions = &mmc0_10,
>>                .functions_len = ARRAY_SIZE(mmc0_10);
>>                .dev_name = "tegra-sdhci.0",
>>        },
>> };
>>
>> Which sort of kludges up the syntax for all the simple cases that will
>> also have to add ARRAY_SIZE() and a separate string array for
>> each of its single-function maps.
>>
>> So it has the downside of complicating the simple maps.
>
> Yes, you're right. I think I have a simpler solution that degenerates to
> the same syntax as in your current patch. Starting with your original:
>
> static struct pinmux_map pmx_mapping[] = {
>       {
>               .dev_name = "tegra-sdhci.0",
>               .function = "mmc0-1:0",
>       },
>
> (where devices look up mappings by ".function", among other options)
>
> We then add a new "mapping name" field; you'll see why soon:
>
> static struct pinmux_map pmx_mapping[] = {
>       {
>               .dev_name = "tegra-sdhci.0",
>               .map_name = "2 bit",
>               .function = "mmc0-1:0",
>       },
>
> (where we now use ".map_name" for searching the list instead of
> ".function", which ties into my comment above about having explicit
> different sets of names for mapping entries and low-level pinmux driver
> internal function names.
>
> We can still set ".map_name" = NULL and omit it in the simple case where
> drivers search based on ".dev_name" and don't specify any specific
> .map_name to search for, and don't have multiple options for mappings
> they can switch between.
>
> Now, we can have multiple entries with the same .map_name:
>
> static struct pinmux_map pmx_mapping[] = {
>       {
>               .dev_name = "tegra-sdhci.0",
>               .map_name = "4 bit", # Note this is 4 now
>               .function = "mmc0-1:0",
>       },
>       {
>               .dev_name = "tegra-sdhci.0",
>               .map_name = "4 bit",
>               .function = "mmc0-3:2",
>       },
>
> This means that if a client request map name "4 bit", then both functions
> "mmc0-1:0" and "mmc0-3:2" are part of that mapping.

(...)

> In terms of implementation, this is still pretty easy; all we do when
> reserving or activating a given mapping is to walk the entire list, find
> *all* entries that match the client's search terms, and operate on all of
> them, instead of stopping at the first one.

So:
pmx = pinmux_get(dev, "4 bit");

in this case would reserve pins for two functions on pinmux_get() and
activate two different functions after one another when
we pinmux_enable(pmx) on this, "mmc0-1:0" and "mmc0-3:2" in some
undefined order (inferenced across namespace).

I don't think it's as simple as you say, this gets hairy pretty quickly:

Since my previous pinmux_get() would create a struct pinmux * cookie
for each map entry, assuming a 1:1 relationship between map entries
and pinmuxes, we now break this, and you need to introduce
more complex logic to search through the pinmux_list and dynamically
add more functions to each entry with a matching map_name.

Then you need to take care of the case where acquiring pins for
one of the functions fail: then you need to go back and free the
already acquired pins in the error path.

I tried quickly to see if I could code this up, and it got very complex
real quick, sadly. Maybe if I can just get to iterate a v4 first, I
could venture down this track.

But if you can code up the patch for this, I'm pretty much game for
it!

> struct pinmux, as returned by pinmux_get(), would need some adjustments
> to store either an array of map entries, or just the .map_name of the
> found entry/entries, so the loop could be repeated later.

Yes if we can just write the code for it I buy into it. :-)

> So sorry but just to hammer home my point, the disadvantages of the pinmux
> driver itself (as opposed to the mapping list) aggregating multiple pins
> or groups-of-pins into functions for each supported combination are:
>
> * Potential explosion of functions exposed.

Yes I understand this, what I need to know if this is a problem in real
life, i.e. that it's not just a function explosion in theory on some 5000
pin chip with a plethora of mux capabilities, but on real chips existing
now, so it's worth all the extra abstraction and code incurred by this.

But I do trust you if you say it's a real problem on the Tegra.

> * The same point, but think about a SW bit-banged bus consisting of 8
> GPIOs for the bus and 100 pins on the device. Each permutation of 8 out
> of 100 is scary... I'd love a board to be able to represent a single
> mapping for a particular board's set of GPIOs in this case, but not for
> the pinmux driver to expose all possibilities!

Is this a real world problem or a theoretical one? Seems like the
latter, and as stated in the documentation this subsystem is not about
solving discrete maths permutation spaces, but practical enumerations.

> * By having the pinmux driver expose the pins/groups in exactly the way
> the HW supports, the pinmux driver is purely a simple hardware driver,
> and doesn't know anything much beyond "program this pin/group to be this
> function". All the logic of aggregating sets of pins/groups-of-pins into
> mappings is defined by the board/machine/... when it sets up the mapping
> table. I like keeping the pinmux driver simpler, and having the boards
> describe functions in terms of which pins/groups should be set to which
> function, rather than picking for a pre-defined large list of all
> possibilities.

This is a real good argument and I buy it wholesale, if the associated
cost in code complexity does not run amok.

> For a pinmux driver that can apply to different platforms (e.g. the same
> register set applies to n different SoCs with different pin layouts), I
> think the pinmux driver itself can be parameterized with the mapping from
> register bits/fields to function names exported to the pinmux core. The
> parameterization could come from platform data, DeviceTree, ...
(...)
>> We have that situation already in Ux500. c.f.:
>> arch/arm/mach-ux500/pins-db5500.h
>> arch/arm/mach-ux500/pins-db8500.h
>>
>> Two ASICs, same set of hardware registers, but vastly different pin
>> assignments.
>
> OK, does the idea I floated a little above work; having the pinmux driver
> itself get its register->function-name mapping from some data structure
> provided to the pinmux driver?

Yes I think so. We can adapt to that.

[next subject]
> I think mapping table entry names should generally be used in conjunction
> with a device name for lookup, so it's clear which device's mappings
> you're searching for.
>
> Now, the final question is, given a mapping entry:
>
>       {
>               .dev_name = "tegra-sdhci.0",
>               .map_name = "2 bit",
>               .function = "mmc0-1:0",
>       },
>
> How do you know which pinmux driver to go to when activating the function?
>
> I think the answer is to expand the mapping table again, to be:
>
>       {
>               .dev_name = "tegra-sdhci.0",
>               .map_name = "2 bit",
>               .pmx_dev_name = "tegra-pinmux.0",
>               .function = "mmc0-1:0",
>       },
>
> The above entry means:
>
> For device "tegra-sdhci.0",
> when it wants to activate its pinmux mapping named "2 bit",
>  (where that name is optional if there's only 1 for the device)
> go to pinmux driver names "tegra-pinmux.0",
> and activate function "mmc0-1:0" there.
>
> Each registered pinmux driver would need a name. To cover the case of
> multiple instances of the exact same driver, the driver's name could
> e.g. encode I2C bus number and address for example "foochip@0.1a". I
> think that gpiolib names gpiochips along those lines? The naming that
> ASoC (ALSA for Systems on Chip; sound/soc/*) uses for I2C devices
> such as codecs works just like this.

OK sounds reasonable. But like we have an optional
struct device *dev in the mapping as an alternative to
.dev_name we should have an optional .pmx_dev too.

But I get the idea, and it'll probably work.

>> Non-surprsingly, that is exactly what the drivers/leds subsystem
>> commonly does to identify LEDs on different chips:
>
> Interesting. Having a mapping be:
>
>       {
>               .dev_name = "tegra-sdhci.0",
>               .map_name = "2 bit",
>               .function = " tegra-pinmux.0::mmc0-1:0",
>       },
>
> Instead of:
>
>       {
>               .dev_name = "tegra-sdhci.0",
>               .map_name = "2 bit",
>               .pmx_dev_name = "tegra-pinmux.0",
>               .function = "mmc0-1:0",
>       },
>
> Seems fine to me.

No, the other idea with a pmx_dev_name is much better, I was
misguided in this. That namespace style only gets hard to maintain
I think.

> However, having the pinmux drivers statically define their prefixes in
> strings at compile-time doesn't seem correct; it prevents one from having
> multiple instances of the same pinmux/led driver; having separate fields
> makes this pretty easy, and avoids having to dynamically construct
> prefixed strings at runtime.

You are right.

>> While I *think* (and DO correct me!) that you would argue:
>>
>> 1. Make it possible to map several functions to a single
>>   device map
>
> Yes.
>
>> 2. Namespace device instances by different map field
>>   members referring to specific instances
>
> Yes.

Atleast we know what the remaining problem space is now, surely we
can iron this out. But I think I need some working code for that.

Now I will post some v4 version of the framework, with some minor
corrections and bugfixes, then we can do this larger redesign on
top of that, patches welcome! I'll put in a git link.

Thanks.
Linus Walleij
