Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab1CFHxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 02:53:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38308 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1CFHxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 02:53:38 -0500
Date: Sun, 6 Mar 2011 00:53:34 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/3] gpiolib: Add ability to get GPIO pin direction
Message-ID: <20110306075334.GC29325@angua.secretlab.ca>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
 <1297698493.965.5475.camel@petert>
 <20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
 <AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
 <20110214193502.101759d0@lxorguk.ukuu.org.uk>
 <1297726502.965.6921.camel@petert>
 <20110215114210.1f1a8470@lxorguk.ukuu.org.uk>
 <1297789548.965.10101.camel@petert>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297789548.965.10101.camel@petert>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 11:05:48AM -0600, Peter Tyser wrote:
> > > Also, in most cases I'd think that the BIOS/U-Boot/firmware should have
> > > configured the GPIO pins appropriately, which Linux should inherit in
> > > general.  Linux currently inherits GPIO states that were set in firmware
> > > when a GPIO is requested, but it doesn't properly report those values
> > > via sysfs - that's the only bug I'm trying to fix.
> > 
> > Yes - however you can't fix it unless you are prepared to admit that the
> > gpio has multiple states. At minimum you need to be able to report
> > 
> > 	input/output/unknown/unavailable
> > 
> > if you want to generalise it. Otherwise you don't solve the problem
> > because you are asking a question that driver cannot answer correctly.
> 
> As far as the "unknown" state, I can update the patch to have the logic:
> +       if (chip->get_direction) {
> +               /* chip->get_direction may sleep */
> +               spin_unlock_irqrestore(&gpio_lock, flags);
> +               if (chip->get_direction(chip, gpio - chip->base) > 0)
> +                       set_bit(FLAG_IS_OUT, &desc->flags);
> +               spin_lock_irqsave(&gpio_lock, flags);
> +       } else {
> +               set_bit(FLAG_IS_UNKNOWN, &desc->flags);
> +       }
> 
> This would have the side effect of having nearly all GPIO drivers
> default to an "unknown" direction until they implement the new
> get_direction() function, which I think is an improvement over the
> current system where they are all unconditionally shown as "input",
> often incorrectly.  Are you OK with this Grant?

Not really, no.  Defaulting to "input" may be incorrect, but it is
always safe, it it should only be a minor inconvenience to human users
of the sysfs interface.  Actual usage of a gpio pin must always be to
explicitly set the direction before using a pin.


> Changing the logic to allow "unavailable" GPIO pins to be
> requested/exported would require larger changes to the code, and
> wouldn't provide much benefit without additional changes (eg an alt_func
> feature).  So I'd vote to not add support for "unavailable" pins in this
> patch and rather wait until someone has a specific use for it, and add
> it then.

Agreed.

g.
