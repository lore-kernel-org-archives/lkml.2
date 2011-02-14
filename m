Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1BNTa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:30:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58273 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751139Ab1BNTa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:30:27 -0500
Date: Mon, 14 Feb 2011 19:35:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        "Uwe Kleine-K?nig" <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/3] gpiolib: Add ability to get GPIO pin direction
Message-ID: <20110214193502.101759d0@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
	<1297698493.965.5475.camel@petert>
	<20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
	<AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What is the use-case for alt_func?  From the point of view of a GPIO
> driver, I don't think it cares if the pin has been dedicated to

Currently it doesn't.

However the moment it starts setting input and output itself on requests
then it does because it may kick the pin out of alt_func mode when you
merely want to request it so you know which pin to stick into alt_func
mode, or to find a mapping. The current situation is an "ignorance is
bliss" one, but making it smarter backfires. We have the same problem
with unknown state - if I have a set of pins some of whose state is known
at boot time then I can't now provide a get_direction interface because
of the lack of states. At the very least we need input/output/godknows
where the latter means the gpio_request code keeps its nose out.

	reconfigure_resource();
	see_if_we_own_it()

is simply the wrong order for a resource.


The second problem is that in many cases you need to call gpio_request to
know you have the pin yourself before you can set the direction. That
means forcing the direction in gpio_request is daft - you force an
undefined value that cannot yet safely be set in all cases.

At the moment the lack of alt_func also has some strange effects and you
end up with code like

foo_firmware_update()
{
	/* Reserve the line for alt_func use for the moment */
	gpio_request(GPIO_FOO, "blah");
	random_gpio_driver_specific_altfunc_foo();
	do stuff();
	random_gpio_driver_specific_altfunc_foo();
	gpio_free(GPIO_FOO);

	/* Now available again for its normal GPIO use */
}


and that means you can't generalise dynamic access to a shared GPIO pin
without extra hardcoded knowledge.

In the case of a fixed pin its easy as you can either a) not register it
or b) just gpio_request it at boot and whack it in arch code, but if you
want to go beyond that it gets interesting.

Alan
