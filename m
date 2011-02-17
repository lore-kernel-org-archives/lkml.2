Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab1BQRIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:08:06 -0500
Received: from kroah.org ([198.145.64.141]:54464 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559Ab1BQRIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:08:04 -0500
Date: Thu, 17 Feb 2011 09:04:41 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Len Brown <lenb@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC][PATCH 2/2] PM: Make system-wide PM and runtime PM handle
 subsystems consistently
Message-ID: <20110217170441.GA31809@kroah.com>
References: <201102170045.48975.rjw@sisk.pl>
 <Pine.LNX.4.44L0.1102170951330.2153-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1102170951330.2153-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 09:55:46AM -0500, Alan Stern wrote:
> On Thu, 17 Feb 2011, Rafael J. Wysocki wrote:
> 
> > > > Apart from this I think the order of checks introduced by the $subject patch
> > > > should be:
> > > > (1) If dev->class != NULL and dev->class->pm != NULL, use dev->class,
> > > >     or otherwise
> > > > (2) if dev->type != NULL and dev->type->pm != NULL, use dev->type,
> > > >     or otherwise
> > > > (3) use dev->bus (if present).
> > > > as that would allow classes and device types to override bus type PM
> > > > callbacks if they wish to.
> > > 
> > > I haven't heard of any device types being present on more than one kind
> > > of bus, so it makes sense for device types to override bus types.
> > 
> > OK
> > 
> > > But I'm not so sure about the priority we should give to classes.  On the
> > > other hand, if no classes define a dev_pm_ops then of course it doesn't
> > > matter.
> > 
> > The change will also affect classes that provide "legacy" suspend-resume
> > (if there are any, which I'm totally unsure of).
> > 
> > Anyway, I think we need to choose one ordering. :-)
> > 
> > What about type / bus / class , then?
> 
> I really don't know.  Somebody who has more experience with device 
> class implementations should answer.
> 
> Greg, any ideas?
> 
> To recap: The issue is how to handle multiple PM callbacks.  Since the
> bus type, device type, and device class may all have their own
> callbacks, Rafael has decided the best approach is to prioritize them
> and invoke only the highest-priority callback.  But what priority order
> should we use?

I think we should do it in the following order:
	device type
	device class
	device bus

for the reasons that a device itself could override the default class
and bus information if it "knows" it is special.  After that, the class
of the device holds a lot of information about what is going on with the
logic involved (i.e. network stuff), and lastly, the bus knows some
default hardware information.

Sound reasonable?

I think that follows the default we have today, right?

thanks,

greg k-h
