Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab0DAPly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:41:54 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:26968 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab0DAPlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:41:46 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAC9btEurR7Ht/2dsb2JhbACDEpgscZxviEOQV4ErgSqBQWsEgyM
X-IronPort-AV: E=Sophos;i="4.51,349,1267401600"; 
   d="scan'208";a="506934398"
From: Tom Lyon <pugs@lyon-about.com>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for non-privileged processes
Date: Thu, 1 Apr 2010 08:39:07 -0700
User-Agent: KMail/1.9.9
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201003311708.38961.pugs@lyon-about.com> <4BB462B5.1030402@redhat.com>
In-Reply-To: <4BB462B5.1030402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004010839.07451.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010 02:09:09 am Avi Kivity wrote:
> On 04/01/2010 03:08 AM, Tom Lyon wrote:
> > uio_pci_generic has previously been discussed on the KVM list, but this
> > patch has nothing to do with KVM, so it is also going to LKML.
>
> (needs to go to lkml even if it was for kvm)
>
> > The point of this patch is to beef up the uio_pci_generic driver so that
> > a non-privileged user process can run a user level driver for most PCIe
> > devices. This can only be safe if there is an IOMMU in the system with
> > per-device domains.  Privileged users (CAP_SYS_RAWIO) are allowed if
> > there is no IOMMU.
> >
> > Specifically, I seek to allow low-latency user level network drivers (non
> > tcp/ip) which directly access SR-IOV style virtual network adapters, for
> > use with packages such as OpenMPI.
> >
> > Key areas of change:
> > - ioctl extensions to allow registration and dma mapping of memory
> > regions, with lock accounting
> > - support for mmu notifier driven de-mapping
>
> Note that current iommus/devices don't support restart-on-fault dma, so
> userspace drivers will have to lock memory so that it is not swapped
> out.  I don't think this prevents page migration, though.
The driver provides a way to lock memory for DMA; the mmu notifier support is 
to catch things when the user accidentally frees locked pages.

> > - support for MSI and MSI-X interrupts (the intel 82599 VFs support only
> > MSI-X)
>
> How does a userspace program receive those interrupts?
Same as other UIO drivers - by read()ing an event counter.
