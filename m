Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab0FXAEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 20:04:13 -0400
Received: from mail2.shareable.org ([80.68.89.115]:33266 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab0FXAEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 20:04:12 -0400
Date: Thu, 24 Jun 2010 01:04:03 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux kernel <linux-kernel@vger.kernel.org>,
       ext-jani.1.nikula@nokia.com,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and sleeping gpios)
Message-ID: <20100624000403.GH7058@shareable.org>
References: <191168.5104.qm@web180308.mail.gq1.yahoo.com> <4C21955D.1020502@bluewatersys.com> <20100623225345.GD7058@shareable.org> <4C22936F.9050300@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C22936F.9050300@bluewatersys.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan Mallon wrote:
> On 06/24/2010 10:53 AM, Jamie Lokier wrote:
> > Ryan Mallon wrote:
> >> On 06/23/2010 04:37 PM, David Brownell wrote:
> >> I'm not. Some gpios, such as those on io expanders, may sleep in their
> >> implementations of the gpio_(set/get) functions.
> > 
> > I'm having a hard time figuring out where some GPIOs I'm using fit
> > into this picture.
> > 
> > I have some hardware that is currently using a 2.4.26 kernel, but I
> > look from time to time at forward-porting all the drivers to 2.6.recent.
> > 
> > It has an I2C driven GPIO expander, with a watchdog reset chip hanging
> > off the expander.
> > 
> > The watchdog is kept alive off the back end of a timer BH, which means
> > the I2C GPIO routines are written to be safe in BH context (which
> > isn't sleepable), but they can't be used in IRQ context because the
> > necessary spin_lock_irqsave() would turn off interrupts for too long
> > for other subsystems to function properly.
> 
> Do the implementations of the get/set calls for the io expander gpios
> sleep at all?

No, because sleeping isn't allowed in BH context.  (Note that this is
2.4.26 code - things have changed a bit for 2.6, but the hardware is
the same, and still needs the I2C watchdog to be driven from a BH-like
context).

> > How should I flag those GPIO routines in your scheme?  They're safe to
> > use in some non-sleeping contexts, but not safe in irq context.
> 
> The idea in my proposal is to use gpio_request in a driver if the
> requested gpio can never sleep (ie because of the context it is used
> in), and gpio_request_cansleep if the gpio is never used from non-sleep
> safe context in a driver. I suggested stripping back the patch to just
> add the gpio_request_cansleep function.
> 
> In the current code, if a driver ever calls gpio_(set/get)_value on a
> gpio then you cannot pass a sleeping gpio to that driver. The request
> will succeed, but you will get warnings with the get/get calls are made.
> My idea is basically to move the denotation of whether a gpio will be
> used in non-sleep safe context to the gpio request.

The reason I'm asking about my scenario is because the GPIO routines
can't sleep and are used from a non-sleep safe context - but they are
not safe to call in irq contexts.

So my watchdog driver would have to call gpio_request (not _cansleep)
- that's fine.  But if I connected other GPIOs from the same GPIO
driver (other lines on the same I/O expander chip) to another
GPIO-using driver which happens to use them from irq context, then
your changes won't detect the problem - the code will just break at
runtime.

Of course if I did that, it would be my fault and my problem.  I get
to keep both pieces etc.  But it's a scenario which your proposal
would fail to catch at compile time, that's why I bring it up.

-- Jamie
