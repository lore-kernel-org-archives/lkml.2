Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab1JNOsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:48:37 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:16851 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab1JNOsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:48:36 -0400
X-SpamScore: -16
X-BigFish: VS-16(zz168aJ1432N98dK1455Mzz1202hzzz2dh2a8h668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 14 Oct 2011 22:59:02 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
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
Subject: Re: pinctrl_config APIs, and other pinmux questions
Message-ID: <20111014145900.GA28728@S2100-06.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A166@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A166@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It might be a good place for me to catch up the pinctrl subsystem
discussion, as far as imx migration concerned.

I have not read the backlog of all the previous discussion, so please
excuse me if something I put here have been discussed.

On Thu, Oct 13, 2011 at 01:59:55PM -0700, Stephen Warren wrote:
> Linus, (and other people interested in pinmux!)
> 
> I've started to look at porting the Tegra pinmux driver to your pinctrl
> subsystem. In order to replace the existing pinmux driver, I need a way
> to support configuring options such as tri-state, pull-up/down, drive-
> strength, etc.
> 
I'm also concerned about this.  The current pinctrl subsystem only
implements pinmux.  Before pin/pad configuration (pincfg) support is
available, I can not really convert imx iomuxc driver (iomux-v3) over
to use the subsystem.

> At this point, I have a couple of options:
> 
> 1) Initialize all those parameters (and indeed the initial system-level
> mux configuration) using custom code in the Tegra pinmux driver, and just
> use the pin controller subsystem APIs for dynamic pin-muxing. As you
> recall, I did post some patches to the Tegra pinmux driver to do this,
> but I'm hoping to do (2) instead.
> 
> 2) Enhance the pin controller subsystem to support configuring these
> properties.
> 
Yeah.  I remember Linus.W originally named the subsystem pinmux and
changed it to pinctrl later for that he wants to cover not only pinmux
but also pin/pad configuration with this subsystem.

> The following is some issues that need to be thought about if we do (2):
> 
> 
> 
> 
> Issue 1: Pinctrl core -> driver interface
> 
This is something I'm not completely follow right now.

Looking at the two drivers already migrated to the subsystem,
pinmux-u300 and pinmux-sirf, from the naming of the driver, it
seems they are supposed to be pinmux drivers and only handle pinmux.
Is it a indication that we will have another pincfg driver to handle
pin configuration?  In that case, we need to have a clear separation
among pinmux, and pincfg and pinctrl (core), e.g. pinctrl_ops probably
should not stay in pinmux driver.

Alternatively, we can have driver pinctrl-u300 rather than pinmux-u300
handling both pinmux and pincfg in one driver.  If pinmux and pincfg
are not so standalone, e.g. we may want to expand the mapping to be
function-pinmux-pincfg, this option might be good.

> I propose adding the following to pinctrl_ops:
> 
> int (*pin_config)(unsigned pin, u32 param, u32 data);
> int (*group_config)(unsigned group, u32 param, u32 data);
> 
If we take pinmux and pincfg as two equal but separate pieces of
pinctrl, having pinmux_ops for pinmux while plugging pincfg ops into
pinctrl_ops is something looks odd to me.

The reasonable way to add pincfg functions into pinctrl_ops would be
that we have driver named pincrl-u300 rather than pinmux-u300, both
pinmux_ops and pincfg_ops embedded in pinctrl_ops, to handle pinmux
and pincfg in the same driver.

> Where "param" is some driver-specific parameter, such as:
> 
> #define TEGRA_PINCTRL_PARAM_TRISTATE_ENABLE    0
> #define TEGRA_PINCTRL_PARAM_PULL_TYPE          1
> #define TEGRA_PINCTRL_PARAM_SCHMITT_ENABLE     2
> #define TEGRA_PINCTRL_PARAM_HIGH_SPEED_ENABLE  3
> #define TEGRA_PINCTRL_PARAM_DRIVE_STRENGTH     4
> #define TEGRA_PINCTRL_PARAM_PULL_UP_STRENGTH   5
> #define TEGRA_PINCTRL_PARAM_PULL_DOWN_STRENGTH 6
> #define TEGRA_PINCTRL_PARAM_SLEW_RATE_RISING   7
> #define TEGRA_PINCTRL_PARAM_SLEW_RATE_FALLING  8
> 
> Rationale:
> 
> Param being SoC-specific:
> 
+1

