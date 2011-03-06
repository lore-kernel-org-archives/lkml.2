Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab1CFHtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 02:49:31 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43616 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1CFHt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 02:49:28 -0500
Date: Sun, 6 Mar 2011 00:49:24 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/3] gpiolib: Add ability to get GPIO pin direction
Message-ID: <20110306074924.GB29325@angua.secretlab.ca>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
 <1297698493.965.5475.camel@petert>
 <20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
 <AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
 <20110214193502.101759d0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214193502.101759d0@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 07:35:02PM +0000, Alan Cox wrote:
> > What is the use-case for alt_func?  From the point of view of a GPIO
> > driver, I don't think it cares if the pin has been dedicated to
> 
> Currently it doesn't.
> 
> However the moment it starts setting input and output itself on requests
> then it does because it may kick the pin out of alt_func mode when you
> merely want to request it so you know which pin to stick into alt_func
> mode, or to find a mapping. The current situation is an "ignorance is
> bliss" one, but making it smarter backfires. We have the same problem
> with unknown state - if I have a set of pins some of whose state is known
> at boot time then I can't now provide a get_direction interface because
> of the lack of states. At the very least we need input/output/godknows
> where the latter means the gpio_request code keeps its nose out.

Not quite; the gpio api is only about discrete gpios.  If a particular
pin is dedicated to another non-gpio purpose, then from the POV of the
gpio api, the pin is disconnected from the outside world and any
twiddling of it just won't do anything.  If an alt_func has any driver
behaviour impact, then it needs to be handled internal to the driver.

> 
> 	reconfigure_resource();
> 	see_if_we_own_it()
> 
> is simply the wrong order for a resource.

Yes, this is broken.  gpio_request() should not change the state of
the resource.  I don't see anything in gpiolib that currently does
this.

> The second problem is that in many cases you need to call gpio_request to
> know you have the pin yourself before you can set the direction. That
> means forcing the direction in gpio_request is daft - you force an
> undefined value that cannot yet safely be set in all cases.
> 
> At the moment the lack of alt_func also has some strange effects and you
> end up with code like
> 
> foo_firmware_update()
> {
> 	/* Reserve the line for alt_func use for the moment */
> 	gpio_request(GPIO_FOO, "blah");
> 	random_gpio_driver_specific_altfunc_foo();
> 	do stuff();
> 	random_gpio_driver_specific_altfunc_foo();
> 	gpio_free(GPIO_FOO);
> 
> 	/* Now available again for its normal GPIO use */
> }
> 
> 
> and that means you can't generalise dynamic access to a shared GPIO pin
> without extra hardcoded knowledge.

I don't follow the argument.  Of course you have to do weird hardcoded
things when a gpio pin has to be shared between multiple purposes, but
that is also a weird corner case that won't fit any kind of common
pattern.  I don't see the above code snippet as a problem.

g.
