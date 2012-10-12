Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab2JLPDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:03:53 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:21345 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751666Ab2JLPDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:03:50 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+FPM6+nDxue8MbZDEYEHbM
Date: Fri, 12 Oct 2012 08:03:43 -0700
From: Tony Lindgren <tony@atomide.com>
To: kishon <kishon@ti.com>
Cc: Rajendra Nayak <rnayak@ti.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, linux@arm.linux.org.uk,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Moiz Sonasath <m-sonasath@ti.com>
Subject: Re: [PATCH 1/4] usb: phy: add a new driver for usb3 phy
Message-ID: <20121012150342.GA30339@atomide.com>
References: <1348054229-27362-1-git-send-email-kishon@ti.com>
 <1348054229-27362-2-git-send-email-kishon@ti.com>
 <20121011005944.GX12552@atomide.com>
 <5077DE0A.4000301@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5077DE0A.4000301@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* kishon <kishon@ti.com> [121012 02:10]:
> Hi Tony,
> 
> On Thursday 11 October 2012 06:29 AM, Tony Lindgren wrote:
> >Hi,
> >
> >* Kishon Vijay Abraham I <kishon@ti.com> [120919 04:32]:
> >>Added a driver for usb3 phy that handles the interaction between usb phy
> >>device and dwc3 controller.
> >>
> >>This also includes device tree support for usb3 phy driver and
> >>the documentation with device tree binding information is updated.
> >>
> >>Currently writing to control module register is taken care in this
> >>driver which will be removed once the control module driver is in place.
> >
> >You may be able to set up the control module register with one
> >of the following Linux standard frameworks:
> >
> >1. Fixed regulator defined in mach-omap2/control.c
> 
> Is it control.c?

Hmm after looking into it more we're missing one piece of the puzzle
to handle SCM regulators, which is omap-scm-regulator.c :)
I'll do a minimal DT only version of that.

> >    In this case the PHY driver can pick up the regulator by name.
> 
> Do you mean we have to define something like fixed_voltage_config
> defined in board-4430sdp.c?
> From whatever I could make out from regulator/fixed.c,
> enabling/disabling of regulator is done using only gpio. I'm not
> sure how we can use that to write to control module register.

Yes you're right, we're missing omap-scm-regulator.c, then it will
be trivial to select the regulator from DT like we have for the
twl-regulator.c.

> >>+usb3phy@4a084400 {
> >>+	compatible = "ti,omap-usb3";
> >>+	reg = <0x0x4a084400 0x80>,
> >>+	      <0x4a084800 0x64>,
> >>+	      <0x4a084c00 0x40>,
> >>+	      <0x4a002370 0x4>;
> >>+};
> >
> >And register 0x4a002370 here. Care to post some info what the
> >0x4a002370 register bits do? Is that same as CONTROL_DEV_CONF
> >on omap4, or does it have other bits there too?
> 
> It's CONTROL_PHY_POWER_USB register and it's structure looks like this.
> 31:22 USB_PWRCTL_CLK_FREQ
> 21:14 USB_PWRCTL_CLK_CMD
> 13:0 RESERVED
> 
> CLK_CMD takes values to power up/down the TX and RX in various combinations.
> 
> And CLK_FREQ takes values for clock configuration.

Oh, it's a clock. Then it would be best to set it up using the
common clock framework and have the clock registered by the
SCM core driver when those are available.

Maybe please just add a comment for that for later on?

Regards,

Tony
