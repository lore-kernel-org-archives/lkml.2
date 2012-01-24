Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab2AXWaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:30:06 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18418 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2AXWaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:30:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 24 Jan 2012 14:29:38 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Tony Lindgren <tony@atomide.com>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "Shawn Guo (shawn.guo@linaro.org)" <shawn.guo@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 24 Jan 2012 14:29:37 -0800
Subject: RE: Pinmux bindings proposal V2
Thread-Topic: Pinmux bindings proposal V2
Thread-Index: AczaNmbvBCJhz4ZkQpm01kFwDIBG6QArxzlQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178CB81EDB@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <20120123210052.GS22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB81C0D@HQMAIL01.nvidia.com>
 <20120124012038.GT22818@atomide.com>
In-Reply-To: <20120124012038.GT22818@atomide.com>
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

Tony Lindgren wrote at Monday, January 23, 2012 6:21 PM:
> * Stephen Warren <swarren@nvidia.com> [120123 14:37]:
> > Tony Lindgren wrote at Monday, January 23, 2012 2:01 PM:
> > > This mostly looks pretty good to me, few more comments below.
...
> > > >                 pmx_sdhci_active: pinconfig-sdhci-active {
> > > >                         /*
> > > >                          * In each of these nodes, both the mux and config
> > > >                          * properties are optional. This node represents the
> > > >                          * additions to pmx_sdhci that are specific to an
> > > >                          * active state. In this case, only pin configuration
> > > >                          * settings are different.
> > > >                          */
> > > >                         config =
> > > >                                 <TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 0>
> > > >                                 <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 0>;
> > > >                 };
> > > >                 pmx_sdhci_standby: pinconfig-sdhci-standby {
> > > >                         config =
> > > >                                 <TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
> > > >                                 <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>;
> > > >                 };
> > >
> > > After thinking about this a bit more, I'm now thinking that we should
> > > probably only describe the active state in the device tree to keep things
> > > simple.
> > >
> > > Anything PM related could be initialized later on during the boot by the
> > > device driver, or even from userspace using /lib/firmware or /sys entries.
> > > This would cut down the device tree bloat quite a bit.
> >
> > I think it makes sense to describe everything in one place. It's much
> > easier to ensure everything is consistent and correct if you don't have
> > to cross-check two sources of data for the same thing.
> 
> But we end up repeating the same bits over and over again making the device
> tree bloated.

What exactly gets repeated; can you please show an example?

Given that each named state can reference n nodes defining part of that
state's pinmux configuration, and some of those nodes can affect the same
pin controller, you can easily split the overall configuration into
"stuff that's common for all states for this device" and "stuff that's
common between these n states of the device but not these m others" and
"stuff that's unique to this 1 state", and hence avoid repeating any
identical information.

> I'm suspecting that the initial state can be used to set the PM states for
> pins. Probably most pins can have the PM configuration set from the start.

Can you please explain more?

> If dynamic muxing is needed, it should be for a very limited set of pins,
> and that can be done in the drivers.

(and later, saying the same thing):
> > > If we only allow describing the initial state in device tree, then we can
> > > leave out pinctrl-names, and assume the setting is always the initial bootup
> > > state desired.
> >
> > That's true, but people have already discussed the usefulness of having
> > multiple named states, e.g. an SDHCI controller that needs different pin
> > configuration (perhaps drive strength or slew rate?) depending on the
> > clock rate of the SD interface itself.
> 
> Yes but those too should be doable from the device drivers using pin ctrl
> framework calls. Usually it's just few pins that needs to change dynamically.

Do you mean drivers explicitly requesting that a named pin/group have
some specific parameter set to some specific value?

That would make the peripheral driver have to know specific details of
each SoC's pin controller. This isn't an issue for one-off IP, but if
you've got some IP block that gets re-used in 2 or 3 different SoCs each
with a SoC-vendor-specific pin controller, then the driver is going to
have to know those same details 3 times over, which is pretty much exactly
what we're trying to avoid by abstracting the details out of the drivers
and into a common binding that's handled by the pinctrl subsystem.

