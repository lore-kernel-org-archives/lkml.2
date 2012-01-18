Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab2AROuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:50:01 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:43664 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820Ab2AROuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:50:00 -0500
X-Greylist: delayed 2179 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jan 2012 09:49:59 EST
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+NkmiNQTjbDMkeUFZA/Vw2
Date: Wed, 18 Jan 2012 06:13:29 -0800
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>,
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
Message-ID: <20120118141329.GA22818@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <20120116182808.GG4223@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116182808.GG4223@ponder.secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Grant Likely <grant.likely@secretlab.ca> [120116 09:55]:
> On Fri, Jan 13, 2012 at 12:39:42PM -0800, Stephen Warren wrote:
> >                 pinmux =
> >                         <"default" &pmx_sdhci_active>
> >                         <"suspend" &pmx_sdhci_suspend>;
> > 
> >                 /* 1:n example: */
> >                 pinmux =
> >                         <"default" &pmx_sdhci_mux_a>
> >                         <"default" &pmx_sdhci_pincfg_a>
> >                         <"suspend" &pmx_sdhci_mux_a>
> >                         <"suspend" &pmx_sdhci_pincfg_a_suspend>;
> 
> 
> Yeah, don't do this.  Mixing phandle, string and cell values in a
> property gets messy and could become troublesome to parse.  I've
> backed away from it in the clk binding.

Yup, that's because the string is embedded directly into the mixed
mode array and will likely make the following data unaligned. That
means it's extremely flakey to parse, and will lead into horrible
errors if you have typos in the .dts file.. Tried that and gave up
on it.

I think I've found a way to avoid using names at all, assuming we set
each pin as a phandle for the drivers to use :) 

If some drivers need to use pin names, they should be optional
optional for the cases where the phandle is not available.

Here's what I'm currently using:

        pinnmux@4a100000 {
                compatible = "pinmux-simple";
                reg = <0x4a100000 0x01d4>;
                #address-cells = <1>;
                #size-cells = <0>;
                #pinmux-cells = <2>;

                /* uart3_rx_irrx dmtimer8_pwm_evt na gpio_143 na na na safe_mode */
                uart3_rx_irrx: mux-uart3_rx_irrx@4a100144 {
                        reg = <0x4a100144>;
                        gpios = <&gpio1 1 0>;
                        #pin-args = <1>;
                };

                /* uart3_tx_irtx dmtimer9_pwm_evt na gpio_144 na na na safe_mode */
                uart3_tx_irtx: mux-uart3_tx_irtx@4a100146 {
                        reg = <0x4a100146>;
                        gpios = <&gpio1 2 0>;
                        #pin-args = <1>;
                };
                ...
        };

        serial@48020000 {
                compatible = "ti,8250";
                reg = <0x48020000 0x100>;
                reg-shift = <2>;
                interrupts = <106>;
                pins = <&uart3_rx_irrx 0x10
                        &uart3_tx_irtx 0x0>;
        };

Here I have just one value for each pin register but note that the
#pin-args allows specifying the number or configuration options
depending on the hardware like of_gpio.c does using
of_parse_phandle_with_args().

The various functions for each pin controller register are only
in the comments, so currently the function needs to be provided as
a value. A preprosessor should solve that issue at some point.

This should work for anything that has one register per pin.I'd
assume the pin groups can be described here too for the hardware
that one register per pin group only just by specifying group-pins
array there?

Cheers, 

Tony
