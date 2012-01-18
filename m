Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab2ARTBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:01:06 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11863 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077Ab2ARTBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:01:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 18 Jan 2012 11:00:40 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
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
Date: Wed, 18 Jan 2012 11:00:38 -0800
Subject: RE: Pinmux bindings proposal
Thread-Topic: Pinmux bindings proposal
Thread-Index: AczVkDA3are6Z070SoiRMZQwksHd8wAghpbQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1780DAAE7C@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <20120114070858.GG1810@S2101-09.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17801D22C7@HQMAIL01.nvidia.com>
 <20120118033209.GB563@S2101-09.ap.freescale.net>
In-Reply-To: <20120118033209.GB563@S2101-09.ap.freescale.net>
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

Shawn Guo wrote at Tuesday, January 17, 2012 8:32 PM:
> On Tue, Jan 17, 2012 at 10:47:14AM -0800, Stephen Warren wrote:
> > Shawn Guo wrote at Saturday, January 14, 2012 12:09 AM:
> > > On Fri, Jan 13, 2012 at 12:39:42PM -0800, Stephen Warren wrote:
...
> > > >                 /*
> > > >                  * The actual definition of the complete state of the
> > > >                  * pinmux as required by some driver.
> > > >                  *
> > > >                  * These can be either directly in the device node, or
> > > >                  * somewhere in tegra20.dtsi in order to provide pre-
> > > >                  * selected/common configurations. Hence, they're referred
> > > >                  * to by phandle above.
> > > >                  */
> > > >                 pmx_sdhci_active: {
> > > >                         /*
> > > >                          * Pin mux settings. Mandatory?
> > > >                          * Not mandatory if the 1:1 mentioned above is
> > > >                          * extended to 1:n.
> > > >                          *
> > > >                          * Format is <&pmx_controller_phandle muxable_entity_id
> > > >                          * selected_function>.
> > > >                          *
> > > >                          * The pmx phandle is required since there may be more
> > > >                          * than one pinmux controller in the system. Even if
> > > >                          * this node is inside the pinmux controller itself, I
> > > >                          * think it's simpler to just always have this field
> > > >                          * present in the binding for consistency.
> > > >                          *
> > >
> > > I prefer to just put such nodes inside pinctrl controller itself and
> > > drop those phandles.
> >
> > My rationale here:
> >
> > Forcing those nodes to be inside the controller node forces us to store
> > any board-specific custom configurations or overrides in the controller
> > node too; I'd simply prefer the flexibility to put them anywhere.
>
> Hmm, this type of flexibility does not make too much point to me.  On
> the contrary, it's good to have a centralized place for these nodes,
> so that they can be well organized and people can find them easily.

I still would really rather have the flexibility to just put the nodes
anywhere.

However, I don't think we lose any functionality by forcing the nodes
to be inside the pin controller's node. And as you say, we do get to
remove the phandle from the mux and config properties then too, which
very marginally simplifies parsing.

One other concern I had was a device that needed to configure the pin
mux on two different pin controllers (think the main SoC and some complex
chip attached to one of the SoC's external busses). Ideally, there'd be
a Linux device for each end of the bus, and each would configure the
respective chip's pinmux. However, I can certainly foresee cases where
there's only a Linux device for the main SoC, and it'd need to configure
both chips' pinmux. Still, I think we can deal with that easily enough,
since that device's pinctrl property can simply use the 1:n feature, and
have multiple entries pointing at both chip's pinctrl device:

foo@c8000200 {
   ...
   pinctrl = <&pinmux_soc_xxx> <&pinmux_otherchip_xxx>
             <&pinmux_soc_xxx_suspend> <&pinmux_otherchip_xxx_suspend>;
   pinctrl-entries = <2 2>;
   pinctrl-names = "active", "suspend";
};

So, I can live with requiring the pin configuration nodes to be underneath
the relevant pin controller's node, and removing the phandle from the
mux and config properties in the pin configuration nodes.

-- 
nvpublic

