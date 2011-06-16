Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab1FPTM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:12:58 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7905 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab1FPTM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:12:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 16 Jun 2011 12:12:38 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 16 Jun 2011 12:12:36 -0700
Subject: RE: More pinmux feedback, and GPIO vs. pinmux interaction
Thread-Topic: More pinmux feedback, and GPIO vs. pinmux interaction
Thread-Index: AcwsNxACK05SEhO4QTq/VjjbnMfmVgAHIg6Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04992C07E5@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF04992C067D@HQMAIL01.nvidia.com>
 <BANLkTi==jWGxbiW4QZ7SSfAdyShhEgvMig@mail.gmail.com>
In-Reply-To: <BANLkTi==jWGxbiW4QZ7SSfAdyShhEgvMig@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Thursday, June 16, 2011 9:07 AM:
> On Wed, Jun 15, 2011 at 11:48 PM, Stephen Warren <swarren@nvidia.com> wrote:
>
> > Some more thoughts on pinmux:
>
> Thanks!
>
> Keep it coming until you get tired of me :-)
>
> > ========== GPIO/pinmux API interactions
> >
> > I'd like to understand how the gpio and pinmux subsystems are intended
> > to interact.
>
> Mainly I'd like Grant to comment on that a bit. It refers to the (long)
> reply I wrote in response to his feeback on these issues with some
> open questions in it.
>
> >  Note that requesting a GPIO does NOT cause it to be configured in any
> >  way; it just marks that GPIO as in use.  Separate code must handle any
> >  pin setup (e.g. controlling which pin the GPIO uses, pullup/pulldown).
> >
> > Due to this, the current Tegra GPIO driver contains additional non-
> > standard functions:
> >
> > void tegra_gpio_enable(int gpio);
> > void tegra_gpio_disable(int gpio);
> >
> > In some cases, those functions are called by board files at boot time,
> > and in other cases by drivers themselves, right before gpio_request().
> >
> > Is it your intention that such custom functions be replaced by
> > pinmux_request_gpio(), and the Tegra pinmux driver's gpio_request_enable
> > op should call tegra_gpio_enable?
> >
> > That seems like the right idea to me.
>
> Yes and no. As you saw in the last iteration I renamed the pinmux
> framework "pinctrl" or "pin control". So being such a hopeless optimist
> I set out to solve all pin controlling in this subsystem. The sales rap
> would be something like:
>
> - Do you need to bias your pin to 3.3 V with an 1MOhm resistor?
> - Do you want to mux your pin with differetn functions?
> - Do you want to set the load capacitance of you pin to 10pF?
> - Do you want to drive your pin as open collector?
> - Is all or some the above software-controlled in your ASIC?
> - Do you despair from the absence of relevant frameworks?
>
> DON'T WORRY!
> The pinctrl subsystem is here to save YOU!
>
> However that's a bit of vaporware, since I just implemented the
> pin numberspace and pin registration (that is the generic part)
> and then the pinmux part. The rest (assorted pin control) is
> yet to come.

Just one note on the extra stuff for the future:

* Tegra has say 100 muxable pins.
* GPIO vs. special function is selectable per pin.
* Muxing of which special function (and some other features, such as
pullup/down) is only at a granularity of "group of pins".
* Some other pin features (such as slew rate, drive strength) is also
only at a granularity of "group of pins" **but** the groups are defined
differently for these features than for muxing.

I figure the general model is:

* N pins, each perhaps with some per-pin controls.
* M groups of pins, each allowing muxing, and possibly other controls
and also an arbitrary number of:
* P groups of pins, allowing various other controls

