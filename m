Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab0FXGll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 02:41:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49558 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab0FXGlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 02:41:40 -0400
Date: Thu, 24 Jun 2010 08:41:27 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux kernel <linux-kernel@vger.kernel.org>,
       ext-jani.1.nikula@nokia.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and sleeping
	gpios)
Message-ID: <20100624064127.GA23539@pengutronix.de>
References: <728731.73469.qm@web180307.mail.gq1.yahoo.com> <4C225CB2.6090407@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C225CB2.6090407@bluewatersys.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 24, 2010 at 07:12:50AM +1200, Ryan Mallon wrote:
> David Brownell wrote:
> > 
> > --- On Tue, 6/22/10, Ryan Mallon <ryan@bluewatersys.com> wrote:
> > 
> >>> --- On Tue, 6/22/10, Ryan Mallon <ryan@bluewatersys.com>
> >> wrote:
> 
> >>>> 'Can sleep' for a gpio has two different meanings
> >> depending
> >>>> on context
> >>> NO; for the GPIO itself it's only ever had one
> >>> meaning, regardless of context.
> >>>
> >>> You're trying to conflate the GPIO and one
> >>> of the contexts in which it's used.  That's
> >>> the problem you seem to be struggling with.
> >>>
> >>> Please stop conflating/confusing
> >>> those two disparate concepts...
> >> I'm not. 
> > 
> > BUT Your "counter" example below is solid
> > proof that you are:  it shows exactly the
> > confusion I pointed out:  call context versus
> > the GPIO itself.  There's no way I can read
> > that as anything except "you are"...
> > 
> >  
> > Your intent here seems perhaps more to
> > be a troll than to address any real
> > technical issues.  I don't see much
> > point participating any further.
> > 
> > 
> >  Some gpios, such as those on io expanders, may
> >> sleep in their
> >> implementations of the gpio_(set/get) functions.
> >>
> > 
> > Such GPIOs have a "cansleep" attribute, in short.
> > 
> > 
> >> Drivers, which use a gpio, may call gpio_(set/get)
> >> functions for a given
> >> gpio from a context where it is not safe to sleep.
> > 
> > And that's the call dontext
> > (in this case, from a driver).
> 
> Yes.
> 
> >   QED.  You are confusing two disparate concepts.
> 
> We are saying exactly the same thing.
> 
> > 
> >  In this
> >> case, a gpio
> >> which may sleep (ie one on an i2c io-expander) cannot be
> >> used with this
> >> driver. The gpio_request will succeed, but any call to
> >> gpio_(set/get)_value will produce a warning.
> >>
> >>>> example, if a driver calls gpio_get_value(gpio)
> >> from an
> >>>> interupt handler
> > 
> > 
> > (YOU introduce interrupt/IRQ handlers...)
> > 
> >>>> then the gpio must not be a sleeping gpio.
> >>> In a threaded IRQ handler it's OK to use
> >>> the get_value_cansleep() option..
> >> Ugh, you are really twisting my words.
> > 
> > 
> > You said IRQ handler, so did I.  In what csense could I
> > possibly be "twisting" your words"???
> > 
> > 
> > STOP TROLLING.
> 
> Okay, I messed up the wording an used 'interrupt handler' as an example
> of a non-sleep safe context. If I had said 'atomic' or 'spinlock'
> context you would probably be telling me off for missing some other
> non-sleep safe contexts.
> 
> The point is that we are discussing the issue of calls which may sleep.
> Even if I was not entirely clear by getting the wording wrong, you _do_
> know what I am talking about. You could correct on the bits on I get
> wrong instead of labeling me a troll.
> 
> If we strip my patch back to just introducing gpio_request_cansleep,
> which would be used in any driver where all of the calls are
> gpio_(set/get)_cansleep, and make gpio_request only allow non-sleeping
> gpios then incorrect use of gpios would be caught at request time and
> returned to the caller as an error.
I'm not sure that changing the API in this way is sensible.  I'd do
either what Jani Nikula suggested (i.e. substitute some WARN_ON(extra_checks
&& chip->can_sleep); by might_sleep_if(chip->can_sleep);) or
alternatively let gpio_get_value et al. return < 0 if they are called in
atomic context with chip->can_sleep != 0.  Maybe even return < 0
independant of the current context?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
