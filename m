Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab1HSO0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:26:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35165 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab1HSO0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:26:13 -0400
Date: Fri, 19 Aug 2011 15:26:08 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jamie Iles <jamie@jamieiles.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/4 v4] drivers: create a pin control subsystem
Message-ID: <20110819142608.GB2800@pulham.picochip.com>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
 <20110819104816.GA5030@pulham.picochip.com>
 <CACRpkdZhg_1WM37uqT1PNmpUjWS_groWJmNnR4SBjqJ6LFQQWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZhg_1WM37uqT1PNmpUjWS_groWJmNnR4SBjqJ6LFQQWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Aug 19, 2011 at 04:04:54PM +0200, Linus Walleij wrote:
> On Fri, Aug 19, 2011 at 12:48 PM, Jamie Iles <jamie@jamieiles.com> wrote:
> > On Fri, Aug 19, 2011 at 11:53:50AM +0200, Linus Walleij wrote:
> >> +Interaction with the GPIO subsystem
> >> +===================================
> >> +
> >> +The GPIO drivers may want to perform operations of various types on the same
> >> +physical pins that are also registered as GPIO pins.
> >> +
> >> +Since the pin controller subsystem have its pinspace local to the pin
> >> +controller we need a mapping so that the pin control subsystem can figure out
> >> +which pin controller handles control of a certain GPIO pin. This member
> >> +in the pin controller descriptor handles this mapping:
> >> +
> >> +static struct pinctrl_desc foo_desc = {
> >> +     ...
> >> +     .gpio_base = FIRST_PIN,
> >> +};
> >> +
> >> +When GPIO-specific functions in the pin control subsystem are called, these
> >> +mappings will be used to look up the apropriate pin controller by inspecting
> >> +and matching the pin to this pin range.
> >
> > On our (difficultly muxed!) platform we have two types of GPIO - a
> > Synopsys controller which is a fairly conventional GPIO controller, then
> > a sigma-delta GPIO controller which can also do a an analogue type
> > output (as well as digital).
> 
> Does that mean it is really not a GPIO controller but a kind of D/A converter?

Kind of.  In the basic mode it's just a GPIO controller that does 
digital I/O.  In the SD mode it all really depends on what the external 
filter looks like.  As gpio_set_value() takes an int as the value, then 
the gpio controller theoretically _could_ treat that as an analogue 
output value and use the pinctrl api to set the converter and rate sizes 
but I don't really want to go there yet as it's a bit of an abuse of the 
gpio API!

> >  For lots of our pads they can either be
> > ARM GPIO, SD GPIO or some other function, so I don't see how this fits
> > in with a single GPIO base.
> 
> And each of them are modeled as a separate gpio_chip I guess?
> 
> Otherwise it's a bad match with reality. We had this discussion with GRant
> where two gpio_chips would use the same number range in the GPIO
> global pinspace, and it's basically not allowed IIRC.

Yes, the SD-GPIO isn't memory mapped so has a completely separte 
gpio_chip.

> But yes, there is an assumption that each pin controller will only
> deal with one block of GPIO pins. So if I make it possible to support
> several GPIO ranges for one pin controller, does that solve your problem?
> 
> Like this:
> 
> struct pinctrl_gpio_range {
>     char *name;
>     unsigned int base;
>     unsigned int npins;
> }
> 
> static unsigned int gpio_ranges[] = {
>     {
>         .name="chip1",
>         .base = 0,
>         .npins = 16,
>     },
>     {
>         .name =" chip2",
>         .base = 32,
>         .npins = 16,
>     },
>     {
>         .name = "chip3",
>         .base = 64,
>         .npins = 16,
>     },
> };
> 
> static struct pinctrl_desc foo_desc = {
>         ...
>         .gpio_ranges = gpio_ranges,
>         .num_gpio_ranges = ARRAY_SIZE(gpio_ranges),
> };
> 
> For three different 32-bit GPIO controllers muxed on
> pins 0..31 using GPIO space pins from 0..95.
> 
> Then I pass the number of the instance down to the
> driver in the gpio_request_enable() callback like
> this:
> 
> int (*gpio_request_enable) (struct pinctrl_dev *pctldev,
> 	    unsigned instance,
> 	    unsigned offset);
> 
> Would this work?
> 
> This has a restriction: the GPIO space must be mapped in
> continous ranges, as must the pin controller. Else we need
> one entry per pin in the list above...

OK, that looks perfect!

> >> +The correspondence for the range from the GPIO subsystem to the pin controller
> >> +subsystem must be one-to-one. Thus the GPIO pins are in the pin controller
> >> +range [0 .. maxpin] where maxpin is the specified end of the pin range.
> >
> > So doesn't this mean that the enumeration that was initially described
> > as arbitrary actually has to enumerate the GPIO pins first?
> 
> If you use GPIO accessors, the enumeration has to match.
> So I rewrite it like this:
> 
> "this enumeration was arbitrarily chosen, in practice you need to think
> through your numbering system so that it matches the layout of registers
> and such things in your driver, or the code may become complicated. You must
> also consider matching of offsets to the GPIO ranges that may be handled by
> the pin controller."
> 
> OK?

Sounds good.

> >> +static struct class pinctrl_class = {
> >> +     .name = "pinctrl",
> >> +     .dev_release = pinctrl_dev_release,
> >> +     .dev_attrs = pinctrl_dev_attrs,
> >> +};
> >
> > Greg K-H has mentioned in the past that class is now deprecated for new
> > use and that a bus_type should be used instead.
> 
> Can you provide a reference with some detail?
> The pin control devices are usually aleady on a bus like the
> platform_bus or amba_bus or i2c_bus, then they register a
> class device in this case.
> 
> The kerneldoc documentation says
> "A bus is a channel between the processor and one or more devices."
> 
> This isn't the case here.
> 
> Anyhthing that help me understand this is appreciated, Arnd?

