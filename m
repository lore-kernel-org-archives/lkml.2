Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653Ab0DAQow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:44:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758546Ab0DAQol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:44:41 -0400
Date: Thu, 1 Apr 2010 17:25:04 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tom Lyon <pugs@lyon-about.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for
	non-privileged processes
Message-ID: <20100401142504.GA6338@redhat.com>
References: <201003311708.38961.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003311708.38961.pugs@lyon-about.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 05:08:38PM -0700, Tom Lyon wrote:
> uio_pci_generic has previously been discussed on the KVM list, but this patch 
> has nothing to do with KVM, so it is also going to LKML.
> 
> The point of this patch is to beef up the uio_pci_generic driver so that a 
> non-privileged user process can run a user level driver for most PCIe 
> devices. This can only be safe if there is an IOMMU in the system with 
> per-device domains.

Why? Per-guest domain should be safe enough.

>  Privileged users (CAP_SYS_RAWIO) are allowed if there is 
> no IOMMU.

qemu does not support it, I doubt this last option is worth having.

> Specifically, I seek to allow low-latency user level network drivers (non 
> tcp/ip) which directly access SR-IOV style virtual network adapters, for use 
> with packages such as OpenMPI.
> 
> Key areas of change:
> - ioctl extensions to allow registration and dma mapping of memory regions, 
> with lock accounting
> - support for mmu notifier driven de-mapping
> - support for MSI and MSI-X interrupts (the intel 82599 VFs support only 
> MSI-X)
> - allowing interrupt enabling and device register mapping all 
> through /dev/uio* so that  permissions may be granted just by chmod 
> on /dev/uio*

For non-priveledged users, we need a way to enforce that
device is bound to an iommu.

Further, locking really needs to be scoped with iommu domain existance
and with iommu mappings: as long as a page is mapped in iommu,
it must be locked. This patch does not seem to enforce that.

Also note that what we really want is a single iommu domain per guest,
not per device.

For this reason, I think we should address the problem somwwhat
differently:
- Create a character device to represent the iommu
- This device will handle memory locking etc
- Allow binding this device to iommu
- Allow other operations only after iommu is bound

Thanks!

-- 
MST
