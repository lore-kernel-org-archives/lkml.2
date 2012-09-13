Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab2IMWLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:11:31 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40716 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab2IMWL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:11:26 -0400
Date: Fri, 14 Sep 2012 00:11:25 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: document semantics vs GPIO
Message-ID: <20120913221125.GA10032@glitch>
Mail-Followup-To: Stephen Warren <swarren@wwwdotorg.org>,
	Linus Walleij <linus.walleij@stericsson.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Stephen Warren <swarren@nvidia.com>,
	Anmar Oueja <anmar.oueja@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
References: <1347519686-10170-1-git-send-email-linus.walleij@stericsson.com>
 <505205B1.4080708@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505205B1.4080708@wwwdotorg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 10:11:29AM -0600, Stephen Warren wrote:
> On 09/13/2012 01:01 AM, Linus Walleij wrote:
> > From: Linus Walleij <linus.walleij@linaro.org>
> > 
> > The semantics of the interactions between GPIO and pinctrl may be
> > unclear, e.g. which one do you request first? This amends the
> > documentation to make this clear.
> 
> > +Drivers needing both pin control and GPIOs
> > +==========================================
> > +
> > +Again, it is discouraged to let drivers lookup and select pin control states
> > +themselves, but again sometimes this is unavoidable.
> > +
> > +So say that your driver is fetching its resources like this:
> > +
> > +#include <linux/pinctrl/consumer.h>
> > +#include <linux/gpio.h>
> > +
> > +struct pinctrl *pinctrl;
> > +int gpio;
> > +
> > +pinctrl = devm_pinctrl_get_select_default(&dev);
> > +gpio = devm_gpio_request(&dev, 14, "foo");
> > +
> > +Here we first request a certain pin state and then request GPIO 14 to be
> > +used. If you're using the subsystems orthogonally like this, always get
> > +your pinctrl handle and select the desired pinctrl state BEFORE requesting
> > +the GPIO. This is a semantic convention to avoid situations that can be
> > +electrically unpleasant, you will certainly want to mux in and bias pins
> > +in a certain way before the GPIO subsystems starts to deal with them.
> 
> I'm not 100% certain that all HW will work best by first programming
> pinctrl then programming GPIO. For example of strangeness, Tegra's GPIO
> controller has a bit per-pin which overrides the pinmux's mux function
> to enable GPIOs, yet the pinctrl's tri-state overrides the GPIO's
> input/output control. I imagine HW engineers can come up with even more
> bizarre schemes that might in some cases require the reverse order).

This sounds like a good argument to keep pinctrl and GPIO subsystems
orthogonal as much as possible.

> However, I suppose what you've documented is likely common and it'd be
> good to recommend a default order between the two APIs. I might whittle
> out the part that justifies the order from a HW glitching perspective
> though.

Maybe a note like "The order of pin and GPIO acquisitions may be reversed
due to HW constrains or glitch-free policies" is enough?

> > +But there are also situations where it makes sense for the GPIO subsystem
> > +to communicate directly with with the pinctrl subsystem, using the latter
> > +as a back-end. This is when the GPIO driver may call out to the functions
> > +described in the section "Pin control interaction with the GPIO subsystem"
> > +above. This only involves per-pin multiplexing, and will be completely
> > +hidden behind the gpio_*() function namespace. In this case, the driver
> > +need not interact with the pin control subsystem at all.
> 
> I think it makes sense to more strongly recommend that for GPIO muxing,
> the GPIO driver always call into the pinctrl subsystem (if needed by the
> HW) to perform that muxing, so that standalone gpio_direction_*() always
> work without any use of pinctrl; the interaction between the two should
> only be required if pin configuration (not just pin muxing) is also
> required.

Don't know. Isn't possible to reach the same effect moving this kind
of knowledge into higher level helper functions and remove this bridge
across the subsystems?  Because there is also the pin config stuff that
may require special mixing as well and it's clear that there is no space
for it in these calls.

cheers,
Domenico
