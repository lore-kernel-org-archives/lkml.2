Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab2AJSgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:36:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab2AJSgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:36:14 -0500
Message-ID: <1326220554.1605.107.camel@bling.home>
Subject: Re: [PATCH 0/5] VFIO core framework
From: Alex Williamson <alex.williamson@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: anthony.perard@citrix.com, chrisw@sous-sol.org, aik@ozlabs.ru,
        david@gibson.dropbear.id.au, joerg.roedel@amd.com, agraf@suse.de,
        benve@cisco.com, aafabbri@cisco.com, B08248@freescale.com,
        B07421@freescale.com, avi@redhat.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 10 Jan 2012 11:35:54 -0700
In-Reply-To: <20120110162631.GB22499@phenom.dumpdata.com>
References: <20111221213019.27028.26890.stgit@bling.home>
	 <20120110162631.GB22499@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-10 at 11:26 -0500, Konrad Rzeszutek Wilk wrote:
> On Wed, Dec 21, 2011 at 02:42:02PM -0700, Alex Williamson wrote:
> > This series includes the core framework for the VFIO driver.
> > VFIO is a userspace driver interface meant to replace both the
> > KVM device assignment code as well as interfaces like UIO.  Please
> > see patch 1/5 for a complete description of VFIO, what it can do,
> > and how it's designed.
> > 
> > This version and the VFIO PCI bus driver, for exposing PCI devices
> > through VFIO, can be found here:
> > 
> > git://github.com/awilliam/linux-vfio.git vfio-next-20111221
> > 
> > A development version of qemu which includes a full working
> > vfio-pci driver, indepdendent of KVM support, can be found here:
> > 
> > git://github.com/awilliam/qemu-vfio.git vfio-ng
> > 
> > Thanks,
> 
> Alex,
> 
> So I took a look at the patchset with two different things in mind this time:
>  - What if you do not need to do any IRQ ack/de-ack etc in the host all of that
>    is done in the guest (say you have an actual IOAPIC in the guest that is
>    _not_ managed by QEMU).
>  - What would be required to make this work with a different hypervisor - say Xen.
> 
> And the conclusions I came to that it would require some surgery - especially
> as some of the IRQ, irqfs, etc code support is not required per say.
> 
> To me it seems to get this working with Xen (or perhaps with the Power machines
> as well, as their hypervisor is similar to Xen in architecture?) we would need at
> least two extra pieces of Linux kernel code: 
> - Xen IOMMU, which really is just doing a whole bunch of xc_domain_memory_mapping
>   the user-space iova calls. For the normal PCI devices operations it would just
>   offload them to the existing DMA API.
> - Xen VFIO PCI. Or at least make the VFIO PCI (in your vfio-next-20111221 branch)
>   driver allow some abstraction. There are certain things we might done via alternate
>   operations. Such as the interrupt handling - where we "bind" the IRQ to an event
>   channel or make a hypercall to program the guest' MSI vectors. Perhaps there can
>   be an "platform-specific" part of it.

Sure, I've envisioned that we'll have multiple iommu interfaces.  We'll
need build-time and run-time selection.  I haven't implemented that yet
since the iommu requirements are still developing.  Likewise, a
vfio-xen-pci module is possible or we can look at whether we make the
vfio-pci code too ugly by incorporating a dual-mode into that.

> In the userland:
>  - In QEMU VFIO, make the interrupt part optional for certain parts (like we don't
>    expect an IRQ to happen in the host).

Or can it be handled by vfio-xen-pci, which enables event channels
through to xen?  It's possible the GET_IRQ_INFO ioctls could report a
flag indicating the type of notification available (eventfds being the
initial option) and SET_IRQ_EVENTFDS could be generalized to take an
array of structs other than eventfds.  For the non-Xen case, eventfds
seem to provide us with the most flexibility since we can either connect
them to userspace or just have userspace be the agent that connects the
eventfd to an irqfd in another module.  See the (outdated) version of
qemu-kvm vfio in this tree for an example (look for QEMU_KVM_BUILD):
https://github.com/awilliam/qemu-kvm-vfio/blob/vfio/hw/vfio.c

> I am curious to see how the Power folks have to deal with this? Perhaps the requirement
> to write an PV IOMMU is not something they need to write?
> 
> In terms of this patchset, the "big" thing for me is that it moves the usual mechanism
> of "unbind"/"bind" of using the SysFS to be done via ioctls. I get the reasoning for it
> - cannot guarantee any locking, but doing it all in ioctls instead of configfs or sysfs
> seems odd. But perhaps that is just me having gotten use to doing it in sysfs/configfs.
> Certainly it makes it easier to program in QEMU/libvirt. And ultimately that is going
> to be user for 99% of this.

Can you be more specific about which ioctl part you're referring to?  We
bind/unbind each device to vfio-pci via the normal sysfs driver
interfaces.  Userspace binds itself to a group via ioctls, but that's
because neither configfs or sysfs allow ioctl and I don't think it's
possible to implement an ioctl-free vfio.  Trying to implement vfio
across both configfs and chardev presents issues with ownership.

> The requirement of the VFIO PCI driver to deal with all of the nasty work-arounds for
> devices is nice. I do like the seperation - where this driver (VFIO core) deal
> with _just_ the user facing portion. And the backends (just one right now - VFIO PCI)
> gets to play with all the real hardware details.

Yep, and the iommu layer is intended to be the same, but is maybe not
quite as evolved yet.

> So curious if your perception of this is similar to mine or if I had missed
> something?

It seems like we have options for dealing with it via separate or
modified iommu/device vfio modules and some tweaks to some of the
ioctls.  Maybe I'm oversimplifying the xen requirements?  Thanks for the
review and comments,

Alex

