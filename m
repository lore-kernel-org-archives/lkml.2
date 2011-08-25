Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1HYLFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 07:05:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50672 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab1HYLFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 07:05:00 -0400
Date: Thu, 25 Aug 2011 13:04:51 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        ext Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 1/4 v4] drivers: create a pin control subsystem
Message-ID: <20110825110451.GU31404@pengutronix.de>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
 <74CDBE0F657A3D45AFBB94109FB122FF04B24A3BC0@HQMAIL01.nvidia.com>
 <CACRpkdaZfG4hiGf8vug3EGMRMc0c92xbj=L_HAQcS27DAXYc4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaZfG4hiGf8vug3EGMRMc0c92xbj=L_HAQcS27DAXYc4Q@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:32:47 up 64 days, 16:20, 45 users,  load average: 2.11, 1.85,
 2.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 12:12:59PM +0200, Linus Walleij wrote:
> On Wed, Aug 24, 2011 at 8:29 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Linus Walleij wrote at Friday, August 19, 2011 3:54 AM:
> >>
> >> This creates a subsystem for handling of pin control devices.
> >> These are devices that control different aspects of package
> >> pins.
> >
> > Sorry to keep harping on about this, but I'm still not convinced the data
> > model is correct.
> 
> Don't feel sorry! I'm getting very much done and much important
> research and thinking is happening thanks to you valuable feedback.
> Keep doing this!
> 
> What I notice is that the review comments have changed focus
> from the earlier contention point about having multiple functions
> per map entry to something else, which to me seems like it
> comes from device tree work, and is about describing how each
> and every pin is wired to its function. Does this correspond to
> your recent pinmux experience?
> 
> > Here are the two possible models:
> >
> > Model 1 (as implemented in the pin control subsystem):
> >
> > * Each pinmux chip defines a number of functions.
> > * Each function describes what functionality is mux'd onto the pins.
> > * Each function describes which pins are affected by the function.
> 
> This is correct.
> 
> > Result:
> >
> > If there are a couple of controllers that can each be mux'd out two
> > places, you get four functions:
> >
> > Function i2c0-0: Controller i2c0 is mux'd onto pins 0 and 1
> > Function i2c0-1: Controller i2c0 is mux'd onto pins 2 and 3
> > Function spi0-0: Controller spi0 is mux'd onto pins 0 and 1
> > Function spi0-1: Controller spi0 is mux'd onto pins 4 and 5
> 
> Yes, if and only if the pinmux driver find it useful to expose
> these two ports on the two sets of pins each.
> 
> For example: there really *is* a bus soldered to pin {0,1}
> and another bus soldered to pin {2,3}, and each has devices
> on it. But I have only one single i2c controller i2c0.
> 
> If pins {2,3} were not soldered or used for something else
> it doesn't make sense for the pin controller to expose
> two functions like this.
> 
> So this is dependent on platform/board data. We need
> to know how the chip has been deployed in this very
> machine to know what functions to expose.
> 
> > Model 2 (what I'd like to see)
> >
> > * Each pinmux chip defines a number of functions.
> > * Each function describes the functionality that can be mux'd out.
> > * Each pinmux chip defines a number of pins.
> > * Each pinmux chip defines which functions are legal on which pins.
> >
> > Result:
> >
> > With the same controllers and pins above, you get:
> >
> > Function i2c0
> > Function spi0
> > Pins 0, 1, 2, 3, 4, 5
> > Pins 0, 1 accept functions i2c0, spi0
> > Pins 2, 3 accept functions i2c0
> > Pins 4, 5 accept functions spi0
> >
> > We'd still have a single controller-wide namespace for functions, it's
> > just that functions are something you mux onto pins, not the combination
> > of mux'd functionality and the pins it's been mux'd onto.
> 
> I think I understand this. Maybe.
> 
> I read it like this:
> Legend:
>   1..* = one to many
>   1..1 = one to one
> 
> - Pins has a 1..* relation to functions
> - Functions in general have a 1..* relation to pins,
> - Device drivers in general have a 1..* relation to
>   functions
> - Functions with 1..1 relation to pins and device drives
>   with a 1..1 relation to functions is not the norm
> 
> So this is radically different in that it requires the pin control
> system to assume basically that any one pin can be used for
> any one function.
> 
> I refer to this as a phone-exchange model, like any one pin
> can map to any one function, like any phone can call any
> other phone.
> 
> The current model is not based on that assumption at
> all. The current model is derived from some available
> pinmux controllers and described below.
> 
> > * I believe this model is much more directly maps to the way most HW
> > works; there's a register for each pin where you write a value to select
> > which functionality to mux onto that pin. Assuming that's true, using
> > this data model might lead to simpler pinmux chip implementations; they'd
> > require fewer mapping tables.
> 
> I understand this statement as you assume al pinmuxes
> are phone-exachange-type, where any pin can be tied to
> any function at runtime. So for example the CLK pin of spi0
> can be muxed onto any pin basically, not a predetermined
> set of pins.
> 
> I think that data model does not take into account the fact
> that all or most pinmuxes are inherently restricted and not at
> all that open-ended. That model would impose a
> phone-exchange type of data model on hardware that is
> much more limited.
> 
> So the data model I'm assuming is:
> 
> - Pins has a 1..* relation to functions
> - Functions in general have a 1..1 relation to pins,
> - Device drivers in general have a 1..1 relation to
>   functions
> - Functions with 1..* relation to pins is uncommon
>   as is 1..* realtions between device drivers and
>   functions.
> 
> The latter is the crucial point where I think we have
> different assumptions.
> 
> If it holds, it leads to the fact that a pinmux driver
> will present a few functions for say i2s0 usually only
> one, maybe two, three, never hundreds.
> 
> 
> Survey of some systems
> 
> So this is where we have to determine what is really the
> way such hardware at large works. I have done some
> research in data sheets and code:
> 
> What I have found is that the typical layout is that:
> 
> - Each pin has a number of mux control bits in some
>   register, often 2 or 3 bits.
> 
> - These bits select a mux setting out of 2 to 8 possible
>   settings.
> 
> - It is very uncommon to be able to map the
>   same function to some other pin - so often say
>   UART0 CTS can only come out on one pin, not
>   five different pins, let alone any pin
> 
> - The need to present a lot of different combinations
>   of one function on different pins to the subsystem
>   through the selectors is very limited.
> 
> mach-u300:
> ----------------
> 
> Configurability: each function can be mapped to one pin
> (pad) only - for example SPI is found on pads { 420 .. 425 }
> it can only be enabled on these pins. It's not possible to
> move the SPI to say pins { 100 ... 105 }, what you can do
> is turn the pins into GPIO:s instead. However you cannot
> map any arbitrary GPIO line to each one of them, but a
> *certain* GPIO line. So this muxing is pretty static.
> 
> Further the functions are selected groupwise, so you
> select all 6 pins to be used for GPIO or something else,
> you cannot select things on each pin individually at all.
> For example pins {166 ... 171, 176, 177} can be used for
> MMC *or* memory stick, *or* GPIOs. You cannot
> request to have your MMC on some other pins and
> you absolutely can never use MMC and memory stick
> at the same time, because they can only use these
> pins.
> 
> So there is a mux, and it is not like a phone
> exchange that can route anything anywhere, it's
> a few functions per pin.
> 
> mach-ux500:
> -----------------
> 
> Each muxable pin has a default function, which is GPIO,
> then it also can provide one of three "alternate functions"
> called A, B, C. Our map looks like this for pin 0:
> 
> #define GPIO0_GPIO              PIN_CFG(0, GPIO)
> #define GPIO0_U0_CTSn           PIN_CFG(0, ALT_A)
> #define GPIO0_TRIG_OUT          PIN_CFG(0, ALT_B)
> #define GPIO0_IP_TDO            PIN_CFG(0, ALT_C)
> 
> So pin 0 can be used for GPIO, the UART0 CTS signal,
> trigger output or TDO, whatever that is.
> 
> You cannot move the UART0 CTS singnal to some
> other pin, this is fixed muxing per pin, just like in the
> U300. If you want to use UART0 you *have* to use
> pin 0 for it's CTS signal, nothing else is possible.
> 
> If you want to use the other functions, you loose
> UART0.
> 
> However the Ux500 is not muxed in groups, so each
> pins function can be selected individually. Which
> makes it possible to configure a few useless
> combinations, like vital pins replaced by GPIO and
> whatever.
> 
> plat-omap:
> --------------
> 
> I have checked the TRMs for OMAP 3 & 4 but the pinmux
> stuff seems to sit in the system controller
> (at OMAP*_CTRL_BASE) which in turn does not appear
> to be documented in the public data sheet.
> (Help me if you have a reference...)
> 
> Looking at say arch/arm/mach-omap2/mux2420.c you see
> entries like this:
> 
>         _OMAP2420_MUXENTRY(CAM_D0, 54,
>                 "cam_d0", "hw_dbg2", "sti_dout", "gpio_54",
>                 NULL, NULL, "etk_d2", NULL),
> 
> As you can see pin 54 (which does not seem to mean
> anything else than that this is the pin that can be used for
> GPIO channel 54) can theoretically be used for up to 8
> different functions, in this case only 5 of them are
> actually valid. The selected function is apparently
> controlled by 3 bits per pin somewhere.
> 
> It's not like you can move "sti_dout" to some other pin
> than 54. This is a restriction of the electronics.
> 
> So OMAPs mux impose identical restrictions on pins
> as the ux500 mux - a pin can not hold *any* function, just
> a few select functions. It is not a phone-exchange type.
> 
> mach-msm:
> ----------------
> 
> Hard to tell how this works and what's available, support
> seems to be incomplete. Currently it seems to be wired
> to do either a dedicated function (like some UART pin)
> or GPIO, like each pin can be used for two specific
> things, and not phone-exchange type.
> 
> plat-mxc/mach-mx5:
> ----------------------------
> 
> Quite hard o make out, but checking the mux maps in
> arch/arm/plat-mxc/include/mach/iomux-*.h I get the
> impression that also these muxes are of the same type
> as the above for example:
> 
> /*                                                        PAD    MUX
> ALT INPSE PATH PADCTRL */
> #define _MX51_PAD_EIM_D16__AUD4_RXFS            IOMUX_PAD(0x3f0, 0x5c,
> 5, 0x0000, 0, 0)
> #define _MX51_PAD_EIM_D16__AUD5_TXD             IOMUX_PAD(0x3f0, 0x5c,
> 7, 0x08d8, 0, 0)
> #define _MX51_PAD_EIM_D16__EIM_D16              IOMUX_PAD(0x3f0, 0x5c,
> 0, 0x0000, 0, 0)
> #define _MX51_PAD_EIM_D16__GPIO2_0              IOMUX_PAD(0x3f0, 0x5c,
> 1, 0x0000, 0, 0)
> #define _MX51_PAD_EIM_D16__I2C1_SDA             IOMUX_PAD(0x3f0, 0x5c,
> 0x14, 0x09b4, 0, 0)
> #define _MX51_PAD_EIM_D16__UART2_CTS            IOMUX_PAD(0x3f0, 0x5c,
> 3, 0x0000, 0, 0)
> #define _MX51_PAD_EIM_D16__USBH2_DATA0          IOMUX_PAD(0x3f0, 0x5c,
> 2, 0x0000, 0, 0)
> 
> Pad 16 seems to be able to mux in AUD4 RXFS, AUD5 TXD,
> EIM, GPIO2 controller line 0, I2C1_SDA, UART2 CTS and
> USBH2 DATA0.
> 
> Thus these functions are restricted to this one pin. It's not
> like I could all of a sudden have GPIO2 line 0 on pad 45
> instead. Or UART2 CTS on pad 96. Or similar. If I want to
> use UART2, it's CTS signal must go out on pad 16.

