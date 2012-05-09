Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235Ab2EIVIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 17:08:17 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:32520 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761128Ab2EIVIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 17:08:15 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX196Is6aBP91nsCEdMqq5vlF
Date: Wed, 9 May 2012 14:08:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that
 supports omap2+ padconf
Message-ID: <20120509210811.GX5088@atomide.com>
References: <20120502172401.GG3739@atomide.com>
 <4FA42CBF.8010906@wwwdotorg.org>
 <20120504215758.GV5613@atomide.com>
 <4FAAD08D.1050806@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAAD08D.1050806@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [120509 13:19]:
> On 05/04/2012 03:57 PM, Tony Lindgren wrote:
> > * Stephen Warren <swarren@wwwdotorg.org> [120504 12:27]:
> >> On 05/02/2012 11:24 AM, Tony Lindgren wrote:
> >>
> >>> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-simple.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-simple.txt
> ...
> >> On the other hand, I worry about whether using "pinctrl-simple" here as
> >> the compatible value is going to cause issues:
> >>
> >> Certainly, this is a pretty simple driver, and most likely reasonably
> >> generic an applicable to many SoCs. However, it doesn't cover a bunch of
> >> cases that I'd still consider "simple". For example, what if each pin
> >> has a separate mux and pinconf register? There are probably many such
> >> small cases that would add up to something more complex. to cover those
> >> cases, will we be able to extend pinctrl-simple to cover them, and
> >> continue to be backwards compatible, or will we need to create a
> >> binding/driver for pinctrl-simple-1, pinctrl-simple-2, pinctrl-simple-3
> >> each of which covers some different, yet still simple, configuration?
> > 
> > Yes getting the binding right is the critical part here, everything else
> > can be added as needed. I was thinking about using separate properties
> > for auxilary registers, but now thinking about it a bit more, it may not
> > be sufficient.
> > 
> > How about we make some of these properties into arrays? For example:
> > 
> > #pinctrl-cells = 6;
> > pinctrl-simple,function-mask = <0x0000ffff 0x0000ffff 0xffff0000>;
> > pinctrl-simple,function-off = <0x7 0x7 0x70000>;
> > pinctrl-simple,pinconf-mask = <0xffff0000 0xffff0000 0x0000ffff>;
> 
> I'm not sure what the 3 entries in the array are meant to describe?

If you have let's say three registers per pin, those would be the
related function and pinconf masks for those registers.
 
> > Because we need to specify GPIO for some pins. There may be additional flags
> 
> What do you mean by "specify GPIO"?
> 
> Nothing in this pinctrl-simple binding seems to imply that it's also a
> GPIO controller.

It is not a GPIO controller, but eventually needs to deal with existing
GPIO controllers.
 
> If "GPIO" is one of the functions that can be mux'd onto a pin, then I'd
> expect that to be represented in exactly the same way as any other
> function that could be mux'd onto the pin.

Right. But additionally we also need to know the mux register to GPIO
mapping for things like irq_set_irq_wake()/enable_irq_wake()/disable_irq_wake()
that may be set dynamically depending on what the user wants.
 
> So, I'm not sure what GPIO-related information you want to represent.

It seems that we should be able to do pinctrl_request_gpio that uses
an external GPIO controller and also sets up the desired wake-up flags
as needed. Anyways, not needed yet.

> > too, we do have external DMA request lines for few pins available.. I'm not
> > saying pinctrl fwk should know about that, but it's a similar mapping of pins
> > to GPIO lines.
> 
> Aren't DMA request lines also just another function that can be mux'd
> onto a pin?

Yes it's a function for routing the signal. But that also needs to be
configured in the DMA controller. Right now there's no need to have
that mapping in the binding.

Regards,

Tony
