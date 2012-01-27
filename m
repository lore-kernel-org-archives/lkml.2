Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab2A0Rhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:37:47 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:40138 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2A0Rhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:37:45 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+yKMwbYHGL1ug7JLLamsSy
Date: Fri, 27 Jan 2012 09:37:32 -0800
From: Tony Lindgren <tony@atomide.com>
To: Simon Glass <sjg@chromium.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>, Dong Aisheng <dongas86@gmail.com>,
        "Shawn Guo (shawn.guo@linaro.org)" <shawn.guo@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Pinmux bindings proposal V2
Message-ID: <20120127173732.GJ13504@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <CAPnjgZ3Xhebn1x1A-Vdy78DWbDd=cp0AK6tL-R1SRzS4GdF97g@mail.gmail.com>
 <20120127022111.GK29812@atomide.com>
 <CAPnjgZ2EkvTMsOkWyf4pfwRpvcvYs=WaKy5Gi8fdkAUQmvt=ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPnjgZ2EkvTMsOkWyf4pfwRpvcvYs=WaKy5Gi8fdkAUQmvt=ig@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Simon Glass <sjg@chromium.org> [120127 07:12]:
> 
> On Thu, Jan 26, 2012 at 6:21 PM, Tony Lindgren <tony@atomide.com> wrote:
> >
> > Maybe we need two bindings: A minimal subset of what Stephen is suggesting
> > that can handle 95% of the muxes with minimal overhead, then what you're
> > suggesting for the few muxes that need multiple states?
> 
> Perhaps that would work, it certainly deals nicely with making the
> rare cases less ugly if indeed they are rare. Of course a single
> binding that is not too ugly and still reasonably efficient would be
> best.
> 
> I will have a think about this a bit more and see if anything leaps
> out. It's quite an interesting problem...

Just to try to recap what has come up so far:

1. We need to avoid bloating things for basic cases to initialize
   several hundred pins.

2. Some muxes need to define multiple states.

3. We need to pass a flag for each mux to know whether or
   not it can be freed after init.

So how about let's do separate static and dynamic bindings,
something like this:

	/*
	 * Static init time only mux where
	 * we only specify phandle to driver
	 * and, offset of the mux, and the value.
	 * These pins are discarded after init.
	 *
	 * Format:	  mux_ctrl      offset value
	 */
	pinctrl-static = <&pmx_driver1  0x0020 0x1245
			   &pmx_driver2 0x0022 0x6578>;

	/*
	 * Dynamic mux where the mux is kept around after
	 * init and multiple states can be defined for
	 * a mux as a subnode of the pinmux controller.
	 *
	 * Format:	   mux_phandle   initial state
	 */ 
	pinctrl-dynamic = <&pmx_sdhci    PMX_STATE_ENABLED
			   &pmx_ehci_xcv PMX_STATE_ENABLED>;

This would make pinctrl-static binding follow the same
standard as GPIO binding and can be parsed easily with
of_parse_phandle_with_args.

Then for pinctrl-dynamic we can make a custom parser,
and the binding can follow the more readable format as
Simon posted.

Regards,

Tony
