Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab1LIDCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 22:02:16 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:43693 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1LIDCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 22:02:15 -0500
Date: Fri, 9 Dec 2011 14:00:34 +1100
From: David Gibson <dwg@au1.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, aik@au1.ibm.com,
        linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com,
        benh@kernel.crashing.org
Subject: Re: RFC: Device isolation infrastructure
Message-ID: <20111209030034.GF5750@truffala.fritz.box>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>, joerg.roedel@amd.com,
	dwmw2@infradead.org, iommu@lists.linux-foundation.org,
	aik@au1.ibm.com, linux-kernel@vger.kernel.org, chrisw@redhat.com,
	agraf@suse.de, scottwood@freescale.com, B08248@freescale.com,
	benh@kernel.crashing.org
References: <20111207035816.GC7631@truffala.fritz.box>
 <1323240402.2182.241.camel@bling.home>
 <20111207142201.GA5696@truffala.fritz.box>
 <1323287120.15059.63.camel@bling.home>
 <20111208024357.GB5344@truffala.fritz.box>
 <1323325390.24340.81.camel@bling.home>
 <20111208065216.GA9107@truffala.fritz.box>
 <1323354505.24340.111.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323354505.24340.111.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11120817-5140-0000-0000-000000654ECC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 07:28:25AM -0700, Alex Williamson wrote:
> On Thu, 2011-12-08 at 17:52 +1100, David Gibson wrote:
> > On Wed, Dec 07, 2011 at 11:23:10PM -0700, Alex Williamson wrote:
> > > On Thu, 2011-12-08 at 13:43 +1100, David Gibson wrote:
> > > > On Wed, Dec 07, 2011 at 12:45:20PM -0700, Alex Williamson wrote:
> > > > > So the next problem is that while the group is the minimum granularity
> > > > > for the iommu, it's not necessarily the desired granularity.  iommus
> > > > > like VT-d have per PCI BDF context entries that can point to shared page
> > > > > tables.  On such systems we also typically have singleton isolation
> > > > > groups, so when multiple devices are used by a single user, we have a
> > > > > lot of duplication in time and space.  VFIO handles this by allowing
> > > > > groups to be "merged".  When this happens, the merged groups point to
> > > > > the same iommu context.  I'm not sure what the plan is with isolation
> > > > > groups, but we need some way to reduce that overhead.
> > > > 
> > > > Right.  So, again, I intend that mutiple groups can go into one
> > > > domain.  Not entirely sure of the interface yet.  One I had in mind
> > > > was to borrow the vfio1 interface, so you open a /dev/vfio (each open
> > > > gives a new instance).  Then you do an "addgroup" ioctl which adds a
> > > > group to the domain.  You can do that multiple times, then start using
> > > > the domain.
> > > 
> > > This also revisits one of the primary problems of vfio1, the dependency
> > > on a privileged uiommu domain creation interface.  Assigning a user
> > > ownership of a group should be a privileged operation.  If a privileged
> > > user needs to open /dev/vfio, add groups, then drop privileges and hand
> > > the open file descriptor to an unprivileged user, the interface becomes
> > > much harder to use.  "Hot merging" becomes impossible.
> > 
> > No, I was assuming that "permission to detach" could be handed out to
> > a user before this step.  uid/gid/mode attributes in sysfs would
> > suffice, though there might be better ways.
> 
> Wow.  So you effectively get:
> 
> # chown user:user /sys/isolation/$GROUP

I was thinking more /sys/isolation/$GROUP/{uid,gid,mode} properties,
because I'm not sure you can implement chown simply in sysfs, but,
whatever.

> $ fd = open(/dev/vfio)
> $ ioctl(fd, addgroup, $GROUP)
>   ^^^^ this is where the actual detach occurs?
> 
> And vfio has to find the $GROUP object,

That's easy.

> figure out where /sys is mounted
> on this system,

a) /sys is always at /sys (see Documentation/sysfs-tules.txt

b) we don't need that anyway.  vfio can use use an in-kernel interface
to grab a handle on the group, it doesn't need to trawl through the
filesystem.


> construct a path to $SYS/isolation/$GROUP, and check the
> file access before calling the isolation group detach API.

Well, no, because the perms would just be in struct isolation_group,
and we'd have a helper function that detaches iff current has the
relevant permission.

> Then later...
> 
> $ ioctl(fd, delgroup, $GROUP)
> 
> But a reattach can't occur here or we've just given the user the power
> to cause the DoS, or at least system chaos, I described earlier.  So
> then the admin later has to:

I think you overestimate this "chaos".  But this is why I'm
considering an alternate approach where the group is detached, then
"meta-bound" as separate steps.

> 
> # chown root:root /sys/isolation/$GROUP
> # echo 0 > /sys/ioslation/$GROUP/detached

Well, if you want to give it back to normal drivers.  More usually, I
expect you'd detach the group at boot, and when the first guest using
it dies, it sits in limbo until the next guest (or more likely the
same guest, restarted) claims it.

> Under the covers, "addgroup" would require vfio to a) "detach" the
> group,

One function call.

> b) put the devices in an iommu domain.  If we're dealing with
> multiple group, 

Well, it has to do that anyway.

> b) can be rejected by the iommu driver, at which point
> vfio then sends a "reattach" to the isolation API (but that can't
> actually do much, as noted above),

Yes.  Again, one function call.

> the user then opens a new instance
> of /dev/vfio and tries an "addgroup" there.
> 
> Also note that there was a request to make it possible to get multiple
> file descriptors to the same group/device/iommu from different threads.
> I don't see how that's possible here.

dup(2)?  Although it depends exactly what the alternate handles are
needed for.  I can't actually see why you would need them at all, at
present.

> And this is somehow better than the perceived dis-symmetry that annoys
> you in vfio?  I'm getting a strong not-invented-here vibe and I'm not
> sure you've internalized all the interactions that make vfio manage
> groups the way it does.
> 
> Alex
> 

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

