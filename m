Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab1DFMdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:33:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33034 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab1DFMdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:33:20 -0400
Date: Wed, 6 Apr 2011 14:33:10 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, kernel@pengutronix.de
Subject: Re: [PATCH v2] leds: provide helper to register "leds-gpio" devices
Message-ID: <20110406123310.GD13963@pengutronix.de>
References: <20110405163338.GA11832@n2100.arm.linux.org.uk>
 <1302035048-25819-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1302090738.22904.8.camel@rex>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302090738.22904.8.camel@rex>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Richard,

On Wed, Apr 06, 2011 at 04:52:18AM -0700, Richard Purdie wrote:
> On Tue, 2011-04-05 at 22:24 +0200, Uwe Kleine-König wrote:
> > This function makes a deep copy of the platform data to allow it to live
> > in init memory.
> > The definition cannot go into leds-gpio.c because it needs to be builtin
> > to be usable by platforms.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> > changes since v1:
> >  - don't add __init to the declaration of gpio_led_register_device
> > 
> >  drivers/leds/led-core.c |   27 ++++++++++++++++++++++++++-
> >  include/linux/leds.h    |   12 ++++++++++++
> >  2 files changed, 38 insertions(+), 1 deletions(-)
> 
> Can you explain the reasoning for this a little further please? It
> sounds like instead of leaving the platform data in memory (which is
> reasonable since we need it), we're now adding code to make a copy of
> this data so we can remove the original. Why?
> 
> I have a rather strong dislike of adding "always builtin" functions as
> they suggest something is wrong with the approach. led-core.c has always
> been intentionally as minimal as we could get it.
> 
> In times when things like boot time are important it also seems like bad
> form to be copying data around just so we can throw one copy away during
> the boot process. What memory savings (which I assume is the
> motivation?) is this giving us at what cost?
> 
> I guess the motivation might be that if a given platform has many
> different LED configurations, you're trying to remove the ones you don't
> need from memory? Given all the above I'd suggest that this function
> should really be added to the platform device code if anywhere and
"platform device code" means e.g. arch/arm/plat-mxc or drivers/base
here?

> doesn't belong in the LED subsystem as its not an LED specific problem.
yeap, that's it. Note that this thread[1] started on the linux-arm-kernel
mailing list with a imx-specific version of this function. With the
background of Linus' recent rant against churn in arch/arm several
people pointed out that this can better go to a more generic place where
not only arm/imx, but also arm/omap and even powerpc can use the same
code. So the (IMHO) obvious place to put the code is near the driver.

And yes, the problem is not LED specific, but a function that creates
and registers a leds-gpio device *is* LED specific. A while back I
thought about introducing something like drivers/register/*, but I'm
sure this won't scale. Either you need a header per device type (or at
subsystem) or a single header. Both look ugly in my eyes. Having the
prototype in include/linux/leds.h seems the right thing, because
platform code needs to include that anyhow to provide a struct
gpio_led_platform_data.

I don't consider something wrong here, because the Linux device model
requires that you have a driver and a device. Both have to match and the
device (usually) is created at boot time. Because of the needed match
it's natural to have device use (aka driver) and device creation at the
same place. Because of the boot time thing the code needs to be
built-in.

Best regards
Uwe

[1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/112485

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
