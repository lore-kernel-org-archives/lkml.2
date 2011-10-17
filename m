Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab1JQPDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:03:24 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50077 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab1JQPDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:03:23 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A166@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A166@HQMAIL01.nvidia.com>
Date: Mon, 17 Oct 2011 17:03:22 +0200
Message-ID: <CACRpkdYR=Dgd=Ohp=jOh-VpxGFFb4dYniN6N-Zaj9y6uuGDftg@mail.gmail.com>
Subject: Re: pinctrl_config APIs, and other pinmux questions
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Stijn Devriendt <highguy@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for a long letter, took som time to read, but as usual it
contains good stuff!

I think you're talking about two things here:

1) The need to configure per-pin "stuff" like biasing, driving,
  load capacitance ... whatever

2) The need to handle state transitions of pinmux settings.

I prefer that we try to keep these two separate and not conflate
them too much.

On Thu, Oct 13, 2011 at 10:59 PM, Stephen Warren <swarren@nvidia.com> wrote:

> 2) Enhance the pin controller subsystem to support configuring these
> properties.

This is definately what we want to do. That is why the subsystem was
renamed from pinmux to pinctrl in the first place, and also the rationale
for introducing the abstract pin groups.

> int (*pin_config)(unsigned pin, u32 param, u32 data);
> int (*group_config)(unsigned group, u32 param, u32 data);

Do you mean
int (*group_config)(const char *group, u32 param, u32 data);

On the latter one? We identify groups by name mainly.
The selectors is an internal thing between pinctrl core and
drivers.

> Where "param" is some driver-specific parameter, such as:
>
> #define TEGRA_PINCTRL_PARAM_TRISTATE_ENABLE    0
(...)
> I looked at a bunch of existing pinmux drivers in the mainline kernel.
> There are certainly some common concepts between SoCs. However, the
> details are often different enough that I don't think attempting to
> unify the set of configuration options will be that successful; I
> doubt we could create a generic enough abstraction of these settings
> for a cross-SoC driver to be able to usefully name and select values
> for all the different pin/group options.

I don't know, I could easily say the same thing about say input devices:
all of them are essentially different, still they opted to create the file
<linux/input.h> with this kind of stuff:

...
#define KEY_COMMA               51
#define KEY_DOT                 52
#define KEY_SLASH               53
#define KEY_RIGHTSHIFT          54
#define KEY_KPASTERISK          55
...

And it has proven to be very useful. I'd rather opt to just remove
the TEGRA_ prefix from all the above, and that we try to create some
common sematics to these calls.

> Data being a plain u32 rather than a pointer as your v7 patchset had it:

Actually it looked like this:

static inline int pinmux_config(struct pinmux *pmx, u16 param,
                               unsigned long *data)

That was supposed to be an unsigned long (not a *pointer), which
is exchangeable to pointer, as per the example known from
interrupt handlers. It can also be used to pass a plain argument.
It was designed to be "ioctl()-like".

So I prefer we say:
int (*pin_config)(unsigned pin, u32 param, unsigned long data);
int (*group_config)(const char *group, u32 param, unsigned long data);

> Using a pointer does allow passing arbitrary data into the driver, which
> seems useful. However, this also makes it much more difficult for the
> core pin controller API to handle the values, e.g. in the mapping table,
> in a device-tree representation thereof, etc.

Only if it treats "param" as opaque. If we let "param"
infer the semantics of "data" it's no problem, and it can
easily switch(param) to select the proper semantics for the
data.

> Having both config_pin and config_group functions:

I buy that straight off, there is obviously a need for that.

> Issue 2: Do we need a new "pin settings" table passed from the board to
> the pin controller core?

Yes I think so, trying to stuff it into the mappings does not look
appealing at all. We should try to separate concerns, also it makes
for nice separation in the DT metadata I suspect?

> Issue 3: Do we need to change "pin settings" on-the-fly, or only at boot?

Both I think, from own experience and from reading the
text below...

> struct pinmux_map {
>        const char *name;
>        struct device *ctrl_dev;
>        const char *ctrl_dev_name;
>        enum pinmux_map_type type;
>        union {
>            struct {
>                const char *function;
>                const char *group;
>            } mux;
>            struct {
>                u32 param;
>                u32 data;
>            } config;
>        } data;
>        struct device *dev;
>        const char *dev_name;
>        const bool hog_on_boot;
> };
>
> Such that pinmux_enable would both activate all the mux settings, and
> also call pin/group_config based on the mapping table.

