Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab1LUDcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 22:32:45 -0500
Received: from ozlabs.org ([203.10.76.45]:45415 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab1LUDcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 22:32:42 -0500
Date: Wed, 21 Dec 2011 14:32:35 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, aik@ozlabs.ru,
        benh@kernel.crashing.org, dwmw2@infradead.org, chrisw@redhat.com,
        agraf@suse.de, scottwood@freescale.com, B08248@freescale.com,
        rusty@rustcorp.com.au, iommu@lists.linux-foundation.org,
        qemu-devel@nongnu.org, linux-kernel@vger.kernel.org, joro@8bytes.org
Subject: Re: [Qemu-devel] [RFC] Device isolation infrastructure v2
Message-ID: <20111221033235.GA4537@truffala.fritz.box>
Mail-Followup-To: Joerg Roedel <joerg.roedel@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>, aik@ozlabs.ru,
	benh@kernel.crashing.org, dwmw2@infradead.org, chrisw@redhat.com,
	agraf@suse.de, scottwood@freescale.com, B08248@freescale.com,
	rusty@rustcorp.com.au, iommu@lists.linux-foundation.org,
	qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
	joro@8bytes.org
References: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
 <1323972307.2437.19.camel@x201.home>
 <20111216145353.GA29877@amd.com>
 <20111219001125.GA30390@truffala.fritz.box>
 <20111219154156.GG29877@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219154156.GG29877@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 04:41:56PM +0100, Joerg Roedel wrote:
> On Mon, Dec 19, 2011 at 11:11:25AM +1100, David Gibson wrote:
> > Well.. that's not where it is in Alex's code either.  The iommu layer
> > (to the extent that there is such a "layer") supplies the group info,
> > but the group management is in vfio, not the iommu layer.  With mine
> > it is in the driver core because the struct device seemed the logical
> > place for the group id.
> 
> Okay, seems we have different ideas of what the 'grouping code' is. I
> talked about the group enumeration code only. But group handling code is
> certainly important to some degree too. But before we argue about the
> right place of the code we should agree on the semantics such code
> should provide.
> 
> For me it is fine when the code is in VFIO for now, since VFIO is the
> only user at the moment. When more users pop up we can easily move it
> out to somewhere else. But the semantics influence the interface to
> user-space too, so it is more important now. It splits up into a number
> of sub problems:
> 
> 	1) How userspace detects the device<->group relationship?
> 	2) Do we want group-binding/unbinding to device drivers?
> 	3) Group attach/detach to iommu-domains?
> 	4) What to do with hot-added devices?
> 
> For 1) I think the current solution with the iommu_group file is fine.
> It is somewhat expensive for user-space to figure out the per-group
> device-sets, but that is a one-time effort so it doesn't really matter.
> Probably we can rename 'iommu_group' to 'isolation_group' or
> something.

Hrm.  Alex's group code also provides no in-kernel way to enumerate a
group, short of walking every device in the system.  And it provides
no way to attach information to a group.  It just seems foolish to me
to have this concept without some kind of in-kernel handle on it, and
if you're managing the in-kernel representation you might as well
expose it to userspace there as well.

> Regarding 2), I think providing user-space a way to unbind groups of
> devices from their drivers is a horrible idea.

Well, I'm not wed to unbinding all the drivers at once.  But what I
*do* think is essential is that we can atomically switch off automatic
driver matching for the whole group.  Without that nothing really
stops a driver reattaching to the things you've unbound, so you end up
bailing a leakey boat.

> It makes it too easy for
> the user to shoot himself in the foot. For example when the user wants
> to assign a network card to a guest, but that card is in the same group
> as the GPU and the screen wents blank when the guest is started.
> Requiring devices to be unbound one-by-one is better because this way
> the user always needs to know what he is doing.

Ok, that's not the usage model I had in mind.  What I'm thinking here
is that the admin removes groups that will be used in guests from the
host kernel (probably via boot-time scripts).  The guests will pick
them up later, so that when a guest quits then restarts, we don't have
devices appearing transiently in the host.

> For the remaining two questions I think the concept of a default-domain
> is helpful.  The default-domain is a per-group domain which is created
> by the iommu-driver at initialization time. It is the domain each device
> is assigned to when it is not assigned to any other domain (which means
> that each device/group is always attached to a domain). The default
> domain will be used by the DMA-API layer. This implicitly means, that a
> device which is not in the default-domain can't be used with the
> dma-api. The dma_supported() function will return false for those
> devices.

But.. by definition every device in the group must belong to the same
domain.  So how is this "default domain" in any way different from
"current domain".

In addition making dma_supported() doesn't seem like a strong enough
constraint.  With this a kernel driver which does not use DMA, or
which is initializing and hasn't yet hit a dma_supported() check could
be accessing a device which is in the same group as something a guest
is simultaneously accessing.  Since there's no DMA (on the kernel
side) we can't get DMA conflicts but there are other forms of
isolation that the group could be enforcing which would make that
unsafe. e.g. irqs from the two devices can't be reliably separated,
debug registers on one device let config space be altered to move it
on top of the other, one can cause a bus error which will mess up the
other.

> So what does this mean for point 3? I think we can implement attaching
> and detaching groups in the iommu-api. This interface is not exposed to
> userspace and can help VFIO and possible future users. Semantic is, that
> domain_attach_group() only works when all devices in the group are in
> their default domain and domain_detach_group() puts them back into the
> default domain.

The domain_{attach,detach} functions absolutely should be group based
not device based.  That's what it means to be a group.

> Question 4) is also solved with the default-domain concept. A hot-added
> device is put in the domain of its group automatically.

Well, of course it is.  A group can only have one domain.  That's what
being a group means.

> If the group is
> owned by VFIO and another driver attaches to the device dma_supported
> will return false and initialization will fail.

By the time dma_supported is checked the driver could have already
touched the device.  That's way too late.

> > Right, so, the other problem is that a well boundaried "iommu-driver'
> > is something that only exists on x86 at present, and the "iommu api"
> > is riddled with x86-centric thinking.  Or more accurately, design
> > based on how the current intel and amd iommus work.  On systems like
> > POWER, use of the iommu is not optional - it's built into the PCI host
> > bridge and must be initialized when the bridge is probed, much earlier
> > than iommu driver initialization on x86.  They have no inbuilt concept
> > of domains (though we could fake in software in some circumstances).
> 
> Well, the iommu-api was designed for amd-vi and vt-d. But its concepts
> turn out to be more general and by no way x86-centric anymore.

It's improving, but there are still plenty of x86isms there.

> We
> support a couple of ARM platforms too for example. More to come. With
> small extensions to the API we will also support GART-like IOMMUs in the
> future.
> For your hardware the domain-concept will work too. In terms of the
> iommu-api a domain is nothing more than an address space. As far as I
> understand there is a 1-1 mapping between a hardware iommu and a domain
> in your case. The easiest solution then is to share the datastructures
> which describe the address space to the hardware between all iommus in a
> particular domain.
> 
> 
> Regards,
> 
> 	Joerg
> 

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