> > > Setting the initial state from device tree makes sense, but I'm afraid
> > > the standby and off states will require driver interaction depending on
> > > how the user wants to configure the system.
> > >
> > > For example, allowing a device to wake up a system might be user
> > > configurable option, such as "Wake up on tapping the touchscreen".
> >
> > That can be supported pretty easily.
> >
> > The driver for a simple device can require two named states: "active"
> > and "standby". In your more complex example, the driver can require
> > three named states: "active", "standby", "standby-wake". During suspend,
> > it'll simply select the appropriate of the latter two states based on
> > user request.
> >
> > You can even retrofit this capability to a previously simple driver that
> > Originally did:
> >
> > suspend() {
> >     pinconf_select(dev, "suspend");
> > }
> >
> > To make it do the following instead:
> >
> > suspend() {
> >     if (wake)
> >         state = "suspend-wake";
> >     else
> >         state = "suspend-nowake";
> >     err = pinconf_select(dev, state);
> >     if (err < 0)
> >         pinconf_select(dev, "suspend";
> > }
> >
> > ... which should allow old device trees to work fine, but new device
> > trees to specify a different if they need.
> 
> You can do just the same from a driver with something like:
> 
> 	...
> 	res = pin_config_set_for_pin(pctldev, pin, PIN_STATE_SUSPEND);
> 	...
> 
> As long as the pinconf/pinmux driver knows how to set PIN_STATE_SUSPEND
> for one entry. Note that I've avoided using pin_config_set here because
> there really should not be any string parsing needed except during driver
> init for doing things like this during runtime..

In order to implement pin_config_set_for_pin(), you still need some
source of data defining what PIN_STATE_SUSPEND means. I has been suggested
to defer that knowledge into each individual pin controller driver, but
since this is probably board-specific in general, that means that each
pin controller driver then needs to parse the data from device tree, so
we end up with exactly the same data in device tree, just represented in
a different way for each SoC vendor. To me, that's exactly what the pinctrl
subsystem and common pinctrl DT bindings are trying to avoid.

> > > Then I'd rather not use "config" at all, and just put the value for
> > > initial state mux register(s) in the mux to avoid repeating the same data
> > > multiple time. Looks like with the mux + config/mux-config option you
> > > need to duplicate at least TEGRA_PMX_PG_DTA.
> > >
> > > BTW, maybe the name "config" should probably be "mux-config" instead?
> >
> > Mux and config are two unrelated things though. Mux is the function
> > (signal, alternate function, mission mode, ...) that is selected for
> > the pin/group in question. Config is anything else, but explicitly not
> > mux, such as pull-up, pull-down, tri-state, drive-strength, etc.
> 
> Right, but how many registers are you really writing to? In the cases
> I've seen it's mostly just one register. In some cases it can be three
> tree registers per mux, but only one would change during runtime
> potentially.

For each pin group on Tegra20, there are 1, 2, or 3 registers that affect
it. In most cases, each register contains fields that affect multiple pin
groups. On Tegra30, there is 1:1 mapping between registers and pin groups.

> > > So to summarize: I suggest we'll just stick to basics to get the system
> > > booting and devices working using device tree. In most cases the device
> > > drivers should be able to configure the suspend and off states in a generic
> > > way using pinctrl API. Everything else, like debugging, we can probably
> > > do with userspace tools.
> >
> > But how will they configure suspend/off states in a generic way using the
> > pinctrl API if the pinctrl API has no way of knowing how to configure the
> > pins in suspend...
> 
> We can have a set of defined states that the pinmux/pinconf drivers can
> implement. Then have functions to get/set a mux or a mux group. And then
> the triggering could be hooked up into pm_runtime calls just like clock
> framework calls.

Does runtime PM allow drivers to request arbitrary states, i.e. make up
device-specific state names? I must admit I'm not at all familiar with it,
but I'd expect it supports "active" and "inactive", whereas to support the
SDHCI controller example that's been mentioned, it'd need to support
"active 24MHz", "active 40MHz", "inactive" (the exact clock rates I use in
this example may be wrong).

-- 
nvpublic

