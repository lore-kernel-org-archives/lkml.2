Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab1CGGuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 01:50:09 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60259 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1CGGuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 01:50:07 -0500
Date: Sun, 6 Mar 2011 23:50:02 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: Re: [PATCH v5 1/4] gpiolib: Add "unknown" direction support
Message-ID: <20110307065002.GA29999@angua.secretlab.ca>
References: <1299022100-14564-1-git-send-email-ptyser@xes-inc.com>
 <20110306072505.GC7467@angua.secretlab.ca>
 <4D73EC49.8030809@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D73EC49.8030809@bluewatersys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 09:19:21AM +1300, Ryan Mallon wrote:
> On 03/06/2011 08:25 PM, Grant Likely wrote:
> 
> > Back to sysfs:  The sysfs gpio interface is useful for many reasons,
> > but it is dangerous much in the same way that /dev/mem is dangerous.
> > It gives userspace unfettered access to gpio resources without any
> > clues about how it should be used.  I consider it bad practice to
> > depend on the gpio sysfs interface for any real system/application.
> 
> In an embedded system, where both the kernel and the userspace are
> provided by the hardware vendor, it can be completely sensible to rely
> on gpio numbers in userspace (though I would also like to see the sysfs
> interface able to use named access). There are some existing kernel
> interfaces for common gpio functions such as leds and input devices, but
> there are also many other valid uses for gpios. There are many reasons
> for the access code to be in userspace too: It may be easier to write
> and debug, depending on the setup of the device it may be easier to do
> firmware upgrades of userspace than it is for the kernel, etc.

I don't dispute any of the above points.  It is the sysfs interface
itself that I see as problematic.  It provides no discoverability and
it does not change the fact that once gpios are actually attached to
something they become specific purpose and users *absolutely must*
understand exactly what they are doing.

> > gpio numbers could easily change or become unavailable if a kernel
> > driver decides to use them (heck, I'd like to be rid of gpio
> > numbers entirely, but that's a separate debate). I'd much rather see
> > real device drivers be written for gpio interfaces instead of bodging
> > things together from userspace.  Since the addition of an 'unknown'
> > direction is solely for benefit of the sysfs interface, I don't (yet)
> > see a valid argument for adding it.  *Who cares* if sysfs might report
> > direction as 'input' inaccurately?
> 
> Because it is incorrect? It may also be useful for a userspace debug
> tool to request all available gpios and show the current direction and
> value of them.

If it was a simple & correct fix, then I'd have no problem with it.
The current proposed solution doesn't meet that criteria for me (more
below)

> 
> > It may be mildly inconvenient to a
> > human reader, but it doesn't change the usage model one iota because
> > the direction still must be explicitly set before using the gpio.
> 
> I agree that the usage model should be to request and then explicitly
> set the direction before use, but that isn't really an argument for
> exporting incorrect information to userspace. The ABI should attempt to
> prevent abuse of itself so that crappy userspace apps cannot be written.
> Either exporting the direction as "unknown" or making the direction file
> unreadable and the value file unreadable/unwritable until the direction
> has been explicitly set?

I'm far more interested in a solution that puts the onus on the GPIO
driver to populate the starting state at registration time, and
possibly to update it if it changes due to unrelated events.

Another consideration is that adding an 'unknown' value changes the
user space ABI, which must always be approached carefully.

> 
> > So, I'm going to say no to this patch.
> 
> The patch is small (it adds 9 lines) and fixes an incorrect value being
> exported to userspace.

It solves the problem at the wrong level.  Rather than having an
'unknown' state, I'm far more interested in a solution that pushed
back on the drivers to correctly initialize the gpio starting state
at gpiochip_add() time.  This would be both simpler and more correct
from my perspective.

And, yes, I do realize that some controllers cannot be probed for the
starting state, but I strongly suspect them to be a minority and
starting state can be handled with pdata in those cases.

> By your argument we should actually remove the
> ability to read the direction file in sysfs, since userspace must
> explicitly set it, and therefore knows what the direction is?

No, I'm arguing that the driver should provide good data from the
outset.  If it does not, then defaulting to 'input' is both a
reasonable assumption, and is safe.

g.
