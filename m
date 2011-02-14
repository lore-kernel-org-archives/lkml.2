Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1BNWfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:35:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44495 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab1BNWfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:35:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 2/2] PM: Make system-wide PM and runtime PM handle subsystems consistently
Date: Mon, 14 Feb 2011 23:35:18 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Len Brown <lenb@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.44L0.1102141123370.1716-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1102141123370.1716-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102142335.18973.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 14, 2011, Alan Stern wrote:
> On Sat, 12 Feb 2011, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The code handling system-wide power transitions (eg. suspend-to-RAM)
> > can in theory execute callbacks provided by the device's bus type,
> > device type and class in each phase of the power transition.  In
> > turn, the runtime PM core code only calls one of those callbacks at
> > a time, preferring bus type callbacks to device type or class
> > callbacks and device type callbacks to class callbacks.
> > 
> > It seems reasonable to make them both behave in the same way in that
> > respect.  Moreover, even though a device may belong to two subsystems
> > (eg. bus type and device class) simultaneously, in practice power
> > management callbacks for system-wide power transitions are always
> > provided by only one of them (ie. if the bus type callbacks are
> > defined, the device class ones are not and vice versa).  Thus it is
> > possible to modify the code handling system-wide power transitions
> > so that it follows the core runtime PM code (ie. treats the
> > subsystem callbacks as mutually exclusive).
> > 
> > On the other hand, the core runtime PM code will choose to execute,
> > for example, a runtime suspend callback provided by the device type
> > even if the bus type's struct dev_pm_ops object exists, but the
> > runtime_suspend pointer in it happens to be NULL.  This is confusing,
> > because it may lead to the execution of callbacks from different
> > subsystems during different operations (eg. the bus type suspend
> > callback may be executed during runtime suspend, while the device
> > type callback will be executed during runtime resume).
> > 
> > Make all of the power management code treat subsystem callbacks in
> > a consistent way, such that:
> > (1) If the device's bus type is defined (eg. dev->bus is not NULL)
> >     and its pm pointer is not NULL, the callbacks from dev->bus->pm
> >     will be used.
> > (2) If dev->bus is NULL or dev->bus->pm is NULL, but the device's
> >     device type is defined (eg. dev->type is not NULL) and its pm
> >     pointer is not NULL, the callbacks from dev->type->pm will be
> >     used.
> > (3) If dev->bus is NULL or dev->bus->pm is NULL and dev->type is
> >     NULL or dev->type->pm is NULL, the callbacks from dev->class->pm
> >     will be used provided that both dev->class and dev->class->pm
> >     are not NULL.
> 
> It looks okay, but I haven't tested it.  Just one minor change needed 
> in the documentation:
> 
> > +All phases use bus, type, or class callbacks (that is, methods defined in
> > +dev->bus->pm, dev->type->pm, or dev->class->pm).  These callbacks are mutually
> > +exclusive, so if the bus provides a struct dev_pm_ops object pointed to by its
> > +pm field (i.e. both dev->bus and dev->bus->pm are defined), the callbacks
> > +included in that object (i.e. dev->bus->pm) will be used.  In turn, if the
> 
> s/In turn/Otherwise/

OK

> > +device type provides a struct dev_pm_ops object pointed to by its pm field
> > +(i.e. both dev->type and dev->type->pm are defined), the PM core will used the
> > +callbacks from that object (i.e. dev->type->pm).  Finally, if the pm fields of
> > +both the bus and device type objects are NULL (or those objects do not exist),
> > +the callbacks provided by the class (that is, the callbacks from dev->class->pm)
> > +will be used.
> >  
> >  These callbacks may in turn invoke device- or driver-specific methods stored in
> >  dev->driver->pm, but they don't have to.

Thanks,
Rafael
