Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1HETP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 15:15:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39418 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab1HETPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 15:15:54 -0400
Date: Fri, 5 Aug 2011 20:15:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@nvidia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/3] If an IRQ is a GPIO, request and configure it
Message-ID: <20110805191504.GB28958@n2100.arm.linux.org.uk>
References: <1312498820-2275-1-git-send-email-swarren@nvidia.com> <20110805094017.GC20575@n2100.arm.linux.org.uk> <74CDBE0F657A3D45AFBB94109FB122FF049F171EFC@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF049F171EFC@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 08:43:20AM -0700, Stephen Warren wrote:
> Russell King - ARM Linux wrote at Friday, August 05, 2011 3:40 AM:
> > On Thu, Aug 04, 2011 at 05:00:17PM -0600, Stephen Warren wrote:
> > > In http://www.spinics.net/lists/linux-tegra/msg01731.html, Mark Brown
> > > pointed out that it was a little silly forcing every board or driver
> > > to gpio_request() a GPIO that is later converted to an IRQ, and passed
> > > to request_irq. The first patch in this series instead makes the core
> > > IRQ code perform these calls when appropriate, to avoid duplicating it
> > > everywhere.
> > 
> > Trying to go from IRQ to GPIO is not a good idea - most of the
> > IRQ <-> GPIO macros we have today are just plain broken.  Many of them
> > just add or subtract a constant, which means non-GPIO IRQs have an
> > apparant GPIO number too.  Couple this with the fact that all positive
> > GPIO numbers are valid, and this is a recipe for wrong GPIOs getting
> > used and GPIOs being requested for non-GPIO IRQs.
> > 
> > I think this was also discussed in the past, and the conclusion was that
> > IRQs should be kept separate from GPIOs.  Maybe views have changed since
> > then...
> > 
> > However, if we do want to do this, then it would be much better to provide
> > a new API for requesting GPIO IRQs, eg:
> > 
> > gpio_request_irq()
> > 
> > which would wrap around request_threaded_irq(), takes a GPIO number,
> > does the GPIO->IRQ conversion internally, and whatever GPIO setup is
> > required.  Something like this:
> 
> With that approach, drivers need to explicitly know whether they're
> passed a GPIO or an IRQ, and do something different, or they need to
> choose to only accept a GPIO or IRQ.

You completely missed the biggest reason why your approach is broken.

+               gpio = irq_to_gpio(irq);
+               if (gpio_is_valid(gpio))

Let's look at the code:

#define ARCH_NR_GPIOS           256

static inline bool gpio_is_valid(int number)
{
        return number >= 0 && number < ARCH_NR_GPIOS;
}

Now, let's take AT91:

#define irq_to_gpio(irq)  (irq)

This doesn't define ARCH_NR_GPIOS, so it gets the default 256.  Now lets
take a random selection of the AT91 interrupt numbers:

#define AT91RM9200_ID_US3       9       /* USART 3 */
#define AT91RM9200_ID_MCI       10      /* Multimedia Card Interface */
#define AT91RM9200_ID_UDP       11      /* USB Device Port */
#define AT91RM9200_ID_TWI       12      /* Two-Wire Interface */
#define AT91RM9200_ID_SPI       13      /* Serial Peripheral Interface */
#define AT91RM9200_ID_SSC0      14      /* Serial Synchronous Controller 0 */
#define AT91RM9200_ID_SSC1      15      /* Serial Synchronous Controller 1 */

None of these are GPIOs.  Yet gpio_is_valid(irq_to_gpio(AT91RM9200_ID_TWI))
is true.

That's the problem - it's undefined whether gpio_is_valid(irq_to_gpio(irq))
returns true or false for any particular interrupt.  There's no multiplexing
through gpiolib for the IRQ-to-GPIO mapping either, so it doesn't work for
off-SoC GPIOs.

So, you can't reliably go from interrupt numbers to GPIO numbers - it's
just not supported.  So to throw this into the IRQ layer is just going to
end up breaking a hell of a lot of platforms.

Now, stack on top of that a discussion at the Linaro Connect conference
this week where we discussed getting rid of IRQ numbers entirely, and
our desire to kill off irq_to_gpio() and I think it makes this approach
a non-starter.

> So it seems like, as was mentioned elsewhere in this thread, the upshot of
> this conversation is that interrupt chip drivers should do this internally,
> both to avoid requiring a general irq_to_gpio function, and because calling
> gpio_direction_input for GPIOs-used-as-IRQs isn't appropriate for all
> hardware.

That would be more appropriate, because the IRQ chip stuff at least knows
if there's a GPIO associated with it.

There's still the unanswered question whether we even want the IRQ layer
to do this kind of stuff, and the previous decision on that I believe was
in the negative.  So I think Thomas needs to respond to that point first.