> > ========== pinmux calling GPIO or vice-versa?
> >
> > Having pinmux call gpio appears to conflict with a couple of things from
> > your recent pinmux patchset:
> >
> >> diff --git a/drivers/Kconfig b/drivers/Kconfig
> >> +# pinctrl before gpio - gpio drivers may need it
> >> +
> >> +source "drivers/pinctrl/Kconfig"
> >> +
> >>  source "drivers/gpio/Kconfig"
> >>
> >> diff --git a/drivers/Makefile b/drivers/Makefile
> >>...
> >> +# GPIO must come after pinctrl as gpios may need to mux pins etc
> >> +obj-y                                += pinctrl/
> >
> > Don't those patches imply that the GPIO controller code is calling into
> > the pinmux code to perform muxing, not the other way around?
>
> Yes.
>
> Grant does not seem to like the idea of the gpio subsystem
> meddeling with all this stuff anyway, so I intend to take all that
> into pinctrl, and then gpio only deal with, well GPIO. Setting
> bits quickly and such.
>
> That is, irrespective of the fact that these functions may live
> in the same register range, this is a divide between functionality
> not hardware blocks.
>
> > ========== When pins get marked as in-used
> >
> > There seems to be a discrepancy in the way the client APIs work: For
> > special functions, the client calls pinmux_get, then later pinmux_enable,
> > whereas for GPIOs, the client just calls pinmux_request_gpio. I'm not
> > sure of the benefit of having separate pinmux_get and pinmux_enable
> > calls; I thought the idea was that a client could:
> >
> > a = pinmux_get(dev, "funca");
> > b = pinmux_get(dev, "funcb");
> > pinmux_enable(a);
> > ...
> > pinmux_disable(a);
> > pinmux_enable(b);
> > ...
> > pinmux_disable(b);
> > pinmux_put(b);
> > pinmux_put(a);
> >
> > However, since the pins are marked as reserved/in-use when pinmux_get
> > is called rather than pinmux_enable, the code above won't work;
>
> If the two functions share the same pins so they are mutually exclusive,
> then yes.
>
> > it'd need to be:
> >
> > a = pinmux_get(dev, "funca");
> > pinmux_enable(a);
> > ...
> > pinmux_disable(a);
> > pinmux_put(a);
> > b = pinmux_get(dev, "funcb");
> > pinmux_enable(b);
> > ...
> > pinmux_disable(b);
> > pinmux_put(b);
> >
> > Perhaps pin usage marking should be moved into enable/disable?
>
> Actually no - my idea is that enable/disable shall be fast while
> get/put will be allowed to take time. (fastpath vs slowpath if
> you like).
>
> The rationale was described I think in the first patch set, that
> switching pinmuxes tied to a device will be rare, whereas
> enabling/disabling will be common. So get/put will do the
> slow lookup of descriptors etc, whereas enable/disable will
> typically involve poking some hardware register so it will be fast.
>
> For example enabling/disabling on many systems need to be
> done as part of idling the hardware, and thus it should be
> fast since you may need to turn it back on quickly.

The issue with this model is that one can't fast-switch between two
mappings that do both require the same pin (e.g. say between 2-bit and
4-bit MMC bus). Given this is as you say probably not a very common case,
and actually I don't think the lookup will be *that* slow, it sounds like
everything will work fine.

It might be nice to provide a short example, just like the code I wrote
above, on switching in the documentation just so people have something
canonical to cut/paste into their driver so they get it right without
having to internalize the model.

> > ========== Matched request/free calls for GPIOs
> >
> > A couple more comments on your recent pinmux patches in light of this:
> >
> > From pin_request():
> >
> > +       /*
> > +        * If there is no kind of request function for the pin we just assume
> > +        * we got it by default and proceed.
> > +        */
> > +       if (gpio && ops->gpio_request_enable)
> > +               /* This requests and enables a single GPIO pin */
> > +               status = ops->gpio_request_enable(pmxdev,
> > +                                                 pin - pmxdev->desc->base);
> > +       else if (ops->request)
> > +               status = ops->request(pmxdev,
> > +                                     pin - pmxdev->desc->base);
> > +       else
> > +               status = 0;
> >
> > a) I feel the default should be to error out, not succeed; the whole
> > point of the API is for HW where something must be programmed to enable
> > each function. As such, if you don't provide that ops->request* function,
> > that seems like an error.
>
> This is designed for the case where the driver avoids to define either
> a gpio_request_enable() or a single pin request() callback.
>
> The request() is entirely optional but intended to handle the case
> where hardware puts additional restrictons on muxing apart from
> pin ovelap (which is already handled by the core). For chips that
> do not have any such hardware restrictions you don't implement the
> callback and then it succeeds, as there is no restriction.
>
> The issue of HW restrictions on muxing was raised by Grant
> only yesterday I think, it's a universal phenomenon, some have
> it some don't.