> I looked at a bunch of existing pinmux drivers in the mainline kernel.
> There are certainly some common concepts between SoCs. However, the
> details are often different enough that I don't think attempting to
> unify the set of configuration options will be that successful; I
> doubt we could create a generic enough abstraction of these settings
> for a cross-SoC driver to be able to usefully name and select values
> for all the different pin/group options.
> 
> Data being a plain u32 rather than a pointer as your v7 patchset had it:
> 
+1

> Using a pointer does allow passing arbitrary data into the driver, which
> seems useful. However, this also makes it much more difficult for the
> core pin controller API to handle the values, e.g. in the mapping table,
> in a device-tree representation thereof, etc.
> 
> Having both config_pin and config_group functions:
> 
> Tegra at least has settings that are applicable to groups. Most (all??)
> other SoCs apply configurations to individual pins. I think we need
> separate functions to make this explicit, so the function knows if it's
> looking up selector as a pin name (ID) or a group name (ID).
> 
The "group" defined in this subsystem does not necessarily require
multiple pins be controlled by single register at hardware level.
A group of pins muxed for given function can be controlled by hardware
in the way of individual pin.  Similar to pinmux, I guess that the
interface between pincfg and core can take group only, and leave the
mapping between group and pins to the driver.  Single-pin function can
be a particular case of group-pins.

> 
> Issue 2: Do we need a new "pin settings" table passed from the board to
> the pin controller core?
> 
> Issue 3: Do we need to change "pin settings" on-the-fly, or only at boot?
> 
I at least have one case on imx that needs change pincfg on-the-fly.
The usdhc on imx6q requires different SD pin/pad configurations for
different SD bus frequencies, 50M, 100M and 200M.  We can not have one
configuration working for all these three frequencies, and have to
change configuration per different frequency setting on the fly.

> These issues are closely related.
> 
> If we only care about statically configuring pins at boot time, then
> pinmux_register_mappings() could be enhanced to accept two tables; the
> existing one for the mux settings, and a second one that's essentially
> just a list of pin/group_config calls to make at pinmux init time.
> 
> However, if we ever want things to change dynamically (say, suspend/
> resume), or only be activated when a device initializes (just like the
> mux settings), we need to enhance struct pinmux_map to contain either
> mux settings or config settings; perhaps rework it as follows:
> 
I would think that we need to enhance pinmux_map to contain both mux
*and* config settings.  To me, the mapping seems to be a group of pins
with specific mux and config settings for a given function.

