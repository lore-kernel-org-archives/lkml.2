Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab2A0CIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 21:08:41 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:53836 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2A0CIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 21:08:40 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Mefsk8c3QeWOiQNMPIh6X
Date: Thu, 26 Jan 2012 18:08:33 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: "Shawn Guo (shawn.guo@linaro.org)" <shawn.guo@linaro.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Pinmux bindings proposal V2
Message-ID: <20120127020832.GJ29812@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <20120123210052.GS22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB81C0D@HQMAIL01.nvidia.com>
 <20120124012038.GT22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB81EDB@HQMAIL01.nvidia.com>
 <20120125000407.GU22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB82433@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178CB82433@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@nvidia.com> [120126 11:03]:
> Tony Lindgren wrote at Tuesday, January 24, 2012 5:04 PM:
> 
> There's an entry for each of DTA and DTD in each of the two nodes because
> in this example, I want the value of parameter TEGRA_PMX_CONF_TRISTATE to
> be different in each of those two nodes.
> 
> If the value wasn't different, there'd be no need to specify the value
> of TEGRA_PMX_CONF_TRISTATE in each of the two nodes; you'd typically
> specify it just once in the common node.
> 
> So, the binding itself isn't forcing you to repeat anything, it's just
> in the example we actually want different values for this parameter in
> different status. You need /some/ way to specify that.
> 
> If we don't do that in the common pinctrl binding, I see a couple choices:
> 
> a) Put it in static data in the pinctrl driver.

Having data in the driver is fine as long as it's "how to operate certain
kind of features" type data for the driver. Then once you have hundreds of
instances of something, then the data for "where the instances are and what
type of instances they are" should be in device tree so the driver knows
how to use them.
 
> b) Put it in device tree in a binding that's specific to the individual
> pinctrl driver, rather than a common binding.
> 
> Now in each case, if you want the value of some parameter on some pin to
> be different in each of two states, you need /some/ way to represent that.
> Perhaps in (a) above, the literal 32-bit value "DTA" could be implicit,
> in that it's an array index into some table, but I don't see how to avoid
> specifying the two different values that are desired...

I don't think we should try to pass the different possible states from
device tree. The pinmux/pinconf driver should know how to deal with that,
and the driver using the mux should be able to communicate what it wants
to the pinmux/pinconf driver. If people really want to be able to pass
alternative mux states from device tree, they should be standard bindings
for things like active/idle/suspend/off.

Maybe you can just pass the hardware mux type from device tree? Something
like TEGRA_MUX_TYPE_SDHCI and then your pinmux/pinconf driver would know
how to deal with that set no matter where the instances are sprinkled on
new Tegras.

> > IMHO already that list of mux states seems limited as you may need to
> > list other driver states too like pmx_sdhci_standby_wake_up_disabled and
> > pmx_sdhci_standby_off. So it starts to sound a bit like PM policy instead
> > of letting the driver know what hardware is on the system.
> 
> First off, the binding isn't enforcing any specific set of named states,
> it's providing a mechanism to define a set of states with completely
> arbitrary names. As such (as I think I gave an example elsewhere in this
> thread), a dumb driver could require just one state e.g. "active", a
> simple driver could require two states e.g. "active", "standby", and a
> complex driver could require a whole bunch of different named states per
> its needs. All this is allowed by the common binding which is just
> providing a transport not policy. The pinctrl client drivers are what
> are defining the required state names, in their individual binding.

I'd rather prefer a combination of pinmux/pinconf initial register value,
mux type, and Linux generic flags from device tree rather than trying
to list register values for all possible states a device may have.

> Second, as I mentioned before, while some of the states are certainly
> PM-related, I don't think all will be, e.g. the case of running an SD
> controller at different clock rates to the SD card, and needing to
> set different pin parameters based on the clock rate. Is runtime PM
> intended cover that kind of thing? The idea here is that the common
> pinctrl binding can allow the driver to require different named states
> for those different clock rate cases.

For the PM related states, those should be Linux generic. For rate
setting sounds like that's really something you should set up as clocks
in the Tegra wrapper driver for SDHCI?

Ideally the SDHCI driver would be completely arch independent, and
then the SoC specific wrapper driver would know how to communicate to
the pinmux/pinconf framwork or clock framework what it needs using
Linux generic APIs. So I'd rather stay out of random named states for
the pins coming from device tree; If we still need them, they should
be common bindings rather than things like "xyz_clock_hack".

> > Having multiple config options also means that you end up setting
> > #pinconfig-cell to something unnecessarily large for all mux nodes even
> > if you only need the alternative values for one pin on the system.
> 
> I don't understand here.
> 
> In the example above, which I'll repeate:
> 
> config =
>     <TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
>     <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>;
> 
> #pinconfig-cells would be 3:
> cell 0 is pin/group ID
> cell 1 is configuration parameter
> cell 2 is value for that configuration parameter
> 
> The parsing of the config node involves splitting the whole cell list
> into chunks of #pinconfig-cells each, and interpreting each one in turn,
> in exactly the same way as #gpio-cells can be used to parse a DT property
> containing a list of GPIOs.

Ah sorry, I misread your example and thought you had more than three for
some entries. No problem there then.
 
> > > Given that each named state can reference n nodes defining part of that
> > > state's pinmux configuration, and some of those nodes can affect the same
> > > pin controller, you can easily split the overall configuration into
> > > "stuff that's common for all states for this device" and "stuff that's
> > > common between these n states of the device but not these m others" and
> > > "stuff that's unique to this 1 state", and hence avoid repeating any
> > > identical information.
> > >
> > > > I'm suspecting that the initial state can be used to set the PM states for
> > > > pins. Probably most pins can have the PM configuration set from the start.
> > >
> > > Can you please explain more?
> > 
> > For the cases I know the default values work for 95% - 100% of the pins in
> > the system for PM also. Only few pins on some systems need to be dynamically
> > remuxed during the runtime. The rest of the pins can be discarded after init.
> 
> So that's fine.
> 
> 95% the same means that the nodes you use to describe the differences are
> only 5% of the total; no repetition necessary in the DT nodes.

Sure, but why not handle it properly in the drivers? :)

BTW, for how many mux entries do you think you'll need these alternative
custom states?
 
> Now for the 95% of the programming that happens at device probe time:
> Perhaps we could throw away all the data representing that after it was
> performed.

Yes that's what we should do in general unless a pin or mux is marked
as dynamic in device tree.
 
> However, that's not related to the DT binding; it's an implementation
> detail of the pinctrl subsystem that it parses the pinmux mapping table
> early in boot and keeps it around in memory (e.g. to display in sysfs).
> I don't believe there's anything in the DT binding that forces the
> implementation to do that.
> 
> Similarly, if you don't need any (or very little) of the dynamic per-
> device stuff, you could probably just set up your base pinmux config
> as a huge array of (in pinctrl subsystem terms) "system hog" entries,
> or in terms of this DT binding, pin configuration nodes that are associated
> with the pin controller itself rather than individual devices, and just
> list the differences (if any) in the per-device nodes.

Yes it seems that that's what most people prefer.
 
> I need a bit more time to digest the rest of your email; the parts where
> I think you're saying:
> 
> a) For stuff like active/suspend, have the pinctrl driver know what
>    that means and implement it rather than explicitly representing
>    those states in device tree (but where do we represent them?)

Maybe you can represent different types of mux groups in your
pinmux/pinconf driver and just pass the type from device tree?
 
> b) For other states, do everything through runtime PM. I need to
>    familiarize myself with runtime PM in order to understand how that'd
>    work I guess.

That provides the trigger for platform specific state changes from the
driver.

Regards,

Tony
