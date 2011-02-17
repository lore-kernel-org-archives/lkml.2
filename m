Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab1BQIG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 03:06:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48891 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab1BQIGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 03:06:54 -0500
Date: Thu, 17 Feb 2011 09:06:43 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/3] gpiolib: Add ability to get GPIO pin direction
Message-ID: <20110217080643.GI22310@pengutronix.de>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
 <1297698493.965.5475.camel@petert>
 <20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
 <AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
 <20110214193502.101759d0@lxorguk.ukuu.org.uk>
 <1297726502.965.6921.camel@petert>
 <20110215114210.1f1a8470@lxorguk.ukuu.org.uk>
 <1297789548.965.10101.camel@petert>
 <20110215171915.384223b6@lxorguk.ukuu.org.uk>
 <1297792151.965.10259.camel@petert>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1297792151.965.10259.camel@petert>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 11:49:11AM -0600, Peter Tyser wrote:
> On Tue, 2011-02-15 at 17:19 +0000, Alan Cox wrote:
> > > +       if (chip->get_direction) {
> > > +               /* chip->get_direction may sleep */
> > > +               spin_unlock_irqrestore(&gpio_lock, flags);
> > > +               if (chip->get_direction(chip, gpio - chip->base) > 0)
> > > +                       set_bit(FLAG_IS_OUT, &desc->flags);
> > > +               spin_lock_irqsave(&gpio_lock, flags);
> > > +       } else {
> > > +               set_bit(FLAG_IS_UNKNOWN, &desc->flags);
> > > +       }
> > > 
> > > This would have the side effect of having nearly all GPIO drivers
> > > default to an "unknown" direction until they implement the new
> > > get_direction() function, which I think is an improvement over the
> > 
> > This doesn't solve anything. If the hardware supports alt_func state then
> > it now can't implement get_direction, so that's useless.
> 
> I don't follow.  If a pin is configured for some alternate function,
> then requesting it for GPIO should fail, thus it doesn't matter if it
> implements get_direction()?  Since we can't easily toggle back and forth
> between GPIO and alt_func, I'd think we shouldn't be able to request
> alt_func pins for GPIO - they should be off-limits to the GPIO subsystem
> altogether.
hmm, I'm not sure.  Letting gpio_request fail looks good from the POV of
an uninformed driver.  But for some platform code, it seems more natural
to do:

	gpio_request(mygpio);
	myplatform_iomux_setup(pad_for_altfunc);
	do_something_special();
	/*
	 * the controler is unable to reset some component, so use
	 * bitbanging for that
	 */
	myplatform_iomux_setup(pad_for_gpio);
	gpio_direction_output(mygpio, 0);
	usleep(100);
	myplatform_iomux_setup(pad_for_altfunc);
	...

instead of only being able to gpio_request after
myplatform_iomux_setup(pad_for_gpio). (And so in theory take that risk
that another process grabs the gpio between mux-for-gpio and
gpio_request.) So if you ask me, it's gpio_direction_{in,out}put that
should fail, not gpio_request.  But I'm not that sure about it to
already know now to keep this opinion until after this discussion is
over.

> My understanding is that currently if some platform wants to toggle pins
> back and forth between alt_func and GPIO, it needs to handle that logic
> itself.  If platform code is handling that toggling, I'd think the GPIO
> code should not touch pins configured as alt_func.  If the platform is
> no longer using them as alt_func, then it should poke the appropriate
> registers to make them not alt_func so that they can then be used by the
> GPIO subsystem.
.. or at least make the usage via the gpio subsystem fail using it.
OTOH on arm/plat-mxc (at least the newer chips) there is no easy mapping
between pads and gpios.  So currently we do:  gpio_request and
gpio_direction_{in,out}put yield 0, but it depends on the pin muxing if
the gpio is "visible" anywhere.  I don't like that much, but I agree
that it's not worth to setup a huge table to map gpios to pads and back
just to return -ESOMETHING in the gpio functions.
 
Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