> enum pinmux_map_type {
>     MUX,
>     PIN_CONFIG,
>     GROUP_CONFIG
> };
> 
> struct pinmux_map {
>         const char *name;
>         struct device *ctrl_dev;
>         const char *ctrl_dev_name;
>         enum pinmux_map_type type;
>         union {
>             struct {
>                 const char *function;
>                 const char *group;
>             } mux;
>             struct {
>                 u32 param;
>                 u32 data;
>             } config;

If the config has limited number of possible settings for given
function, we can probably enumerate it in pinctrl driver just like
what we are doing with pinmux option, and add parameter "config" to
pinmux_map to select pincfg option for given mapping.

@@ -46,6 +46,7 @@ struct pinmux_map {
        const char *ctrl_dev_name;
        const char *function;
        const char *group;
+       const char *config;
        struct device *dev;
        const char *dev_name;
        const bool hog_on_boot;

>         } data;
>         struct device *dev;
>         const char *dev_name;
>         const bool hog_on_boot;
> };
> 
> Such that pinmux_enable would both activate all the mux settings, and
> also call pin/group_config based on the mapping table.
> 
> 
> 
> 
> Issue 4: Device-tree
> 
Yes, with pincfg added and mapping described by device tree, we will
have the subsystem fully ready for existing pinctrl driver under arch/
to migrate to.

> I'd like to enhance the pinmux core to allow the mapping table to be read
> from device tree. If we end up with a separate "pin configuration" table,
> the same applies there. Do you have any thoughts here, or should I just go
> ahead and create/propose something? I'd probably base this partially on my
> previous patches that do this within the Tegra pinmux driver itself.
> 
> 
> 
> 
> Issue 5: Suspend/resume, and other state changes
> 
> First, some HW background on Tegra, which I imagine applies to any SoC
> capable of muxing a single "function" onto different sets of pins:
> 
> Lets take Tegra's first I2C controller. It can be mux'd onto pingroups
> "I2CP" or "RM". Given the register definitions (for each pingroup, there's
> a "function select" register field), it's possible to tell the HW to mux
> that I2C function onto *both* pingroups at once. However, we must avoid
> this, because this will cause incorrect HW operation; for input pins, both
> pingroups will be trying to drive the internal signal. At best, this will
> cause the I2C controller to receive garbled signals. At worst, it will
> cause damage to the chip. (I'm not sure which is true in Tegra's case).
> 
> For this reason, any time the pinmux driver is told to disable a function,
> it must program that pingroup's mux function to a "safe" value, which is
> guaranteed not to cause conflicts for any other possible mux settings on
> other pingroups. Possibly, the driver should tristate the pingroup too,
> to avoid whatever HW function the "safe" function is from actually driving
> any output pins and confusing the attached device. Our current driver
> doesn't tristate though.
> 
> Now let's suppose that we've enhanced the mapping table to support pin/
> group_config values, and that a driver is written to expect a pinmux
> mapping table with the following mappings:
> 
> "active"
> "suspend"
> 
> Where the only difference between those two mappings is some pin/
> group_config value. When switching between those two settings, the "active"
> mux values will be rolled back to some "safe" values, then the "suspend"
> mux values will be re-programmed. This may cause spurious changes in output
> signals, depending on what the "safe" function is exactly. It might even
> temporarily change some pins from inputs to outputs.
> 
> The pinmux API currently conflates two different things:
> 
> a) A device's ownership of certain pins.
> 
> b) The configuration of those pins.
> 
> I think we should aim for some mechanism of teasing those two concepts
> apart, and allowing dynamic transitioning between different configurations
> for the owned pins without completely releasing them.
> 
> There's also the slight issue that if you put() a mapping to change to
> another one, there's a small window where the driver doesn't own the pins,
> which might show up in a pinmux debug file, or allow another driver to
> take ownership of them.
> 
I agree with above observations.  For my example on imx6q usdhc, when
changing from one mapping to another with only pincfg differences, we
should manage pinctrl core not release the pins.  I'm not sure that the
following solution is optimal though, as the changes to the API seems
significant.

Regards,
Shawn

> One possibility might be to add another column to the mapping table, so
> that we end up with the search key being:
> 
> Search keys: device, name, configuration (new)
> Output data: list of mux settings, pin/group_config settings
> 
> This would modify the client driver API to something like:
> 
> Mapping table:
> 
> Driver mapping_name configuration settings
> -----------------------------------------
> i2c    -            active        group i2cp.mux = i2c
> i2c    -            active        group i2cp.tristate = false
> i2c    -            suspend       group i2cp.mux = i2c
> i2c    -            suspend       group i2cp.tristate = true
> 
> Driver probe():
> 
> reservation = pinmux_reserve(device, NULL /* mapping_name */)
> pinmux_select(reservation, "active")
> 
> Driver suspend():
> 
> // Within this call, the pinmux driver doesn't have to program safe values
> // into HW, because it knows that any future programming on pins relevant
> // to the driver can only be driven by mapping table entries for the "4-bit"
> // reservation, and we assume the person creating those mapping table
> // entries didn't set up some problematic configuration
> //
> // The mapping tables may be set up so the only difference is some pin/
> // group_config values here
> pinmux_select(reservation, "suspend")
> 
> Driver resume():
> 
> pinmux_select(reservation, "active")
> 
> Driver remove():
> 
> // Within this call, the pinmux driver programs the safe values into HW,
> // since the ownership of the pins is released; some other driver may
> // start using the pins or mux'd HW modules now.
> pinmux_unreserve(reservation)
> 
> In this scheme, the mapping table might even be enhanced to be a list of
> actions to perform on each transition, rather than completely describing
> the state of the mux in each state. That might optimize the set of actions
> performed by some state transitions, if the mapping table author desires.
> 
> What are your thoughts on this?
> 

