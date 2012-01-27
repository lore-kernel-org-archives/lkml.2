Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab2A0Raq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:30:46 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5374 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab2A0Rap convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:30:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 27 Jan 2012 09:29:54 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Simon Glass <sjg@chromium.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>, Dong Aisheng <dongas86@gmail.com>,
        "Shawn Guo (shawn.guo@linaro.org)" <shawn.guo@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 27 Jan 2012 09:29:50 -0800
Subject: RE: Pinmux bindings proposal V2
Thread-Topic: Pinmux bindings proposal V2
Thread-Index: AczcUdyMpawuT1cYSYit8pJhMhaLFgAw3ZnA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178E123E54@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <CAPnjgZ3Xhebn1x1A-Vdy78DWbDd=cp0AK6tL-R1SRzS4GdF97g@mail.gmail.com>
In-Reply-To: <CAPnjgZ3Xhebn1x1A-Vdy78DWbDd=cp0AK6tL-R1SRzS4GdF97g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Glass wrote at Thursday, January 26, 2012 10:42 AM:
> On Fri, Jan 20, 2012 at 2:22 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Here's V2 of my pinmux binding proposal, after incorporating some feedback
> > from Shawn Guo and Dong Aisheng. Main changes:
> > [large quote elided; see https://lkml.org/lkml/2012/1/20/310 for content]

> I have been through this carefully and thought about how this might be
> implemented. Your example has really helped me to understand this
> properly, as the 70-email-long thread was a huge amount of reading.
> 
> So I have the following comments in general:
> 
> 1. It doesn't seem to make full use of the device tree format. For example,
> 
>    <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> 
> would be better as something like
> 
>     drive-strength = <5>;
> 
> if we could arrange it. It also reduces the need for these
> TEGRA_PMX_CONF_DRIVE_STRENGTH defines.

Yes I can see the argument this is more readable.

However, it:

* Requires a lot of string handling when parsing the device tree, since
  you have to search for lots of individual properties by name.

* Bloats the device tree quite a bit due to representing each parameter
  as a separate property, with a longish name, rather than a single u32
  cell in the config property I proposed.

* Makes the pinmux binding vary much more between different SoCs, since
  each SoC will have a different set of configuration parameters that
  can be applied to each pin/group, and hence will have a different set
  of property names and value formats.

  I'm assuming (and nobody has contradicted in this DT binding discussion
  or the pinctrl API discussion that I can recall) that the properties on
  all SoCs can be represented as a list of (parameter, value) pairs, with
  the SoC defining the list of legal parameters.

Still, the binding proposal does rely on named constants in dtc to be
really readable, and I have no idea if/when they will appear...

> 2. The TEGRA_PMX_ prefix on everything seems unnecessary to me and
> makes it harder to read and more long-winded. Other SOCs will not
> include the same header, I think. Can we just drop this?

I'd rather not due to namespace conflict reasons; it's the only way you
can guarantee that a system with a pinmux on both the primary SoC and
on some peripheral device won't both define the same named constatns;
exactly the same as a C header file.

> 3. To me, the pinctrl-entries following by pinctrl also does not make
> great use of the device tree. It seems to me that this:
> 
> pinctrl-entries = <2 2>;
> pinctrl = <&pmx_sdhci> <&pmx_sdhci_active>
>          <&pmx_sdhci> <&pmx_sdhci_standby>;
> 
> where you say:
> >                 * Here, state "active" covers 2 entries (0 and 1) in pinctrl,
> >                 * and state "suspend" covers 2 more entries (2 and 3) in
> >                 * pinctrl.
> 
> might be better as something like:
> 
> state-active {
>        mux =  <&pmx_sdhci> <&pmx_sdhci_active>;
> };
> 
> state-standby {
>        mux =  <&pmx_sdhci> <&pmx_sdhci_standby>;
> };
> 
> which means that we don't need to represent a 2-dimensional array in a
> single property, which seems error-prone and complicated. In general I
> wonder if we can make more use of hierarchy. This might help it be
> more extensible in future also.

Yes, that's simpler.

However, that then requires name-based access.

Other bindings that support named access also support access based on
integer IDs. So, in:

pinctrl-entries = <2 2>;
pinctrl = <&pmx_sdhci> <&pmx_sdhci_active>
          <&pmx_sdhci> <&pmx_sdhci_standby>;
