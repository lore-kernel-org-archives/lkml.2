Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab1BORGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:06:48 -0500
Received: from xes-mad.com ([216.165.139.218]:34042 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab1BORGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:06:45 -0500
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
In-Reply-To: <20110215114210.1f1a8470@lxorguk.ukuu.org.uk>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
	 <1297698493.965.5475.camel@petert>
	 <20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
	 <AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
	 <20110214193502.101759d0@lxorguk.ukuu.org.uk>
	 <1297726502.965.6921.camel@petert>
	 <20110215114210.1f1a8470@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 11:05:48 -0600
Message-ID: <1297789548.965.10101.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also, in most cases I'd think that the BIOS/U-Boot/firmware should have
> > configured the GPIO pins appropriately, which Linux should inherit in
> > general.  Linux currently inherits GPIO states that were set in firmware
> > when a GPIO is requested, but it doesn't properly report those values
> > via sysfs - that's the only bug I'm trying to fix.
> 
> Yes - however you can't fix it unless you are prepared to admit that the
> gpio has multiple states. At minimum you need to be able to report
> 
> 	input/output/unknown/unavailable
> 
> if you want to generalise it. Otherwise you don't solve the problem
> because you are asking a question that driver cannot answer correctly.

As far as the "unknown" state, I can update the patch to have the logic:
+       if (chip->get_direction) {
+               /* chip->get_direction may sleep */
+               spin_unlock_irqrestore(&gpio_lock, flags);
+               if (chip->get_direction(chip, gpio - chip->base) > 0)
+                       set_bit(FLAG_IS_OUT, &desc->flags);
+               spin_lock_irqsave(&gpio_lock, flags);
+       } else {
+               set_bit(FLAG_IS_UNKNOWN, &desc->flags);
+       }

This would have the side effect of having nearly all GPIO drivers
default to an "unknown" direction until they implement the new
get_direction() function, which I think is an improvement over the
current system where they are all unconditionally shown as "input",
often incorrectly.  Are you OK with this Grant?


For the "unavailable" state, I didn't think it would be necessary.  As
is, if someone calls gpio_request() on an invalid or alt_use pin, they
shouldn't get access to the GPIO, which makes the "unavailable value
moot since they couldn't access the GPIO in the first place.

Changing the logic to allow "unavailable" GPIO pins to be
requested/exported would require larger changes to the code, and
wouldn't provide much benefit without additional changes (eg an alt_func
feature).  So I'd vote to not add support for "unavailable" pins in this
patch and rather wait until someone has a specific use for it, and add
it then.

Peter

