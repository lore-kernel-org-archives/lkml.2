Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab1GEOW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:22:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab1GEOW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:22:26 -0400
Date: Tue, 5 Jul 2011 07:21:49 -0700
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Message-ID: <20110705142149.GA3498@suse.de>
References: <20110704170949.11059.92774.stgit@ponder>
 <20110704174126.GA26533@suse.de>
 <20110704180159.GA11278@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704180159.GA11278@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 12:01:59PM -0600, Grant Likely wrote:
> On Mon, Jul 04, 2011 at 10:41:26AM -0700, Greg KH wrote:
> > On Mon, Jul 04, 2011 at 11:11:59AM -0600, Grant Likely wrote:
> > > Allow drivers to report at probe time that they cannot get all the resources
> > > required by the device, and should be retried at a later time.
> > 
> > When is "later"?
> 
> In this case, after at least one other device has successfully probed.
> The 'later' is handled in a workqueue that walks the list
> asynchronously from normal initialization.
> 
> > And why would a driver not be able to get all of the proper resources?
> 
> Discussed below...
> 
> > Why can't a bus, at a later time, just try to reprobe everything when it
> > determines that it is a "later" time now, without having to do this
> > added change to the core?
> 
> It can't be done by a specific bus type because it has zero
> relationship with the bus type.  For example, it is typical for an
> SDHCI driver to require a GPIO line for the card detect switch, and
> the device cannot be initialized until it has it.  However, the
> bus_type that the SDHCI driver is attached to could be anything;
> platform_bus_type, pci, amba, etc.  It isn't a bus_type deficiency,
> but rather that the driver core has no way to gracefully handle
> devices that get probed in an undetermined order.
> 
> It has to be done at the core level because any device in the system,
> regardless of bus_type, may require another device to be probed first.
> Originally I tried modifying the drivers to successfully probe
> anyway and then 'go to sleep' to try again later, but it turned out to
> push a lot of complexity into the device drivers when it can be solved
> far more simply if the driver core has the ability to retry drivers
> that request it.

So the driver core is just going to sit and spin and continue to try to
probe drivers for as long as it gets that error value returned?  What is
going to ever cause that loop to terminate?  It seems a bit hacky to
just keep looping over and over and hoping that sometime everything will
all settle down so that we can go to sleep again.

It just doesn't feel right, there has to be some other way to handle
stuff like this in a way that is known to terminate properly other than
just guessing.

greg k-h
