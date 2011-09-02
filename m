Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1IBQeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 12:34:13 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10145 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1IBQeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 12:34:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 02 Sep 2011 09:33:58 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>, Barry Song <21cnbao@gmail.com>
Date: Fri, 2 Sep 2011 09:33:56 -0700
Subject: RE: [PATCH 1/4 v6] drivers: create a pin control subsystem v6
Thread-Topic: [PATCH 1/4 v6] drivers: create a pin control subsystem v6
Thread-Index: AcxpcCbu6RFXK9tGSPe4Byj4dEhCzgAG10Sg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B327A58F@HQMAIL01.nvidia.com>
References: <1314869536-5495-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B327A3FD@HQMAIL01.nvidia.com>
 <CACRpkdYBaWq3BuXNvMtgaS1nMzU-vArRB9_y5WE3Zqp9idaOuA@mail.gmail.com>
In-Reply-To: <CACRpkdYBaWq3BuXNvMtgaS1nMzU-vArRB9_y5WE3Zqp9idaOuA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Friday, September 02, 2011 6:59 AM:
> > I would imagine treating GPIOs as just another function. I'll repeat
> > some text I wrote previously (https://lkml.org/lkml/2011/8/26/298) about
> > how I see this working:
> >
> >>SW For reference, here's how I'd imagine modeling those three cases in
> >>SW pinmux (all based on my earlier comments about the data model I imagine,
> >>SW rather than what's currently in the pinmux patches):
> >
> >>SW 1) Have a single function "gpio" that can be applied to any pin that
> >>SW supports it. The actual GPIO number that gets mux'd onto the pin differs
> >>SW per pin, and is determine by HW design. But logically, we're connecting
> >>SW that pin to function "gpio", so we only need one function name for that.
> >
> > So here, the only issue is that if "GPIO" can be assigned per pin, we'd
> > need to define a pingroup per pin, even if we had a set of other groups
> > for muxing. (And a pin would have to be in its per-pin pingroup, and
> > mux group, which goes back to my very first comment above.) I suppose this
> > might end up being a lot of pingroups. However, this is all data, and
> > it seems like having large data is better than having large code? Still,
> > these per-pin groups might end up existing for other functionality like
> > biasing anyway, depending on HW.
> 
> Hm I have a hard time figuring out how that code would look...
> I'm worried that the drivers could get pretty hard to read.

For a simple chip that allowed everything to be configured at a pin level
rather than pingroup level:

Functions:
spi
i2c
gpio

pins:
A1
A2
A3
A4

Groups, with pin list and legal functions:
A1: A1: gpio spi
A2: A2: gpio spi
A3: A3: gpio i2c
A4: A4: gpio i2c

For a chip that allowed muxing to be configured at a group level, but
GPIOs to be configured at a pin level:

Functions:
spi
i2c
gpio

pins:
A1
A2
A3
A4

Groups, with legal functions:
A1: A1: gpio
A2: A2: gpio
A3: A3: gpio
A4: A4: gpio
GROUPA: A1, A2: spi
GROUPB: A3, A4: i2c

...
> Right now I have resorted to the diplomatic solution of actually
> supporting both.
> 
> pinmux_request_gpio() will request a gpio pin named
> "gpioN" where N is the global GPIO number.
> 
> This fragment from pinmux.c sort of specifies it:
> 
>         if (gpio && ops->gpio_request_enable)
>                 /* This requests and enables a single GPIO pin */
>                 status = ops->gpio_request_enable(pctldev, gpio_range, pin);
>         else if (ops->request)
>                 status = ops->request(pctldev, pin);
>         else
>                 status = 0;
> 
> So if the driver doesn't implement the quick ->gpio_request_enable()
> the second else-clause will attempt to get the function "gpioN".
> 
> So if the driver just wants to present a single function per pin instead,
> it can readily do so, but it must still specify which GPIO ranges it
> supports.

Ah, OK.

The only issue I see with that is that is there end up being a whole ton
of functions named "gpio0", "gpio1", ..., "gpio125" etc. Do those functions
have to be listed in the table of functions exported by the driver, or does
the core expect to pass these "created" function names to the driver without
their previously existing?

Whereas if you do a function-per-gpio-controller, or function-per-gpio-
that- can-be-configured-on-the-pin, you limit the number of function
names that are required.

> >> diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
> >
> >> +/**
> >> + * struct pinmux_ops - pinmux operations, to be implemented by pin controller
> >> + * drivers that support pinmuxing
> >> + * @request: called by the core to see if a certain pin can be made available
> >> + *   available for muxing. This is called by the core to acquire the pins
> >> + *   before selecting any actual mux setting across a function. The driver
> >> + *   is allowed to answer "no" by returning a negative error code
> >> + * @free: the reverse function of the request() callback, frees a pin after
> >> + *   being requested
> >
> > Shouldn't request/free be for a pingroup, not a pin, since that's what
> > functions are assigned to? Also, the function should be passed, since
> > some restrictions these functions might need to check for might depend
> > on what the pin/group will be used for.
> 
> This is not for checking anything on function or group level.
> It's exclusively for things that need to be on a per-pin level, so any
> pin can deny being selected for muxing at any time.
> 
> So what you're saying is that you need a function to check
> also on group level as part of the pinmux_get() sematics?
> 
> We can add that and have two optional checks: @request_pin()
> on pin level and say @request_function_and_group() on the
> group+function level, would that work for your scenarios?

Well, that's a move in the right direction, but not quite everything I'd
like.

The basic issue is that a single logical function (I2C controller 0) can
be mux'd out onto more than one pingroup. However, the HW requires that
at /any given time/ it only be mux'd out onto a single pingroup.

To fully enforce this, the request() function needs to know what the
complete state will be after the entire (set of) mapping entries is
processed.

When the core can only process 1 mapping entry at a time, this is trivial,
since there's only 1 change relative to current HW to process in request().

However, when the core can process n mapping entries for a single client
request, you end up with:

* Initial HW state is programmed

* request() called once for the first mapping entry. This can only validate
that this one request is valid against current HW state; it can't validate
this call's new setting against any settings passed to future request() calls.

* Similarly, the second request() call can only validate that one change
against HW; it can't validate this call against the change requested in
an earlier call, or against any later calls.

The only way I can see this being implementable is:

a) Add request_start() and request_end() functions, so the driver can
copy HW state to SW state in request_start(), and modify this cached
state in each request() call, and hence has access to all state changes
to-date in each request() call. Then, request_end() to finalize the
whole set of changes.

Or:

b) request() passes an array of changes at once, instead of many calls
each requesting a single .change

This is certainly a tough problem. The current Tegra pinmux driver doesn't
actually make any attempt to enforce this, so perhaps it's not worth
worrying about; we just assume people write sensible mapping tables.

> > When the core is modified to support applying n entries in the mapping
> > table for each pinmux_get() call, how will request/free be aware of the
> > partial pending state?
> 
> That is like answering how code I haven't yet written will
> look like... The easiest answer is to implement it I think,
> then you can check if it looks sane.

:-)

-- 
nvpublic

