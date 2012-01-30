Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab2A3RUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:20:54 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:52076 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab2A3RUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:20:52 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ObBejAvX/maemyv+NnJt4
Date: Mon, 30 Jan 2012 09:20:42 -0800
From: Tony Lindgren <tony@atomide.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Dong Aisheng <dongas86@gmail.com>,
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
Message-ID: <20120130172042.GE9339@atomide.com>
References: <20120123210052.GS22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB81C0D@HQMAIL01.nvidia.com>
 <20120124012038.GT22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB81EDB@HQMAIL01.nvidia.com>
 <20120125000407.GU22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB82433@HQMAIL01.nvidia.com>
 <20120127020832.GJ29812@atomide.com>
 <20120127065752.GB32740@S2101-09.ap.freescale.net>
 <20120127170545.GH13504@atomide.com>
 <20120130015607.GA10470@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130015607.GA10470@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Shawn Guo <shawn.guo@linaro.org> [120129 17:13]:
> On Fri, Jan 27, 2012 at 09:05:45AM -0800, Tony Lindgren wrote:
> > Hi,
> > 
> > * Shawn Guo <shawn.guo@linaro.org> [120126 22:15]:
> > > On Thu, Jan 26, 2012 at 06:08:33PM -0800, Tony Lindgren wrote:
> > > > * Stephen Warren <swarren@nvidia.com> [120126 11:03]:
> > > ...
> > > > > Second, as I mentioned before, while some of the states are certainly
> > > > > PM-related, I don't think all will be, e.g. the case of running an SD
> > > > > controller at different clock rates to the SD card, and needing to
> > > > > set different pin parameters based on the clock rate. Is runtime PM
> > > > > intended cover that kind of thing? The idea here is that the common
> > > > > pinctrl binding can allow the driver to require different named states
> > > > > for those different clock rate cases.
> > > > 
> > > > For the PM related states, those should be Linux generic. For rate
> > > > setting sounds like that's really something you should set up as clocks
> > > > in the Tegra wrapper driver for SDHCI?
> > > > 
> > > That's right.
> > > 
> > > > Ideally the SDHCI driver would be completely arch independent, and
> > > > then the SoC specific wrapper driver would know how to communicate to
> > > > the pinmux/pinconf framwork or clock framework what it needs using
> > > > Linux generic APIs.
> > > 
> > > But that wrapper driver should not be bothered to call pinmux/pinconf
> > > APIs on pin basis to change the pinctrl configuration.  The elegant
> > > way would be something like the following in case that it switches
> > > the bus frequency from 50 MHz to 100 MHz.
> > > 
> > > 	pmx = pinmux_get(dev, "esdhc_50mhz");
> > > 	...
> > > 	pinmux_put(pmx);
> > > 	pmx = pinmux_get(dev, "esdhc_100mhz");
> > > 	...
> > > 
> > > The specific mux and config settings of states esdhc_50mhz and
> > > esdhc_100mhz would be retrieved from device tree.
> > 
> > Yes whatever mux names can be used, same as with clock framework
> > for clock names. But that means you'll have to constantly get/put
> > the mux which is not efficient.
> > 
> The most important reason that we want to move to pinctrl subsystem
> is we need its run-time configuration feature for cases like esdhc
> here.  I do not think the switch here is so constant to be inefficient.
> 
> > Wouldn't it be cleaner to just clk_get esdhc_clk during init, then
> > do clk_set_rate on it to toggle the rates?
> >  
> It's not an init-time switch but run-time one.  That said,
> sdhci_ops.set_clock will be called during run-time.

Right, basically you don't want to do clk_get or pinmux_get during
runtime, you do that once one during init. Then do clk_set_rate or
whaterver during runtime.

Is there anything stopping from implementing sdhci_ops.set_rate
using clock framework and clk_set_rate in this case BTW?
 
> > > > So I'd rather stay out of random named states for
> > > > the pins coming from device tree; If we still need them, they should
> > > > be common bindings rather than things like "xyz_clock_hack".
> > > > 
> > > The binding defines the syntax, and I do not see the necessity to
> > > force the particular state name, which is really pinctrl client
> > > device specific.
> > 
> > Do you have some other custom pin state example other than the
> > clock rate change example above?
> > 
> I have another case PM related.  To aggressively save power, the pins
> configured for particular function during active mode need to be
> muxed on gpio mode and output 0 in low-power mode.

OK, but basically only a small subset of pins of the total pins?

Regards,

Tony
