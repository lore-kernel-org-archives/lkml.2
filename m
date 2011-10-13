Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab1JMRiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 13:38:20 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38201 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab1JMRiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 13:38:18 -0400
Date: Thu, 13 Oct 2011 11:15:39 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <tom.leiming@gmail.com>, Andrei Warkentin <awarkentin@vmware.com>,
        Greg KH <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        "G, Manjunath Kondaiah" <manjugk@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Manjunath@jasper.es,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux PM List <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
Message-ID: <20111013171539.GA18574@ponder.secretlab.ca>
References: <CACVXFVNXyzzJw7UK+OFuDe23voQvyywoP9AvUsV=iPDFPO4fPw@mail.gmail.com>
 <Pine.LNX.4.44L0.1110131029510.2026-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1110131029510.2026-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 10:31:45AM -0400, Alan Stern wrote:
> On Thu, 13 Oct 2011, Ming Lei wrote:
> 
> > >> Inside device_add(), device_pm_add is called before bus_probe_device,
> > >> so the patch can't change the device order in pm list, and just change
> > >> the driver probe order.
> > >
> > > That's the way it works now, but can it be reworked? ?It would be
> > 
> > IMO, it depends on what shape you plan to rework.  Currently, the
> > deferred probe may found a resource dependency, but I am not sure
> > that pm dependency is same with the resource dependency found
> > during probe.
> > 
> > > possible to adjust the list order after successful probe. ?However,
> > > I'm not clear on the ordering rules for the dpm_list. ?Right now it is
> > > explicitly ordered to have parents before children, but as already
> > > expressed, that doesn't accurately represent ordering constraints for
> > > multiple device dependancies.
> > 
> > Maybe we should understand the correct model of the ordering constraints
> > for the multiple device dependancies first, could you give a description or
> > some examples about it?
> 
> The requirement is that devices must be capable of resuming in the 
> order given by dpm_list, and they must be capable of suspending in 
> the reverse order.
> 
> Therefore if device A can't work unless device B is functional, then B 
> must come before A in dpm_list.

For the deferred case; here is an example of the additional
constraint.  Consider the following hierarchy:

-A
 +-B
 | +-C
 | +-D
 |
 +-E
   +-F
   +-G

dpm_list could be ordered in at least the following ways (depending on
exactly when devices get registered).  There are many permutation, but
children are always be listed after its direct parent.

1) ABECDFG (breadth first)
2) AEBFGCD (breadth first)
3) ABCDEFG (depth first)
4) AEFGBCD (depth first)

Now, assume that device B depends on device F, and also assume that
there is no way either to express that in the hierarchy or even for
the constraint to be known at device registration time (the is exactly
the situation we're dealing with on embedded platforms).  Only the
driver for B knows that it needs a resource provided by F's driver.
So, the situation becomes that the ordering of dpm_list must now also
be sorted so that non-tree dependencies are also accounted for.  Of
the list above, only sort order 4 meets the new constraint.

The question then becomes, how can the dpm_list get resorted
dynamically at runtime to ensure that the new constraints are always
met without breaking old ones.  Here are some options I can think of:

1) When a deferred probe succeeds, move the deferred device to the
end of the dpm_list.  Then the new sort order might be one of:

	1) AECDFGB
	2) AEFGCDB
	3) ACDEFGB
	4) AEFGCDB

However, that approach breaks the guarantee that children appear after
their parents (C & D appear before B in all cases above)

2a) When a deferred probe succeeds, move the deferred device and it's
entire child hierarchy to the end of the list to become one of:

	1) AEFGBCD
	2) AEFGBCD
	3) AEFGBCD
	4) AEFGBCD (hey! they're all the same now, but there are other
			orderings possible that aren't)  :-)

Problem: Complexity increases.  This requires iterating through all
the children and performing a reorder for each.  Fortunately, this
should be too expensive since I believe each individual move is an
O(1) operation.  I don't think the code will need to walk the list for
each device.

Potential problem: This may result in unnecessary sorting in a lot of
cases.  It may be that the newly probed device is already after the
device it depends on, but the driver just hadn't been probed early
enough to avoid deferral.

Potential problem: It may end up exposing implicit dependencies
between drivers that weren't observed before.

Potential problem: This completely breaks if a parent gets probed
*after* its child which might happen if something other than the
parent driver creates the child devices.  I don't think this is a real
problem, but I think the kernel would first need to ensure that none
of the children are bound to drivers, and complain loudly if they are.
Otherwise the dpm_list won't reflect probe order.

2b) alternately, when *any* probe succeeds, move the deferred device
and its children to the end of the list.  This continues to maintain
the parent-child relationship, and it ensures that the dpm_list is
always also sorted in probe-order (devices bound to drivers will
collect at the end of the list).

Potential problem: On a big device hierarchy, this will mean a lot of
moves.  It should still only be O(1) for each move, but O(N^2) over
probing the entire hierarchy.  Devices will end up being moved once
for itself, and once for each parent and grandparent bound to a
driver.  It could become slow.

This option also has the potential problem when a parent gets probed
after its child as discussed in 2a.

3) Add devices to dpm_list after successful probe instead of at
device_add time.

Potential problem: this means that only devices with drivers actually
get suspend/resume calls.  I don't know nearly enough about the PM
subsystem, but I suspect that this is a problem.

4) ignore parent-child relationships entirely and just move devices to
the end of the list on successful probe.  If it probed successfully,
then it can be successfully suspended regardless of whether it has any
children.  That breaks the parent-child ordering, but guarantees the
probe order ordering.  Any devices without drivers will end up
collecting at the beginning of the list, and will be suspended after
all the devices with drivers.

Problem: Same as with 3, I suspect that even devices without drivers
need to process PM suspend, which makes this option unworkable.

...

For my money, I think that option 2b shows the most promise despite
the potential O(N^2) complexity.  There may be a better algorithm for
doing the runtime reordering that isn't O(N^2) that I haven't thought
of.  Having a list that is strongly ordered both on hierarchy *and*
probe order I think is the right thing to do, even without deferred
probe support.

g.

> Alan Stern
> 
