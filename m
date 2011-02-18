Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1BRRhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 12:37:12 -0500
Received: from xes-mad.com ([216.165.139.218]:20795 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab1BRRhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 12:37:07 -0500
Subject: Re: [PATCH v3 2/4] gpiolib: Add ability to get GPIO pin direction
From: Peter Tyser <ptyser@xes-inc.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <20110218085734.GX22310@pengutronix.de>
References: <1297983799-4747-1-git-send-email-ptyser@xes-inc.com>
	 <1297983799-4747-2-git-send-email-ptyser@xes-inc.com>
	 <20110218085734.GX22310@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 11:36:26 -0600
Message-ID: <1298050586.965.20444.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 09:57 +0100, Uwe Kleine-König wrote:
> On Thu, Feb 17, 2011 at 05:03:17PM -0600, Peter Tyser wrote:
> > Add a new get_direction() function to the gpio_chip structure.  This is
> > useful so that the direction of a pin can be determined when its
> > initially exported.  Previously, the direction defaulted to "unknown"
> > regardless of the actual configuration of the GPIO pin.
> > 
> > If a GPIO driver implements get_direction(), it is called in
> > gpio_request() to set the initial direction of the pin accurately.
> IMHO the commit log is conceptually wrong, because it talks about a
> "pin".  Better use gpio here.

I don't follow.  I used "pin" to make it clear that the get_direction()
function operates on a pin-by-pin basis, and to help reduce any
ambiguity about if a gpio chip or gpio pin is being referred to.  Would
you prefer that the "pin" references are clarified to be "GPIO pin"?

> > Cc: Alek Du <alek.du@intel.com>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Cc: David Brownell <dbrownell@users.sourceforge.net>
> > Cc: Eric Miao <eric.y.miao@gmail.com>
> > Cc: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
> > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Cc: Joe Perches <joe@perches.com>
> > Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> > ---
> > Changes since v1:
> > - Add support for "unknown" direction
> > 
> > Changes since v2:
> >   Based on Wolfram's feedback:
> > - Use GPIOF_DIR_* flags as returns from get_direction()
> > - Call spin_lock_irqsave() to before setting flags
> > 
> >  drivers/gpio/gpiolib.c     |   23 +++++++++++++++++++++++
> >  include/asm-generic/gpio.h |    4 ++++
> >  2 files changed, 27 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > index eb74311..a656a2c 100644
> > --- a/drivers/gpio/gpiolib.c
> > +++ b/drivers/gpio/gpiolib.c
> > @@ -1174,6 +1174,7 @@ int gpio_request(unsigned gpio, const char *label)
> >  	struct gpio_desc	*desc;
> >  	struct gpio_chip	*chip;
> >  	int			status = -EINVAL;
> > +	int			dir;
> >  	unsigned long		flags;
> >  
> >  	spin_lock_irqsave(&gpio_lock, flags);
> > @@ -1214,6 +1215,28 @@ int gpio_request(unsigned gpio, const char *label)
> >  		}
> >  	}
> >  
> > +	if (chip->get_direction) {
> > +		/* chip->get_direction may sleep */
> > +		spin_unlock_irqrestore(&gpio_lock, flags);
> might_sleep_if(chip->can_sleep) ?

Makes sense.  I was following the lead of chip->request() in the same
function, which doesn't use might_sleep_if().  I assume might_sleep_if()
should be added to it as well in a separate patch?

> > +		dir = chip->get_direction(chip, gpio - chip->base);
> > +		spin_lock_irqsave(&gpio_lock, flags);
> > +		switch (dir) {
> > +		case GPIOF_DIR_OUT:
> > +			set_bit(FLAG_DIR_OUT, &desc->flags);
> > +			clear_bit(FLAG_DIR_IN, &desc->flags);
> > +			break;
> > +		case GPIOF_DIR_IN:
> > +			set_bit(FLAG_DIR_IN, &desc->flags);
> > +			clear_bit(FLAG_DIR_OUT, &desc->flags);
> > +			break;
> > +		default:
> > +			/* Direction isn't known */
> > +			clear_bit(FLAG_DIR_OUT, &desc->flags);
> > +			clear_bit(FLAG_DIR_IN, &desc->flags);
> > +			break;
> > +		}
> Alternatively to my suggestion for patch1:
> 	} else {
> 		clear_bit(FLAG_DIR_OUT, &desc->flags);
> 		clear_bit(FLAG_DIR_IN, &desc->flags);

I like this way better too.  I'll initialize dir = -1 and pull the
switch statement out of the conditional, like:

	if (chip->get_direction) {
		/* chip->get_direction may sleep */
		spin_unlock_irqrestore(&gpio_lock, flags);
		might_sleep_if(chip->can_sleep);
		dir = chip->get_direction(chip, gpio - chip->base);
		spin_lock_irqsave(&gpio_lock, flags);
	}

	switch (dir) {
	case GPIOF_DIR_OUT:
		set_bit(FLAG_DIR_OUT, &desc->flags);
		clear_bit(FLAG_DIR_IN, &desc->flags);
		break;
	case GPIOF_DIR_IN:
		set_bit(FLAG_DIR_IN, &desc->flags);
		clear_bit(FLAG_DIR_OUT, &desc->flags);
		break;
	default:
		/* Direction isn't known */
		clear_bit(FLAG_DIR_OUT, &desc->flags);
		clear_bit(FLAG_DIR_IN, &desc->flags);
		break;
	}

Thanks for the comments,
Peter

