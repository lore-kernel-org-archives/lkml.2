Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476Ab1GDSCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 14:02:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53748 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758153Ab1GDSCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 14:02:02 -0400
Date: Mon, 4 Jul 2011 12:01:59 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Greg KH <gregkh@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Message-ID: <20110704180159.GA11278@ponder.secretlab.ca>
References: <20110704170949.11059.92774.stgit@ponder>
 <20110704174126.GA26533@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704174126.GA26533@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 10:41:26AM -0700, Greg KH wrote:
> On Mon, Jul 04, 2011 at 11:11:59AM -0600, Grant Likely wrote:
> > Allow drivers to report at probe time that they cannot get all the resources
> > required by the device, and should be retried at a later time.
> 
> When is "later"?

In this case, after at least one other device has successfully probed.
The 'later' is handled in a workqueue that walks the list
asynchronously from normal initialization.

> And why would a driver not be able to get all of the proper resources?

Discussed below...

> Why can't a bus, at a later time, just try to reprobe everything when it
> determines that it is a "later" time now, without having to do this
> added change to the core?

It can't be done by a specific bus type because it has zero
relationship with the bus type.  For example, it is typical for an
SDHCI driver to require a GPIO line for the card detect switch, and
the device cannot be initialized until it has it.  However, the
bus_type that the SDHCI driver is attached to could be anything;
platform_bus_type, pci, amba, etc.  It isn't a bus_type deficiency,
but rather that the driver core has no way to gracefully handle
devices that get probed in an undetermined order.

It has to be done at the core level because any device in the system,
regardless of bus_type, may require another device to be probed first.
Originally I tried modifying the drivers to successfully probe
anyway and then 'go to sleep' to try again later, but it turned out to
push a lot of complexity into the device drivers when it can be solved
far more simply if the driver core has the ability to retry drivers
that request it.

Another example is sound on embedded systems.  A "sound card"
typically consists of multiple devices; one or more codecs (often i2c
or spi attached), a sound bus (often i2s), a dma controller, and a
lump of machine/platform specific code that ties them all together.
Right now the ASoC code is going through all kinds of gymnastics make
each component register with the ASoC layer and the 'tie together'
driver has to wait for each of them to show up.  As Mark will attest,
it is a lot of domain specific code that cannot be easily generalized
to be used by other subsystems.

I also could have implemented this without the deferred_probe list,
but doing so would have required every unbound device in the system to
be retried against every matching driver each time an -EAGAIN event
occurred.  I figured that would be rather excessive when the kernel
already has specific knowledge of devices that need to be retried.

> > This should completely solve the problem of getting devices
> > initialized in the right order.  Right now this is mostly handled by
> > mucking about with initcall ordering which is a complete hack, and
> > doesn't even remotely handle the case where device drivers are in
> > modules.  This approach completely sidesteps the issues by allowing
> > driver registration to occur in any order, and any driver can request
> > to be retried after a few more other drivers get probed.
> 
> Why would drivers in modules be an issue?  If a driver depends on
> another driver, making it a module dependancy would solve the problem,
> right?

Not nearly that simple.  Consider the case where driver A depends on a
gpio resource provided by driver B.  Well, driver A could depend on
driver B, but driver A has zero knowledge of what B actually is
because B is different for each system.

So, since A cannot depend on B because B is dynamic, the problem
cannot be solved with enforcing a module load order.

g.

