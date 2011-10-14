Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1JNPyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:54:09 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1763 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab1JNPyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:54:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 14 Oct 2011 08:53:34 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Shawn Guo <shawn.guo@freescale.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stijn Devriendt <highguy@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>
Date: Fri, 14 Oct 2011 08:53:33 -0700
Subject: RE: pinctrl_config APIs, and other pinmux questions
Thread-Topic: pinctrl_config APIs, and other pinmux questions
Thread-Index: AcyKgFuNg5UZqe9xTCy0UzuaN/5DDgABVzhg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A275@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A166@HQMAIL01.nvidia.com>
 <20111014145900.GA28728@S2100-06.ap.freescale.net>
In-Reply-To: <20111014145900.GA28728@S2100-06.ap.freescale.net>
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

Shawn Guo wrote at Friday, October 14, 2011 8:59 AM:
> It might be a good place for me to catch up the pinctrl subsystem
> discussion, as far as imx migration concerned.
> 
> I have not read the backlog of all the previous discussion, so please
> excuse me if something I put here have been discussed.
> 
> On Thu, Oct 13, 2011 at 01:59:55PM -0700, Stephen Warren wrote:
> > Linus, (and other people interested in pinmux!)
> >
> > I've started to look at porting the Tegra pinmux driver to your pinctrl
> > subsystem. In order to replace the existing pinmux driver, I need a way
> > to support configuring options such as tri-state, pull-up/down, drive-
> > strength, etc.
...
> > 2) Enhance the pin controller subsystem to support configuring these
> > properties.
>
> Yeah.  I remember Linus.W originally named the subsystem pinmux and
> changed it to pinctrl later for that he wants to cover not only pinmux
> but also pin/pad configuration with this subsystem.

AIUI, the pin control subsystem is intended to encompass both pin muxing
and pin configuration, it's just that the pin configuration part isn't
fleshed out yet, and will be via a separate ops structure that the overall
driver can provide.

...
> > I propose adding the following to pinctrl_ops:
> >
> > int (*pin_config)(unsigned pin, u32 param, u32 data);
> > int (*group_config)(unsigned group, u32 param, u32 data);
...
> > Having both config_pin and config_group functions:
> >
> > Tegra at least has settings that are applicable to groups. Most (all??)
> > other SoCs apply configurations to individual pins. I think we need
> > separate functions to make this explicit, so the function knows if it's
> > looking up selector as a pin name (ID) or a group name (ID).
> >
> The "group" defined in this subsystem does not necessarily require
> multiple pins be controlled by single register at hardware level.
> A group of pins muxed for given function can be controlled by hardware
> in the way of individual pin.  Similar to pinmux, I guess that the
> interface between pincfg and core can take group only, and leave the
> mapping between group and pins to the driver.  Single-pin function can
> be a particular case of group-pins.

That's true; we could define a group for each pin, which no function uses
as a legal group/position, but does allow config() to be used.

