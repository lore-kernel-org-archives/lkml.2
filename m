Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341Ab0D3RGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:06:52 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:43852 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758412Ab0D3RGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:06:20 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAZ82UurRN+K/2dsb2JhbACdEnGjKpl0hRAEgzw
X-IronPort-AV: E=Sophos;i="4.52,296,1270425600"; 
   d="scan'208";a="190427189"
From: Tom Lyon <pugs@lyon-about.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH V3] drivers/uio/uio_pci_generic.c: allow access for non-privileged processes
Date: Thu, 29 Apr 2010 12:29:40 -0700
User-Agent: KMail/1.9.9
Cc: hjk@linutronix.de, gregkh@suse.de, chrisw@sous-sol.org, joro@8bytes.org,
       avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4bccd3af.M/eSrn9OV22zg0A8%pugs@cisco.com> <20100421093849.GB30855@redhat.com>
In-Reply-To: <20100421093849.GB30855@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004291229.40918.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael, et al - sorry for the delay, but I've been digesting the comments and researching new approaches.

I think the plan for V4 will be to take things entirely out of the UIO framework, and instead have a driver which supports user mode use of "well-behaved" PCI devices. I would like to use read and write to support access to memory regions, IO regions,  or PCI config space. Config space is a bitch because not everything is safe to read or write, but I've come up with a table driven approach which can be run-time extended for non-compliant devices (under root control) which could then enable non-privileged users. For instance, OHCI 1394 devices use a dword in config space which is not formatted as a PCI capability, root can use sysfs to enable access:
	echo <offset> <readbits> <writebits> > /sys/dev/pci/devices/xxxx:xx:xx.x/<yyy>/config_permit


A "well-behaved" PCI device must have memory BARs >= 4K for mmaping, must have separate memory space for MSI-X that does not need mmaping
by the user driver, must support the PCI 2.3 interrupt masking, and must not go totally crazy with PCI config space (tg3 is real ugly, e1000 is fine).

Again, my primary usage model is for direct user-level access to network devices, not for virtualization, but I think both will work.

So, I will go outside UIO because:
1 - it doesn't allow reads and writes to sub-drivers, just irqcontrol
2 - it doesn't have ioctls
3 - it has its own interrupt model which doesn't use eventfds
4 - it's ugly doing the new stuff and maintaining backwards compat.

I hereby solicit comments on the name and location for the new driver.

Michael - some of your comments below imply you didn't look at the companion changes to uio.c, which had the eventfd interrupts and effectively the same iommu handling - but see my inline comments below.

On Wednesday 21 April 2010 02:38:49 am Michael S. Tsirkin wrote:
> On Mon, Apr 19, 2010 at 03:05:35PM -0700, Tom Lyon wrote:
> > 
> > These are changes to uio_pci_generic.c to allow better use of the driver by
> > non-privileged processes.
> > 1. Add back old code which allowed interrupt re-enablement through uio fd.
> > 2. Translate PCI bards to uio mmap regions, to allow mmap through uio fd.
> 
> Since it's common for drivers to need configuration cycles
> for device control, the above 2 are not sufficient for generic devices.
> And if you fix the above, you won't need irqcontrol,
> which IMO we are better off saving for stuff like eventfd mapping.
I will handle config access for well-behaved devices.

> 
> Also - this modifies a kernel/userspace interface in a way
> that makes an operation that was always safe previously
> potentially unsafe.
Not sure what you meant, but probably irrelevant in new scheme.
> 
> Also, BAR regions could be less than 1 page in size,
> mapping these to unpriveledged process is a security problem.
Agreed, no mmaping, just r/w.

> Also, for a generic driver, we likely need write combining
> support in the interface.
Given that many system platforms don't have it, doesn't seem like a big deal.
But I'll look into it.

> Also, io space often can not be mmaped. We need read/write
> for that.
Agreed.

> 
> > 3. Allow devices which support MSI or MSI-X, but not IRQ.
> 
> If the device supports MSI or MSI-X, it can perform
> PCI writes upstream, and MSI-X vectors are controlled
> through memory. So with MSI-X + mmap to an unpriveledged
> process you can easily cause the device to modify any memory.
Yes, will "virtualize" this in the driver. User level will not be allowed to
mmap real MSI-X region (if MSI-X in use); MSI config writes will be intercepted.
>
> With MSI it's hard to be sure, maybe some devices might make guarantees
> not to do writes except for MSI, but there's no generic way to declare
> that: bus master needs to be enabled for MSI to work, and once bus
> master is enabled, nothing seems to prevent the device from corrupting
> host memory.
The code already requires iommu protection for masters, I will make sure this
includes MSI and MSI-X devices.

As an aside, the IOMMU is supposed to be able to do interrupt translation also,
but the format for vectors changes, so it doesn't really help with virtualization.

> So the patch doesn't look like generic enough or safe enough
> for users I have in mind (virtualization). What users/devices
> do you have in mind?
Non-virt, just new user level drivers for special cases.

> For virtualization, I've been thinking about unpriviledged access and
> msi as well, and here's a plan I thought might work:
> 
> - add a uio_iommu character device that controls an iommu domain
> - uio_iommu would make sure iommu is programmed in a safe way
> - use irqcontrol to bind pci device to iommu domain
> - allow config cycles through uio fd, but
>   force bus master to 0 unless device is bound to a domain
> - for sub-page regions, and io, we can't allow mmap to an unpriveledged
>   process. extend irqcontrol to allow read/write and range-check the
>   operations
> - for msi/msix, drivers use multiple vectors. One idea is to
>   map them by binding an eventfd to a vector. This approach has
>   the advantage that in virtualization space, kvm already
>   can consume eventfd descriptors.
I think I can cover all these, slightly differently, in V4.
> 
Thank for your comments.