There's a thread here https://lkml.org/lkml/2011/3/25/443 where this has 
been discussed (I originally had a class too).

> >> +/**
> >> + * struct pinctrl_desc - pin controller descriptor, register this to pin
> >> + * control subsystem
> >> + * @name: name for the pin controller
> >> + * @pins: an array of pin descriptors describing all the pins handled by
> >> + *   this pin controller
> >> + * @npins: number of descriptors in the array, usually just ARRAY_SIZE()
> >> + *   of the pins field above
> >> + * @maxpin: since pin spaces may be sparse, there can he "holes" in the
> >> + *   pin range, this attribute gives the maximum pin number in the
> >> + *   total range. This should not be lower than npins for example,
> >> + *   but may be equal to npins if you have no holes in the pin range.
> >> + * @pmxops: pinmux operation vtable, if you support pinmuxing in your driver
> >> + * @gpio_base: the base offset of the pin range in the GPIO subsystem that
> >> + *   is handled by this controller, if applicable. This member is only
> >> + *   relevant if you want to e.g. control pins from the GPIO subsystem.
> >> + * @gpio_pins: the number of pins from (and including) the gpio_base offset
> >> + *   handled by this pin controller.
> >> + * @owner: module providing the pin controller, used for refcounting
> >> + */
> >> +struct pinctrl_desc {
> >> +     const char *name;
> >> +     struct pinctrl_pin_desc const *pins;
> >> +     unsigned int npins;
> >> +     unsigned int maxpin;
> >> +     struct pinmux_ops *pmxops;
> >> +     unsigned int gpio_base;
> >> +     unsigned int gpio_pins;
> >> +     struct module *owner;
> >
> > Would it be better to put the owner in the ops structure like file_ops?
> > I'm sure I remember someone saying that it's better to do that so that
> > it's in the modules .data/.rodata section but I can't find that
> > reference.
> 
> I can't do that because the pinmux_ops vtable is not mandatory.
> 
> The plan is to add more ops for other things like pin bias etc.

OK, I'd missed that.

> >> +/**
> >> + * struct pinctrl_dev - pin control class device
> >> + * @desc: the pin controller descriptor supplied when initializing this pin
> >> + *   controller
> >> + * @node: node to include this pin controller in the global pin controller list
> >> + * @dev: the device entry for this pin controller
> >> + * @owner: module providing the pin controller, used for refcounting
> >> + * @driver_data: driver data for drivers registering to the pin controller
> >> + *   subsystem
> >> + *
> >> + * This should be dereferenced and used by the pin controller core ONLY
> >> + */
> >> +struct pinctrl_dev {
> >> +     struct pinctrl_desc *desc;
> >> +     struct radix_tree_root pin_desc_tree;
> >> +     spinlock_t pin_desc_tree_lock;
> >> +     struct list_head node;
> >> +     struct device dev;
> >> +     struct module *owner;
> >> +     void *driver_data;
> >
> > Couldn't the struct device driver_data be used here?
> 
> I'm already using dev_set_drvdata(&pctldev->dev, pctldev);
> So I can retrieve the pctldev withdev_get_drvdata(dev);
> in sysfs...
> 
> If I wasn't registering sysfs nodes I couldv'e used it.

OK, fair enough.

> >> +/* These should only be used from drives */
> >
> > s/drives/drivers?
> 
> OK.
> 
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
> > So is the request like gpio_request() or just test if it the pin is
> > available?  If its the latter then perhaps pin_is_available() might be a
> > better name?
> 
> It's the former. The pin controller may have some electrical
> properties that makes it impossible to request a certain pin for muxing
> at a certain time. (Found out on earlier list review.)

OK, it's a bit of a language nitpick, but I interpreted that as meaning 
it was purely a test.

	@request: called by the core to reserve a pin for muxing. This 
	is called by the core to acquire the pins before selecting any 
	actual mux setting across a function. The driver is allowed to 
	answer "no" by returning a negative error code.

maybe makes things a little clearer (to me anyway!)?

> >> +#else /* !CONFIG_PINMUX */
> >> +
> >> +static inline int pinmux_request_gpio(unsigned gpio)
> >> +{
> >> +     return 0;
> >> +}
> >> +
> >> +static inline void pinmux_free_gpio(unsigned gpio)
> >> +{
> >> +}
> >> +
> >> +static inline struct pinmux *pinmux_get(struct device *dev, const char *func)
> >> +{
> >> +     return NULL;
> >> +}
> >
> > The CONFIG_PINMUX=y version of pinmux_get returns an ERR_PTR() encoded
> > error so perhaps this should return something like ERR_PTR(-ENXIO)?
> 
> No this is modeled more like the regulator stubs in
> <linux/regulator.h>. For example, if you're compiling for a
> platform that does not support regulators they are assumed to
> be always on.
> 
> In this case, if compiled for a platform without pinmux, we assume
> we got the pins we need already so it just works, not fail.

That makes perfect sense!  Doh!

Thanks a lot for doing this work Linus, it's really appreciated and 
looking great!  It's a bit difficult for me to test this on my platform 
at the moment as I'm still trying to handle all of the device tree stuff 
but I'll give this a good test as soon as I can.

Jamie