pinctrl-names = "active" "standby";

You could either:

a) Search for name "active" in the pinctrl-names array, then used the
index where it was found to search by index.

b) Search directly by index in pinctrl-entries array. If only supporting
search-by-index, the pinctrl-names property could be elided.

With the alternative form you proposed, you could only search by index
if you forced a pinctrl-names to always exist, so you could map the index
to a name and then form the new property name to look for.

Perhaps it's reasonable to only allow search-by-name though. IIRC, this
wasn't acceptable for other bindings though.

Finally, rather than:

    state-active {
        mux =  <&pmx_sdhci> <&pmx_sdhci_active>;
    };

The following would be much simpler to parse:

    pinctrl-mux-active = <&pmx_sdhci> <&pmx_sdhci_active>;
    pinctrl-config-active = <&pmx_sdhci> <&pmx_sdhci_active>;

since there'd be one less node. It should be equally extensible to
adding new stuff (other than mux/config) to the binding if needed,
although admittedly if we really think that's likely (I don't since
the config parameters should be able to represent anything) we probably
should put all that stuff in a node as you say just to group stuff
together.

> 4. Your example for different 'states' is clear, but I'm not sure if
> you are intending to handling actual different pin assignments in
> these 'states'. To me this is the big point: does SDIO1 come out pin
> groups DTA and DTC; or does it come out pin groups SLXA-D. That's what
> the boards want to select. I think the state side of it may be best as
> a separate thing, which drivers may even just handle themselves if
> they are basic implementations. Or they may just want to implement the
> active state (U-Boot).

In the main, I think the multiple states are a runtime thing, so typically
would use the same set of pins.

> 5. My previous email suggested that the SOC define several possible
> options for each peripheral so that the board vendor can just select
> them from a menu. All the device tree complexity would then live in
> the SOC file (tegra20.dtsi in this case) and very little in the board
> file. I still think that is a worthwhile goal. You have this in there,
> but I feel it could be simplified further, to a single phandle
> perhaps.

For any single named state, you can already construct the definitions of
those named states to be fully within a single node and single phandle.

So you're asking for a single phandle to represent the entire set of
named states. That seems even more complex; introducing another level
of node nesting to define the set of states and still allow them to be
pieced together from common parts so as not to duplicate everything,
unless we don't care about that any more.

> 6. Looking ahead I imagine that the pinmux nodes will become large. I
> don't know how large but looking at some of the kernel bindings for TI
> I do get a little alarmed. Board vendors may wish to try to cut down
> the size of the device tree blob, particularly for use in the boot
> loader. With the binding in your email I think that would be hard to
> do. In particular if people know that standby is not being used in the
> boot loader, I think they would need to do things like change:
> 
> pinctrl-entries = <2 2>;
> pinctrl = <&pmx_sdhci> <&pmx_sdhci_active>
>          <&pmx_sdhci> <&pmx_sdhci_standby>;
> 
> to:
> 
> pinctrl-entries = <2>;
> pinctrl = <&pmx_sdhci> <&pmx_sdhci_active>;

I don't think that makes sense.

You can either:

a) Feed the same DT into both the bootloader and the kernel. There's
no duplication here, and the DT size is the superset of anything needed
by the bootloader and the kernel.

b) Create a cut-down subset of the DT to feed to the bootloader. In this
case, everything that's common is duplicated. At worst, you take 2x the
size to store both DTs. At best, you take 1.xx% where xx% is the common
part and obviously > 0. I don't see where the space saving is here.

...
> So, rather than just provide vague feedback, I though I would try to
> modify your binding according to the above, so it is below,

[large example elided; see https://lkml.org/lkml/2012/1/26/308]

That looks pretty nice and readable. The issues I see are:

* Bloat of DT due using strings to represent each configuration parameter
as a property name, putting each param in a different property, etc.

* There's no use of phandles within each state definition node, so
there's no way to piece together common partial pieces of a state. So,
if two nodes are 99% identical but simply have e.g. a slightly different
board-specific drive strength setting, you need to cut/paste the whole
thing rather than referencing the common portion from two places and
providing the differences. Note, I'm not talking about differences
between 2 named states, but between two boards' usage of SDIO1 routed
to DTA+DTD for example.

Perhaps there are ways to overcome those issues?

-- 
nvpublic