OK. But I'm not sure request is the correct time to implement this, or
at least not the only time it needs to be implemented. The special
requirements that Tegra might implement could only be determined right
when actually programming the pinmux registers, since the checks rely
on which other functions actually end up being activated.

Well, unless you're not allowed to even request conflicting setups. But
Then, the pinmux driver needs to have complete access to the pinmux core
state on what's been *requested*, not just what's actually active in HW
right now...

In particular, the kind of checks Tegra would need are (although exact
details of controller names etc, may be wrong):

* I2C controller 0 can be routed out to two different sets of pins. Only
One set of pins must be connected to the I2C controller at once.

* Foo controller 0 has two different kinds of interface to it; I2C slave
and SPI slave. Only one of these two interfaces should be actually
connected to pins at once.

I think the core pinmux code could implement some of these constraints
if provided with appropriate data from the pinmux drivers. However, I
think it'd be a good idea to defer that discussion until a little later
once we've talked through some of the other data model issues primarily
in the other email I just sent.

> The kerneldoc for request() right now looks like this:
>
>  * @request: called by the core to see if a certain pin can be made available
>  *      available for muxing. This is called by the core to acquire the pins
>  *      before selecting any actual mux setting across a function. The driver
>  *      is allowed to answer "no" by returning a negative error code
>
> Maybe it needs some clarification?
>
> > I think the logic above should be to always call ops->gpio_request_enable
> > if (gpio):
> >
> >        if (gpio)
> >                if (ops->gpio_request_enable)
> >                        /* This requests and enables a single GPIO pin */
> >                        status = ops->gpio_request_enable(pmxdev,
> >                                                  pin - pmxdev->desc->base);
> >        else
> >                status = ops->request(pmxdev,
> >                                      pin - pmxdev->desc->base);
> >
> > (ops->gpio_request_enable could be optional if GPIOs aren't supported on
> > any pinmux pins, whereas ops->request isn't optional, and should be checked
> > during pinmux_register)
>
> Well the idea is that if you want to reserve individual pins for GPIO
> but only need to implement one function for all pins on the mux,
> you need only implement ops->request(), this is the case for example
> with ux500 - any muxable pin works the same way since *all* muxable
> pins can also handle GPIO.

If each pin can either be just GPIO or some other function, wouldn't you
only need to implement ops->gpio_request_enable (to set whatever bit was required
for GPIO mode); you wouldn't need ops->request at all, since the non-GPIO case
was always valid?

> > Also, ops->gpio_request_enable should also be passed the GPIO number,
> > so the driver can validate that it's the correct one.
>
> Normally I think the pinmux driver should have no knowledge of
> such GPIO stuff.
>
> It's two totally separate number spaces here,
> one for pins, one for GPIO:s, I definately don't want to create
> cross-dependencies between these two.
>
> The basic assumption is that the pin number request coming in
> is sane, that the user knows what it is asking for.

Hmmm. I'd argue not to pass the GPIO number into the pinmux API at all then;
that way, there's no GPIO-related data that one has to decide whether to
validate or not.

