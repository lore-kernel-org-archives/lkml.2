Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010Ab1LPBkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 20:40:35 -0500
Received: from ozlabs.org ([203.10.76.45]:55860 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab1LPBkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 20:40:31 -0500
Date: Fri, 16 Dec 2011 12:40:26 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, joerg.roedel@amd.com,
        dwmw2@infradead.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com, rusty@rustcorp.com.au,
        iommu@lists.linux-foundation.org, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Device isolation infrastructure v2
Message-ID: <20111216014026.GA4921@truffala.fritz.box>
Mail-Followup-To: Alex Williamson <alex.williamson@redhat.com>,
	aik@ozlabs.ru, benh@kernel.crashing.org, joerg.roedel@amd.com,
	dwmw2@infradead.org, chrisw@redhat.com, agraf@suse.de,
	scottwood@freescale.com, B08248@freescale.com,
	rusty@rustcorp.com.au, iommu@lists.linux-foundation.org,
	qemu-devel@nongnu.org, linux-kernel@vger.kernel.org
References: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
 <1323972307.2437.19.camel@x201.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323972307.2437.19.camel@x201.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 11:05:07AM -0700, Alex Williamson wrote:
> On Thu, 2011-12-15 at 17:25 +1100, David Gibson wrote:
> > Here's the second spin of my preferred approach to handling grouping
> > of devices for safe assignment to guests.
> > 
> > Changes since v1:
> >  * Many name changes and file moves for improved consistency
> >  * Bugfixes and cleanups
> >  * The interface to the next layer up is considerably fleshed out,
> >    although it still needs work.
> >  * Example initialization of groups for p5ioc2 and p7ioc.
> > 
> > TODO:
> >  * Need sample initialization of groups for intel and/or amd iommus
> 
> I think this very well might imposed significant bloat for those
> implementations.  On POWER you typically don't have singleton groups,
> while it's the norm on x86.  I don't know that either intel or amd iommu
> code have existing structures that they can simply tack the group
> pointer to.

Actually, I think they can probably just use the group pointer in the
struct device.  Each PCI function will typically allocate a new group
and put the pointer in the struct device and no-where else.  Devices
hidden under bridges copy the pointer from the bridge parent instead.
I will have to check the unplug path to ensure we can manage the group
lifetime properly, of course.

>  Again, this is one of the reasons that I think the current
> vfio implementation is the right starting point.  We keep groups within
> vfio, imposing zero overhead for systems not making use of it and only
> require iommu drivers to implement a trivial function to opt-in.  As we
> start to make groups more pervasive in the dma layer, independent of
> userspace driver exposure, we can offload pieces to the core.  Starting
> with it in the core and hand waving some future use that we don't plan
> to implement right now seems like the wrong direction.

Well, I think we must agree to disagree here; I think treating groups
as identifiable objects is worthwhile.  That said, I am looking for
ways to whittle down the overhead when they're not in use.

> >  * Use of sysfs attributes to control group permission is probably a
> >    mistake.  Although it seems a bit odd, registering a chardev for
> >    each group is probably better, because perms can be set from udev
> >    rules, just like everything else.
> 
> I agree, this is a horrible mistake.  Reinventing file permissions via
> sysfs is bound to be broken and doesn't account for selinux permissions.
> Again, I know you don't like aspects of the vfio group management, but
> it gets this right imho.

Yeah.  I came up with this because I was trying to avoid registering a
device whose only purpose was to act as a permissioned "handle" on the
group.  But it is a better approach, despite that.  I just wanted to
send out the new patches for comment without waiting to do that
rework.

> >  * Need more details of what the binder structure will need to
> >    contain.
> >  * Handle complete removal of groups.
> >  * Clarify what will need to happen on the hot unplug path.
> 
> We're still also removing devices from the driver model, this means
> drivers like vfio need to re-implement a lot of the driver core for
> driving each individual device in the group,

Ah, so, that's a bit I've yet to flesh out.  The subtle distinction is
that we prevent driver _matching_ not driver _binding.  It's
intentionally still possible to explicitly bind drivers to devices in
the group, by bypassing the automatic match mechanism.

I'm intending that when a group is bound, the binder struct will
(optionally) specify a driver (or several, for different bus types)
which will be "force bound" to all the devices in the group.

> and as you indicate, it's
> unclear what happens in the hotplug path

It's clear enough in concept.  I just have to work out exactly where
we need to call d_i_dev_remove(), and whether we'll need some sort of
callback to the bridge / iommu code.

> and I wonder if things like
> suspend/resume will also require non-standard support.  I really prefer
> attaching individual bus drivers to devices using the standard
> bind/unbind mechanisms.  I have a hard time seeing how this is an
> improvement from vfio.  Thanks,
> 
> Alex
> 

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
