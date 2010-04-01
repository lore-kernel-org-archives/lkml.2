Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab0DAQFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:05:25 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:3533 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697Ab0DAQFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:05:20 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAM5gtEurRN+J/2dsb2JhbACbPnGcbZkaglWCLASDIw
X-IronPort-AV: E=Sophos;i="4.51,349,1267401600"; 
   d="scan'208";a="506946411"
From: Tom Lyon <pugs@lyon-about.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for non-privileged processes
Date: Thu, 1 Apr 2010 09:02:41 -0700
User-Agent: KMail/1.9.9
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201003311708.38961.pugs@lyon-about.com> <20100401142504.GA6338@redhat.com>
In-Reply-To: <20100401142504.GA6338@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004010902.42002.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010 07:25:04 am Michael S. Tsirkin wrote:
> On Wed, Mar 31, 2010 at 05:08:38PM -0700, Tom Lyon wrote:
> > uio_pci_generic has previously been discussed on the KVM list, but this
> > patch has nothing to do with KVM, so it is also going to LKML.
> >
> > The point of this patch is to beef up the uio_pci_generic driver so that
> > a non-privileged user process can run a user level driver for most PCIe
> > devices. This can only be safe if there is an IOMMU in the system with
> > per-device domains.
>
> Why? Per-guest domain should be safe enough.
I'm not sure what 'per-guest' means in an ordinary process context.
>
> >  Privileged users (CAP_SYS_RAWIO) are allowed if there is
> > no IOMMU.
>
> qemu does not support it, I doubt this last option is worth having.
This is extremely useful in non IOMMU systems - again, we're talking ordinary 
processes, nothing to do with VMs. As long as the program can be trusted, 
e.g., in embedded apps.

>
> > Specifically, I seek to allow low-latency user level network drivers (non
> > tcp/ip) which directly access SR-IOV style virtual network adapters, for
> > use with packages such as OpenMPI.
> >
> > Key areas of change:
> > - ioctl extensions to allow registration and dma mapping of memory
> > regions, with lock accounting
> > - support for mmu notifier driven de-mapping
> > - support for MSI and MSI-X interrupts (the intel 82599 VFs support only
> > MSI-X)
> > - allowing interrupt enabling and device register mapping all
> > through /dev/uio* so that  permissions may be granted just by chmod
> > on /dev/uio*
>
> For non-priveledged users, we need a way to enforce that
> device is bound to an iommu.
Right now I just use iommu_found - assuming that if we have one, it is in use. 
Something better would be nice.

> Further, locking really needs to be scoped with iommu domain existance
> and with iommu mappings: as long as a page is mapped in iommu,
> it must be locked. This patch does not seem to enforce that.
Sure it does. The DMA API - get_user_pages and dma_map_sg lock pages into the 
MMU and the IOMMU. The MMU notifier unlocks if the user forgets to do it 
explicitly.

> Also note that what we really want is a single iommu domain per guest,
> not per device.
For my networking applications, I will need the ability to talk to multiple 
devices on potentially separate IOMMUs. What would per-guest mean then?
>

> For this reason, I think we should address the problem somwwhat
> differently:
> - Create a character device to represent the iommu
> - This device will handle memory locking etc
> - Allow binding this device to iommu
> - Allow other operations only after iommu is bound
There are still per-device issues with locking - in particular the size of the 
device's DMA address space. The DMA API already handles this - why not use 
it? It would be nice to have a way to test whether a device is truly covered 
by an IOMMU, but today it appears that if an IOMMU exists, then it covers all 
devices (at least as far as I can see for x86).




