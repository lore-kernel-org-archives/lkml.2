Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab2ARUCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 15:02:44 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1585 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2ARUCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 15:02:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Jan 2012 12:02:22 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>
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
Date: Wed, 18 Jan 2012 12:02:21 -0800
Subject: RE: Pinmux bindings proposal
Thread-Topic: Pinmux bindings proposal
Thread-Index: AczV61+kVUMS8HFST9GQ3+39uoWV9gAL5Fzw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1780DAAEBB@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <20120116182808.GG4223@ponder.secretlab.ca>
 <20120118141329.GA22818@atomide.com>
In-Reply-To: <20120118141329.GA22818@atomide.com>
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

Tony Lindgren wrote at Wednesday, January 18, 2012 7:13 AM:
> * Grant Likely <grant.likely@secretlab.ca> [120116 09:55]:
> > On Fri, Jan 13, 2012 at 12:39:42PM -0800, Stephen Warren wrote:
> > >                 pinmux =
> > >                         <"default" &pmx_sdhci_active>
> > >                         <"suspend" &pmx_sdhci_suspend>;
> > >
> > >                 /* 1:n example: */
> > >                 pinmux =
> > >                         <"default" &pmx_sdhci_mux_a>
> > >                         <"default" &pmx_sdhci_pincfg_a>
> > >                         <"suspend" &pmx_sdhci_mux_a>
> > >                         <"suspend" &pmx_sdhci_pincfg_a_suspend>;
> >
> >
> > Yeah, don't do this.  Mixing phandle, string and cell values in a
> > property gets messy and could become troublesome to parse.  I've
> > backed away from it in the clk binding.
> 
> Yup, that's because the string is embedded directly into the mixed
> mode array and will likely make the following data unaligned. That
> means it's extremely flakey to parse, and will lead into horrible
> errors if you have typos in the .dts file.. Tried that and gave up
> on it.
> 
> I think I've found a way to avoid using names at all, assuming we set
> each pin as a phandle for the drivers to use :)

I'd prefer not to do that for my platforms, for the reason Shawn points
out in his reply to yours.

However, I believe the bindings I proposed are flexible enough to allow
you to do exactly this for your platforms without requiring that everyone
do it.

Recall my proposal was:

pmx_sdhci_standby: pinctrl@0 {
    /* Format is <&pmx_controller_phandle muxable_entity_id
     * selected_function>.
     */
    mux =
        <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
        <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>;
    config =
        <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
        <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>
        <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
        <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
        <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
        <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
};

(Note that I think we've agreed to remove the first cell above, &tegra_pmx,
now by requiring such nodes exist as children of the pin controller.)

My assertion is that the common pinmux bindings define that the
Interpretation of muxable_entity_id is left up to the binding of the
specific pin controller. Hence, I can says "it's an integer, and here
is the list of valid values and what they mean", and you can say "it's
a phandle, which must refer to one of the per-pin nodes defined by the
pin controller".

Does that work for you?

-- 
nvpublic

