Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab1LUQqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:46:38 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:3437
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135Ab1LUQqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:46:36 -0500
X-SpamScore: -22
X-BigFish: VPS-22(zz179dN1432N98dKzz1202hz70kz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWKBXG-01-DLI-02
X-M-MSG: 
Date: Wed, 21 Dec 2011 17:46:27 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>, <aik@ozlabs.ru>,
        <benh@kernel.crashing.org>, <dwmw2@infradead.org>, <chrisw@redhat.com>,
        <agraf@suse.de>, <scottwood@freescale.com>, <B08248@freescale.com>,
        <rusty@rustcorp.com.au>, <iommu@lists.linux-foundation.org>,
        <qemu-devel@nongnu.org>, <linux-kernel@vger.kernel.org>,
        <joro@8bytes.org>
Subject: Re: [Qemu-devel] [RFC] Device isolation infrastructure v2
Message-ID: <20111221164626.GQ29877@amd.com>
References: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
 <1323972307.2437.19.camel@x201.home>
 <20111216145353.GA29877@amd.com>
 <20111219001125.GA30390@truffala.fritz.box>
 <20111219154156.GG29877@amd.com>
 <20111221033235.GA4537@truffala.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111221033235.GA4537@truffala.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 02:32:35PM +1100, David Gibson wrote:
> On Mon, Dec 19, 2011 at 04:41:56PM +0100, Joerg Roedel wrote:
> > For 1) I think the current solution with the iommu_group file is fine.
> > It is somewhat expensive for user-space to figure out the per-group
> > device-sets, but that is a one-time effort so it doesn't really matter.
> > Probably we can rename 'iommu_group' to 'isolation_group' or
> > something.
> 
> Hrm.  Alex's group code also provides no in-kernel way to enumerate a
> group, short of walking every device in the system.  And it provides
> no way to attach information to a group.  It just seems foolish to me
> to have this concept without some kind of in-kernel handle on it, and
> if you're managing the in-kernel representation you might as well
> expose it to userspace there as well.

I agree that we should have an in-kernel handle for groups in the
future. This would be generic code the iommu-drivers can use to manage
their groups and where the pci-quirks can chime in. But we don't need
that immediatly, lets add this incrementally.
>From the implementation side I would prefer to introduce a dev->iommu
pointer (a generalization of the dev->archdata->iommu pointer we have on
x86, ia64 and arm already) and link this to the handle of the group.
This makes it also easy to walk all devices in a group within the
kernel.
I still disagree that we need to expose this to user-space in any other
way then what we currently have. It is just not worth the effort when it
is used that rarely. It is perfectly fine if user-space has to scan the
sysfs device tree to build its own group data structures.

> > Regarding 2), I think providing user-space a way to unbind groups of
> > devices from their drivers is a horrible idea.
> 
> Well, I'm not wed to unbinding all the drivers at once.  But what I
> *do* think is essential is that we can atomically switch off automatic
> driver matching for the whole group.  Without that nothing really
> stops a driver reattaching to the things you've unbound, so you end up
> bailing a leakey boat.

Okay, makes sense for hotadd to have this. What we need from the
driver-core here is a method to disable driver probing for a device. The
iommu-layer can then call this method on the DEVICE_ADD notifier if
required. This also can be done incrementally to the current VFIO
implementation.

> Ok, that's not the usage model I had in mind.  What I'm thinking here
> is that the admin removes groups that will be used in guests from the
> host kernel (probably via boot-time scripts).  The guests will pick
> them up later, so that when a guest quits then restarts, we don't have
> devices appearing transiently in the host.

This 'remove-groups-from-the-host' thing can easily be done (also at
boot time) by just binding the devices in question to the VFIO driver.
And the devices can stay with VFIO for the lifetime of the system (or
until the host want to make use of it). I don't think we need any
additional logic for that.

> > For the remaining two questions I think the concept of a default-domain
> > is helpful.  The default-domain is a per-group domain which is created
> > by the iommu-driver at initialization time. It is the domain each device
> > is assigned to when it is not assigned to any other domain (which means
> > that each device/group is always attached to a domain). The default
> > domain will be used by the DMA-API layer. This implicitly means, that a
> > device which is not in the default-domain can't be used with the
> > dma-api. The dma_supported() function will return false for those
> > devices.
> 
> But.. by definition every device in the group must belong to the same
> domain.  So how is this "default domain" in any way different from
> "current domain".

The default domain is created by the iommu-drivers for all groups it
finds on the system and the devices are automatically assigned to it at
iommu-driver initialization time. This domain will be used for mapping
dma-api calls.
The "current domain" on the other side can also be a domain created by
VFIO (or KVM as it is today) for mapping the device dma space into a
guest.

> The domain_{attach,detach} functions absolutely should be group based
> not device based.  That's what it means to be a group.

I disagree with that. This would force all iommu-drivers that have no
group-concept (basically all current ARM iommu implementations) to work
on groups too. That makes the iommu-api much harder to use.

We could do instead:

	1) Force users of the iommu-api to bind each device in the group
	   individually.
	2) Attach all devices in the group automatically to the same
	   domain if a single device is attached to it.

I have no strong opinion which way we go, but have a slight favour for
way 2. To make it harder to mis-use we can force that way 2 only works
if the group is in its default-domain and there are no pending
dma-allocations.

> > Question 4) is also solved with the default-domain concept. A hot-added
> > device is put in the domain of its group automatically.
> 
> Well, of course it is.  A group can only have one domain.  That's what
> being a group means.
> 
> > If the group is
> > owned by VFIO and another driver attaches to the device dma_supported
> > will return false and initialization will fail.
> 
> By the time dma_supported is checked the driver could have already
> touched the device.  That's way too late.

Okay, I agree with that, dma_supported is probably not sufficient. But
we can use the method to disable driver-probing instead.

> > Well, the iommu-api was designed for amd-vi and vt-d. But its concepts
> > turn out to be more general and by no way x86-centric anymore.
> 
> It's improving, but there are still plenty of x86isms there.

Hmm, I don't buy that. What x86isms do you mean? And why there are
'plenty'? The iommu-api works on two central concepts: domains and
devices. A domain is an abstraction for an address-space, which, by
definition, every IOMMU hardware provides. And devices are also not a
very x86-centric concept ;)
The concept that a domain can spread multiple devices (or even groups)
can be seen as x86-originated. But so far no non-x86 IOMMU
implementation we have in drivers/iommu has a big problem with that.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

