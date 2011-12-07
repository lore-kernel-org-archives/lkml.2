Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab1LGTqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:46:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620Ab1LGTqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:46:14 -0500
Message-ID: <1323287120.15059.63.camel@bling.home>
Subject: Re: RFC: Device isolation infrastructure
From: Alex Williamson <alex.williamson@redhat.com>
To: David Gibson <dwg@au1.ibm.com>
Cc: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, aik@au1.ibm.com,
        linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com,
        benh@kernel.crashing.org
Date: Wed, 07 Dec 2011 12:45:20 -0700
In-Reply-To: <20111207142201.GA5696@truffala.fritz.box>
References: <20111207035816.GC7631@truffala.fritz.box>
	 <1323240402.2182.241.camel@bling.home>
	 <20111207142201.GA5696@truffala.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 01:22 +1100, David Gibson wrote:
> On Tue, Dec 06, 2011 at 11:46:42PM -0700, Alex Williamson wrote:
> > On Wed, 2011-12-07 at 14:58 +1100, David Gibson wrote:
> > > 
> > > Alex Williamson recently posted some patches adding a new hook to
> > > iommu_ops to identify groups of devices which cannot reliably be
> > > distinguished by the iommu, and therefore can only safely be assigned
> > > as a unit to a guest or userspace driver.
> > > 
> > > I'm not very fond of that design, because:
> > >     - It requires something else to scan the group ids to present the
> > > groups in a userspace discoverable manner, rather than handling that
> > > in the core.
> > 
> > The thought was that the vast majority of users won't make use of
> > groups, so why bloat the core when the only user is vfio.  
> 
> Well, "won't make use of" actually means "are on a system with
> all-singleton groups".  And the answer is because it actually doesn't
> bloat, but simplifies the core.  We need the group concept _at
> minimum_ to handle bridges and buggy multifunction devices.  So it
> makes life easier to assume they're always there, even if they're
> often singletons.

Ok, let's back up from the patch because I think its clouding the driver
model with a detached device state that might be detracting from the
useful bits.

An isolation group is a generic association of devices into a set based
on, well... isolation.  Presumably something like an iommu driver does a
bus_register_notifier() and bus_for_each_dev() and when a new device is
added we do isolation_group_new() and isolation_group_dev_add() as
necessary.  When the iommu driver needs to do a dma_ops call for a
device, it can traverse up to the isolation group and find something
that points it to the shared iommu context for that group.  While
dma_ops can share the iommu context among the drivers attached to the
various devices, iommu_ops wants a single meta-driver for the group
because it's predominantly designed for use when devices are exposed
directly to the user.  We trust native kernel drivers to share context
between each other, we do not trust user level drivers to share context
with anyone but themselves.  Ok so far?

The first question we run into is what does the iommu driver do if it
does not provide isolation?  If it's a translation-only iommu, maybe it
has a single context and can manage to maintain it internally and should
opt-out of isolation groups.  But we also have things like MSI isolation
where we have multiple contexts and the isolation strength is sufficient
for dma_ops, but not iommu_ops.  I don't know if we want to make that
determination via a strength bitmask at the group level or simply a bool
that the iommu driver sets when it registers a group.

Once we store iommu context at the group, it makes sense to start using
it as the primary object the iommu drivers operate on.  There's no need
to break everyone for dma_ops, so isolation aware iommu drivers can
simply follow the link from the device to the group with no change to
callers.  iommu_ops though can switch to being entirely group based [not
looking forward to retrofitting groups into kvm device assignment].

So the next problem is that while the group is the minimum granularity
for the iommu, it's not necessarily the desired granularity.  iommus
like VT-d have per PCI BDF context entries that can point to shared page
tables.  On such systems we also typically have singleton isolation
groups, so when multiple devices are used by a single user, we have a
lot of duplication in time and space.  VFIO handles this by allowing
groups to be "merged".  When this happens, the merged groups point to
the same iommu context.  I'm not sure what the plan is with isolation
groups, but we need some way to reduce that overhead.

Finally, we get to how do we manage the devices of the group when we
switch to iommu_ops mode vs dma_ops, which is what this patch seems to
have started with.  For VFIO we have bus specific drivers which attach
to individual devices.  When all the devices in the group are attached
to the bus driver (by the user), iommu_ops, and therefore access to
devices from userspace becomes available.

This is the level that the vast majority of users are not going to make
use of, so while the above does feel cleaner and justifies it's
addition, we need to be careful here.

My concern with the "detached state" approach is that we're removing
devices from the existing driver model.  Who does things like pm_runtime
callbacks when we start using devices?  How does a driver enumerate and
attach to devices within the group?  How do we even enumerate and attach
to isolation groups for the group level metadriver?  This is where I'm
nervous we're just making a requirement for a group-driver model that
lives alongside the existing device driver model.

I actually like the approach that individual devices are bound by the
user to vfio bus drivers (group/iommu_ops drivers).  This is tedious,
but easily automate-able in userspace and puts the responsibility of
unbinding each device on the user.  Imagine the chaos a user could cause
if vfio creates a chardev for accessing a group, we give a user access
to it, and each time it's opened all the group devices automatically get
unbound from the host drivers and re-bound on close.  'while (true); do
cat /dev/vfio/$GROUP; done' could cause a denial of service on the
system.

We just need to figure out how binding vfio bus drivers to all the
isolation group devices turns the robot lions into Voltron ;)

> > >     - It does not provide an obvious means to prevent a kernel
> > > driver unsafely binding to a new device which is hotplugged into an
> > > iommu group already assigned to a guest.
> > 
> > I've added this for PCI, triggered via the device add notifier.
> 
> Hrm.  Does the notifier run early enough to guarantee that a driver
> can't bind before it's complete?

Yes, like I assume you're planning to do with setting up groups, it runs
from the device add bus notifier.  Thanks,

Alex

