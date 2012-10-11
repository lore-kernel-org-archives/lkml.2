Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab2JKA75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:59:57 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:33037 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757442Ab2JKA7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:59:53 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+k608Ue0zXrsfpJVqYQdIl
Date: Wed, 10 Oct 2012 17:59:44 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Moiz Sonasath <m-sonasath@ti.com>
Subject: Re: [PATCH 1/4] usb: phy: add a new driver for usb3 phy
Message-ID: <20121011005944.GX12552@atomide.com>
References: <1348054229-27362-1-git-send-email-kishon@ti.com>
 <1348054229-27362-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348054229-27362-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Kishon Vijay Abraham I <kishon@ti.com> [120919 04:32]:
> Added a driver for usb3 phy that handles the interaction between usb phy
> device and dwc3 controller.
> 
> This also includes device tree support for usb3 phy driver and
> the documentation with device tree binding information is updated.
> 
> Currently writing to control module register is taken care in this
> driver which will be removed once the control module driver is in place.

You may be able to set up the control module register with one
of the following Linux standard frameworks:

1. Fixed regulator defined in mach-omap2/control.c

   In this case the PHY driver can pick up the regulator by name.

2. A mux mapped with pinctrl framework using pinctrl-single,bits
   binding

   And in this case the PHY driver can request the named pinctrl
   states like "enabled" and "disabled".

> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
> @@ -15,3 +15,21 @@ usb2phy@4a0ad080 {
>  	reg = <0x4a0ad080 0x58>,
>  	      <0x4a002300 0x4>;
>  };

The comments also apply to the omap_usb2.c driver for
0x4a002300 above.

> +
> +OMAP USB3 PHY
> +
> +Required properties:
> + - compatible: Should be "ti,omap-usb3"
> + - reg : Address and length of the register set for the device. Also
> +add the address of control module phy power register until a driver for
> +control module is added
> +
> +This is usually a subnode of ocp2scp to which it is connected.
> +
> +usb3phy@4a084400 {
> +	compatible = "ti,omap-usb3";
> +	reg = <0x0x4a084400 0x80>,
> +	      <0x4a084800 0x64>,
> +	      <0x4a084c00 0x40>,
> +	      <0x4a002370 0x4>;
> +};

And register 0x4a002370 here. Care to post some info what the
0x4a002370 register bits do? Is that same as CONTROL_DEV_CONF
on omap4, or does it have other bits there too?

The advantage for using regulator fwk and pinctrl fwk is
that the regulator and mux can be children of the SCM
core driver when we have it. And no direct register tinkering
or omap specific custom exported functions are needed ;)

Regards,

Tony
