Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab1KUTA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:00:58 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4234 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab1KUTA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:00:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 21 Nov 2011 11:00:51 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
Date: Mon, 21 Nov 2011 11:00:49 -0800
Subject: RE: [PATCH] pinctrl: indicate GPIO direction on single GPIO request
Thread-Topic: [PATCH] pinctrl: indicate GPIO direction on single GPIO request
Thread-Index: AcyoOvf52tMEgBqWQXiUFtJWiYlgFAAPgqHA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174F08C17B@HQMAIL01.nvidia.com>
References: <1321261837-31320-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805AAE@HQMAIL01.nvidia.com>
	<CAJuYYwTKNLh0NxfUBubGJuyLFDgkD6qPc=brd8dLObUW9p0tgA@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805E0A@HQMAIL01.nvidia.com>
	<CACRpkdYz_gOP22cHgtdo5GqY6P_DeCbykFm1MS6Kua_ERVKEpQ@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740D74BC3@HQMAIL01.nvidia.com>
 <CACRpkdapm2cx=QJkPinwteCPZFNNnxVcKqR4f0D8_ikWMTea_g@mail.gmail.com>
In-Reply-To: <CACRpkdapm2cx=QJkPinwteCPZFNNnxVcKqR4f0D8_ikWMTea_g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Monday, November 21, 2011 3:47 AM:
> On Thu, Nov 17, 2011 at 6:15 PM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > a) gpio_request() doesn't know the direction; only gpio_direction_*()
> > know that. I suggest the pinctrl API have the same set of GPIO-related
> > functions that gpiolib has, so each can be passed through to a pinctrl
> > function 1:1:
> >
> > gpio_request -> pinmux_gpio_request
> > gpio_direction_input -> pinmux_gpio_direction_input
> > gpio_direction_output -> pinmux_gpio_direction_output
> > gpio_free -> pinmux_gpio_free
> >
> > (and a pinmux driver ops entry for each too)
> 
> You are right, the current solution is messy, and this is way more
> elegant and to the point. I'll fix up the patch set and resubmit it.
> 
> > However, it doesn't cover the following case:
> >
> > b3) Some GPIO could be routed to multiple pins, just like any other pinmux
> > function. In this case, knowing the GPIO ID isn't enough to program the
> > pinmux, but you need to know both "this GPIO" (which we have) and "this
> > pin" (which is missing).
> >
> > I'm not sure how to solve that. For such SoCs, perhaps we should treat
> > this as a muxing setup, and require it to be in the mapping table, and
> > consider all the pinmux_gpio_* functions to be "enable GPIO access to
> > pins" rather than "set up pin mux for GPIOs"?
> 
> I think we'll survive that, since the gpio range concept is supposed to
> make the final resolution of that at runtime.
> 
> Now ranges are dynamic, so if these pin allocation also want to
> *change* at runtime it will be hairy, but that only reflects the actual
> trouble in doing such re-arrangements I think...

Doing this with dynamic GPIO ranges sounds complex; every time the mux
setting gets changed for a pin which can be a GPIO, you'd have to adjust
the dynamic ranges; this sounds like a lot of work.

I thought I'd sent this on Friday, but perhaps I only thought it up over
the weekend... Here's my proposal:

1)

Add a new gpiolib API:

int gpio_request_at(unsigned gpio, const char *label, unsigned at);

"at" is the "pinmux location for this GPIO". The interpretation of this
value is defined by each SoC just like GPIO IDs and pinctrl pin numbers
are.

On SoCs where a GPIO could be routed to n different pinctrl pins, the
caller can provide a specific location ("at") to mux it onto. The muxing
would happen during the gpiolib to pinctrl gpio_request() or
gpio_direction_*() call.

The existing gpio_request() would just call gpio_request() with at==0.

Now, most SoCs don't support this, so would validate that at==0 in their
implementation.

Equally, since this feature probably isn't used today, most drivers can
simply keep calling plain old gpio_request().

