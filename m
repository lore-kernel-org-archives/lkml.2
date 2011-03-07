Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab1CGDHz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 22:07:55 -0500
Received: from xes-mad.com ([216.165.139.218]:38292 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab1CGDHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 22:07:54 -0500
Subject: Re: [PATCH v5 2/4] gpiolib: Add ability to get GPIO direction
From: Peter Tyser <ptyser@xes-inc.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20110306073003.GA29325@angua.secretlab.ca>
References: <1299022100-14564-1-git-send-email-ptyser@xes-inc.com>
	 <1299022100-14564-2-git-send-email-ptyser@xes-inc.com>
	 <20110306073003.GA29325@angua.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Mar 2011 21:07:21 -0600
Message-ID: <1299467241.11719.145.camel@ptyser-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-06 at 00:30 -0700, Grant Likely wrote:
> On Tue, Mar 01, 2011 at 05:28:18PM -0600, Peter Tyser wrote:
> > Add a new get_direction() function to the gpio_chip structure.  This is
> > useful so that the direction of a GPIO can be determined when its
> > initially exported.  Previously, the direction defaulted to "unknown"
> > regardless of the actual configuration of the GPIO.
> > 
> > If a GPIO driver implements get_direction(), it is called in
> > gpio_request() to set the initial direction of the GPIO accurately.
> 
> I don't like this approach.  It effectively creates two methods for
> determining the direction of a gpio; either ask the driver, or read
> the flags value.  Currently, only gpio_request() actually uses the
> first option, but it still leaves the ambiguity.
> 
> Instead, the driver should be able to preload the direction flag at or
> shortly after gpiochip_add() time.  No need for a new callback hook
> from what I can see.

The callback hook was used because the gpio_desc[] structure was local
to gpiolib.c.  The code would have to be restructured a bit to allow
drivers to set the flags themselves.  I can do that if you'd prefer, but
don't think it'd be all that much cleaner.

Also, I thought it made sense to read the direction of the GPIO in
gpio_request() because that's the point that the GPIO comes under the
GPIO subsystem's control.  Prior to that, there's a chance the direction
could be changed by platform code, or another driver, etc, so reading
the direction in gpiochip_add() may result in out-of-date directions.

The reading of the direction could also be put in chip drivers'
request() function.  That would get rid of the callback and still ensure
the direction is up-to-date.

I think the current patch seems cleaner than the alternatives, but will
change if you'd prefer.

Best,
Peter

