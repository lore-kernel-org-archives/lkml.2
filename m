Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab2ARDUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 22:20:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61352 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab2ARDUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 22:20:53 -0500
Date: Wed, 18 Jan 2012 11:32:12 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: Pinmux bindings proposal
Message-ID: <20120118033209.GB563@S2101-09.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <20120114070858.GG1810@S2101-09.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17801D22C7@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17801D22C7@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 10:47:14AM -0800, Stephen Warren wrote:
> Shawn Guo wrote at Saturday, January 14, 2012 12:09 AM:
> > On Fri, Jan 13, 2012 at 12:39:42PM -0800, Stephen Warren wrote:
...
> > >                 /* 1:n example: */
> > >                 pinmux =
> > >                         <"default" &pmx_sdhci_mux_a>
> > >                         <"default" &pmx_sdhci_pincfg_a>
> > >                         <"suspend" &pmx_sdhci_mux_a>
> > >                         <"suspend" &pmx_sdhci_pincfg_a_suspend>;
> > 
> > I personally do not like the 1:n binding.  To me, any particular pinctrl
> > configuration, e.g. pmx_sdhci_active, should consist of a pair of pinmux
> > and pinconf, which should be given by the pmx_sdhci_active node.
> 
> Just a further explanation on my original code: I always intended that
> each entry in that list was a full pinmux configuration that could include
> mux and pin configuration settings. Thus, the above is more like:
> 
> pinctrl = 
>     <"default" &pmx_sdhci_a>
>     <"default" &pmx_sdhci_overrides>
> 
> (overrides rather than explicit separate mux/config; the separate mux
> And config were just an example use case).
> 
> My thoughts here:
> 
> With this binding, we can certainly define a lot of pre-defined/canned
> configurations to a set of pins. However, there are so many pin config
> options (at least on Tegra) for different aspects of drive strength, slew
> rate, ... that I sincerely doubt every single board is going to be able
> to use one of those pre-defined/canned *exactly* without changes. The ways
> to cope with these small board-specific differences are:
> 
> a) Cut/paste the entire pre-defined/canned configuration and tweak it
> as necessary. You can do this with the 1:1 model.
> 
> b) Use the pre-defined/canned as a base, then modify it to add extra
> configuration options, or change existing configuration options, as
> appropriate. I think the 1:n model works best for this. Given previous
> comments, I'd now propose the following syntax for a 1:n model:
> 
> 
>     pinctrl = <&pmx_sdhci_a>, <&pmx_sdhci_overrides>, <&pmx_sdhci_suspend>;
>     pinctrl-names = "default", "default", "suspend";
> 
> This should be easy to implement; instead of roughly:
> 
> prop = get_prop(np, "pinctrl-names");
> index = find_index(prop, "default");
> handle_pinctrl_prop(np, "pinctrl", index);
> 
> something more like:
> 
> prop = get_prop(np, "pinctrl-names");
> prev = NULL;
> while (find_index(prop, "default", &prev))
>     handle_pinctrl_prop(np, "pinctrl", index);
> 
Ok, I get it.  It seems a comprehensive design to me then.

> ...
> > >                 /*
> > >                  * The actual definition of the complete state of the
> > >                  * pinmux as required by some driver.
> > >                  *
> > >                  * These can be either directly in the device node, or
> > >                  * somewhere in tegra20.dtsi in order to provide pre-
> > >                  * selected/common configurations. Hence, they're referred
> > >                  * to by phandle above.
> > >                  */
> > >                 pmx_sdhci_active: {
> > >                         /*
> > >                          * Pin mux settings. Mandatory?
> > >                          * Not mandatory if the 1:1 mentioned above is
> > >                          * extended to 1:n.
> > >                          *
> > >                          * Format is <&pmx_controller_phandle muxable_entity_id
> > >                          * selected_function>.
> > >                          *
> > >                          * The pmx phandle is required since there may be more
> > >                          * than one pinmux controller in the system. Even if
> > >                          * this node is inside the pinmux controller itself, I
> > >                          * think it's simpler to just always have this field
> > >                          * present in the binding for consistency.
> > >                          *
> > 
> > I prefer to just put such nodes inside pinctrl controller itself and
> > drop those phandles.
> 
> My rationale here:
> 
> Forcing those nodes to be inside the controller node forces us to store
> any board-specific custom configurations or overrides in the controller
> node too; I'd simply prefer the flexibility to put them anywhere.
> 
Hmm, this type of flexibility does not make too much point to me.  On
the contrary, it's good to have a centralized place for these nodes,
so that they can be well organized and people can find them easily.

> Equally, I want SoC vendors to be able to choose whether to use these
> pre-defined/canned configuration nodes at all. If you do use them, putting
> them into the controller node makes perfect sense. If you don't use them,
> putting the pin configuration nodes into the individual device nodes (in
> the board.dts file) makes much more sense.
> 
Having 'pinctrl' phandle point to a configuration node which is in the
same device node looks odd to me.  I'd rather define these configuration
nodes in <board>.dts still under controller node.

> Having each property start with the phandle of the relevant controller
> is also far more consistent with the way all the GPIO, IRQ, ... bindings
> work.
> 
The GPIO and IRQ gets only one level phandle reference from device node
to the destination, while you are proposing two levels of phandle
reference for pinctrl.  Having 'pinctrl' phandle point to the
configuration node which sits under controller node seems well aligned
with GPIO and IRQ etc to me.

-- 
Regards,
Shawn
