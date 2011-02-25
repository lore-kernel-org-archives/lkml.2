Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab1BYIyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 03:54:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:37636 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294Ab1BYIyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 03:54:07 -0500
Subject: Re: [RFC PATCH 01/15] dt/powerpc: move of_bus_type infrastructure
 to ibmebus
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <201102241546.48790.arnd@arndb.de>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
	 <20110223043340.20795.84024.stgit@localhost6.localdomain6>
	 <201102241546.48790.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 19:53:39 +1100
Message-ID: <1298624019.8833.607.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 15:46 +0100, Arnd Bergmann wrote:
> On Wednesday 23 February 2011, Grant Likely wrote:
> > arch/powerpc/kernel/ibmebus.c is the only remaining user of the
> > of_bus_type support code for initializing the bus and registering
> > drivers.  All others have either been switched to the vanilla platform
> > bus or already have their own infrastructure.
> > 
> > This patch moves the functionality that ibmebus is using out of
> > drivers/of/{platform,device}.c and into ibmebus.c where it is actually
> > used.  Also renames the moved symbols from of_platform_* to
> > ibmebus_bus_* to reflect the actual usage.
> > 
> > This patch is part of moving all of the of_platform_bus_type users
> > over to the platform_bus_type.
> > 
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> 
> The ibmebus is essentially the platform bus of the IBM Power Systems (a.k.a.
> pSeries a.k.a. System p), I think it would make a lot of sense to convert
> the two drivers (ehca and ehea) on this bus into platform drivers as well.
> 
> The original reason for this bus was to provide a different IOMMU for them
> than what is used on the PCI devices. This should now be possible in simpler
> ways.

Well, it's really the IBM "GX" bus but yeah, it could be converted I
suppose. The "special" iommu functions mostly derive from the fact that
the two adapters we are interested in have their own translation
mechanism built-in. The GX bus sits "above" the TCEs used as an iommu on
these systems.

> > +static void ibmebus_bus_device_shutdown(struct device *dev)
> > +{
> > +	struct platform_device *of_dev = to_platform_device(dev);
> > +	struct of_platform_driver *drv = to_of_platform_driver(dev->driver);
> > +
> > +	if (dev->driver && drv->shutdown)
> > +		drv->shutdown(of_dev);
> > +}
> 
> neither of the drivers provides a shutdown function.

Right but they might grow one ... and people will wonder why it doesn't
work if you remove the above :-)

 .../...

> These are also unused in the drivers.

Same reasoning, however it becomes moot if we convert them to platform.

Cheers,
Ben.


