Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab1JNSjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:39:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41640 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752489Ab1JNSjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:39:36 -0400
Date: Fri, 14 Oct 2011 14:39:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Grant Likely <grant.likely@secretlab.ca>
cc: Ming Lei <tom.leiming@gmail.com>, Andrei Warkentin <awarkentin@vmware.com>,
        Greg KH <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        "G, Manjunath Kondaiah" <manjugk@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>, <Manjunath@jasper.es>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linux PM List <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
In-Reply-To: <CACxGe6sc8qOWDvLYSKwUzG8-VEZCXDKQX88qQsFYuP2QtEHvFg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1110141432070.2036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Grant Likely wrote:

> > However D sometimes does defer probes.  Therefore the device always
> > needs to be moved, even though this particular probe wasn't deferred.
> 
> Yes, that's part of my point.

Okay, then we agree. :-)

> So the argument is that if really_probe() called dpm_move_last()
> immediately before the dev->bus->probe()/drv->probe() call then there
> is a race condition that G could get both registered and probed before
> D's probe() starts using G's resources.  And so, the list would still
> have G after D which is in the wrong order.  Do I understand
> correctly?

Exactly so.

> > Devices need to be moved whenever they have any external dependencies,
> > regardless of the particular order they get probed in.
> 
> I suspect this gets messy in a hurry, but perhaps it is worth trying.
> So, any device that makes use of a PHY, GPIO line, codec, etc will
> need to call dpm_move_last() before adding child devices, correct?

Pretty much, yes.  Unless the driver somehow knows that it will become
sufficiently idle at an early suspend stage (like the prepare callback) 
that it doesn't need to use the PHY, GPIO, codec, etc.

> I'd be much happier to find a way to do this in core code though.  And
> there is still a potential race condition here.  For example, if G is
> in the middle of it's probe routine, and D gets probed between G
> registering GPIOs and calling dpm_move_last(), then we're in the same
> boat again.

Of course, this means that G must call dpm_move_last() _before_ 
registering its GPIOs.  So the overall flow of a probe routine is 
simple enough:

	1. Check that all the resources you need are available.

	2. If not, defer your probe.  If yes, call dpm_move_last().

	3. Finish the probe, including registration of resources
	   that will be available to other drivers (such as child
	   devices).

>  I think the window for this race can be considered to be
> of the same magnitude as the moved to early race described above.  I
> need to think about this more...

Alan Stern