No thanks :-)

Let's keep these two separate. One mapping, one default
pin config or whatever we want to call it.

> I'd like to enhance the pinmux core to allow the mapping table to be read
> from device tree. If we end up with a separate "pin configuration" table,
> the same applies there. Do you have any thoughts here, or should I just go
> ahead and create/propose something? I'd probably base this partially on my
> previous patches that do this within the Tegra pinmux driver itself.

Something is better than nothing, but I cannot claim to be
knowledgeable in DT.

Right now I would prefer to create basic stuff first, i.e. create
a device tree binding for the stuff we have - the mapping table,
get that ready for merge and then move on to the next thing.

> Now let's suppose that we've enhanced the mapping table to support pin/
> group_config values, and that a driver is written to expect a pinmux
> mapping table with the following mappings:
>
> "active"
> "suspend"

I'm not following why this should be different mappings.

I would rather contrast it with the similar concept from the
regulator framework, these have modes like these:

enum regulator_status {
        REGULATOR_STATUS_OFF,
        REGULATOR_STATUS_ON,
        REGULATOR_STATUS_ERROR,
        /* fast/normal/idle/standby are flavors of "on" */
        REGULATOR_STATUS_FAST,
        REGULATOR_STATUS_NORMAL,
        REGULATOR_STATUS_IDLE,
        REGULATOR_STATUS_STANDBY,
};

So I think we should have pin group states in a similar
manner:

enum pinmux_state {
    PINMUX_STATE_DEFAULT, /* == active */
    PINMUX_STATE_LOWPOWER,
};

And associated calls:

pinmux_set_state(const char *group, enum pingroup_state state);

> Where the only difference between those two mappings is some pin/
> group_config value. When switching between those two settings, the "active"
> mux values will be rolled back to some "safe" values, then the "suspend"
> mux values will be re-programmed. This may cause spurious changes in output
> signals, depending on what the "safe" function is exactly. It might even
> temporarily change some pins from inputs to outputs.

A pinmux_set_state() function all the way down to the driver
could handle this I think.

> The pinmux API currently conflates two different things:
>
> a) A device's ownership of certain pins.
>
> b) The configuration of those pins.
>
> I think we should aim for some mechanism of teasing those two concepts
> apart, and allowing dynamic transitioning between different configurations
> for the owned pins without completely releasing them.

I agree with this. So we only need to decide on a proper
mechanism. pinmux_set_state() looks appealing to me...

> Driver mapping_name configuration settings
> -----------------------------------------
> i2c    -            active        group i2cp.mux = i2c
> i2c    -            active        group i2cp.tristate = false
> i2c    -            suspend       group i2cp.mux = i2c
> i2c    -            suspend       group i2cp.tristate = true

I would prefer not to try to shoehorn this into the mapping
table. Isn't it possible to introduce this in some orthogonal
way, like a per-group state table with associated groups?

Right now the pinmux_map** enumerates the valid
groups, and pinmux_get()/put() selects one of them,
I don't see any problem with pinmux_set_state() changing
from one group to another.

If this has to follow some specific order like first go
from group A -> B -> C should probably be handled in
the driver since that's definately HW-specific, else we start
embedding some scripting engine in the pinctrl core
and that would be most unfortunate (IMO).

> Driver probe():
>
> reservation = pinmux_reserve(device, NULL /* mapping_name */)
> pinmux_select(reservation, "active")

Just
pmx = pinmux_get()

> Driver suspend():
> pinmux_select(reservation, "suspend")

pinmux_set_state(pmx, PINMUX_STATE_SUSPEND);

> Driver resume():
>
> pinmux_select(reservation, "active")

pinmux_set_state(pmx, PINMUX_STATE_DEFAULT);

> Driver remove():
> pinmux_unreserve(reservation)

pinmux_put(pmx);


> For reference, I read through all the pinmux drivers I could find in arch/
> arm, and made a rough list of all the pin/group_config settings they support:

Thanks for this! I need to go over them too, also read some
datasheets I guess, else I can not figure out whether my
idea of trying to keep parameters generic makes sense or is
just plain raving mad.

Yours,
Linus Walleij
