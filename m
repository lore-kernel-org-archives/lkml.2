Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab2ASK5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 05:57:41 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:58197 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab2ASK5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 05:57:40 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX188NhA+9iiKpSZEdn+rrjwD
Date: Thu, 19 Jan 2012 02:57:28 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
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
Message-ID: <20120119105728.GE22818@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <20120116182808.GG4223@ponder.secretlab.ca>
 <20120118141329.GA22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1780DAAEBB@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1780DAAEBB@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@nvidia.com> [120118 11:29]:
> Tony Lindgren wrote at Wednesday, January 18, 2012 7:13 AM:
> 
> I'd prefer not to do that for my platforms, for the reason Shawn points
> out in his reply to yours.
> 
> However, I believe the bindings I proposed are flexible enough to allow
> you to do exactly this for your platforms without requiring that everyone
> do it.

Well I can easily use one phandle per pinmux controller instance
instead of one phandle per pin, so let's plan on doing that.
 
> Recall my proposal was:

Yes I think that's pretty close to what I'm using, just few
minor comments below.
 
> pmx_sdhci_standby: pinctrl@0 {
>     /* Format is <&pmx_controller_phandle muxable_entity_id
>      * selected_function>.
>      */
>     mux =
>         <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
>         <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>;

Assuming this is describing the pins a driver is using, how
about calling it pins?

That's because you might want to do all the muxing in a
bootloader, but still need to tell how many pins you're using
for MMC on a device. So it actually has a wider meaning than just
mux.

Also, we need to standardize on some name to use for parsing pins
using of_parse_phandle_with_args, and I suggested #pin-args.

>     config =
>         <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
>         <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>
>         <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
>         <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
>         <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
>         <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
> };

Here I don't quite understand how config is different from pins/mux
above? It seems to set the driver/pull stuff, but why don't you
just make #pin-args larger and have a wider pin array?

Something like:

	pins =
	<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1 TEGRA_PMX_CONF_TRISTATE 1
	 &tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1 TEGRA_PMX_CONF_TRISTATE 1>;

and in the parent set #pin-args to 3.
 
> (Note that I think we've agreed to remove the first cell above, &tegra_pmx,
> now by requiring such nodes exist as children of the pin controller.)

Sorry I don't quite follow, can you please maybe repost a complete
.dts entry for your pin controller and one driver entry?
 
> My assertion is that the common pinmux bindings define that the
> Interpretation of muxable_entity_id is left up to the binding of the
> specific pin controller. Hence, I can says "it's an integer, and here
> is the list of valid values and what they mean", and you can say "it's
> a phandle, which must refer to one of the per-pin nodes defined by the
> pin controller".
> 
> Does that work for you?

Yes it does, other than the comments above.

Regards,

Tony
