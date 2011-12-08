Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1LHO2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 09:28:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab1LHO2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 09:28:50 -0500
Message-ID: <1323354505.24340.111.camel@bling.home>
Subject: Re: RFC: Device isolation infrastructure
From: Alex Williamson <alex.williamson@redhat.com>
To: David Gibson <dwg@au1.ibm.com>
Cc: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, aik@au1.ibm.com,
        linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com,
        benh@kernel.crashing.org
Date: Thu, 08 Dec 2011 07:28:25 -0700
In-Reply-To: <20111208065216.GA9107@truffala.fritz.box>
References: <20111207035816.GC7631@truffala.fritz.box>
	 <1323240402.2182.241.camel@bling.home>
	 <20111207142201.GA5696@truffala.fritz.box>
	 <1323287120.15059.63.camel@bling.home>
	 <20111208024357.GB5344@truffala.fritz.box>
	 <1323325390.24340.81.camel@bling.home>
	 <20111208065216.GA9107@truffala.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 17:52 +1100, David Gibson wrote:
> On Wed, Dec 07, 2011 at 11:23:10PM -0700, Alex Williamson wrote:
> > On Thu, 2011-12-08 at 13:43 +1100, David Gibson wrote:
> > > On Wed, Dec 07, 2011 at 12:45:20PM -0700, Alex Williamson wrote:
> > > > So the next problem is that while the group is the minimum granularity
> > > > for the iommu, it's not necessarily the desired granularity.  iommus
> > > > like VT-d have per PCI BDF context entries that can point to shared page
> > > > tables.  On such systems we also typically have singleton isolation
> > > > groups, so when multiple devices are used by a single user, we have a
> > > > lot of duplication in time and space.  VFIO handles this by allowing
> > > > groups to be "merged".  When this happens, the merged groups point to
> > > > the same iommu context.  I'm not sure what the plan is with isolation
> > > > groups, but we need some way to reduce that overhead.
> > > 
> > > Right.  So, again, I intend that mutiple groups can go into one
> > > domain.  Not entirely sure of the interface yet.  One I had in mind
> > > was to borrow the vfio1 interface, so you open a /dev/vfio (each open
> > > gives a new instance).  Then you do an "addgroup" ioctl which adds a
> > > group to the domain.  You can do that multiple times, then start using
> > > the domain.
> > 
> > This also revisits one of the primary problems of vfio1, the dependency
> > on a privileged uiommu domain creation interface.  Assigning a user
> > ownership of a group should be a privileged operation.  If a privileged
> > user needs to open /dev/vfio, add groups, then drop privileges and hand
> > the open file descriptor to an unprivileged user, the interface becomes
> > much harder to use.  "Hot merging" becomes impossible.
> 
> No, I was assuming that "permission to detach" could be handed out to
> a user before this step.  uid/gid/mode attributes in sysfs would
> suffice, though there might be better ways.

Wow.  So you effectively get:

# chown user:user /sys/isolation/$GROUP
$ fd = open(/dev/vfio)
$ ioctl(fd, addgroup, $GROUP)
  ^^^^ this is where the actual detach occurs?

And vfio has to find the $GROUP object, figure out where /sys is mounted
on this system, construct a path to $SYS/isolation/$GROUP, and check the
file access before calling the isolation group detach API.

Then later...

$ ioctl(fd, delgroup, $GROUP)

But a reattach can't occur here or we've just given the user the power
to cause the DoS, or at least system chaos, I described earlier.  So
then the admin later has to:

# chown root:root /sys/isolation/$GROUP
# echo 0 > /sys/ioslation/$GROUP/detached

Under the covers, "addgroup" would require vfio to a) "detach" the
group, b) put the devices in an iommu domain.  If we're dealing with
multiple group, b) can be rejected by the iommu driver, at which point
vfio then sends a "reattach" to the isolation API (but that can't
actually do much, as noted above), the user then opens a new instance
of /dev/vfio and tries an "addgroup" there.

Also note that there was a request to make it possible to get multiple
file descriptors to the same group/device/iommu from different threads.
I don't see how that's possible here.

And this is somehow better than the perceived dis-symmetry that annoys
you in vfio?  I'm getting a strong not-invented-here vibe and I'm not
sure you've internalized all the interactions that make vfio manage
groups the way it does.

Alex