Not really. UART2_CTS can't be routed to arbitrary pads, but it can be
routed to more than one pad:

#define _MX51_PAD_EIM_D16__UART2_CTS		IOMUX_PAD(0x3f0, 0x5c, 3, 0x0000, 0, 0)
#define _MX51_PAD_EIM_D25__UART2_CTS		IOMUX_PAD(0x414, 0x80, 4, 0x0000, 0, 0)
#define _MX51_PAD_USBH1_DATA0__UART2_CTS	IOMUX_PAD(0x688, 0x288, 1, 0x0000, 0, 0)

The naming in the iomux files is always <pad_name>__<function>

This is why there can't be a setup_iomux(uart2) function without
being able to specify *which* pads in a board specific way.

Also the same gpio can sometime be routed to different pads:

#define _MX51_PAD_NANDF_ALE__GPIO3_5            IOMUX_PAD(0x4ec, 0x110, 3, 0x0988, 0, 0)
#define _MX51_PAD_DISPB2_SER_DIN__GPIO3_5       IOMUX_PAD(0x6bc, 0x2bc, 4, 0x0988, 1, 0)

This is why there can't be any setup_iomux_for_this_gpio() function
without being able to specify which pad should be used, again in
a board specific way.

This is more or less the same that OMAP and PXA have.

