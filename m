Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab2ASSUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 13:20:38 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:13195 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab2ASSUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 13:20:36 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1962ndSRQpZteew7F6AbI3V
Date: Thu, 19 Jan 2012 10:20:19 -0800
From: Tony Lindgren <tony@atomide.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
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
Message-ID: <20120119182019.GI22818@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <CAJuYYwQoh4_SnA9wmy4x+cG0w0hGukxTkODWtcSw_2QHYuDsrg@mail.gmail.com>
 <20120119165607.GG22818@atomide.com>
 <CAJuYYwQB1pDu-JS5o3XPA1D8WbVcwbdtD43M4y7PeJNWeNXxQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuYYwQB1pDu-JS5o3XPA1D8WbVcwbdtD43M4y7PeJNWeNXxQQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Abraham <thomas.abraham@linaro.org> [120119 09:05]:
> 
> On 19 January 2012 22:26, Tony Lindgren <tony@atomide.com> wrote:
> > * Thomas Abraham <thomas.abraham@linaro.org> [120119 04:37]:
> >>
> >> i2c0: i2c@18000000 {
> >>         [... other properties ...]
> >>         pinctrl-active = <&pctrl0 5 0 2 3 0>,
> >>                              <&pctrl0 5 1 2 3 0>;
> >>         pinctrl-suspend = <&pctrl0 5 0 2 0 0>,
> >>                                 <&pctrl0 5 1 2 0 0>;
> >> };
> >
> > Maybe we should have just the active/suspend/off flags in the
> > same array? Otherwise we'll end up unnecessarily repeating the
> > the pin information. See the pins + #pin-args example I posted,
> > which is otherwise similar.
> 
> Yes, I agree. That would be better.

OK great.
 
> >
> >> In the example above, the specifier of pinctrl-* is specific for
> >> Samsung io-pad controllers. Its format/syntax would be mainly
> >> dependent on the io-pad controller used, the above is only an example
> >> for Samsung io-pad controller. In the above node, the format of the
> >> pinctrl-* specifier is
> >>
> >> property-name = <phandle of the pin-controller
> >>                            pin bank within the pin-controller
> >>                            pin number within the pin-bank
> >>                            pin-mux function number
> >>                            pull up/down config
> >>                            drive strength config>;
> >
> > Are these all just bits in one register? If so, let's say you
> > have 16-bits per pin, we might be able to share the generic
> > pinmux-simple.c driver I have almost ready..
> 
> no, these get written to different registers, one for pinmux, one for
> pull up/down and one for drive strength. It would be helpful of your
> pinmux-simple.c can support writes to multiple registers also.
 
Hmm yeah that should be doable, and actually we have the old legacy
omap1510 set up with three different registers per pin..

The question is: Do we want to add the on/idle/off modes for each
pin in .dts, or do we want to have the driver set the dynamic muxing
flags separately?

> > The format would then be
> >
> >        #pin-args <4>;
> >        ...
> >
> >        /*    controller  offset on   idle off */
> >        pins = <&pinctrl0 0x0030 0x15 0x15 0x7>;
> >
> >> * Using the pinmux/pinconfig specifier in device nodes to configure hardware.
> >>
> >> A driver (for a device instantiated from device tree) would require
> >> code to be made aware of the pinmux/pinconfig options available. The
> >> typical sequence in a probe function would be as below.
> >>
> >> (a) call of_get_named_gpio() to get the gpio number. In case of
> >> Samsung pinctrl driver, the pinctrl driver itself provides the gpiolib
> >> functionality and it attaches a gpio specifier translator with the
> >> gpio_chip. This translator is capable of translating the pinctrl-* and
> >> returning a gpio number.
> >>
> >> (b) gpio_request() the gpio number obtained in step (a) above.
> >>
> >> (c) Repeat steps (a) and (b) until all the gpios required by the
> >> driver are requested. In case a request fails, give up all the
> >> successfully requested gpio and return failure.
> >
> > Can't the driver do this to request the gpio pins that you
> > can get from DT and pinmux? Even if you need to do dynamic pinmuxing
> > to GPIO pins for wake-up events, you can do that from the driver
> > as long as you get the GPIO number for the pin from mux code.
> 
> Yes, it is the driver that finds out the gpio number from dt and
> requests it. Maybe, I did not understand your point here.

Oh ok, sorry I misunderstood thinking you want to do all that in the
pinmux driver..
 
> With the approach that I mentioned in the previous email, there are no
> pinmux, pin groups or pin desc tables built from dt. Each device node
> specifies what needs to configured (pinmux,pinconfig) and the code
> using that device node uses pinctrl driver to get those
> pinmux/pinconfig values written to the hardware registers.
> 
> Does the dt support for pinmux/pinconfig that you are developing build
> the pinmux, pin groups or pin desc tables? Do drivers have to call
> pinmux_{get/put}() or pin_config_set() functions even in dt case?

Yeah the pinmux/pingroups and functions are built from the DT. Drivers
would have to still call pinmux_get and set right now. But some of this
could probably be automatically done using runtime PM?

Cheers,

Tony
