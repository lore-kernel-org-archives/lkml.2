Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1BNXfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:35:50 -0500
Received: from xes-mad.com ([216.165.139.218]:30962 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab1BNXfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:35:39 -0500
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
In-Reply-To: <20110214193502.101759d0@lxorguk.ukuu.org.uk>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
	 <1297698493.965.5475.camel@petert>
	 <20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
	 <AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
	 <20110214193502.101759d0@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 17:35:02 -0600
Message-ID: <1297726502.965.6921.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 19:35 +0000, Alan Cox wrote:
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
> 
> 	reconfigure_resource();
> 	see_if_we_own_it()
> 
> is simply the wrong order for a resource.

It looks like most drivers that implement a chip-specific request()
function do check if the gpio pin is available for use prior to
reconfiguring it.  If a pin is reserved for an alt_func, the request
fails and the pin is not touched.  Seems like adding a well coded
chip-specific request() function to drivers where necessary would
resolve your concern about reconfiguring pins before checking ownership?

> The second problem is that in many cases you need to call gpio_request to
> know you have the pin yourself before you can set the direction. That
> means forcing the direction in gpio_request is daft - you force an
> undefined value that cannot yet safely be set in all cases.

My understanding is that gpio_request() doesn't generally force a
direction, it just sets up the pin for use, or checks to make sure the
pin could be used.  Most chip's don't have their own request() function
and thus don't touch hardware at all.  For those that do have their own
request() function, they don't appear to force a value in many cases.

Also, in most cases I'd think that the BIOS/U-Boot/firmware should have
configured the GPIO pins appropriately, which Linux should inherit in
general.  Linux currently inherits GPIO states that were set in firmware
when a GPIO is requested, but it doesn't properly report those values
via sysfs - that's the only bug I'm trying to fix.

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

Are there many cases where people need to swap a pin from GPIO to alt
functionality, and back again in Linux?  I have never seen them used
like that; generally they are either wired up to an alt_func device (I2C
pins, serial pins, etc), or as a GPIO - not both dynamically.  If some
hardware does need to do that, isn't it very chipset/board specific?  I
guess I'm just not really grasping the big advantage of the alt_func
feature, or how it'd be implemented as common code.  It looks like there
was a thread about it back in 2009 that didn't go anywhere:
http://thread.gmane.org/gmane.linux.kernel/851818

The current GPIO implementation has worked well for my usage scenarios,
so you may have to be blunt with me as far as what your looking for:)

Thanks,
Peter 