> 
> > * Given that's the way Tegra HW works at least, the patches I recently
> > posted to initialize the Tegra pinmux from device-tree define bindings
> > that use this model. I think it's important that such bindings use the
> > same data model as the pinmux chip data model. This keeps consistency
> > between boot-time initialization and the pinmux chip portion of any
> > run-time pinmux modifications.
> 
> Isn't it better if that data model is kept as a Tegra thing as I
> guess it is right now?
> 
> Atleast until we find if this model really suits other machines...
> 
> My concern is that it may force all pin control drivers to conform to
> something pretty complex that is only useful for Tegra. And in that
> case that part of it (the 1..* relation between functions and pins)
> should reside in the tegra pinmux driver, not across the entire
> subsystem.
> 
> The intention of the pinmux part of the pin control subsystem is to
> model the subset of what is common functionality across all pin
> controllers, not the superset of everything that is possible to do
> with every pin controller, atleast not if it makes the API hard to use
> for others. So let's figure out if this is the case.
> 
> So that way in summary:
> 
> - Pin has a 1..* relation to functions - ALL SYSTEMS
> - Functions in general have a 1..1 relation to pins, the function
>   can only come out on one pin

on one pin at a time only, yes, but functions can be routed to many pins.

> - Functions with 1..* relation to pins is uncommon, Tegra is
>   the only chip that has this.

+ i.MX and OMAP

> - Device drivers in general have a 1..1 relation to functions,
>   1..* is uncommon

Don't exactly know what you mean here.

> 
> I don't know if this makes anything clearer, I feel I'm writing
> too much text :-/

;)

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
