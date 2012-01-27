Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2A0SKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:10:19 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:32100 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2A0SKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:10:17 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/CiN2DvoBj4pBtkdmITtYM
Date: Fri, 27 Jan 2012 10:10:04 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Simon Glass <sjg@chromium.org>, Dong Aisheng-B29396 <B29396@freescale.com>,
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
Message-ID: <20120127181004.GA9339@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <CAPnjgZ3Xhebn1x1A-Vdy78DWbDd=cp0AK6tL-R1SRzS4GdF97g@mail.gmail.com>
 <20120127022111.GK29812@atomide.com>
 <CAPnjgZ2EkvTMsOkWyf4pfwRpvcvYs=WaKy5Gi8fdkAUQmvt=ig@mail.gmail.com>
 <20120127173732.GJ13504@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178E123E62@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178E123E62@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@nvidia.com> [120127 09:21]:
> Tony Lindgren wrote at Friday, January 27, 2012 10:38 AM:
> ...
> > So how about let's do separate static and dynamic bindings,
> > something like this:
> > 
> > 	/*
> > 	 * Static init time only mux where
> > 	 * we only specify phandle to driver
> > 	 * and, offset of the mux, and the value.
> > 	 * These pins are discarded after init.
> > 	 *
> > 	 * Format:	  mux_ctrl      offset value
> > 	 */
> > 	pinctrl-static = <&pmx_driver1  0x0020 0x1245
> > 			   &pmx_driver2 0x0022 0x6578>;
> 
> So those are direct register writes? That sounds pretty scary, and a
> royal pain to author the device tree.

Driver specific, either registers or enumeration. It could also
it could be also generic defines, something along the lines of
PMX_MUX_FUNCTION_1 | PMX_MUX_GPIO_INPUT.
 
> If we do go with this, I think we'd need a mask for each register write
> too, so you can leave certain bits unaffected; there's no reason to
> believe in general that each pin has a dedicated register only for that
> pin, or even that only pinmux/config data is in the register.

I'm currently using "pinmux-simple,function-mask", but yeah sounds like
it should be a generic mask name.
 
> This also makes it difficult to extract semantic information from the
> DT. How can the pinctrl subsystem know which pins are in use and which
> aren't here? This is relevant if some module loads later and attempts
> to claim some pins - are they already in use by another driver or not?

We could just have one spinlock for all the discarded pins instead of
having a single spinlock for each discarded pin?
 
> Now individual pinctrl drivers could interpret those register values
> and know that this means pin/group "x" is programmed to mux value "y",
> but does that mean pin "x" is actually /used/, or just that the init
> table had to program value "y" because the default for that pin is "z"
> which conflicted in HW with some other mux setting that the board
> needed (e.g. muxing signal "y" to some other pin).
> 
> (Put another way, this binding completely bypasses the pinctrl subsystem;
> is that OK?)

Well I was thinking we should still register the pins, and have pinctrl
fwk set those values, then discard those pins but still keep them as
locked.
 
> > 	/*
> > 	 * Dynamic mux where the mux is kept around after
> > 	 * init and multiple states can be defined for
> > 	 * a mux as a subnode of the pinmux controller.
> > 	 *
> > 	 * Format:	   mux_phandle   initial state
> > 	 */
> > 	pinctrl-dynamic = <&pmx_sdhci    PMX_STATE_ENABLED
> > 			   &pmx_ehci_xcv PMX_STATE_ENABLED>;
> > 
> > This would make pinctrl-static binding follow the same
> > standard as GPIO binding and can be parsed easily with
> > of_parse_phandle_with_args.
> > 
> > Then for pinctrl-dynamic we can make a custom parser,
> > and the binding can follow the more readable format as
> > Simon posted.
> 
> I don't think there's any point in having 2 separate bindings; it's been
> hard enough to come up with /one/ binding! If we do go for raw register
> writes for the static stuff, we should just do the same for the dynamic
> stuff too.

But then we need to waste a register for the static/dynamic flag for
each mux.. Or make the tree deeper.
 
> In fact, given this would all bypass the pinctrl subsystem entirely,
> perhaps lets not even define a standard format for pinctrl-static or
> pinctrl-dynamic, and just have each pin controller driver parse tables
> inside its own node, in a format specific to that pin controller's
> binding. I already had that working for the static case back in last
> August and would love to just apply those patches and be done with this.

Hmm I don't think it would by pass it, we just need to let pinctrl
fwk deal with the init time only pins too.

For the dynamic pins, note that PMX_STATE_* defines would be one of the
standard states supported by the pinctrl fwk. Then of course where
pmx_sdhci binding is implemented, you could have either hardware specific
register values, enumeration or generic defines depending on how the
pinctrl driver is implemented.

Regards,

Tony 