> > Often, only
> > one value would be legal, but perhaps some pinmuxs allow 1 of N different
> > GPIOs to be mapped to some pin, so selection of which GPIO is on par with
> > selection of which special function to mux out, yet the driver still
> > doesn't want to expose every GPIO possibility as a pinmux "function" due
> > to explosion of the number of functions if it did that.
> >
> > b) When ops->gpio_request_enable is called to request a pin, it'd be nice
> > if the core could track this, and specifically call a new ops- >gpio_disable
> > to free it, rather than the generic ops->free. There are two cases in HW:
> >
> > b1) "GPIO" is just another special function in a list, e.g. SPI, I2C, GPIO.
> > In this case, free for a GPIO needs to either do nothing (the next call to
> > request will simply set the desired function), or possibly do something to
> > disable the pin in the same way as any other function. This works fine with
> > a single free function.
> >
> > b2) GPIO enable/disable is a separate concept from the pinmuxing; on Tegra
> > it'll be implemented by calling tegra_gpio_enable/disable. As such, a
> > single free function would require the pinmux driver to store state
> > indicating whether ops->free should call tegra_gpio_disable, or whether it
> > should do cleanup to the pinmux registers. Since the core is managing GPIO
> > vs. function allocation, I think the storing that state in the core makes
> > sense.
>
> I understand, I think.
>
> But I don't know if passing the gpio number into the pinmux
> driver helps with that. To me it sounds like a reason to keep
> then even more strictly separated so the pinmux driver have no
> clue whatsoever what it is muxing, it just performs the muxing.
>
> I had this similar usecase (I think from Sascha?) where two slightly
> different GPIO blocks (different drive strengths etc) would be alternatively
> muxed onto the same pins, on a per-pin basis.

I'd imagine selecting between the two GPIO blocks would be represented as
two different functions for each pin then. Of course, that runs into the
issue of an explosion in the number of functions, which brings me to:

Within a pinmux driver, the definition of a function describes both the
particular pin (or group of pins) it applies to and the functionality to
mux onto those pins.

Hence, if we want to represent "GPIO" as a function, we end up with e.g.
gpio0, gpio1, ..., gpio99 as functions; an explosion.

This is why we ended up with specific pinmux APIs for the "GPIO" case.
But, those APIs break down a little when there are 2 GPIO controllers;
pinmux_request_gpio() doesn't let you say you want to use a pin "for
GPIO controller <n>", but just "as a GPIO".

----------==========----------==========----------==========----------==========
To solve this, I propose that the definition of a function not include
any reference to a pin/pin-group.

Instead, we could have a *single* "gpio" function, that may be applied
to *any* pin/group (that supports it).

Then, to represent two GPIO controllers, you just end up with two
functions; "gpio0" and "gpio1".

This would require a pinmux driver to expose data slightly differently:

* A list of pins, each probably having a name.

Examples might be " A1", " A2", "A3", ...

* A list of functions, each probably having a name, but not list of pins.

Examples might be "I2C 0 SDA", "I2C 0 SCL", "I2C 1 SDA", "UART 0 RX", ...

* A table indicating which pins can support which function.

An example might be:

pin  functions
A1   UART 0 RX, I2C 0 SDA
A2   UART 0 TX, I2C 0 SCL
...

(as an aside, this is pretty much the data model in the existing Tegra
pinmux driver; see arch/arm/mach-tegra/include/mach/pinmux*.h and
arch/arm/mach-tegra/pinmux*.c) Perhaps I'm biased, not that I wrote any
of the existing Tegra pinmux code.

Internally, each pinmux driver would need a lookup table that maps from
the tuple (pin, function) to "register value to program into HW", since
selecting a particular function on pin A might be a different register
value than selecting that same logical function on pin B.

An example might be:

pin  function   register_value
A1   UART 0 RX  0
A1   I2C 0 SDA  1
A2   UART 0 RX  5
...

If pinmux drivers exported this data model, then the pinmux core could
probably implement some of the error-checking I talked about above, such
as ensuring that a particular logical function was not activated on
multiple pins/groups at once.

> In that case I think it was modeled such that say GPIO pins [0-N]
> were considered the same pins [0-N] on the other chip too.
> In that case I'd say it would be more clever to say that you have
> GPIO pins [0..N] and [N+1...2N], then let the physical pins
> behind that be a different issue altogether.
>
> For these cases I generally feel we need actual code to get
> somewhere, it might get into too much premature upfront design
> otherwise. I think it's better to look at patches here.
>
> > Thanks for reading. Hopefully this email didn't jump about too much.
>
> No problem... The more I read the more I learn.
>
> Thanks,
> Linus Walleij

--
nvpublic