> > Issue 2: Do we need a new "pin settings" table passed from the board to
> > the pin controller core?
> >
> > Issue 3: Do we need to change "pin settings" on-the-fly, or only at boot?
...
> > However, if we ever want things to change dynamically (say, suspend/
> > resume), or only be activated when a device initializes (just like the
> > mux settings), we need to enhance struct pinmux_map to contain either
> > mux settings or config settings; perhaps rework it as follows:
>
> I would think that we need to enhance pinmux_map to contain both mux
> *and* config settings.  To me, the mapping seems to be a group of pins
> with specific mux and config settings for a given function.
> 
> > enum pinmux_map_type {
> >     MUX,
> >     PIN_CONFIG,
> >     GROUP_CONFIG
> > };
> >
> > struct pinmux_map {
> >         const char *name;
> >         struct device *ctrl_dev;
> >         const char *ctrl_dev_name;
> >         enum pinmux_map_type type;
> >         union {
> >             struct {
> >                 const char *function;
> >                 const char *group;
> >             } mux;
> >             struct {
> >                 u32 param;
> >                 u32 data;
> >             } config;
> >         } data;
> >         struct device *dev;
> >         const char *dev_name;
> >         const bool hog_on_boot;
> > };
> 
> If the config has limited number of possible settings for given
> function, we can probably enumerate it in pinctrl driver just like
> what we are doing with pinmux option, and add parameter "config" to
> pinmux_map to select pincfg option for given mapping.
> 
> @@ -46,6 +46,7 @@ struct pinmux_map {
>         const char *ctrl_dev_name;
>         const char *function;
>         const char *group;
> +       const char *config;
>         struct device *dev;
>         const char *dev_name;
>         const bool hog_on_boot;
> 
> > Such that pinmux_enable would both activate all the mux settings, and
> > also call pin/group_config based on the mapping table.

Having the driver expose a list of all possible combinations of pin
configurations seems impractical, for the same reason as I objected to
the original proposal for how the driver listed functions; there are
simply far too many pin config parameters and legal value to list the
entire set of combinations.

Listing legal values for each param individual option might be OK, but
at least on Tegra, there are some interactions between them (e.g. for
low drive strength, I think some of the faster slew rates aren't available
or something like that). I'd tend to avoid the pinmux core defining any
format for validation of config values requested in the mapping table,
and have the driver or HW do that if required.

However, I like your idea above of simply adding one extra "config" field
to the mapping table, rather than adding extra rows each detailing one
config value. However, instead, of a "char *" pointing at an enumerated
named config, perhaps just point at a board-/dt-defined (rather than
driver-defined) list of config values:

struct pinmux_config {
    u32 param;
    u32 value;
};

Then add the following to each mapping table entry:

struct pinmux_map {
	...
	struct pinmux_config *configs;
	int                   nconfigs;


> > Issue 5: Suspend/resume, and other state changes
...
> > The pinmux API currently conflates two different things:
> >
> > a) A device's ownership of certain pins.
> >
> > b) The configuration of those pins.
> >
> > I think we should aim for some mechanism of teasing those two concepts
> > apart, and allowing dynamic transitioning between different configurations
> > for the owned pins without completely releasing them.
> >
> > There's also the slight issue that if you put() a mapping to change to
> > another one, there's a small window where the driver doesn't own the pins,
> > which might show up in a pinmux debug file, or allow another driver to
> > take ownership of them.
> >
> I agree with above observations.  For my example on imx6q usdhc, when
> changing from one mapping to another with only pincfg differences, we
> should manage pinctrl core not release the pins.  I'm not sure that the
> following solution is optimal though, as the changes to the API seems
> significant.

It true that I proposed quite a change to the API.

That said, I think most of the difference in my example was naming.
Re-writing my proposal with existing names, and modifying it to just
add parameters to existing functions rather than introducing a new set
of functions might end up with:

Driver mapping_name configuration group  mux  config
--------------------------------------------------------------------
i2c    -            active        i2cp   i2c  tristate = false, ...
i2c    -            suspend       i2cp   i2c  tristate = true, ...

Driver probe():

pmx = pinmux_get(device, NULL /* mapping_name */)
pinmux_enable(pmx, "active"); // All we do is add a new parameter here

Driver suspend():

// Within this call, the pinmux driver doesn't have to program safe values
// into HW, because it knows that any future programming on pins relevant
// to the driver can only be driven by mapping table entries for same
// reserved "pmx", and we assume the person creating those mapping table
// entries didn't set up some problematic configuration.
//
// The mapping tables may be set up so the only difference is some pin/
// group_config values here
//
// Enable acts like enable or switch-to-new-config depending on whether
// it was previously called or not.
pinmux_enable(pmx, "suspend")

Driver resume():

pinmux_enable(pmx, "active")

Driver remove():

// Within this call, the pinmux driver programs the safe values into HW,
// since the ownership of the pins is released; some other driver may
// start using the pins or mux'd HW modules now.
pinmux_disable(pmx)
pinmux_put(pmx)

-- 
nvpublic

