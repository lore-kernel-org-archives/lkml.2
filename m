Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab1BORTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:19:46 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57286 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752014Ab1BORTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:19:42 -0500
Date: Tue, 15 Feb 2011 17:19:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/3] gpiolib: Add ability to get GPIO pin direction
Message-ID: <20110215171915.384223b6@lxorguk.ukuu.org.uk>
In-Reply-To: <1297789548.965.10101.camel@petert>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
	<1297698493.965.5475.camel@petert>
	<20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
	<AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
	<20110214193502.101759d0@lxorguk.ukuu.org.uk>
	<1297726502.965.6921.camel@petert>
	<20110215114210.1f1a8470@lxorguk.ukuu.org.uk>
	<1297789548.965.10101.camel@petert>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

This doesn't solve anything. If the hardware supports alt_func state then
it now can't implement get_direction, so that's useless.
 
> For the "unavailable" state, I didn't think it would be necessary.  As
> is, if someone calls gpio_request() on an invalid or alt_use pin, they
> shouldn't get access to the GPIO, which makes the "unavailable value
> moot since they couldn't access the GPIO in the first place.

In a word 'sysfs'

We need FLAG_IS_UNKNOWN (or saner would be FLAG_IS_IN to go with
FLAG_IS_OUT) to make the sysfs code report properly (and some other spots
fixing to make it work right)

If you add FLAG_IS_UNKNOWN then the other change you need is in

gpio_direction_show() which needs to also check the UNKNOWN bit and
report appropriately. That would fix that problem and at least allow the
reporting side of GPIO in use for something else to be handled as a
platform thing even though it can't be handled properly.

The combination of RESERVED & EXPORTED is also busted but is actually
sensible - that I gues should report reserved and fail the set operations.