If/when a SoC needs this functionality, the relevant drivers will need to
be updated to call gpio_request_at() instead of plain gpio_request(). The
"at" parameter should come in through platform data (or device-tree) in
exactly the same way as the existing GPIO ID does; the driver certainly
should not be defining the "at" value itself. In device-tree, this can be
handles by increasing "#gpio-cells" for the GPIO controller, think.

2)

Instead of pinctrl drivers providing a GPIO<->pin table to the pinctrl
core, and having to dynamically adjust this every time a GPIO's muxing
changes, I propose completely removing GPIO range support from pinctrl.

Instead, a pinmux driver should implement a new pinmux_op, e.g.:

int (*gpio_get_pin)(unsigned gpio, unsigned at, unsigned *pin)

At least Tegra will just implement this as:

int foo_gpio_get_pin(unsigned gpio, unsigned at, unsigned *pin)
{
    if (at != 0)
        return -EINVAL;
    if (gpio >= NUM_SOC_GPIOS)
        return -EINVAL;
    /*
     * GPIO IDs have a 1:1 mapping with pinctrl pins, and GPIO 0 == pin 0.
     * Other drivers may need to implement a range lookup here.
     */
    return gpio;
}

A pinctrl driver with a non 1:1 or offset mapping of GPIO ID to pin
number might need slightly more complexity:

    return gpio + 128; // 128 == base pin ID of first GPIO

or:

    if (gpio < 32)
        return gpio + 16;
    elif (gpio < 64)
        return gpio + 64;
    else;
        return gpio + 128;

A pinctrl driver that supports GPIOs being muxed to different locations
might have to look up the combination of gpio,at in some table.

The advantage here is that it removes a lot of core code from pinctrl
that deals with the range tables, especially if we need to start making
them dynamic. The replacement op that pinmux drivers need to implement
is likely to be trivial in most cases; perhaps even simpler than
providing a gpio range definition to the core as it must right now. And
any complexity caused by SoCs that can map a GPIO to different pins is
basically isolated to that SoC's pinctrl drivers' gpio_get_pin API, and
any drivers than run on the SoC, which only need to pass one extra piece
of data to gpiolib.

Finally, when pinctrl receives any of the pinmux_gpio_* calls, it will
simply do:

int pinmux_request_gpio(unsigned gpio, unsigned at)
{
	struct pinctrl_dev *pctldev;
	const struct pinmux_ops *ops;
	int ret;
	int pin;

	ret = pinctrl_get_gpio_dev(gpio, &pctldev);
	if (ret < 0)
		return ret;
	ops = pctldev->desc->pmxops;

	ret = ops->gpio_get_pin(gpio, at, &pin);
	if (ret < 0)
		return ret;

	/* Calls ops->gpio_request internally */
	ret = pin_request(pctldev, pin, at, "gpio%d");
	if (ret < 0)
		return ret;

      /*
	 * We'd need to cache a GPIO->pin,at mapping here to allow
	 * pinmux_gpio_direction() to call gpio_get_pin. Perhaps we
	 * could have gpiolib store the mapping, per GPIO and pass
	 * it back to other functions?
	 */
	return 0;
}

Now, you do need to write a pinctrl_get_gpio_dev() function, so I suppose
that pinctrl drivers will need to tell the pinctrl core their min/max
GPIO IDs, and I suppose there could be many ranges, so we get back to
registering ranges. Ick.

(In a system with multiple pinctrl drivers, you can't just grab "the"
pinctrl driver here, because there's more than one, and different gpiolib
GPIO ranges will probably map to different pinctrl drivers)

Perhaps we could get some help from gpiolib; for each GPIO chip that
gets registered, can gpiolib store the pctldev and pass it into the
pinctrl driver:

/* Or some equivalent first parameter */
int pinmux_request_gpio(struct pinctrl_dev *pctldev, unsigned gpio, unsigned at);

pinctrl driver probe would probably need to do something like:

pinctrl_set_gpio_driver(gpio, numgpios, <driver handle>)

which internally would do nothing but call:

gpiolib_set_gpiochip_pinctrl_driver(f(<driver handle>), gpio)

where f(<driver handle>) is whatever gets passed as the first parameter to
pinmux_request_gpio()?

-- 
nvpublic

