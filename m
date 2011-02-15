Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab1BORtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:49:52 -0500
Received: from xes-mad.com ([216.165.139.218]:34258 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab1BORtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:49:49 -0500
Subject: Re: [PATCH 1/3] gpiolib: Add ability to get GPIO pin direction
From: Peter Tyser <ptyser@xes-inc.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
In-Reply-To: <20110215171915.384223b6@lxorguk.ukuu.org.uk>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
	 <1297698493.965.5475.camel@petert>
	 <20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
	 <AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
	 <20110214193502.101759d0@lxorguk.ukuu.org.uk>
	 <1297726502.965.6921.camel@petert>
	 <20110215114210.1f1a8470@lxorguk.ukuu.org.uk>
	 <1297789548.965.10101.camel@petert>
	 <20110215171915.384223b6@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 11:49:11 -0600
Message-ID: <1297792151.965.10259.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 17:19 +0000, Alan Cox wrote:
> > +       if (chip->get_direction) {
> > +               /* chip->get_direction may sleep */
> > +               spin_unlock_irqrestore(&gpio_lock, flags);
> > +               if (chip->get_direction(chip, gpio - chip->base) > 0)
> > +                       set_bit(FLAG_IS_OUT, &desc->flags);
> > +               spin_lock_irqsave(&gpio_lock, flags);
> > +       } else {
> > +               set_bit(FLAG_IS_UNKNOWN, &desc->flags);
> > +       }
> > 
> > This would have the side effect of having nearly all GPIO drivers
> > default to an "unknown" direction until they implement the new
> > get_direction() function, which I think is an improvement over the
> 
> This doesn't solve anything. If the hardware supports alt_func state then
> it now can't implement get_direction, so that's useless.

I don't follow.  If a pin is configured for some alternate function,
then requesting it for GPIO should fail, thus it doesn't matter if it
implements get_direction()?  Since we can't easily toggle back and forth
between GPIO and alt_func, I'd think we shouldn't be able to request
alt_func pins for GPIO - they should be off-limits to the GPIO subsystem
altogether.

My understanding is that currently if some platform wants to toggle pins
back and forth between alt_func and GPIO, it needs to handle that logic
itself.  If platform code is handling that toggling, I'd think the GPIO
code should not touch pins configured as alt_func.  If the platform is
no longer using them as alt_func, then it should poke the appropriate
registers to make them not alt_func so that they can then be used by the
GPIO subsystem.

Maybe we disagree on the above point, which is adding to the confusion?

> > For the "unavailable" state, I didn't think it would be necessary.  As
> > is, if someone calls gpio_request() on an invalid or alt_use pin, they
> > shouldn't get access to the GPIO, which makes the "unavailable value
> > moot since they couldn't access the GPIO in the first place.
> 
> In a word 'sysfs'
> 
> We need FLAG_IS_UNKNOWN (or saner would be FLAG_IS_IN to go with
> FLAG_IS_OUT) to make the sysfs code report properly (and some other spots
> fixing to make it work right)

Agreed.

> If you add FLAG_IS_UNKNOWN then the other change you need is in
> 
> gpio_direction_show() which needs to also check the UNKNOWN bit and
> report appropriately.

Agreed.

> That would fix that problem and at least allow the
> reporting side of GPIO in use for something else to be handled as a
> platform thing even though it can't be handled properly.

I don't follow.  I don't think I'm grasping what you want for alt_func
pins in the short term.  Do you want them to be exported to the GPIO
sysfs filesystem and shown as "unavailable"?  If so, what advantage does
that have over not allowing them to be exported/reserved in the first
place?

Peter




