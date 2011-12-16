Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab1LPGPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 01:15:07 -0500
Received: from ozlabs.org ([203.10.76.45]:44327 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab1LPGPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 01:15:03 -0500
Date: Fri, 16 Dec 2011 17:00:46 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, joerg.roedel@amd.com,
        dwmw2@infradead.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com, rusty@rustcorp.com.au,
        iommu@lists.linux-foundation.org, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Device isolation infrastructure v2
Message-ID: <20111216060046.GB4887@truffala.fritz.box>
Mail-Followup-To: Alex Williamson <alex.williamson@redhat.com>,
	aik@ozlabs.ru, benh@kernel.crashing.org, joerg.roedel@amd.com,
	dwmw2@infradead.org, chrisw@redhat.com, agraf@suse.de,
	scottwood@freescale.com, B08248@freescale.com,
	rusty@rustcorp.com.au, iommu@lists.linux-foundation.org,
	qemu-devel@nongnu.org, linux-kernel@vger.kernel.org
References: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
 <1323972307.2437.19.camel@x201.home>
 <20111216014026.GA4921@truffala.fritz.box>
 <1324010945.8225.36.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324010945.8225.36.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 09:49:05PM -0700, Alex Williamson wrote:
> On Fri, 2011-12-16 at 12:40 +1100, David Gibson wrote:
> > On Thu, Dec 15, 2011 at 11:05:07AM -0700, Alex Williamson wrote:
> > > On Thu, 2011-12-15 at 17:25 +1100, David Gibson wrote:
> > > > Here's the second spin of my preferred approach to handling grouping
> > > > of devices for safe assignment to guests.
> > > > 
> > > > Changes since v1:
> > > >  * Many name changes and file moves for improved consistency
> > > >  * Bugfixes and cleanups
> > > >  * The interface to the next layer up is considerably fleshed out,
> > > >    although it still needs work.
> > > >  * Example initialization of groups for p5ioc2 and p7ioc.
> > > > 
> > > > TODO:
> > > >  * Need sample initialization of groups for intel and/or amd iommus
> > > 
> > > I think this very well might imposed significant bloat for those
> > > implementations.  On POWER you typically don't have singleton groups,
> > > while it's the norm on x86.  I don't know that either intel or amd iommu
> > > code have existing structures that they can simply tack the group
> > > pointer to.
> > 
> > Actually, I think they can probably just use the group pointer in the
> > struct device.  Each PCI function will typically allocate a new group
> > and put the pointer in the struct device and no-where else.  Devices
> > hidden under bridges copy the pointer from the bridge parent instead.
> > I will have to check the unplug path to ensure we can manage the group
> > lifetime properly, of course.
> > 
> > >  Again, this is one of the reasons that I think the current
> > > vfio implementation is the right starting point.  We keep groups within
> > > vfio, imposing zero overhead for systems not making use of it and only
> > > require iommu drivers to implement a trivial function to opt-in.  As we
> > > start to make groups more pervasive in the dma layer, independent of
> > > userspace driver exposure, we can offload pieces to the core.  Starting
> > > with it in the core and hand waving some future use that we don't plan
> > > to implement right now seems like the wrong direction.
> > 
> > Well, I think we must agree to disagree here; I think treating groups
> > as identifiable objects is worthwhile.  That said, I am looking for
> > ways to whittle down the overhead when they're not in use.
> > 
> > > >  * Use of sysfs attributes to control group permission is probably a
> > > >    mistake.  Although it seems a bit odd, registering a chardev for
> > > >    each group is probably better, because perms can be set from udev
> > > >    rules, just like everything else.
> > > 
> > > I agree, this is a horrible mistake.  Reinventing file permissions via
> > > sysfs is bound to be broken and doesn't account for selinux permissions.
> > > Again, I know you don't like aspects of the vfio group management, but
> > > it gets this right imho.
> > 
> > Yeah.  I came up with this because I was trying to avoid registering a
> > device whose only purpose was to act as a permissioned "handle" on the
> > group.  But it is a better approach, despite that.  I just wanted to
> > send out the new patches for comment without waiting to do that
> > rework.
> 
> So we end up with a chardev created by the core, whose only purpose is
> setting the group access permissions for userspace usage, which only
> becomes useful with something like vfio?  It's an odd conflict that
> isolation groups would get involved with userspace permissions to access
> the group, but leave enforcement of isolation via iommu groups to the
> "binder" driver

Hm, perhaps.  I'll think about it.

> (where it seems like vfio is still going to need some
> kind of merge interface to share a domain between isolation groups).

That was always going to be the case, but I wish we could stop
thinking of it as the "merge" interface, since I think that term is
distorting thinking about how the interface works.

For example, I think opening a new domain, then adding / removing
groups provides a much cleaner model than "merging' groups without a
separate handle on the iommu domain we're building.

> Is this same chardev going to be a generic conduit for
> read/write/mmap/ioctl to the "binder" driver or does vfio need to create
> it's own chardev for that?

Right, I was thinking that the binder could supply its own fops or
something for the group chardev once the group is bound.

>  In the former case, are we ok with a chardev
> that has an entirely modular API behind it, or maybe you're planning to
> define some basic API infrastructure, in which case this starts smelling
> like implementing vfio in the core.

I think it can work, but I do need to look closer.

>  In the latter case (isolation
> chardev + vfio chardev) coordinating permissions sounds like a mess.

Absolutely.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
