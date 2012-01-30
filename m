Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2A3BoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 20:44:08 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47509 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab2A3BoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 20:44:06 -0500
Date: Mon, 30 Jan 2012 09:56:10 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Tony Lindgren <tony@atomide.com>
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
Message-ID: <20120130015607.GA10470@S2101-09.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <20120123210052.GS22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB81C0D@HQMAIL01.nvidia.com>
 <20120124012038.GT22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB81EDB@HQMAIL01.nvidia.com>
 <20120125000407.GU22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB82433@HQMAIL01.nvidia.com>
 <20120127020832.GJ29812@atomide.com>
 <20120127065752.GB32740@S2101-09.ap.freescale.net>
 <20120127170545.GH13504@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127170545.GH13504@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 09:05:45AM -0800, Tony Lindgren wrote:
> Hi,
> 
> * Shawn Guo <shawn.guo@linaro.org> [120126 22:15]:
> > On Thu, Jan 26, 2012 at 06:08:33PM -0800, Tony Lindgren wrote:
> > > * Stephen Warren <swarren@nvidia.com> [120126 11:03]:
> > ...
> > > > Second, as I mentioned before, while some of the states are certainly
> > > > PM-related, I don't think all will be, e.g. the case of running an SD
> > > > controller at different clock rates to the SD card, and needing to
> > > > set different pin parameters based on the clock rate. Is runtime PM
> > > > intended cover that kind of thing? The idea here is that the common
> > > > pinctrl binding can allow the driver to require different named states
> > > > for those different clock rate cases.
> > > 
> > > For the PM related states, those should be Linux generic. For rate
> > > setting sounds like that's really something you should set up as clocks
> > > in the Tegra wrapper driver for SDHCI?
> > > 
> > That's right.
> > 
> > > Ideally the SDHCI driver would be completely arch independent, and
> > > then the SoC specific wrapper driver would know how to communicate to
> > > the pinmux/pinconf framwork or clock framework what it needs using
> > > Linux generic APIs.
> > 
> > But that wrapper driver should not be bothered to call pinmux/pinconf
> > APIs on pin basis to change the pinctrl configuration.  The elegant
> > way would be something like the following in case that it switches
> > the bus frequency from 50 MHz to 100 MHz.
> > 
> > 	pmx = pinmux_get(dev, "esdhc_50mhz");
> > 	...
> > 	pinmux_put(pmx);
> > 	pmx = pinmux_get(dev, "esdhc_100mhz");
> > 	...
> > 
> > The specific mux and config settings of states esdhc_50mhz and
> > esdhc_100mhz would be retrieved from device tree.
> 
> Yes whatever mux names can be used, same as with clock framework
> for clock names. But that means you'll have to constantly get/put
> the mux which is not efficient.
> 
The most important reason that we want to move to pinctrl subsystem
is we need its run-time configuration feature for cases like esdhc
here.  I do not think the switch here is so constant to be inefficient.

> Wouldn't it be cleaner to just clk_get esdhc_clk during init, then
> do clk_set_rate on it to toggle the rates?
>  
It's not an init-time switch but run-time one.  That said,
sdhci_ops.set_clock will be called during run-time.

> > > So I'd rather stay out of random named states for
> > > the pins coming from device tree; If we still need them, they should
> > > be common bindings rather than things like "xyz_clock_hack".
> > > 
> > The binding defines the syntax, and I do not see the necessity to
> > force the particular state name, which is really pinctrl client
> > device specific.
> 
> Do you have some other custom pin state example other than the
> clock rate change example above?
> 
I have another case PM related.  To aggressively save power, the pins
configured for particular function during active mode need to be
muxed on gpio mode and output 0 in low-power mode.

-- 
Regards,
Shawn
